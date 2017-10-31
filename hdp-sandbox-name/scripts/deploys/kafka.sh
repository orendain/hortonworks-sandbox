#!/usr/bin/env bash

# Reference: https://cwiki.apache.org/confluence/display/AMBARI/Adding+a+New+Service+to+an+Existing+Cluster

# Add a Service to the cluster
curl -u admin:admin -H 'X-Requested-By: ambari' -X POST -d '{"ServiceInfo":{"service_name":"KAFKA"}}' http://localhost:8080/api/v1/clusters/Sandbox/services

# Add Components to the service
curl -u admin:admin -H 'X-Requested-By: ambari' -X POST http://localhost:8080/api/v1/clusters/Sandbox/services/KAFKA/components/KAFKA_BROKER

# Create host components
curl -u admin:admin -H 'X-Requested-By: ambari' -X POST -d '{
  "host_components": [
    {"HostRoles": {"component_name": "KAFKA_BROKER"}}
  ]
}' http://localhost:8080/api/v1/clusters/Sandbox/hosts?Hosts/host_name=sandbox-hdp.hortonworks.com

# Install the service and wait until it is done
curl -u admin:admin -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo":{"context":"Install Kafka","operation_level":{"level":"CLUSTER","cluster_name":"Sandbox"}},"Body":{"ServiceInfo":{"state":"INSTALLED"}}}' http://localhost:8080/api/v1/clusters/Sandbox/services/KAFKA | python /sandbox/ambari/wait-until-done.py
