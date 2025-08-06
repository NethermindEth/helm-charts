{{/*
Expand the name of the chart.
*/}}
{{- define "arbitrum-orbit-chain.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "arbitrum-orbit-chain.fullname" -}}
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
{{- define "arbitrum-orbit-chain.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "arbitrum-orbit-chain.labels" -}}
helm.sh/chart: {{ include "arbitrum-orbit-chain.chart" . }}
{{ include "arbitrum-orbit-chain.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "arbitrum-orbit-chain.selectorLabels" -}}
app.kubernetes.io/name: {{ include "arbitrum-orbit-chain.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "arbitrum-orbit-chain.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "arbitrum-orbit-chain.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Nitro node selector labels
*/}}
{{- define "arbitrum-orbit-chain.nitro.selectorLabels" -}}
app.kubernetes.io/name: {{ include "arbitrum-orbit-chain.name" . }}-nitro
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: nitro-node
{{- end }}

{{/*
Blockscout backend selector labels
*/}}
{{- define "arbitrum-orbit-chain.blockscout-backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "arbitrum-orbit-chain.name" . }}-blockscout-backend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: blockscout-backend
{{- end }}

{{/*
Blockscout frontend selector labels
*/}}
{{- define "arbitrum-orbit-chain.blockscout-frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "arbitrum-orbit-chain.name" . }}-blockscout-frontend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: blockscout-frontend
{{- end }}

{{/*
Token bridge selector labels
*/}}
{{- define "arbitrum-orbit-chain.token-bridge.selectorLabels" -}}
app.kubernetes.io/name: {{ include "arbitrum-orbit-chain.name" . }}-token-bridge
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: token-bridge
{{- end }}

{{/*
New orbit-chain helper functions for self-contained chart
*/}}
{{- define "orbit-chain.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "orbit-chain.fullname" -}}
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

{{- define "orbit-chain.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "orbit-chain.labels" -}}
helm.sh/chart: {{ include "orbit-chain.chart" . }}
{{ include "orbit-chain.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "orbit-chain.selectorLabels" -}}
app.kubernetes.io/name: {{ include "orbit-chain.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "orbit-chain.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "orbit-chain.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Nitro startup probe command
*/}}
{{- define "nitro.startupProbe" -}}
{{- if .Values.nitro.startupProbe.command }}
{{ .Values.nitro.startupProbe.command }}
{{- else }}
curl "http://localhost:{{ .Values.nitro.config.http.port }}{{ .Values.nitro.config.http.rpcprefix }}" -H "Content-Type: application/json" \
         -sd "{\"jsonrpc\":\"2.0\",\"id\":0,\"method\":\"eth_syncing\",\"params\":[]}" \
         | jq -ne "input.result == false"
{{- end }}
{{- end -}}

{{/*
Nitro environment variables for resource management
*/}}
{{- define "nitro.env" -}}
{{- $envPrefix := .Values.nitro.config.conf.env_prefix | default "NITRO" -}}

{{/* Memory-based environment variables */}}
{{- if and .Values.nitro.resources .Values.nitro.resources.limits .Values.nitro.resources.limits.memory .Values.nitro.env.goMemLimit.enabled -}}
{{- $memory := .Values.nitro.resources.limits.memory -}}
{{- $value := regexFind "^\\d*\\.?\\d+" $memory | float64 -}}
{{- $unit := regexFind "[A-Za-z]+" $memory -}}
{{- $valueMi := 0.0 -}}
{{- if eq $unit "Gi" -}}
  {{- $valueMi = mulf $value 1024 -}}
{{- else if eq $unit "Mi" -}}
  {{- $valueMi = $value -}}
{{- end }}
- name: GOMEMLIMIT
  value: {{ printf "%dMiB" (int (mulf $valueMi (.Values.nitro.env.goMemLimit.multiplier | default 0.9))) | quote }}
{{- end }}

{{/* CPU-based environment variables */}}
{{- if .Values.nitro.env.goMaxProcs.enabled -}}
{{- $cpuRequest := 0.0 -}}
{{- $cpuLimit := 0.0 -}}
{{- $multiplier := .Values.nitro.env.goMaxProcs.multiplier | default 2 -}}

{{/* Get CPU request if set */}}
{{- if and .Values.nitro.resources .Values.nitro.resources.requests .Values.nitro.resources.requests.cpu -}}
  {{- $cpuRequestStr := toString .Values.nitro.resources.requests.cpu -}}
  {{/* Handle different CPU formats: cores (1), millicores (1000m), or decimal (0.5) */}}
  {{- if contains "m" $cpuRequestStr -}}
    {{/* Convert millicores to cores (e.g., 500m -> 0.5) */}}
    {{- $milliCores := regexFind "^\\d+" $cpuRequestStr | int -}}
    {{- $cpuRequest = mulf (divf $milliCores 1000.0) $multiplier -}}
  {{- else -}}
    {{/* Handle decimal or whole cores */}}
    {{- $cpuRequestVal := regexFind "^\\d*\\.?\\d+" $cpuRequestStr | float64 -}}
    {{- $cpuRequest = mulf $cpuRequestVal $multiplier -}}
  {{- end -}}
{{- end -}}

{{/* Get CPU limit if set */}}
{{- if and .Values.nitro.resources .Values.nitro.resources.limits .Values.nitro.resources.limits.cpu -}}
  {{- $cpuLimitStr := toString .Values.nitro.resources.limits.cpu -}}
  {{/* Handle different CPU formats: cores (1), millicores (1000m), or decimal (0.5) */}}
  {{- if contains "m" $cpuLimitStr -}}
    {{/* Convert millicores to cores (e.g., 500m -> 0.5) */}}
    {{- $milliCores := regexFind "^\\d+" $cpuLimitStr | int -}}
    {{- $cpuLimit = divf $milliCores 1000.0 -}}
  {{- else -}}
    {{/* Handle decimal or whole cores */}}
    {{- $cpuLimit = regexFind "^\\d*\\.?\\d+" $cpuLimitStr | float64 -}}
  {{- end -}}
{{- end -}}

{{/* Only set GOMAXPROCS if CPU requests or limits are defined */}}
{{- if or (gt $cpuRequest 0.0) (gt $cpuLimit 0.0) -}}
  {{/* Use the higher value between CPU request*multiplier and CPU limit */}}
  {{- $maxProcs := 0 -}}
  {{- if gt $cpuRequest $cpuLimit -}}
    {{- $maxProcs = ceil $cpuRequest | int -}}
  {{- else if gt $cpuLimit 0.0 -}}
    {{- $maxProcs = ceil $cpuLimit | int -}}
  {{- else if gt $cpuRequest 0.0 -}}
    {{- $maxProcs = ceil $cpuRequest | int -}}
  {{- end -}}

  {{/* Ensure GOMAXPROCS is at least 1 */}}
  {{- if eq $maxProcs 0 -}}
    {{- $maxProcs = 1 -}}
  {{- end }}
- name: GOMAXPROCS
  value: {{ $maxProcs | quote }}
{{- end }}
{{- end }}
{{- end -}}