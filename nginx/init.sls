{% from "nginx/map.jinja" import nginx as nginx_map with context %}

include:
  - nginx.common
{% if salt['pillar.get']('nginx:use_upstart', nginx_map['use_upstart']) %}
  - nginx.upstart
{% elif salt['pillar.get']('nginx:use_sysvinit', nginx_map['use_sysvinit']) %}
  - nginx.sysvinit
{% endif %}
{% if pillar.get('nginx', {}).get('user_auth_enabled', true) %}
  - nginx.users
{% endif %}
{% if pillar.get('nginx', {}).get('install_from_source', false) %}
  - nginx.source
{% else %}
  - nginx.package
{% endif -%}

