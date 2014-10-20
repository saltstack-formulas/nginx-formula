include:
  - nginx.common
# Only upstart OR sysvinit should default to true.
{% if pillar.get('nginx', {}).get('use_upstart', true) %}
  - nginx.upstart
{% elif pillar.get('nginx', {}).get('use_sysvinit', false) %}
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

