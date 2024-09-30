#!/bin/bash

# AWS sso login
# aws sso login --profile staging
OUTPUT=/tmp/output
# staging
ACCOUNT_ID=473301030746
# RND
#ACCOUNT_ID=577926974532

aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com

helm repo update
helm show values zesty-pvc-staging/zesty > /tmp/helm-images

AGENT_TAG=$(yq '.agentManager.agent.image.tag' /tmp/helm-images)
MANAGER_TAG=$(yq '.agentManager.manager.image.tag' /tmp/helm-images)
OPERATOR_TAG=$(yq '.storageOperator.image.tag' /tmp/helm-images)

rm -rf $OUTPUT
mkdir $OUTPUT

docker pull "$ACCOUNT_ID".dkr.ecr.us-west-2.amazonaws.com/zd/k8s/manager:"$MANAGER_TAG"
docker tag "$ACCOUNT_ID".dkr.ecr.us-west-2.amazonaws.com/zd/k8s/manager:"$MANAGER_TAG" zd/k8s/manager:"$MANAGER_TAG"
docker save zd/k8s/manager:"$MANAGER_TAG" --output "$OUTPUT"/manager:"$MANAGER_TAG"

docker pull "$ACCOUNT_ID".dkr.ecr.us-west-2.amazonaws.com/zd/k8s/agent:"$AGENT_TAG"
docker tag "$ACCOUNT_ID".dkr.ecr.us-west-2.amazonaws.com/zd/k8s/agent:"$AGENT_TAG" zd/k8s/agent:"$AGENT_TAG"
docker save zd/k8s/agent:"$AGENT_TAG" --output "$OUTPUT"/agent:"$AGENT_TAG"

docker pull "$ACCOUNT_ID".dkr.ecr.us-west-2.amazonaws.com/zd/k8s/storage-operator:"$OPERATOR_TAG"
docker tag "$ACCOUNT_ID".dkr.ecr.us-west-2.amazonaws.com/zd/k8s/storage-operator:"$OPERATOR_TAG" zd/k8s/storage-operator:"$OPERATOR_TAG"
docker save zd/k8s/storage-operator:"$OPERATOR_TAG" --output "$OUTPUT"/storage-operator:"$OPERATOR_TAG"