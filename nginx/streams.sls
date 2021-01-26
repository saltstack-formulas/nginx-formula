# nginx.streams
#
# Manages creation of streams

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ '/map.jinja' import nginx, sls_block with context %}
{%- from tplroot ~ '/libtofs.jinja' import files_switch with context %}

{#- _nginx is a lightened copy of nginx map intended to passed in templates #}
{%- set _nginx = nginx.copy() %}
{%- do _nginx.pop('streams') %}
{%- do _nginx.pop('servers') %}

nginx_streams_dir:
  file.directory:
    {{ sls_block(nginx.servers.dir_opts) }}
    - name: {{ nginx.lookup.streams_dir }}

{% for stream, config in nginx.streams.items() %}
nginx_streams_{{ stream }}:
  file.managed:
    - name: {{ nginx.lookup.streams_dir ~ '/' ~ stream }}
    - source: {{ files_switch([ stream, 'server.conf' ],
                              'nginx_stream_file_managed'
                 )
              }}
    - template: jinja
    - context:
        config: {{ config|json() }}
        nginx: {{ _nginx|json() }}
{% endfor %}
