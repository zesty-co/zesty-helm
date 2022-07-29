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

## Uninstalling the Chart
To uninstall/delete:
```bash
$ helm delete my-release
```

## Configuration
The following table lists the configurable parameters of the zesty-disk chart and their default values.
| Parameter | Description | Default |
| --------- | ----------- | ------- |
| namespace | The K8s target namespace | "default" |
| apikey  | Zesty API key | "" |
| registry  | The Docker registry used to pull images | "zestyco" |

## Usage
In order to start utilising Zesty Disk in your cluster, after installing the chart, go ahead and create a `StatefulSet` (or add to an existing one) the label `ZestyDisk: true` **to its pods** (under `statefulset.spec.template.metadata.labels`).
Once the pods are labeled, every new PV created (whether through the `volumeClaimTemplates` of the StatefulSet or another way) will start being tracked by the system.

Here's an example yaml to get you started:

```yaml
# We need a headless service for the pods network identity
kind: Service
apiVersion: v1
metadata:
  name: demo-app-service
  labels:
    app: "demo"
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    ZestyDisk: "true"
    app: "demo"
---
kind: StatefulSet
apiVersion: apps/v1
metadata:
  name: demo-app-statefulset
spec:
  selector:
    matchLabels:
      ZestyDisk: "true"
      app: "demo"
  serviceName: "demo-app-service"
  replicas: 1
  template:
    metadata:
      labels:
        app: "demo"
        ZestyDisk: "true"
    spec:
      terminationGracePeriodSeconds: 10
      containers:
        - name: demo-app
          image: my-demo-app:latest
          volumeMounts:
            - mountPath: "/zesty-disk"
              name: storage
  volumeClaimTemplates:
  - metadata:
      name: storage
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "zesty-storageclass"
      resources:
        requests:
          storage: 15Gi
```
