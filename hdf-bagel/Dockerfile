FROM orendain/sandbox-hdf-streaming:dev-0

LABEL maintainer="eorendain@hortonworks.com"

# New Ambari service startup
COPY assets/service-startup.sh /sandbox/ambari/service-startup.sh

# Temporarily stop services from running automatically
# It will be enabled again after new services are installed
RUN systemctl disable sandbox-ambari-services && \
    chmod 755 /sandbox/ambari/service-startup.sh
