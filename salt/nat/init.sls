/etc/ipf/ipnat.conf:
  file:
    - managed
    - source: salt://nat/files/ipnat.conf
    - mode: 644      # function declaration

ipv4-forwarding:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/ipf/ipnat.conf

# route:
#   service:
#     - running
#     - enable: True

/etc/ipf/ipf.conf:
  file:
    - managed
    - source: salt://nat/files/ipf.conf
    - mode: 644      # function declaration

validate_ipf:
  cmd.run:
    - name: ipf -n -f /etc/ipf/ipf.conf && ipnat -n -f /etc/ipf/ipnat.conf
    - require:
      - file: /etc/ipf/ipf.conf
      - file: /etc/ipf/ipnat.conf

ipfilter:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/ipf/ipf.conf
    - require:
      - cmd: validate_ipf

/etc/ipf/ipf.sh:               # ID declaration
  file:
    - managed
    - mode: 744      # function declaration
    - source: salt://nat/files/ipf.sh
  cmd:
    - run     # function declaration
