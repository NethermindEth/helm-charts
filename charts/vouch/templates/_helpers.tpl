{{/*
Compute a short checksum of the vouch ConfigMap data.
Using vouchFullConfig when provided, otherwise vouch values.
This is appended to the ConfigMap name so any change to the config
produces a new name, forcing a Pod restart.
*/}}
{{- define "vouch.configChecksum" -}}
{{- if .Values.vouchFullConfig -}}
{{- toYaml .Values.vouchFullConfig | sha256sum | trunc 8 -}}
{{- else -}}
{{- toYaml .Values.vouch | sha256sum | trunc 8 -}}
{{- end -}}
{{- end -}}

{{/*
Full name of the vouch ConfigMap, including a content hash suffix.
*/}}
{{- define "vouch.configmap.name" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) (include "vouch.configChecksum" .) -}}
{{- end -}}
