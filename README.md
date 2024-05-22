# Zesty's Helm Chart
A Helm package to install [Zesty Disk's](https://zesty.co/products/zesty-disk/) components on a Kubernetes cluster

## Prerequisites
* Kubernetes 1.7+

## Installation
```
## IMPORTANT: Zesty requires an API key in order to function properly.

# Add the Zesty repo to your helm client
$ helm repo add zestyrepo https://zesty-co.github.io/zesty-helm

# Update the repo if it's already configured
$ helm repo update

# Install the chart
$ helm install zesty-pvc --set agent.apiKey=<API_KEY> zestyrepo/zesty
# If want to install also Prometheus Exporter container to expose Zesty Disk metrics install with `agent.prometheusExporter.port` variable that contains the port you want to expose the metrics on
$ helm install zesty-pvc --set agent.apiKey=<API_KEY> --set agent.prometheusExporter.port=<PORT> zestyrepo/zesty
```

## Uninstalling the Chart
To uninstall/delete:
```bash
$ helm delete zesty-pvc
```

## Monitoring
The Zesty collector exposes a `/metrics` endpoint so that Prometheus (or other compatible metric collectors) could scrape and collect different exported values.
In order to add the metrics to Prometheus, add a target by filtering the label `app=zesty-collector`.
