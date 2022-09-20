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
$ helm install zesty --set apikey="" zestyrepo/zesty-helm
```

## Uninstalling the Chart
To uninstall/delete:
```bash
$ helm delete zesty
```

## Configuration
The following table lists the configurable parameters of the zesty-disk chart and their default values.
| Parameter | Description | Default |
| --------- | ----------- | ------- |
| namespace | The K8s target namespace | "default" |
| apikey  | Zesty API key | "" |
| registry  | The Docker registry used to pull images | "zestyco" |

## Usage
Once the chart is installed, a new [CRD](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) is installed - "ZestfulSet". As the name suggest, a `ZestfulSet` (`zts` in short) is a custom resources that manages stateful workloads.

A `ZestfulSet` simply holds a standard `StatefulSet` in the `StatefulSetSpec` field:

```yaml
apiVersion: apps.zesty.co/v1alpha1
kind: ZestfulSet
metadata:
  name: zestfulset-sample
spec:
  statefulSetSpec:
    # standard statefulset configuration...
```

In order to start utilizing a `ZestfulSet` in your cluster, go ahead and create it locally and deploy it into the cluster. Once it's created, the ZTS controller will manage the lifecycle of your stateful application and its storage.

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

apiVersion: apps.zesty.co/v1alpha1
kind: ZestfulSet
metadata:
  name: demo-app-statefulset
spec:
  statefulSetSpec:
    selector:
      matchLabels:
        app: "demo"
    serviceName: "demo-app-service"
    template:
      metadata:
        labels:
          app: "demo"
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

## Monitoring
The Zesty collector exposes a `/metrics` endpoint so that Prometheus (or other compatible metric collectors) could scrape and collect different exported values.
In order to add the metrics to Prometheus, add a target by filtering the label `app=zesty-collector`.
