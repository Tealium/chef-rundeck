#
# Cookbook Name:: chef-rundeck
# Recipe:: aws_plugin
#
# Copyright 2012, Jen Frisk <jennifer.frisk@tealium.com>
#
#
#package "rubygems1.9" do
#  action :install
#end


#need to install the latest gems globally andcally.

%w(
ohai
chef 
knife-ec2 
aws-sdk
).each do |pak|
    rvm_gem pak do 
       action :install 
    end
    rvm_global_gem pak do 
       action :install 
    end
end