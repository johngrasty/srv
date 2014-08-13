salt://ghost/files/move.sh:
  cmd.script

ghost:
  user.present:
    - password: {{ salt['pillar.get']('user:ghost:password') }}
    - groups:
      - ghost


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

/etc/security/auth_attr:
  file.blockreplace:
    - name: /etc/security/auth_attr
    - marker_start: "# START managed zone of Ghost auths -DO-NOT-EDIT-"
    - marker_end: "# END managed zone of Ghost auths --"
    - content:  |
        solaris.ghost.operator:::Ghost Operator::
        solaris.ghost.administrator:::Ghost administrator::
    - append_if_not_found: True
    - backup: '.bak'
    - show_changes: True

/usr/sbin/usermod -A solaris.ghost.operator ghost:
  cmd.run

/data/ghost/ghost/config.js:
  file.managed:
    - source: salt://ghost/files/config.js
    - user: ghost
    - group: ghost
    - mode: 644


/data/ghost/ghost/manifest.xml:
  file.managed:
    - source: salt://ghost/files/manifest.xml
    - user: root
    - group: root
    - mode: 644


ghost_service:
  service:
    - name: ghost
    - running
    - enable: True
    - watch:
      - file: /data/ghost/ghost/config.js

fmd:
  service:
    - running
    - enable: True

sendmail-client:
  service:
    - running
    - enable: True

smtp-notify:
  service:
    - running
    - enable: True
    - require: 
      - service: sendmail-client