# nginx.ng.config
#
# Manages the main nginx server configuration file.

{% from 'nginx/ng/map.jinja' import nginx, sls_block with context %}

nginx_config:
  file.managed:
    {{ sls_block(nginx.server.opts) }}
    - name: {{ nginx.lookup.conf_file }}
    - source: salt://nginx/ng/files/nginx.conf
    - template: jinja
    - context:
        config: {{ nginx.server.config|json() }}
