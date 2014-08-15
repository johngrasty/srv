#!/usr/bin/bash
 

PATH=/opt/local/bin:/opt/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export PATH


 
if [ ! -e "/data/ghost/ghost_move" ]; then
  # Control will enter here if file doesn't exist.
  #Exit on error rather than plowing on.
  set -o errexit

  #Save errors to file (I think)
  set -o xtrace

  echo "Moving the mount point for the delegated dataset."
  zfs set mountpoint=/data zones/`zonename`/data


  echo "Move the ghost user's home directory."
  usermod -d /data/ghost -m ghost

  echo "Update SMF for the new location."
  svccfg -s application/ghost setprop manifestfiles/home_ghost_ghost_manifest_xml = astring: /data/ghost/ghost/manifest.xml
  svccfg -s application/ghost setprop method_context/working_directory = astring: /data/ghost/ghost
  svcadm refresh application/ghost

  svccfg setnotify -g to-maintenance mailto:johnpgrasty@gmail.com

  touch /data/ghost/ghost_move
fi