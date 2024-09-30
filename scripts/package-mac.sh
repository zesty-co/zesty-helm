#!/bin/bash

if [ -z "$1" ] ; then
    echo "Please add chart version argument"
  exit 1
fi

HELM_VERSION=$1

OUTPUT="output"

# TODO: download from gitlab
cp ~/Library/Caches/helm/repository/zesty-"$HELM_VERSION".tgz /tmp/"$OUTPUT"/zesty-"$HELM_VERSION".tgz.tmp
cp ebs-sc.yaml /tmp/$OUTPUT

echo "merge values-production.yaml with values.yaml"
cd /tmp/$OUTPUT || exit

# merge values files
tar -xzf zesty-"$HELM_VERSION".tgz.tmp zesty/values.yaml zesty/values-production.yaml
yq eval-all '. as $item ireduce ({}; . * $item )' zesty/values.yaml zesty/values-production.yaml > zesty/values.new.yaml
rm zesty/values.yaml  
mv zesty/values.new.yaml zesty/values.yaml

echo "Create tgz without redundant files"
if ! tar -czf zesty-"$HELM_VERSION".tgz --exclude="zesty/values*.yaml" --exclude="zesty/index.yaml" @zesty-"$HELM_VERSION".tgz.tmp ; then
  echo "Failed to create tgz"
  exit 1
else
  rm zesty-"$HELM_VERSION".tgz.tmp
fi

# must unzip the file to be able to update the tar
echo "Pack new values.yaml into tar file"
gunzip zesty-"$HELM_VERSION".tgz
tar -uvf zesty-"$HELM_VERSION".tar zesty/values.yaml
gzip zesty-"$HELM_VERSION".tar
echo "Rename tar file into tgz"
mv zesty-"$HELM_VERSION".tar.gz zesty-"$HELM_VERSION".tgz
rm -rf zesty

echo "package all products: zesty-$HELM_VERSION.tgz, ebs-sc.yaml and values.yaml into zesty-pvc-$HELM_VERSION.tar.gz"
cd /tmp || exit
tar -czf zesty-pvc-"$HELM_VERSION".tar.gz $OUTPUT
mkdir -p ~/Workspace/zesty/zd-pvc/releases
cp zesty-pvc-"$HELM_VERSION".tar.gz ~/Workspace/zesty/zd-pvc/releases
cd - || exit