# Task 2 - Kubernetes Audit Logging

In this task I configured log collection solution using ELK stack and tried to detect suspicious activity using it.

## Aquired insight

After deploying ELK stack to k8s cluster I started getting logs from all nodes available, which became available as indexes in Kibana data view creation field, each one is for logs from corresponding namespace:
![alt text](/Week%208/Task%202%20-%20Kubernetes%20Audit%20Logging/images/logIndexes.png)

I created several data views, one for each collection available:

![alt text](/Week%208/Task%202%20-%20Kubernetes%20Audit%20Logging/images/dataViews.png)

And after switching to any data view, I have list of all logs available from specified k8s namespace:
![alt text](/Week%208/Task%202%20-%20Kubernetes%20Audit%20Logging/images/logsInKibana.png)

## Helm charts used

| Chart | Version | Repository |
|-------|---------|------------|
| elastic/elasticsearch | 8.5.1 | [Artifact_Hub](https://artifacthub.io/packages/helm/elastic/elasticsearch) |
| elastic/kibana | 8.5.1 | [Artifact_Hub](https://artifacthub.io/packages/helm/elastic/kibana) |
| elastic/logstash | 8.5.1 | [Artifact_Hub](https://artifacthub.io/packages/helm/elastic/logstash) |
| elastic/filebeat | 8.5.1 | [Artifact_Hub](https://artifacthub.io/packages/helm/elastic/filebeat) |
| sample-django | 0.3.0 | [this_repo](/Week%208/Task%201%20-%20k8s%20Security%20Enhacement/sample-django-secure/) |

## Deployment Guide

To successfully deploy ELK stack I created two bash scripts that automatically configure k8s cluster:
1. `clusterSetup.sh` -- deploys nginx ingress, cert-manager and metrics-server to k8s cluster
2. `helmfile/install_elk.sh` -- deploys ELK stack to cluster in correct order and wait conditions, so that helm installations won't break.

Installation guide:
1. Execute `clusterSetup.sh` script from `Task 2 - Kubernetes Audit Logging/` folder
    (Optional: configure domain names, if you plan to expose kibana and other components over ingress)
2. Edit `-values.yaml` files in `helmfile/values/` directory to fit your needs
3. Execute `install_elk.sh` script from `helmfile/` folder
