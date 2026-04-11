{{- define "my-deployment.tpl" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.appName.app }}
spec:
  replicas: {{ .Values.replicas }}
  selector:
    matchLabels:
      app: {{ .Values.appName.app }}
  template:
    metadata:
      labels:
        app: {{ .Values.appName.app }}
    spec:
          # select only all the key:values inside specific key
      nodeSelector: 
      {{- toYaml .Values.nodeSelector | nindent 7 }} #nindent = space
      containers:
      - name: {{ .Values.appName.app }}-con
      ## option2 using {with}
      {{- with .Values.container }}
        image: {{ .image }}
        imagePullPolicy: {{ .pullPolicy }}
        ports:
        - containerPort: {{ .port }}
      {{- end }}
      {{- if .Values.volumeMounts }}
        volumeMounts:
        {{- range .Values.volumeMounts }}
        - name: {{ .name }}
          moutPath: {{ .mountPath }}
        {{- end }}
      {{- end }}

        ## option1 
        # image: {{ .Values.container.image }}
        # imagePullPolicy: {{ .Values.container.pullPolicy }}
        # ports:
        # - containerPort: {{ .Values.container.port }}

        resources:
          limits:
            memory: "128Mi"
            cpu: "500m"
        env: 
        {{- range .Values.container.envs }}
          - name: {{ .name }}
            value: {{ .value }}
        {{- end}}
    {{- if .Values.volumes }}
      volumes:
      {{- range .Values.volumes }}
        {{- toYaml . | nindent 7 }}
      {{- end }}
    {{- end }}

{{- end }}