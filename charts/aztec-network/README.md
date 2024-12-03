
# aztec-network

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

A Helm chart for deploying the aztec network

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 0xDones |  |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aztec.epochDuration | int | `16` |  |
| aztec.epochProofClaimWindow | int | `13` |  |
| aztec.slotDuration | int | `24` |  |
| bootNode.coinbaseAddress | string | `"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"` |  |
| bootNode.contracts.feeJuiceAddress | string | `""` |  |
| bootNode.contracts.feeJuicePortalAddress | string | `""` |  |
| bootNode.contracts.inboxAddress | string | `""` |  |
| bootNode.contracts.outboxAddress | string | `""` |  |
| bootNode.contracts.registryAddress | string | `""` |  |
| bootNode.contracts.rollupAddress | string | `""` |  |
| bootNode.debug | string | `"aztec:*,-aztec:avm_simulator*,-aztec:libp2p_service*,-aztec:circuits:artifact_hash,-json-rpc*,-aztec:world-state:database,-aztec:l2_block_stream*"` |  |
| bootNode.deployContracts | bool | `true` |  |
| bootNode.externalHost | string | `""` |  |
| bootNode.logLevel | string | `"debug"` |  |
| bootNode.p2p.enabled | string | `"true"` |  |
| bootNode.realProofs | bool | `false` |  |
| bootNode.replicas | int | `1` |  |
| bootNode.resources.requests.cpu | string | `"200m"` |  |
| bootNode.resources.requests.memory | string | `"2Gi"` |  |
| bootNode.sequencer.maxSecondsBetweenBlocks | int | `0` |  |
| bootNode.sequencer.minTxsPerBlock | int | `1` |  |
| bootNode.service.nodePort | int | `8080` |  |
| bootNode.service.p2pTcpPort | int | `40400` |  |
| bootNode.service.p2pUdpPort | int | `40400` |  |
| bootNode.startupProbe.failureThreshold | int | `120` |  |
| bootNode.startupProbe.periodSeconds | int | `10` |  |
| bootNode.storage | string | `"8Gi"` |  |
| bootNode.validator.disabled | bool | `true` |  |
| bot.botNoStart | bool | `false` |  |
| bot.botPrivateKey | string | `"0xcafe"` |  |
| bot.debug | string | `"aztec:*,-aztec:avm_simulator*,-aztec:libp2p_service*,-aztec:circuits:artifact_hash,-json-rpc*,-aztec:l2_block_stream,-aztec:world-state:database"` |  |
| bot.enabled | bool | `true` |  |
| bot.followChain | string | `"NONE"` |  |
| bot.logLevel | string | `"debug"` |  |
| bot.maxErrors | int | `3` |  |
| bot.nodeUrl | string | `""` |  |
| bot.privateTransfersPerTx | int | `0` |  |
| bot.proverRealProofs | bool | `false` |  |
| bot.publicTransfersPerTx | int | `1` |  |
| bot.pxeProverEnabled | bool | `false` |  |
| bot.readinessProbe.failureThreshold | int | `3` |  |
| bot.readinessProbe.initialDelaySeconds | int | `5` |  |
| bot.readinessProbe.periodSeconds | int | `10` |  |
| bot.readinessProbe.successThreshold | int | `1` |  |
| bot.readinessProbe.timeoutSeconds | int | `5` |  |
| bot.replicas | int | `1` |  |
| bot.resources.requests.cpu | string | `"200m"` |  |
| bot.resources.requests.memory | string | `"2Gi"` |  |
| bot.service.nodePort | int | `8082` |  |
| bot.service.type | string | `"ClusterIP"` |  |
| bot.stopIfUnhealthy | bool | `true` |  |
| bot.txIntervalSeconds | int | `24` |  |
| ethereum.args | string | `""` |  |
| ethereum.blockTime | string | `"12sec"` |  |
| ethereum.chainId | int | `1337` |  |
| ethereum.externalHost | string | `""` |  |
| ethereum.gasLimit | string | `"1000000000"` |  |
| ethereum.readinessProbe.failureThreshold | int | `3` |  |
| ethereum.readinessProbe.initialDelaySeconds | int | `5` |  |
| ethereum.readinessProbe.periodSeconds | int | `10` |  |
| ethereum.readinessProbe.successThreshold | int | `1` |  |
| ethereum.readinessProbe.timeoutSeconds | int | `5` |  |
| ethereum.replicas | int | `1` |  |
| ethereum.resources.requests.cpu | string | `"200m"` |  |
| ethereum.resources.requests.memory | string | `"2Gi"` |  |
| ethereum.service.nodePort | string | `""` |  |
| ethereum.service.port | int | `8545` |  |
| ethereum.service.targetPort | int | `8545` |  |
| ethereum.service.type | string | `"ClusterIP"` |  |
| ethereum.storage | string | `"80Gi"` |  |
| fullnameOverride | string | `""` |  |
| images.aztec.image | string | `"aztecprotocol/aztec"` |  |
| images.aztec.pullPolicy | string | `"IfNotPresent"` |  |
| images.curl.image | string | `"curlimages/curl:7.81.0"` |  |
| images.curl.pullPolicy | string | `"IfNotPresent"` |  |
| images.foundry.image | string | `"ghcr.io/foundry-rs/foundry@sha256:ce4b236f6760fdeb08e82267c9fa17647d29a374760bfe7ee01998fb8c0aaad7"` |  |
| images.foundry.pullPolicy | string | `"IfNotPresent"` |  |
| images.reth.image | string | `"ghcr.io/paradigmxyz/reth:v1.0.8"` |  |
| images.reth.pullPolicy | string | `"IfNotPresent"` |  |
| jobs.deployL1Verifier.enable | bool | `false` |  |
| nameOverride | string | `""` |  |
| network.public | bool | `false` |  |
| network.setupL2Contracts | bool | `true` |  |
| proverAgent.bb.hardwareConcurrency | string | `""` |  |
| proverAgent.debug | string | `"aztec:*,-aztec:avm_simulator*,-aztec:libp2p_service*,-aztec:circuits:artifact_hash,-json-rpc*,-aztec:world-state:database,-aztec:l2_block_stream*"` |  |
| proverAgent.enabled | bool | `true` |  |
| proverAgent.gke.spotEnabled | bool | `false` |  |
| proverAgent.logLevel | string | `"debug"` |  |
| proverAgent.nodeSelector | object | `{}` |  |
| proverAgent.pollIntervalMs | int | `1000` |  |
| proverAgent.proofTypes[0] | string | `"foo"` |  |
| proverAgent.proofTypes[1] | string | `"bar"` |  |
| proverAgent.proofTypes[2] | string | `"baz"` |  |
| proverAgent.realProofs | bool | `false` |  |
| proverAgent.replicas | int | `1` |  |
| proverAgent.resources | object | `{}` |  |
| proverAgent.service.nodePort | int | `8083` |  |
| proverBroker.dataDirectory | string | `""` |  |
| proverBroker.debug | string | `"aztec:*,-aztec:avm_simulator*,-aztec:libp2p_service*,-aztec:circuits:artifact_hash,-json-rpc*,-aztec:world-state:database,-aztec:l2_block_stream*"` |  |
| proverBroker.enabled | bool | `true` |  |
| proverBroker.jobMaxRetries | int | `3` |  |
| proverBroker.jobTimeoutMs | int | `30000` |  |
| proverBroker.logLevel | string | `"debug"` |  |
| proverBroker.nodeSelector | object | `{}` |  |
| proverBroker.pollIntervalMs | int | `1000` |  |
| proverBroker.replicas | int | `1` |  |
| proverBroker.resources | object | `{}` |  |
| proverBroker.service.nodePort | int | `8084` |  |
| proverNode.affinity | object | `{}` |  |
| proverNode.debug | string | `"aztec:*,-aztec:avm_simulator*,-aztec:libp2p_service*,-aztec:circuits:artifact_hash,-json-rpc*,-aztec:world-state:database,-aztec:l2_block_stream*"` |  |
| proverNode.externalHost | string | `""` |  |
| proverNode.logLevel | string | `"debug"` |  |
| proverNode.nodeSelector | object | `{}` |  |
| proverNode.p2pEnabled | bool | `true` |  |
| proverNode.proverAgent.count | int | `0` |  |
| proverNode.proverAgent.pollIntervalMs | int | `1000` |  |
| proverNode.proverAgent.proofTypes | list | `[]` |  |
| proverNode.proverBroker.dataDirectory | string | `""` |  |
| proverNode.proverBroker.enabled | bool | `false` |  |
| proverNode.proverBroker.jobMaxRetries | int | `3` |  |
| proverNode.proverBroker.jobTimeoutMs | int | `30000` |  |
| proverNode.proverBroker.pollIntervalMs | int | `1000` |  |
| proverNode.realProofs | bool | `false` |  |
| proverNode.replicas | int | `1` |  |
| proverNode.resources.requests.cpu | string | `"200m"` |  |
| proverNode.resources.requests.memory | string | `"2Gi"` |  |
| proverNode.service.nodePort | int | `8080` |  |
| proverNode.service.p2pTcpPort | int | `40400` |  |
| proverNode.service.p2pUdpPort | int | `40400` |  |
| proverNode.storage | string | `"8Gi"` |  |
| proverNode.tolerations | list | `[]` |  |
| pxe.debug | string | `"aztec:*,-aztec:avm_simulator*,-aztec:libp2p_service*,-aztec:circuits:artifact_hash,-json-rpc*,-aztec:world-state:database,-aztec:l2_block_stream*"` |  |
| pxe.logLevel | string | `"debug"` |  |
| pxe.proverEnable | bool | `false` |  |
| pxe.proverEnabled | bool | `false` |  |
| pxe.readinessProbe.failureThreshold | int | `3` |  |
| pxe.readinessProbe.initialDelaySeconds | int | `5` |  |
| pxe.readinessProbe.periodSeconds | int | `10` |  |
| pxe.readinessProbe.successThreshold | int | `1` |  |
| pxe.readinessProbe.timeoutSeconds | int | `5` |  |
| pxe.replicas | int | `1` |  |
| pxe.resources.requests.cpu | string | `"200m"` |  |
| pxe.resources.requests.memory | string | `"2Gi"` |  |
| pxe.service.nodePort | int | `8081` |  |
| telemetry.enabled | bool | `false` |  |
| telemetry.otelCollectorEndpoint | string | `nil` |  |
| validator.affinity | object | `{}` |  |
| validator.debug | string | `"aztec:*,-aztec:avm_simulator*,-aztec:libp2p_service*,-aztec:circuits:artifact_hash,-json-rpc*,-aztec:world-state:database,-aztec:l2_block_stream*"` |  |
| validator.dynamicBootNode | bool | `false` |  |
| validator.logLevel | string | `"debug"` |  |
| validator.nodeSelector | object | `{}` |  |
| validator.p2p.enabled | string | `"true"` |  |
| validator.replicas | int | `1` |  |
| validator.resources.requests.cpu | string | `"200m"` |  |
| validator.resources.requests.memory | string | `"2Gi"` |  |
| validator.sequencer.enforceTimeTable | bool | `true` |  |
| validator.sequencer.maxSecondsBetweenBlocks | int | `0` |  |
| validator.sequencer.maxTxsPerBlock | int | `4` |  |
| validator.sequencer.minTxsPerBlock | int | `1` |  |
| validator.service.nodePort | int | `8080` |  |
| validator.service.p2pTcpPort | int | `40400` |  |
| validator.service.p2pUdpPort | int | `40400` |  |
| validator.startupProbe.failureThreshold | int | `120` |  |
| validator.startupProbe.periodSeconds | int | `10` |  |
| validator.tolerations | list | `[]` |  |
| validator.validator.disabled | bool | `false` |  |
| validator.validator.reexecute | bool | `true` |  |
| validator.validatorAddresses | list | `[]` |  |
| validator.validatorKeys | list | `[]` |  |
| validator.validatorKeysSecret | string | `""` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)