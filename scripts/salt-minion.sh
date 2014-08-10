#!/usr/bin/bash
 
 
if [ ! -d "/opt/salt/bin" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  cd /opt 
  curl -LO http://www.shalman.org/salt/salt-2014.1.10-esky-smartos.tar.gz  
  tar xzvf salt-2014.1.10-esky-smartos.tar.gz
  /opt/salt/install/install.sh
  echo "master: "$(mdata-get salt-master) >> /opt/salt/etc/minion  
  echo "id: "$(mdata-get salt-id) >> /opt/salt/etc/minion 
  svcadm enable salt-minion

  pkgin up
  pkgin fug -y
fi