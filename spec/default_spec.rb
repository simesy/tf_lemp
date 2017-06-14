require 'spec_helper'

describe ec2('lil-web-asg') do
  it { should exist }
  it { should be_running }
  its(:instance_id) { should eq 'i-08e6fcc96c58f682d' }
  its(:image_id) { should eq 'ami-ba231ad9' }
  its(:private_dns_name) { should eq 'ip-172-31-27-9.ap-southeast-2.compute.internal' }
  its(:public_dns_name) { should eq 'ec2-13-54-103-36.ap-southeast-2.compute.amazonaws.com' }
  its(:instance_type) { should eq 't2.micro' }
  its(:private_ip_address) { should eq '172.31.27.9' }
  its(:public_ip_address) { should eq '13.54.103.36' }
  it { should have_security_group('lil-web-sg-default') }
  it { should belong_to_vpc('Initial Default VPC') }
  it { should belong_to_subnet('subnet-e02ab6b9') }
  it { should have_ebs('vol-047662e9afd986283') }
  it { should have_network_interface('eni-43a6141b') }
end
