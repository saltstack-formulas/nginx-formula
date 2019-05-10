# nginx.src
#
# Manages installation of nginx from source.

{% from 'nginx/map.jinja' import nginx, sls_block with context %}

nginx_deps:
  pkg.installed:
    - pkgs:
      - libpcre3-dev
      - libssl-dev
      - zlib1g-dev

nginx_download:
  archive.extracted:
    - name: /tmp/
    - source: http://nginx.org/download/nginx-{{ nginx.source_version }}.tar.gz
    - source_hash: sha256={{ nginx.source_hash }}
    - archive_format: tar
    - if_missing: /usr/sbin/nginx-{{ nginx.source_version }}
    - require:
      - pkg: nginx_deps

nginx_configure:
  cmd.run:
    - name: ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path={{ nginx.lookup.conf_file }} {{ nginx.source.opts | join(' ') }}
    - cwd: /tmp/nginx-{{ nginx.source_version }}
    - onchanges:
      - archive: nginx_download

nginx_compile:
  cmd.run:
    - name: make
    - cwd: /tmp/nginx-{{ nginx.source_version }}
    - onchanges:
      - cmd: nginx_configure

nginx_install:
  cmd.run:
    - name: make install
    - cwd: /tmp/nginx-{{ nginx.source_version }}
    - onchanges:
      - cmd: nginx_compile

nginx_link:
  file.copy:
    - name: /usr/sbin/nginx-{{ nginx.source_version }}
    - source: /usr/sbin/nginx
    - onchanges:
      - cmd: nginx_install
