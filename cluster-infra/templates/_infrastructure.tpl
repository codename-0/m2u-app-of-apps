{{- define "infraApplication" -}}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: {{ .infra.name }}-{{ .env.name }}
  namespace: argocd
  labels:
    app.kubernetes.io/part-of: cluster-infra
spec:
  project: default
  sources:
    - repoURL: {{ .infra.repoURL }}
      targetRevision: {{ .infra.targetRevision }}
      helm:
        releaseName: {{ .infra.name }}
        valueFiles:
          {{- range .infra.valueFiles }}
          - $values{{ . }}
          {{- end }}
    
    - repoURL: {{ .top.Values.defaultSource.repoURL }}
      targetRevision: {{ .top.Values.defaultSource.targetRevision }}
      ref: values

  destination:
    server: {{ (.env.destination).server | default .top.Values.defaultDestination.server }}
    namespace: {{ .infra.namespace }}
    
  syncPolicy:
    automated:
      selfHeal: true
      prune: true
    syncOptions:
      - CreateNamespace=true
      - PrunePropagationPolicy=foreground
      - ServerSideApply=true
{{- end -}}