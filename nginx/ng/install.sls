# nginx.ng.install
#
# Manages installation of nginx.

{% from 'nginx/ng/map.jinja' import nginx, sls_block with context %}

nginx_install:
  {% if nginx.install_from_source %}
  ## add source compilation here
  {% else %}
  pkg.installed:
    {{ sls_block(nginx.package.opts) }}
    - name: {{ nginx.lookup.package }}
  {% endif %}

{% if salt['grains.get']('os_family') == 'Debian' %}
nginx_ppa_repo:
  pkgrepo:
    {%- if nginx.install_from_ppa %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - humanname: nginx-ppa-{{ grains['oscodename'] }}
    {%- if nginx.ppa_version == 'mainline' %}
    - name: deb http://nginx.org/packages/mainline/ubuntu/ {{ grains['oscodename'] }} nginx
    - key_url: http://nginx.org/keys/nginx_signing.key
    {%- else %}
    - name: deb http://ppa.launchpad.net/nginx/{{ nginx.ppa_version }}/ubuntu {{ grains['oscodename'] }} main
    - keyid: C300EE8C
    - keyserver: keyserver.ubuntu.com
    {%- endif %}
    - file: /etc/apt/sources.list.d/nginx-{{ nginx.ppa_version }}-{{ grains['oscodename'] }}.list
    - dist: {{ grains['oscodename'] }}
    - require_in:
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
{% endif %}
