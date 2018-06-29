# nginx:
   install_from_source: True
   use_upstart: True
   use_sysvinit: False
   user_auth_enabled: True
   with_luajit: False
   with_openresty: True
   repo_version: development  # Must be using ppa install by setting `repo_source = ppa`
   set_real_ips: # NOTE: to use this, nginx must have http_realip module enabled
     from_ips:
       - 10.10.10.0/24
     real_ip_header: X-Forwarded-For
   modules:
     headers-more:
       source: http://github.com/agentzh/headers-more-nginx-module/tarball/v0.21
       source_hash: sha1=dbf914cbf3f7b6cb7e033fa7b7c49e2f8879113b

# ========
# nginx.ng
# ========

nginx:
  ng:
    # The following three `install_from_` options are mutually exclusive. If none is used, the distro's provided
    # package will be installed. If one of the `install_from` option is set to `True`, the state will
    # make sure the other two repos are removed.

    # Use the official's nginx repo binaries
    install_from_repo: false

    # Use Phusionpassenger's repo to install nginx and passenger binaries
    # Debian, Centos, Ubuntu and Redhat are currently available
    install_from_phusionpassenger: false

    # PPA install
    install_from_ppa: false
    # Set to 'stable', 'development' (mainline), 'community', or 'nightly' for each build accordingly ( https://launchpad.net/~nginx )
    ppa_version: 'stable'

    # Source install
    source_version: '1.10.0'
    source_hash: ''

    # These are usually set by grains in map.jinja
    # Typically you can comment these out.
    lookup:
      package: nginx-custom
      service: nginx
      webuser: www-data
      conf_file: /etc/nginx/nginx.conf
      server_available: /etc/nginx/sites-available
      server_enabled: /etc/nginx/sites-enabled
      server_use_symlink: True
      # If you install nginx+passenger from phusionpassenger in Debian, these values will probably be needed
      passenger_package: libnginx-mod-http-passenger
      passenger_config_file: /etc/nginx/conf.d/mod-http-passenger.conf

      # This is required for RedHat like distros (Amazon Linux) that don't follow semantic versioning for $releasever
      rh_os_releasever: '6'
      # Currently it can be used on rhel/centos/suse when installing from repo
      gpg_check: True
      pid_file: /var/run/nginx.pid   ### Prevent Rendering SLS error (map.jinja:149) if nginx.server.config.pid undefined (Ubuntu, etc) ###


    # Source compilation is not currently a part of nginx.ng
    from_source: False

    source:
      opts: {}

    package:
      opts: {} # this partially exposes parameters of pkg.installed

    service:
      enable: True # Whether or not the service will be enabled/running or dead
      opts: {} # this partially exposes parameters of service.running / service.dead

    server:
      opts: {} # this partially exposes file.managed parameters as they relate to the main nginx.conf file

      # nginx.conf (main server) declarations
      # dictionaries map to blocks {} and lists cause the same declaration to repeat with different values
      config:
        source_path: salt://path_to_nginx_conf_file/nginx.conf # IMPORTANT: This option is mutually exclusive with the rest of the
                                                          # options; if it is found other options (worker_processes: 4 and so
                                                          # on) are not processed and just upload the file from source
        worker_processes: 4
        load_module: modules/ngx_http_lua_module.so  # this will be passed very first in configuration; otherwise nginx will fail to start
        pid: /var/run/nginx.pid		### Directory location must exist
        events:
          worker_connections: 768
        http:
          sendfile: 'on'
          include:
            #### Note: Syntax issues in these files generate nginx [emerg] errors on startup.  ####
            - /etc/nginx/mime.types
            - /etc/nginx/conf.d/*.conf
            - /etc/nginx/sites-enabled/*

    servers:
      disabled_postfix: .disabled # a postfix appended to files when doing non-symlink disabling
      symlink_opts: {} # partially exposes file.symlink params when symlinking enabled sites
      rename_opts: {} # partially exposes file.rename params when not symlinking disabled/enabled sites
      managed_opts: {} # partially exposes file.managed params for managed server files
      dir_opts: {} # partially exposes file.directory params for site available/enabled dirs

      # server declarations
      # servers will default to being placed in server_available
      managed:
        mysite: # relative pathname of the server file
          # may be True, False, or None where True is enabled, False, disabled, and None indicates no action
          enabled: True
          # Remove the site config file. Nice to clean up the conf.d (or sites-available).
          # It also remove the symlink (if it is exists).
          # The site MUST be disabled before delete it (if not the nginx is not reloaded).
          deleted: True
          ###########
          ## Modify  'available_dir' AND 'enabled_dir' '/etc/nginx' location to alternative value.
          ###########
          available_dir: /etc/nginx/sites-available # an alternate directory (not sites-available) where this server may be found
          enabled_dir: /etc/nginx/sites-enabled # an alternate directory (not sites-enabled) where this server may be found
          disabled_name: mysite.aint_on # an alternative disabled name to be use when not symlinking
          overwrite: True # overwrite an existing server file or not

          # May be a list of config options or None, if None, no server file will be managed/templated
          # Take server directives as lists of dictionaries. If the dictionary value is another list of
          # dictionaries a block {} will be started with the dictionary key name
          config:
            - server:
              - server_name: localhost
              - listen:
                - 80
                - default_server
              - index:
                - index.html
                - index.htm
              - location ~ .htm:
                - try_files:
                  - $uri
                  - $uri/ =404
                - test: something else

          # The above outputs:
          # server {
          #    server_name localhost;
          #    listen 80 default_server;
          #    index index.html index.htm;
          #    location ~ .htm {
          #        try_files $uri $uri/ =404;
          #        test something else;
          #    }
          # }
        mysite2: # Using source_path options to upload the file instead of templating all the file
          enabled: True
          available_dir: /etc/nginx/sites-available
          enabled_dir: /etc/nginx/sites-enabled
          config:
            source_path: salt://path-to-site-file/mysite2

        # Below configuration becomes handy if you want to create custom configuration files
        # for example if you want to create /usr/local/etc/nginx/http_options.conf with
        # the following content:

        # sendfile on;
        # tcp_nopush on;
        # tcp_nodelay on;
        # send_iowait 12000;

        http_options.conf:
          enabled: True
          available_dir: /usr/local/etc/nginx
          enabled_dir: /usr/local/etc/nginx
          config:
            - sendfile: 'on'
            - tcp_nopush: 'on'
            - tcp_nodelay: 'on'
            - send_iowait: 12000

    certificates_path: '/etc/nginx/ssl'  # Use this if you need to deploy below certificates in a custom path.
    # If you're doing SSL termination, you can deploy certificates this way.
    # The private one(s) should go in a separate pillar file not in version
    # control (or use encrypted pillar data).
    certificates:
      'www.example.com':
        public_cert: |
          -----BEGIN CERTIFICATE-----
          (Your Primary SSL certificate: www.example.com.crt)
          -----END CERTIFICATE-----
          -----BEGIN CERTIFICATE-----
          (Your Intermediate certificate: ExampleCA.crt)
          -----END CERTIFICATE-----
          -----BEGIN CERTIFICATE-----
          (Your Root certificate: TrustedRoot.crt)
          -----END CERTIFICATE-----
        private_key: |
          -----BEGIN RSA PRIVATE KEY-----
          (Your Private Key: www.example.com.key)
          -----END RSA PRIVATE KEY-----

    dh_param:
      'mydhparam1.pem': |
        -----BEGIN DH PARAMETERS-----
        (Your custom DH prime)
        -----END DH PARAMETERS-----
      # or to generate one on-the-fly
      'mydhparam2.pem':
        keysize: 2048

    # Passenger configuration
    # Default passenger configuration is provided, and will be deployed in
    # /etc/nginx/conf.d/passenger.conf
    passenger:
      passenger_root: /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini
      passenger_ruby: /usr/bin/ruby
      passenger_instance_registry_dir: /var/run/passenger-instreg
