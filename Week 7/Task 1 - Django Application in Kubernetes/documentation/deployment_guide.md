# How to use chart and helmfile

This is a short guide how to deploy sample-django app using chart provided in this repo.

## Requirements
1. [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
2. [helm](https://helm.sh/docs/intro/install/)
3. [helm-secrets](https://github.com/jkroepke/helm-secrets/wiki/Installation) plugin
4. [helmfile](https://helmfile.readthedocs.io/en/latest/#installation)

## Release only sample-django

1. Go to `sample-django/` directory
2. Create .yaml file with database connection credentials (example: [unencrypted_secrets_example.yaml](/Week%207/Task%201%20-%20Django%20Application%20in%20Kubernetes/helmfile/unencrypted_secrets_example.yaml))
3. Edit `values.yaml` file to have your domain(`ingress.hosts.host`), ACME registration e-mail(`clusterIssuer.privateSecretRef`), and TLS hosts(`ingress.tls.hosts`)
4. Execute `helm secrets install RELEASE_NAME -f values.yaml -f YOUR_SECRETS.yaml .`

## Apply all required charts using helmfile

1. Go to `helmfile/` directory
2. Create `values.yaml` file with values you wish to change from default ones
3. Create encrypted `secrets.yaml` file with database connection credentials
4. Execute `helmfile init`
5. Execute `helmfile apply`