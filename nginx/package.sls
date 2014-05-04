{% set use_upstart = pillar.get('nginx', {}).get('use_upstart', true) %}
{% if use_upstart %}
nginx-old-init:
  file:
    - rename
    - name: /usr/share/nginx/init.d
    - source: /etc/init.d/nginx
    - require_in:
      - file: nginx
  cmd:
    - wait
    - name: dpkg-divert --divert /usr/share/nginx/init.d --add /etc/init.d/nginx
    - require:
      - module: nginx-old-init
    - watch:
      - file: nginx-old-init
    - require_in:
      - file: nginx
  module:
    - wait
    - name: cmd.run
    - cmd: kill `cat /var/run/nginx.pid`
    - watch:
      - file: nginx-old-init
    - require_in:
      - file: nginx

nginx-old-init-disable:
  cmd:
    - wait
    - name: update-rc.d -f nginx remove
    - require:
      - module: nginx-old-init
    - watch:
      - file: nginx-old-init
{% endif %}

nginx:
  pkg.installed:
    - name: nginx
{% if use_upstart %}
  file:
    - managed
    - name: /etc/init/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/templates/upstart.jinja
    - require:
      - pkg: nginx
      - file: nginx-old-init
      - module: nginx-old-init
{% endif %}
  service:
    - running
    - enable: True
    - restart: True
    - watch:
{% if use_upstart %}
      - file: nginx
{% endif %}
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/conf.d/default.conf
      - file: /etc/nginx/conf.d/example_ssl.conf
      - pkg: nginx
