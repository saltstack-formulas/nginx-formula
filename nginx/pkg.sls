# nginx.pkg
#
# Manages installation of nginx from pkg.

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import nginx, sls_block with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if nginx.install_from_repo %}
  {% set from_official = true %}
  {% set from_ppa = false %}
  {% set from_phusionpassenger = false %}
  {% set from_opensuse_devel = false %}
{% elif nginx.install_from_ppa %}
  {% set from_official = false %}
  {% set from_ppa = true %}
  {% set from_phusionpassenger = false %}
  {% set from_opensuse_devel = false %}
{% elif nginx.install_from_phusionpassenger %}
  {% set from_official = false %}
  {% set from_ppa = false %}
  {% set from_phusionpassenger = true %}
  {% set from_opensuse_devel = false %}
{% elif nginx.install_from_opensuse_devel %}
  {% set from_official = false %}
  {% set from_ppa = false %}
  {% set from_phusionpassenger = false %}
  {% set from_opensuse_devel = true %}
{% else %}
  {% set from_official = false %}
  {% set from_ppa = false %}
  {% set from_phusionpassenger = false %}
  {% set from_opensuse_devel = false %}
{%- endif %}

{%- set resource_repo_managed = 'file' if grains.os_family == 'Debian' else 'pkgrepo' %}

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

{% if grains.os_family == 'Debian' %}
  {%- if from_official %}
nginx_official_repo_keyring:
  file.managed:
    - name: {{ nginx.lookup.package_repo_keyring }}
    - source: {{ files_switch(['nginx-archive-keyring.gpg'],
                              lookup='nginx_official_repo_keyring'
                 )
              }}
    - require_in:
      - {{ resource_repo_managed }}: nginx_official_repo
  {%- endif %}

nginx_official_repo:
  file:
    {%- if from_official %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - name: /etc/apt/sources.list.d/nginx-official-{{ grains.oscodename }}.list
    - contents: >
        deb [signed-by={{ nginx.lookup.package_repo_keyring }}]
        http://nginx.org/packages/{{ grains.os | lower }}/ {{ grains.oscodename }} nginx

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
    {% if grains.os == 'Ubuntu' %}
    - ppa: nginx/{{ nginx.ppa_version }}
    {% else %}
    - name: deb http://ppa.launchpad.net/nginx/{{ nginx.ppa_version }}/ubuntu {{ grains.oscodename }} main
    - keyid: C300EE8C
    - keyserver: keyserver.ubuntu.com
    {% endif %}
    - require_in:
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
   {%- endif %}

  {%- if from_phusionpassenger %}
nginx_phusionpassenger_repo_keyring:
  file.managed:
    - name: /usr/share/keyrings/phusionpassenger-archive-keyring.gpg
    - source: {{ files_switch(['phusionpassenger-archive-keyring.gpg'],
                              lookup='nginx_phusionpassenger_repo_keyring'
                 )
              }}
    - require_in:
      - {{ resource_repo_managed }}: nginx_phusionpassenger_repo

# Remove the old repo file
nginx_phusionpassenger_repo_remove:
  pkgrepo.absent:
    - name: deb http://nginx.org/packages/{{ grains.os |lower }}/ {{ grains.oscodename }} nginx
    - keyid: 561F9B9CAC40B2F7
    - require_in:
      - {{ resource_repo_managed }}: nginx_phusionpassenger_repo
  file.absent:
    - name: /etc/apt/sources.list.d/nginx-phusionpassenger-{{ grains.oscodename }}.list
    - require_in:
      - {{ resource_repo_managed }}: nginx_phusionpassenger_repo
  {%- endif %}

nginx_phusionpassenger_repo:
  file:
    {%- if from_phusionpassenger %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - name: /etc/apt/sources.list.d/phusionpassenger-official-{{ grains.oscodename }}.list
    - contents: >
        deb [signed-by={{ nginx.lookup.passenger_package_repo_keyring }}]
        https://oss-binaries.phusionpassenger.com/apt/passenger {{ grains.oscodename }} main

    - require_in:
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
{% endif %}

{% if grains.os_family == 'Suse' or grains.os == 'SUSE' %}
nginx_zypp_repo:
  pkgrepo:
    - name: server_http
    {%- if from_opensuse_devel %}
    - managed
    - humanname: server_http
    - baseurl: 'http://download.opensuse.org/repositories/server:/http/{{ grains.osrelease }}/'
    - enabled: True
    - autorefresh: True
    - gpgcheck: {{ nginx.lookup.gpg_check }}
    - gpgkey: {{ nginx.lookup.gpg_key }}
    - gpgautoimport: {{ nginx.lookup.gpg_autoimport }}
    {%- else %}
    - absent
    {%- endif %}
    - require_in:
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
{% endif %}

{% if grains.os_family == 'RedHat' %}
  {% if grains.get('osfinger', '') == 'Amazon Linux-2' %}
nginx_epel_repo:
  pkgrepo.managed:
    - name: epel
    - humanname: Extra Packages for Enterprise Linux 7 - $basearch
    - mirrorlist: https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
    - enabled: 1
    - gpgcheck: 1
    - gpgkey: https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
    - failovermethod: priority
    - require_in:
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
{%   endif %}

nginx_yum_repo:
  pkgrepo:
    {%- if from_official %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    - name: nginx
    - humanname: nginx repo
    {%- if grains.os == 'CentOS' %}
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
    - gpgkey: 'https://oss-binaries.phusionpassenger.com/yum/definitions/RPM-GPG-KEY.asc'
    - enabled: True
    - sslverify: 1
    - sslcacert: /etc/pki/tls/certs/ca-bundle.crt
    - require_in:
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
{% endif %}
