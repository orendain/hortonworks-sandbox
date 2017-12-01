#!/usr/bin/env bash

# Reference: https://cwiki.apache.org/confluence/display/AMBARI/Adding+a+New+Service+to+an+Existing+Cluster

# Add a Service to the cluster
curl -u admin:admin -H 'X-Requested-By: ambari' -X POST -d '{"ServiceInfo":{"service_name":"HBASE"}}' http://localhost:8080/api/v1/clusters/Sandbox/services

# Add Components to the service
for component in HBASE_MASTER HBASE_REGIONSERVER PHOENIX_QUERY_SERVER;
do
  curl -u admin:admin -H 'X-Requested-By: ambari' -X POST http://localhost:8080/api/v1/clusters/Sandbox/services/HBASE/components/$component
done

# Create host components
curl -u admin:admin -H 'X-Requested-By: ambari' -X POST -d '{
  "host_components": [
    {"HostRoles": {"component_name": "HBASE_MASTER"}},
    {"HostRoles": {"component_name": "HBASE_REGIONSERVER"}},
    {"HostRoles": {"component_name": "PHOENIX_QUERY_SERVER"}}
  ]
}' http://localhost:8080/api/v1/clusters/Sandbox/hosts?Hosts/host_name=sandbox-hdf.hortonworks.com

# Install the service
curl -u admin:admin -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo":{"context":"Install HBase","operation_level":{"level":"CLUSTER","cluster_name":"Sandbox"}},"Body":{"ServiceInfo":{"state":"INSTALLED"}}}' http://localhost:8080/api/v1/clusters/Sandbox/services/HBASE | python /sandbox/ambari/wait-until-done.py
