# drpc-nodecore

![Version: 1.1.1](https://img.shields.io/badge/Version-1.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for dRPC nodeCore application

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| manjeet-nt |  |  |
| adriantpaez |  |  |

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
| affinity | object | `{}` |  |
| args | list | `[]` |  |
| command | list | `[]` | Command and args for the container |
| config | object | `{}` | config is the most straightforward way to set environment variables for your application, the key/value configmap will be mounted as envs. No need to do any extra configuration. |
| configMaps | list | `[{"data":{"drpc-nginx.conf":"# Map Upgrade header for WebSocket support\nmap $http_upgrade $connection_upgrade {\n    default upgrade;\n    ''      close;\n}\n\nserver {\n    listen 8080;\n\n    location /queries/ {\n        # Extract token from query string and set header\n        proxy_set_header X-Nodecore-Token $arg_token;\n\n        # Remove token from query string before proxying\n        set $clean_args \"\";\n        if ($args ~* \"token=[^&]+&?(.*)\") {\n            set $clean_args $1;\n        }\n        if ($clean_args = \"\") {\n            proxy_pass http://127.0.0.1:9090$uri;\n        }\n        if ($clean_args != \"\") {\n            proxy_pass http://127.0.0.1:9090$uri?$clean_args;\n        }\n\n        # Standard proxy headers\n        proxy_set_header Host $host;\n        proxy_set_header X-Real-IP $remote_addr;\n        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n        proxy_set_header X-Forwarded-Proto $scheme;\n\n        # WebSocket headers\n        proxy_http_version 1.1;\n        proxy_set_header Upgrade $http_upgrade;\n        proxy_set_header Connection $connection_upgrade;\n\n        # Forward request body\n        proxy_pass_request_body on;\n        proxy_pass_request_headers on;\n    }\n}\n","nginx.conf":"# PID file location (writable by non-root user)\npid /var/cache/nginx/nginx.pid;\n\n# Worker processes\nworker_processes auto;\n\nevents {\n    worker_connections 1024;\n}\n\nhttp {\n    include /etc/nginx/mime.types;\n    default_type application/octet-stream;\n\n    # Temp paths that non-root user can write to\n    client_body_temp_path /var/cache/nginx/client_temp;\n    proxy_temp_path /var/cache/nginx/proxy_temp;\n    fastcgi_temp_path /var/cache/nginx/fastcgi_temp;\n    uwsgi_temp_path /var/cache/nginx/uwsgi_temp;\n    scgi_temp_path /var/cache/nginx/scgi_temp;\n\n    # Logging\n    access_log /dev/stdout;\n    error_log /dev/stderr info;\n\n    sendfile on;\n    keepalive_timeout 65;\n\n    # Include your server configuration\n    include /etc/nginx/conf.d/*.conf;\n}\n"},"name":"nginx-config"}]` | Extra ConfigMaps, they need to be configured using volumes and volumeMounts |
| defaultInitContainers | list | `[{"command":["sh","-c","mkdir -p /var/cache/nginx && chmod -R 777 /var/cache/nginx"],"image":"nginx:1.25","name":"init-nginx-cache","volumeMounts":[{"mountPath":"/var/cache/nginx","name":"nginx-cache"}]}]` | Default init containers |
| defaultVolumes[0].emptyDir | object | `{}` |  |
| defaultVolumes[0].name | string | `"nginx-cache"` |  |
| defaultVolumes[1].configMap.name | string | `"nginx-config"` |  |
| defaultVolumes[1].name | string | `"nginx-config"` |  |
| defaultVolumes[2].emptyDir | object | `{}` |  |
| defaultVolumes[2].name | string | `"nginx-conf-d"` |  |
| deployment | object | `{"autoscaling":{"enabled":false,"maxReplicas":10,"minReplicas":1,"targetCPUUtilizationPercentage":80},"enabled":true,"restartOnChanges":false}` | Enable Deployment |
| env | list | `[]` | This is for setting container environment variables: https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/ |
| envFrom | list | `[]` | envFrom configuration |
| extraContainers | list | `[{"command":["sh","-c","rm -f /etc/nginx/conf.d/default.conf\nexec nginx -g 'daemon off;'\n"],"image":"nginx:1.25","name":"nginx-sidecar","ports":[{"containerPort":8080}],"securityContext":{"readOnlyRootFilesystem":false,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000},"volumeMounts":[{"mountPath":"/etc/nginx/nginx.conf","name":"nginx-config","readOnly":true,"subPath":"nginx.conf"},{"mountPath":"/etc/nginx/conf.d/drpc-nginx.conf","name":"nginx-config","readOnly":true,"subPath":"drpc-nginx.conf"},{"mountPath":"/etc/nginx/conf.d","name":"nginx-conf-d"},{"mountPath":"/var/cache/nginx","name":"nginx-cache"}]}]` | Sidecar containers |
| extraObjects | list | `[]` | Extra Kubernetes resources to be created |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"drpcorg/nodecore"` |  |
| image.tag | string | `"0.1.6"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific","portName":"http"}]}],"tls":[]}` | For now all traffic is routed to the `http` port |
| ingress.hosts[0].paths[0].portName | string | `"http"` | Port name as defined in the service.ports section |
| initContainerSecurityContext.allowPrivilegeEscalation | bool | `true` |  |
| initContainerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| initContainerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| initContainerSecurityContext.runAsGroup | int | `0` |  |
| initContainerSecurityContext.runAsNonRoot | bool | `false` |  |
| initContainerSecurityContext.runAsUser | int | `0` |  |
| initContainerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.initialDelaySeconds | int | `30` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.tcpSocket.port | int | `9090` |  |
| livenessProbe.timeoutSeconds | int | `1` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.fsGroup | int | `1000` |  |
| podSecurityContext.runAsGroup | int | `1000` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `1000` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| readinessProbe.failureThreshold | int | `2` |  |
| readinessProbe.httpGet.path | string | `"/metrics"` |  |
| readinessProbe.httpGet.port | int | `9093` |  |
| readinessProbe.initialDelaySeconds | int | `10` |  |
| readinessProbe.periodSeconds | int | `5` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| runtimeClassName | string | `""` | Runtime class name for the pod (e.g., "nvidia" for GPU workloads) |
| securityContext.allowPrivilegeEscalation | bool | `true` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `false` |  |
| securityContext.runAsGroup | int | `0` |  |
| securityContext.runAsNonRoot | bool | `false` |  |
| securityContext.runAsUser | int | `0` |  |
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
| serviceMonitor.enabled | bool | `true` |  |
| serviceMonitor.path | string | `"/metrics"` |  |
| serviceMonitor.port | string | `"metrics"` |  |
| terminationGracePeriodSeconds | int | `30` | Default termination grace period for the pod |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| workingDir | string | `""` | Working directory for the container. If not set, the container's default will be used. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
