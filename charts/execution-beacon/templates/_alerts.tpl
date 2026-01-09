{{/*
Generates two PrometheusRules alerts for the default `up` metric.
Receives a dict as the parameter, with the following keys:
- root: the root helm context
- type: either "execution" or "beacon"
*/}}
{{- define "execution-beacon.upalerts" -}}
{{- $root := .root | required "The root key is required as a paremeter to execution-beacon.upalerts" -}}
{{- $type := .type | required "The type key is required as a paremeter to execution-beacon.upalerts" -}}

{{- $fullname := include "common.names.fullname" $root -}}
{{- $namespace := $root.Release.Namespace -}}

{{- $upAlertExpr := printf "up{job='%s', namespace='%s'} == 0" $fullname $namespace -}}
{{- $isNotUpdatingAlertExpr := printf "and on() (kube_statefulset_status_current_revision{statefulset='%s', namespace='%s'} == kube_statefulset_status_update_revision{statefulset='%s', namespace='%s'})" $fullname $namespace $fullname $namespace -}}

{{- $typeTitle := title $type -}}
{{- $clientTitle := "" -}}
{{- if eq $type "beacon" -}}
  {{- $clientTitle = title $root.Values.beacon.client -}}
{{- end -}}
{{- $annotationMsgPrefix := (printf "%s %s" $clientTitle $typeTitle | trim) -}}
- alert: {{ printf "%s%sNodeDownNoUpdate" $clientTitle $typeTitle }}
  expr: |
    {{ $upAlertExpr }}
    {{ $isNotUpdatingAlertExpr }}
  for: 5m
  labels:
    {{- with $root.Values.metrics.prometheusRule.severity }}
    severity: {{ quote . }}
    {{- end }}
  annotations:
    summary: {{ $annotationMsgPrefix }} Node {{ printf "{{ $labels.instance }}" }} down
    description: {{ $annotationMsgPrefix }} Node {{ printf "{{ $labels.instance }}" }} is down, and there is no current update underway
- alert: {{ printf "%s%sNodeDown" $clientTitle $typeTitle }}
  expr: {{ $upAlertExpr }}
  for: 10m
  labels:
    {{- with $root.Values.metrics.prometheusRule.severity }}
    severity: {{ quote . }}
    {{- end }}
  annotations:
    summary: {{ $annotationMsgPrefix }} Node {{ printf "{{ $labels.instance }}" }} down
    description: {{ $annotationMsgPrefix }} Node {{ printf "{{ $labels.instance }}" }} is down
{{- end }}
