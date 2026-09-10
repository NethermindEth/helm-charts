{{/*
Generates two PrometheusRules alerts for the default `up` metric.
Receives the Helm root context as its parameter
*/}}
{{- define "execution-beacon.upalerts" -}}
{{- $root := . -}}

{{- $fullname := include "common.names.fullname" $root -}}
{{- $namespace := $root.Release.Namespace -}}

{{- $upAlertExpr := printf "up{job='%s', namespace='%s'} == 0" $fullname $namespace -}}
{{- $isNotUpdatingAlertExpr := printf "kube_statefulset_status_current_revision{statefulset='%s', namespace='%s'} == kube_statefulset_status_update_revision{statefulset='%s', namespace='%s'}" $fullname $namespace $fullname $namespace -}}

- alert: EthNodeDown
  expr: |
    {{ $upAlertExpr }}
    and on() ({{ $isNotUpdatingAlertExpr }})
  for: 5m
  labels:
    {{- with $root.Values.metrics.prometheusRule.severity }}
    severity: {{ quote . }}
    {{- end }}
  annotations:
    summary: {{ `Node {{ $labels.container }} {{ $labels.job }} down` }}
    description: {{ `Node {{ $labels.container }} {{ $labels.job }}, in namespace {{ $labels.namespace }}, is down` }}
- alert: EthNodeUpdateFailed
  expr: |
    {{ $upAlertExpr }}
    unless on() ({{ $isNotUpdatingAlertExpr }})
  for: 10m
  labels:
    {{- with $root.Values.metrics.prometheusRule.severity }}
    severity: {{ quote . }}
    {{- end }}
  annotations:
    summary: {{ `Node {{ $labels.container }} {{ $labels.job }} down during update` }}
    description: {{ `Node {{ $labels.container }} {{ $labels.job }}, in namespace {{ $labels.namespace }}, was mid update, but has not recovered` }}
{{- end }}
