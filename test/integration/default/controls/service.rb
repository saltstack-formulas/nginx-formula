# frozen_string_literal: true

control 'Nginx service' do
  title 'should be running and enabled'

  describe service('nginx') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
