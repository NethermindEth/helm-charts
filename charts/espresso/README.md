
# espresso

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 20240925-patch1](https://img.shields.io/badge/AppVersion-20240925--patch1-informational?style=flat-square)

A Helm chart for Espresso Sequencer nodes.

**Homepage:** <https://docs.espressosys.com/sequencer>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| AntiD2ta | <miguel@nethermind.io> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| externalSecrets.enabled | bool | `false` |  |
| externalSecrets.name | string | `"eso-espresso-sequencer-secrets"` | Name of the ExternalSecret resource |
| externalSecrets.secretStoreRef.kind | string | `"SecretStore"` |  |
| externalSecrets.secretStoreRef.name | string | `"secretStoreRef"` |  |
| fullnameOverride | string | `""` | Provide a name to substitute for the full names of resources |
| global.namespaceOverride | string | `""` |  |
| global.networkType | string | `""` | Network type to be used in Espresso's Node Validator Dashboard for identity purposes. Values: Residential, Hosted, AWS, Azure, GCP, Cloud Provider. If the value is a well known cloud provider, then availability zone could be added. E.g. AWS us-east-1a. |
| global.persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"size":"150Gi","storageClassName":""}` | Whether or not to allocate persistent volume disk for the data directory. In case of node failure, the node data directory will still persist.  |
| global.rbac.create | bool | `true` | Whether or not to create ClusterRole and ClusterRoleBinding resources |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"ghcr.io/espressosystems/espresso-sequencer/sequencer","tag":"main"}` | Sequencer node image |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts | list | `[]` | Hostnames. Can be provided if Ingress is enabled. |
| ingress.labels | object | `{}` |  |
| ingress.routePrefix | string | `"/"` | Route Prefix. Can skip it if any item of path has the path defined. |
| ingress.tls | list | `[]` | TLS configuration for Ingress Secret must be manually created in the namespace  |
| initImage | object | `{"pullPolicy":"IfNotPresent","repository":"bitnami/kubectl","tag":"1.28"}` | Init image is used to manage which secrets the pod should use. |
| keystoreCLI.db | object | `{"host":"","secretId":"","user":""}` | Postgres DB credentials |
| keystoreCLI.image.pullPolicy | string | `"IfNotPresent"` |  |
| keystoreCLI.image.repository | string | `"nethermindeth/espresso-keystore-cli"` |  |
| keystoreCLI.image.tag | string | `"v0.1.1"` |  |
| keystoreCLI.projectId | string | `""` |  |
| keystoreCLI.pv | object | `{"secretId":""}` | Secret ID of the Secret containing the Sequencer's private keys |
| logFormat | string | `"espresso"` | Log format for the Sequencer containers. Custom label for Promtail. |
| nameOverride | string | `""` | Provide a name to substitute for the name of the chart |
| nodes.da.command | list | `["sequencer","--","storage-sql","--","http","--","catchup","--","status","--","query"]` | Command to be used to start the node |
| nodes.da.nodeName | string | `""` | Node name to identify the node in the Espresso's Node Validator Dashboard. The node index will be appended to the node name. |
| nodes.da.replicaCount | int | `0` |  |
| nodes.da.resources.limits.cpu | string | `"4000m"` |  |
| nodes.da.resources.limits.memory | string | `"32000Mi"` |  |
| nodes.da.resources.requests.cpu | string | `"2000m"` |  |
| nodes.da.resources.requests.memory | string | `"16000Mi"` |  |
| nodes.da.secrets.data | list | `[]` |  |
| nodes.da.secrets.postgresSecretKey | string | `""` | Postgres secret key. Must match the secret key in the Secret resource or ExternalSecret resource for the postgres related secrets. |
| nodes.da.secrets.sequencerSecretKey | string | `""` | Sequencer secret key. Must match the secret key in the Secret resource or ExternalSecret resource for the sequencer node secrets. |
| nodes.da.sqlStorage | bool | `true` | DA nodes will use SQL storage, keep it true |
| nodes.da.volumeMount | bool | `false` | DA nodes won't use volume mount, keep it false |
| nodes.normal.command | list | `["sequencer","--","http","--","catchup","--","status"]` | Command to be used to start the node |
| nodes.normal.nodeName | string | `""` | Node name to identify the node in the Espresso's Node Validator Dashboard. The node index will be appended to the node name. |
| nodes.normal.replicaCount | int | `1` |  |
| nodes.normal.resources.limits.cpu | string | `"4000m"` |  |
| nodes.normal.resources.limits.memory | string | `"32000Mi"` |  |
| nodes.normal.resources.requests.cpu | string | `"2000m"` |  |
| nodes.normal.resources.requests.memory | string | `"16000Mi"` |  |
| nodes.normal.secrets.data | list | `[]` |  |
| nodes.normal.secrets.sequencerSecretKey | string | `""` | Sequencer secret key. Must match the secret key in the Secret resource or ExternalSecret resource for the node type. |
| nodes.normal.sqlStorage | bool | `false` | Normal nodes won't use SQL storage, keep it false |
| nodes.normal.volumeMount | bool | `true` |  |
| nodes_config | object | `{"ESPRESSO_SEQUENCER_API_PORT":80,"ESPRESSO_SEQUENCER_CDN_ENDPOINT":"cdn.decaf.testnet.espresso.network:1737","ESPRESSO_SEQUENCER_GENESIS_FILE":"/genesis/decaf.toml","ESPRESSO_SEQUENCER_IDENTITY_COMPANY_NAME":"Nethermind","ESPRESSO_SEQUENCER_IDENTITY_COMPANY_WEBSITE":"https://nethermind.io","ESPRESSO_SEQUENCER_L1_PROVIDER":"","ESPRESSO_SEQUENCER_LIBP2P_ADVERTISE_ADDRESS":"0.0.0.0:31000","ESPRESSO_SEQUENCER_LIBP2P_BIND_ADDRESS":"0.0.0.0:31000","ESPRESSO_SEQUENCER_ORCHESTRATOR_URL":"https://orchestrator-7BEFB0C9FFC.decaf.testnet.espresso.network","ESPRESSO_SEQUENCER_STATE_PEERS":"https://query.decaf.testnet.espresso.network","ESPRESSO_SEQUENCER_STORAGE_PATH":"/mount/sequencer/store/","ESPRESSO_STATE_RELAY_SERVER_URL":"https://state-relay.decaf.testnet.espresso.network","RUST_LOG":"warn,libp2p=off","RUST_LOG_FORMAT":"json"}` | Sequencer node configuration for the container. |
| prometheusRule.additionalLabels | object | `{}` | Additional labels for the prometheusRule |
| prometheusRule.default | bool | `true` | Create a default set of Alerts |
| prometheusRule.namespace | string | `""` | The namespace in which the prometheusRule will be created |
| prometheusRule.rules | list | `[]` | Custom Prometheus rules |
| rbac.clusterRules | list | `[{"apiGroups":[""],"resources":["services","endpoints"],"verbs":["get","list","watch"]}]` | Required ClusterRole rules |
| rbac.create | bool | `true` |  |
| rbac.name | string | `""` | The name of the role to use. If not set and create is true, a name is generated using the fullname template  |
| rbac.rules | list | `[{"apiGroups":[""],"resources":["secrets"],"verbs":["create","get","list","watch","delete"]},{"apiGroups":[""],"resources":["services"],"verbs":["get","list","watch"]}]` | Required Role rules |
| service.annotations | object | `{}` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template  |
| serviceMonitor.additionalLabels | object | `{}` | Additional labels that can be used so ServiceMonitor resource(s) can be discovered by Prometheus |
| serviceMonitor.honorLabels | bool | `false` | Specify honorLabels parameter to add the scrape endpoint |
| serviceMonitor.metricRelabelings | list | `[]` | Metrics RelabelConfigs to apply to samples before ingestion. |
| serviceMonitor.namespace | string | `""` | The namespace in which the ServiceMonitor will be created |
| serviceMonitor.relabellings | list | `[]` | Metrics RelabelConfigs to apply to samples before scraping. |
| serviceMonitor.scrapeTimeout | string | `""` | The timeout after which the scrape is ended |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
