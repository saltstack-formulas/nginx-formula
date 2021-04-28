# frozen_string_literal: true

# Set defaults, use debian as base

# Override by platform family
server_available, server_enabled =
  case platform[:family]
  when 'redhat', 'fedora'
    %w[/etc/nginx/conf.d /etc/nginx/conf.d]
  when 'suse'
    %w[/etc/nginx/vhosts.d /etc/nginx/vhosts.d]
  when 'bsd'
    %w[/usr/local/etc/nginx/sites-available /usr/local/etc/nginx/sites-enabled]
  else
    %w[/etc/nginx/sites-available /etc/nginx/sites-enabled]
  end

nginx_conf, snippets_letsencrypt_conf, file_owner, file_group =
  case platform[:family]
  when 'bsd'
    %w[/usr/local/etc/nginx/nginx.conf /usr/local/etc/nginx/snippets/letsencrypt.conf
       root wheel]
  else
    %w[/etc/nginx/nginx.conf /etc/nginx/snippets/letsencrypt.conf root root]
  end

control 'Nginx configuration' do
  title 'should match desired lines'

  # main configuration
  describe file(nginx_conf) do
    it { should be_file }
    it { should be_owned_by file_owner }
    it { should be_grouped_into file_group }
    its('mode') { should cmp '0644' }
    its('content') do
      # rubocop:disable Metrics/LineLength
      should include %(    log_format main '$remote_addr - $remote_user [$time_local] $status '
                    '"$request" $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';)
      # rubocop:enable Metrics/LineLength
    end
  end

  # snippets configuration
  describe file(snippets_letsencrypt_conf) do
    it { should be_file }
    it { should be_owned_by file_owner }
    it { should be_grouped_into file_group }
    its('mode') { should cmp '0644' }
    its('content') { should include 'location ^~ /.well-known/acme-challenge/ {' }
    its('content') { should include 'proxy_pass http://localhost:9999;' }
    its('content') { should include '{' }
  end

  # sites configuration
  [server_available, server_enabled].each do |dir|
    describe file "#{dir}/default" do
      it { should_not exist }
    end

    describe file "#{dir}/mysite" do
      it { should be_file }
      it { should be_owned_by file_owner }
      it { should be_grouped_into file_group }
      its('mode') { should cmp '0644' }
      its('content') { should include 'server_name localhost;' }
      its('content') { should include 'listen 80 default_server;' }
      its('content') { should include 'index index.html index.htm;' }
      its('content') { should include 'location ~ .htm {' }
      its('content') { should include 'try_files $uri $uri/ =404;' }
      its('content') { should include 'include snippets/letsencrypt.conf;' }
    end
    describe file "#{dir}/mysite_with_require" do
      it { should be_file }
      it { should be_owned_by file_owner }
      it { should be_grouped_into file_group }
      its('mode') { should cmp '0644' }
      its('content') { should include 'server_name with-deps;' }
      its('content') { should include 'listen 80;' }
      its('content') { should include 'index index.html index.htm;' }
      its('content') { should include 'location ~ .htm {' }
      its('content') { should include 'try_files $uri $uri/ =404;' }
    end
  end
end
