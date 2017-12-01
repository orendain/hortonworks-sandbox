#!/usr/bin/env bash

# Build options
version="1.0"
export PACKER_LOG=0

# Script directory (so this script can be called from anywhere)
scriptDir="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

# List all your sandboxes here to build at once (in series)
sandboxesToBuild=(
  #hdp-sandbox-name
  #hdp-sandbox-name-2
  #hdp-sandbox-name-3

  hdf-bagel
)

# For each sandbox, build docker image followed by running its packer job
for sandboxName in "${sandboxesToBuild[@]}";
do
  docker build -t sandbox-$sandboxName-pre:$version $scriptDir/$sandboxName

  cd $scriptDir/$sandboxName
  packer build -var "version=$version" packer.json
done
