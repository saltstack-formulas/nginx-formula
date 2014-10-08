include:
  - nginx.common
{% if pillar.get('nginx', {}).get('use_upstart', true) %}
  - nginx.upstart
{% endif %}
{% if pillar.get('nginx', {}).get('user_auth_enabled', true) %}
  - nginx.users
{% endif %}
{% if pillar.get('nginx', {}).get('install_from_source') %}
  - nginx.source
{% else %}
  - nginx.package
{% endif -%}

