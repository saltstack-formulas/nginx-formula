# nginx.pkg
#
# Manages installation of nginx from pkg.

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ '/map.jinja' import nginx, sls_block with context %}
{%- if nginx.install_from_repo %}
  {% set from_official = true %}
  {% set from_ppa = false %}
  {% set from_phusionpassenger = false %}
  {% set from_openresty = false %}
{% elif nginx.install_from_ppa %}
  {% set from_official = false %}
  {% set from_ppa = true %}
  {% set from_phusionpassenger = false %}
  {% set from_openresty = false %}
{% elif nginx.install_from_phusionpassenger %}
  {% set from_official = false %}
  {% set from_ppa = false %}
  {% set from_phusionpassenger = true %}
  {% set from_openresty = false %}
{% elif nginx.install_from_openresty %}
  {% set from_official = false %}
  {% set from_ppa = false %}
  {% set from_phusionpassenger = false %}
  {% set from_openresty = true %}
{% else %}
  {% set from_official = false %}
  {% set from_ppa = false %}
  {% set from_phusionpassenger = false %}
  {% set from_openresty = false %}
{%- endif %}

{{ tplroot }}_nginx_install:
  pkg.installed:
    {{ sls_block(nginx.package.opts) }}
    {% if nginx.lookup.package is iterable and nginx.lookup.package is not string %}
    - pkgs:
      {% for pkg in nginx.lookup.package %}
      - {{ pkg }}
      {% endfor %}
    {% else %}
    - name: {{ nginx.lookup.package }}
    {% endif %}

{% if salt['grains.get']('os_family') == 'Debian' %}
{{ tplroot }}_nginx_official_repo:
  pkgrepo:
    {%- if from_official %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - humanname: nginx apt repo
    - name: deb http://nginx.org/packages/{{ grains['os'].lower() }}/ {{ grains['oscodename'] }} nginx
    - file: /etc/apt/sources.list.d/nginx-official-{{ grains['oscodename'] }}.list
    - keyid: ABF5BD827BD9BF62
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: {{ tplroot }}_nginx_install
    - watch_in:
      - pkg: {{ tplroot }}_nginx_install

openresty_official_repo:
  pkgrepo:
    {%- if from_openresty %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - humanname: openresty apt repo
    - name: deb http://openresty.org/package/{{ grains['os'].lower() }}/ {{ grains['oscodename'] }} {{ nginx.lookup.apt_repo_component }}
    - file: /etc/apt/sources.list.d/openresty-{{ grains['oscodename'] }}.list
    - key_url: https://openresty.org/package/pubkey.gpg
    - require_in:
      - pkg: {{ tplroot }}_nginx_install
    - watch_in:
      - pkg: {{ tplroot }}_nginx_install

{% for package, version in nginx.opm.installed.items() %}
{{ tplroot }}_opm_package_{{ package }}:
  opm.installed:
    - name: {{ package }}
{% if version %}
    - version: {{ version }}
{% endif %}
    - require:
      - pkg: {{ tplroot }}_nginx_install
    - require_in:
      - service: {{ tplroot }}_nginx_service
{% endfor %}

# Ensure service does not start upon package installation since default
# configuration might conflict with an already running service (ex. installing
# OpenResty while NGINX is already listening on default port).
{{ tplroot }}_mask_service:
  file.symlink:  # Not using service.masked: it looks buggy with prereq on Salt 2019.2.5
    - name: /etc/systemd/system/{{ nginx.lookup.service }}.service
    - target: /dev/null
    - prereq:
      - pkg: {{ tplroot }}_nginx_install

# Unmask service after package installation to be able to start it normally
# when configured later on.
{{ tplroot }}_unmask_service:
  file.absent:  # Not using service.unmasked: it looks buggy with prereq on Salt 2019.2.5
    - name: /etc/systemd/system/{{ nginx.lookup.service }}.service
    - onchanges:
      - pkg: {{ tplroot }}_nginx_install
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: /etc/systemd/system/{{ nginx.lookup.service }}.service

   {%- if grains.os not in ('Debian',) %}
       ## applies to Ubuntu and derivatives only #}
{{ tplroot }}_nginx_ppa_repo:
  pkgrepo:
    {%- if from_ppa %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    {% if salt['grains.get']('os') == 'Ubuntu' %}
    - ppa: nginx/{{ nginx.ppa_version }}
    {% else %}
    - name: deb http://ppa.launchpad.net/nginx/{{ nginx.ppa_version }}/ubuntu {{ grains['oscodename'] }} main
    - keyid: C300EE8C
    - keyserver: keyserver.ubuntu.com
    {% endif %}
    - require_in:
      - pkg: {{ tplroot }}_nginx_install
    - watch_in:
      - pkg: {{ tplroot }}_nginx_install
   {%- endif %}

{{ tplroot }}_nginx_phusionpassenger_repo:
  pkgrepo:
    {%- if from_phusionpassenger %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - humanname: nginx phusionpassenger repo
    - name: deb https://oss-binaries.phusionpassenger.com/apt/passenger {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/nginx-phusionpassenger-{{ grains['oscodename'] }}.list
    - keyid: 561F9B9CAC40B2F7
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: {{ tplroot }}_nginx_install
    - watch_in:
      - pkg: {{ tplroot }}_nginx_install
{% endif %}

{% if salt['grains.get']('os_family') == 'Suse' or salt['grains.get']('os') == 'SUSE' %}
{{ tplroot }}_nginx_zypp_repo:
  pkgrepo:
    {%- if from_official %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - name: server_http
    - humanname: server_http
    - baseurl: 'http://download.opensuse.org/repositories/server:/http/openSUSE_13.2/'
    - enabled: True
    - autorefresh: True
    - gpgcheck: {{ nginx.lookup.gpg_check }}
    - gpgkey: {{ nginx.lookup.gpg_key }}
    - require_in:
      - pkg: {{ tplroot }}_nginx_install
    - watch_in:
      - pkg: {{ tplroot }}_nginx_install
{% endif %}

{% if salt['grains.get']('os_family') == 'RedHat' %}
{{ tplroot }}_nginx_yum_repo:
  pkgrepo:
    {%- if from_official %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - name: nginx
    - humanname: nginx repo
    {%- if salt['grains.get']('os') == 'CentOS' %}
    - baseurl: 'http://nginx.org/packages/centos/$releasever/$basearch/'
    {%- else %}
    - baseurl: 'http://nginx.org/packages/rhel/{{ nginx.lookup.rh_os_releasever }}/$basearch/'
    {%- endif %}
    - gpgcheck: {{ nginx.lookup.gpg_check }}
    - gpgkey: {{ nginx.lookup.gpg_key }}
    - enabled: True
    - require_in:
      - pkg: {{ tplroot }}_nginx_install
    - watch_in:
      - pkg: {{ tplroot }}_nginx_install

{{ tplroot }}_nginx_phusionpassenger_yum_repo:
  pkgrepo:
    {%- if from_phusionpassenger %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - name: passenger
    - humanname: nginx phusionpassenger repo
    - baseurl: 'https://oss-binaries.phusionpassenger.com/yum/passenger/el/$releasever/$basearch'
    - repo_gpgcheck: 1
    - gpgcheck: 0
    - gpgkey: 'https://packagecloud.io/gpg.key'
    - enabled: True
    - sslverify: 1
    - sslcacert: /etc/pki/tls/certs/ca-bundle.crt
    - require_in:
      - pkg: {{ tplroot }}_nginx_install
    - watch_in:
      - pkg: {{ tplroot }}_nginx_install
{% endif %}
