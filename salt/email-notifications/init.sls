/opt/local/etc/postfix/aliases:
  file.append:
    - text:
      - "root:           root"

/opt/local/bin/newaliases:
  cmd.run

"/usr/sbin/svccfg setnotify -g to-maintenance mailto:johnpgrasty@gmail.com":
  cmd.run


postfix:
  service:
    - running
    - enable: True

fmd:
  service:
    - running
    - enable: True

sendmail-client:
  service:
    - dead
    - enable: False

smtp-notify:
  service:
    - running
    - enable: True
    - require: 
      - service: postfix