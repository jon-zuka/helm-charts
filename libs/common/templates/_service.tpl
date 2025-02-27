{{- define "common.svc" }}
{{- with .Values.svc }}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "common.fullname" $ }}
  labels:
    {{- include "common.labels" $ | nindent 4 }}
spec:
  type: ClusterIP
  ports:
  {{- range . }}
    - name: {{ .name | default "default" }}
      port: {{ .port | default .containerPort }}
      targetPort: {{ .containerPort | default .port }}
      protocol: {{ .protocol | default "TCP" }}
  {{- end }}
  selector:
    {{- include "common.selectorLabels" $ | nindent 4 }}
{{- end }}
{{- end }}


{{- define "common.lb" }}
{{- with .Values.lb }}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "common.fullname" $ }}-lb
  labels:
    {{- include "common.labels" $ | nindent 4 }}
spec:
  type: LoadBalancer
  ports:
  {{- range . }}
    - name: {{ .name | default "default" }}
      port: {{ .port | default .containerPort }}
      nodePort: {{ .port | default .containerPort }}
      targetPort: {{ .containerPort | default .port }}
      protocol: {{ .protocol | default "TCP" }}
  {{- end }}
  selector:
    {{- include "common.selectorLabels" $ | nindent 4 }}
{{- end }}
{{- end }}

