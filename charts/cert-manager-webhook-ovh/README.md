
# cert-manager-webhook-ovh

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.3.1](https://img.shields.io/badge/AppVersion-0.0.1-informational?style=flat-square)

Cert Manager Webhook Resolver for OVH DNS Zone

This Helm chart enables seamless integration of cert-manager with OVH DNS Zone for managing DNS-01 challenges, leveraging the resources provided by the [cert-manager-webhook-ovh](https://github.com/baarde/cert-manager-webhook-ovh) project.  

The chart is designed to simplify deployment and configuration while maintaining compatibility with the webhook implementation provided in the repository. It allows users to install and manage the webhook in a Kubernetes environment using an online Helm chart.  

For additional details about the source code and implementation, please refer to the [cert-manager-webhook-ovh GitHub repository](https://github.com/baarde/cert-manager-webhook-ovh).

## Requirements

* [cert-manager](https://github.com/jetstack/cert-manager) version 1.5.3 or higher:
  - [Installing on Kubernetes](https://cert-manager.io/docs/installation/kubernetes/#installing-with-helm)

## Values
| Key                             | Description                                                                                                     | Default                                |
|---------------------------------|-----------------------------------------------------------------------------------------------------------------|----------------------------------------|
| `groupName`                     | A unique group name for identifying your company or business unit, used for DNS01 challenge webhook references. | `acme.mycompany.example`              |
| `certManager.namespace`         | Namespace where cert-manager is deployed.                                                                      | `cert-manager`                         |
| `certManager.serviceAccountName`| Name of the cert-manager service account.                                                                      | `cert-manager`                         |
| `image.repository`              | Container image repository for the webhook.                                                                    | `baarde/cert-manager-webhook-ovh`      |
| `image.tag`                     | Tag of the container image.                                                                                    | `latest` (commented by default)        |
| `image.pullPolicy`              | Image pull policy.                                                                                             | `IfNotPresent`                         |
| `imagePullSecrets`              | Secrets for pulling images from private registries.                                                            | `[]`                                   |
| `nameOverride`                  | Override the chart's name.                                                                                     | `""`                                   |
| `fullnameOverride`              | Override the chart's full name.                                                                                | `""`                                   |
| `service.type`                  | Kubernetes service type.                                                                                       | `ClusterIP`                            |
| `service.port`                  | Port number for the service.                                                                                   | `443`                                  |
| `resources`                     | Resource limits and requests for the pods.                                                                     | `{}`                                   |
| `nodeSelector`                  | Node selector for pod scheduling.                                                                              | `{}`                                   |
| `tolerations`                   | Tolerations for pod scheduling.                                                                                | `[]`                                   |
| `affinity`                      | Affinity rules for pod scheduling.                                                                             | `{}`                                   |
