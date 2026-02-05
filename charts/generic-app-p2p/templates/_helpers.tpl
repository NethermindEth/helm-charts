{{/*
Expand the name of the chart.
*/}}
{{- define "generic-app-p2p.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "generic-app-p2p.fullname" -}}
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
{{- define "generic-app-p2p.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "generic-app-p2p.labels" -}}
{{ include "generic-app-p2p.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "generic-app-p2p.selectorLabels" -}}
app.kubernetes.io/name: {{ include "generic-app-p2p.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "generic-app-p2p.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "generic-app-p2p.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "configmap.hash" -}}
{{- .Values.config | toJson | sha256sum }}
{{- end }}

{{/*
Takes a list with two arguments: a percentage, and a total, and returns the integer value (rounded up) that the
percentage represents
*/}}
{{- define "generic-app-p2p.percentageAsCeilTotal" }}
{{- $percentStr := index . 0 }}
{{- $total := index . 1 }}

{{- $percentNumeral := trimSuffix "%" $percentStr }}
{{- $percent := float64 $percentNumeral }}
{{- $calculated := mulf (divf $percent 100.0) (float64 $total) }}
{{- ceil $calculated | int }}
{{- end }}

{{- define "generic-app-p2p.affinity" -}}
{{- if .Values.affinity -}}
  {{- toYaml .Values.affinity -}}
{{- else if eq .Values.antiAffinityPreset "soft" -}}
podAntiAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        topologyKey: kubernetes.io/hostname
        labelSelector:
          matchLabels:
            {{- include "generic-app-p2p.selectorLabels" . | nindent 12 }}
{{- else if eq .Values.antiAffinityPreset "hard" -}}
podAntiAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    - topologyKey: kubernetes.io/hostname
      labelSelector:
        matchLabels:
          {{- include "generic-app-p2p.selectorLabels" . | nindent 10 -}}
{{- end }}
{{- end }}
