{{- define "common.storage" }}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ include "common.fullname" . }}
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: {{ .Values.storage.class }}
  resources:
    requests:
      storage: {{ .Values.storage.size }}
{{- end }}


{{- define "common.withStorage" }}
{{- $name := include "common.fullname" . }}
{{- $mountPath := .Values.storage.mountPath }}
{{- $volumeMount := list (dict 
  "name" "storage" 
  "mountPath" $mountPath) 
}}
{{- $volumes := list (dict
  "name" "storage" 
  "persistentVolumeClaim" (dict
    "claimName" $name
    )
  )
}}
{{- $override := dict 
  "Values" (dict 
      "volumeMounts" $volumeMount 
      "volumes" $volumes) 
}}
{{- toYaml $override }}
{{- end }}
