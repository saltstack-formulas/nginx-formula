# frozen_string_literal: true

case platform.family
when 'redhat'
  repo_file = '/etc/yum.repos.d/passenger.repo'
  repo_url = 'https://oss-binaries.phusionpassenger.com/yum/passenger/el/$releasever/$basearch'
when 'debian'
  # Inspec does not provide a `codename` matcher, so we add ours
  finger_codename = {
    'ubuntu-18.04' => 'bionic',
    'ubuntu-20.04' => 'focal',
    'debian-9' => 'stretch',
    'debian-10' => 'buster',
    'debian-11' => 'bullseye'
  }
  codename = finger_codename[system.platform[:finger]]

  repo_keyring = '/usr/share/keyrings/phusionpassenger-archive-keyring.gpg'
  repo_file = "/etc/apt/sources.list.d/phusionpassenger-official-#{codename}.list"
  # rubocop:disable Metrics/LineLength
  repo_url = "deb [signed-by=#{repo_keyring}] https://oss-binaries.phusionpassenger.com/apt/passenger #{codename} main"
  # rubocop:enable Metrics/LineLength
end

control 'Phusion-passenger repository keyring' do
  title 'should be installed'

  only_if('Requirement for Debian family') do
    os.debian?
  end

  describe file(repo_keyring) do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
  end
end

control 'Phusion-passenger repository' do
  impact 1
  title 'should be configured'
  describe file(repo_file) do
    its('content') { should include repo_url }
  end
end
