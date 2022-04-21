{% from 'nginx/map.jinja' import nginx with context %}

include:
  - nginx.service

{% set certificates_path = salt['pillar.get']('nginx:certificates_path', '/etc/nginx/ssl') %}
prepare_certificates_path_dir:
  file.directory:
    - name: {{ certificates_path }}
    - makedirs: True

{%- for dh_param, value in salt['pillar.get']('nginx:dh_param', {}).items() %}
{%- if value is string %}
create_nginx_dhparam_{{ dh_param }}_key:
  file.managed:
    - name: {{ certificates_path }}/{{ dh_param }}
    - contents_pillar: nginx:dh_param:{{ dh_param }}
    - makedirs: True
    - require:
      - file: prepare_certificates_path_dir
    - watch_in:
      - service: nginx_service
{%- else %}
generate_nginx_dhparam_{{ dh_param }}_key:
  pkg.installed:
    - name: {{ nginx.lookup.openssl_package }}
  cmd.run:
    - name: openssl dhparam -out {{ dh_param }} {{ value.get('keysize', 2048) }}
    - cwd: {{ certificates_path }}
    - creates: {{ certificates_path }}/{{ dh_param }}
    - require:
      - file: prepare_certificates_path_dir
      - pkg: generate_nginx_dhparam_{{ dh_param }}_key
    - watch_in:
      - service: nginx_service
{%- endif %}
{%- endfor %}

{%- for domain in salt['pillar.get']('nginx:certificates', {}).keys() %}

nginx_{{ domain }}_ssl_certificate:
  file.managed:
    - name: {{ certificates_path }}/{{ domain }}.crt
    - makedirs: True
{% if salt['pillar.get']("nginx:certificates:{}:public_cert_pillar".format(domain)) %}
    - contents_pillar: {{ salt['pillar.get']('nginx:certificates:{}:public_cert_pillar'.format(domain)) }}
{% else %}
    - contents_pillar: nginx:certificates:{{ domain }}:public_cert
{% endif %}
    - watch_in:
      - service: nginx_service

{% if salt['pillar.get']("nginx:certificates:{}:private_key".format(domain)) or salt['pillar.get']("nginx:certificates:{}:private_key_pillar".format(domain)) %}
nginx_{{ domain }}_ssl_key:
  file.managed:
    - name: {{ certificates_path }}/{{ domain }}.key
    - mode: 600
    - makedirs: True
{% if salt['pillar.get']("nginx:certificates:{}:private_key_pillar".format(domain)) %}
    - contents_pillar: {{ salt['pillar.get']('nginx:certificates:{}:private_key_pillar'.format(domain)) }}
{% else %}
    - contents_pillar: nginx:certificates:{{ domain }}:private_key
{% endif %}
    - watch_in:
      - service: nginx_service
{% endif %}
{%- endfor %}
