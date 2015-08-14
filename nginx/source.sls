{% from "nginx/map.jinja" import nginx as nginx_map with context %}

{% set nginx = pillar.get('nginx', {}) -%}
{% set use_sysvinit = nginx.get('use_sysvinit', nginx_map['use_sysvinit']) %}
{% set version = nginx.get('version', '1.6.2') -%}
{% set tarball_url = nginx.get('tarball_url', 'http://nginx.org/download/nginx-' + version + '.tar.gz') -%}
{% set checksum = nginx.get('checksum', 'sha256=b5608c2959d3e7ad09b20fc8f9e5bd4bc87b3bc8ba5936a513c04ed8f1391a18') -%}
{% set home = nginx.get('home', nginx_map['home']) -%}
{% set base_temp_dir = nginx.get('base_temp_dir', '/tmp') -%}
{% set source = nginx.get('source_root', '/usr/local/src') -%}

{% set conf_dir = nginx.get('conf_dir', nginx_map['conf_dir']) -%}
{% set conf_only = nginx.get('conf_only', false) -%}
{% set log_dir = nginx.get('log_dir', nginx_map['log_dir']) -%}
{% set pid_path = nginx.get('pid_path', nginx_map['pid_path']) -%}
{% set lock_path = nginx.get('lock_path', '/var/lock/nginx.lock') -%}
{% set sbin_dir = nginx.get('sbin_dir', nginx_map['sbin_dir']) -%}

{% set install_prefix = nginx.get('install_prefix', nginx_map['install_prefix']) -%}
{% set with_items = nginx.get('with', ['debug', 'http_dav_module', 'http_stub_status_module', 'pcre', 'ipv6']) -%}
{% set without_items = nginx.get('without', []) -%}
{% set make_flags = nginx.get('make_flags', nginx_map['make_flags']) -%}

{% set service_name = nginx.get('service_name', 'nginx') %}
{% set service_enable = nginx.get('service_enable', True) %}

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
    - name: {{ nginx_map.default_group }}

nginx_user:
  file.directory:
    - name: {{ home }}
    - user: {{ nginx_map.default_user }}
    - group: {{ nginx_map.default_group }}
    - mode: 0755
    - require:
      - user: nginx_user
      - group: nginx_group
  user.present:
    - name: {{ nginx_map.default_user }}
    - home: {{ home }}
    - groups:
      - {{ nginx_map.default_group }}
    - require:
      - group: nginx_group

{{ nginx_modules_dir }}:
  file:
    - directory
    - makedirs: True

get-build-tools:
{% if grains['saltversion'] < '2015.8.0' and grains['os_family'] == 'RedHat' %}
  module.run:
    - name: pkg.group_install
    - m_name: {{ nginx_map.group_pkg }}
{% else %}
  {{ nginx_map.group_action }}:
    - name: {{ nginx_map.group_pkg }}
{% endif %}

get-nginx:
  pkg.installed:
    - names:
      - {{ nginx_map.libpcre_dev }}
      - {{ nginx_map.libssl_dev }}

  file.managed:
    - name: {{ nginx_package }}
    - source: {{ tarball_url }}
    - source_hash: {{ checksum }}
    - require:
      - file: {{ nginx_modules_dir }}
  cmd.wait:
    - cwd: {{ source }}
    - name: tar --transform "s,^$(tar --list -zf nginx-{{ version }}.tar.gz | head -n 1),nginx-{{ version }}/," -zxf {{ nginx_package }}
    - require:
      - pkg: get-nginx
      - file: get-nginx
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

is-nginx-source-modified:
  cmd.run:
    - cwd: {{ source }}
    - stateful: True
    - names:
      - if [ ! -d "nginx-{{ version }}" ]; then
          echo "changed=yes comment='Tarball has not yet been extracted'";
          exit 0;
        fi;
        cd "nginx-{{ version }}";
        m=$(find . \! -name "build.*" -newer {{ sbin_dir }}/nginx -print -quit);
        r=$?;
        if [ x$r != x0 ]; then
          echo "changed=yes comment='binary file does not exist or other find error'";
          exit 0;
        fi;
        if [ x$m != "x" ]; then
          echo "changed=yes comment='source files are newer than binary'";
          exit 0;
        fi;
        echo "changed=no comment='source files are older than binary'"

{% for name, module in nginx.get('modules', {}).items() -%}
is-nginx-module-modified-{{name}}:
  cmd.run:
    - cwd: {{ nginx_modules_dir }}/{{name}}
    - stateful: True
    - names:
      - m=$(find . \! -name "build.*" -newer {{ sbin_dir }}/nginx -print -quit);
        r=$?;
        if [ x$r != x0 ]; then
          echo "changed=yes comment='binary file does not exist or other find error'";
          exit 0;
        fi;
        if [ x$m != "x" ]; then
          echo "changed=yes comment='module source files are newer than binary'";
          exit 0;
        fi;
        echo "changed=no comment='module source files are older than binary'"
{% endfor -%}

nginx:
  cmd.wait:
    - cwd: {{ nginx_source }}
    - names:
      - (
        ./configure --conf-path={{ conf_dir }}/nginx.conf
        --sbin-path={{ sbin_dir }}/nginx
        --user={{ nginx_map.default_user }}
        --group={{ nginx_map.default_group }}
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
        )
        {#- If they want to silence the compiler output, then save it to file so we can reference it later if needed #}
        {%- if nginx.get('silence_compiler', true) %}
        > {{ nginx_source }}/build.out 2> {{ nginx_source }}/build.err;
        {#- If the build process failed, write stderr to stderr and exit with the error code #}
        r=$?;
        if [ x$r != x0 ]; then
          cat {{ nginx_source }}/build.err 1>&2;  {#- copy err output to stderr #}
          exit $r;
        fi;
        {% endif %}
    - watch:
      - cmd: get-nginx
      - cmd: is-nginx-source-modified
      {% for name, module in nginx.get('modules', {}).items() -%}
      - cmd: is-nginx-module-modified-{{name}}
      - file: get-nginx-{{name}}
      {% endfor %}
{% if use_sysvinit %}
    - watch_in:
      {% set logger_types = ('access', 'error') %}
      {% for log_type in logger_types %}  
      - service: nginx-logger-{{ log_type }}
      {% endfor %}
{% endif %}
    - require:
      - cmd: get-nginx
      {% for name, module in nginx.get('modules', {}).items() -%}
      - file: get-nginx-{{name}}
      {% endfor %}
{% if use_sysvinit %}
  file:
    - managed
    - template: jinja
    - name: /etc/init.d/{{ service_name }}
    - source: salt://nginx/templates/nginx.init.jinja
    - user: root
    - group: root
    - mode: 0755
    - context:
      service_name: {{ service_name }}
      sbin_dir: {{ sbin_dir }}
      pid_path: {{ pid_path }}
{% endif %}
  service:
{% if service_enable %}
    - running
    - enable: True
    - restart: True
{% else %}
    - dead
    - enable: False
{% endif %}
    - name: {{ service_name }}
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
    - require_in:
      - service: nginx
{% endfor %}

{% for file in nginx.get('delete_htdocs', []) %}
{{ install_prefix }}/html/{{ file }}:
  file:
    - absent
    - require_in:
      - service: nginx
{% endfor %}
