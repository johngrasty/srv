base:
  'global.*':
    - global
  'nat*':
    - nat
    - email-notifications
  'nginx*':
    - nginx
    - email-notifications
  'mysql*':
    - mysql
    - backups
    - email-notifications
  'ghost*':
    - ghost
    - backups
    - email-notifications
  'icecast*':
    - email-notifications
    - icecast
  'ng_backend*':
    - email-notifications
    - ng_backend
    - ng_backend.ggimissions
  'assp*':
    - assp
    - email-notifications
    - backups
  'opensmtpd*':
    - opensmtpd
  'dovecot*':
    - backups
    - email-notifications
    - dovecot
    
