{{- define "todo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 -}}
{{- end -}}

{{- define "todo.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "todo.name" .) -}}
{{- end -}}
