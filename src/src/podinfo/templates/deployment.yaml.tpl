apiVersion: apps/v1
kind: Deployment
metadata:
  {{- include "podinfo.deploymentMetadata" . | nindent 2 }}
spec:
  replicas: 1
  selector:
    matchLabels:
      {{- include "podinfo.selector" . | nindent 6 }}
  template:
    metadata:
      {{- include "podinfo.podMetadata" . | nindent 6 }}
    spec:
      containers:
        - name: {{ include "podinfo.containerName" . | quote }}
          image: "ghcr.io/stefanprodan/podinfo:{{ .Chart.AppVersion }}"
          ports:
            - name: http
              protocol: TCP
              containerPort: {{ required "app.port is required" (.Values.app).port | int }}
          envFrom:
            - configMapRef:
                name: {{ include "podinfo.configMapName" . | quote }}
          livenessProbe:
            httpGet:
              path: /healthz
              port: http
            failureThreshold: 6
          readinessProbe:
            httpGet:
              path: /readyz
              port: http
            failureThreshold: 6
      {{- with (.Values.pod).spec }}
      {{- toYaml . | nindent 6 }}
      {{- end }}
  {{- with (.Values.deployment).spec }}
  {{- toYaml . | nindent 2 }}
  {{- end }}
