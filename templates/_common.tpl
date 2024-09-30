{{- define "name" -}}
{{- default "zesty" .Values.prefix | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "selectorLabels" -}}
app.kubernetes.io/name: {{ include "name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "labels" -}}
helm.sh/chart: {{ include "chart" . }}
app.kubernetes.io/name: {{ include "name" . }}
app.kubernetes.io/part-of: {{ include "name" . }}
app.kubernetes.io/component: {{ include "name" . }}
app.kubernetes.io/created-by: {{ include "name" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.additionalLabels }}
{{ toYaml .Values.additionalLabels }}
{{- end -}}
{{- end -}}
