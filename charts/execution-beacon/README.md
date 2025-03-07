
# execution-beacon

![Version: 1.0.8](https://img.shields.io/badge/Version-1.0.8-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.1](https://img.shields.io/badge/AppVersion-0.0.1-informational?style=flat-square)

A Helm chart for deploying Ethereum execution and consensus clients

**Homepage:** <https://www.ethereum.org/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 0xDones |  |  |
| matilote |  |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../common | common | 1.0.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
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
| beacon.metrics.categories[10] | string | `"REMOTE_VALIDATOR"` |  |
| beacon.metrics.categories[11] | string | `"VALIDATOR"` |  |
| beacon.metrics.categories[12] | string | `"VALIDATOR_PERFORMANCE"` |  |
| beacon.metrics.categories[1] | string | `"PROCESS"` |  |
| beacon.metrics.categories[2] | string | `"BEACON"` |  |
| beacon.metrics.categories[3] | string | `"DISCOVERY"` |  |
| beacon.metrics.categories[4] | string | `"EVENTBUS"` |  |
| beacon.metrics.categories[5] | string | `"EXECUTOR"` |  |
| beacon.metrics.categories[6] | string | `"NETWORK"` |  |
| beacon.metrics.categories[7] | string | `"STORAGE"` |  |
| beacon.metrics.categories[8] | string | `"STORAGE_HOT_DB"` |  |
| beacon.metrics.categories[9] | string | `"STORAGE_FINALIZED_DB"` |  |
| beacon.metrics.enabled | bool | `true` |  |
| beacon.metrics.host | string | `"0.0.0.0"` |  |
| beacon.metrics.hostAllowList[0] | string | `"*"` |  |
| beacon.metrics.port | int | `9090` |  |
| beacon.metrics.prometheusRule.enabled | bool | `true` |  |
| beacon.metrics.serviceMonitor.enabled | bool | `true` |  |
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
| execution.client | string | `"nethermind"` |  |
| execution.env | list | `[]` |  |
| execution.envFrom | list | `[]` |  |
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
| execution.jsonrpc.grpc.port | int | `9090` |  |
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
| execution.jsonrpc.websocket.enabled | bool | `true` |  |
| execution.jsonrpc.websocket.origins | string | `"*"` |  |
| execution.jsonrpc.websocket.port | int | `8546` |  |
| execution.metrics.enabled | bool | `true` |  |
| execution.metrics.host | string | `"0.0.0.0"` |  |
| execution.metrics.port | int | `8008` |  |
| execution.metrics.prometheusRule.enabled | bool | `true` |  |
| execution.metrics.serviceMonitor.enabled | bool | `true` |  |
| execution.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| execution.persistence.annotations | object | `{}` |  |
| execution.persistence.enabled | bool | `true` |  |
| execution.persistence.size | string | `"100Gi"` |  |
| execution.persistence.storageClassName | string | `""` |  |
| execution.privateApiAddr | string | `"127.0.0.1:9090"` |  |
| execution.resources | object | `{}` |  |
| execution.targetPeers | int | `50` |  |
| execution.terminalTotalDifficulty | string | `""` |  |
| execution.volumeMounts | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.JWTSecret | string | `""` |  |
| global.affinity | object | `{}` |  |
| global.env | list | `[]` |  |
| global.envFrom | list | `[]` |  |
| global.ethsider.bindAddr | int | `3000` |  |
| global.ethsider.enabled | bool | `true` |  |
| global.ethsider.livenessProbe.enabled | bool | `false` |  |
| global.ethsider.livenessProbe.failureThreshold | int | `3` |  |
| global.ethsider.livenessProbe.httpGet.path | string | `"/liveness"` |  |
| global.ethsider.livenessProbe.httpGet.port | string | `"sidecar"` |  |
| global.ethsider.livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| global.ethsider.livenessProbe.initialDelaySeconds | int | `10` |  |
| global.ethsider.livenessProbe.periodSeconds | int | `1` |  |
| global.ethsider.livenessProbe.successThreshold | int | `3` |  |
| global.ethsider.livenessProbe.timeoutSeconds | int | `3` |  |
| global.ethsider.pullPolicy | string | `"IfNotPresent"` |  |
| global.ethsider.readinessProbe.enabled | bool | `true` |  |
| global.ethsider.readinessProbe.failureThreshold | int | `3` |  |
| global.ethsider.readinessProbe.httpGet.path | string | `"/readiness"` |  |
| global.ethsider.readinessProbe.httpGet.port | string | `"sidecar"` |  |
| global.ethsider.readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| global.ethsider.readinessProbe.initialDelaySeconds | int | `10` |  |
| global.ethsider.readinessProbe.periodSeconds | int | `1` |  |
| global.ethsider.readinessProbe.successThreshold | int | `3` |  |
| global.ethsider.readinessProbe.timeoutSeconds | int | `3` |  |
| global.ethsider.repository | string | `"nethermindeth/ethsider"` |  |
| global.ethsider.tag | string | `"v1.0.0"` |  |
| global.externalSecrets.data | list | `[]` |  |
| global.externalSecrets.enabled | bool | `false` |  |
| global.externalSecrets.secretStoreRef.kind | string | `"SecretStore"` |  |
| global.externalSecrets.secretStoreRef.name | string | `"secretStoreRef"` |  |
| global.image.beacon.lighthouse.repository | string | `"sigp/lighthouse"` |  |
| global.image.beacon.lighthouse.tag | string | `"v4.5.0"` |  |
| global.image.beacon.lodestar.repository | string | `"chainsafe/lodestar"` |  |
| global.image.beacon.lodestar.tag | string | `"v1.12.1"` |  |
| global.image.beacon.nimbus.repository | string | `"statusim/nimbus-eth2"` |  |
| global.image.beacon.nimbus.tag | string | `"multiarch-v23.11.0"` |  |
| global.image.beacon.prysm.repository | string | `"gcr.io/prylabs-dev/prysm/beacon-chain"` |  |
| global.image.beacon.prysm.tag | string | `"v4.1.1"` |  |
| global.image.beacon.teku.repository | string | `"consensys/teku"` |  |
| global.image.beacon.teku.tag | string | `"23.12.1"` |  |
| global.image.execution.bseu.repository | string | `"hyperledger/besu"` |  |
| global.image.execution.bseu.tag | string | `"23.10.2"` |  |
| global.image.execution.erigon.repository | string | `"thorax/erigon"` |  |
| global.image.execution.erigon.tag | string | `"v2.54.0"` |  |
| global.image.execution.geth.repository | string | `"ethereum/client-go"` |  |
| global.image.execution.geth.tag | string | `"v1.13.5"` |  |
| global.image.execution.nethermind.repository | string | `"nethermind/nethermind"` |  |
| global.image.execution.nethermind.tag | string | `"1.24.0"` |  |
| global.image.imagePullPolicy | string | `"IfNotPresent"` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.initImage.pullPolicy | string | `"IfNotPresent"` |  |
| global.initImage.repository | string | `"bitnami/kubectl"` |  |
| global.initImage.tag | string | `"1.28"` |  |
| global.metrics.annotations | object | `{}` |  |
| global.metrics.enabled | bool | `true` |  |
| global.metrics.prometheusRule.additionalLabels | object | `{}` |  |
| global.metrics.prometheusRule.default | bool | `true` |  |
| global.metrics.prometheusRule.namespace | string | `""` |  |
| global.metrics.prometheusRule.rules | list | `[]` |  |
| global.metrics.serviceMonitor.additionalLabels | object | `{}` |  |
| global.metrics.serviceMonitor.honorLabels | bool | `false` |  |
| global.metrics.serviceMonitor.interval | string | `"30s"` |  |
| global.metrics.serviceMonitor.metricRelabelings | list | `[]` |  |
| global.metrics.serviceMonitor.namespace | string | `""` |  |
| global.metrics.serviceMonitor.relabellings | list | `[]` |  |
| global.metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
| global.network | string | `"mainnet"` |  |
| global.nodeSelector | object | `{}` |  |
| global.p2pNodePort.annotations | object | `{}` |  |
| global.p2pNodePort.enabled | bool | `false` |  |
| global.p2pNodePort.replicaToNodePort | object | `{}` |  |
| global.p2pNodePort.startAtBeacon | int | `31200` |  |
| global.p2pNodePort.startAtExecution | int | `31100` |  |
| global.p2pNodePort.type | string | `"NodePort"` |  |
| global.priorityClassName | string | `""` |  |
| global.rbac.create | bool | `true` |  |
| global.replicaCount | int | `1` |  |
| global.service.svcHeadless | bool | `true` |  |
| global.serviceAccount.create | bool | `true` |  |
| global.sessionAffinity.enabled | bool | `false` |  |
| global.sessionAffinity.timeoutSeconds | int | `86400` |  |
| global.sharedPersistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| global.sharedPersistence.annotations | object | `{}` |  |
| global.sharedPersistence.enabled | bool | `false` |  |
| global.sharedPersistence.size | string | `"300Gi"` |  |
| global.sharedPersistence.storageClassName | string | `""` |  |
| global.terminationGracePeriodSeconds | int | `120` |  |
| global.tolerations | list | `[]` |  |
| global.volumes | list | `[]` |  |
| initContainerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| initContainerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| initContainerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| initContainerSecurityContext.runAsGroup | int | `1000` |  |
| initContainerSecurityContext.runAsNonRoot | bool | `true` |  |
| initContainerSecurityContext.runAsUser | int | `1000` |  |
| initContainerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| nameOverride | string | `""` |  |
| podSecurityContext.fsGroup | int | `1000` |  |
| podSecurityContext.runAsGroup | int | `1000` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `1000` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| rbac.clusterRules[0].apiGroups[0] | string | `""` |  |
| rbac.clusterRules[0].resources[0] | string | `"nodes"` |  |
| rbac.clusterRules[0].verbs[0] | string | `"get"` |  |
| rbac.clusterRules[0].verbs[1] | string | `"list"` |  |
| rbac.clusterRules[0].verbs[2] | string | `"watch"` |  |
| rbac.name | string | `""` |  |
| rbac.rules[0].apiGroups[0] | string | `""` |  |
| rbac.rules[0].resources[0] | string | `"services"` |  |
| rbac.rules[0].verbs[0] | string | `"get"` |  |
| rbac.rules[0].verbs[1] | string | `"list"` |  |
| rbac.rules[0].verbs[2] | string | `"watch"` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsGroup | int | `1000` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.name | string | `""` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
