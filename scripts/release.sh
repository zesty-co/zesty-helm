#!/bin/bash

bump_version() {
  current_version=$(yq .version Chart.yaml)
  echo "Releasing Current version : $current_version"
  bumped_version=$(echo "${current_version}")
  BUMPED=${bumped_version} yq -i '.version = strenv(BUMPED)' Chart.yaml
  RELEASE_FILE="zesty-${bumped_version}.tgz"
}

pack() {
  helm package .
}

index() {
  helm repo index --merge index.yaml --url "https://github.com/zesty-co/zesty-helm/releases/download/${bumped_version}" .
}

release() {
  gh release create "${bumped_version}" "${RELEASE_FILE}" --generate-notes --prerelease --title "Releasing the Zesty PVC package"
}

clean_workspace() {
  rm "${RELEASE_FILE}"
}

commit() {
  git add Chart.yaml index.yaml
  git commit -m "bump ${bumped_version}"
}

bump_version
pack
index
release
commit
clean_workspace
