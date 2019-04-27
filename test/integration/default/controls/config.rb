# Set defaults, use debian as base

server_available = '/etc/nginx/sites-available'
server_enabled	 = '/etc/nginx/sites-enabled'

# Override by OS
case os[:name]
when 'redhat', 'centos', 'fedora'
  server_available = '/etc/nginx/conf.d'
  server_enabled   = '/etc/nginx/conf.d'
when 'opensuse'
  server_available = '/etc/nginx/vhosts.d'
  server_enabled   = '/etc/nginx/vhosts.d'
end

control 'Nginx configuration' do
  title 'should match desired lines'

  # main configuration
  describe file('/etc/nginx/nginx.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include %Q[    log_format main '$remote_addr - $remote_user [$time_local] $status '
                    '"$request" $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';] }
  end

  # snippets configuration
  describe file('/etc/nginx/snippets/letsencrypt.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include 'location ^~ /.well-known/acme-challenge/ {' }
    its('content') { should include 'proxy_pass http://localhost:9999;' }
    its('content') { should include '{' }
  end

  # sites configuration
  [server_available, server_enabled].each do |dir|

    describe file ("#{dir}/default") do
     it { should_not exist }
    end

    describe file ("#{dir}/mysite") do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its('mode') { should cmp '0644' }
      its('content') { should include 'server_name localhost;' }
      its('content') { should include 'listen 80 default_server;' }
      its('content') { should include 'index index.html index.htm;' }
      its('content') { should include 'location ~ .htm {' }
      its('content') { should include 'try_files $uri $uri/ =404;' }
      its('content') { should include 'include snippets/letsencrypt.conf;' }
    end

  end
end
