# Task 1 - Django Application in Kubernetes

In this task I created Kubernetes cluster on Digital Ocean and deployed sample-django app to this cluster.

This solution uses Helm charts and helmfile to successfuly deploy sample-django app to k8s cluster.

## Used Helm charts

| Chart | Version | Source |
|-------|---------|--------|
| ingress-nginx | `4.10.1` | [Artifact_Hub](https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx)|
| cert-manager | `1.14.5` | [Artifact_Hub](https://artifacthub.io/packages/helm/cert-manager/cert-manager) |
| sample-django | `0.1.0` | This repo |