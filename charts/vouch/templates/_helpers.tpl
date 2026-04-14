{{/*
Compute a sha256 checksum of the vouch ConfigMap data.
Using vouchFullConfig when provided, otherwise vouch values.
This is injected as a pod annotation so any change to the config
triggers a rolling restart of the StatefulSet.
*/}}
{{- define "vouch.configmap.hash" -}}
{{- if .Values.vouchFullConfig -}}
{{- toYaml .Values.vouchFullConfig | sha256sum -}}
{{- else -}}
{{- toYaml .Values.vouch | sha256sum -}}
{{- end -}}
{{- end -}}
