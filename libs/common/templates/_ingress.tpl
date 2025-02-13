{{- define "common.ingress" }}
{{- if .Values.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "common.fullname" . }}
spec:
  ingressClassName: nginx
  rules:
  - host: {{ .Values.ingress.host }}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{ include "common.fullname" . }}
            port:
              number: {{ .Values.service.port }}
{{- end }}
{{- end }}