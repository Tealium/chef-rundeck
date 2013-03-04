#
# Cookbook Name:: chef-rundeck
# Recipe:: aws_plugin
#
# Copyright 2012, Jen Frisk <jennifer.frisk@tealium.com>
#
#
#Add the ec2 plugin jar file to the libtxt folder and the restarting 
	cookbook_file "/var/lib/rundeck/libext/rundeck-ec2-nodes-plugin-1.3.jar" do
		source 'rundeck-ec2-nodes-plugin-1.3.jar'
		owner 'rundeck'
		group 'rundeck'
		mode 00644
		action :create
		notifies :restart, "service[rundeckd]"		
	end