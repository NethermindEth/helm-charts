
# arbitrum-orbit-chain

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v3.6.8](https://img.shields.io/badge/AppVersion-v3.6.8-informational?style=flat-square)

A self-contained Helm chart for deploying Arbitrum Orbit L2 chain with Nitro node, Blockscout explorer and token bridge

**Homepage:** <https://github.com/NethermindEth/orbit-setup-script>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| nme-mvasylenko |  |  |

## Source Code

* <https://github.com/OffchainLabs/orbit-setup-script>
* <https://github.com/OffchainLabs/nitro>
* <https://github.com/blockscout/blockscout>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `3` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| blockscout.backend.image.repository | string | `"blockscout/blockscout-arbitrum"` |  |
| blockscout.backend.image.tag | string | `"6.5.0"` |  |
| blockscout.backend.replicaCount | int | `1` |  |
| blockscout.enabled | bool | `true` |  |
| blockscout.frontend.env.NEXT_PUBLIC_AD_BANNER_PROVIDER | string | `"none"` |  |
| blockscout.frontend.env.NEXT_PUBLIC_NETWORK_NAME | string | `"Arbitrum Local"` |  |
| blockscout.frontend.env.NEXT_PUBLIC_NETWORK_SHORT_NAME | string | `"Arbitrum Local"` |  |
| blockscout.frontend.image.repository | string | `"blockscout/frontend"` |  |
| blockscout.frontend.image.tag | string | `"v1.31.0"` |  |
| blockscout.frontend.replicaCount | int | `1` |  |
| blockscout.postgresql.auth.database | string | `"blockscout"` |  |
| blockscout.postgresql.auth.password | string | `""` |  |
| blockscout.postgresql.auth.username | string | `"blockscout"` |  |
| blockscout.postgresql.enabled | bool | `true` |  |
| blockscout.postgresql.primary.persistence.enabled | bool | `true` |  |
| blockscout.postgresql.primary.persistence.size | string | `"100Gi"` |  |
| blockscout.postgresql.storageClass | string | `""` |  |
| blockscout.redis.auth.enabled | bool | `false` |  |
| blockscout.redis.enabled | bool | `true` |  |
| blockscout.service.backend.port | int | `4000` |  |
| blockscout.service.frontend.port | int | `3000` |  |
| blockscout.service.type | string | `"ClusterIP"` |  |
| configMaps.nodeConfig | bool | `true` |  |
| configMaps.orbitSetupConfig | bool | `true` |  |
| configMaps.outputInfo | bool | `true` |  |
| das.enabled | bool | `false` |  |
| das.image.repository | string | `"offchainlabs/nitro-node"` |  |
| das.image.tag | string | `"v3.6.8"` |  |
| das.service.ports[0].name | string | `"das-rpc"` |  |
| das.service.ports[0].port | int | `9876` |  |
| das.service.ports[1].name | string | `"das-rest"` |  |
| das.service.ports[1].port | int | `9877` |  |
| das.service.type | string | `"ClusterIP"` |  |
| global.chainId | string | `"96975958395"` |  |
| global.chainName | string | `"BaasDev Arbitrum Orbit Chain 250806"` |  |
| global.domain | string | `"example.com"` |  |
| global.parentChainId | string | `"11155111"` |  |
| global.protocol | string | `"http"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/rewrite-target" | string | `"/"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/ssl-redirect" | string | `"false"` |  |
| ingress.className | string | `"nginx"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.hosts[0].host | string | `"192.168.1.100.sslip.io"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.hosts[0].paths[0].port | int | `3000` |  |
| ingress.hosts[0].paths[0].service | string | `"blockscout-frontend"` |  |
| ingress.hosts[0].paths[1].path | string | `"/api"` |  |
| ingress.hosts[0].paths[1].pathType | string | `"Prefix"` |  |
| ingress.hosts[0].paths[1].port | int | `4000` |  |
| ingress.hosts[0].paths[1].service | string | `"blockscout-backend"` |  |
| ingress.hosts[0].paths[2].path | string | `"/bridge"` |  |
| ingress.hosts[0].paths[2].pathType | string | `"Prefix"` |  |
| ingress.hosts[0].paths[2].port | int | `3000` |  |
| ingress.hosts[0].paths[2].service | string | `"token-bridge"` |  |
| ingress.hosts[0].paths[3].path | string | `"/rpc"` |  |
| ingress.hosts[0].paths[3].pathType | string | `"Prefix"` |  |
| ingress.hosts[0].paths[3].port | int | `8449` |  |
| ingress.hosts[0].paths[3].service | string | `"nitro"` |  |
| monitoring.enabled | bool | `false` |  |
| monitoring.prometheusRule.enabled | bool | `false` |  |
| monitoring.serviceMonitor.enabled | bool | `false` |  |
| networkPolicy.enabled | bool | `false` |  |
| nitro.additionalVolumeClaims | list | `[]` |  |
| nitro.affinity | object | `{}` |  |
| nitro.argsOverride | list | `[]` |  |
| nitro.blobPersistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| nitro.blobPersistence.enabled | bool | `false` |  |
| nitro.blobPersistence.size | string | `"100Gi"` |  |
| nitro.blobPersistence.storageClassName | string | `""` |  |
| nitro.commandOverride | list | `[]` |  |
| nitro.config.chain.id | int | `96975958395` |  |
| nitro.config.chain.info-json | object | `{}` |  |
| nitro.config.chain.name | string | `"My Custom Arbitrum Orbit Chain"` |  |
| nitro.config.conf.env_prefix | string | `"NITRO"` |  |
| nitro.config.execution.caching.archive | bool | `true` |  |
| nitro.config.execution.forwarding-target | string | `""` |  |
| nitro.config.execution.sequencer.enable | bool | `true` |  |
| nitro.config.execution.sequencer.max-block-speed | string | `"250ms"` |  |
| nitro.config.execution.sequencer.max-tx-data-size | int | `85000` |  |
| nitro.config.http.addr | string | `"0.0.0.0"` |  |
| nitro.config.http.api[0] | string | `"arb"` |  |
| nitro.config.http.api[1] | string | `"eth"` |  |
| nitro.config.http.api[2] | string | `"net"` |  |
| nitro.config.http.api[3] | string | `"web3"` |  |
| nitro.config.http.api[4] | string | `"txpool"` |  |
| nitro.config.http.api[5] | string | `"arbdebug"` |  |
| nitro.config.http.corsdomain | string | `"*"` |  |
| nitro.config.http.port | int | `8449` |  |
| nitro.config.http.rpcprefix | string | `"/rpc"` |  |
| nitro.config.http.vhosts | string | `"*"` |  |
| nitro.config.log-type | string | `"json"` |  |
| nitro.config.metrics | bool | `false` |  |
| nitro.config.metrics-server.addr | string | `"0.0.0.0"` |  |
| nitro.config.metrics-server.port | int | `6070` |  |
| nitro.config.node.batch-poster.enable | bool | `true` |  |
| nitro.config.node.batch-poster.max-delay | string | `"5m0s"` |  |
| nitro.config.node.batch-poster.max-size | int | `90000` |  |
| nitro.config.node.batch-poster.parent-chain-wallet.private-key | string | `""` |  |
| nitro.config.node.dangerous.disable-blob-reader | bool | `false` |  |
| nitro.config.node.dangerous.no-sequencer-coordinator | bool | `true` |  |
| nitro.config.node.delayed-sequencer.enable | bool | `true` |  |
| nitro.config.node.delayed-sequencer.finalize-distance | int | `1` |  |
| nitro.config.node.delayed-sequencer.use-merge-finality | bool | `false` |  |
| nitro.config.node.sequencer | bool | `true` |  |
| nitro.config.node.staker.enable | bool | `false` |  |
| nitro.config.node.staker.parent-chain-wallet.private-key | string | `""` |  |
| nitro.config.node.staker.strategy | string | `"MakeNodes"` |  |
| nitro.config.parent-chain.blob-client.beacon-url | string | `"https://ethereum-sepolia-beacon-api.publicnode.com"` |  |
| nitro.config.parent-chain.connection.url | string | `"https://ethereum-sepolia-rpc.publicnode.com"` |  |
| nitro.config.parent-chain.id | int | `11155111` |  |
| nitro.config.persistent.chain | string | `"/home/user/data/"` |  |
| nitro.config.validation.wasm.allowed-wasm-module-roots[0] | string | `"/home/user/nitro-legacy/machines"` |  |
| nitro.config.validation.wasm.allowed-wasm-module-roots[1] | string | `"/home/user/target/machines"` |  |
| nitro.config.ws.addr | string | `"0.0.0.0"` |  |
| nitro.config.ws.api[0] | string | `"net"` |  |
| nitro.config.ws.api[1] | string | `"web3"` |  |
| nitro.config.ws.api[2] | string | `"eth"` |  |
| nitro.config.ws.api[3] | string | `"arb"` |  |
| nitro.config.ws.port | int | `8548` |  |
| nitro.config.ws.rpcprefix | string | `"/ws"` |  |
| nitro.enabled | bool | `true` |  |
| nitro.env.goMaxProcs.enabled | bool | `false` |  |
| nitro.env.goMaxProcs.multiplier | int | `2` |  |
| nitro.env.goMemLimit.enabled | bool | `true` |  |
| nitro.env.goMemLimit.multiplier | float | `0.9` |  |
| nitro.extraArgs | list | `[]` |  |
| nitro.extraEnv | list | `[]` |  |
| nitro.extraPorts | list | `[]` |  |
| nitro.extraVolumeMounts | list | `[]` |  |
| nitro.extraVolumes | list | `[]` |  |
| nitro.headlessService.annotations | object | `{}` |  |
| nitro.headlessService.enabled | bool | `true` |  |
| nitro.headlessService.publishNotReadyAddresses | bool | `true` |  |
| nitro.image.pullPolicy | string | `"Always"` |  |
| nitro.image.repository | string | `"offchainlabs/nitro-node"` |  |
| nitro.image.tag | string | `"v3.6.8-d6c96a5"` |  |
| nitro.initContainers | list | `[]` |  |
| nitro.jwtSecret.enabled | bool | `false` |  |
| nitro.jwtSecret.value | string | `""` |  |
| nitro.lifecycle | object | `{}` |  |
| nitro.livenessProbe | object | `{}` |  |
| nitro.nodeSelector | object | `{}` |  |
| nitro.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| nitro.persistence.enabled | bool | `true` |  |
| nitro.persistence.size | string | `"500Gi"` |  |
| nitro.persistence.storageClassName | string | `""` |  |
| nitro.podAnnotations | object | `{}` |  |
| nitro.podLabels | object | `{}` |  |
| nitro.podSecurityContext.fsGroup | int | `1000` |  |
| nitro.podSecurityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` |  |
| nitro.podSecurityContext.runAsGroup | int | `1000` |  |
| nitro.podSecurityContext.runAsNonRoot | bool | `true` |  |
| nitro.podSecurityContext.runAsUser | int | `1000` |  |
| nitro.priorityClassName | string | `""` |  |
| nitro.readinessProbe | object | `{}` |  |
| nitro.replicaCount | int | `1` |  |
| nitro.resources.limits.cpu | string | `"2000m"` |  |
| nitro.resources.limits.memory | string | `"4Gi"` |  |
| nitro.resources.requests.cpu | string | `"1000m"` |  |
| nitro.resources.requests.memory | string | `"2Gi"` |  |
| nitro.securityContext | object | `{}` |  |
| nitro.service.annotations | object | `{}` |  |
| nitro.service.externalTrafficPolicy | string | `""` |  |
| nitro.service.extraPorts | list | `[]` |  |
| nitro.service.loadBalancerClass | string | `""` |  |
| nitro.service.loadBalancerIP | string | `""` |  |
| nitro.service.loadBalancerSourceRanges | list | `[]` |  |
| nitro.service.ports.http | int | `8449` |  |
| nitro.service.ports.metrics | int | `6070` |  |
| nitro.service.ports.ws | int | `8548` |  |
| nitro.service.publishNotReadyAddresses | bool | `false` |  |
| nitro.service.type | string | `"ClusterIP"` |  |
| nitro.serviceMonitor.additionalLabels | object | `{}` |  |
| nitro.serviceMonitor.enabled | bool | `false` |  |
| nitro.serviceMonitor.interval | string | `"5s"` |  |
| nitro.serviceMonitor.path | string | `"/debug/metrics/prometheus"` |  |
| nitro.serviceMonitor.portName | string | `"metrics"` |  |
| nitro.serviceMonitor.relabelings | list | `[]` |  |
| nitro.sidecars | list | `[]` |  |
| nitro.startupProbe.command | string | `""` |  |
| nitro.startupProbe.enabled | bool | `true` |  |
| nitro.startupProbe.failureThreshold | int | `2419200` |  |
| nitro.startupProbe.periodSeconds | int | `1` |  |
| nitro.tolerations | list | `[]` |  |
| nitro.updateStrategy.type | string | `"RollingUpdate"` |  |
| nitro.wallet.files | object | `{}` |  |
| nitro.wallet.mountPath | string | `"/wallet/"` |  |
| podDisruptionBudget.enabled | bool | `true` |  |
| podDisruptionBudget.minAvailable | int | `1` |  |
| secrets.batchPosterPrivateKey | string | `""` |  |
| secrets.blockscoutDbPassword | string | `""` |  |
| secrets.blockscoutSecretKeyBase | string | `""` |  |
| secrets.deployerPrivateKey | string | `""` |  |
| secrets.validatorPrivateKey | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tokenBridge.config.l1Bridge | string | `"0x6495661ffa6acceb439d3949c0eea0a16cb8c75c"` |  |
| tokenBridge.config.l1ChainId | int | `11155111` |  |
| tokenBridge.config.l1Router | string | `"0x6495661ffa6acceb439d3949c0eea0a16cb8c75c"` |  |
| tokenBridge.config.l1Rpc | string | `"https://ethereum-sepolia-rpc.publicnode.com"` |  |
| tokenBridge.config.l2Bridge | string | `"0x8D367789eDe2740Eb3C9504cf4676A1dB0Bd044a"` |  |
| tokenBridge.config.l2ChainId | int | `96975958395` |  |
| tokenBridge.config.l2Router | string | `"0x4eaab9164527ff540aec1c085ffa9f9347eeea46"` |  |
| tokenBridge.config.l2Rpc | string | `"http://nitro:8449"` |  |
| tokenBridge.config.l2WethGateway | string | `"0x5c3a12e500dac7c432a6014d75f76e07e1798e0a"` |  |
| tokenBridge.enabled | bool | `true` |  |
| tokenBridge.image.pullPolicy | string | `"Always"` |  |
| tokenBridge.image.repository | string | `"offchainlabs/arb-token-bridge"` |  |
| tokenBridge.image.tag | string | `"latest"` |  |
| tokenBridge.replicaCount | int | `1` |  |
| tokenBridge.resources.limits.cpu | string | `"500m"` |  |
| tokenBridge.resources.limits.memory | string | `"1Gi"` |  |
| tokenBridge.resources.requests.cpu | string | `"250m"` |  |
| tokenBridge.resources.requests.memory | string | `"512Mi"` |  |
| tokenBridge.service.port | int | `3000` |  |
| tokenBridge.service.type | string | `"ClusterIP"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
