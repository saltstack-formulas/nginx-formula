# nginx.config
#
# Manages the main nginx server configuration file.

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ '/map.jinja' import nginx, sls_block with context %}
{%- from tplroot ~ '/libtofs.jinja' import files_switch with context %}

{% if nginx.server.config.http.access_log %}
{{ tplroot }}_nginx_accesslog_dir:
  file.directory:
    - name: {{ salt['file.dirname'](nginx.server.config.http.access_log) }}
    - user: {{ nginx.server.config.user }}
    - group: {{ nginx.server.config.user }}
    - makedirs: True
{% endif %}

{% if nginx.server.config.http.error_log %}
{{ tplroot }}_nginx_errorlog_dir:
  file.directory:
    - name: {{ salt['file.dirname'](nginx.server.config.http.error_log) }}
    - user: {{ nginx.server.config.user }}
    - group: {{ nginx.server.config.user }}
    - makedirs: True
{% endif %}

{{ tplroot }}_nginx_config:
  file.managed:
    {{ sls_block(nginx.server.opts) }}
    - name: {{ nginx.lookup.conf_file }}
    - source:
{% if 'source_path' in nginx.server.config %}
      - {{ nginx.server.config.source_path }}
{% endif %}
      {{ files_switch(['nginx.conf'],
                      'nginx_config_file_managed'
          )
      }}
    - template: jinja
{% if 'source_path' not in nginx.server.config %}
    - context:
        config: {{ nginx.server.config|json(sort_keys=False) }}
{% endif %}
