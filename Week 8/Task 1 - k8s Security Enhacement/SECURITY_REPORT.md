# Task 1 - Enhacing k8s cluster security

In this task I enhacned k8s cluster security by following known k8s security best practices ([OWASP](https://cheatsheetseries.owasp.org/cheatsheets/Kubernetes_Security_Cheat_Sheet.html), [CIS](https://www.cisecurity.org/benchmark/kubernetes) (using Trivy) ).

## Scanning cluster for issues and choosing mitigation strategies

Before implementing any improvements to security I decided to scan k8s cluster for any issues using Trivy. Resulting reports of the cluster vulnerabilities and problems are available [here](/Week%208/Task%201%20-%20k8s%20Security%20Enhacement/reports).

[sample-django_namespace_report](/Week%208/Task%201%20-%20k8s%20Security%20Enhacement/reports/sample-django_namespace_report.txt) was created from scanning sample-django namespace, where all needed resources for sample-django application are deployed.

The main problem with my deployment was absence of pods' and containers' `securityContext` specification in deployment manifest that enabled privilege escalation attacks in deployed containers.

To mitigate named and potential problems I've done next:
[1.](#1-securitycontext) Correctly configured `securityContext`
[2.](#2-service-account) I decided to create Service Account to follow best practices.

### 1. `securityContext`

I implemented `securityContext` using this config:
```yaml
podSecurityContext:
  supplementaryGroups: [100]

securityContext:
  capabilities:
    drop:
    - ALL
  readOnlyRootFilesystem: false
  runAsNonRoot: true
  runAsUser: 1001
  allowPrivilegeEscalation: false
```
`podSecurityContext` is applied to pod itself and `securityContext` is applied to containers. Before applying these changes, I had to patch nfs-share deployment to allow non-root users to make changes to volume, so that sample-django container will be able to collect static files in provisioned nfs-share. Patch used was taken from [issue](https://github.com/openebs-archive/dynamic-nfs-provisioner/issues/46#issuecomment-856465595) with similar problem:
```bash
kubectl patch deploy "*pv-deployment-name*" -p '{"spec":{"template":{"spec":{"securityContext": {"fsGroup": 100, "fsGroupChangePolicy": "OnRootMismatch"}}}}}' -n openebs-nfs-provisioner
```
After doing everything, pv is correctly mounted to pod with required permisions for the files:
![alt text](/Week%208/Task%201%20-%20k8s%20Security%20Enhacement/reports/securityContext_result.png)

And any interaction in non-required paths is not allowed:
![alt text](/Week%208/Task%201%20-%20k8s%20Security%20Enhacement/reports/correct_permissions.png)

### 2. Service Account

To create Service Account, [serviceAccount.yaml](/Week%208/Task%201%20-%20k8s%20Security%20Enhacement/sample-django-secure/templates/serviceAccount.yaml) template was added, and to improve security, this Service Account won't have any roles provided, which means this Pod won't be able to do anything in the k8s cluster, because deployed sample-django aplication doesn't needs it.

## Tests

To test sample-django release I wrote 2 test: [test-connection.yaml](/Week%208/Task%201%20-%20k8s%20Security%20Enhacement/sample-django-secure/templates/tests/test-connection.yaml) and [test-db-connection.yaml](/Week%208/Task%201%20-%20k8s%20Security%20Enhacement/sample-django-secure/templates/tests/test-db-connection.yaml).

1. `test-connection.yaml` tests availability of the sample-django pods in the cluster by provisioning busybox pod and executing wget command to the sample-django pod.
2. `test-db-connection.yaml` tests connection to the database utilizing postgres:alpine image and Secret provisioned for sample-django app to connect to DB using psql.

Result of the `helm test -n sample-django sample-django`:
![alt text](/Week%208/Task%201%20-%20k8s%20Security%20Enhacement/reports/chart_tests_result.png)