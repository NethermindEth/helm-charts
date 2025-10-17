{{/*
Expand the name of the chart.
*/}}
{{- define "validators.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "validators.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "validators.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "validators.labels" -}}
helm.sh/chart: {{ include "validators.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
component: validator
{{- end }}

{{/*
Additional components labels
*/}}
{{- define "validator.labels" -}}         component: validator            {{- end }}

{{/*
Selector labels
*/}}
{{- define "validators.selectorLabels" -}}
app.kubernetes.io/name: {{ include "validators.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
component: validator
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "validators.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "validators.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Update permissions on files inside /data directory
*/}}
{{- define "init-chown" -}}
- name: init-chown
  image: "{{ .Values.initImageBusybox.repository }}:{{ .Values.initImageBusybox.tag }}"
  imagePullPolicy: {{ .Values.initImageBusybox.pullPolicy }}
  securityContext:
    runAsUser: 0
  command: ["chown", "-R", "{{ .Values.global.podSecurityContext.runAsUser }}:{{ .Values.global.podSecurityContext.runAsUser }}", "/data"]
  volumeMounts:
    - name: data
      mountPath: /data
{{- end }}

{{/*
Validator beacon node
*/}}
{{- define "beacon-rpc-node" -}}
{{- if eq $.Values.type "prysm" }}
- "--beacon-rpc-provider={{ $.Values.beaconChainRpcEndpoints | join "," }}"
{{- else if eq $.Values.type "lighthouse" }}
- "--beacon-nodes={{ $.Values.beaconChainRpcEndpoints | join "," }}"
{{- else if eq $.Values.type "teku" }}
- "--beacon-node-api-endpoint={{ $.Values.beaconChainRpcEndpoints | join "," }}"
{{- else if eq $.Values.type "nimbus" }}
- "--beacon-node={{ $.Values.beaconChainRpcEndpoints | join "," }}"
{{- else if eq $.Values.type "lodestar" }}
--beaconNodes={{ $.Values.beaconChainRpcEndpoints | join "," }}
{{- end }}
{{- end }}

{{/*
Validator graffiti
*/}}
{{- define "validator-graffiti" -}}
{{- if $.Values.graffiti }}
{{- if eq $.Values.type "teku" }}
- "--validators-graffiti={{ $.Values.graffiti }}"
{{- else }}
- "--graffiti={{ $.Values.graffiti }}"
{{- end }}
{{- end }}
{{- end }}

{{/*
Web3signer endpoint
*/}}
{{- define "web3signer" -}}
{{- .Values.web3signerEndpoint }}
{{- end }}

{{- define "flatten_list" -}}
  {{- $output := list -}}
  {{- range . -}}
    {{- if (kindIs "slice" . ) -}}
      {{- $output = (concat $output ( get (fromYaml (include "flatten_list" . ) )  "list" ) ) -}}
    {{- else -}}
      {{- $output = (append $output . ) -}}
    {{- end -}}
  {{- end -}}
  {{- toYaml (dict "list" $output) -}}
{{- end -}}

{{- define "flatten" -}}
  {{- get ( fromYaml (include "flatten_list" . ) ) "list" | uniq | join "," }}
{{- end -}}

{{/*
Prysm validator arguments
*/}}
{{- define "validator-args-prysm" -}}
{{- $values := .Values -}}
{{- $rpcEndpoints := .rpcEndpoints -}}
{{- range (pluck "prysm" $values.flags | first) }}
- {{ . | quote }}
{{- end }}
{{- if ne $values.network "gnosis" }}
- "--{{ $values.network }}"
- "--config-file=/data/config"
- "--validators-external-signer-url={{ $values.web3signerEndpoint }}"
- "--proposer-settings-file=/data/proposerConfig.json"
{{- else }}
- "--config-file=/data/config_gnosis_prysm"
- "--chain-config-file=/data/config_gnosis_prysm"
- "--validators-external-signer-url={{ $values.web3signerEndpoint }}"
{{- end }}
{{- if $values.graffiti }}
- "--graffiti={{ $values.graffiti }}"
{{- end }}
{{- if $values.beaconChainRpcEndpointsRandomized }}
- "--beacon-rpc-provider={{ $rpcEndpoints }}"
{{- else }}
- "--beacon-rpc-provider={{ $values.beaconChainRpcEndpoints | join "," }}"
{{- end }}
{{- if $values.metrics.enabled }}
{{- range (pluck "prysm" $values.metrics.flags | first) }}
- {{ . | quote }}
{{- end }}
{{- end }}
{{- range (pluck "prysm" $values.extraFlags | first) }}
- {{ . | quote }}
{{- end }}
{{- end }}

{{/*
Lighthouse validator arguments
*/}}
{{- define "validator-args-lighthouse" -}}
{{- $values := .Values -}}
{{- $rpcEndpoints := .rpcEndpoints -}}
{{- range (pluck "lighthouse" $values.flags | first) }}
- {{ . | quote }}
{{- end }}
- "--network={{ $values.network }}"
{{- if $values.dvt.enabled }}
- "--distributed"
{{- end }}
{{- if $values.graffiti }}
- "--graffiti={{ $values.graffiti }}"
{{- end }}
{{- if $values.beaconChainRpcEndpointsRandomized }}
- "--beacon-nodes={{ $rpcEndpoints }}"
{{- else }}
- "--beacon-nodes={{ $values.beaconChainRpcEndpoints | join "," }}"
{{- end }}
{{- if $values.metrics.enabled }}
{{- range (pluck "lighthouse" $values.metrics.flags | first) }}
- {{ . | quote }}
{{- end }}
{{- end }}
{{- range (pluck "lighthouse" $values.extraFlags | first) }}
- {{ . | quote }}
{{- end }}
{{- end }}

{{/*
Teku validator arguments
*/}}
{{- define "validator-args-teku" -}}
{{- $values := .Values -}}
{{- $rpcEndpoints := .rpcEndpoints -}}
{{- range (pluck "teku" $values.flags | first) }}
- {{ . | quote }}
{{- end }}
- "--network=auto"
- "--config-file=/data/config"
- "--validators-external-signer-url={{ $values.web3signerEndpoint }}"
{{- if not $values.dvt.enabled }}
- "--validators-proposer-config=/data/proposerConfig.json"
{{- else }}
- "--validators-builder-registration-default-enabled=true"
- "--validators-proposer-config={{ (index $values.beaconChainRpcEndpoints 0) }}/teku_proposer_config"
{{- end }}
{{- if $values.graffiti }}
- "--validators-graffiti={{ $values.graffiti }}"
{{- end }}
{{- if $values.beaconChainRpcEndpointsRandomized }}
{{- $beaconChainRpcEndpointsLen := len $values.beaconChainRpcEndpointsRandomized }}
{{- if gt $beaconChainRpcEndpointsLen 1 }}
- "--beacon-node-api-endpoints={{ $rpcEndpoints | join "," }}"
{{- else }}
- "--beacon-node-api-endpoint={{ $rpcEndpoints }}"
{{- end }}
{{- else }}
- "--beacon-node-api-endpoint={{ $values.beaconChainRpcEndpoints | join "," }}"
{{- end }}
{{- if $values.metrics.enabled }}
{{- range (pluck "teku" $values.metrics.flags | first) }}
- {{ . | quote }}
{{- end }}
{{- end }}
{{- range (pluck "teku" $values.extraFlags | first) }}
- {{ . | quote }}
{{- end }}
{{- end }}

{{/*
Nimbus validator arguments
*/}}
{{- define "validator-args-nimbus" -}}
{{- $values := .Values -}}
{{- $rpcEndpoints := .rpcEndpoints -}}
{{- range (pluck "nimbus" $values.flags | first) }}
- {{ . | quote }}
{{- end }}
- "--network={{ $values.network }}"
{{- if $values.graffiti }}
- "--graffiti={{ $values.graffiti }}"
{{- end }}
{{- if $values.beaconChainRpcEndpointsRandomized }}
- "--beacon-node={{ $rpcEndpoints }}"
{{- else }}
- "--beacon-node={{ $values.beaconChainRpcEndpoints | join "," }}"
{{- end }}
{{- if $values.metrics.enabled }}
{{- range (pluck "nimbus" $values.metrics.flags | first) }}
- {{ . | quote }}
{{- end }}
{{- end }}
{{- range (pluck "nimbus" $values.extraFlags | first) }}
- {{ . | quote }}
{{- end }}
{{- end }}

{{/*
Lodestar validator command
*/}}
{{- define "validator-command-lodestar" -}}
{{- $values := .Values -}}
{{- $rpcEndpoints := .rpcEndpoints -}}
- sh
- -c
- >
  node ./packages/cli/bin/lodestar
{{- range (pluck "lodestar" $values.flags | first) }}
  {{ . }}
{{- end }}
  --network={{ $values.network }}
  --proposerSettingsFile=/data/proposerConfig.yaml
  --externalSigner.url={{ $values.web3signerEndpoint }}
  --rcConfig=/data/rcconfig.json
{{- if $values.dvt.enabled }}
  --distributed
{{- if $values.enableBuilder }}
  --builder.selection="builderalways"
{{- end }}
{{- end }}
{{- if $values.beaconChainRpcEndpointsRandomized }}
  --beaconNodes={{ $rpcEndpoints }}
{{- else }}
  --beaconNodes={{ $values.beaconChainRpcEndpoints | join "," }}
{{- end }}
{{- if $values.metrics.enabled }}
{{- range (pluck "lodestar" $values.metrics.flags | first) }}
  {{ . }}
{{- end }}
{{- end }}
{{- range (pluck "lodestar" $values.extraFlags | first) }}
  {{ . }}
{{- end }}
{{- end }}
