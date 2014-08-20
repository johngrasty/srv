#!/usr/bin/bash
 

PATH=/opt/local/bin:/opt/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export PATH


 
if [ ! -e "/data/zfs_move" ]; then
  # Control will enter here if file doesn't exist.
  #Exit on error rather than plowing on.
  set -o errexit

  #Save errors to file (I think)
  set -o xtrace

  echo "Moving the mount point for the delegated dataset."
  zfs set mountpoint=/data zones/`zonename`/data

  svccfg setnotify -g to-maintenance mailto:johnpgrasty@gmail.com

  touch /data/zfs_move
fi