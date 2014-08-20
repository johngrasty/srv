nginx:
  pkg.installed

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
    - require:
      - pkg: nginx

/opt/local/etc/nginx/ssl/dhparam.pem:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: ssl_server:dhparam

/opt/local/etc/nginx/sites-available:
  file.directory:
    - require:
      - pkg: nginx

include:
  - nginx.ggimissions
  - nginx.needfaith

nginx_config:
  service:
    - name: nginx
    - enabled
    - restart: True
    - watch:
      - file: /opt/local/etc/nginx/nginx.conf
      - pkg: nginx
