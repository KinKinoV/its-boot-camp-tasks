#!/bin/bash

#           This script isntalls metric-server, ingress (nginx) and cert-manager to your k8s cluster
# =============================================================================================================
# cert-manager CRDs
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.5/cert-manager.crds.yaml
# metrics-server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
# Installing nginx ingress and cert-manager from helm charts using helmfile
helmfile apply -f helmfile/ingress_cert_helmfile.yaml
# Creating ClusterIssuer
kubectl apply -n cert-manager -f clusterIssuer.yaml

# Wait for ingress pod to be ready
kubectl wait -n ingress \
    --for=condition=Ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=300s