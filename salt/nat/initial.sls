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


