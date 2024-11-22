
# erpc

![Version: 1.0.7](https://img.shields.io/badge/Version-1.0.7-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.29](https://img.shields.io/badge/AppVersion-0.0.29-informational?style=flat-square)

A Helm chart for deploying Erpc

**Homepage:** <https://docs.erpc.cloud>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cbermudez97 |  |  |
| AntiD2ta |  |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| erpc.config.database.evmJsonRpcCache.driver | string | `""` | Cache driver to be used. One of `memory` or `redis`. Other drivers configurations will be ignored. DynamoDB and Postgres drivers are not supported at the moment. Ref: https://docs.erpc.cloud/config/database |
| erpc.config.database.evmJsonRpcCache.maxItems | int | `10000` | Maximum number of items to be cached. |
| erpc.config.database.evmJsonRpcCache.redis.addr | string | `""` | Redis server address. |
| erpc.config.database.evmJsonRpcCache.redis.db | string | `""` | Redis database to be used. |
| erpc.config.database.evmJsonRpcCache.redis.password | object | `{"secret":{"key":"","name":""}}` | Redis server password. |
| erpc.config.logLevel | string | `"warn"` | Erpc log level. |
| erpc.config.metrics | object | `{"enabled":true,"hostV4":"0.0.0.0","hostV6":"[::]","listenV4":true,"listenV6":false}` | Erpc prometheus metrics server configuration. |
| erpc.config.projects[0].auth | object | `{"secretKey":"","type":"secret"}` | Project authentication strategies. Ref: https://docs.erpc.cloud/config/auth. Only `secret` strategy is supported at the moment. |
| erpc.config.projects[0].id | string | `""` |  |
| erpc.config.projects[0].networks | list | `[{"chainId":1,"failsafe":{},"type":"evm"}]` | Project networks to be used. |
| erpc.config.projects[0].networks[0].failsafe | object | `{}` | Failsafe policies to be used for this network. Ref: https://docs.erpc.cloud/config/failsafe |
| erpc.config.projects[0].networks[0].type | string | `"evm"` | Chain type to be used. Only `evm` is supported at the moment. |
| erpc.config.projects[0].upstreams[0].chainId | int | `1` | Upstream chain id to be used. |
| erpc.config.projects[0].upstreams[0].endpoint | object | `{"secret":{"enabled":false,"key":""},"value":""}` | Upstream endpoint to be used. |
| erpc.config.projects[0].upstreams[0].endpoint.secret | object | `{"enabled":false,"key":""}` | Optional secret key to be used. This key is taken from the configured `erpc.secret` resource. |
| erpc.config.projects[0].upstreams[0].endpoint.value | string | `""` | Optional endpoint value. Ignored if the endpoint is using the `secret` configuration. |
| erpc.config.projects[0].upstreams[0].failsafe | object | `{}` | Failsafe policies to be used for this upstream. Ref: https://docs.erpc.cloud/config/failsafe |
| erpc.config.projects[0].upstreams[0].id | string | `""` |  |
| erpc.config.projects[0].upstreams[0].type | string | `"evm"` | Upstream type to be used. |
| erpc.config.server | object | `{"httpHostV4":"0.0.0.0","httpHostV6":"[::]","listenV4":true,"listenV6":false}` | Erpc json-rpc server configuration. |
| erpc.secret.name | string | `""` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ghcr.io/erpc/erpc"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[],"tls":[]}` | Ingress for the erpc rpc endpoint. |
| livenessProbe.httpGet.path | string | `"/"` |  |
| livenessProbe.httpGet.port | string | `"http"` |  |
| metricsIngress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[],"tls":[]}` | Ingress for the erpc metrics endpoint. |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.fsGroup | int | `1000` |  |
| podSecurityContext.runAsGroup | int | `1000` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `1000` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| readinessProbe.httpGet.path | string | `"/"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsGroup | int | `0` |  |
| securityContext.runAsNonRoot | bool | `false` |  |
| securityContext.runAsUser | int | `0` |  |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| service.metricsPort | int | `9000` |  |
| service.port | int | `8080` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
