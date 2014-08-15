icecast:
  pkg:
    - installed

/opt/local/etc/icecast/icecast.xml:
  file.managed:
    - source: salt://icecast/files/icecast.xml
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/opt/local/share/icecast/manifest.xml:
  file.managed:
    - source: salt://icecast/files/icecast_manifest.xml
    - user: root
    - group: root
    - mode: 644


/opt/local/share/icecast/passwd:
  file.managed:
    - user: icecast
    - group: icecast
    - mode: 600
    - contents_pillar: icecast_passwd

/var/log/icecast:
  file.directory:
    - user: icecast
    - group: icecast
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True

salt://icecast/files/manifest.sh:
  cmd.script

icecast_app:
  service.running:
    - name: icecast
    - enable: True
    - require:
      - file: /opt/local/etc/icecast/icecast.xml
      - file: /var/log/icecast
      - file: /opt/local/share/icecast/passwd
      - file: /opt/local/share/icecast/manifest.xml


