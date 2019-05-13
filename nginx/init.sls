# nginx
#
# Meta-state to fully install nginx.

{%- from 'nginx/map.jinja' import nginx, sls_block with context %}

include:
  {%- if nginx.ng is defined %}
  - nginx.deprecated
  {%- endif %}
  - nginx.config
  - nginx.service
  {%- if nginx.snippets is defined %}
  - nginx.snippets
  {%- endif %}
  - nginx.servers
  - nginx.certificates

extend:
  nginx_service:
    service:
      - listen:
        - file: nginx_config
      - require:
        - file: nginx_config
  nginx_config:
    file:
      - require:
        {%- if nginx.install_from_source %}
        - cmd: nginx_install
        {%- else %}
        - pkg: nginx_install
        {%- endif %}
