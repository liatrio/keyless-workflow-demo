{{- if .Values.gateway.enabled }}
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: {{ include "devops-knowledge-share-ui.fullname" . }}
  labels:
    {{- include "devops-knowledge-share-ui.labels" . | nindent 4 }}
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - {{ .Values.fqdn }}
    tls:
      httpsRedirect: true
  - port:
      number: 443
      name: https
      protocol: HTTPS
    hosts:
    - {{ .Values.fqdn }}
    tls:
      credentialName: {{ .Values.gateway.tlsCredentialName }}
      mode: SIMPLE
{{- end }}
