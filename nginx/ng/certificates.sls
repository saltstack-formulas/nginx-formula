{% from 'nginx/ng/map.jinja' import nginx with context %}

include:
  - nginx.ng.service

{% set certificates_path = salt['pillar.get']('nginx:ng:certificates_path', '/etc/nginx/ssl') %}

{%- for dh_param, value in salt.pillar.get('nginx:ng:dh_param').items() %}
{%- if value is string %}
create_nginx_dhparam_{{ dh_param }}_key:
  file.managed:
    - name: {{ certificates_path }}/{{ dh_param }}
    - contents_pillar: nginx:ng:dh_param:{{ dh_param }}
    - makedirs: True
{%- else %}
generate_nginx_dhparam_{{ dh_param }}_key:
  pkg.installed:
    - name: {{ nginx.lookup.openssl_package }}
  file.directory:
    - name: {{ certificates_path }}
    - makedirs: True
  cmd.run:
    - name: openssl dhparam -out {{ dh_param }} {{ value.get('keysize', 2048) }}
    - cwd: {{ certificates_path }}
    - creates: {{ certificates_path }}/{{ dh_param }}
{%- endif %}
{%- endfor %}

{%- for domain in salt['pillar.get']('nginx:ng:certificates', {}).keys() %}

nginx_{{ domain }}_ssl_certificate:
  file.managed:
    - name: {{ certificates_path }}/{{ domain }}.crt
    - makedirs: True
    - contents_pillar: nginx:ng:certificates:{{ domain }}:public_cert
    - watch_in:
      - service: nginx_service

{% if salt['pillar.get']("nginx:ng:certificates:{}:private_key".format(domain)) %}
nginx_{{ domain }}_ssl_key:
  file.managed:
    - name: {{ certificates_path }}/{{ domain }}.key
    - mode: 600
    - makedirs: True
    - contents_pillar: nginx:ng:certificates:{{ domain }}:private_key
    - watch_in:
      - service: nginx_service
{% endif %}
{%- endfor %}
