# nginx.servers
#
# Manages virtual hosts and their relationship to the nginx service.

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ '/map.jinja' import nginx, sls_block with context %}
{%- from tplroot ~ '/servers_config.sls' import server_states with context %}

{% macro file_requisites(states) %}
{%- for state in states %}
        - file: {{ state }}
{%- endfor -%}
{% endmacro %}

include:
  - nginx.service
  - nginx.servers_config

{% if server_states|length() > 0 %}
extend:
  nginx_service:
    service:
      - reload: True
      - require:
        - file: nginx_config
        {{ file_requisites(server_states) }}
      - listen:
        - file: nginx_config
        {{ file_requisites(server_states) }}
{% endif %}
