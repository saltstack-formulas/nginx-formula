# nginx.ng.vhosts_config
#
# Manages the configuration of virtual host files.

{% from 'nginx/ng/map.jinja' import nginx, sls_block with context %}
{% set vhost_states = [] %}

# Simple path concatenation.
# Needs work to make this function on windows.
{% macro path_join(file, root) -%}
  {{ root ~ '/' ~ file }}
{%- endmacro %}

# Retrieves the disabled name of a particular vhost
{% macro disabled_name(vhost) -%}
  {%- if nginx.lookup.vhost_use_symlink -%}
    {{ nginx.vhosts.managed.get(vhost).get('disabled_name', vhost) }}
  {%- else -%}
    {{ nginx.vhosts.managed.get(vhost).get('disabled_name', vhost ~ nginx.vhosts.disabled_postfix) }}
  {%- endif -%}
{%- endmacro %}

# Gets the path of a particular vhost
{% macro vhost_path(vhost, state) -%}
  {%- if state == True -%}
    {{ path_join(vhost, nginx.vhosts.managed.get(vhost).get('dir', nginx.lookup.vhost_enabled)) }}
  {%- elif state == False -%}
    {{ path_join(disabled_name(vhost), nginx.vhosts.managed.get(vhost).get('dir', nginx.lookup.vhost_available)) }}
  {%- else -%}
    {{ path_join(vhost, nginx.vhosts.managed.get(vhost).get('dir', nginx.lookup.vhost_available)) }}
  {%- endif -%}
{%- endmacro %}

# Gets the current canonical name of a vhost
{% macro vhost_curpath(vhost) -%}
  {{ vhost_path(vhost, nginx.vhosts.managed.get(vhost).get('available')) }}
{%- endmacro %}

# Creates the sls block that manages symlinking / renaming vhosts
{% macro manage_status(vhost, state) -%}
  {%- set anti_state = {True:False, False:True}.get(state) -%}
  {% if state == True %}
    {%- if nginx.lookup.vhost_use_symlink %}
  file.symlink:
    {{ sls_block(nginx.vhosts.symlink_opts) }}
    - name: {{ vhost_path(vhost, state) }}
    - target: {{ vhost_path(vhost, anti_state) }}
    {%- else %}
  file.rename:
    {{ sls_block(nginx.vhosts.rename_opts) }}
    - name: {{ vhost_path(vhost, state) }}
    - source: {{ vhost_path(vhost, anti_state) }}
    {%- endif %}
  {%- elif state == False %}
    {%- if nginx.lookup.vhost_use_symlink %}
  file.absent:
    - name: {{ vhost_path(vhost, anti_state) }}
    {%- else %}
  file.rename:
    {{ sls_block(nginx.vhosts.rename_opts) }}
    - name: {{ vhost_path(vhost, state) }}
    - source: {{ vhost_path(vhost, anti_state) }}
    {%- endif -%}
  {%- endif -%}
{%- endmacro %}

# Makes sure the enabled directory exists
nginx_vhost_enabled_dir:
  file.directory:
    {{ sls_block(nginx.vhosts.dir_opts) }}
    - name: {{ nginx.lookup.vhost_enabled }}

# If enabled and available are not the same, create available
{% if nginx.lookup.vhost_enabled != nginx.lookup.vhost_available -%}
nginx_vhost_available_dir:
  file.directory:
    {{ sls_block(nginx.vhosts.dir_opts) }}
    - name: {{ nginx.lookup.vhost_available }}
{%- endif %}

# Manage the actual vhost files
{% for vhost, settings in nginx.vhosts.managed.items() %}
{% endfor %}

# Managed enabled/disabled state for vhosts
{% for vhost, settings in nginx.vhosts.managed.items() %}
{% if settings.config != None %}
{% set conf_state_id = 'vhost_conf_' ~ loop.index0 %}
{{ conf_state_id }}:
  file.managed:
    {{ sls_block(nginx.vhosts.managed_opts) }}
    - name: {{ vhost_curpath(vhost) }}
    - source: salt://nginx/ng/files/vhost.conf
    - template: jinja
    - context:
        config: {{ settings.config|json() }}
{% do vhost_states.append(conf_state_id) %}
{% endif %}

{% if settings.enabled != None %}
{% set status_state_id = 'vhost_state_' ~ loop.index0 %}
{{ status_state_id }}:
{{ manage_status(vhost, settings.enabled) }}
{% if settings.config != None %}
    - require:
      - file: {{ conf_state_id }}
{% endif %}

{% do vhost_states.append(status_state_id) %}
{% endif %}
{% endfor %}
