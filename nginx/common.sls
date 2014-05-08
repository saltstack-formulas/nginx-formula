/usr/share/nginx:
  file:
    - directory

{% for filename in ('default', 'example_ssl') %}
/etc/nginx/conf.d/{{ filename }}.conf:
  file.absent
{% endfor %}

{% if pillar.get('nginx', {}).get('use_upstart', true) %}
{% set logger_types = ('access', 'error') %}

{% for log_type in logger_types %}
/var/log/nginx/{{ log_type }}.log:
  file.absent

nginx-logger-{{ log_type }}:
  file:
    - managed
    - name: /etc/init/nginx-logger-{{ log_type }}.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/templates/upstart-logger.jinja
    - context:
      type: {{ log_type }}
  service:
    - running
    - enable: True
    - require:
      - file: nginx-logger-{{ log_type }}
    - require_in:
      - service: nginx
{% endfor %}

/etc/logrotate.d/nginx:
  file:
    - absent
{% endif %}

/etc/nginx:
  file.directory:
    - user: root
    - group: root

/etc/nginx/nginx.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/templates/config.jinja
    - require:
      - file: /etc/nginx

{% for dir in ('sites-enabled', 'sites-available') %}
/etc/nginx/{{ dir }}:
  file.directory:
    - user: root
    - group: root
{% endfor -%}
