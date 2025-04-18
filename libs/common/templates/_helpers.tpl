{{/*
Expand the name of the chart.
*/}}
{{- define "common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "common.labels" -}}
helm.sh/chart: {{ include "common.chart" . }}
{{ include "common.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "common.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Default values
*/}}
{{- define "common.defaultValues" }}
{{- $firstContainerPort := (index (index .Values._services 0).ports 0).containerPort }}
{{- $defaults := dict
  "_sa" (dict "create" false "name" "default")
  "_hpa" (dict "min" 1 "max" 1 "memory" 90)
  "_resources" (dict
    "requests" (dict "cpu" "10m" "memory" "100Mi")
    "limits" (dict "cpu" "1200m" "memory" "512Mi") )
  "_image" (dict "policy" "IfNotPresent")
  "_livenessProbe" (dict "httpGet" (dict "path" "health/liveness" "port" $firstContainerPort ))
  "_readinessProbe" (dict "httpGet" (dict "path" "health/readiness" "port" $firstContainerPort ))
}}
{{- $values := dict "Values" $defaults }}
{{- $values | toYaml }}
{{- end }}
