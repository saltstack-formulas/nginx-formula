# nginx.ng
#
# Meta-state to fully install nginx.

{% from 'nginx/ng/map.jinja' import nginx, sls_block with context %}

include:
  - nginx.ng.config
  - nginx.ng.service
  - nginx.ng.vhosts
  - nginx.ng.certificates

extend:
  nginx_service:
    service:
      - watch:
        - file: nginx_config
      - require:
        - file: nginx_config
  nginx_config:
    file:
      - require:
        {% if nginx.install_from_source %}
        - cmd: nginx_install
        {% else %}
        - pkg: nginx_install
        {% endif %}
