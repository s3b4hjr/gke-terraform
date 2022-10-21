{{/*
Expand the name of the chart.
*/}}
{{- define "bootcamp.name" -}}
{{- default (lower .Chart.Name) .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "bootcamp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bootcamp.labels" -}}
{{ include "bootcamp.selectorLabels" . }}
helm.sh/chart: {{ include "bootcamp.chart" . }}
app.kubernetes.io/version: {{ default .Chart.AppVersion .Values.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bootcamp.selectorLabels" -}}
app: {{ include "bootcamp.name" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bootcamp.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bootcamp.name" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
