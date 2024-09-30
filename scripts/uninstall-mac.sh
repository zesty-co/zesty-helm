#!/bin/bash

# Query k8s api for multiple resources with field
# kubectl get statefulsets,services --all-namespaces --field-selector metadata.namespace!=default

#if [ $# -lt 2 ] ; then
#  echo "You didn't provide pod and pvc names, this will cause removing ALL pods and PVCs in the cluster prefixed 'zd-'"
#  read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
#
#  echo "Usage:"
#  echo "1. Provide a Pod name as a first (1st) argument"
#  printf "2. Provide a PVC name as a second (2nd) argument\n\n"
#  echo "Example:"
#  echo "./uninstall my-pod my-pvc"
#fi
#
POD_NAME=$1
#PVC_NAME=$2

#FS_NAME="$PVC_NAME"-"$POD_NAME"
#echo "Removing POD: $POD_NAME, PVC: $PVC_NAME, FS: $FS_NAME"
echo "The operation will remove ALL PODs, PVCs, PVs, VolumeAttachments and FS in you cluster in current namespace"
read -p "Are you sure you want to continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

# get all va for a pvc
#VOLUME_ATTACHMENTS=$(kubectl get fs "$PVC_NAME" -o=jsonpath='{.spec.volumeAttachments}')

echo "Removing volume attachments"
#kubectl delete volumeattachments "$VOLUME_ATTACHMENTS"
kubectl get volumeattachments --no-headers | awk '{print $1}' | xargs kubectl patch volumeattachments -p '{"metadata":{"finalizers":null}}'
kubectl get volumeattachments --no-headers | awk '{print $1}' | xargs kubectl delete volumeattachments

echo "Removing volume PVC"
kubectl get pvc --no-headers | awk '{print $1}' | xargs kubectl patch pvc -p '{"metadata":{"finalizers":null}}'
kubectl get pvc --no-headers | grep -ie "^zd-csi-" | awk '{print $1}' | xargs kubectl delete pvc
kubectl get pvc --no-headers | awk '{print $1}' | xargs kubectl delete pvc

echo "Removing volume PV"
kubectl get pv --no-headers | awk '{print $1}' | xargs kubectl patch pv -p '{"metadata":{"finalizers":null}}'
kubectl get pv --no-headers | awk '{print $1}' | xargs kubectl delete pv

echo "Removing volume FS"
kubectl get fs --no-headers | awk '{print $1}' | xargs kubectl delete fs
#kubectl get fs | grep -ie "^$PVC_NAME" | awk '{print $1}' | xargs kubectl delete fs

kubectl delete statefulsets "$POD_NAME" --force