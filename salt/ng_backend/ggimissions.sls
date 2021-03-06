/opt/local/etc/nginx/ssl/ggimissions.key:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: ggimissions:key

/opt/local/etc/nginx/ssl/ggimissions.crt:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: ggimissions:crt

/opt/local/etc/nginx/sites-available/ggimissions.com:
  file.managed:
    - source: salt://ng_backend/configs/ggimissions.com
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx_config

/opt/local/etc/nginx/sites-enabled/ggimissions.com:
  file.symlink:
    - target: /opt/local/etc/nginx/sites-available/ggimissions.com

/data/www/ggimissions.com/wp-config.php:
  file.managed:
    - source: salt://ng_backend/configs/ggimissions_wp-config.php
    - template: jinja
    - user: www
    - group: www
    - mode: 600

 