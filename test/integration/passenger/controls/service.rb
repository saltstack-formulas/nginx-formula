# frozen_string_literal: true

control 'Nginx service' do
  title 'should be running and enabled'

  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end
end

control 'Passenger module' do
  title 'should be running and enabled'

  describe 'Passenger engine' do
    it 'passenger-config should say configuration "looks good"' do
      expect(command(
        '/usr/bin/passenger-config validate-install --auto'
      ).stdout).to match(/looks good/)
    end

    it 'passenger-memory-stats should return Passenger stats' do
      expect(command('/usr/sbin/passenger-memory-stats').stdout).to match(
        %r{nginx: master process /usr/sbin/nginx.*Passenger watchdog.*Passenger core.*}m
      )
    end
  end
end
