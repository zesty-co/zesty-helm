{{/* OPERATOR */}}

{{- define "operator.name" -}}
{{- printf "%s-operator" (include "name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "operator.image" -}}
{{- printf "%s/%s" .Values.registry .Values.storageOperator.image.name -}}
{{- end -}}

{{/* AGENT */}}

{{- define "agent.name" -}}
{{- printf "%s-agent" (include "name" .) | trunc 63 | trimSuffix "-" -}}
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

{{- define "scheduler.image" -}}
{{- printf "public.ecr.aws/eks-distro/kubernetes/kube-scheduler" -}}
{{- end -}}

{{- define "scheduler.tag" -}}
{{- $gitVersion := (semver .Capabilities.KubeVersion.GitVersion) -}}
{{- printf "v%d.%d.%d-eks-%d-%d-latest" $gitVersion.Major $gitVersion.Minor $gitVersion.Patch $gitVersion.Major $gitVersion.Minor -}}
{{- end -}}

{{/* ADMISSION */}}

{{- define "admission.mutator.name" -}}
{{- printf "%s-mutator" (include "name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "admission.mutator.image" -}}
{{- printf "%s/%s" .Values.registry .Values.admission.mutator.image.name -}}
{{- end -}}

{{- define "admission.secret.name" -}}
{{- .Values.admission.secret.name | default (printf "%s-admission" (include "name" .) | trunc 63 | trimSuffix "-") -}}
{{- end -}}

{{/* EXTENDER */}}

{{- define "extender.name" -}}
{{- printf "%s-extender" (include "name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "extender.image" -}}
{{- printf "%s/%s" .Values.registry .Values.extender.image.name -}}
{{- end -}}

{{/* EXPORTER */}}

{{- define "prometheus.exporter.image" -}}
{{- printf "%s/%s" .Values.registry .Values.agentManager.prometheusExporter.image.name -}}
{{- end -}}