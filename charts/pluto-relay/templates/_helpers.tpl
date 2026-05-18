{{/*
Expand the name of the chart.
*/}}
{{- define "pluto-relay.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "pluto-relay.fullname" -}}
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
Chart label.
*/}}
{{- define "pluto-relay.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "pluto-relay.labels" -}}
{{ include "pluto-relay.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "pluto-relay.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pluto-relay.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ServiceAccount name.
*/}}
{{- define "pluto-relay.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "pluto-relay.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Hash of env ConfigMap content — used to roll pods on config changes.
*/}}
{{- define "pluto-relay.configHash" -}}
{{- .Values.config | toJson | sha256sum }}
{{- end }}

{{/*
Anti-affinity preset block. Used by the StatefulSet.
*/}}
{{- define "pluto-relay.affinity" -}}
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
            {{- include "pluto-relay.selectorLabels" . | nindent 12 }}
{{- else if eq .Values.antiAffinityPreset "hard" -}}
podAntiAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    - topologyKey: kubernetes.io/hostname
      labelSelector:
        matchLabels:
          {{- include "pluto-relay.selectorLabels" . | nindent 10 -}}
{{- end }}
{{- end }}

{{/*
Percentage helper for PDB validation.
*/}}
{{- define "pluto-relay.percentageAsCeilTotal" }}
{{- $percentStr := index . 0 }}
{{- $total := index . 1 }}
{{- $percentNumeral := trimSuffix "%" $percentStr }}
{{- $percent := float64 $percentNumeral }}
{{- $calculated := mulf (divf $percent 100.0) (float64 $total) }}
{{- ceil $calculated | int }}
{{- end }}
