# generic-app

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Generic App Helm chart for Kubernetes

## Installation

```bash
helm repo add nethermind https://nethermindeth.github.io/helm-charts
helm install generic-app nethermind/generic-app
```

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 0xDones |  |  |

## Usage

Check `values.deploy.yaml` or `values.sts.yaml` for example configuration options.

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
    http: 80
  extraPorts:
    - name: metrics
      port: 9090
      protocol: TCP
```

### Environment Variables

#### From ConfigMap

Mounting a ConfigMap as environment variables is the simplest way to use a ConfigMap in a Pod.

```yaml
envFrom:
  - configMapRef:
      name: '{{ include "generic-app.fullname" . }}'

configMap:
  enabled: true
  data:
    VAR_1: value1
    VAR_2: value2
```

#### From env

```yaml
env:
  - name: MY_ENV_VAR
    value: my-env-var-value
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
| affinity | object | `{}` |  |
| args | list | `[]` |  |
| command | list | `[]` | Command and args for the container |
| configMap | object | `{"data":{},"enabled":false}` | ConfigMap configuration, if enabled configMap will be created and mounted as environment variables |
| deployment | object | `{"autoscaling":{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80},"enabled":true}` | Enable Deployment |
| env | list | `[]` |  |
| envFrom | list | `[]` | envFrom configuration |
| extraContainers | list | `[]` | Sidecar containers |
| extraObjects | list | `[]` | Extra Kubernetes resources to be created |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"nginx"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | For now all traffic is routed to the `http` port |
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
| readinessProbe | string | `nil` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsGroup | int | `1000` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| service.extraPorts | list | `[]` |  |
| service.ports.http | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| serviceMonitor.annotations | object | `{}` | Additional ServiceMonitor annotations |
| serviceMonitor.enabled | bool | `false` | If true, a ServiceMonitor CRD is created for a prometheus operator. https://github.com/coreos/prometheus-operator |
| serviceMonitor.interval | string | `"1m"` | ServiceMonitor scrape interval |
| serviceMonitor.labels | object | `{}` | Additional ServiceMonitor labels |
| serviceMonitor.namespace | string | `nil` | Alternative namespace for ServiceMonitor |
| serviceMonitor.path | string | `"/metrics"` | Path to scrape |
| serviceMonitor.port | string | `"metrics"` | Port name |
| serviceMonitor.relabelings | list | `[]` | ServiceMonitor relabelings |
| serviceMonitor.scheme | string | `"http"` | ServiceMonitor scheme |
| serviceMonitor.scrapeTimeout | string | `"30s"` | ServiceMonitor scrape timeout |
| serviceMonitor.tlsConfig | object | `{}` | ServiceMonitor TLS configuration |
| statefulSet | object | `{"enabled":false,"persistence":{"accessModes":["ReadWriteOnce"],"enabled":false,"mountPath":"/data","size":"10Gi","storageClassName":""}}` | Enable StatefulSet |
| statefulSet.persistence | object | `{"accessModes":["ReadWriteOnce"],"enabled":false,"mountPath":"/data","size":"10Gi","storageClassName":""}` | Enable PVC for StatefulSet |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
