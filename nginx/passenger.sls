# nginx.passenger
#
# Manages installation of passenger from repo.
# Requires install_from_phusionpassenger = True

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ '/map.jinja' import nginx, sls_block with context %}
{%- from tplroot ~ '/libtofs.jinja' import files_switch with context %}

{% if salt['grains.get']('os_family') in ['Debian', 'RedHat'] %}
include:
  - nginx.pkg
  - nginx.config
  - nginx.service
  {%- if nginx.snippets is defined %}
  - nginx.snippets
  {%- endif %}
  {%- if nginx.streams is defined %}
  - nginx.streams
  {%- endif %}
  - nginx.servers
  - nginx.certificates

passenger_install:
  pkg.installed:
    {{ sls_block(nginx.package.opts) }}
    - name: {{ nginx.lookup.passenger_package }}
    - require:
      - pkg: nginx_install
    - require_in:
      - service: nginx_service
      - file: nginx_config

/etc/nginx/passenger.conf:
  file.absent:
    - require:
      - pkg: passenger_install

passenger_config:
  file.managed:
    {{ sls_block(nginx.server.opts) }}
    - name: {{ nginx.lookup.passenger_config_file }}
    - source: {{ files_switch(['nginx.conf'],
                              'passenger_config_file_managed'
                 )
              }}
    - template: jinja
    - context:
        config: {{ nginx.passenger|json() }}
    - watch_in:
      - service: nginx_service
    - require_in:
      - service: nginx_service
      - file: nginx_config
    - require:
      - file: /etc/nginx/passenger.conf
      - pkg: passenger_install
{% endif %}
