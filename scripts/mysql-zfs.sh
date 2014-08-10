#!/usr/bin/bash
 

PATH=/opt/local/bin:/opt/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

#Exit on error rather than plowing on.
set -o errexit

#Save errors to file (I think)
set -o xtrace
 
if [ ! -e "/root/zfs_create" ]; then
  # Control will enter here if file doesn't exist.
  
  echo "Set Delegated Dataset mountpoint."
  zfs set mountpoint=/data zones/`hostname`/data

  echo "Create datasets."
  zfs create -o mountpoint=/data/innodb-data -o recordsize=16k zones/`zonename`/data/innodb-data
  zfs create -o mountpoint=/data/innodb-logs zones/`zonename`/data/innodb-logs
  zfs create -o mountpoint=/data/backups zones/`zonename`/data/backups

  echo "Configure"
  svccfg -s pkgsrc/quickbackup-percona setprop quickbackup/backupdir = /data/backups


  touch /root/zfs_create
fi