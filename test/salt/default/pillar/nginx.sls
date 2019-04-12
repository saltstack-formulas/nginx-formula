
# Simple pillar setup
# - snippet letsencrypt
# - remove 'default' site
# - create 'mysite' site

nginx:
  ng:
    snippets:
      letsencrypt:
        - location ^~ /.well-known/acme-challenge/:
          - proxy_pass: http://localhost:9999
    servers:
      managed:
        default:
          deleted: True
          enabled: False
          config: {}

        mysite:
          enabled: True
          config:
            - server:
              - server_name: localhost
              - listen:
                - '80 default_server'
              - index: 'index.html index.htm'
              - location ~ .htm:
                - try_files: '$uri $uri/ =404'
              - include: 'snippets/letsencrypt.conf'

