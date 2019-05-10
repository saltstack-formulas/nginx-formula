# nginx.service
#
# Manages the nginx service.

{% from 'nginx/map.jinja' import nginx, sls_block with context %}
{% set service_function = {True:'running', False:'dead'}.get(nginx.service.enable) %}

include:
  {% if nginx.install_from_source %}
  - nginx.src
  {% else %}
  - nginx.pkg
  {% endif %}

{% if nginx.install_from_source %}
nginx_systemd_service_file:
  file.managed:
    - name: /lib/systemd/system/nginx.service
    - source: salt://nginx/files/nginx.service
{% endif %}

nginx_service:
  service.{{ service_function }}:
    {{ sls_block(nginx.service.opts) }}
    - name: {{ nginx.lookup.service }}
    - enable: {{ nginx.service.enable }}
    - require:
      {% if nginx.install_from_source %}
      - sls: nginx.src
      {% else %}
      - sls: nginx.pkg
      {% endif %}
    - listen:
      {% if nginx.install_from_source %}
      - cmd: nginx_install
      {% else %}
      - pkg: nginx_install
      {% endif %}
