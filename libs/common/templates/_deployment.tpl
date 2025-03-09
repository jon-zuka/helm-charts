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
      {{- with .Values.deploy.image.secret }}
      imagePullSecrets:
        - name: {{ . }}
      {{- end }}
      {{- with .Values.deploy.podSecurityContext }}
      securityContext: {{ . | toYaml | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ .Values.sa.name | default "default" }}
      containers:
        - name: {{ .Chart.Name }}  
          {{- with .Values.deploy.command }}
          command: {{ . | toYaml | nindent 12 }}
          {{- end }}
          {{- with .Values.deploy.args }}
          args: {{ . | toYaml | nindent 12 }}
          {{- end }}
          {{- with .Values.deploy.env }}
          env: {{ . | toYaml | nindent 12 }}
          {{- end }}
          {{- with .Values.deploy.image }}
          image: "{{ .repository }}:{{ .tag }}"
          imagePullPolicy: {{ .policy }}
          {{- end }}
          {{- with .Values.deploy.containerSecurityContext }}
          securityContext: {{ . | toYaml | nindent 12 }}
          {{- end }}
          ports:
          {{- range .Values.svc }}
          {{- range .ports }}
            - name: {{ .name | default "default" }}
              containerPort: {{ .containerPort | default .port }}
          {{- end }}
          {{- end }}
          resources: {{ toYaml .Values.deploy.resources | nindent 12 }}
          {{- with .Values._volumeMounts }}
          volumeMounts:
            {{- toYaml . | nindent 12 }}
          {{- end }}

      {{- with .Values._volumes }}
      volumes:
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{- end }}
