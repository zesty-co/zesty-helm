{{- define "fullname" -}}
{{- if .Values.prefixName }}
{{- printf "%s-%s" .Values.prefixName .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "provisioner.image" -}}
{{- printf "%s/%s" .Values.registry .Values.provisioner.image.name }}
{{- end }}

{{- define "collector.image" -}}
{{- printf "%s/%s" .Values.registry .Values.agent.collector.image.name }}
{{- end }}

{{- define "sidecar.image" -}}
{{- printf "%s/%s" .Values.registry .Values.agent.sidecar.image.name }}
{{- end }}

{{- define "provisioner.name" -}}
{{- printf "%s-provisioner" (include "fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "agent.name" -}}
{{- printf "%s-agent" (include "fullname" .) | trunc 63 | trimSuffix "-" }}
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
