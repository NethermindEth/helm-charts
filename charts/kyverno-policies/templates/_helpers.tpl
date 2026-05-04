{{/*
Expand the name of the chart.
*/}}
{{- define "kyverno-policies.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kyverno-policies.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kyverno-policies.labels" -}}
helm.sh/chart: {{ include "kyverno-policies.chart" . }}
{{ include "kyverno-policies.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kyverno-policies.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kyverno-policies.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Map a values key prefix (e.g. "validatingPolicies") to its Kubernetes Kind.
Usage: {{ include "kyverno-policies.kindFromKey" "validatingPolicies" }}
*/}}
{{- define "kyverno-policies.kindFromKey" -}}
{{- $map := dict
    "validatingPolicies"                "ValidatingPolicy"
    "mutatingPolicies"                  "MutatingPolicy"
    "generatingPolicies"                "GeneratingPolicy"
    "deletingPolicies"                  "DeletingPolicy"
    "imageValidatingPolicies"           "ImageValidatingPolicy"
    "namespacedValidatingPolicies"      "NamespacedValidatingPolicy"
    "namespacedMutatingPolicies"        "NamespacedMutatingPolicy"
    "namespacedGeneratingPolicies"      "NamespacedGeneratingPolicy"
    "namespacedDeletingPolicies"        "NamespacedDeletingPolicy"
    "namespacedImageValidatingPolicies" "NamespacedImageValidatingPolicy"
-}}
{{- get $map . }}
{{- end }}

{{/*
Returns true if the given values key is for a namespaced policy variant.
Usage: {{ include "kyverno-policies.isNamespaced" "namespacedValidatingPolicies" }}
*/}}
{{- define "kyverno-policies.isNamespaced" -}}
{{- if hasPrefix "namespaced" . }}true{{- else }}false{{- end }}
{{- end }}

{{/*
TODO: fix this it doesn't need name anymore
Render the standard Kyverno annotations for a policy.
Expects a dict with keys: name and policy.

Usage:
  {{- include "kyverno-policies.policyAnnotations" (dict "name" $name "policy" $policy) }}
*/}}
{{- define "kyverno-policies.policyAnnotations" -}}
{{- $policy := .policy -}}
policies.kyverno.io/title: {{ $policy.title | quote }}
policies.kyverno.io/description: {{ $policy.description | quote }}
policies.kyverno.io/severity: {{ $policy.severity | quote }}
policies.kyverno.io/category: {{ $policy.category | quote }}
{{- end }}
