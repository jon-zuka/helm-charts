{{- define "common.hpa" }}
{{- with .Values._hpa }}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "common.fullname" $ }}
  labels:
    {{- include "common.labels" $ | nindent 4 }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "common.fullname" $ }}
  minReplicas: {{ .min }}
  maxReplicas: {{ .max }}
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {{ .cpu }}
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: {{ .memory }}
{{- end }}
{{- end }}
