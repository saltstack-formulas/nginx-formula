# nginx.snippet
#
# Manages creation of snippets

{% from 'nginx/map.jinja' import nginx, sls_block with context %}

nginx_snippets_dir:
  file.directory:
    {{ sls_block(nginx.servers.dir_opts) }}
    - name: {{ nginx.lookup.snippets_dir }}

{% for snippet, config in nginx.snippets.items() %}
nginx_snippet_{{ snippet }}:
  file.managed:
    - name: {{ nginx.lookup.snippets_dir }}/{{ snippet }}.conf
    - source: salt://nginx/files/server.conf
    - template: jinja
    - context:
        config: {{ config|json() }}
{% endfor %}
