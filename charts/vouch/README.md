
# vouch

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.11.1](https://img.shields.io/badge/AppVersion-1.11.1-informational?style=flat-square)

A Helm chart for installing and configuring Vouch validator client for large scale ETH staking infrastructure on top of the Kubernetes

**Homepage:** <https://nethermind.io>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| matilote |  |  |
| aivarasko |  |  |
| adriantpaez |  |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../common | common | 1.0.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| blockRelayPort | int | `18550` |  |
| cliImage.pullPolicy | string | `"IfNotPresent"` |  |
| cliImage.repository | string | `"nethermindeth/keystores-cli"` |  |
| cliImage.tag | string | `"v1.0.14"` |  |
| externalSecrets.dataFrom.key | string | `"vouch"` |  |
| externalSecrets.enabled | bool | `false` |  |
| externalSecrets.secretStoreRef.kind | string | `"SecretStore"` |  |
| externalSecrets.secretStoreRef.name | string | `"secretStoreRef"` |  |
| fullnameOverride | string | `""` |  |
| gasLimit | string | `nil` |  |
| global.podSecurityContext.fsGroup | int | `10000` |  |
| global.podSecurityContext.runAsNonRoot | bool | `true` |  |
| global.podSecurityContext.runAsUser | int | `10000` |  |
| global.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| global.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| global.securityContext.runAsNonRoot | bool | `true` |  |
| global.securityContext.runAsUser | int | `10000` |  |
| global.serviceAccount.create | bool | `true` |  |
| httpPort | int | `8881` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"attestant/vouch"` |  |
| image.tag | string | `"1.11.1"` |  |
| imagePullSecrets | list | `[]` |  |
| initImage.pullPolicy | string | `"IfNotPresent"` |  |
| initImage.repository | string | `"nethermindeth/bash"` |  |
| initImage.tag | string | `"5.2-alpine3.19"` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.httpGet.path | string | `"/metrics"` |  |
| livenessProbe.httpGet.port | string | `"metrics"` |  |
| livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| livenessProbe.initialDelaySeconds | int | `60` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `3` |  |
| loggingLevel | string | `"INFO"` |  |
| metricsPort | int | `8081` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.httpGet.path | string | `"/metrics"` |  |
| readinessProbe.httpGet.port | string | `"metrics"` |  |
| readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| readinessProbe.initialDelaySeconds | int | `10` |  |
| readinessProbe.periodSeconds | int | `5` |  |
| readinessProbe.successThreshold | int | `2` |  |
| readinessProbe.timeoutSeconds | int | `3` |  |
| relays | list | `[]` |  |
| resources | object | `{}` |  |
| service.httpPort | int | `8881` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.name | string | `""` |  |
| serviceMonitor.additionalLabels | object | `{}` |  |
| serviceMonitor.enabled | bool | `false` |  |
| serviceMonitor.honorLabels | bool | `false` |  |
| serviceMonitor.interval | string | `"30s"` |  |
| serviceMonitor.metricRelabelings | list | `[]` |  |
| serviceMonitor.namespace | string | `""` |  |
| serviceMonitor.relabellings | list | `[]` |  |
| serviceMonitor.scrapeTimeout | string | `""` |  |
| tolerations | object | `{}` |  |
| vouch.accountmanager.dirk.accounts[0] | string | `"Validators"` |  |
| vouch.accountmanager.dirk.endpoints[0] | string | `"dirk-1:8881"` |  |
| vouch.accountmanager.dirk.endpoints[1] | string | `"dirk-2:8881"` |  |
| vouch.accountmanager.dirk.endpoints[2] | string | `"dirk-3:8881"` |  |
| vouch.accountmanager.dirk.timeout | string | `"1m"` |  |
| vouch.beaconnodeaddress | string | `"localhost:5052"` |  |
| vouch.beaconnodeaddresses[0] | string | `"localhost:5051"` |  |
| vouch.beaconnodeaddresses[1] | string | `"localhost:5052"` |  |
| vouch.blockrelay.fallbackfeerecipient | string | `"0x0000000000000000000000000000000000000001"` |  |
| vouch.blockrelay.listen-address | string | `"0.0.0.0:18550"` |  |
| vouch.feerecipient.defaultaddress | string | `"0x0000000000000000000000000000000000000001"` |  |
| vouch.graffiti.static.value | string | `"My graffiti"` |  |
| vouch.loglevel | string | `"debug"` |  |
| vouch.metrics.prometheus.listenaddress | string | `"0.0.0.0:8081"` |  |
| vouch.metrics.prometheus.loglevel | string | `"trace"` |  |
| vouch.strategies | string | `nil` |  |
| vouch.submitter | string | `nil` |  |
| vouch.tracing | string | `nil` |  |
| vouchDataDir | string | `"/data/vouch"` |  |
| vouchFullConfig | string | `nil` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
