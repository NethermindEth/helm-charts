# generic-app

![Version: 1.4.0](https://img.shields.io/badge/Version-1.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for Kubernetes generic app

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 0xDones |  |  |
| gehlotanish |  |  |

## Usage

Check `values.deploy.yaml` or `values.sts.yaml` for example configuration options.

- `values.deploy.yaml` is for configuring a Deployment resource.
- `values.sts.yaml` is for configuring a StatefulSet resource.

### Name Override

Always use the `nameOverride` to set the name of the resources.

```yaml
nameOverride: "my-app"
```

### Init Containers or Sidecars

```yaml
initContainers:
  - name: my-init-container
    image: busybox
    command: ['sh', '-c', 'echo "Hello, World!"']
    resources: {}
      # limits:
      #   cpu: 100m
      #   memory: 128Mi
      # requests:
      #   cpu: 100m
      #   memory: 128Mi

extraContainers:
  - name: my-sidecar
    image: "busybox"
    imagePullPolicy: IfNotPresent
    ports:
      - name: http
        containerPort: 80
        protocol: TCP
```

### Container and Service Ports

This will create both service and container ports configuration. Only http port is required. It will be the default port for the Ingress resource.

```yaml
service:
  ports:
    - name: http
      port: 8080
      protocol: TCP
    - name: metrics
      port: 9090
      protocol: TCP
  extraContainersPorts: []
    # - name: http
    #   port: 8080
    #   protocol: TCP
```

### Ingress

```yaml
ingress:
  enabled: true
  className: "kong"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  hosts:
    - host: chart-example.local
      paths:
        - path: /
          pathType: ImplementationSpecific
          # -- Port name as defined in the service.ports section
          portName: http
  tls:
    - secretName: chart-example-local-tls
      hosts:
        - chart-example.local
```

### Prometheus Metrics

If you are exposing prometheus-style metrics, they can be collected by deploying a Service Monitor resource.

```yaml
serviceMonitor:
  enabled: true
```

Note that it expects the port named `metrics` to exist in the service, and the metrics to be available at `/metrics`.
Customize these as necessary:
```yaml
service:
  ports:
    - name: foo
      port: 8080
      protocol: TCP
    - name: bar
      port: 9090
      protocol: TCP

serviceMonitor:
  enabled: true
  port: bar
  path: /some/path/to/metrics
```

### Application Configuration

#### Environment Variables

There are different ways to expose environment variables to the application inside the container.

This is the most simple way to set environment variables. No further configuration is needed. A ConfigMap will be created named `{{ .Release.Name }}-env-cm`.

```yaml
config:
  VAR_1: value1
  VAR_2: value2
```

This uses the container `env` field to set environment variables. Ref: [Kubernetes Docs](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/)

```yaml
env:
  - name: MY_ENV_VAR
    value: my-env-var-value
  - name: SECRET
    valueFrom:
      secretKeyRef:
        key: SECRET
        name: secret-name
```

### Config Files

Mounting a ConfigMap as a file is useful when the application expects a configuration file.

```yaml
configMaps:
  - name: example-app-config
    data:
      config.yaml: |
        db_host: localhost
        db_user: db_user
  - name: example-app-single-file
    data:
      config.json: |
        {
          "key": "value"
        }

volumes:
  - name: example-app-config
    configMap:
      name: example-app-config
  - name: example-app-single-file
    configMap:
      name: example-app-single-file

volumeMounts:
  # Mounting a ConfigMap as a directory
  - name: example-app-config
    mountPath: /etc/config
    readOnly: true
  # Mounting a single file from a ConfigMap
  - name: example-app-single-file
    mountPath: /etc/single-file/config.json
    subPath: config.json
    readOnly: true
```

### Sts Persistence

```yaml
statefulSet:
  enabled: true
  persistence:
    enabled: true
    storageClassName: ""
    mountPath: /data
    accessModes:
      - ReadWriteOnce
    size: 50Gi
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| HTTPRoute.annotations | object | `{}` |  |
| HTTPRoute.enabled | bool | `false` |  |
| HTTPRoute.hostnames | list | `[]` |  |
| HTTPRoute.parentRefs | list | `[]` |  |
| HTTPRoute.rules | list | `[]` |  |
| TCPRoutes.annotations | object | `{}` |  |
| TCPRoutes.routes | object | `{}` |  |
| affinity | object | `{}` |  |
| args | list | `[]` |  |
| command | list | `[]` | Command and args for the container |
| config | object | `{}` | config is the most straightforward way to set environment variables for your application, the key/value configmap will be mounted as envs. No need to do any extra configuration. |
| configMaps | list | `[]` | Extra ConfigMaps, they need to be configured using volumes and volumeMounts |
| deployment | object | `{"autoscaling":{"enabled":false,"maxReplicas":10,"minReplicas":1,"targetCPUUtilizationPercentage":80},"enabled":false,"restartOnChanges":false}` | Enable Deployment |
| env | list | `[]` | This is for setting container environment variables: https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/ |
| envFrom | list | `[]` | envFrom configuration |
| extraContainers | list | `[]` | Sidecar containers |
| extraObjects | list | `[]` | Extra Kubernetes resources to be created |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"alpine"` |  |
| image.tag | string | `"latest"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific","portName":"http"}]}],"tls":[]}` | For now all traffic is routed to the `http` port |
| ingress.hosts[0].paths[0].portName | string | `"http"` | Port name as defined in the service.ports section |
| initContainerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| initContainerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| initContainerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| initContainerSecurityContext.runAsGroup | int | `1000` |  |
| initContainerSecurityContext.runAsNonRoot | bool | `true` |  |
| initContainerSecurityContext.runAsUser | int | `1000` |  |
| initContainers | list | `[]` | Init containers |
| livenessProbe | string | `nil` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.fsGroup | int | `1000` |  |
| podSecurityContext.runAsGroup | int | `1000` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `1000` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| readinessProbe | string | `nil` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| runtimeClassName | string | `""` | Runtime class name for the pod (e.g., "nvidia" for GPU workloads) |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsGroup | int | `1000` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| service.annotations | object | `{}` |  |
| service.extraContainersPorts | list | `[]` |  |
| service.ports[0].name | string | `"http"` |  |
| service.ports[0].port | int | `8080` |  |
| service.ports[0].protocol | string | `"TCP"` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| serviceMonitor.annotations | object | `{}` | Additional ServiceMonitor annotations |
| serviceMonitor.enabled | bool | `false` | If true, a ServiceMonitor CRD is created for a prometheus operator. https://github.com/coreos/prometheus-operator |
| serviceMonitor.interval | string | `"1m"` | ServiceMonitor scrape interval |
| serviceMonitor.labels | object | `{}` | Additional ServiceMonitor labels |
| serviceMonitor.metricRelabelings | list | `[]` | ServiceMonitor metricRelabelings |
| serviceMonitor.namespace | string | `nil` | Alternative namespace for ServiceMonitor |
| serviceMonitor.path | string | `"/metrics"` | Path to scrape |
| serviceMonitor.port | string | `"metrics"` | Port name |
| serviceMonitor.relabelings | list | `[]` | ServiceMonitor relabelings |
| serviceMonitor.scheme | string | `"http"` | ServiceMonitor scheme |
| serviceMonitor.scrapeTimeout | string | `"30s"` | ServiceMonitor scrape timeout |
| serviceMonitor.tlsConfig | object | `{}` | ServiceMonitor TLS configuration |
| statefulSet | object | `{"enabled":false,"persistence":{"accessModes":["ReadWriteOnce"],"enabled":false,"mountPath":"/data","size":"10Gi","storageClassName":""},"restartOnChanges":false}` | Enable StatefulSet |
| statefulSet.persistence | object | `{"accessModes":["ReadWriteOnce"],"enabled":false,"mountPath":"/data","size":"10Gi","storageClassName":""}` | Enable PVC for StatefulSet |
| terminationGracePeriodSeconds | int | `30` | Default termination grace period for the pod |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |
| workingDir | string | `""` | Working directory for the container. If not set, the container's default will be used. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
