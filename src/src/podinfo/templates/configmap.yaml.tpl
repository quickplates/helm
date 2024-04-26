apiVersion: v1
kind: ConfigMap
metadata:
  {{- include "podinfo.configMapMetadata" . | nindent 2 }}
data:
  PODINFO_PORT: {{ required "app.port is required" (.Values.app).port | int | quote }}
