{% from "nginx/map.jinja" import nginx with context %}
{% set use_upstart = salt['pillar.get']('nginx:use_upstart', nginx['use_upstart']) %}
{% if use_upstart %}
nginx-old-init:
  file.rename:
    - name: /usr/share/nginx/init.d
    - source: /etc/init.d/nginx
    - require_in:
      - file: nginx
    - require:
      - pkg: nginx
    - force: True
{% if grains.get('os_family') == 'Debian' %}
# Don't dpkg-divert if we are not Debian based!
  cmd.wait:
    - name: dpkg-divert --divert /usr/share/nginx/init.d --add /etc/init.d/nginx
    - require:
      - module: nginx-old-init
    - watch:
      - file: nginx-old-init
    - require_in:
      - file: nginx
{% endif %}
  module.wait:
    - name: cmd.run
    - cmd: sh -c "kill `cat /var/run/nginx.pid`"
    - watch:
      - file: nginx-old-init
    - require_in:
      - file: nginx
    - onlyif: [ -e /var/run/nginx.pid ]

# RedHat requires the init file in place to chkconfig off
{% if nginx['disable_before_rename'] %}
  {% set _in = '_in' %}
{% else %}
  {% set _in = '' %}
{% endif %}

nginx-old-init-disable:
  cmd.run:
    - name: {{ nginx.old_init_disable }}
    - require{{ _in }}:
      - module: nginx-old-init
    - onlyif: [ -f /etc/init.d/nginx ]
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
    - name: deb http://ppa.launchpad.net/nginx/{{ pillar.get('nginx', {}).get('repo_version', 'stable') }}/ubuntu {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/nginx-{{ pillar.get('nginx', {}).get('repo_version', 'stable') }}-{{ grains['oscodename'] }}.list
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
  file.managed:
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
  service.running:
    - enable: True
    - restart: True
    - watch:
{% if use_upstart %}
      - file: nginx
{% endif %}
{% set conf_dir = salt['pillar.get']('nginx:conf_dir', '/etc/nginx') %}
      - file: {{ conf_dir }}/nginx.conf
      - file: {{ conf_dir }}/conf.d/default.conf
      - file: {{ conf_dir }}/conf.d/example_ssl.conf
      - pkg: nginx

# Create 'service' symlink for tab completion.
# This is not supported in os_family RedHat and likely only works in
# Debian-based distros
{% if use_upstart and grains['os_family'] == 'Debian' %}
/etc/init.d/nginx:
  file.symlink:
    - target: /lib/init/upstart-job
    - force: True
{% endif %}
