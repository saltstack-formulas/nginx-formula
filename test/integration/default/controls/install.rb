# frozen_string_literal: true

control 'Nginx package' do
  title 'should be installed'

  describe package('nginx') do
    it { should be_installed }
  end
end
