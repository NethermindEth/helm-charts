# aztec-validator

![Version: 0.0.2](https://img.shields.io/badge/Version-0.0.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for deploying an Aztec validator

**Homepage:** <https://docs.aztec.network/>

## Installation

```bash
helm repo add nethermind https://nethermindeth.github.io/helm-charts
helm install aztec-validator nethermind/aztec-validator
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
| config.BOOTSTRAP_NODES | string | `"enr:-Jq4QO_3szmgtG2cbEdnFDIhpGAQkc1HwfNy4-M6sG9QmQbPTmp9PMOHR3xslfR23hORiU-GpA7uM9uXw49lFcnuuvYGjWF6dGVjX25ldHdvcmsBgmlkgnY0gmlwhCIwTIOJc2VjcDI1NmsxoQKQTN17XKCwjYSSwmTc-6YzCMhd3v6Ofl8TS-WunX6LCoN0Y3CCndCDdWRwgp3Q"` |  |
| config.COINBASE | string | `"0xbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"` |  |
| config.COIN_ISSUER_CONTRACT_ADDRESS | string | `"0xdc64a140aa3e981100a9beca4e685f962f0cf6c9"` |  |
| config.DATA_DIRECTORY | string | `"/local-data"` |  |
| config.DEBUG | string | `"aztec:*,-aztec:avm_simulator*,-aztec:circuits:artifact_hash,-aztec:libp2p_service,-json-rpc*,-aztec:world-state:database,-aztec:l2_block_stream*"` |  |
| config.ETHEREUM_HOST | string | `"http://34.48.76.131:8545"` |  |
| config.ETHEREUM_SLOT_DURATION | string | `"6sec"` |  |
| config.FEE_JUICE_CONTRACT_ADDRESS | string | `"0xe7f1725e7734ce288f8367e1bb143e90bb3f0512"` |  |
| config.FEE_JUICE_PORTAL_CONTRACT_ADDRESS | string | `"0x0165878a594ca255338adfa4d48449f69242eb8f"` |  |
| config.GOVERNANCE_CONTRACT_ADDRESS | string | `"0xcf7ed3acca5a467e9e704c703e8d87f634fb0fc9"` |  |
| config.GOVERNANCE_PROPOSER_CONTRACT_ADDRESS | string | `"0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0"` |  |
| config.INBOX_CONTRACT_ADDRESS | string | `"0xed179b78d5781f93eb169730d8ad1be7313123f4"` |  |
| config.L1_CHAIN_ID | string | `"1337"` |  |
| config.LOG_LEVEL | string | `"debug"` |  |
| config.OUTBOX_CONTRACT_ADDRESS | string | `"0x1016b5aaa3270a65c315c664ecb238b6db270b64"` |  |
| config.P2P_ENABLED | string | `"true"` |  |
| config.P2P_TCP_LISTEN_ADDR | string | `"0.0.0.0:40400"` |  |
| config.P2P_UDP_LISTEN_ADDR | string | `"0.0.0.0:40400"` |  |
| config.PROVER_REAL_PROOFS | string | `"true"` |  |
| config.PXE_PROVER_ENABLED | string | `"true"` |  |
| config.REGISTRY_CONTRACT_ADDRESS | string | `"0x5fbdb2315678afecb367f032d93f642f64180aa3"` |  |
| config.REWARD_DISTRIBUTOR_CONTRACT_ADDRESS | string | `"0x5fc8d32690cc91d4c39d9d3abcbd16989f875707"` |  |
| config.ROLLUP_CONTRACT_ADDRESS | string | `"0x2279b7a0a67db372996a5fab50d91eaa73d2ebe6"` |  |
| config.VALIDATOR_DISABLED | string | `"false"` |  |
| env | list | `[]` |  |
| envFrom | list | `[]` |  |
| extraInitContainers | list | `[]` |  |
| extraObjects | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"aztecprotocol/aztec"` |  |
| image.tag | string | `"698cd3d62680629a3f1bfc0f82604534cedbccf3-x86_64"` |  |
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
