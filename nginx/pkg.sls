# nginx.pkg
#
# Manages installation of nginx from pkg.

{% from 'nginx/map.jinja' import nginx, sls_block with context %}
{%- if nginx.install_from_repo %}
  {% set from_official = true %}
  {% set from_ppa = false %}
  {% set from_phusionpassenger = false %}
{% elif nginx.install_from_ppa %}
  {% set from_official = false %}
  {% set from_ppa = true %}
  {% set from_phusionpassenger = false %}
{% elif nginx.install_from_phusionpassenger %}
  {% set from_official = false %}
  {% set from_ppa = false %}
  {% set from_phusionpassenger = true %}
{% else %}
  {% set from_official = false %}
  {% set from_ppa = false %}
  {% set from_phusionpassenger = false %}
{%- endif %}

nginx_install:
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
nginx_official_repo:
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
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install

   {%- if grains.os not in ('Debian',) %}
       ## applies to Ubuntu and derivatives only #}
nginx_ppa_repo:
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
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
   {%- endif %}

nginx_phusionpassenger_repo:
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
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
{% endif %}

{% if salt['grains.get']('os_family') == 'Suse' or salt['grains.get']('os') == 'SUSE' %}
nginx_zypp_repo:
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
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
{% endif %}

{% if salt['grains.get']('os_family') == 'RedHat' %}
nginx_yum_repo:
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
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install

nginx_phusionpassenger_yum_repo:
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
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
{% endif %}
