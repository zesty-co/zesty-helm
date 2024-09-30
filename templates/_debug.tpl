{{- define "delve" -}}
{{- if hasSuffix "debug" .Values.extender.image.tag }}
ports:
- name: delve
  containerPort: 40000
{{- end }}
{{- end }}
