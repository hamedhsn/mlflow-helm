{{/*
Expand the name of the chart.
*/}}
{{- define "mlflow-helm.name" -}}
{{- default .Chart.Name .Values.server.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mlflow-helm.fullname" -}}
{{- if .Values.server.fullnameOverride }}
{{- .Values.server.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.server.nameOverride }}
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
{{- define "mlflow-helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mlflow-helm.labels" -}}
helm.sh/chart: {{ include "mlflow-helm.chart" . }}
{{ include "mlflow-helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mlflow-helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mlflow-helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mlflow-helm.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create }}
{{- default (include "mlflow-helm.fullname" .) .Values.server.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.server.serviceAccount.name }}
{{- end }}
{{- end }}

#{{/*
#The list of `env` for server Pods
#EXAMPLE USAGE: {{ include "mlflow.env" (dict "Release" .Release "Values" .Values "CONNECTION_CHECK_MAX_COUNT" "0") }}
#*/}}
{{- define "mlflow.env" }}
- name: DATABASE_NAME
  value: {{ .Values.postgresql.postgresqlDatabase | quote }}
- name: DATABASE_URL
  value: {{ .Values.server.db.url | quote }}
- name: DATABASE_PORT
  value: {{ .Values.server.db.port | quote }}
- name: ARTIFACT_STORE
  value: {{ .Values.server.artifact.name | quote }}
{{- /* set DATABASE_USER */ -}}
{{- if .Values.postgresql.enabled }}
- name: DATABASE_USER
  value: {{ .Values.postgresql.postgresqlUsername | quote }}
{{- else }}
#{{- if .Values.externalDatabase.userSecret }}
#- name: DATABASE_USER
#  valueFrom:
#    secretKeyRef:
#      name: {{ .Values.externalDatabase.userSecret }}
#      key: {{ .Values.externalDatabase.userSecretKey }}
#{{- else }}
{{- /* in this case, DATABASE_USER is set in the `-config-envs` Secret */ -}}
{{- end }}
{{- end }}

{{- /* set DATABASE_PASSWORD */ -}}
{{- if .Values.postgresql.enabled }}
{{- if .Values.postgresql.existingSecret }}
- name: DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.postgresql.existingSecret }}
      key: {{ .Values.postgresql.existingSecretKey }}
{{- else }}
- name: DATABASE_PASSWORD
  value: {{ .Values.postgresql.postgresqlPassword | quote }}
{{- end }}
{{- else }}
#{{- if .Values.externalDatabase.passwordSecret }}
#- name: DATABASE_PASSWORD
#  valueFrom:
#    secretKeyRef:
#      name: {{ .Values.externalDatabase.passwordSecret }}
#      key: {{ .Values.externalDatabase.passwordSecretKey }}
#{{- else }}
{{- /* in this case, DATABASE_PASSWORD is set in the `-config-envs` Secret */ -}}
{{- end }}
{{- end }}

{{- /* user-defined environment variables */ -}}
{{- if .Values.server.extraEnv }}
{{ toYaml .Values.server.extraEnv }}
{{- end }}
{{- end }}

