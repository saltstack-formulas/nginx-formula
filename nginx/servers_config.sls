# nginx.servers_config
#
# Manages the configuration of virtual host files.

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ '/map.jinja' import nginx, sls_block with context %}
{%- from tplroot ~ '/libtofs.jinja' import files_switch with context %}

{% set server_states = [] %}

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
    - clean: {{ nginx.servers.purge_servers_config }}

# If enabled and available are not the same, create available
{% if nginx.lookup.server_enabled != nginx.lookup.server_available -%}
nginx_server_available_dir:
  file.directory:
    {{ sls_block(nginx.servers.dir_opts) }}
    - name: {{ nginx.lookup.server_available }}
    - clean: {{ nginx.servers.purge_servers_config }}
{%- endif %}

# Manage the actual server files
{% for server, settings in nginx.servers.managed.items() %}
{% endfor %}

# Managed enabled/disabled state for servers
{% for server, settings in nginx.servers.managed.items() %}
{% set conf_state_id = 'server_conf_' ~ loop.index0 %}
{% if 'deleted' in settings and settings.deleted %}
{{ conf_state_id }}:
    file.absent:
        - name: {{ server_curpath(server) }}
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
    - require_in:
      - service: nginx_service
{% if 'source_path' not in settings.config %}
    - context:
        config: {{ settings.config|json(sort_keys=False) }}
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

{% if 'deleted' not in settings or ( 'deleted' in settings and settings.deleted == False ) %}
{% do server_states.append(status_state_id) %}
{% endif %}
{%- endif %} {# enabled != available_dir #}
{% endif %}
{% endfor %}
