nginx:
  pkg.installed:
    - pkgs:
      - nginx
      - php55-fpm
      - php55-extensions
      - php55-zendoptimizerplus
  service:
    - enabled
    - restart: True
    - watch:
      - file: /opt/local/etc/nginx/nginx.conf
      - pkg: nginx

/opt/local/etc/nginx/nginx.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx_mine/templates/config.jinja

/opt/local/etc/nginx/sites-enabled:
  file.directory:
    - require:
        - pkg: nginx

/opt/local/etc/nginx/ssl:
  file.directory:
    - require:
        - pkg: nginx

/opt/local/etc/nginx/sites-available:
  file.directory:
    - require:
        - pkg: nginx

/opt/local/etc/nginx/sites-available/vision.conf:
  file.managed:
    - source: salt://nginx_mine/templates/vision.conf
    - template: jinja
    - require:
      - pkg: nginx

/opt/local/etc/nginx/sites-enabled/vision.conf:
  file.symlink:
    - target: /opt/local/etc/nginx/sites-available/vision.conf
    - watch:
        - file: /opt/local/etc/nginx/sites-enabled
        - file: /opt/local/etc/nginx/sites-available/vision.conf

/opt/local/etc/nginx/ssl/vbm.key:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: vision:key

/opt/local/etc/nginx/ssl/vbm.crt:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: vision:crt