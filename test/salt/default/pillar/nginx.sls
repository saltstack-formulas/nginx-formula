# -*- coding: utf-8 -*-
# vim: ft=yaml
---
# Simple pillar setup
# - snippet letsencrypt
# - remove 'default' site
# - create 'mysite' site

nginx:
  snippets:
    letsencrypt.conf:
      - location ^~ /.well-known/acme-challenge/:
          - proxy_pass: http://localhost:9999
  server:
    config:
      http:
        ### module ngx_http_log_module example
        log_format: |-
          main '$remote_addr - $remote_user [$time_local] $status '
                              '"$request" $body_bytes_sent "$http_referer" '
                              '"$http_user_agent" "$http_x_forwarded_for"'
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
              - server_name: localhost
              - listen:
                  - '80 default_server'
              - index: 'index.html index.htm'
              - location ~ .htm:
                  - try_files: '$uri $uri/ =404'
              - include: 'snippets/letsencrypt.conf'
