#!/bin/bash
# Text collor vars
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
WHITE='\033[0m'

#                       This script installs ELK stack to your k8s cluster using helm charts and helmfiles
# =================================================================================================================================
# Installing Elasticsearch
echo -e "${YELLOW}Installing Elasticsearch${WHITE}"
helmfile apply -f elasticsearch_helmfile.yaml
kubectl wait -n elk \
    --for=condition=Ready pod \
    --selector=release=elasticsearch \
    --timeout=500s

# Installing Kibana
echo -e "${YELLOW}Installing Kibana${WHITE}"
helmfile apply -f kibana_helmfile.yaml
# Waiting for Kibana to be Ready
kubectl wait -n elk \
    --for=condition=Ready pod \
    --selector=release=kibana \
    --timeout=300s

# Installing Logstash
echo -e "${YELLOW}Installing Logstash${WHITE}"
helmfile apply -f logstash_helmfile.yaml
kubectl wait -n elk \
    --for=condition=Ready pod \
    --selector=release=logstash \
    --timeout=300s

# Installing Filebeat
echo -e "${YELLOW}Installing Filebeat${WHITE}"
helmfile apply -f filebeat_helmfile.yaml
kubectl wait -n elk \
    --for=condition=Ready pod \
    --selector=release=filebeat \
    --timeout=300s

echo -e "${GREEN}ELK stack has been successfully installed on your k8s cluster!"
echo -e "${BLUE}Here are credentials to log into Kibana:"
echo -ne "${YELLOW}Username:${RED}" && kubectl get secret -n elk elasticsearch-master-credentials -o jsonpath='{.data.username}' | base64 --decode && echo ""
echo -ne "${YELLOW}Password:${RED}" && kubectl get secret -n elk elasticsearch-master-credentials -o jsonpath='{.data.password}' | base64 --decode && echo ""