#!/bin/bash

echo "Setting up MySQL Zone"

#Need to edit for our needs. This is the Joyent Percona script. Need to add a test to see if it has been done.
if [ ! -e "/root/mysql_setup" ]; then
## Do Stuff



PATH=/opt/local/bin:/opt/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

#Exit on error rather than plowing on.
set -o errexit

#Save errors to file (I think)
set -o xtrace

SAVEFILE=/root/mysql_joyent_tuning

# Get password from metadata, 
MYSQL_PW=${MYSQL_PW:-$(mdata-get mysql_pw 2>/dev/null)}

# Generate svccfg happy password for quickbackup-percona
# (one without special characters)
QB_PW=$(od -An -N8 -x /dev/random | head -1 | sed 's/^[ \t]*//' | tr -d ' ');
QB_US=qb-$(zonename | awk -F\- '{ print $5 }');

# Default query to lock down access and clean up
MYSQL_INIT="DELETE from mysql.user;
DELETE FROM mysql.proxies_priv WHERE Host='base.joyent.us';
GRANT ALL on *.* to 'root'@'localhost' identified by '${MYSQL_PW}' with grant option;
GRANT LOCK TABLES,SELECT,RELOAD,SUPER,REPLICATION CLIENT on *.* to '${QB_US}'@'localhost' identified by '${QB_PW}';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;"

# MySQL my.cnf tuning
MEMCAP=$(kstat -c zone_memory_cap -s physcap -p | cut -f2 | awk '{ printf "%d", $1/1024/1024 }');

# innodb_buffer_pool_size
INNODB_BUFFER_POOL_SIZE=$(echo -e "scale=0; ${MEMCAP}/2"|bc)M

# back_log
BACK_LOG=64
[[ ${MEMCAP} -gt 8000 ]] && BACK_LOG=128

# max_connections
[[ ${MEMCAP} -lt 1000 ]] && MAX_CONNECTIONS=200
[[ ${MEMCAP} -gt 1000 ]] && MAX_CONNECTIONS=500
[[ ${MEMCAP} -gt 2000 ]] && MAX_CONNECTIONS=1000
[[ ${MEMCAP} -gt 3000 ]] && MAX_CONNECTIONS=2000
[[ ${MEMCAP} -gt 5000 ]] && MAX_CONNECTIONS=5000

# table_cache
TABLE_CACHE=$((${MEMCAP}/4))
[[ ${TABLE_CACHE} -lt 256 ]] && TABLE_CACHE=256
[[ ${TABLE_CACHE} -gt 512 ]] && TABLE_CACHE=512

# thread_cache_size
THREAD_CACHE_SIZE=$((${MAX_CONNECTIONS}/2))
[[ ${THREAD_CACHE_SIZE} -gt 1000 ]] && THREAD_CACHE_SIZE=1000

echo "MEMCAP = " $MEMCAP >> $SAVEFILE
echo "INNODB_BUFFER_POOL_SIZE = " $INNODB_BUFFER_POOL_SIZE >> $SAVEFILE
echo "BACK_LOG = " $BACK_LOG >> $SAVEFILE
echo "MAX_CONNECTIONS = " $MAX_CONNECTIONS >> $SAVEFILE
echo "TABLE_CACHE = " $TABLE_CACHE >> $SAVEFILE
echo "THREAD_CACHE_SIZE = " $THREAD_CACHE_SIZE >> $SAVEFILE


# gsed -i \
# 	-e "s/back_log = 64/back_log = ${BACK_LOG}/" \
# 	-e "s/table_open_cache = 512/table_open_cache = ${TABLE_CACHE}/" \
# 	-e "s/thread_cache_size = 1000/thread_cache_size = ${THREAD_CACHE_SIZE}/" \
# 	-e "s/max_connections = 1000/max_connections = ${MAX_CONNECTIONS}/" \
# 	-e "s/innodb_buffer_pool_size = 16M/innodb_buffer_pool_size = ${INNODB_BUFFER_POOL_SIZE}/" \
# 	/opt/local/etc/my.cnf

svccfg -s quickbackup-percona setprop quickbackup/username = astring: ${QB_US}
svccfg -s quickbackup-percona setprop quickbackup/password = astring: ${QB_PW}
svccfg -s quickbackup-percona setprop quickbackup/backupdir = /data/backups
svccfg -s quickbackup-percona setprop quickbackup/expiredays = 15
svccfg -s quickbackup-percona setprop quickbackup/day = all
svccfg -s quickbackup-percona setprop quickbackup/hour = 1,4,7,10,13,16,19,22
svccfg -s quickbackup-percona setprop quickbackup/minute = 15
svcadm refresh quickbackup-percona
svcadm enable quickbackup-percona

svccfg setnotify -g to-maintenance mailto:johnpgrasty@gmail.com

svcadm enable fmd
svcadm enable sendmail-client
svcadm enable smtp-notify


chown -R mysql:mysql /data/


if [[ "$(svcs -Ho state mysql)" == "online" ]]; then
	svcadm disable -t mysql
	sleep 2
fi

svcadm enable mysql

COUNT="0";
while [[ ! -e /tmp/mysql.sock ]]; do
        sleep 1
        ((COUNT=COUNT+1))
        if [[ $COUNT -eq 60 ]]; then
    ERROR=yes
    break 1
  fi
done
[[ -n "${ERROR}" ]] && exit 31

sleep 1

# [[ "$(svcs -Ho state mysql)" == "online" ]] || \
#   ( log "ERROR MySQL SMF not reporting as 'online'" && exit 31 )

mysql -u root -e "${MYSQL_INIT}" >/dev/null 

touch /root/mysql_setup

fi
