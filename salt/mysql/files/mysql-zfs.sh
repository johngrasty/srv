#!/usr/bin/bash
 

PATH=/opt/local/bin:/opt/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export PATH


 
if [ ! -e "/data/backups/zfs_move" ]; then
  # Control will enter here if file doesn't exist.
  #Exit on error rather than plowing on.
  set -o errexit

  #Save errors to file (I think)
  set -o xtrace

  echo "Set Delegated Dataset mountpoint."
  zfs set mountpoint=/data zones/`zonename`/data

  echo "Create datasets."
  zfs create -o mountpoint=/data/innodb-data -o recordsize=16k zones/`zonename`/data/innodb-data
  zfs create -o mountpoint=/data/innodb-logs zones/`zonename`/data/innodb-logs
  zfs create -o mountpoint=/data/backups zones/`zonename`/data/backups
  zfs create -o mountpoint=/data/mysql-data zones/`zonename`/data/mysql-data
  zfs create -o mountpoint=/data/mysql-logs zones/`zonename`/data/mysql-logs


  touch /data/backups/zfs_move
fi