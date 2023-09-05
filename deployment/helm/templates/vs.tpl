{{- if .Values.gateway.enabled }}
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: {{ include "devops-knowledge-share-ui.fullname" . }}
  labels:
    {{- include "devops-knowledge-share-ui.labels" . | nindent 4 }}
spec:
  hosts:
  - {{ .Values.fqdn }}
  gateways:
  - {{ include "devops-knowledge-share-ui.fullname" . }}
  http:
  - route:
    - destination:
        port:
          number: 80
        host: {{ include "devops-knowledge-share-ui.fullname" . }}
{{- end}}