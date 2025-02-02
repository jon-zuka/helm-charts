{{- define "common.service" }}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "common.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
spec:
  type: ClusterIP
  ports:
  {{- range .Values.ports }}
    - name: {{ .name | default "default" }}
      port: {{ .port | default .containerPort }}
      targetPort: {{ .containerPort | default .port }}
      protocol: {{ .protocol | default "TCP" }}
  {{- end }}
  selector:
    {{- include "common.selectorLabels" . | nindent 4 }}
{{- end }}