# Zesty's Helm Chart
A Helm package to install [Zesty Disk's](https://zesty.co/products/zesty-disk/) components on a Kubernetes cluster

## Prerequisites
* Kubernetes 1.7+

## Installation
Acquire API Key by: (going to this url: ..., clicking on whatever)
// Zesty requires an API key in order to function properly. # TODO: How do I get this API Key?

# Add the Zesty repo to your helm client
```bash
helm repo add zestyrepo https://zesty-co.github.io/zesty-helm
```

# Update the repo if it's already configured
```bash
helm repo update
```

# Install the chart
```bash
helm install zesty-pvc --set agent.apiKey=<API_KEY> zestyrepo/zesty
```

### Helm installation args
> All args are set using helm's `set` command: `--set agent.apiKey=<API_KEY>`

| Option                           | Description                                       | Default           |
|----------------------------------|---------------------------------------------------|-------------------|
| `agent.apiKey`                   | apiKey received by (#: TODO: Complete this )      |                   |
| `agent.prometheusExporter.port`  | Prometheus port ( #: TODO: See more info here )   |                   |
| `defaultStorageClassProvisioner` | If storageClassName is not defined, this value will take affect and be decided upon the first occurance of the StorageClass that has a provisioner equals to `defaultStorageClassProvisioner`     | `ebs.csi.aws.com` |
| `storageClassName`               | Customize StorageClass name instead of using                `defaultStorageClassProvisioner`'s value                                                                                  |                   |


## Exposing Zesty Disk Metrics
Zesty Disk is able to expose (# TODO: These metrics) by setting `agent.prometheusExporter.port` and (# TODO: choosing a random unusued port??)
```bash
helm install zesty-pvc --set agent.apiKey=<API_KEY> --set agent.prometheusExporter.port=<PORT> zestyrepo/zesty
```

## Uninstalling the Chart
To uninstall/delete:
```bash
helm delete zesty-pvc
```

## Monitoring
The Zesty collector exposes a `/metrics` endpoint so that Prometheus (or other compatible metric collectors) could scrape and collect different exported values.
In order to add the metrics to Prometheus, add a target by filtering the label `app=zesty-collector`.
