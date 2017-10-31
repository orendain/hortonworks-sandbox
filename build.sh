#!/usr/bin/env bash

# Build options
version="0.5.0"
dockerRepo="orendain"

export PACKER_LOG=0

# Script directory
scriptDir="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

# Specifiy sandboxes to build
sandboxesToBuild=(

  # HDP Sandboxes
  hdp-sandbox-name

  # HDF Sandboxes
  hdp-sandbox-name
)

# Build docker image followed by packer job for each sandbox
# Addiitionally, tag the most-recently build image with the latest tag
for sandboxName in "${sandboxesToBuild[@]}";
do
  docker build -t $dockerRepo/sandbox-$sandboxName-pre:$version --build-arg VERSION=$version $scriptDir/$sandboxName
  cd $scriptDir/$sandboxName
  packer build -var "version=$version" -var "docker-repo=$dockerRepo" packer.json
done
