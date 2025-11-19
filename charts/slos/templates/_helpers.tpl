{{/*
Expand the name of the chart.
*/}}
{{- define "slos.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "slos.fullname" -}}
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
{{- define "slos.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "slos.labels" -}}
helm.sh/chart: {{ include "slos.chart" . }}
{{ include "slos.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
group: {{ required "The value `labels.group` is required" .Values.labels.group | quote }}
team: {{ required "The value `labels.team` is required" .Values.labels.team | quote }}
project: {{ required "The value `labels.project` is required" .Values.labels.project | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "slos.selectorLabels" -}}
app.kubernetes.io/name: {{ include "slos.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Ensures that a given window matches an existing Sloth window. Will need updating if we add more windows.
Receives the window as its argument
*/}}
{{- define "slos.window" }}
{{- $selectedWindow := . }}
{{- $windows := list "30d" "1d" }}
{{- if (not ($windows | has $selectedWindow))}}
  {{- fail (printf "Window '%s' is not a valid window, see the comments on the values file for more info" $selectedWindow) }}
{{- end }}
{{- $selectedWindow }}
{{- end }}


{{/*
Ensures that queries contain a literal `[{{ .window  }}]` block for Sloth to use.
Without this, we'll get the same error, just at deploy time.
*/}}
{{- define "slos.validateQuery" }}
{{- $query := . }}
{{- if (not ($query | contains "[{{ .window }}]")) }}
  {{- fail (printf "The query `%s` does not contain `[{{ .window }}]`, which is required by Sloth to generate the rate rules" $query) }}
{{- end }}
{{- $query }}
{{- end }}
