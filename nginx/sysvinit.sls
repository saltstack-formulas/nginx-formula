{% set logger_types = ('access', 'error') %}

{% for log_type in logger_types %}
/var/log/nginx/{{ log_type }}.log:
  file.absent

nginx-logger-{{ log_type }}:
  file:
    - managed
    - name: /etc/init.d/nginx-logger-{{ log_type }}
    - template: jinja
    - user: root
    - group: root
    - mode: 755
    - source: salt://nginx/templates/sysvinit-logger.jinja
    - context:
      type: {{ log_type }}
  service:
    - running
    - enable: True
    - require:
      - file: nginx-logger-{{ log_type }}
    - require_in:
      - service: nginx
  cmd:
    - wait
    - name: /usr/sbin/update-rc.d nginx-logger-{{ log_type }} defaults
{% endfor %}

/etc/logrotate.d/nginx:
  file.absent
