{{- define "hugo-site.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "hugo-site.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- include "hugo-site.name" . -}}
{{- end -}}
{{- end -}}

{{- define "hugo-site.labels" -}}
app.kubernetes.io/name: {{ include "hugo-site.name" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "hugo-site.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hugo-site.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
