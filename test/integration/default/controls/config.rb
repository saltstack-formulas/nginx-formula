control 'Nginx configuration' do
  title 'should match desired lines'

  describe file('/etc/nginx/nginx.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
  end
end
