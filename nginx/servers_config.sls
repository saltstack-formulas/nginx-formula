# nginx.servers_config
#
# Manages the configuration of virtual host files.

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ '/map.jinja' import nginx, sls_block with context %}
{%- from tplroot ~ '/libtofs.jinja' import files_switch with context %}

{% set server_states = [] %}
{#- _nginx is a lightened copy of nginx map intended to passed in templates #}
{%- set _nginx = nginx.copy() %}
{%- do _nginx.pop('snippets') if nginx.snippets is defined %}
{%- do _nginx.pop('servers') if nginx.servers is defined %}

# Simple path concatenation.
# Needs work to make this function on windows.
{% macro path_join(file, root) -%}
  {{ root ~ '/' ~ file }}
{%- endmacro %}

# Retrieves the disabled name of a particular server
{% macro disabled_name(server) -%}
  {%- if nginx.lookup.server_use_symlink -%}
    {{ nginx.servers.managed.get(server).get('disabled_name', server) }}
  {%- else -%}
    {{ nginx.servers.managed.get(server).get('disabled_name', server ~ nginx.servers.disabled_postfix) }}
  {%- endif -%}
{%- endmacro %}

# Gets the path of a particular server
{% macro server_path(server, state) -%}
  {%- if state == True -%}
    {{ path_join(server, nginx.servers.managed.get(server).get('enabled_dir', nginx.lookup.server_enabled)) }}
  {%- elif state == False -%}
    {{ path_join(disabled_name(server), nginx.servers.managed.get(server).get('available_dir', nginx.lookup.server_available)) }}
  {%- else -%}
    {{ path_join(server, nginx.servers.managed.get(server).get('available_dir', nginx.lookup.server_available)) }}
  {%- endif -%}
{%- endmacro %}

# Gets the current canonical name of a server
{% macro server_curpath(server) -%}
  {{ server_path(server, nginx.servers.managed.get(server).get('available_dir')) }}
{%- endmacro %}

# Creates the sls block that manages symlinking / renaming servers
{% macro manage_status(server, state, deleted) -%}
  {%- set anti_state = {True:False, False:True}.get(state) -%}
  {% if state == True %}
    {%- if nginx.lookup.server_use_symlink %}
  file.symlink:
    {{ sls_block(nginx.servers.symlink_opts) }}
    - name: {{ server_path(server, state) }}
    - makedirs: True
    - target: {{ server_path(server, anti_state) }}
    {%- else %}
        {%- if deleted == True %}
  file.absent:
    - name: {{ server_path(server, state) }}
        {%- else %}
  file.rename:
    {{ sls_block(nginx.servers.rename_opts) }}
    - name: {{ server_path(server, state) }}
    - source: {{ server_path(server, anti_state) }}
        {%- endif %}
    {%- endif %}
  {%- elif state == False %}
    {%- if nginx.lookup.server_use_symlink %}
  file.absent:
    - name: {{ server_path(server, anti_state) }}
    {%- else %}
        {%- if deleted == True %}
  file.absent:
    - name: {{ server_path(server, state) }}
        {%- else %}
  file.rename:
    {{ sls_block(nginx.servers.rename_opts) }}
    - name: {{ server_path(server, state) }}
    - source: {{ server_path(server, anti_state) }}
        {%- endif %}
    {%- endif -%}
  {%- endif -%}
{%- endmacro %}

# Makes sure the enabled directory exists
nginx_server_enabled_dir:
  file.directory:
    {{ sls_block(nginx.servers.dir_opts) }}
    - name: {{ nginx.lookup.server_enabled }}

# If enabled and available are not the same, create available
{% if nginx.lookup.server_enabled != nginx.lookup.server_available -%}
nginx_server_available_dir:
  file.directory:
    {{ sls_block(nginx.servers.dir_opts) }}
    - name: {{ nginx.lookup.server_available }}
{%- endif %}

# Managed enabled/disabled state for servers
{% for server, settings in nginx.servers.managed.items() %}
{% set conf_state_id = 'server_conf_' ~ loop.index0 %}
{% if 'deleted' in settings and settings.deleted %}
{{ conf_state_id }}:
    file.absent:
        - name: {{ server_curpath(server) }}
{% do server_states.append(conf_state_id) %}
{% else %}
{% if settings.enabled == True %}
{{ conf_state_id }}:
  file.managed:
    {{ sls_block(nginx.servers.managed_opts) }}
    - name: {{ server_curpath(server) }}
    - source:
{%- if 'source_path' in settings.config %}
      - {{ settings.config.source_path }}
{%- endif %}
      {{ files_switch([server, 'server.conf'],
                      'server_conf_file_managed'
         )
      }}
    - makedirs: True
    - template: jinja
      {%- if 'requires' in settings %}
    - require:
        {%- for k, v in settings.requires.items() %}
      - {{ k }}: {{ v }}
        {%- endfor %}
      {%- endif %}
{% if 'source_path' not in settings.config %}
    - context:
        config: {{ settings.config|json(sort_keys=False) }}
        nginx: {{ _nginx|json() }}
{% endif %}
    {% if 'overwrite' in settings and settings.overwrite == False %}
    - unless:
      - test -e {{ server_curpath(server) }}
    {% endif %}
{% do server_states.append(conf_state_id) %}
{% endif %}
{% endif %}

{% if settings.enabled != None %}
{% set status_state_id = 'server_state_' ~ loop.index0 %}
{%- set enabled_dir = path_join(server, nginx.servers.managed.get(server).get('enabled_dir', nginx.lookup.server_enabled)) -%}
{%- set available_dir = path_join(server, nginx.servers.managed.get(server).get('available_dir', nginx.lookup.server_available)) -%}
{%- if enabled_dir != available_dir %}
{{ status_state_id }}:
{% if 'deleted' in settings and settings.deleted %}
{{ manage_status(server, False, True) }}
{% else %}
{{ manage_status(server, settings.enabled, False) }}
{% endif %}
{% if settings.enabled == True %}
    - require:
      - file: {{ conf_state_id }}
{% endif %}

{% do server_states.append(status_state_id) %}
{%- endif %} {# enabled != available_dir #}
{% endif %}
{% endfor %}


{# Add . and .. to make it easier to not clean those #}
{% set valid_sites = ['.', '..', ] %}

{# Take sites from nginx.servers.managed #}
{% for server, settings in salt['pillar.get']('nginx:servers:managed', {}).items() %}
{%   do valid_sites.append(server) %}
{% endfor %}

{% if salt['file.directory_exists'](nginx.lookup.server_enabled) %}
{%   for filename in salt['file.readdir'](nginx.lookup.server_enabled) %}
{%     if filename not in valid_sites %}

{{ nginx.lookup.server_enabled ~ '/' ~ filename }}:
  file.absent

{%     endif %}
{%   endfor %}
{% endif %}
