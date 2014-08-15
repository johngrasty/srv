base:
  'global.*':
    - global
  'nat*':
    - nat
    - email-notifications
  'nginx*':
    - nginx
    - nginx.needfaith
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
