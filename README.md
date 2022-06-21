# Zesty's Helm Chart
A Helm package to install [Zesty Disk's](https://zesty.co/products/zesty-disk/) components on a Kubernetes cluster

## Prerequisites
* Kubernetes 1.7+
* `btrfs-progs` on cluster nodes

## Installation
```
## IMPORTANT: Zesty requires an API key in order to function properly.

# Add the Zesty repo to your helm client
$ helm repo add zestyrepo https://zesty-co.github.io/zesty-helm

# Install the chart
$ helm install zesty --set apikey="" zestyrepo/zesty-helm
```

