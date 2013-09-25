include:
  - nginx.common
  - nginx.users
{% if pillar.get('nginx', {}).get('install_from_source') %}
  - nginx.source
{% else %}
  - nginx.package
{% endif -%}

