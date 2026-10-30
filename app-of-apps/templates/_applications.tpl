{{- define "application" -}}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: {{ .app.name }}-{{ .env.name }}
  namespace: argocd
spec:
  project: {{ .app.project }}
  sources:
    - repoURL: {{ .top.Values.defaultSource.repoURL }}
      targetRevision: {{ .top.Values.defaultSource.targetRevision }}
      path: {{ .app.path }}
      helm:
        releaseName: {{ .app.releaseName | default .app.name }}
        valueFiles:
          {{- range .app.valueFiles }}
          - $values{{ . }}
          {{- end }}
    - repoURL: {{ .top.Values.defaultSource.repoURL }}
      targetRevision: {{ .top.Values.defaultSource.targetRevision }}
      ref: values
  destination:
    server: {{ (.env.destination).server | default .top.Values.defaultDestination.server }}
    namespace: {{ (.app.namespace) | default .top.Values.defaultDestination.namespace }}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - PrunePropagationPolicy=foreground
      - PruneLast=true
{{- end -}}
