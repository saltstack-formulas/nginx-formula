# nginx.ng.config
#
# Manages the main nginx server configuration file.

{% from 'nginx/ng/map.jinja' import nginx, sls_block with context %}

{% if nginx.install_from_source %}
nginx_log_dir:
  file.directory:
    - name: /var/log/nginx
    - user: {{ nginx.server.config.user }}
    - group: {{ nginx.server.config.user }}
{% endif %}

{% if 'source' in nginx.server.config %}
{% set source_path = nginx.server.config.source %}
{% else %} 
{% set source_path = 'salt://nginx/ng/files/nginx.conf' %} 
{% endif %}
nginx_config:
  file.managed:
    {{ sls_block(nginx.server.opts) }}
    - name: {{ nginx.lookup.conf_file }}
    - source: {{ source_path }}
    - template: jinja
{% if 'source' not in nginx.server.config %} 
    - context:
        config: {{ nginx.server.config|json() }}
{% endif %}
