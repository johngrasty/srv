ipf:               # ID declaration
  cmd.run:                # state declaration
    - name: /opt/salt/srv/salt/global/files/ipf.sh       # function declaration

sshd:
  /usbkey/ssh/sshd_config:
    file.managed:
      - source: salt://global/files/sshd_config
      - user: root
      - group: root
      - mode: 644

ssh:
  service:
    - running
    - watch:
      - file: /usbkey/ssh/sshd_config