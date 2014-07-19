/opt/salt/srv/salt/global/files/ipf.sh:               # ID declaration
  file:
    - managed
    - source: salt://global/files/ipf.sh
    - mode: 744      # function declaration
  cmd:                # state declaration
    - run

/opt/custom/smf/salt-call.xml
  file:
    - managed
    - source: salt://global/files/salt-call.xml

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
