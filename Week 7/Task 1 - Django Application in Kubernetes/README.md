# Task 1 - Django Application in Kubernetes

In this task I created Kubernetes cluster on Digital Ocean and deployed sample-django app to this cluster.

This solution uses Helm charts and helmfile to successfuly deploy sample-django app to k8s cluster and serve application on chosen doamin (in my case: https://django.kinkinov.com ).

## Used Helm charts

| Chart | Version | Source |
|-------|---------|--------|
| ingress-nginx | `4.10.1` | [Artifact_Hub](https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx)|
| cert-manager | `1.14.5` | [Artifact_Hub](https://artifacthub.io/packages/helm/cert-manager/cert-manager) |
| sample-django | `0.1.0` | This repo |

## Screenshots of successfull deployment

Loaded main page with certificate for HTTPS:

![alt text](Main%20page%20of%20sample-django%20from%20k8s%20cluster.png)