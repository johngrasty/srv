/root/mysql-zfs.sh:
  cmd.run:
    - cwd: /
  file:
    - managed
    - source: salt://mysql/files/mysql-zfs.sh
    - mode: 744

mysql_pkgs:
  pkg.installed:
    - pkgs:
      - mysql-server
      - percona56-xtrabackup
      - quickbackup-percona 
      - p5-DBD-mysql56 
      - p5-File-Temp 
      - dtracetools
    - refresh: True

/opt/local/etc/my.cnf:
  file.managed:
    - source: salt://mysql/files/my.cnf

mysql:
  service:
    - name: mysql
    - enabled
    - restart: True
    - watch:
      - file: /opt/local/etc/my.cnf

/root/init.sh:
  cmd.run:
    - cwd: /
  file:
    - managed
    - source: salt://mysql/files/init.sh
    - mode: 744