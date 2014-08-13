include:
  - backups.nfs

#Install the scripts

/opt/local/bin/zfssnap.sh:
  file.managed:
    - source: salt://backups/files/zfssnap.sh
    - user: root
    - group: root
    - mode: 744

/opt/local/bin/zfsbk.sh:
  file.managed:
    - source: salt://backups/files/zfsbk.sh
    - user: root
    - group: root
    - mode: 744

#Local snapshots

DATASET="zones/`zonename`/data" /opt/local/bin/zfssnap.sh qrt 4:
  cron.present:
    - identifier: 15 minute snapshot
    - user: root
    - minute: '0,15,30,45'

DATASET="zones/`zonename`/data" /opt/local/bin/zfssnap.sh 6hr 4:
  cron.present:
    - identifier: 6 hour snapshot
    - user: root
    - minute: random
    - hour: '0,6,12,18'

DATASET="zones/`zonename`/data" /opt/local/bin/zfssnap.sh day 7:
  cron.present:
    - identifier: Daily Snapshot
    - user: root
    - minute: random
    - hour: 1

DATASET="zones/`zonename`/data" /opt/local/bin/zfssnap.sh week 6:
  cron.present:
    - identifier: Weekly snapshot
    - user: root
    - minute: random
    - hour: 1
    - dayweek: 1

#NFS Backups

DATASET="zones/`zonename`/data" /opt/local/bin/zfsbk.sh nfs6hr 4:
  cron.present:
    - identifier: 6 hour backup to NFS
    - user: root
    - minute: random
    - hour: '0,6,12,18'

DATASET="zones/`zonename`/data" /opt/local/bin/zfsbk.sh nfsday 7:
  cron.present:
    - identifier: Daily backup to NFS
    - user: root
    - minute: random
    - hour: 1

DATASET="zones/`zonename`/data" /opt/local/bin/zfsbk.sh nfsweek 6:
  cron.present:
    - identifier: Weekly backup to NFS
    - user: root
    - minute: random
    - hour: 1
    - dayweek: 1

