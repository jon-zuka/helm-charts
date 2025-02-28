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
    spec:
      {{- with .Values.deploy.image.secret }}
      imagePullSecrets:
        - name: {{ . }}
      {{- end }}
      serviceAccountName: {{ include "common.serviceAccountName" . }}
      containers:
        - name: {{ .Chart.Name }}  
          {{- with .Values.deploy.args }}
          args: {{ . | toYaml | nindent 12 }}
          {{- end }}
          {{- with .Values.deploy.image }}
          image: "{{ .repository }}:{{ .tag }}"
          imagePullPolicy: {{ .policy }}
          {{- end }}
          ports:
          {{- range .Values.svc }}
          {{- range .ports }}
            - name: {{ .name | default "default" }}
              containerPort: {{ .containerPort | default .port }}
          {{- end }}
          {{- end }}
          {{- range .Values.lb }}
            - name: {{ .name | default "default" }}
              containerPort: {{ .containerPort | default .port }}
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
