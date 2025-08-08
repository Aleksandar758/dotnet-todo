{{- define "testapp.name" -}}
testapp
{{- end -}}

{{- define "testapp.fullname" -}}
{{ .Release.Name }}-testapp
{{- end -}}
