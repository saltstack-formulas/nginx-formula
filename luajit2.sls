{% set nginx = pillar.get('nginx', {}) -%}
{% set home = nginx.get('home', '/var/www') -%}
{% set source = nginx.get('source_root', '/usr/local/src') -%}

get-luajit2:
  file.managed:
    - name: {{ source }}/luajit.tar.gz
    - source: http://luajit.org/download/LuaJIT-2.0.1.tar.gz
    - source_hash: sha1=330492aa5366e4e60afeec72f15e44df8a794db5
  cmd.wait:
    - cwd: {{ nginx_home }}
    - name: tar -zxf {{ source }}/luajit.tar.gz -C {{ source }}
    - watch:
      - file: get-luajit2
    - require_in:
      - cmd: nginx