#!/usr/bin/env bash

# Reference: https://cwiki.apache.org/confluence/display/AMBARI/Adding+a+New+Service+to+an+Existing+Cluster

# Add a Service to the cluster
curl -u admin:admin -H 'X-Requested-By: ambari' -X POST -d '{"ServiceInfo":{"service_name":"NIFI"}}' http://localhost:8080/api/v1/clusters/Sandbox/services

# Add Components to the service
for component in NIFI_MASTER NIFI_CA;
do
  curl -u admin:admin -H 'X-Requested-By: ambari' -X POST http://localhost:8080/api/v1/clusters/Sandbox/services/NIFI/components/$component
done

# Create host components
curl -u admin:admin -H 'X-Requested-By: ambari' -X POST -d '{
  "host_components": [
    {"HostRoles": {"component_name": "NIFI_MASTER"}},
    {"HostRoles": {"component_name": "NIFI_CA"}}
  ]
}' http://localhost:8080/api/v1/clusters/Sandbox/hosts?Hosts/host_name=sandbox-hdp.hortonworks.com

# Install the service and wait until it is done
curl -u admin:admin -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo":{"context":"Install NiFi","operation_level":{"level":"CLUSTER","cluster_name":"Sandbox"}},"Body":{"ServiceInfo":{"state":"INSTALLED"}}}' http://localhost:8080/api/v1/clusters/Sandbox/services/NIFI | python /sandbox/ambari/wait-until-done.py
