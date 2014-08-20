salt://assp/files/zfs-move.sh:
  cmd.script

unzip:
  pkg.installed

gcc47:
  pkg.installed

gmake:
  pkg.installed

/data/assp/files/localdomains:
  file.managed:
    - source: salt://files/localdomains
    - user: root
    - group: wheel
    - mode: 644

#### perl5 and a bunch of lwp packages. p5-YAML p5-perl-headers compat_headers p5-Error
#p5-Mail-SRS p5-Mail-SPF-Query p5-Mail-SPF p5-LEOCHARRE-CLI2 p5-Mail-ClamAV p5-Devel-Size p5-Regexp-Assemble

# ln -s /opt/local/lib/perl5/vendor_perl/5.20.0/i386-solaris-thread-multi/Mail/ClamAV.pm /data/assp/lib/File/Scan/ClamAV.pm

# install file::scan::ClamAV and regexp::optimizer in cpan.

########################

# icecast:
#   pkg:
#     - installed

# /opt/local/etc/icecast/icecast.xml:
#   file.managed:
#     - source: salt://icecast/files/icecast.xml
#     - template: jinja
#     - user: root
#     - group: root
#     - mode: 644

# /opt/local/share/icecast/manifest.xml:
#   file.managed:
#     - source: salt://icecast/files/icecast_manifest.xml
#     - user: root
#     - group: root
#     - mode: 644


# /opt/local/share/icecast/passwd:
#   file.managed:
#     - user: icecast
#     - group: icecast
#     - mode: 600
#     - contents_pillar: icecast_passwd

# /var/log/icecast:
#   file.directory:
#     - user: icecast
#     - group: icecast
#     - dir_mode: 755
#     - file_mode: 644
#     - makedirs: True

# salt://icecast/files/manifest.sh:
#   cmd.script

# icecast_app:
#   service.running:
#     - name: icecast
#     - enable: True
#     - require:
#       - file: /opt/local/etc/icecast/icecast.xml
#       - file: /var/log/icecast
#       - file: /opt/local/share/icecast/passwd
#       - file: /opt/local/share/icecast/manifest.xml


