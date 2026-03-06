# execution-beacon-fallback Chart Design

## Problem

`execution-beacon` runs a single execution + beacon node pair. When the local beacon is unavailable (crash, sync, maintenance), there is no failover — clients lose their beacon API connection.

The goal is a chart that keeps clients connected to a beacon API at all times by routing to a 3rd party provider (DrPC, QuickNode, etc.) when the local beacon is unhealthy.

## Why Not Dugtrio

Dugtrio was evaluated and rejected for this use case. It only implements round-robin scheduling across ready endpoints — when both local and 3rd party are healthy, traffic is split ~50/50. There is no primary-preference or backup concept. Dugtrio is appropriate for active-active load balancing across multiple local beacons, not for active-fallback.

## Solution

A new chart `execution-beacon-fallback` — a self-contained copy of `execution-beacon` with an HAProxy Deployment added as an active-fallback proxy in front of the beacon.

HAProxy is chosen because:
- Active HTTP health checks built into OSS version (no Plus license required)
- Native `backup` server directive — zero traffic to backup when primary is healthy
- Beacon nodes expose `/eth/v1/node/health` returning `200` (ready), `206` (syncing), `503` (not synced) — HAProxy `http-check expect status 200` correctly treats a syncing node as down

## Architecture

```
[clients]
         |
  [HAProxy Service :5052]    ClusterIP, external-facing
         |
  [HAProxy Deployment]
    GET /eth/v1/node/health  expect 200
         |
  primary:  http://<release>-beacon:<port>   in-cluster, always preferred
  backup:   <3rd-party HTTPS>                only when primary health check fails
         |
  [execution-beacon StatefulSet]
    execution container + beacon container
  [beacon Service]    ClusterIP, internal only
```

## Secret Injection

The 3rd party beacon URL (full HTTPS URL with embedded API key, e.g. `https://nd-xxx.p2pify.com/apikey`) is stored in a Kubernetes Secret managed externally (e.g. via InfisicalSecret CRD).

An init container on the HAProxy pod:
1. Reads `FALLBACK_BEACON_URL` from the secret via `envFrom.secretRef`
2. Parses it into `FALLBACK_HOST`, `FALLBACK_PORT`, `FALLBACK_PATH` using shell
3. Runs `envsubst` on the haproxy.cfg template (from ConfigMap) into an emptyDir volume
4. HAProxy main container reads the rendered config from the emptyDir

This follows the same pattern used in `drpc-nodecore` in this repo.

## Kubernetes Resources

| Resource | Description |
|---|---|
| StatefulSet | execution + beacon containers, copied from execution-beacon |
| Service `*-beacon` | ClusterIP, internal only — HAProxy to local beacon |
| Deployment `*-haproxy` | HAProxy proxy, conditionally created when `haproxy.enabled: true` |
| Service `*-haproxy` | ClusterIP, external-facing — clients connect here |
| ConfigMap `*-haproxy` | haproxy.cfg template with `${VAR}` placeholders |
| ServiceAccount | one per chart |
| ServiceMonitor | optional, Prometheus scraping of HAProxy stats |
| Ingress | optional, points to HAProxy service |

## haproxy.cfg Template

Stored in ConfigMap with `${VAR}` placeholders substituted at pod start by the init container:

```haproxy
global
    log stdout format raw local0
    maxconn 4096

defaults
    log global
    mode http
    option httplog
    option dontlognull
    timeout connect 5s
    timeout client  55s
    timeout server  55s

frontend beacon
    bind *:5052
    default_backend beacon_backend

backend beacon_backend
    option httpchk GET /eth/v1/node/health
    http-check expect status 200
    server local ${LOCAL_BEACON_HOST}:${LOCAL_BEACON_PORT} check inter ${CHECK_INTERVAL}ms fall ${CHECK_FALL} rise ${CHECK_RISE}
    server fallback ${FALLBACK_HOST}:${FALLBACK_PORT} ssl verify none check inter ${CHECK_INTERVAL}ms fall ${CHECK_FALL} rise ${CHECK_RISE} backup
```

Init container parses `FALLBACK_BEACON_URL=https://nd-xxx.p2pify.com/apikey` into:
- `FALLBACK_HOST` — hostname
- `FALLBACK_PORT` — port (default 443 for https, 80 for http)

`LOCAL_BEACON_HOST`, `LOCAL_BEACON_PORT`, `CHECK_INTERVAL`, `CHECK_FALL`, `CHECK_RISE` are injected directly from rendered Helm values (not from secrets).

## New Values

```yaml
haproxy:
  enabled: true

  image:
    repository: haproxy
    tag: "3.0-alpine"
    pullPolicy: IfNotPresent

  fallback:
    existingSecret: ""               # name of K8s Secret
    secretKey: "FALLBACK_BEACON_URL" # key containing full https://host/path URL

  checkInterval: 5000    # ms between health checks
  checkFall: 2           # consecutive failures to mark primary down
  checkRise: 2           # consecutive successes to mark primary up

  service:
    type: ClusterIP
    port: 5052

  resources: {}

  serviceMonitor:
    enabled: false

  ingress:
    enabled: false
```

## What Is Copied from execution-beacon

All execution-beacon templates and values are copied verbatim:
- StatefulSet with execution + beacon containers
- JWT authentication setup
- P2P NodePort services
- Persistence (separate PVCs for execution and beacon)
- All supported clients (Nethermind, Geth, Besu, Erigon, Reth / Lighthouse, Nimbus, Teku, Lodestar, Prysm)
- Metrics and ServiceMonitor for execution + beacon
- ethsider sidecar health checks

The only additions are the HAProxy Deployment, its Service, ConfigMap, and the `haproxy:` values block.

## Usage Example

```yaml
# values.yaml
haproxy:
  enabled: true
  fallback:
    existingSecret: "beacon-fallback-secret"
    secretKey: "DRPC_BEACON_URL"

# K8s Secret (managed by InfisicalSecret):
# DRPC_BEACON_URL: "https://beacon.drpc.org/YOUR_API_KEY"
```
