include:
  - nginx.ng.service

{%- for domain in salt['pillar.get']('nginx:ng:certificates', {}).keys() %}

nginx_{{ domain }}_ssl_certificate:
  file.managed:
    - name: /etc/nginx/ssl/{{ domain }}.crt
    - makedirs: True
    - contents_pillar: nginx:ng:certificates:{{ domain }}:public_cert
    - watch_in:
      - service: nginx_service

nginx_{{ domain }}_ssl_key:
  file.managed:
    - name: /etc/nginx/ssl/{{ domain }}.key
    - mode: 600
    - makedirs: True
    - contents_pillar: nginx:ng:certificates:{{ domain }}:private_key
    - watch_in:
      - service: nginx_service

{%- endfor %}
