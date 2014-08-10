{% from "mysql/map.jinja" import mysql with context %}
{% set os = salt['grains.get']('os', None) %}
{% set os_family = salt['grains.get']('os_family', None) %}

{% set user_states = [] %}

{% if os in ['Solaris'] %}
include:
  - mysql.python
{% endif %}


{% for user in salt['pillar.get']('mysql:user', []) %}
{% set state_id = 'mysql_user_' ~ loop.index0 %}
{{ state_id }}:
  mysql_user.present:
    - name: {{ user['name'] }}
    - host: '{{ user['host'] }}'
  {%- if user['password_hash'] is defined %}
    - password_hash: '{{ user['password_hash'] }}'
  {% else %}
    - password: '{{ user['password'] }}'
  {% endif %}
    - connection_host: localhost
    - connection_user: root
    - connection_pass: '{{ salt['pillar.get']('mysql:server:root_password', 'somepass') }}'
    - connection_charset: utf8

{% for db in user['databases'] %}
{{ state_id ~ '_' ~ loop.index0 }}:
  mysql_grants.present:
    - name: {{ user['name'] ~ '_' ~ db['database'] }}
    - grant: {{db['grants']|join(",")}}
    - database: {{ db['database'] }}.*
    - user: {{ user['name'] }}
    - host: '{{ user['host'] }}'
    - connection_host: localhost
    - connection_user: root
    - connection_pass: '{{ salt['pillar.get']('mysql:server:root_password', 'somepass') }}'
    - connection_charset: utf8
    - require:
      - mysql_user: {{ user['name'] }}
{% endfor %}

{% do user_states.append(state_id) %}
{% endfor %}


