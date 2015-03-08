# nginx.ng.install
#
# Manages installation of nginx.

{% from 'nginx/ng/map.jinja' import nginx, sls_block with context %}

nginx_install:
  {% if nginx.install_from_source %}
  ## add source compilation here
  {% else %}
  pkg.installed:
    {{ sls_block(nginx.package.opts) }}
    - name: {{ nginx.lookup.package }}
  {% endif %}

{% if salt['grains.get']('os_family') == 'Debian' %}
nginx_ppa_repo:
  pkgrepo:
    {%- if nginx.install_from_ppa %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - ppa: nginx/{{ nginx.ppa_version }}
    - require_in:
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
{% endif %}

{% if salt['grains.get']('os_family') == 'Suse' %}
nginx_zypp_repo:
  pkgrepo:
    {%- if nginx.install_from_repo %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - name: server_http
    - humanname: server_http
    - baseurl: 'http://download.opensuse.org/repositories/server:/http/openSUSE_13.2/'
    - enabled: True
    - autorefresh: True
    - gpgcheck: True
    - gpgkey: 'http://download.opensuse.org/repositories/server:/http/openSUSE_13.2/repodata/repomd.xml.key'
    - require_in:
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
{% endif %}
