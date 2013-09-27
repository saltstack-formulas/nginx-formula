include:
  - nginx.common

{% set nginx = pillar.get('nginx', {}) -%}
{% set version = nginx.get('version', '1.5.2') -%}
{% set checksum = nginx.get('checksum', 'sha1=3546be28a72251f8823ab6be6a1180d300d06f76') -%}
{% set home = nginx.get('home', '/var/www') -%}
{% set source = nginx.get('source_root', '/usr/local/src') -%}

{% set nginx_package = source + '/nginx-' + version + '.tar.gz' -%}
{% set nginx_home     = home + "/nginx-" + version -%}
{% set nginx_modules_dir = source + "/nginx-modules" -%}

{% if nginx['with_luajit'] -%}
include:
  - nginx.luajit2
{% endif -%}

{% if nginx['with_openresty'] -%}
include:
  - nginx.openresty
{% endif -%}

nginx_group:
  group.present:
    - name: www-data

nginx_user:
  file.directory:
    - name: {{ home }}
    - user: www-data
    - group: www-data
    - mode: 0755
    - require:
      - user: nginx_user
      - group: nginx_group
  user.present:
    - name: www-data
    - home: {{ home }}
    - groups:
      - www-data
    - require:
      - group: nginx_group

get-nginx:
  pkg.installed:
    - names:
      - libpcre3-dev
      - build-essential
      - libssl-dev
  file.managed:
    - name: {{ nginx_package }}
    - source: http://nginx.org/download/nginx-{{ version }}.tar.gz
    - source_hash: {{ checksum }}
  cmd.wait:
    - cwd: {{ source }}
    - name: tar -zxf {{ nginx_package }} -C {{ home }}
    - require:
      - file: nginx_user
      - pkg: get-nginx
    - watch:
      - file: get-nginx

{% for name, module in nginx.get('modules', {}).items() -%}
get-nginx-{{name}}:
  file.managed:
    - name: {{ nginx_modules_dir }}/{{name}}.tar.gz
    - source: {{ module['source'] }}
    - source_hash: {{ module['source_hash'] }}
    - require:
      - file: nginx_user
  cmd.wait:
    - cwd: {{ nginx_home }}
    - names:
        - tar -zxf {{ nginx_modules_dir }}/{{name}}.tar.gz -C {{ nginx_modules_dir }}/{{name}}
    - watch:
      - file: get-nginx
    - require_in:
      - cmd: make-nginx
{% endfor -%}

{% if install_luajit -%}

{% endif -%}

get-ngx_devel_kit:
  file.managed:
    - name: {{ source }}/ngx_devel_kit.tar.gz
    - source: https://github.com/simpl/ngx_devel_kit/archive/v0.2.18.tar.gz
    - source_hash: sha1=e21ba642f26047661ada678b21eef001ee2121d8
  cmd.wait:
    - cwd: {{ nginx_home }}
    - name: tar -zxf {{ source }}/ngx_devel_kit.tar.gz -C {{ source }}
    - watch:
      - file: get-ngx_devel_kit

get-lua-nginx-module:
  file.managed:
    - name: {{ source }}/lua-nginx-module.tar.gz
    - source: https://github.com/chaoslawful/lua-nginx-module/archive/v0.8.3rc1.tar.gz
    - source_hash: sha1=49b2fa946517fb2e9b26185d418570e98ff5ff51
  cmd.wait:
    - cwd: {{ nginx_home }}
    - name: tar -zxf {{ source }}/lua-nginx-module.tar.gz -C {{ source }}
    - watch:
      - file: get-lua-nginx-module

{{ home }}:
  file.directory:
    - user: www-data
    - group: www-data
    - makedirs: True
    - mode: 0755

{% for dir in ('body', 'proxy', 'fastcgi') -%}
{{ home }}-{{dir}}:
  file.directory:
    - name: {{ home }}/{{dir}}
    - user: www-data
    - group: www-data
    - mode: 0755
    - require:
      - file: {{ home }}
    - require_in:
      - service: nginx
{% endfor -%}

nginx:
  cmd.wait:
    - cwd: {{ nginx_home }}
    - names:
      - ./configure --conf-path=/etc/nginx/nginx.conf
        --sbin-path=/usr/sbin/nginx
        --user=www-data
        --group=www-data
        --prefix=/usr/local/nginx
        --error-log-path=/var/log/nginx/error.log
        --pid-path=/var/run/nginx.pid
        --lock-path=/var/lock/nginx.lock
        --http-log-path=/var/log/nginx/access.log
        --with-http_dav_module
        --http-client-body-temp-path={{ home }}/body
        --http-proxy-temp-path={{ home }}/proxy
        --with-http_stub_status_module
        --http-fastcgi-temp-path={{ home }}/fastcgi
        --with-debug
        --with-http_ssl_module
        {% for name, module in nginx.get('modules', {}).items() -%}
        --add-module={{nginx_modules_dir}}/{{name}} \
        --with-pcre --with-ipv6
        {% endfor %}
      - make -j2 && make install
    - watch:
      - cmd: get-nginx
    - require:
      - cmd: get-nginx
      - cmd: get-lua-nginx-module
      - cmd: get-ngx_devel_kit
    - require_in:
      - service: nginx
  file.managed:
    - name: /etc/init/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/templates/upstart.jinja
    - require:
      - cmd: nginx
  service.running:
    - enable: True
    - watch:
      - file: nginx
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/conf.d/default.conf
      - file: /etc/nginx/conf.d/example_ssl.conf
      - file: nginx
    - require:
      - cmd: nginx
      - file: {{ home }}
