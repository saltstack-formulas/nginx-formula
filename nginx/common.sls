{% from "nginx/map.jinja" import nginx as nginx_map with context %}
{% set nginx = pillar.get('nginx', {}) -%}
{% set home = nginx.get('home', '/var/www') -%}
{% set conf_dir = nginx.get('conf_dir', '/etc/nginx') -%}
{% set conf_template = nginx.get('conf_template', 'salt://nginx/templates/config.jinja') -%}

{{ home }}:
  file:
    - directory
    - user: {{ nginx_map.default_user }}
    - group: {{ nginx_map.default_group }}
    - mode: 0755
    - makedirs: True
    - require:
      {%- if pillar.get('nginx', {}).get('install_from_source', false) %}
      - user: {{ nginx_map.default_user }}
      - group: {{ nginx_map.default_group }}
      {%- else %}
      - pkg: nginx
      {% endif %}

/usr/share/nginx:
  file:
    - directory

{% for filename in ('default', 'example_ssl') %}
{{ conf_dir }}/conf.d/{{ filename }}.conf:
  file.absent
{% endfor %}

{{ conf_dir }}:
  file.directory:
    - user: root
    - group: root
    - makedirs: True

{{ conf_dir }}/nginx.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: {{ conf_template }}
    - require:
      - file: {{ conf_dir }}
    - context:
      default_user: {{ nginx_map.default_user }}
      default_group: {{ nginx_map.default_group }}

{% if nginx.get('init_conf_dirs', True) %}
{% for dir in ('sites-enabled', 'sites-available') %}
{{ conf_dir }}/{{ dir }}:
  file.directory:
    - user: root
    - group: root
{% endfor -%}
{% endif %}
