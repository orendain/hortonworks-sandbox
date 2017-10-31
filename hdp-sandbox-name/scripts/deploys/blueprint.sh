#!/usr/bin/env bash

## Note: This file takes care of parsing your "blueprint.json" file into configuration blocks, overridden with your "custom-configs.json" entries, annd made consumable for Ambari. Generally, there is no need to make changes to this file.

timestamp=$(date +%s)

# Install jq for json parsing
yum install -y jq
yum clean -y all
rm -rf /var/cache/yum

# Parse blueprint into configurations
cat /tmp/sandbox/build/configurations/blueprint.json | jq '.configurations | to_entries | map({type: .value | to_entries[].key, tag: '"$timestamp"', properties: .value | to_entries[].value.properties})' > /tmp/sandbox/build/configurations/blueprint-configurations-temp.json

# Override configurations with custom configurations
jq --argfile A /tmp/sandbox/build/configurations/blueprint-configurations-temp.json '
    (reduce $A[] as $a({};.[$a.type]=$a)) as $t  # build lookup table
    | map( ($t[.type]//{tag:"NEW"})*. )            # apply A to B
    | (($t|keys_unsorted)-map(.type)) as $o        # find keys in A not in B
    | [$t[$o[]]] + .                               # add back those keys' /tmp/sandbox/build/configurations/custom-configs.json > /tmp/sandbox/build/configurations/blueprint-configurations.json

# Perform necessary configuration transformations
sed -i 's/%HOSTGROUP::host_group_1%/sandbox-hdp.hortonworks.com/' /tmp/sandbox/build/configurations/blueprint-configurations.json

# Submit configurations
curl -u admin:admin -H 'X-Requested-By: ambari' -X POST -d "@/tmp/sandbox/build/configurations/blueprint-configurations.json" http://localhost:8080/api/v1/clusters/Sandbox/configurations

# Apply configurations to the cluster
for configType in $(cat /tmp/sandbox/build/configurations/blueprint-configurations.json | jq '. | to_entries[] | .value.type');
do
  curl -u admin:admin -H 'X-Requested-By: ambari' -X PUT -d '[
    {"Clusters": {"desired_configs": {"tag": '"$timestamp"', "type": '"$configType"'}}}
  ]' http://localhost:8080/api/v1/clusters/Sandbox
done
