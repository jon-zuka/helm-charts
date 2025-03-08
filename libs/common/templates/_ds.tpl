{{- define "common.ds" }}
apiVersion: apps/v1
kind: DaemonSet
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
      {{- with .Values.ds.image.secret }}
      imagePullSecrets:
        - name: {{ . }}
      {{- end }}
      serviceAccountName: {{ .Values.sa.name | default "default" }}
      containers:
        - name: {{ .Chart.Name }}  
          {{- with .Values.ds.args }}
          args: {{ . | toYaml | nindent 12 }}
          {{- end }}
          {{- with .Values.ds.env }}
          env: {{ . | toYaml | nindent 12 }}
          {{- end }}
          {{- with .Values.ds.securityContext }}
          securityContext: {{ . | toYaml | nindent 12 }}
          {{- end }}
          {{- with .Values.ds.image }}
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
          resources: {{ toYaml .Values.ds.resources | nindent 12 }}
          {{- with .Values._volumeMounts }}
          volumeMounts:
            {{- toYaml . | nindent 12 }}
          {{- end }}

      {{- with .Values._volumes }}
      volumes:
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{- end }}
