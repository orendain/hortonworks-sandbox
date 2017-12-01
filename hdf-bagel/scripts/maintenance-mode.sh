#!/usr/bin/env bash

# Turn on maintenance mode
for service in HDFS MAPREDUCE2 YARN HBASE; do
	curl -u admin:admin -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo":{"context":"Turn On Maintenance Mode for '$service'"},"Body":{"ServiceInfo":{"maintenance_state":"ON"}}}' http://localhost:8080/api/v1/clusters/Sandbox/services/$service
done
