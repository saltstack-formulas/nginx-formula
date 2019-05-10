# nginx.passenger
#
# Manages installation of passenger from repo.
# Requires install_from_phusionpassenger = True

{% from 'nginx/map.jinja' import nginx, sls_block with context %}

{% if salt['grains.get']('os_family') in ['Debian', 'RedHat'] %}
include:
  - nginx.pkg
  - nginx.service

passenger_install:
  pkg.installed:
    - name: {{ nginx.lookup.passenger_package }}
    - require:
      - pkg: nginx_install
    - require_in:
      - service: nginx_service

/etc/nginx/passenger.conf:
  file.absent:
    - require:
      - pkg: passenger_install

passenger_config:
  file.managed:
    {{ sls_block(nginx.server.opts) }}
    - name: {{ nginx.lookup.passenger_config_file }}
    - source: salt://nginx/files/nginx.conf
    - template: jinja
    - context:
        config: {{ nginx.passenger|json() }}
    - watch_in:
      - service: nginx_service
    - require_in:
      - service: nginx_service
    - require:
      - file: /etc/nginx/passenger.conf
      - pkg: passenger_install
{% endif %}
