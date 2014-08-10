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

/data/ghost/ghost/config.js:
  file.managed:
    - source: salt://ghost/files/config.js
    - user: ghost
    - group: ghost
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