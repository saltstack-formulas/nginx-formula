# Source currently requires package 'build-essential' which is Debian based.
# Will not work with os_family RedHat!  You have been warned.
{% set nginx = pillar.get('nginx', {}) -%}
{% set version = nginx.get('version', '1.6.2') -%}
{% set checksum = nginx.get('checksum', 'sha256=b5608c2959d3e7ad09b20fc8f9e5bd4bc87b3bc8ba5936a513c04ed8f1391a18') -%}
{% set home = nginx.get('home', '/var/www') -%}
{% set base_temp_dir = nginx.get('base_temp_dir', '/tmp') -%}
{% set source = nginx.get('source_root', '/usr/local/src') -%}

{% set conf_dir = nginx.get('conf_dir', '/etc/nginx') -%}
{% set conf_only = nginx.get('conf_only', false) -%}
{% set log_dir = nginx.get('log_dir', '/var/log/nginx') -%}
{% set pid_path = nginx.get('pid_path', '/var/run/nginx.pid') -%}
{% set lock_path = nginx.get('lock_path', '/var/lock/nginx.lock') -%}
{% set sbin_dir = nginx.get('sbin_dir', '/usr/sbin') -%}

{% set install_prefix = nginx.get('install_prefix', '/usr/local/nginx') -%}
{% set with_items = nginx.get('with', ['debug', 'http_dav_module', 'http_stub_status_module', 'pcre', 'ipv6']) -%}
{% set without_items = nginx.get('without', []) -%}
{% set make_flags = nginx.get('make_flags', '-j2') -%}

{% set nginx_package = source + '/nginx-' + version + '.tar.gz' -%}
{% set nginx_source  = source + "/nginx-" + version -%}
{% set nginx_modules_dir = source + "/nginx-modules" -%}

include:
  - nginx.common
{% if nginx.get('with_luajit', false) %}
  - nginx.luajit2
{% endif -%}
{% if nginx.get('with_openresty', false) %}
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

{{ nginx_modules_dir }}:
  file:
    - directory
    - makedirs: True

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
    - name: tar -zxf {{ nginx_package }}
    - require:
      - pkg: get-nginx
    - watch:
      - file: get-nginx

{% for name, module in nginx.get('modules', {}).items() -%}
get-nginx-{{name}}:
  file.managed:
    - name: {{ nginx_modules_dir }}/{{name}}.tar.gz
    - source: {{ module['source'] }}
    - source_hash: {{ module['source_hash'] }}
  cmd.wait:
    - cwd: {{ nginx_modules_dir }}
    - names:
        - tar --transform "s,^$(tar --list -zf {{name}}.tar.gz | head -n 1),{{name}}/," -zxf {{name}}.tar.gz
    - watch:
      - file: get-nginx-{{name}}
    - require_in:
      - cmd: nginx
{% endfor -%}

{% if nginx.get('ngx_devel_kit', true) -%}
get-ngx_devel_kit:
  file.managed:
    - name: {{ source }}/ngx_devel_kit.tar.gz
    - source: https://github.com/simpl/ngx_devel_kit/archive/v0.2.18.tar.gz
    - source_hash: sha1=e21ba642f26047661ada678b21eef001ee2121d8
  cmd.wait:
    - cwd: {{ source }}
    - name: tar -zxf {{ source }}/ngx_devel_kit.tar.gz -C {{ source }}
    - watch:
      - file: get-ngx_devel_kit
{% endif %}

nginx:
  cmd.wait:
    - cwd: {{ nginx_source }}
    - names:
      - ./configure --conf-path={{ conf_dir }}/nginx.conf
        --sbin-path={{ sbin_dir }}/nginx
        --user=www-data
        --group=www-data
        --prefix={{ install_prefix }}
        --http-log-path={{ log_dir }}/access.log
        --error-log-path={{ log_dir }}/error.log
        --pid-path={{ pid_path }}
        --lock-path={{ lock_path }}
        --http-client-body-temp-path={{ base_temp_dir }}/body
        --http-proxy-temp-path={{ base_temp_dir }}/proxy
        --http-fastcgi-temp-path={{ base_temp_dir }}/fastcgi
        --http-uwsgi-temp-path={{ base_temp_dir }}/temp_uwsgi
        --http-scgi-temp-path={{ base_temp_dir }}/temp_scgi
        {%- for name, module in nginx.get('modules', {}).items() %}
        --add-module={{nginx_modules_dir}}/{{name}}
        {%- endfor %}
        {%- for name in with_items %}
        --with-{{ name }}
        {%- endfor %}
        {%- for name in without_items %}
        --without-{{ name }}
        {%- endfor %}
        && make {{ make_flags }}
        && make install
    - watch:
      - cmd: get-nginx
      {% for name, module in nginx.get('modules', {}).items() -%}
      - file: get-nginx-{{name}}
      {% endfor %}
    - watch_in:
      {% set logger_types = ('access', 'error') %}
      {% for log_type in logger_types %}  
      - service: nginx-logger-{{ log_type }}
      {% endfor %}
    - require:
      - cmd: get-nginx
      {% for name, module in nginx.get('modules', {}).items() -%}
      - file: get-nginx-{{name}}
      {% endfor %}
    - require_in:
      - service: nginx
  file:
    - managed
    - template: jinja
    - name: /etc/init.d/nginx
    - source: salt://nginx/templates/nginx.init.jinja
    - user: root
    - group: root
    - mode: 0755
    - context:
      sbin_dir: {{ sbin_dir }}
      pid_path: {{ pid_path }}
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - cmd: nginx
      - file: {{ conf_dir }}/nginx.conf
    - require:
      - cmd: nginx
      - file: {{ conf_dir }}/nginx.conf

{% for file in nginx.get('delete_confs', []) %}
{{ conf_dir }}/{{ file }}:
  file:
    - absent
  watch:
    - cmd: nginx
{{ conf_dir }}/{{ file }}.default:
  file:
    - absent
  watch:
    - cmd: nginx
{% endfor %}

{% for file in nginx.get('delete_htdocs', []) %}
{{ install_prefix }}/html/{{ file }}:
  file:
    - absent
  watch:
    - cmd: nginx
{% endfor %}
