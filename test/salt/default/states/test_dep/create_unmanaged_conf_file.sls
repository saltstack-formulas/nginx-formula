# This state creates a file that is used to test whether an unmanaged file is 
# purged when nginx:servers:purge_servers_config: is set to true.

{%- from 'nginx/map.jinja' import nginx with context %}

create_unmanaged_conf_file:
  file.managed:
    - name: {{ nginx.lookup.server_available }}/unmanaged-deleteme.conf
    - makedirs: true
    - contents: |
        # This exists only for testing and should be removed when the 
        # purge_servers_config flag is set to true.

{% if nginx.lookup.server_enabled != nginx.lookup.server_available %}
create_unmanaged_conf_symlink:
  file.symlink:
    - name: {{ nginx.lookup.server_enabled }}/unmanaged-deleteme.conf
    - target: {{ nginx.lookup.server_available }}/unmanaged-deleteme.conf
    - makedirs: true
{% endif %}
