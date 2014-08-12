#! /bin/sh

# change this to the name of your ZFS pool. Or set ZPOOL envvar at runtime
zpool=${ZPOOL:-"zones"}

# names of the DATASETs to exclude (datasets, not mountpoints!)
# can override this list at runtime with EXCLUDES envvar.
# can extend this list at runtime with EXTRA_EXCLUDES envvar.
excludes=${EXCLUDES:-"/usr/ports /usr/src"}

dataset=${DATASET:-$zpool}


# You do not want to edit anything below here

tstamp=`date +%Y%m%d-%H%M%S`
label_pfx="zbk-"

# expecting optional arguments: $1 -> usrlabel, $2 -> numsnaps
usrlabel=${1:-"default"}
maxnum=${2:-"10"}

usage () {
    echo Usage:
    echo "zfssnap [label [maxnum]]"
    echo "* label: tag name of snapshot (alphanumeric, default 'default')"
    echo "* maxnum: prune old snapshots when more than this snaps exist"
    echo
    echo "Optional envvars:"
    echo "ZPOOL     name of ZFS pool to manage (default 'zroot')"
    echo "EXCLUDES  list of dataset paths to exclude from snaps. Overrides default."
    echo "EXTRA_EXCLUDES  list of dataset paths to exclude from snaps. Extends default."
    echo "default excluded DATASET paths:"
    echo $excludes
}

failmsg () {
    echo $*
    echo
    usage
    exit 1
}

verify_zpool () {
    zpool status $zpool >/dev/null 2>&1 || failmsg "ZFS pool '$zpool' not found. Fix your \$ZPOOL envvar."
}

verify_zpool

# build list of dataset paths to exclude
if [ "x$EXTRA_EXCLUDES" != x ]
then
    excludes="$excludes $EXTRA_EXCLUDES"
fi

# label
echo "$usrlabel" | grep -qiE '^([a-z0-9]{1,10})$' || failmsg "Invalid label '$usrlabel'! Quitting."
label_pfx="$label_pfx$usrlabel"

# maxnum
echo "$maxnum" | grep -qE '^[0-9]+$' || failmsg "Invalid maxnum '$maxnum'! Terminating."


# add timestamp to label
label="${label_pfx}-$tstamp"

# take recursive snap
echo "Snapshot"
zfs snapshot -r $dataset@$label || exit $?



# prune dbs if requested
if [ "x$maxnum" != x ]
then
    ls /data/.zfs/snapshot/ | sort -rt- -k 3,4 | awk -v maxnum=$maxnum -v matchlabel=$label_pfx 'BEGIN {x=0} $0 ~ "^"matchlabel { x++; if (x>maxnum) print}' | while read snapname
    do
        zfs destroy -r $dataset@$snapname || exit $?
    done
fi

