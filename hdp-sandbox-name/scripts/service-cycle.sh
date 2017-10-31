#!/usr/bin/env bash

# Start all services
curl -u admin:admin -H "X-Requested-By: ambari" -X PUT -d '{"RequestInfo":{"context":"_PARSE_.START.ALL_SERVICES","operation_level":{"level":"CLUSTER","cluster_name":"Sandbox"}},"Body":{"ServiceInfo":{"state":"STARTED"}}}' http://localhost:8080/api/v1/clusters/Sandbox/services | python /sandbox/ambari/wait-until-done.py

# Stop all services
curl -u admin:admin -H "X-Requested-By: ambari" -X PUT -d '{"RequestInfo":{"context":"_PARSE_.STOP.ALL_SERVICES","operation_level":{"level":"CLUSTER","cluster_name":"Sandbox"}},"Body":{"ServiceInfo":{"state":"INSTALLED"}}}' http://localhost:8080/api/v1/clusters/Sandbox/services | python /sandbox/ambari/wait-until-done.py

# Wait a few more seconds for Ambari to save progress and catch up
sleep 10
