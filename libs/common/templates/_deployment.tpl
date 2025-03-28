{{- define "common.deployment" }}

apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "common.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
spec:
  selector:
    matchLabels:
      {{- include "common.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "common.labels" . | nindent 8 }}
      annotations:
        checksum/config: {{ .Values | toYaml | sha256sum }}
    spec:
      imagePullSecrets: {{ .Values._image.secrets | toYaml | nindent 8 }}
      securityContext: {{ .Values._podSecurityContext | toYaml | nindent 8 }}
      serviceAccountName: {{ .Values._sa.name }}
      containers:
        - name: {{ .Chart.Name }}  
          command: {{ .Values._command | toYaml | nindent 12 }}
          args: {{ .Values._args | toYaml | nindent 12 }}
          env: {{ .Values._env | toYaml | nindent 12 }}
          image: "{{ .Values._image.repository }}:{{ .Values._image.tag }}"
          imagePullPolicy: {{ .Values._image.policy }}
          securityContext: {{ .Values._containerSecurityContext | toYaml | nindent 12 }}
          ports:
          {{- range .Values.svc }}
          {{- range .ports }}
            - name: {{ .name | default "default" }}
              containerPort: {{ .containerPort | default .port }}
          {{- end }}
          {{- end }}
          resources: {{ toYaml .Values._resources | nindent 12 }}
          {{- with .Values._volumeMounts }}
          volumeMounts:
            {{- toYaml . | nindent 12 }}
          {{- end }}
      {{- with .Values._volumes }}
      volumes:
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{- end }}
