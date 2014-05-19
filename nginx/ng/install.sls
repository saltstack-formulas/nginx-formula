# nginx.ng.install
#
# Manages installation of nginx.

{% from 'nginx/ng/map.jinja' import nginx, sls_block with context %}

nginx_install:
  {% if nginx.from_source %}
  ## add source compilation here
  {% else %}
  pkg.installed:
    {{ sls_block(nginx.package.opts) }}
    - name: {{ nginx.lookup.package }}
  {% endif %}
