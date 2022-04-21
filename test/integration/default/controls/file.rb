# frozen_string_literal: true

control 'Dependency test file' do
  title 'should exist'

  describe file('/tmp/created_to_test_dependencies') do
    it { should be_file }
  end
end
