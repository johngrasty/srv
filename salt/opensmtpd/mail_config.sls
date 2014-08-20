/usr/local/etc/mail/smtpd.conf:
  file.managed:
    - source: salt://opensmtpd/conf/smtpd.conf
    - user: root
    - group: wheel
    - mode: 644
    - template: jinja
    - require:
      - ports: mailserver

/usr/local/etc/mail/smtpd/secret:
  file.managed:
    - contents_pillar: oepnsmtpd:secret
    - user: root
    - group: wheel
    - mode: 600
    - require:
      - ports: mailserver
      - file: /usr/local/etc/mail/smtpd/certs

/usr/local/etc/mail/smtpd/virtual-domains:
  file.managed:
    - source: salt://opensmtpd/conf/virtual-domains
    - user: root
    - group: wheel
    - mode: 644
    - require:
      - ports: mailserver
      - file: /usr/local/etc/mail/smtpd/certs

/usr/local/etc/mail/smtpd/virtual-users:
  file.managed:
    - source: salt://opensmtpd/conf/virtual-users
    - user: root
    - group: wheel
    - mode: 644
    - require:
      - ports: mailserver
      - file: /usr/local/etc/mail/smtpd/certs

/usr/local/etc/mail/smtpd/virtual-recipient:
  file.managed:
    - source: salt://opensmtpd/conf/virtual-recipient
    - user: root
    - group: wheel
    - mode: 644
    - require:
      - ports: mailserver
      - file: /usr/local/etc/mail/smtpd/certs
  
/usr/local/etc/mail/smtpd/certs:
  file.directory:
    - require:
      - ports: mailserver
    - user: root
    - group: wheel
    - dir_mode: 700
    - file_mode: 600
    - recurse:
      - user
      - group
      - mode
    - makedirs: True
    - clean: False

/usr/local/etc/mail/smtpd/certs/ggi.key:
  file.managed:
    - user: root
    - group: wheel
    - mode: 600
    - contents_pillar: ggimissions:key
    - require:
      - file: /usr/local/etc/mail/smtpd/certs

/usr/local/etc/mail/smtpd/certs/ggi_bundle.crt:
  file.managed:
    - user: root
    - group: wheel
    - mode: 600
    - contents_pillar: ggimissions:crt
    - require:
      - file: /usr/local/etc/mail/smtpd/certs