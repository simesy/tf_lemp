require 'spec_helper'
require 'net/http'
require 'uri'

# These variables match test.tfvar. Couldn't load them directly without Go/Ruby inconsistency.
identifier     = "green"
remote_access  = "true"
aws_size       = "t2.micro"

first_instance = `cd .. && terraform output elb.instances.first`
vpc_id = `cd .. && terraform output vpc.id`
db_sng_id = `cd .. && terraform output db_sng.id`
dns_name = `cd .. && terraform output elb.dns_name`

# Test the ASG
describe autoscaling_group("#{identifier}-web-asg") do
  it { should exist }
  its(:desired_capacity) { should eq 1 }
  its(:min_size) { should eq 1 }
  its(:max_size) { should eq 2 }
  its(:health_check_type) { should eq 'EC2' }
end

# Test one of the instances in the ASG.
describe ec2("#{first_instance.strip}") do
  it { should exist }
  it { should be_running }
  its(:instance_type) { should eq "#{aws_size}"}
  it { should have_security_group("#{identifier}-web-sg") }
end

# Database.
describe rds("#{identifier}-rds") do
  it { should exist }
  it { should be_available }
  it { should_not be_maintenance }
  its(:db_instance_class) { should eq 'db.t2.micro' }
  it { should have_security_group("#{identifier}-web-sg") }
  it { should belong_to_vpc("#{vpc_id.strip}") }
  it { should belong_to_db_subnet_group("#{db_sng_id.strip}") }
end

# Test the contents of the static web page.
web_output = Net::HTTP.get(URI.parse("http://#{dns_name.strip}"))
describe "Static web test" do
  it "The website should say Hello World" do
    expect(web_output).to eq("Hello World")
  end
end

# Test the database connection.
web_output_db = Net::HTTP.get(URI.parse("http://#{dns_name.strip}/db-test.php"))
describe "DB connection test" do
  it "The website should say Hello World" do
    expect(web_output_db).to eq("Hello World")
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
