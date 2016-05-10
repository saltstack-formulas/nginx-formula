# nginx.ng.src
#
# Manages installation of nginx from source.

{% from 'nginx/ng/map.jinja' import nginx, sls_block with context %}

nginx_build_dep:
  {% if salt['grains.get']('os_family') == 'Debian' %}
  cmd.run:
    - name: apt-get -y build-dep nginx
  {% elif salt['grains.get']('os_family') == 'RedHat' %}
  cmd.run:
    - name: yum-builddep -y nginx
  {% else %}
  ## install build deps for other distros
  {% endif %}

nginx_download:
  archive.extracted:
    - name: /tmp/
    - source: http://nginx.org/download/nginx-{{ nginx.source_version }}.tar.gz
    - source_hash: sha256={{ nginx.source_hash }}
    - archive_format: tar
    - if_missing: /usr/sbin/nginx-{{ nginx.source_version }}
    - require:
      - cmd: nginx_build_dep
    - onchanges:
      - cmd: nginx_build_dep

nginx_configure:
  cmd.run:
    - name: ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf {{ nginx.source.opts | join(' ') }}
    - cwd: /tmp/nginx-{{ nginx.source_version }}
    - require:
      - archive: nginx_download
    - onchanges:
      - archive: nginx_download

nginx_compile:
  cmd.run:
    - name: make
    - cwd: /tmp/nginx-{{ nginx.source_version }}
    - require:
      - cmd: nginx_configure

nginx_install:
  cmd.run:
    - name: make install
    - cwd: /tmp/nginx-{{ nginx.source_version }}
    - require:
      - cmd: nginx_compile
    - onchanges:
      - cmd: nginx_compile

nginx_link:
  file.copy:
    - name: /usr/sbin/nginx-{{ nginx.source_version }}
    - source: /usr/sbin/nginx
    - require:
      - cmd: nginx_install
    - onchanges:
      - cmd: nginx_install