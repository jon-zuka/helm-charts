{{- define "common.secret" }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.fullname" . }}
type: Opaque
data:
  {{- range $key, $val := .Values.env }}
  {{ $key }}: {{ $val | b64enc }}
  {{- end}}
{{- end }}
