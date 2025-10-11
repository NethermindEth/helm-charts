
# execution-beacon

![Version: 1.0.29](https://img.shields.io/badge/Version-1.0.29-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for deploying Ethereum execution and consensus clients

**Homepage:** <https://www.ethereum.org/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 0xDones |  |  |
| matilote |  |  |
| aivarasko |  |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../common | common | 1.0.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| JWTSecret | string | `""` |  |
| JWTSecretKey | string | `"JWT_SECRET"` |  |
| JWTSecretName | string | `""` |  |
| affinity | object | `{}` |  |
| beacon.builderEndpoint | string | `""` |  |
| beacon.checkPointSync.enabled | bool | `true` |  |
| beacon.checkPointSync.trustedSourceUrl | string | `""` |  |
| beacon.checkPointSync.url | string | `"https://mainnet-checkpoint-sync.attestant.io"` |  |
| beacon.client | string | `"nimbus"` |  |
| beacon.env | list | `[]` |  |
| beacon.envFrom | list | `[]` |  |
| beacon.extraFlags | list | `[]` |  |
| beacon.grpc.enabled | bool | `true` |  |
| beacon.grpc.host | string | `"0.0.0.0"` |  |
| beacon.grpc.port | int | `4000` |  |
| beacon.grpc.portName | string | `"rpc"` |  |
| beacon.initChownData | bool | `true` |  |
| beacon.metrics.annotations | object | `{}` |  |
| beacon.metrics.categories[0] | string | `"JVM"` |  |
| beacon.metrics.categories[10] | string | `"STORAGE_FINALIZED_DB"` |  |
| beacon.metrics.categories[11] | string | `"VALIDATOR"` |  |
| beacon.metrics.categories[12] | string | `"VALIDATOR_PERFORMANCE"` |  |
| beacon.metrics.categories[13] | string | `"VALIDATOR_DUTY"` |  |
| beacon.metrics.categories[1] | string | `"PROCESS"` |  |
| beacon.metrics.categories[2] | string | `"BEACON"` |  |
| beacon.metrics.categories[3] | string | `"DISCOVERY"` |  |
| beacon.metrics.categories[4] | string | `"EVENTBUS"` |  |
| beacon.metrics.categories[5] | string | `"EXECUTOR"` |  |
| beacon.metrics.categories[6] | string | `"LIBP2P"` |  |
| beacon.metrics.categories[7] | string | `"NETWORK"` |  |
| beacon.metrics.categories[8] | string | `"STORAGE"` |  |
| beacon.metrics.categories[9] | string | `"STORAGE_HOT_DB"` |  |
| beacon.metrics.enabled | bool | `true` |  |
| beacon.metrics.host | string | `"0.0.0.0"` |  |
| beacon.metrics.hostAllowList[0] | string | `"*"` |  |
| beacon.metrics.port | int | `9090` |  |
| beacon.metrics.prometheusRule.enabled | bool | `true` |  |
| beacon.metrics.serviceMonitor.enabled | bool | `true` |  |
| beacon.metrics.svcAnnotations | object | `{}` |  |
| beacon.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| beacon.persistence.annotations | object | `{}` |  |
| beacon.persistence.enabled | bool | `true` |  |
| beacon.persistence.size | string | `"100Gi"` |  |
| beacon.persistence.storageClassName | string | `""` |  |
| beacon.proposerOnly | bool | `false` |  |
| beacon.resources | object | `{}` |  |
| beacon.restApi.corsOrigins[0] | string | `"*"` |  |
| beacon.restApi.enabled | bool | `true` |  |
| beacon.restApi.host | string | `"0.0.0.0"` |  |
| beacon.restApi.hostAllowList[0] | string | `"*"` |  |
| beacon.restApi.portMap.lighthouse | int | `5052` |  |
| beacon.restApi.portMap.lodestar | int | `9596` |  |
| beacon.restApi.portMap.nimbus | int | `5052` |  |
| beacon.restApi.portMap.prysm | int | `8080` |  |
| beacon.restApi.portMap.teku | int | `5051` |  |
| beacon.suggestedFeeRecipient | string | `""` |  |
| beacon.targetPeers | int | `50` |  |
| beacon.targetPeersMin | int | `40` |  |
| beacon.totalDifficultyOverride | string | `""` |  |
| beacon.volumeMounts | list | `[]` |  |
| env | list | `[]` |  |
| envFrom | list | `[]` |  |
| ethsider.bindAddr | int | `3000` |  |
| ethsider.enabled | bool | `true` |  |
| ethsider.livenessProbe.enabled | bool | `false` |  |
| ethsider.livenessProbe.failureThreshold | int | `3` |  |
| ethsider.livenessProbe.httpGet.path | string | `"/liveness"` |  |
| ethsider.livenessProbe.httpGet.port | string | `"sidecar"` |  |
| ethsider.livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| ethsider.livenessProbe.initialDelaySeconds | int | `10` |  |
| ethsider.livenessProbe.periodSeconds | int | `1` |  |
| ethsider.livenessProbe.successThreshold | int | `3` |  |
| ethsider.livenessProbe.timeoutSeconds | int | `3` |  |
| ethsider.pullPolicy | string | `"IfNotPresent"` |  |
| ethsider.readinessProbe.enabled | bool | `true` |  |
| ethsider.readinessProbe.failureThreshold | int | `3` |  |
| ethsider.readinessProbe.httpGet.path | string | `"/readiness"` |  |
| ethsider.readinessProbe.httpGet.port | string | `"sidecar"` |  |
| ethsider.readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| ethsider.readinessProbe.initialDelaySeconds | int | `10` |  |
| ethsider.readinessProbe.periodSeconds | int | `1` |  |
| ethsider.readinessProbe.successThreshold | int | `3` |  |
| ethsider.readinessProbe.timeoutSeconds | int | `3` |  |
| ethsider.repository | string | `"nethermindeth/ethsider"` |  |
| ethsider.tag | string | `"v1.0.0"` |  |
| execution.client | string | `"nethermind"` |  |
| execution.enableDiscoveryV5 | bool | `true` |  |
| execution.env | list | `[]` |  |
| execution.envFrom | list | `[]` |  |
| execution.externalCl | bool | `true` |  |
| execution.extraFlags | list | `[]` |  |
| execution.healthchecks.enabled | bool | `true` |  |
| execution.healthchecks.lowStorageSpaceShutdownThreshold | int | `0` |  |
| execution.healthchecks.lowStorageSpaceWarningThreshold | int | `5` |  |
| execution.healthchecks.pollingInterval | int | `5` |  |
| execution.healthchecks.slug | string | `"/health"` |  |
| execution.initChownData | bool | `true` |  |
| execution.jsonrpc.enabled | bool | `true` |  |
| execution.jsonrpc.engine.corsOrigins[0] | string | `"*"` |  |
| execution.jsonrpc.engine.hostAllowList[0] | string | `"*"` |  |
| execution.jsonrpc.engine.port | int | `8551` |  |
| execution.jsonrpc.grpc.port | int | `8655` |  |
| execution.jsonrpc.host | string | `"0.0.0.0"` |  |
| execution.jsonrpc.http.corsOrigins[0] | string | `"*"` |  |
| execution.jsonrpc.http.hostAllowList[0] | string | `"*"` |  |
| execution.jsonrpc.http.port | int | `8545` |  |
| execution.jsonrpc.namespaces.erigon[0] | string | `"eth"` |  |
| execution.jsonrpc.namespaces.erigon[1] | string | `"erigon"` |  |
| execution.jsonrpc.namespaces.erigon[2] | string | `"web3"` |  |
| execution.jsonrpc.namespaces.erigon[3] | string | `"net"` |  |
| execution.jsonrpc.namespaces.erigon[4] | string | `"engine"` |  |
| execution.jsonrpc.namespaces.geth[0] | string | `"web3"` |  |
| execution.jsonrpc.namespaces.geth[1] | string | `"eth"` |  |
| execution.jsonrpc.namespaces.geth[2] | string | `"net"` |  |
| execution.jsonrpc.namespaces.geth[3] | string | `"engine"` |  |
| execution.jsonrpc.namespaces.nethermind[0] | string | `"Web3"` |  |
| execution.jsonrpc.namespaces.nethermind[1] | string | `"Eth"` |  |
| execution.jsonrpc.namespaces.nethermind[2] | string | `"Net"` |  |
| execution.jsonrpc.namespaces.nethermind[3] | string | `"Subscribe"` |  |
| execution.jsonrpc.namespaces.nethermind[4] | string | `"Health"` |  |
| execution.jsonrpc.namespaces.reth[0] | string | `"eth"` |  |
| execution.jsonrpc.namespaces.reth[1] | string | `"web3"` |  |
| execution.jsonrpc.namespaces.reth[2] | string | `"net"` |  |
| execution.jsonrpc.websocket.enabled | bool | `true` |  |
| execution.jsonrpc.websocket.origins | string | `"*"` |  |
| execution.jsonrpc.websocket.port | int | `8546` |  |
| execution.metrics.enabled | bool | `true` |  |
| execution.metrics.host | string | `"0.0.0.0"` |  |
| execution.metrics.port | int | `8008` |  |
| execution.metrics.prometheusRule.enabled | bool | `true` |  |
| execution.metrics.serviceMonitor.enabled | bool | `true` |  |
| execution.metrics.svcAnnotations | object | `{}` |  |
| execution.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| execution.persistence.annotations | object | `{}` |  |
| execution.persistence.enabled | bool | `true` |  |
| execution.persistence.size | string | `"100Gi"` |  |
| execution.persistence.storageClassName | string | `""` |  |
| execution.privateApiAddr | string | `"127.0.0.1:9090"` |  |
| execution.resources | object | `{}` |  |
| execution.snapshot.enabled | bool | `false` |  |
| execution.snapshot.force | bool | `false` |  |
| execution.snapshot.image.pullPolicy | string | `"IfNotPresent"` |  |
| execution.snapshot.image.repository | string | `"alpine"` |  |
| execution.snapshot.image.tag | string | `"3.20"` |  |
| execution.snapshot.url | string | `""` |  |
| execution.targetPeers | int | `50` |  |
| execution.terminalTotalDifficulty | string | `""` |  |
| execution.volumeMounts | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.initContainerSecurityContext.capabilities.add[0] | string | `"CHOWN"` |  |
| global.initContainerSecurityContext.capabilities.add[1] | string | `"DAC_OVERRIDE"` |  |
| global.initContainerSecurityContext.capabilities.add[2] | string | `"FOWNER"` |  |
| global.initContainerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| global.initContainerSecurityContext.runAsGroup | int | `0` |  |
| global.initContainerSecurityContext.runAsNonRoot | bool | `false` |  |
| global.initContainerSecurityContext.runAsUser | int | `0` |  |
| global.podSecurityContext.fsGroup | int | `1000` |  |
| global.podSecurityContext.runAsGroup | int | `1000` |  |
| global.podSecurityContext.runAsNonRoot | bool | `true` |  |
| global.podSecurityContext.runAsUser | int | `1000` |  |
| global.podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| global.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| global.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| global.securityContext.readOnlyRootFilesystem | bool | `false` |  |
| global.securityContext.runAsGroup | int | `1000` |  |
| global.securityContext.runAsNonRoot | bool | `true` |  |
| global.securityContext.runAsUser | int | `1000` |  |
| global.securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| image.beacon.repository | string | `""` |  |
| image.beacon.tag | string | `"multiarch-v25.9.2"` |  |
| image.execution.repository | string | `""` |  |
| image.execution.tag | string | `"1.34.0"` |  |
| image.imagePullPolicy | string | `"IfNotPresent"` |  |
| imagePullSecrets | list | `[]` |  |
| initImage.pullPolicy | string | `"IfNotPresent"` |  |
| initImage.repository | string | `"bitnamilegacy/kubectl"` |  |
| initImage.tag | string | `"1.32"` |  |
| metrics.annotations | object | `{}` |  |
| metrics.enabled | bool | `true` |  |
| metrics.prometheusRule.additionalLabels | object | `{}` |  |
| metrics.prometheusRule.default | bool | `true` |  |
| metrics.prometheusRule.namespace | string | `""` |  |
| metrics.prometheusRule.rules | list | `[]` |  |
| metrics.serviceMonitor.additionalLabels | object | `{}` |  |
| metrics.serviceMonitor.honorLabels | bool | `false` |  |
| metrics.serviceMonitor.interval | string | `"30s"` |  |
| metrics.serviceMonitor.metricRelabelings | list | `[]` |  |
| metrics.serviceMonitor.namespace | string | `""` |  |
| metrics.serviceMonitor.relabellings | list | `[]` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
| nameOverride | string | `""` |  |
| network | string | `"mainnet"` |  |
| nodeSelector | object | `{}` |  |
| p2pNodePort.annotations | object | `{}` |  |
| p2pNodePort.enabled | bool | `false` |  |
| p2pNodePort.replicaToNodePort | object | `{}` |  |
| p2pNodePort.startAtBeacon | int | `31200` |  |
| p2pNodePort.startAtExecution | int | `31100` |  |
| p2pNodePort.type | string | `"NodePort"` |  |
| priorityClassName | string | `""` |  |
| rbac.clusterRules[0].apiGroups[0] | string | `""` |  |
| rbac.clusterRules[0].resources[0] | string | `"nodes"` |  |
| rbac.clusterRules[0].verbs[0] | string | `"get"` |  |
| rbac.clusterRules[0].verbs[1] | string | `"list"` |  |
| rbac.clusterRules[0].verbs[2] | string | `"watch"` |  |
| rbac.create | bool | `true` |  |
| rbac.name | string | `""` |  |
| rbac.rules[0].apiGroups[0] | string | `""` |  |
| rbac.rules[0].resources[0] | string | `"services"` |  |
| rbac.rules[0].verbs[0] | string | `"get"` |  |
| rbac.rules[0].verbs[1] | string | `"list"` |  |
| rbac.rules[0].verbs[2] | string | `"watch"` |  |
| replicaCount | int | `1` |  |
| service.svcHeadless | bool | `true` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| sessionAffinity.enabled | bool | `false` |  |
| sessionAffinity.timeoutSeconds | int | `86400` |  |
| sharedPersistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| sharedPersistence.annotations | object | `{}` |  |
| sharedPersistence.enabled | bool | `false` |  |
| sharedPersistence.size | string | `"300Gi"` |  |
| sharedPersistence.storageClassName | string | `""` |  |
| terminationGracePeriodSeconds | int | `120` |  |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
