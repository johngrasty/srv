salt://dovecot/files/zfs-move.sh:
  cmd.script

add-group-mail:
  group.present:
    - name: mail
    - gid: 1001


root:
  user.present:
    - password: {{ salt['pillar.get']('user:root:password')}}
    - groups:
      - root
      - other
      - bin 
      - sys
      - adm
      - uucp
      - mail
      - tty
      - nuucp
      - daemon

mail:
  user.present:
    - fullname: 'mail'
    - home: /data/mail
    - password: {{ salt['pillar.get']('user:mail:password')}}
    - shell: /usr/bin/false
    - uid: 1001
    - gid: 1001
    - require:
      - group: add-group-mail

dovecot-install:
  pkg:
    - names:
      - dovecot
      - dovecot-pigeonhole
    - installed
  service.running:
    - name: dovecot
    - enable: True
    - require:
      - pkg: dovecot-install
      - file: recurse-dovecot-config
      - file: recurse-sieve-config
      - file: /etc/ssl/certs/ggi.key
      - file: /etc/ssl/certs/ggi_bundle.crt
    - watch:
      - file: recurse-dovecot-config

recurse-dovecot-config:
  file.recurse:
    - name: /opt/local/etc/dovecot
    - source: salt://dovecot/conf
    - clean: False
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - include_empty: True
    - keep_symlinks: True
    - template: jinja

recurse-sieve-config:
  file.recurse:
    - name: /data/mail/sieve
    - source: salt://dovecot/sieve
    - clean: False
    - user: mail
    - group: mail
    - dir_mode: 755
    - file_mode: 644
    - include_empty: False
    - keep_symlinks: True
    - template: jinja

/etc/ssl/certs/ggi.key:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: ggimissions:key

/etc/ssl/certs/ggi_bundle.crt:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: ggimissions:crt

/opt/local/etc/dovecot/domains/test.ggimissions.com/users:
  file.managed:
    - user: dovecot
    - group: dovecot
    - mode: 600
    - contents_pillar: domains:test.ggimissions.com
    - require:
      - file: recurse-dovecot-config

