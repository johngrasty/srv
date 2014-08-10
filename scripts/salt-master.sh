#!/usr/bin/bash


if [ ! -d "/opt/salt/bin" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  cd /opt 
  curl -LO http://www.shalman.org/salt/testing/salt-2014.1.7-10-g579cc0a-esky-smartos.tar.gz  
  tar xzvf salt-2014.1.7-10-g579cc0a-esky-smartos.tar.gz  
  /opt/salt/install/install.sh
  svcadm enable salt-master
fi