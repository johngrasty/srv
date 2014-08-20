root:
  user.present:
    - password: {{ salt['pillar.get']('user:root:password')}}
    - groups:
      - wheel
      - operator

mail:
  user.present:
    - fullname: 'mail Jones'
    - home: /usr/home/mail
    - password: {{ salt['pillar.get']('user:mail:password')}}


common:
  pkg.installed:
    - names:
      - dialog4ports
      - openssl
      - libevent2
      - perl5
      - mysql55-client
      - cmake
      - cmake-modules
      - ca_root_nss

mailserver:
  ports.installed:
    - name: mail/opensmtpd-devel
    - options:
      - LDAP: on
      - MYSQL: on
    - require:
      - pkg: dialog4ports
      - pkg: openssl
      - pkg: libevent2
      - pkg: perl5
      - pkg: cmake
      - pkg: cmake-modules

pkg lock -y opensmtpd-devel:
  cmd.run:
    - require:
      - ports: mailserver

smtpd:
  service.running:
    - enable: True
    - watch:
      - file: /usr/local/etc/mail/smtpd.conf
      - file: /usr/local/etc/mail/smtpd/*
    - require:
      - ports: mailserver
      - file: /usr/local/etc/mail/smtpd.conf


include:
  - opensmtpd.mail_config