{{/*
Expand the name of the chart.
*/}}
{{- define "devops-knowledge-share-ui.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "devops-knowledge-share-ui.fullname" -}}
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
{{- define "devops-knowledge-share-ui.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "devops-knowledge-share-ui.labels" -}}
helm.sh/chart: {{ include "devops-knowledge-share-ui.chart" . }}
app: {{ include "devops-knowledge-share-ui.name" . }}
version: {{ default .Chart.AppVersion .Values.tag }}
{{ include "devops-knowledge-share-ui.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- include "devops-knowledge-share-ui.exampleCompanyLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "devops-knowledge-share-ui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "devops-knowledge-share-ui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
exampleCompany labels
*/}}
{{- define "devops-knowledge-share-ui.exampleCompanyLabels" -}}
{{- if .Values.teamname }}
exampleCompany.com/managed-by-team: {{ .Values.teamname }}
{{- end -}}
{{- if .Values.reponame }}
exampleCompany.com/repo: {{ .Values.reponame }}
{{- end -}}
{{- end -}}

{{/*
Image Repository
*/}}
{{- define "devops-knowledge-share-ui.container" -}}
{{- if .Values.image.registry }}
    {{- .Values.image.registry -}}
    /
{{- end -}}
{{- .Values.image.repository -}}
:
{{- .Values.image.tag | default .Chart.AppVersion }}
{{- end -}}
