{{- define "fullname" -}}
{{- if .Values.prefixName }}
{{- printf "%s-%s" .Values.prefixName .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "zestyStorageOperator.image" -}}
{{- printf "%s/%s" .Values.registry .Values.zestyStorageOperator.image.name }}
{{- end }}

{{- define "agent.image" -}}
{{- printf "%s/%s" .Values.registry .Values.zestyStorageAgent.agent.image.name }}
{{- end }}

{{- define "manager.image" -}}
{{- printf "%s/%s" .Values.registry .Values.zestyStorageAgent.manager.image.name }}
{{- end }}

{{- define "prometheusExporter.image" -}}
{{- printf "%s/%s" .Values.registry .Values.zestyStorageAgent.prometheusExporter.image.name }}
{{- end }}

{{- define "config.name" -}}
{{- printf "%s" (include "fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "zestyStorageOperator.name" -}}
{{- printf "%s-storage-operator" (include "fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "zestyStorageAgent.name" -}}
{{- printf "zesty-storage-agent" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "chart-template.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "chart-template.labels" -}}
helm.sh/chart: {{ include "chart-template.chart" . }}
{{ include "chart-template.selectorLabels" . }}
app.kubernetes.io/created-by: {{ include "fullname" . }}
app.kubernetes.io/part-of: {{ include "fullname" . }}
app.kubernetes.io/component: {{ include "fullname" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "chart-template.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "chart-template.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* MUTATOR */}}

{{- define "admission.mutator.name" -}}
{{- printf "%s-mutator" (include "fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "admission.secret.name" -}}
{{- .Values.admission.secret.name | default (printf "%s-admission" (include "fullname" .) | trunc 63 | trimSuffix "-") }}
{{- end }}

{{- define "admission.mutator.image" -}}
{{- printf "%s/%s" .Values.registry .Values.admission.mutator.image.name }}
{{- end }}

{{- define "admission.mutator.port" -}}
{{- default 8443 .Values.admission.mutator.port }}
{{- end }}
