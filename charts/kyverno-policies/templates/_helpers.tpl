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
Allowed severity values.
*/}}
{{- define "kyverno-policies.allowedSeverities" -}}
{{- list "critical" "high" "medium" "low" "info" }}
{{- end }}

{{/*
Allowed category values.
*/}}
{{- define "kyverno-policies.allowedCategories" -}}
{{- list "Security" "Best Practices" "Governance" "Misc" "Reliability" }}
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
Validate and render the standard Kyverno annotations for a policy.
Expects a dict with keys: name and policy
Fails if any of title, description, severity, or category are missing or invalid.

Usage:
  {{- include "kyverno-policies.policyAnnotations" (dict "name" $name "policy" $policy) }}
*/}}
{{- define "kyverno-policies.policyAnnotations" -}}
{{- $name    := .name }}
{{- $policy  := .policy }}

{{- $title       := required (printf "Policy '%s' is missing required field: title" $name)       $policy.title }}
{{- $description := required (printf "Policy '%s' is missing required field: description" $name) $policy.description }}
{{- $severity    := required (printf "Policy '%s' is missing required field: severity" $name)    $policy.severity }}
{{- $category    := required (printf "Policy '%s' is missing required field: category" $name)    $policy.category }}

{{- $allowedSeverities := list "critical" "high" "medium" "low" "info" }}
{{- if not (has (lower $severity) $allowedSeverities) }}
  {{- fail (printf "Policy '%s' has unsupported severity '%s'. Allowed values: %s. To add support for a new severity, please open an issue or PR against the chart." $name $severity (join ", " $allowedSeverities)) }}
{{- end }}

{{- $allowedCategories := list "Security" "Best Practices" "Governance" "Misc" "Reliability" }}
{{- if not (has $category $allowedCategories) }}
  {{- fail (printf "Policy '%s' has unsupported category '%s'. Allowed values: %s. To add support for a new category, please open an issue or PR against the chart." $name $category (join ", " $allowedCategories)) }}
{{- end -}}
policies.kyverno.io/title: {{ $title | quote }}
policies.kyverno.io/description: {{ $description | quote }}
policies.kyverno.io/severity: {{ lower $severity | quote }}
policies.kyverno.io/category: {{ $category | quote }}
{{- end }}
