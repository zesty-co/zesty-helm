#!/bin/bash

current_version=$(yq .version Chart.yaml)
bumped_version=$(echo "${current_version}" | awk -F. '{$NF = $NF + 1;} 1' | sed 's/ /./g')
BUMPED=${bumped_version} yq -i '.version = strenv(BUMPED)' Chart.yaml
