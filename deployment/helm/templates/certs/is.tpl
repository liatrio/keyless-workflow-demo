{{- if .Values.ingressSecret.enabled }}
apiVersion: di.exampleCompany.com/v1
kind: IngressSecret
metadata:
  name: {{ .Values.ingressSecret.certName }}
spec:
  cert: {{ .Values.ingressSecret.publicCert }}
  path_to_key:
    {{- .Values.team -}}
    /
    {{- .Values.environment -}}
    /
    {{- include "devops-knowledge-share-ui.fullname" . -}}
    /tlscert
{{- end }}
