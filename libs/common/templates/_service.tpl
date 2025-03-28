{{- define "common.services" }}
{{- range .Values._services }}
apiVersion: v1
kind: Service
metadata:
  name: {{ printf "%s-%s" (include "common.fullname" $) .name }}
  labels:
    {{- include "common.labels" $ | nindent 4 }}
spec:
  type: {{ .type | default "ClusterIP" }}
  ports:
  {{- range .ports }}
    - name: {{ .name | default "default" }}
      port: {{ .port | default .containerPort }}
      {{- if .nodePort }}
      nodePort: {{ .nodePort}}
      {{- end }}
      targetPort: {{ .containerPort | default .port }}
      protocol: {{ .protocol | default "TCP" }}
  {{- end }}
  selector:
    {{- include "common.selectorLabels" $ | nindent 4 }}
---
{{- end }}
{{- end }}

