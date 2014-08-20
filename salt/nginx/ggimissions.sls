/opt/local/etc/nginx/ssl/ggimissions.key:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: ggimissions:key
    - require:
      - file: /opt/local/etc/nginx/ssl

/opt/local/etc/nginx/ssl/ggimissions.crt:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: ggimissions:crt
    - require:
      - file: /opt/local/etc/nginx/ssl

/opt/local/etc/nginx/sites-available/ggimissions.com:
  file.managed:
    - source: salt://nginx/files/ggimissions.com
    - require:
      - pkg: nginx
      - file: /opt/local/etc/nginx/sites-enabled
      - file: /opt/local/etc/nginx/sites-available
    - watch_in:
      - service: nginx_config

/opt/local/etc/nginx/sites-enabled/ggimissions.com:
  file.symlink:
    - target: /opt/local/etc/nginx/sites-available/ggimissions.com
    - require:
      - pkg: nginx
      - file: /opt/local/etc/nginx/sites-enabled
      - file: /opt/local/etc/nginx/sites-available

