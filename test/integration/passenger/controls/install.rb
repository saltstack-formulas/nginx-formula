# frozen_string_literal: true

control 'Nginx package' do
  title 'should be installed'

  describe package('nginx') do
    it { should be_installed }
  end
end

control 'Passenger packages' do
  title 'should be installed'

  # Override by OS Family
  passenger_mod_pkg = case platform[:family]
                      when 'redhat', 'centos', 'fedora'
                        'nginx-mod-http-passenger'
                      when 'debian', 'ubuntu'
                        'libnginx-mod-http-passenger'
                      end

  describe package('passenger') do
    it { should be_installed }
  end
  describe package(passenger_mod_pkg) do
    it { should be_installed }
  end
end
