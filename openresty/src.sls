# nginx.src
#
# Manages installation of nginx from source.

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ '/map.jinja' import nginx, sls_block with context %}

{{ tplroot }}_nginx_deps:
  pkg.installed:
    - pkgs:
      - libpcre3-dev
      - libssl-dev
      - zlib1g-dev

{{ tplroot }}_nginx_download:
  archive.extracted:
    - name: /tmp/
    - source: http://nginx.org/download/nginx-{{ nginx.source_version }}.tar.gz
    - source_hash: sha256={{ nginx.source_hash }}
    - archive_format: tar
    - if_missing: /usr/sbin/nginx-{{ nginx.source_version }}
    - require:
      - pkg: {{ tplroot }_nginx_deps

{{ tplroot }}_nginx_configure:
  cmd.run:
    - name: ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path={{ nginx.lookup.conf_file }} {{ nginx.source.opts | join(' ') }}
    - cwd: /tmp/nginx-{{ nginx.source_version }}
    - onchanges:
      - archive: {{ tplroot }}_nginx_download

{{ tplroot }}_nginx_compile:
  cmd.run:
    - name: make
    - cwd: /tmp/nginx-{{ nginx.source_version }}
    - onchanges:
      - cmd: {{ tplroot }}_nginx_configure

{{ tplroot }}_nginx_install:
  cmd.run:
    - name: make install
    - cwd: /tmp/nginx-{{ nginx.source_version }}
    - onchanges:
      - cmd: {{ tplroot }}_nginx_compile

{{ tplroot }}_nginx_link:
  file.copy:
    - name: /usr/sbin/nginx-{{ nginx.source_version }}
    - source: /usr/sbin/nginx
    - onchanges:
      - cmd: {{ tplroot }}_nginx_install
