{% set nginx = pillar.get('nginx', {}) -%}
{% set home = nginx.get('home', '/var/www') -%}
{% set conf_dir = nginx.get('conf_dir', '/etc/nginx') -%}
{% set conf_template = nginx.get('conf_template', 'salt://nginx/templates/config.jinja') -%}

{{ home }}:
  file:
    - directory
    - user: www-data
    - group: www-data
    - mode: 0755
    - makedirs: True

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
