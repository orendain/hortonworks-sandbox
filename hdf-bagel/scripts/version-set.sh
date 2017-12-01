#!/usr/bin/env bash

cat << EOF2 > /usr/local/bin/sandbox-version
#!/usr/bin/env bash
cat << EOF
== Sandbox Information ==
Platform: You're running HDF BAGEL!
Build date: `date +%m`-`date +%d`-`date +%Y`
Ambari version: `ambari-server --version`
Hadoop version: `hadoop version | head -n 1`
OS: `cat /etc/*release | tail -n1`
====
EOF
EOF2

chmod 755 /usr/local/bin/sandbox-version
