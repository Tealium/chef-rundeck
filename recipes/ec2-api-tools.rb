#
# Cookbook Name:: chef-rundeck
# Recipe:: ec2-api-tools
#
# Copyright 2012, Jen Frisk <jennifer.frisk@tealium.com>
#
#
#install the ec2 api command line tools

cookbook_file "/tmp/ec2-api-tools.tgz/" do
		source 'ec2-api-tools.tgz'
		owner 'rundeck'
		group 'rundeck'
		mode 0777
		action :create
	end

bash "installing ec2-api-tools" do
  user "root"
  cwd "/tmp"
  code <<-BASH_SCRIPT
  tar cvzf ec2-api-tools.tgz
  mv ec2-api-tools #{node[:rundeck][:home]}/var/
  BASH_SCRIPT
  not_if do
    File.exists?("#{node[:rundeck][:home]}/var/ec2-api-tools")
  end
end
