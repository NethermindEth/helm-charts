
# pluto-relay

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

A Helm chart for the Pluto libp2p circuit relay (https://github.com/NethermindEth/pluto)

**Homepage:** <https://github.com/NethermindEth/pluto>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| nethermind-devops |  |  |

## Source Code

* <https://github.com/NethermindEth/pluto>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| HTTPRoute.annotations | object | `{}` |  |
| HTTPRoute.enabled | bool | `false` |  |
| HTTPRoute.hostnames | list | `[]` |  |
| HTTPRoute.parentRefs | list | `[]` |  |
| HTTPRoute.rules | list | `[]` |  |
| affinity | object | `{}` |  |
| antiAffinityPreset | string | `"soft"` |  |
| args | list | `[]` |  |
| command[0] | string | `"relay"` |  |
| config.CHARON_DATA_DIR | string | `"/data"` |  |
| config.PLUTO_AUTO_P2PKEY | string | `"true"` |  |
| config.PLUTO_HTTP_ADDRESS | string | `"0.0.0.0:3640"` |  |
| config.PLUTO_LOG_FORMAT | string | `"json"` |  |
| config.PLUTO_LOG_LEVEL | string | `"info"` |  |
| config.PLUTO_MONITORING_ADDRESS | string | `"0.0.0.0:3620"` |  |
| config.PLUTO_P2P_ADVERTISE_PRIVATE_ADDRESSES | string | `"false"` |  |
| config.PLUTO_P2P_MAX_CONNECTIONS | string | `"16384"` |  |
| config.PLUTO_P2P_MAX_RESERVATIONS | string | `"512"` |  |
| config.PLUTO_P2P_RELAY_LOGLEVEL | string | `"info"` |  |
| extraContainers | list | `[]` |  |
| extraInitScript | string | `"exit 0\n"` |  |
| fullnameOverride | string | `""` |  |
| hostnamePattern | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"nethermindeth/pluto"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| initContainerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| initContainerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| initContainerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| initContainerSecurityContext.runAsGroup | int | `1000` |  |
| initContainerSecurityContext.runAsNonRoot | bool | `true` |  |
| initContainerSecurityContext.runAsUser | int | `1000` |  |
| initContainers | list | `[]` |  |
| initScript | string | `"#!/usr/bin/env bash\nset -euo pipefail\necho \"Init: pod=${POD_NAME} node=${NODE_NAME}\"\ntouch /shared/env\n\nREPLICA_INDEX=$(echo \"${POD_NAME}\" | awk -F'-' '{print $NF}')\nP2P_PORT=$((BASE_PORT + REPLICA_INDEX))\n\nEXTERNAL_NODE_IP=$(kubectl get node \"${NODE_NAME}\" -o jsonpath='{.status.addresses[?(@.type==\"ExternalIP\")].address}' 2>/dev/null || echo \"\")\n\nEXTERNAL_HOSTNAME=\"\"\nif [ -n \"${HOSTNAME_PATTERN:-}\" ]; then\n  EXTERNAL_HOSTNAME=$(echo \"${HOSTNAME_PATTERN}\" | sed \"s/{i}/${REPLICA_INDEX}/g\")\nfi\n\necho \"REPLICA_INDEX=${REPLICA_INDEX}\"\necho \"P2P_PORT=${P2P_PORT}\"\necho \"EXTERNAL_NODE_IP=${EXTERNAL_NODE_IP}\"\necho \"EXTERNAL_HOSTNAME=${EXTERNAL_HOSTNAME}\"\n\n{\n  echo \"export REPLICA_INDEX=${REPLICA_INDEX}\"\n  echo \"export EXTERNAL_NODE_IP=${EXTERNAL_NODE_IP}\"\n  echo \"export PLUTO_P2P_TCP_ADDRESS=0.0.0.0:${P2P_PORT}\"\n  echo \"export PLUTO_P2P_UDP_ADDRESS=0.0.0.0:${P2P_PORT}\"\n  if [ -n \"${EXTERNAL_HOSTNAME}\" ]; then\n    echo \"export PLUTO_P2P_EXTERNAL_HOSTNAME=${EXTERNAL_HOSTNAME}\"\n  fi\n} >> /shared/env\n"` |  |
| livenessProbe.failureThreshold | int | `5` |  |
| livenessProbe.httpGet.path | string | `"/"` |  |
| livenessProbe.httpGet.port | string | `"http"` |  |
| livenessProbe.initialDelaySeconds | int | `30` |  |
| livenessProbe.periodSeconds | int | `30` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| p2p.annotations | object | `{}` |  |
| p2p.basePort | int | `32610` |  |
| p2p.enabled | bool | `true` |  |
| p2p.serviceType | string | `"NodePort"` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `true` |  |
| persistence.mountPath | string | `"/data"` |  |
| persistence.size | string | `"1Gi"` |  |
| persistence.storageClassName | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podDisruptionBudget.enabled | bool | `false` |  |
| podDisruptionBudget.minAvailable | int | `1` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.fsGroup | int | `1000` |  |
| podSecurityContext.runAsGroup | int | `1000` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `1000` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.httpGet.path | string | `"/"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| readinessProbe.initialDelaySeconds | int | `10` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsGroup | int | `1000` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| service.ports[0].name | string | `"http"` |  |
| service.ports[0].port | int | `3640` |  |
| service.ports[0].protocol | string | `"TCP"` |  |
| service.ports[1].name | string | `"metrics"` |  |
| service.ports[1].port | int | `3620` |  |
| service.ports[1].protocol | string | `"TCP"` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| serviceMonitor.annotations | object | `{}` |  |
| serviceMonitor.enabled | bool | `true` |  |
| serviceMonitor.interval | string | `"30s"` |  |
| serviceMonitor.labels | object | `{}` |  |
| serviceMonitor.metricRelabelings | list | `[]` |  |
| serviceMonitor.namespace | string | `nil` |  |
| serviceMonitor.path | string | `"/metrics"` |  |
| serviceMonitor.port | string | `"metrics"` |  |
| serviceMonitor.relabelings | list | `[]` |  |
| serviceMonitor.scheme | string | `"http"` |  |
| serviceMonitor.scrapeTimeout | string | `"10s"` |  |
| serviceMonitor.tlsConfig | object | `{}` |  |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
