{{- define "common.cr" }}
{{- range .Values.cr }}
{{- if .create }}
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: {{ .name }}
  labels:
    {{- include "common.labels" $ | nindent 4 }}
rules: {{ .rules | toYaml | nindent 2 }}
---
{{- end }}
{{- end }}
{{- end }}


{{- define "common.crb" }}
{{- range .Values.crb }}
{{- if .create }}
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    {{- include "common.labels" $ | nindent 4 }}
  name: {{ .name }}
roleRef: {{ .roleRef | toYaml | nindent 2 }}
subjects: {{ .subjects | toYaml | nindent 2 }}
---
{{- end }}
{{- end }}
{{- end }}
