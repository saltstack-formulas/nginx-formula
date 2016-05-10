# nginx.ng.service
#
# Manages the nginx service.

{% from 'nginx/ng/map.jinja' import nginx, sls_block with context %}
{% set service_function = {True:'running', False:'dead'}.get(nginx.service.enable) %}

include:
  {% if nginx.install_from_source %}
  - nginx.ng.src
  {% else %}
  - nginx.ng.pkg
  {% endif %}

{% if nginx.install_from_source %}
nginx_systemd_service_file:
  file.managed:
    - name: /lib/systemd/system/nginx.service
    - source: salt://nginx/ng/files/nginx.service
{% endif %} 
  
nginx_service:
  service.{{ service_function }}:
    {{ sls_block(nginx.service.opts) }}
    - name: {{ nginx.lookup.service }}
    - enable: {{ nginx.service.enable }}
    - require:
      {% if nginx.install_from_source %}
      - sls: nginx.ng.src
      {% else %}
      - sls: nginx.ng.pkg
      {% endif %}
    - watch:
      {% if nginx.install_from_source %}
      - cmd: nginx_install
      {% else %}
      - pkg: nginx_install
      {% endif %}
