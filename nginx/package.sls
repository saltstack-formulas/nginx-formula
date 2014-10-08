{% from "nginx/map.jinja" import nginx with context %}
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

{% if grains.get('os_family') == 'Debian' %}

{% set repo_source = pillar.get('nginx', {}).get('repo_source', 'default') %}
{% set use_ppa = repo_source == 'ppa' and grains.get('os') == 'Ubuntu' %}
{% set use_official = repo_source == 'official' and grains.get('os') in ('Ubuntu', 'Debian') %}

nginx-ppa-repo:
  pkgrepo:
    {%- if use_ppa %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - humanname: nginx-ppa-{{ grains['oscodename'] }}
    - name: deb http://ppa.launchpad.net/nginx/stable/ubuntu {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/nginx-stable-{{ grains['oscodename'] }}.list
    - dist: {{ grains['oscodename'] }}
    - keyid: C300EE8C
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: nginx
    - watch_in:
      - pkg: nginx

nginx-official-repo:
  pkgrepo:
    {%- if use_official %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - humanname: nginx apt repo
    - name: deb http://nginx.org/packages/{{ grains['os'].lower() }}/ {{ grains['oscodename'] }} nginx
    - file: /etc/apt/sources.list.d/nginx-official-{{ grains['oscodename'] }}.list
    - keyid: ABF5BD827BD9BF62
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: nginx
    - watch_in:
      - pkg: nginx

{% endif %}

nginx:
  pkg.installed:
    - name: {{ nginx.package }}
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

# Create 'service' symlink for tab completion.
{% if use_upstart %}
/etc/init.d/nginx:
  file.symlink:
    - target: /lib/init/upstart-job
{% endif %}
