base:
  'nginx*':
    - ssl
  'mysql*':
    - mysql
    - nfs
  'ghost*':
    - ghost
    - nfs