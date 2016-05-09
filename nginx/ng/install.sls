# nginx.ng.install
#
# Manages installation of nginx.

{% from 'nginx/ng/map.jinja' import nginx, sls_block with context %}

{% if nginx.install_from_source %}
nginx_build_dep:
  {% if salt['grains.get']('os_family') == 'Debian' %}
  cmd.run:
    - name: apt-get -y build-dep nginx
  {% elif salt['grains.get']('os_family') == 'RedHat' %}
  cmd.run:
    - name: yum-builddep -y nginx
  {% else %}
  ## install build deps for other distros
  {% endif %}

nginx_download:
  archive.extracted:
    - name: /tmp/
    - source: http://nginx.org/download/nginx-{{ nginx.source_version }}.tar.gz
    - source_hash: sha256={{ nginx.source_hash }}
    - archive_format: tar
    - if_missing: /usr/sbin/nginx-{{ nginx.source_version }}
    - require:
      - cmd: nginx_build_dep
    - onchanges:
      - cmd: nginx_build_dep

nginx_configure:
  cmd.run:
    - name: ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf {{ nginx.source.opts | join(' ') }}
    - cwd: /tmp/nginx-{{ nginx.source_version }}
    - require:
      - archive: nginx_download
    - onchanges:
      - archive: nginx_download

nginx_compile:
  cmd.run:
    - name: make
    - cwd: /tmp/nginx-{{ nginx.source_version }}
    - require:
      - cmd: nginx_configure
{% endif %}

nginx_install:
  {% if nginx.install_from_source %}
  cmd.run:
    - name: make install
    - cwd: /tmp/nginx-{{ nginx.source_version }}
    - require:
      - cmd: nginx_compile
    - onchanges:
      - cmd: nginx_compile
  {% else %}
  pkg.installed:
    {{ sls_block(nginx.package.opts) }}
    - name: {{ nginx.lookup.package }}
  {% endif %}

{% if nginx.install_from_source %}
nginx_link:
  file.copy:
    - name: /usr/sbin/nginx-{{ nginx.source_version }}
    - source: /usr/sbin/nginx
    - require:
      - cmd: nginx_install
    - onchanges:
      - cmd: nginx_install
{% endif %}

{% if salt['grains.get']('os_family') == 'Debian' %}
  {%- if nginx.install_from_repo %}
nginx-official-repo:
  pkgrepo:
    - managed
    - humanname: nginx apt repo
    - name: deb http://nginx.org/packages/{{ grains['os'].lower() }}/ {{ grains['oscodename'] }} nginx
    - file: /etc/apt/sources.list.d/nginx-official-{{ grains['oscodename'] }}.list
    - keyid: ABF5BD827BD9BF62
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: nginx
    - watch_in:
      - pkg: nginx
  {%- else %}
nginx_ppa_repo:
  pkgrepo:
    {%- if nginx.install_from_ppa %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    {% if salt['grains.get']('os') == 'Ubuntu' %}
    - ppa: nginx/{{ nginx.ppa_version }}
    {% else %}
    - name: deb http://ppa.launchpad.net/nginx/{{ nginx.ppa_version }}/ubuntu trusty main
    - keyid: C300EE8C
    - keyserver: keyserver.ubuntu.com
    {% endif %}
    - require_in:
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
  {%- endif %}
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
    - gpgcheck: {{ nginx.lookup.gpg_check }}
    - gpgkey: {{ nginx.lookup.gpg_key }}
    - require_in:
      - pkg: nginx_install
    - watch_in:
      - pkg: nginx_install
{% endif %}

{% if salt['grains.get']('os_family') == 'RedHat' %}
nginx_yum_repo:
  {%- if nginx.install_from_repo %}
  pkgrepo.managed:
  {%- else %}
  pkgrepo.absent:
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
{% endif %}
