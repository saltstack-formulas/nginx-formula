{% set nginx = pillar.get('nginx', {}) -%}
{% set home = nginx.get('home', '/var/www') -%}
{% set source = nginx.get('source_root', '/usr/local/src') -%}

{% set openresty = nginx.get('openresty', {}) -%}
{% set openresty_version = openresty.get('version', '1.2.7.8') -%}
{% set openresty_checksum = openresty.get('checksum', 'sha1=f8bee501529ffec33f9cabc00ea4ca512a8d7b59') -%}
{% set openresty_package = source + '/openresty-' + openresty_version + '.tar.gz' -%}

get-openresty:
  file.managed:
    - name: {{ openresty_package }}
    - source: http://openresty.org/download/ngx_openresty-{{ openresty_version }}.tar.gz
    - source_hash: {{ openresty_checksum }}
  cmd.wait:
    - cwd: {{ source }}
    - name: tar -zxf {{ openresty_package }} -C {{ home }}
    - watch:
      - file: get-openresty

install_openresty:
  cmd.wait:
    - cwd: {{ home }}/ngx_openresty-{{ openresty_version }}
    - names: 
      - ./configure --with-luajit \
                    --with-http_drizzle_module \
                    --with-http_postgres_module \ 
                    --with-http_iconv_module
      - make && make install
    - watch:
      - cmd: get-openresty
