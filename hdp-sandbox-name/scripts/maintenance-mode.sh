#!/usr/bin/env bash

# For services
for service in MAPREDUCE2 YARN HDFS; do
	curl -u admin:admin -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo":{"context":"Turn On Maintenance Mode for '$service'"},"Body":{"ServiceInfo":{"maintenance_state":"ON"}}}' http://localhost:8080/api/v1/clusters/Sandbox/services/$service | python /sandbox/ambari/wait-until-done.py
done

# For individual components
#for component in DRPC_SERVER; do
#  curl -u admin:admin -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo":{"context":"Turn On Maintenance Mode for '$component'"},"Body":{"HostRoles":{"maintenance_state":"ON"}}}' http://localhost:8080/api/v1/clusters/Sandbox/hosts/sandbox-hdf.hortonworks.com/host_components/$component
#done
