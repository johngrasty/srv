/opt/local/etc/nginx/ssl/needfaith.key:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: needfaith:key
    - require:
      - file: /opt/local/etc/nginx/ssl

/opt/local/etc/nginx/ssl/needfaith.crt:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: needfaith:crt
    - require:
      - file: /opt/local/etc/nginx/ssl

/opt/local/etc/nginx/sites-available/needfaith.org:
  file.managed:
    - source: salt://nginx/files/needfaith.org
    - require:
      - pkg: nginx
      - file: /opt/local/etc/nginx/sites-enabled
      - file: /opt/local/etc/nginx/sites-available
    - watch_in:
      - service: nginx_config

/opt/local/etc/nginx/sites-enabled/needfaith.org:
  file.symlink:
    - target: /opt/local/etc/nginx/sites-available/needfaith.org
    - require:
      - pkg: nginx
      - file: /opt/local/etc/nginx/sites-enabled
      - file: /opt/local/etc/nginx/sites-available

