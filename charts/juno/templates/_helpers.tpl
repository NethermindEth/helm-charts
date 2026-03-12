{{/*
Expand the name of the chart.
*/}}
{{- define "juno.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "juno.fullname" -}}
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
{{- define "juno.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels (includes base selector labels)
*/}}
{{- define "juno.labels" -}}
helm.sh/chart: {{ include "juno.chart" . }}
{{ include "juno.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Base selector labels
*/}}
{{- define "juno.selectorLabels" -}}
app.kubernetes.io/name: {{ include "juno.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Juno component selector labels (for matchLabels and service selectors)
*/}}
{{- define "juno.juno.selectorLabels" -}}
app.kubernetes.io/component: juno
{{ include "juno.selectorLabels" . }}
{{- end }}

{{/*
Staking component selector labels (for matchLabels and service selectors)
*/}}
{{- define "juno.staking.selectorLabels" -}}
app.kubernetes.io/component: staking
{{ include "juno.selectorLabels" . }}
{{- end }}

{{/*
Juno service name (for intra-chart references, e.g. staking -> juno)
*/}}
{{- define "juno.junoServiceName" -}}
{{ include "juno.fullname" . }}-juno
{{- end }}

{{/*
Name of the secret holding staking config
*/}}
{{- define "juno.stakingSecretName" -}}
{{- if .Values.staking.config.existingSecret }}
{{- .Values.staking.config.existingSecret }}
{{- else }}
{{- include "juno.fullname" . }}-staking-config
{{- end }}
{{- end }}
