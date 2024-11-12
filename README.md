# Zesty Disk for Kubernetes Helm Chart
This document describes the Helm chart for Zesty Disk for K8s.
The resources here define, install, and manage the Zesty Disk for K8s application.
Use the Helm package to install [Zesty Disk](https://zesty.co/products/zesty-disk/) components on a K8s cluster.


## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Add the Zesty repository to your Helm client](#add-the-zesty-repository-to-your-helm-client)
- [Update a configured repository](#update-a-configured-repository)
- [Install the chart](#install-the-chart)
    - [To use the API Key as a secret:](#to-use-the-api-key-as-a-secret)
- [Helm installation args](#helm-installation-args)
- [Expose Zesty Disk filesystem metrics](#expose-zesty-disk-filesystem-metrics)
- [Monitoring](#monitoring)
- [Uninstalling the Chart](#uninstalling-the-chart)


## Prerequisites
The prerequisites are listed at [Deploy Zesty Disk for Kubernetes](https://docs.zesty.co/docs/deploy-zesty-disk-for-k8s) documentation site.

## Installation

### Add the Zesty repository to your Helm client
```bash
helm repo add zestyrepo https://zesty-co.github.io/zesty-helm
```

### Update a configured repository
```bash
helm repo update
```

### Install the chart
You can enter your Zesty API key in the command line, or you can define it using a secret.
```bash
helm install zesty-pvc [-n <ZESTY_HELM_NAMESPACE>] --set agentManager.apiKey=<API_KEY> zestyrepo/zesty
```

#### To use the API Key as a secret:
```shell
kubectl create secret generic zesty-disk-agent-cred --from-literal=ZESTY_API_KEY=<api-key>
```
> Using the secret method, there's no need to pass `--set agentManager.apiKey=<api-key>`

## Helm installation args
> All arguments are set either using the Helm `set` command `--set agentManager.apiKey=<API_KEY>` or through a `values.yaml` file.

| Option                                          | Description                                                                                                                                                                                 | Default                 |
|-------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------|
| `prefix`                                        | Provides a prefix to the resource namespace                                                                                                                                                 | `zesty-storage`         |
| `agentManager.secret.name`                      | The name of the secret contains the API key                                                                                                                                                 | `zesty-disk-agent-cred` |
| `agentManager.apiKey`                           | Zesty API key (the secret won't be used, if associated with a value)                                                                                                                        | ---                     |
| `agentManager.baseUrl`                          | The URL of the Zesty backend                                                                                                                                                                | ---                     |
| `agentManager.priorityClassName`                | The priority class for Zesty storage agent pods                                                                                                                                             | `system-node-critical`  |
| `agentManager.agent.resources.requests.cpu`     | The amount of CPU resources the agent container is requesting                                                                                                                               | `100m`                  |
| `agentManager.agent.resources.requests.memory`  | The amount of RAM resources the agent container is requesting                                                                                                                               | `128Mi`                 |
| `agentManager.agent.resources.limits.memory`    | The maximum amount of RAM resources the agent container can consume                                                                                                                         | `256Mi`                 |
| `agentManager.manager.resources.requests.cpu`   | The amount of CPU resources the manager container is requesting                                                                                                                             | `100m`                  |
| `agentManager.manager.resources.requests.memory`| The amount of RAM resources the manager container is requesting                                                                                                                             | `128Mi`                 |
| `agentManager.manager.resources.limits.memory`  | The maximum amount of RAM resources the manager container can consume                                                                                                                       | `256Mi`                 |
| `agentManager.prometheusExporter.enabled`       | Boolean flag to define if prometheusExporter container should be deployed                                                                                                                   | `false`                 |
| `agentManager.prometheusExporter.port`          | The port the prometheusExporter container exposes                                                                                                                                           | `9100`                  |
| `storageClassName`                              | Customize StorageClass name instead of using `defaultStorageClassProvisioner`'s value                                                                                                       | ---                     |
| `defaultStorageClassProvisioner`                | If `storageClassName` is not defined, this value will be used and be decided upon the first occurrence of the StorageClass whose provisioner is equal to `defaultStorageClassProvisioner`   | `ebs.csi.aws.com`       |
| `storageOperator.resources.requests.cpu`        | The amount of CPU resources the storageOperator container is requesting                                                                                                                     | `500m`                  |
| `storageOperator.resources.requests.memory`     | The amount of RAM resources the storageOperator container is requesting                                                                                                                     | `128Mi`                 |
| `storageOperator.resources.limits.cpu`          | The maximum amount of CPU resources the storageOperator container can consume                                                                                                               | `500m`                  |
| `storageOperator.resources.limits.memory`       | The maximum amount of RAM resources the storageOperator container can consume                                                                                                               | `256Mi`                 |
| `admission.mutator.replicas`                    | The amount of Mutator pod replicas                                                                                                                                                          | `2`                     |
| `admission.mutator.port`                        | The port the Mutator is listening to                                                                                                                                                        | `8443`                  |
| `admission.mutator.failurePolicy`               | Defines the behavior of the admission controller when a request fails. If set to `Ignore`, the request will be allowed even if the mutator fails.                                           | `Ignore`                |
| `admission.secret`                              | Secret name to be used by the mutator. If this is blank, a new secret will be created                                                                                                       | ---                     |
| `admission.failurePolicy`                       | Defines the behavior of the admission controller when a request fails. If set to `Ignore`, the request will be allowed even if the mutator fails.                                           | `Ignore`                |
| `scheduler.replicas`                            | The amount of Scheduler & Extender pod replicas                                                                                                                                             | `2`                     |
| `scheduler.logLevel`                            | The Scheduler & Extender pod log level                                                                                                                                                      | `1`                     |
| `extender.port`                                 | The port the Extender is listening to                                                                                                                                                       | `8888`                  |
| `nodeSelector`                                  | A global node selector rules that will be applied to all components                                                                                                                         | ---                     |
| `tolerations`                                   | A global tolerations that will be applied to all components                                                                                                                                 | ---                     |
| `affinity`                                      | A global affinity rules that will be applied to all components                                                                                                                              | ---                     |
| `imagePullSecrets`                              | The secrets with credentials to pull images from the registry                                                                                                                               | ---                     |
| `imagePullPolicy`                               | The image pull policy determines when to pull images from the registry. Possible values are Always, IfNotPresent, and Never.                                                                | `Always`                |
| `annotations`                                   | A global annotations that will be applied to all components                                                                                                                                 | ---                     |
| `additionalLabels`                              | A global additional labels that will be applied to all components                                                                                                                           | ---                     |
| `serviceAccount.create`                         | Creates a service account for the application                                                                                                                                               | `true`                  |
| `serviceAccount.name`                           | The name of the service account                                                                                                                                                             | `zesty-disk`            |
| `registry`                                      | The registry for the container images                                                                                                                                                       | ---                     |

## Expose Zesty Disk filesystem metrics
You can expose Zesty Disk filesystem metrics to Prometheus by setting `agentManager.prometheusExporter.enabled=true`
```bash
helm install zesty-pvc [-n <ZESTY_HELM_NAMESPACE>] --set agentManager.apiKey=<API_KEY> --set agentManager.prometheusExporter.enabled=true zestyrepo/zesty
```

## Monitoring
If the Zesty Disk PVC installation detects the `monitoring.coreos.com/v1` API, it will deploy a `podMonitor` object that directs the cluster's Prometheus to the Zesty Prometheus Exporter. This exporter provides Zesty Disk PVC metrics to Prometheus through the `/metrics` endpoint.
Enable monitoring with Prometheus by adding a target that filters the label `app=zesty-collector`

## Uninstalling the Chart
To uninstall/delete:
```bash
helm delete zesty-pvc [-n <ZESTY_HELM_NAMESPACE>]
```

[Zesty documentation site](https://docs.zesty.co/docs/zesty-disk-for-kubernetes)