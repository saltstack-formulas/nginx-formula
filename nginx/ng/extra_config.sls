include:
  - nginx.ng.service

{%- for config_file in salt['pillar.get']('nginx:ng:extra_config', {}).keys() %}
{%- set config_path = salt['pillar.get']('nginx:ng:extra_config:' ~ config_file  ~ ':path') %}
{%- set content = salt['pillar.get']('nginx:ng:extra_config:' ~ config_file  ~ ':content') %}
nginx_{{ config_file }}_extra_config:
  file.managed:
    - name: {{ config_path }}/{{ config_file }}.conf
    - makedirs: True
    - contents: |
        {{ content | indent(8) }}
    - watch_in:
      - service: nginx_service
{%- endfor %}

