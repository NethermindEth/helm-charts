
# validators

![Version: 1.0.9](https://img.shields.io/badge/Version-1.0.9-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.0.8](https://img.shields.io/badge/AppVersion-v0.0.8-informational?style=flat-square)

A Helm chart for installing validators with the web3signer.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| aivarasko |  |  |
| matilote |  |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| beaconChainRpcEndpoints | list | `[]` |  |
| beaconChainRpcEndpointsRandomized | list | `[]` |  |
| cliImage.pullPolicy | string | `"IfNotPresent"` |  |
| cliImage.repository | string | `"nethermindeth/keystores-cli"` |  |
| cliImage.tag | string | `"v1.0.11"` |  |
| dvt.enabled | bool | `false` |  |
| enableBuilder | bool | `false` |  |
| enabled | bool | `true` |  |
| env | list | `[]` |  |
| envFrom | list | `[]` | envFrom configuration |
| extraFlags.lighthouse | list | `[]` |  |
| extraFlags.lodestar | list | `[]` |  |
| extraFlags.nimbus | list | `[]` |  |
| extraFlags.prysm | list | `[]` |  |
| extraFlags.teku | list | `[]` |  |
| flags.lighthouse[0] | string | `"lighthouse"` |  |
| flags.lighthouse[1] | string | `"vc"` |  |
| flags.lighthouse[2] | string | `"--datadir=/data/lighthouse"` |  |
| flags.lighthouse[3] | string | `"--init-slashing-protection"` |  |
| flags.lighthouse[4] | string | `"--logfile-compress"` |  |
| flags.lighthouse[5] | string | `"--logfile-max-size=64"` |  |
| flags.lighthouse[6] | string | `"--logfile-max-number=2"` |  |
| flags.lodestar[0] | string | `"validator"` |  |
| flags.lodestar[1] | string | `"--dataDir=/data/lodestar"` |  |
| flags.lodestar[2] | string | `"--logLevel=info"` |  |
| flags.nimbus[0] | string | `"--data-dir=/data/nimbus"` |  |
| flags.nimbus[1] | string | `"--non-interactive"` |  |
| flags.nimbus[2] | string | `"--log-level=INFO"` |  |
| flags.nimbus[3] | string | `"--doppelganger-detection=off"` |  |
| flags.prysm[0] | string | `"--datadir=/data/prysm"` |  |
| flags.prysm[1] | string | `"--accept-terms-of-use"` |  |
| flags.prysm[2] | string | `"--disable-rewards-penalties-logging"` |  |
| flags.prysm[3] | string | `"--disable-account-metrics"` |  |
| flags.teku[0] | string | `"validator-client"` |  |
| flags.teku[1] | string | `"--log-destination=CONSOLE"` |  |
| flags.teku[2] | string | `"--data-base-path=/data"` |  |
| fullnameOverride | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.network | string | `"mainnet"` |  |
| graffiti | string | `""` |  |
| image.lighthouse.repository | string | `"sigp/lighthouse"` |  |
| image.lighthouse.tag | string | `"v6.0.1"` |  |
| image.lodestar.repository | string | `"chainsafe/lodestar"` |  |
| image.lodestar.tag | string | `"v1.23.1"` |  |
| image.nimbus.repository | string | `"statusim/nimbus-validator-client"` |  |
| image.nimbus.tag | string | `"multiarch-v23.11.0"` |  |
| image.prysm.repository | string | `"gcr.io/prysmaticlabs/prysm/validator"` |  |
| image.prysm.tag | string | `"v5.1.2"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.teku.repository | string | `"consensys/teku"` |  |
| image.teku.tag | string | `"23.12.0"` |  |
| imagePullSecrets | list | `[]` |  |
| initImage.pullPolicy | string | `"IfNotPresent"` |  |
| initImage.repository | string | `"busybox"` |  |
| initImage.tag | string | `"1.37.0"` |  |
| livenessProbe.lighthouse.failureThreshold | int | `3` |  |
| livenessProbe.lighthouse.httpGet.path | string | `"/metrics"` |  |
| livenessProbe.lighthouse.httpGet.port | string | `"metrics"` |  |
| livenessProbe.lighthouse.httpGet.scheme | string | `"HTTP"` |  |
| livenessProbe.lighthouse.initialDelaySeconds | int | `60` |  |
| livenessProbe.lighthouse.periodSeconds | int | `60` |  |
| livenessProbe.lighthouse.successThreshold | int | `1` |  |
| livenessProbe.lighthouse.timeoutSeconds | int | `1` |  |
| livenessProbe.prysm.failureThreshold | int | `3` |  |
| livenessProbe.prysm.httpGet.path | string | `"/healthz"` |  |
| livenessProbe.prysm.httpGet.port | string | `"metrics"` |  |
| livenessProbe.prysm.httpGet.scheme | string | `"HTTP"` |  |
| livenessProbe.prysm.initialDelaySeconds | int | `60` |  |
| livenessProbe.prysm.periodSeconds | int | `60` |  |
| livenessProbe.prysm.successThreshold | int | `1` |  |
| livenessProbe.prysm.timeoutSeconds | int | `1` |  |
| livenessProbe.teku.failureThreshold | int | `3` |  |
| livenessProbe.teku.httpGet.path | string | `"/metrics"` |  |
| livenessProbe.teku.httpGet.port | string | `"metrics"` |  |
| livenessProbe.teku.httpGet.scheme | string | `"HTTP"` |  |
| livenessProbe.teku.initialDelaySeconds | int | `60` |  |
| livenessProbe.teku.periodSeconds | int | `60` |  |
| livenessProbe.teku.successThreshold | int | `1` |  |
| livenessProbe.teku.timeoutSeconds | int | `1` |  |
| metrics.enabled | bool | `true` |  |
| metrics.flags.lighthouse[0] | string | `"--metrics"` |  |
| metrics.flags.lighthouse[1] | string | `"--metrics-port=9090"` |  |
| metrics.flags.lighthouse[2] | string | `"--metrics-address=0.0.0.0"` |  |
| metrics.flags.lodestar[0] | string | `"--metrics"` |  |
| metrics.flags.lodestar[1] | string | `"--metrics.address=0.0.0.0"` |  |
| metrics.flags.lodestar[2] | string | `"--metrics.port=9090"` |  |
| metrics.flags.nimbus[0] | string | `"--metrics"` |  |
| metrics.flags.nimbus[1] | string | `"--metrics-port=9090"` |  |
| metrics.flags.nimbus[2] | string | `"--metrics-address=0.0.0.0"` |  |
| metrics.flags.prysm[0] | string | `"--monitoring-port=9090"` |  |
| metrics.flags.prysm[1] | string | `"--monitoring-host=0.0.0.0"` |  |
| metrics.flags.teku[0] | string | `"--metrics-enabled=true"` |  |
| metrics.flags.teku[1] | string | `"--metrics-host-allowlist=*"` |  |
| metrics.flags.teku[2] | string | `"--metrics-interface=0.0.0.0"` |  |
| metrics.flags.teku[3] | string | `"--metrics-port=9090"` |  |
| metrics.port | int | `9090` |  |
| metrics.prometheusRule.additionalLabels | object | `{}` |  |
| metrics.prometheusRule.default | bool | `true` |  |
| metrics.prometheusRule.enabled | bool | `false` |  |
| metrics.prometheusRule.namespace | string | `""` |  |
| metrics.prometheusRule.rules | object | `{}` |  |
| metrics.serviceMonitor.additionalLabels | object | `{}` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| metrics.serviceMonitor.honorLabels | bool | `false` |  |
| metrics.serviceMonitor.interval | string | `"30s"` |  |
| metrics.serviceMonitor.metricRelabelings | list | `[]` |  |
| metrics.serviceMonitor.namespace | string | `""` |  |
| metrics.serviceMonitor.relabelings | list | `[]` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
| nameOverride | string | `""` |  |
| network | string | `"mainnet"` |  |
| nodeSelector | object | `{}` |  |
| priorityClassName | string | `""` |  |
| rbac.create | bool | `true` |  |
| rbac.name | string | `""` |  |
| rbac.rules[0].apiGroups[0] | string | `""` |  |
| rbac.rules[0].resources[0] | string | `"services"` |  |
| rbac.rules[0].resources[1] | string | `"pods"` |  |
| rbac.rules[0].verbs[0] | string | `"list"` |  |
| rbac.rules[0].verbs[1] | string | `"get"` |  |
| rbac.rules[0].verbs[2] | string | `"patch"` |  |
| readinessProbe.lighthouse.failureThreshold | int | `3` |  |
| readinessProbe.lighthouse.httpGet.path | string | `"/metrics"` |  |
| readinessProbe.lighthouse.httpGet.port | string | `"metrics"` |  |
| readinessProbe.lighthouse.httpGet.scheme | string | `"HTTP"` |  |
| readinessProbe.lighthouse.initialDelaySeconds | int | `60` |  |
| readinessProbe.lighthouse.periodSeconds | int | `60` |  |
| readinessProbe.lighthouse.successThreshold | int | `1` |  |
| readinessProbe.lighthouse.timeoutSeconds | int | `1` |  |
| readinessProbe.prysm.failureThreshold | int | `3` |  |
| readinessProbe.prysm.httpGet.path | string | `"/healthz"` |  |
| readinessProbe.prysm.httpGet.port | string | `"metrics"` |  |
| readinessProbe.prysm.httpGet.scheme | string | `"HTTP"` |  |
| readinessProbe.prysm.initialDelaySeconds | int | `60` |  |
| readinessProbe.prysm.periodSeconds | int | `60` |  |
| readinessProbe.prysm.successThreshold | int | `1` |  |
| readinessProbe.prysm.timeoutSeconds | int | `1` |  |
| readinessProbe.teku.failureThreshold | int | `3` |  |
| readinessProbe.teku.httpGet.path | string | `"/metrics"` |  |
| readinessProbe.teku.httpGet.port | string | `"metrics"` |  |
| readinessProbe.teku.httpGet.scheme | string | `"HTTP"` |  |
| readinessProbe.teku.initialDelaySeconds | int | `60` |  |
| readinessProbe.teku.periodSeconds | int | `60` |  |
| readinessProbe.teku.successThreshold | int | `1` |  |
| readinessProbe.teku.timeoutSeconds | int | `1` |  |
| resources | object | `{}` |  |
| securityContext.fsGroup | int | `1001` |  |
| securityContext.runAsUser | int | `1001` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `"validators"` |  |
| strictFeeRecipientCheck | bool | `false` |  |
| terminationGracePeriodSeconds | int | `300` |  |
| tolerations | object | `{}` |  |
| type | string | `"prysm"` |  |
| validatorsCount | int | `0` |  |
| validatorsKeyIndex | int | `0` |  |
| validatorsNoOfKeys | int | `100` |  |
| web3signerEndpoint | string | `"http://test-web3signer:9000"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
