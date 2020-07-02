# nginx
#
# Meta-state to fully install nginx.

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ '/map.jinja' import nginx with context %}

include:
  {%- if nginx.ng is defined %}
  - .deprecated
  {%- endif %}
  - .config
  - .service
  {%- if nginx.snippets is defined %}
  - .snippets
  {%- endif %}
  - .servers
  - .certificates

extend:
  {{ tplroot }}_nginx_service:
    service:
      - listen:
        - file: {{ tplroot }}_nginx_config
      - require:
        - file: {{ tplroot }}_nginx_config
  {{ tplroot }}_nginx_config:
    file:
      - require:
        {%- if nginx.install_from_source %}
        - cmd: nginx_install
        {%- else %}
        - pkg: {{ tplroot }}_nginx_install
        {%- endif %}
