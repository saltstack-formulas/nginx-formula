{% set nginx = pillar.get('nginx', {}) -%}
{% set log_dir = nginx.get('log_dir', '/var/log/nginx') -%}

{% set logger_types = ('access', 'error') %}

{% for log_type in logger_types %}
{{ log_dir }}/{{ log_type }}.log:
  file.absent

nginx-logger-{{ log_type }}:
  file:
    - managed
    - name: /etc/init.d/nginx-logger-{{ log_type }}
    - template: jinja
    - user: root
    - group: root
    - mode: 755
    - source:
      - salt://nginx/templates/{{ grains['os_family'] }}-sysvinit-logger.jinja
      - salt://nginx/templates/sysvinit-logger.jinja
    - context:
      type: {{ log_type }}
  service:
    - running
    - enable: True
    - restart: True
    - require:
      - file: nginx-logger-{{ log_type }}
    - require_in:
      - service: nginx
{% endfor %}

/etc/logrotate.d/nginx:
  file.absent
