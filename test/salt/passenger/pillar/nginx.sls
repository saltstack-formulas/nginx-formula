# -*- coding: utf-8 -*-
# vim: ft=yaml
---
# Simple pillar setup
# - snippet letsencrypt
# - remove 'default' site
# - create 'mysite' site

{%- if grains.os_family in ('RedHat',) %}
  {%- set passenger_pkg = 'nginx-mod-http-passenger' %}
  {%- set passenger_mod = '/usr/lib64/nginx/modules/ngx_http_passenger_module.so' %}
{%- else %}
  {%- set passenger_pkg = 'libnginx-mod-http-passenger' %}
  {%- set passenger_mod = '/usr/lib/nginx/modules/ngx_http_passenger_module.so' %}
{%- endif %}

nginx:
  check_config_before_apply: true

  install_from_phusionpassenger: true
  lookup:
    passenger_package: {{ passenger_pkg }}

  snippets:
    letsencrypt.conf:
      - location ^~ /.well-known/acme-challenge/:
          - proxy_pass: http://localhost:9999
  server:

    config:
      # This is required to get the passenger module loaded
      # In Debian it can be done with this
      # include: 'modules-enabled/*.conf'
      load_module: {{ passenger_mod }}

      worker_processes: 4
      http:
        ### module ngx_http_log_module example
        log_format: |-
          main '$remote_addr - $remote_user [$time_local] $status '
                              '"$request" $body_bytes_sent "$http_referer" '
                              '"$http_user_agent" "$http_x_forwarded_for"'
        include:
          - /etc/nginx/mime.types
          - /etc/nginx/conf.d/*.conf
          - /etc/nginx/sites-enabled/*

  servers:
    managed:
      default:
        deleted: true
        enabled: false
        config: {}

      mysite:
        enabled: true
        config:
          - server:
              - passenger_enabled: 'on'

              - server_name: localhost
              - listen:
                  - '80 default_server'
              - index: 'index.html index.htm'
              - location ~ .htm:
                  - try_files: '$uri $uri/ =404'
              # - include: '/etc/nginx/snippets/letsencrypt.conf'
              - include: 'snippets/letsencrypt.conf'
