include:
  - backups.nfs

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