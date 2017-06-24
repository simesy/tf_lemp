require 'spec_helper'
require 'net/http'
require 'uri'

# These variables match test.tfvar. Couldn't load them directly without Go/Ruby inconsistency.
identifier     = "green"
remote_access  = "true"
aws_size       = "t2.micro"
public_key     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMJssVcx80Qjb500UxUbfkWFG6GV6n1t2zHEXoszFDjdNGSnU+bgAYby6nNMgr4prPsP8OGnvm9aox5SKruijp69+IyD0dcMbZZZEQ07aQU1pY9/iuMTfbAElrN620KEPFUfXJoNbsEbiGZCYzHifPnZsiYhexqcO8tkODIPRdPcZeqKnFGs1D3T2kuu+6edm0DqEBsQ7wSjG1XSGRRN0u/3x4/fV7rB9NQcuAIoy9rV5CUAFjeG0TZ/Pe1U7kjikrwE8UtBL8e28YOvRaIYrpQYCiak7ZRsZYaXs7Q76nxg6e0u7X3a6Hxj6BLd548h0MA+EXMahNz+ISVCoro/n1Wgbb87xy9XnpZjMvuoOGvq6ClZ9EiznNEbCRijphoZ/HCyTTxGny9wiWc0XxrqanwL2Sg7RQUReDaY6J9rPmMTR6AUh5IWggmtm15mYTHcgY7aEVYPnkTCMEJ8u8umCSg9No+LkjzjjD9Gfg8f9taCZivNFWYDm4QG756jBVybdBgMa91ROmWZxdQA3V8iyGD4SowHXa22pMp95JFFE/GVb/wPjbS1z+huek4frl13CFKpJI668F6ZxZZEOEQ/mk7j9QNzI4Lo09HTE40vtPIDTTuJ9qXYnGJx2ZHAr3RUDzscJ/nQsdaXii4FGQRnCIw2tNP/vbUqRrIfEixJUcPQ== insecure@example.com"

# Test the ASG
describe autoscaling_group("#{identifier}-web-asg") do
  it { should exist }
  its(:desired_capacity) { should eq 1 }
  its(:min_size) { should eq 1 }
  its(:max_size) { should eq 2 }
  its(:health_check_type) { should eq 'EC2' }
end

# Test one of the instances in the ASG.
first_instance = `cd .. && terraform output elb.instances.first`
describe ec2("#{first_instance.strip}") do
  it { should exist }
  it { should be_running }
  its(:instance_type) { should eq "#{aws_size}"}
  it { should have_security_group("#{identifier}-web-sg") }
end

# Test the contents of the web page.
dns_name = `cd .. && terraform output elb.dns_name`
print dns_name
web_output = Net::HTTP.get(URI.parse("http://#{dns_name.strip}"))
describe "Web output" do
  it "The website should say Hello World" do
    expect(web_output).to eq("Hello World")
  end
end

# Test SSH
instance_ip = `aws ec2 describe-instances --instance-ids #{first_instance.strip} | grep PublicIpAddress | awk -F ":" '{print $2}' | sed 's/[",]//g'`
ssh_command = "ssh -i ./spec/insecure_key -o StrictHostKeyChecking=no admin@#{instance_ip.strip} exit && echo \$?"
ssh_status = `#{ssh_command}`
describe "SSH status" do
  it "SSH should return non-error response" do
    expect(ssh_status.strip).to eq("0")
  end
end
