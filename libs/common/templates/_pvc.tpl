{{- define "common.pvc" }}
{{ range .Values.pvc }}
{{ if .create }}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ printf "%s-%s" (include "common.fullname" $) .name }}
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: {{ .class }}
  resources:
    requests:
      storage: {{ .size }}
{{- end }}
{{- end }}
{{- end }}


{{- define "common.pvcContext" }}
{{- $mounts := .Values._volumeMounts | default list }}
{{- $volumes := .Values._volumes | default list }}

{{- range .Values.pvc }}
{{- $pvcName :=  printf "%s-%s" (include "common.fullname" $) .name }}

{{- $mount :=  dict
  "name" .name
  "mountPath" .path }}

{{- $volume := dict
  "name" .name
  "persistentVolumeClaim" (dict "claimName" $pvcName) }}
{{- $mounts = append $mounts $mount }}
{{- $volumes = append $volumes $volume }}
{{- end }}


{{- $override := dict 
  "Values" (dict 
      "_volumeMounts" $mounts
      "_volumes" $volumes) 
}}

{{- $override | toYaml }}
{{- end }}
