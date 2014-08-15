salt://ng_backend/files/zfs-move.sh:
  cmd.script

nginx:
  pkg:
    - installed

nginx_config:
  service:
    - name: nginx
    - enabled
    - restart: True
    - watch:
      - file: /opt/local/etc/nginx/nginx.conf
      - file: /opt/local/etc/nginx/sites-enabled/*
      - pkg: nginx


/opt/local/etc/nginx/nginx.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/templates/config.jinja

/opt/local/etc/nginx/sites-enabled:
  file.directory:
    - require:
        - pkg: nginx

/opt/local/etc/nginx/ssl:
  file.directory:
    - makedirs: True
    - user: root
    - group: root
    - dir_mode: 750
    - file_mode: 640
    - require:
        - pkg: nginx

# /opt/local/etc/nginx/ssl/dhparam.pem:
#   file.managed:
#     - user: root
#     - group: root
#     - mode: 600
#     - contents_pillar: ng_backend:dhparam

/opt/local/etc/nginx/sites-available:
  file.directory:
    - require:
        - pkg: nginx

php-fpm-packages:
  pkg.installed:
    - pkgs:
      - php55-bcmath
      - php55-bz2
      - php55-calendar
      - php55-curl
      - php55-dom
      - php55-fpm
      - php55-gd
      - php55-gettext
      - php55-gmp
      - php55-iconv
      - php55-imap
      - php55-json
      - php55-mbstring
      - php55-mcrypt
      - php55-memcache
      - php55-memcached
      - php55-mysql
      - php55-mysqli
      - php55-pdo
      - php55-pdo_mysql
      - php55-pdo_sqlite
      - php55-posix
      - php55-soap
      - php55-xmlrpc
      - php55-xsl
      - php55-zendoptimizerplus
      - php55-zip
      - php55-zlib
      - php55-opcache
      - php55-ldap
      - php55-exif

php55-fpm:
  pkg:
    - installed

php-fpm:
  service.running:
    - enable: True
    - require:
      - pkg: php55-fpm
      # - watch:
      #   - file: /opt/local/etc/nginx/nginx.conf


mysql-client:
  pkg:
    - installed
