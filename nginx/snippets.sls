# nginx.snippet
#
# Manages creation of snippets

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ '/map.jinja' import nginx, sls_block with context %}
{%- from tplroot ~ '/libtofs.jinja' import files_switch with context %}

{#- _nginx is a lightened copy of nginx map intended to passed in templates #}
{%- set _nginx = nginx.copy() %}
{%- do _nginx.pop('snippets') if nginx.snippets is defined %}
{%- do _nginx.pop('servers') if nginx.servers is defined %}

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
        nginx: {{ _nginx|json() }}
    - require:
      - file: nginx_snippets_dir
    - require_in:
      - file: nginx_config
      - service: nginx_service
{% endfor %}
