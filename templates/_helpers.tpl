{{/* OPERATOR */}}

{{- define "operator.name" -}}
{{- .Values.storageOperator.fullnameOverride | default (printf "%s-operator" (include "name" .) | trunc 63 | trimSuffix "-") -}}
{{- end -}}

{{- define "operator.image" -}}
{{- printf "%s/%s" .Values.registry .Values.storageOperator.image.name -}}
{{- end -}}

{{/* AGENT */}}

{{- define "agent.name" -}}
{{- .Values.agentManager.fullnameOverride | default (printf "%s-agent" (include "name" .) | trunc 63 | trimSuffix "-") -}}
{{- end -}}

{{- define "agent.image" -}}
{{- printf "%s/%s" .Values.registry .Values.agentManager.agent.image.name -}}
{{- end -}}

{{/* SIDECAR */}}

{{- define "manager.image" -}}
{{- printf "%s/%s" .Values.registry .Values.agentManager.manager.image.name -}}
{{- end -}}

{{/* SCHEDULER */}}

{{- define "scheduler.name" -}}
{{- printf "%s-scheduler" (include "name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "scheduler.tag" -}}
{{- if .Values.scheduler.image.tag -}}
{{- .Values.scheduler.image.tag -}}
{{- else -}}
{{- $gitVersion := (semver .Capabilities.KubeVersion.GitVersion) -}}
{{- $patch := $gitVersion.Patch -}}
{{- printf "v%d.%d.%d-eks-%d-%d-latest" $gitVersion.Major $gitVersion.Minor $patch $gitVersion.Major $gitVersion.Minor -}}
{{- end -}}
{{- end -}}

{{/* ADMISSION */}}

{{- define "admission.mutator.name" -}}
{{- .Values.admission.mutator.fullnameOverride | default (printf "%s-mutator" (include "name" .) | trunc 63 | trimSuffix "-") -}}
{{- end -}}

{{- define "admission.mutator.image" -}}
{{- printf "%s/%s" .Values.registry .Values.admission.mutator.image.name -}}
{{- end -}}

{{- define "admission.secret.name" -}}
{{- .Values.admission.secret.name | default (printf "%s-admission" (include "name" .) | trunc 63 | trimSuffix "-") -}}
{{- end -}}

{{/* EXTENDER */}}

{{- define "extender.name" -}}
{{- .Values.extender.fullnameOverride | default (printf "%s-extender" (include "name" .) | trunc 63 | trimSuffix "-") -}}
{{- end -}}

{{- define "extender.image" -}}
{{- printf "%s/%s" .Values.registry .Values.extender.image.name -}}
{{- end -}}

{{/* EXPORTER */}}

{{- define "prometheus.exporter.image" -}}
{{- printf "%s/%s" .Values.registry .Values.agentManager.prometheusExporter.image.name -}}
{{- end -}}