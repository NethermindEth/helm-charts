{{/*
Expand the name of the chart.
*/}}
{{- define "drpc-nodecore.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "drpc-nodecore.fullname" -}}
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
Per-project fully qualified name: <fullname>-<projectName>
Truncated to 63 chars for DNS compliance.
Expects a dict with keys: root, projectName
*/}}
{{- define "drpc-nodecore.projectName" -}}
{{- $fullname := include "drpc-nodecore.fullname" .root -}}
{{- printf "%s-%s" $fullname .projectName | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "drpc-nodecore.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "drpc-nodecore.labels" -}}
{{ include "drpc-nodecore.selectorLabels" . }}
helm.sh/chart: {{ include "drpc-nodecore.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Per-project labels.
Expects a dict with keys: root, projectName
*/}}
{{- define "drpc-nodecore.projectLabels" -}}
{{ include "drpc-nodecore.projectSelectorLabels" . }}
helm.sh/chart: {{ include "drpc-nodecore.chart" .root }}
{{- if .root.Chart.AppVersion }}
app.kubernetes.io/version: {{ .root.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .root.Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "drpc-nodecore.selectorLabels" -}}
app.kubernetes.io/name: {{ include "drpc-nodecore.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Per-project selector labels.
Expects a dict with keys: root, projectName
*/}}
{{- define "drpc-nodecore.projectSelectorLabels" -}}
app.kubernetes.io/name: {{ include "drpc-nodecore.name" .root }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
drpc-nodecore/project: {{ .projectName }}
{{- end }}
