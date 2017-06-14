require 'spec_helper'

# A simple test that assumes default values.
describe ec2('tflemp-web-asg') do
  it { should exist }
  it { should be_running }
  its(:instance_type) { should eq 't2.micro' }
  it { should have_security_group('tflemp-web-sg-default') }
end
