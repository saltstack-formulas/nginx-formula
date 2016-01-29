{% from slspath + "/map.jinja" import nginx as nginx_map with context %}

include:
  - {{ slspath }}.common
{% if salt['pillar.get']('nginx:use_upstart', nginx_map['use_upstart']) %}
  - {{ slspath }}.upstart
{% elif salt['pillar.get']('nginx:use_sysvinit', nginx_map['use_sysvinit']) %}
  - {{ slspath }}.sysvinit
{% endif %}
{% if pillar.get('nginx', {}).get('user_auth_enabled', true) %}
  - {{ slspath }}.users
{% endif %}
{% if pillar.get('nginx', {}).get('install_from_source', false) %}
  - {{ slspath }}.source
{% else %}
  - {{ slspath }}.package
{% endif -%}

