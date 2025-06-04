
# validator-ejector

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for Lido Validator Ejector

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 0xDones |  |  |
| aivarasko |  |  |
| matilote |  |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| args | list | `[]` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| command | list | `[]` | Command and args for the container |
| config | object | `{"CONSENSUS_NODE":"http://localhost:5052","EXECUTION_NODE":"http://localhost:8545","LOCATOR_ADDRESS":"0x12cd349E19Ab2ADBE478Fc538A66C059Cf40CFeC","MESSAGES_LOCATION":"/data/messages","OPERATOR_ID":"123","ORACLE_ADDRESSES_ALLOWLIST":"[]","STAKING_MODULE_ID":"123"}` | Validator Ejector configuration Reference: https://github.com/lidofinance/validator-ejector/tree/main |
| config.CONSENSUS_NODE | string | `"http://localhost:5052"` | Ethereum Consensus Node endpoint |
| config.EXECUTION_NODE | string | `"http://localhost:8545"` | Ethereum Execution Node endpoint |
| config.LOCATOR_ADDRESS | string | `"0x12cd349E19Ab2ADBE478Fc538A66C059Cf40CFeC"` | Address of the Locator contract, can be found in the lido-dao repo |
| config.MESSAGES_LOCATION | string | `"/data/messages"` | Folder to load json exit message files from |
| config.OPERATOR_ID | string | `"123"` | Operator ID in the Node Operators registry, easiest to get from Operators UI |
| config.ORACLE_ADDRESSES_ALLOWLIST | string | `"[]"` | Allowed Oracle addresses to accept transactions |
| config.STAKING_MODULE_ID | string | `"123"` | Staking Module ID for which operator ID is set |
| fullnameOverride | string | `""` |  |
| global.secretName | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"lidofinance/validator-ejector"` |  |
| image.tag | string | `"1.8.0"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.httpGet.path | string | `"/"` |  |
| livenessProbe.httpGet.port | string | `"metrics"` |  |
| loader.config.BEACON_ENDPOINT | string | `"http://localhost:5052"` |  |
| loader.config.EIP2335_PASSWORD | string | `"password"` | Password to encrypt exit messages with. Needed only if you encrypt your exit messages, same value should be used in the validator ejector config |
| loader.config.ENCRYPTION | string | `"EIP2335"` |  |
| loader.config.ENCRYPTION_TYPE | string | `"EIP2335"` |  |
| loader.config.ENCRYPT_WITH_METADATA | string | `"false"` |  |
| loader.config.FETCH_INTERVAL | string | `"60"` |  |
| loader.config.KEY_LOADER_TYPE | string | `"WEB3SIGNER"` |  |
| loader.config.LOADER_MAPPER | string | `"{}"` |  |
| loader.config.LidoKAPI_KEYS_PERCENT | string | `""` |  |
| loader.config.LidoKAPI_OPERATOR_ID | string | `""` |  |
| loader.config.SIGNER_MAPPER | string | `"{}"` |  |
| loader.config.STORAGE_LOCATION | string | `"/data/messages"` |  |
| loader.enabled | bool | `true` |  |
| loader.env | list | `[]` |  |
| loader.image.pullPolicy | string | `"IfNotPresent"` |  |
| loader.image.repository | string | `"nethermindeth/eth-exit-messages"` |  |
| loader.image.tag | string | `"v0.0.26"` |  |
| loader.volumeMounts | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence | object | `{"accessModes":["ReadWriteOnce"],"enabled":false,"mountPath":"/data","size":"10Gi","storageClassName":""}` | Set persistence to true to enable persistent storage for the application. |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.fsGroup | int | `1000` |  |
| podSecurityContext.runAsGroup | int | `1000` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `1000` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| readinessProbe.httpGet.path | string | `"/"` |  |
| readinessProbe.httpGet.port | string | `"metrics"` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsGroup | int | `1000` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| service.ports[0].name | string | `"metrics"` |  |
| service.ports[0].port | int | `8989` |  |
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
| serviceMonitor.namespace | string | `nil` | Alternative namespace for ServiceMonitor |
| serviceMonitor.path | string | `"/metrics"` | Path to scrape |
| serviceMonitor.port | string | `"metrics"` | Port name |
| serviceMonitor.relabelings | list | `[]` | ServiceMonitor relabelings |
| serviceMonitor.scheme | string | `"http"` | ServiceMonitor scheme |
| serviceMonitor.scrapeTimeout | string | `"30s"` | ServiceMonitor scrape timeout |
| serviceMonitor.tlsConfig | object | `{}` | ServiceMonitor TLS configuration |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |
| workingDir | string | `""` | Working directory for the container. If not set, the container's default will be used. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
