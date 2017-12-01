#!/usr/bin/env bash

# Wait for Ambari to come up
/sandbox/ambari/wait-for-ambari.sh
sleep 20 # Optional, but why not?  Just in case on my slow laptop

# For components
for service in ZOOKEEPER_SERVER KAFKA_BROKER REGISTRY_SERVER NIFI_MASTER STREAMLINE_SERVER;
do
  curl -u admin:admin -H "X-Requested-By: ambari" -X PUT -d '{"RequestInfo":{"context":"Start '$service'","operation_level":{"level":"HOST_COMPONENT","cluster_name":"Sandbox","host_name":"sandbox-hdf.hortonworks.com"}},"Body":{"HostRoles":{"state":"STARTED"}}}' http://localhost:8080/api/v1/clusters/Sandbox/hosts/sandbox-hdf.hortonworks.com/host_components/$service | python /sandbox/ambari/wait-until-done.py
done

# For services
for service in STORM HDFS YARN HBASE;
do
  curl -u admin:admin -H "X-Requested-By: ambari" -X PUT -d '{"RequestInfo": {"context" :"Start '$service'"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://localhost:8080/api/v1/clusters/Sandbox/services/$service | python /sandbox/ambari/wait-until-done.py
done
