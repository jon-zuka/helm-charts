{{- define "common.sa" }}
{{ with .Values.sa }}
{{- if .create }}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ .name | default "default" }}
  labels:
    {{- include "common.labels" $ | nindent 4 }}
  {{- with .annotations }}
  annotations:
    {{- toYaml $ | nindent 4 }}
  {{- end }}
automountServiceAccountToken: true
{{- end }}
{{- end }}
{{- end }}
