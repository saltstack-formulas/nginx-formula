{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ '/map.jinja' import nginx with context %}

include:
  - nginx.service

prepare_certificates_path_dir:
  file.directory:
    - name: {{ nginx.certificates_path }}
    - makedirs: True

{%- for dh_param, value in nginx.dh_param.items() %}
{%- if value is string %}
create_nginx_dhparam_{{ dh_param }}_key:
  file.managed:
    - name: {{ nginx.certificates_path }}/{{ dh_param }}
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
    - cwd: {{ nginx.certificates_path }}
    - creates: {{ nginx.certificates_path }}/{{ dh_param }}
    - require:
      - file: prepare_certificates_path_dir
    - watch_in:
      - service: nginx_service
{%- endif %}
{%- endfor %}

{%- for domain in nginx.certificates.keys() %}

nginx_{{ domain }}_ssl_certificate:
  file.managed:
    - name: {{ nginx.certificates_path }}/{{ domain }}.crt
    - makedirs: True
{% if domain in nginx.certificates and 'public_cert_pillar' in nginx.certificates[domain] %}
    - contents_pillar: {{ nginx.certificates[domain].public_cert_pillar }}
{% else %}
    - contents_pillar: nginx:certificates:{{ domain }}:public_cert
{% endif %}
    - watch_in:
      - service: nginx_service

{% if 'private_key' in nginx.certificates[domain] or 'private_key_pillar' in nginx.certificates[domain] %}
nginx_{{ domain }}_ssl_key:
  file.managed:
    - name: {{ nginx.certificates_path }}/{{ domain }}.key
    - mode: 600
    - makedirs: True
{% if 'private_key_pillar' in nginx.certificates[domain] %}
    - contents_pillar: {{ nginx.certificates[domain].private_key_pillar }}
{% else %}
    - contents_pillar: nginx:certificates:{{ domain }}:private_key
{% endif %}
    - watch_in:
      - service: nginx_service
{% endif %}
{%- endfor %}
