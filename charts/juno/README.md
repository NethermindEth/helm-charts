# juno

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Helm chart for Juno Starknet node with optional staking service

## Maintainers

| Name  | Email | Url |
| ----- | ----- | --- |
| brbrr |       |     |

## Usage

The chart deploys a Juno Starknet full node as a StatefulSet with persistent storage. Optionally, a staking validator service can be enabled alongside.

### Minimal Installation

```bash
helm install my-juno ./juno
```

### Name Override

Use `nameOverride` to set the name of the resources.

```yaml
nameOverride: "my-juno"
```

### Juno Node Configuration

```yaml
juno:
  enabled: true
  network: sepolia # mainnet, sepolia, sepolia-integration
  loglevel: "info"
  extraArgs:
    - --disable-l1-verification
  image:
    repository: nethermind/juno
    tag: "v0.15.18"
  persistence:
    storageClassName: ""
    accessModes:
      - ReadWriteOnce
    size: 1Ti
  resources:
    requests:
      cpu: "1"
      memory: "4Gi"
    limits:
      cpu: "2"
      memory: "8Gi"
```

> **Note:** You must provide either `--disable-l1-verification` or `--eth-node <WS endpoint>` in `juno.extraArgs`.

### Staking Service

Enable the staking validator alongside Juno:

```yaml
staking:
  enabled: true
  loglevel: "info"
  image:
    repository: nethermind/starknet-staking-v2
    tag: "v0.3.0"
  config:
    # Recommended: reference an existing secret
    existingSecret: "my-staking-secret"
    # Or provide inline config (dev/test only)
    data:
      signer:
        privateKey: "0x..."
        operationalAddress: "0x..."
  resources:
    requests:
      cpu: "1"
      memory: "4Gi"
```

### Container and Service Ports

Juno exposes RPC, WebSocket, and metrics ports. The staking service exposes a separate metrics port.

```yaml
juno:
  service:
    ports:
      rpc: 6060
      ws: 6061
      metrics: 8080

staking:
  service:
    ports:
      metrics: 8081

service:
  type: ClusterIP
```

### Ingress

Each ingress path defaults to the Juno RPC port (6060). Set `servicePort` to route to a different port (e.g. 6061 for WebSocket).

```yaml
ingress:
  enabled: true
  className: "nginx"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  hosts:
    - host: rpc.example.com
      paths:
        - path: /
          pathType: Prefix
    - host: ws.example.com
      paths:
        - path: /
          pathType: Prefix
          servicePort: 6061
  tls:
    - secretName: juno-tls
      hosts:
        - rpc.example.com
        - ws.example.com
```

### HTTPRoute (Gateway API)

```yaml
httpRoute:
  enabled: true
  parentRefs:
    - name: gateway
      sectionName: http
  hostnames:
    - chart-example.local
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /
```

### Prometheus Metrics

Deploy a ServiceMonitor to scrape metrics from both Juno and the staking service:

```yaml
serviceMonitor:
  enabled: true
```

The ServiceMonitor targets the `metrics` port on each enabled service at `/metrics`. Customize scrape settings as needed:

```yaml
serviceMonitor:
  enabled: true
  interval: "30s"
  scrapeTimeout: "10s"
  labels:
    release: prometheus
```

## Values

| Key                              | Type   | Default                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | Description                                                                                                                                                                                                                                                                                                                                    |
| -------------------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| affinity                         | object | `{}`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                |
| fullnameOverride                 | string | `""`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                |
| httpRoute                        | object | `{"annotations":{},"enabled":false,"hostnames":["chart-example.local"],"parentRefs":[{"name":"gateway","sectionName":"http"}],"rules":[{"matches":[{"path":{"type":"PathPrefix","value":"/"}}]}]}`                                                                                                                                                                                                                                                                                                                                                                                                   | Expose the service via gateway-api HTTPRoute                                                                                                                                                                                                                                                                                                   |
| imagePullSecrets                 | list   | `[]`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                |
| ingress                          | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"Prefix"}]}],"tls":[]}`                                                                                                                                                                                                                                                                                                                                                                                                                                                     | Ingress for exposing Juno RPC externally                                                                                                                                                                                                                                                                                                       |
| ingress.hosts                    | list   | `[{"host":"chart-example.local","paths":[{"path":"/","pathType":"Prefix"}]}]`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | Each path can optionally set servicePort to route to a specific Juno port. Defaults to juno.service.ports.rpc (6060). Set servicePort: 6061 for WebSocket. To expose both RPC and WS, use separate hosts: - host: rpc.example.com paths: - path: / pathType: Prefix - host: ws.example.com paths: - path: / pathType: Prefix servicePort: 6061 |
| juno                             | object | `{"command":[],"enabled":true,"extraArgs":["--disable-l1-verification"],"extraContainers":[],"image":{"pullPolicy":"IfNotPresent","repository":"nethermind/juno","tag":"v0.15.18"},"initContainers":[],"loglevel":"info","network":"sepolia","persistence":{"accessModes":["ReadWriteOnce"],"size":"1Ti","storageClassName":""},"readinessProbe":{"failureThreshold":3,"httpGet":{"path":"/ready","port":"rpc"},"initialDelaySeconds":30,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5},"resources":{},"securityContext":{},"service":{"ports":{"metrics":8080,"rpc":6060,"ws":6061}}}` | Juno Starknet node configuration                                                                                                                                                                                                                                                                                                               |
| juno.network                     | string | `"sepolia"`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | mainnet, sepolia, sepolia-integration                                                                                                                                                                                                                                                                                                          |
| juno.resources                   | object | `{}`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Resource requests and limits for juno container Example: requests: cpu: "1" memory: "4Gi" limits: cpu: "2" memory: "8Gi"                                                                                                                                                                                                                       |
| nameOverride                     | string | `""`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                |
| nodeSelector                     | object | `{}`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                |
| podAnnotations                   | object | `{}`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                |
| podLabels                        | object | `{}`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                |
| podSecurityContext               | object | `{}`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                |
| service                          | object | `{"type":"ClusterIP"}`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | Service type for all services                                                                                                                                                                                                                                                                                                                  |
| serviceMonitor.annotations       | object | `{}`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Additional ServiceMonitor annotations                                                                                                                                                                                                                                                                                                          |
| serviceMonitor.enabled           | bool   | `false`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | If true, a ServiceMonitor CRD is created for a prometheus operator                                                                                                                                                                                                                                                                             |
| serviceMonitor.interval          | string | `nil`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | ServiceMonitor scrape interval (leave empty for Prometheus operator default)                                                                                                                                                                                                                                                                   |
| serviceMonitor.labels            | object | `{}`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Additional ServiceMonitor labels                                                                                                                                                                                                                                                                                                               |
| serviceMonitor.metricRelabelings | list   | `[]`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | ServiceMonitor metricRelabelings                                                                                                                                                                                                                                                                                                               |
| serviceMonitor.namespace         | string | `nil`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Alternative namespace for ServiceMonitor                                                                                                                                                                                                                                                                                                       |
| serviceMonitor.path              | string | `"/metrics"`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | Path to scrape                                                                                                                                                                                                                                                                                                                                 |
| serviceMonitor.relabelings       | list   | `[]`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | ServiceMonitor relabelings                                                                                                                                                                                                                                                                                                                     |
| serviceMonitor.scheme            | string | `"http"`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | ServiceMonitor scheme                                                                                                                                                                                                                                                                                                                          |
| serviceMonitor.scrapeTimeout     | string | `nil`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | ServiceMonitor scrape timeout (leave empty for Prometheus operator default)                                                                                                                                                                                                                                                                    |
| serviceMonitor.tlsConfig         | object | `{}`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | ServiceMonitor TLS configuration                                                                                                                                                                                                                                                                                                               |
| staking                          | object | `{"command":[],"config":{"data":{},"existingSecret":""},"enabled":false,"extraArgs":[],"extraContainers":[],"image":{"pullPolicy":"IfNotPresent","repository":"nethermind/starknet-staking-v2","tag":"latest"},"initContainers":[],"loglevel":"info","readinessProbe":{"failureThreshold":3,"httpGet":{"path":"/metrics","port":"metrics"},"initialDelaySeconds":10,"periodSeconds":10,"timeoutSeconds":5},"resources":{},"securityContext":{},"service":{"ports":{"metrics":8081}}}`                                                                                                                | Starknet staking service configuration                                                                                                                                                                                                                                                                                                         |
| staking.config.data              | object | `{}`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Inline config data (creates a Secret from this; use for dev/test only) Example: data: signer: privateKey: "0x..." operationalAddress: "0x..."                                                                                                                                                                                                  |
| staking.config.existingSecret    | string | `""`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Use an existing secret for staking config (recommended for production)                                                                                                                                                                                                                                                                         |
| staking.extraArgs                | list   | `[]`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Extra CLI args passed to the staking validator (list of strings)                                                                                                                                                                                                                                                                               |
| staking.resources                | object | `{}`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Resource requests and limits for staking container Example: requests: cpu: "1" memory: "4Gi" limits: cpu: "2" memory: "8Gi"                                                                                                                                                                                                                    |
| terminationGracePeriodSeconds    | int    | `300`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |                                                                                                                                                                                                                                                                                                                                                |
| tolerations                      | list   | `[]`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                |

---

Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
