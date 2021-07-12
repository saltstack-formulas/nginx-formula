# frozen_string_literal: true

# Set defaults, use debian as base

# Override by OS Family
case platform[:family]
when 'redhat', 'centos', 'fedora'
  server_available = '/etc/nginx/conf.d'
  server_enabled   = '/etc/nginx/conf.d'
  passenger_mod = '/usr/lib64/nginx/modules/ngx_http_passenger_module.so'
  passenger_root = '/usr/share/ruby/vendor_ruby/phusion_passenger/locations.ini'
  passenger_config_file = '/etc/nginx/conf.d/passenger.conf'
  should_not_exist_file = '/etc/nginx/conf.d/mod-http-passenger.conf'
when 'debian', 'ubuntu'
  server_available = '/etc/nginx/sites-available'
  server_enabled   = '/etc/nginx/sites-enabled'
  passenger_mod = '/usr/lib/nginx/modules/ngx_http_passenger_module.so'
  passenger_root = '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini'
  passenger_config_file = '/etc/nginx/conf.d/mod-http-passenger.conf'
  should_not_exist_file = '/etc/nginx/conf.d/passenger.conf'
end

control 'Passenger configuration' do
  title 'should match desired lines'

  # main configuration
  describe file('/etc/nginx/nginx.conf') do
    its('content') { should include "load_module #{passenger_mod}" }
  end

  describe file(passenger_config_file) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include "passenger_root #{passenger_root};" }
    its('content') { should include 'passenger_ruby /usr/bin/ruby;' }
  end

  describe file(should_not_exist_file) do
    it { should_not exist }
  end

  # sites configuration
  [server_available, server_enabled].each do |dir|
    describe file "#{dir}/default" do
      it { should_not exist }
    end

    describe file "#{dir}/mysite" do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its('mode') { should cmp '0644' }
      its('content') { should include 'passenger_enabled on;' }
    end
  end
end
