{{/*
Expand the name of the chart.
*/}}
{{- define "cnpg-cluster.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cnpg-cluster.fullname" -}}
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
{{- define "cnpg-cluster.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cnpg-cluster.labels" -}}
helm.sh/chart: {{ include "cnpg-cluster.chart" . }}
{{ include "cnpg-cluster.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ with .Values.commonLabels -}}
{{ toYaml . }}
{{ end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cnpg-cluster.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cnpg-cluster.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the cluster resource.
*/}}
{{- define "cnpg-cluster.clusterName" -}}
{{- default (include "cnpg-cluster.fullname" .) .Values.cluster.metadata.name -}}
{{- end }}

{{/*
Create the name of the barman ObjectStore
*/}}
{{- define "cnpg-cluster.barmanName" -}}
{{- default (printf "%s-backup" (include "cnpg-cluster.fullname" .)) .Values.barman.metadata.name -}}
{{- end }}

{{/*
Whether the barman-cloud plugin and ObjectStore are deployed: barman is
enabled and at least one scheduled backup uses the barman-cloud plugin,
either explicitly or via the method and pluginConfiguration defaults.
*/}}
{{- define "cnpg-cluster.barmanEnabled" -}}
{{- $enabled := false -}}
{{- if .Values.barman.enabled -}}
{{- range $spec := .Values.scheduledBackups -}}
{{- $method := get $spec "method" | default "plugin" -}}
{{- if eq $method "plugin" -}}
{{- $pluginName := get (get $spec "pluginConfiguration" | default dict) "name" | default "barman-cloud.cloudnative-pg.io" -}}
{{- if eq $pluginName "barman-cloud.cloudnative-pg.io" -}}
{{- $enabled = true -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- $enabled -}}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cnpg-cluster.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cnpg-cluster.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
