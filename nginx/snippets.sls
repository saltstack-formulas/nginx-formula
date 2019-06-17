# nginx.snippet
#
# Manages creation of snippets

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ '/map.jinja' import nginx, sls_block with context %}
{%- from tplroot ~ '/libtofs.jinja' import files_switch with context %}

nginx_snippets_dir:
  file.directory:
    {{ sls_block(nginx.servers.dir_opts) }}
    - name: {{ nginx.lookup.snippets_dir }}

{% for snippet, config in nginx.snippets.items() %}
nginx_snippet_{{ snippet }}:
  file.managed:
    - name: {{ nginx.lookup.snippets_dir ~ '/' ~ snippet }}
    - source: {{ files_switch([ snippet, 'server.conf' ],
                              'nginx_snippet_file_managed'
                 )
              }}
    - template: jinja
    - context:
        config: {{ config|json() }}
{% endfor %}
