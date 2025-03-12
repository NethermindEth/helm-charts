# aztec-sequencer

![Version: 0.0.4](https://img.shields.io/badge/Version-0.0.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for deploying an Aztec sequencer

**Homepage:** <https://docs.aztec.network/>

## Installation

```bash
helm repo add nethermind https://nethermindeth.github.io/helm-charts
helm install aztec-sequencer nethermind/aztec-sequencer
```

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 0xDones |  |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| args[0] | string | `"start"` |  |
| args[1] | string | `"--node"` |  |
| args[2] | string | `"--archiver"` |  |
| args[3] | string | `"--sequencer"` |  |
| config.AZTEC_EPOCH_DURATION | string | `"32"` |  |
| config.AZTEC_EPOCH_PROOF_CLAIM_WINDOW_IN_L2_SLOTS | string | `"13"` |  |
| config.AZTEC_PORT | string | `"8080"` |  |
| config.AZTEC_SLOT_DURATION | string | `"36"` |  |
| config.BOOTSTRAP_NODES | string | `""` |  |
| config.COINBASE | string | `"0xbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"` |  |
| config.COIN_ISSUER_CONTRACT_ADDRESS | string | `""` |  |
| config.DATA_DIRECTORY | string | `"/local-data"` |  |
| config.DEBUG | string | `"aztec:*,-aztec:avm_simulator*,-aztec:circuits:artifact_hash,-aztec:libp2p_service,-json-rpc*,-aztec:world-state:database,-aztec:l2_block_stream*"` |  |
| config.ETHEREUM_HOST | string | `""` |  |
| config.ETHEREUM_SLOT_DURATION | string | `"6sec"` |  |
| config.FEE_JUICE_CONTRACT_ADDRESS | string | `""` |  |
| config.FEE_JUICE_PORTAL_CONTRACT_ADDRESS | string | `""` |  |
| config.GOVERNANCE_CONTRACT_ADDRESS | string | `""` |  |
| config.GOVERNANCE_PROPOSER_CONTRACT_ADDRESS | string | `""` |  |
| config.INBOX_CONTRACT_ADDRESS | string | `""` |  |
| config.L1_CHAIN_ID | string | `"1337"` |  |
| config.LOG_LEVEL | string | `"debug"` |  |
| config.OUTBOX_CONTRACT_ADDRESS | string | `""` |  |
| config.P2P_ENABLED | string | `"true"` |  |
| config.P2P_TCP_LISTEN_ADDR | string | `"0.0.0.0:40400"` |  |
| config.P2P_UDP_LISTEN_ADDR | string | `"0.0.0.0:40400"` |  |
| config.PROVER_REAL_PROOFS | string | `"true"` |  |
| config.PXE_PROVER_ENABLED | string | `"true"` |  |
| config.REGISTRY_CONTRACT_ADDRESS | string | `""` |  |
| config.REWARD_DISTRIBUTOR_CONTRACT_ADDRESS | string | `""` |  |
| config.ROLLUP_CONTRACT_ADDRESS | string | `""` |  |
| config.VALIDATOR_DISABLED | string | `"false"` |  |
| env | list | `[]` |  |
| envFrom | list | `[]` |  |
| extraInitContainers | list | `[]` |  |
| extraInitScript | string | `"echo \"Running extra init commands...\"\necho \"Done\"\n"` |  |
| extraObjects | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"aztecprotocol/aztec"` |  |
| image.tag | string | `"0.67.1"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| initContainer.image.repository | string | `"bitnami/kubectl"` |  |
| initContainer.image.tag | float | `1.28` |  |
| initContainer.volumeMounts | list | `[]` |  |
| initContainerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| initContainerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| initContainerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| initContainerSecurityContext.runAsGroup | int | `1000` |  |
| initContainerSecurityContext.runAsNonRoot | bool | `true` |  |
| initContainerSecurityContext.runAsUser | int | `1000` |  |
| initContainerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| livenessProbe | string | `nil` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.enabled | bool | `false` |  |
| persistence.mountPath | string | `"/data"` |  |
| persistence.size | string | `"50Gi"` |  |
| persistence.storageClass | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.fsGroup | int | `1000` |  |
| podSecurityContext.runAsGroup | int | `1000` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `1000` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| rbac.create | bool | `true` |  |
| readinessProbe | string | `nil` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsGroup | int | `1000` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| service.internalServiceType | string | `"ClusterIP"` |  |
| service.ports.http | int | `8080` |  |
| service.ports.p2p | int | `40400` |  |
| service.type | string | `"NodePort"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
| validatorKeysSecret | string | `"aztec-validator-keys"` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
