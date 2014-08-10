{%- set nginx=pillar.get('nginx', {}) %}

include:
  - nginx.common
{% if nginx.get('user_auth_enabled', true) %}
  - nginx.users
{% endif %}
{% if nginx.get('install_from_source') %}
  - nginx.source
{% else %}
  - nginx.package
{% endif -%}

