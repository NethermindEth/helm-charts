# execution-beacon-fallback Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create a new `execution-beacon-fallback` Helm chart — a copy of `execution-beacon` with an HAProxy Deployment that provides active-fallback to a 3rd party beacon URL when the local beacon is unhealthy.

**Architecture:** Copy all `execution-beacon` templates verbatim. Add HAProxy as a separate Deployment with an init container that parses the 3rd party URL from a K8s Secret and renders haproxy.cfg via envsubst. HAProxy uses active HTTP health checks against `/eth/v1/node/health` (expects 200) and routes all traffic to the local beacon unless it fails, then switches to the 3rd party backup.

**Tech Stack:** Helm 3, HAProxy 3.0-alpine, helm-unittest plugin, common library chart (file://../common)

**Reference files:**
- Source chart to copy: `charts/execution-beacon/`
- Secret injection pattern: `charts/drpc-nodecore/templates/deployment.yaml` (envsubst init container)
- Test pattern: `charts/execution-beacon/tests/prometheusrules_test.yaml`
- Design doc: `docs/plans/2026-03-06-execution-beacon-fallback-design.md`

---

### Task 1: Scaffold the chart

Copy `execution-beacon` as the base and update chart metadata.

**Files:**
- Create: `charts/execution-beacon-fallback/` (entire directory)

**Step 1: Copy execution-beacon as base**

```bash
cp -r charts/execution-beacon charts/execution-beacon-fallback
```

**Step 2: Update Chart.yaml**

Edit `charts/execution-beacon-fallback/Chart.yaml`:
- `name: execution-beacon-fallback`
- `description: A Helm chart for deploying Ethereum execution and consensus clients with HAProxy active-fallback beacon proxy`
- `version: 0.1.0`
- Keep all keywords, maintainers, and the `common` dependency as-is

**Step 3: Remove execution-beacon lock file and re-fetch deps**

```bash
rm charts/execution-beacon-fallback/Chart.lock
helm dependency update charts/execution-beacon-fallback
```

Expected: `charts/execution-beacon-fallback/charts/common-1.0.0.tgz` downloaded.

**Step 4: Verify helm template renders**

```bash
helm template test-release charts/execution-beacon-fallback \
  --set execution.client=nethermind \
  --set beacon.client=lighthouse \
  > /dev/null
```

Expected: no errors.

**Step 5: Commit**

```bash
git add charts/execution-beacon-fallback/
git commit -m "chore(execution-beacon-fallback): scaffold chart from execution-beacon"
```

---

### Task 2: Add haproxy values

Add the `haproxy:` section to `values.yaml`.

**Files:**
- Modify: `charts/execution-beacon-fallback/values.yaml`

**Step 1: Append haproxy block at the end of values.yaml**

Add this block at the end of `charts/execution-beacon-fallback/values.yaml`:

```yaml
# -- HAProxy active-fallback proxy for beacon API
haproxy:
  # -- Enable HAProxy deployment in front of the beacon node
  enabled: true

  image:
    # -- HAProxy container image repository
    repository: haproxy
    # -- HAProxy container image tag
    tag: "3.0-alpine"
    # -- HAProxy container pull policy
    pullPolicy: IfNotPresent

  fallback:
    # -- Name of the K8s Secret containing the fallback beacon URL
    existingSecret: ""
    # -- Key within the secret containing the full https://host/path URL
    secretKey: "FALLBACK_BEACON_URL"

  # -- Milliseconds between active health checks
  checkInterval: 5000
  # -- Consecutive failures before marking primary down
  checkFall: 2
  # -- Consecutive successes before marking primary back up
  checkRise: 2

  service:
    # -- Service type for the HAProxy external-facing service
    type: ClusterIP
    # -- Port HAProxy listens on (clients connect here)
    port: 5052

  # -- Resource requests and limits for HAProxy container
  resources: {}
  # limits:
  #   cpu: 200m
  #   memory: 128Mi
  # requests:
  #   cpu: 100m
  #   memory: 64Mi

  # -- Pod annotations for HAProxy pods
  podAnnotations: {}

  # -- Node selector for HAProxy pods
  nodeSelector: {}

  # -- Tolerations for HAProxy pods
  tolerations: []

  # -- Affinity for HAProxy pods
  affinity: {}

  serviceMonitor:
    # -- If true, create a ServiceMonitor for HAProxy stats endpoint
    enabled: false
    # -- Scrape interval
    interval: 30s
    # -- Scrape timeout
    scrapeTimeout: 10s
    # -- Additional labels for the ServiceMonitor
    labels: {}

  ingress:
    # -- If true, create an Ingress pointing to the HAProxy service
    enabled: false
    # -- Ingress class name
    className: ""
    # -- Ingress annotations
    annotations: {}
    # -- Ingress hosts
    hosts: []
    #  - host: beacon.example.com
    #    paths:
    #      - path: /
    #        pathType: Prefix
    # -- Ingress TLS
    tls: []
```

**Step 2: Verify values parse**

```bash
helm template test-release charts/execution-beacon-fallback \
  --set execution.client=nethermind \
  --set beacon.client=lighthouse \
  > /dev/null
```

Expected: no errors.

---

### Task 3: HAProxy ConfigMap template

Create the ConfigMap holding the haproxy.cfg template with `${VAR}` placeholders.

**Files:**
- Create: `charts/execution-beacon-fallback/templates/haproxy-configmap.yaml`

**Step 1: Write the failing test first**

Create `charts/execution-beacon-fallback/tests/haproxy_test.yaml`:

```yaml
suite: haproxy tests

templates:
  - haproxy-configmap.yaml
  - haproxy-deployment.yaml
  - haproxy-service.yaml

set:
  fullnameOverride: test-node
  execution:
    client: nethermind
  beacon:
    client: lighthouse
  haproxy:
    enabled: true
    fallback:
      existingSecret: "my-secret"
      secretKey: "FALLBACK_BEACON_URL"

tests:
  - it: when haproxy enabled then configmap is created
    template: haproxy-configmap.yaml
    asserts:
      - isKind:
          of: ConfigMap
      - equal:
          path: metadata.name
          value: test-node-haproxy

  - it: when haproxy disabled then no configmap
    template: haproxy-configmap.yaml
    set:
      haproxy.enabled: false
    asserts:
      - hasDocuments:
          count: 0
```

**Step 2: Run test to verify it fails**

```bash
helm unittest charts/execution-beacon-fallback -f tests/haproxy_test.yaml
```

Expected: FAIL — template file not found.

**Step 3: Create haproxy-configmap.yaml**

Create `charts/execution-beacon-fallback/templates/haproxy-configmap.yaml`:

```yaml
{{- if .Values.haproxy.enabled }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" . }}-haproxy
  labels:
    {{- include "common.labels" . | nindent 4 }}
data:
  haproxy.cfg.tmpl: |
    global
        log stdout format raw local0
        maxconn 4096

    defaults
        log global
        mode http
        option httplog
        option dontlognull
        option forwardfor
        timeout connect 5s
        timeout client  55s
        timeout server  55s

    frontend beacon
        bind *:{{ .Values.haproxy.service.port }}
        default_backend beacon_backend

    backend beacon_backend
        option httpchk GET /eth/v1/node/health
        http-check expect status 200
        server local ${LOCAL_BEACON_HOST}:${LOCAL_BEACON_PORT} check inter {{ .Values.haproxy.checkInterval }}ms fall {{ .Values.haproxy.checkFall }} rise {{ .Values.haproxy.checkRise }}
        server fallback ${FALLBACK_HOST}:${FALLBACK_PORT} ssl verify none check inter {{ .Values.haproxy.checkInterval }}ms fall {{ .Values.haproxy.checkFall }} rise {{ .Values.haproxy.checkRise }} backup
{{- end }}
```

**Step 4: Run test to verify it passes**

```bash
helm unittest charts/execution-beacon-fallback -f tests/haproxy_test.yaml
```

Expected: PASS for configmap tests (deployment/service tests still fail — that's fine).

---

### Task 4: HAProxy Deployment template

Create the HAProxy Deployment with the envsubst init container.

**Files:**
- Create: `charts/execution-beacon-fallback/templates/haproxy-deployment.yaml`

**Step 1: Review the init container pattern in drpc-nodecore**

Read `charts/drpc-nodecore/templates/deployment.yaml` lines around `envsubst` to understand the pattern before writing.

**Step 2: Add deployment tests to haproxy_test.yaml**

Add these test cases to `charts/execution-beacon-fallback/tests/haproxy_test.yaml`:

```yaml
  - it: when haproxy enabled then deployment is created
    template: haproxy-deployment.yaml
    asserts:
      - isKind:
          of: Deployment
      - equal:
          path: metadata.name
          value: test-node-haproxy
      - equal:
          path: spec.template.spec.initContainers[0].name
          value: envsubst

  - it: when haproxy disabled then no deployment
    template: haproxy-deployment.yaml
    set:
      haproxy.enabled: false
    asserts:
      - hasDocuments:
          count: 0

  - it: when existingSecret set then init container has envFrom secretRef
    template: haproxy-deployment.yaml
    asserts:
      - equal:
          path: spec.template.spec.initContainers[0].envFrom[0].secretRef.name
          value: my-secret

  - it: haproxy container mounts rendered config from emptydir
    template: haproxy-deployment.yaml
    asserts:
      - contains:
          path: spec.template.spec.containers[0].volumeMounts
          content:
            name: haproxy-config
            mountPath: /usr/local/etc/haproxy/haproxy.cfg
            subPath: haproxy.cfg
            readOnly: true
```

**Step 3: Run tests to verify they fail**

```bash
helm unittest charts/execution-beacon-fallback -f tests/haproxy_test.yaml
```

Expected: FAIL — haproxy-deployment.yaml not found.

**Step 4: Create haproxy-deployment.yaml**

Create `charts/execution-beacon-fallback/templates/haproxy-deployment.yaml`:

```yaml
{{- if .Values.haproxy.enabled }}
{{- $beaconPort := include "execution-beacon.beaconHttpPort" . }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "common.fullname" . }}-haproxy
  labels:
    {{- include "common.labels" . | nindent 4 }}
spec:
  replicas: 1
  selector:
    matchLabels:
      {{- include "common.selectorLabels" . | nindent 6 }}
      app.kubernetes.io/component: haproxy
  template:
    metadata:
      annotations:
        checksum/config: {{ include (print $.Template.BasePath "/haproxy-configmap.yaml") . | sha256sum }}
        {{- with .Values.haproxy.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      labels:
        {{- include "common.selectorLabels" . | nindent 8 }}
        app.kubernetes.io/component: haproxy
    spec:
      initContainers:
        - name: envsubst
          image: "{{ .Values.haproxy.image.repository }}:{{ .Values.haproxy.image.tag }}"
          imagePullPolicy: {{ .Values.haproxy.image.pullPolicy }}
          command:
            - sh
            - -c
            - |
              set -e
              # parse FALLBACK_BEACON_URL into host and port
              FALLBACK_HOST=$(echo "${{ .Values.haproxy.fallback.secretKey }}" | sed 's|https\?://||' | cut -d'/' -f1 | cut -d':' -f1)
              FALLBACK_PORT=$(echo "${{ .Values.haproxy.fallback.secretKey }}" | sed 's|https\?://||' | cut -d'/' -f1 | grep -oP ':\K[0-9]+' || echo "443")
              export FALLBACK_HOST FALLBACK_PORT
              export LOCAL_BEACON_HOST={{ include "common.fullname" . }}-beacon
              export LOCAL_BEACON_PORT={{ $beaconPort }}
              envsubst < /etc/haproxy-tmpl/haproxy.cfg.tmpl > /etc/haproxy-rendered/haproxy.cfg
          envFrom:
            {{- if .Values.haproxy.fallback.existingSecret }}
            - secretRef:
                name: {{ .Values.haproxy.fallback.existingSecret }}
            {{- end }}
          volumeMounts:
            - name: haproxy-config-tmpl
              mountPath: /etc/haproxy-tmpl
              readOnly: true
            - name: haproxy-config
              mountPath: /etc/haproxy-rendered
      containers:
        - name: haproxy
          image: "{{ .Values.haproxy.image.repository }}:{{ .Values.haproxy.image.tag }}"
          imagePullPolicy: {{ .Values.haproxy.image.pullPolicy }}
          ports:
            - name: beacon
              containerPort: {{ .Values.haproxy.service.port }}
              protocol: TCP
          livenessProbe:
            tcpSocket:
              port: beacon
            initialDelaySeconds: 10
            periodSeconds: 30
          readinessProbe:
            tcpSocket:
              port: beacon
            initialDelaySeconds: 5
            periodSeconds: 10
          resources:
            {{- toYaml .Values.haproxy.resources | nindent 12 }}
          volumeMounts:
            - name: haproxy-config
              mountPath: /usr/local/etc/haproxy/haproxy.cfg
              subPath: haproxy.cfg
              readOnly: true
      volumes:
        - name: haproxy-config-tmpl
          configMap:
            name: {{ include "common.fullname" . }}-haproxy
        - name: haproxy-config
          emptyDir: {}
      {{- with .Values.haproxy.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.haproxy.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.haproxy.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{- end }}
```

**Note on beacon port helper:** The `execution-beacon.beaconHttpPort` helper is defined in `_helpers-beacon.yaml`. Verify its exact name by reading that file — adjust the include name if needed.

**Step 5: Run tests to verify they pass**

```bash
helm unittest charts/execution-beacon-fallback -f tests/haproxy_test.yaml
```

Expected: all deployment tests pass. Fix any helper name mismatches.

**Step 6: Commit**

```bash
git add charts/execution-beacon-fallback/templates/haproxy-configmap.yaml
git add charts/execution-beacon-fallback/templates/haproxy-deployment.yaml
git add charts/execution-beacon-fallback/tests/haproxy_test.yaml
git commit -m "chore(execution-beacon-fallback): add haproxy configmap and deployment"
```

---

### Task 5: HAProxy Service template

Create the ClusterIP service clients connect to.

**Files:**
- Create: `charts/execution-beacon-fallback/templates/haproxy-service.yaml`

**Step 1: Add service tests to haproxy_test.yaml**

```yaml
  - it: when haproxy enabled then service is created
    template: haproxy-service.yaml
    asserts:
      - isKind:
          of: Service
      - equal:
          path: metadata.name
          value: test-node-haproxy
      - equal:
          path: spec.type
          value: ClusterIP
      - equal:
          path: spec.ports[0].port
          value: 5052
      - equal:
          path: spec.ports[0].name
          value: beacon

  - it: when haproxy disabled then no service
    template: haproxy-service.yaml
    set:
      haproxy.enabled: false
    asserts:
      - hasDocuments:
          count: 0
```

**Step 2: Run tests to verify they fail**

```bash
helm unittest charts/execution-beacon-fallback -f tests/haproxy_test.yaml
```

**Step 3: Create haproxy-service.yaml**

Create `charts/execution-beacon-fallback/templates/haproxy-service.yaml`:

```yaml
{{- if .Values.haproxy.enabled }}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "common.fullname" . }}-haproxy
  labels:
    {{- include "common.labels" . | nindent 4 }}
    app.kubernetes.io/component: haproxy
spec:
  type: {{ .Values.haproxy.service.type }}
  ports:
    - name: beacon
      port: {{ .Values.haproxy.service.port }}
      targetPort: beacon
      protocol: TCP
  selector:
    {{- include "common.selectorLabels" . | nindent 4 }}
    app.kubernetes.io/component: haproxy
{{- end }}
```

**Step 4: Run tests to verify they pass**

```bash
helm unittest charts/execution-beacon-fallback -f tests/haproxy_test.yaml
```

**Step 5: Commit**

```bash
git add charts/execution-beacon-fallback/templates/haproxy-service.yaml
git commit -m "chore(execution-beacon-fallback): add haproxy service"
```

---

### Task 6: HAProxy ServiceMonitor and Ingress templates

**Files:**
- Create: `charts/execution-beacon-fallback/templates/haproxy-servicemonitor.yaml`
- Create: `charts/execution-beacon-fallback/templates/haproxy-ingress.yaml`

**Step 1: Add tests**

Add to `charts/execution-beacon-fallback/tests/haproxy_test.yaml`:

```yaml
  - it: when servicemonitor disabled then no servicemonitor
    template: haproxy-servicemonitor.yaml
    asserts:
      - hasDocuments:
          count: 0

  - it: when servicemonitor enabled then servicemonitor is created
    template: haproxy-servicemonitor.yaml
    set:
      haproxy.serviceMonitor.enabled: true
    asserts:
      - isKind:
          of: ServiceMonitor
      - equal:
          path: metadata.name
          value: test-node-haproxy

  - it: when ingress disabled then no ingress
    template: haproxy-ingress.yaml
    asserts:
      - hasDocuments:
          count: 0

  - it: when ingress enabled then ingress is created
    template: haproxy-ingress.yaml
    set:
      haproxy.ingress.enabled: true
      haproxy.ingress.hosts[0].host: beacon.example.com
      haproxy.ingress.hosts[0].paths[0].path: /
      haproxy.ingress.hosts[0].paths[0].pathType: Prefix
    asserts:
      - isKind:
          of: Ingress
```

**Step 2: Create haproxy-servicemonitor.yaml**

```yaml
{{- if and .Values.haproxy.enabled .Values.haproxy.serviceMonitor.enabled }}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ include "common.fullname" . }}-haproxy
  labels:
    {{- include "common.labels" . | nindent 4 }}
    {{- with .Values.haproxy.serviceMonitor.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  endpoints:
    - port: beacon
      interval: {{ .Values.haproxy.serviceMonitor.interval }}
      scrapeTimeout: {{ .Values.haproxy.serviceMonitor.scrapeTimeout }}
      path: /stats;csv
  jobLabel: {{ include "common.fullname" . }}-haproxy
  selector:
    matchLabels:
      {{- include "common.selectorLabels" . | nindent 6 }}
      app.kubernetes.io/component: haproxy
  namespaceSelector:
    matchNames:
      - {{ .Release.Namespace }}
{{- end }}
```

**Step 3: Create haproxy-ingress.yaml**

Copy the pattern from `charts/execution-beacon/templates/` or another chart that has an ingress template (e.g. from `charts/erpc`). The ingress should point to service `{{ include "common.fullname" . }}-haproxy` on port `{{ .Values.haproxy.service.port }}`, gated on `haproxy.enabled` and `haproxy.ingress.enabled`.

**Step 4: Run all tests**

```bash
helm unittest charts/execution-beacon-fallback
```

Expected: all tests pass.

**Step 5: Commit**

```bash
git add charts/execution-beacon-fallback/templates/haproxy-servicemonitor.yaml
git add charts/execution-beacon-fallback/templates/haproxy-ingress.yaml
git commit -m "chore(execution-beacon-fallback): add haproxy servicemonitor and ingress"
```

---

### Task 7: Rename internal beacon service

The existing `execution-beacon` service exposes beacon on the main chart service. In `execution-beacon-fallback`, the external-facing service should be the HAProxy service. The beacon's own service should be internal-only (clients must NOT bypass HAProxy).

**Files:**
- Modify: `charts/execution-beacon-fallback/templates/service.yaml`

**Step 1: Check what ports the existing service.yaml exposes**

Read `charts/execution-beacon-fallback/templates/service.yaml` to understand which ports it exposes. Identify the beacon HTTP port.

**Step 2: When haproxy.enabled, annotate the beacon service as internal-only**

When `haproxy.enabled: true`, add an annotation to the beacon service:

```yaml
{{- if .Values.haproxy.enabled }}
annotations:
  execution-beacon-fallback/internal: "true"
{{- end }}
```

This is informational — it signals to operators that clients should connect to the HAProxy service, not directly to the beacon service.

**Step 3: Add a test**

```yaml
  - it: when haproxy enabled beacon service has internal annotation
    template: service.yaml
    set:
      execution.client: nethermind
      beacon.client: lighthouse
      haproxy.enabled: true
    asserts:
      - equal:
          path: metadata.annotations["execution-beacon-fallback/internal"]
          value: "true"
```

**Step 4: Run and verify**

```bash
helm unittest charts/execution-beacon-fallback
```

**Step 5: Commit**

```bash
git add charts/execution-beacon-fallback/templates/service.yaml
git add charts/execution-beacon-fallback/tests/
git commit -m "chore(execution-beacon-fallback): mark beacon service as internal when haproxy enabled"
```

---

### Task 8: Full render validation

**Step 1: Render with haproxy enabled (default)**

```bash
helm template test-release charts/execution-beacon-fallback \
  --set execution.client=nethermind \
  --set beacon.client=lighthouse \
  --set haproxy.fallback.existingSecret=my-beacon-secret \
  --debug
```

Verify:
- StatefulSet present for execution+beacon
- Deployment present for haproxy
- Two Services: `test-release-execution-beacon-fallback` (beacon) and `test-release-execution-beacon-fallback-haproxy`
- ConfigMap present with haproxy.cfg.tmpl content
- Init container present on haproxy Deployment with `envFrom.secretRef.name: my-beacon-secret`

**Step 2: Render with haproxy disabled**

```bash
helm template test-release charts/execution-beacon-fallback \
  --set execution.client=nethermind \
  --set beacon.client=lighthouse \
  --set haproxy.enabled=false \
  --debug
```

Verify: no HAProxy resources present, identical output to `execution-beacon`.

**Step 3: Helm lint**

```bash
helm lint charts/execution-beacon-fallback \
  --set execution.client=nethermind \
  --set beacon.client=lighthouse
```

Expected: no errors, warnings acceptable.

**Step 4: Run full test suite**

```bash
helm unittest charts/execution-beacon-fallback
```

Expected: all tests pass.

**Step 5: Final commit**

```bash
git add charts/execution-beacon-fallback/
git commit -m "chore(execution-beacon-fallback): complete chart with haproxy active-fallback"
```
