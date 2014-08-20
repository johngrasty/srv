#!/usr/local/bin/bash

PATH=/lib/smartdc:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

export PATH
 
 #Exit on error rather than plowing on.
set -o errexit

#Save errors to file (I think)
set -o xtrace
 
if [ ! -d "/root/salt_install" ]; then

  pkg2ng

  pkg update
  pkg install -y pkg 
  pkg upgrade -y

  portsnap fetch extract

  pkg install -y py27-salt

  cp /usr/local/etc/salt/minion.sample /usr/local/etc/salt/minion

  echo "master: "$(mdata-get salt-master) >> /usr/local/etc/salt/minion  
  echo "id: "$(mdata-get salt-id) >> /usr/local/etc/salt/minion 
  
  sysrc salt_minion_enable="YES"
  sysrc salt_minion_paths="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
  service salt_minion start

  touch /root/salt_install
fi