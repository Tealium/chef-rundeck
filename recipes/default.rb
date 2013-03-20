#
# Cookbook Name:: chef-rundeck
# Recipe:: default
#
# Copyright 2012, Panagiotis Papadomitsos <pj@ezgr.net>
#

	remote_file "#{Chef::Config['file_cache_path']}/rundeck-#{node['rundeck']['version']}.deb" do
		owner 'root'
		group 'root'
		mode '0644'
		source node['rundeck']['deb_url']
		checksum node['rundeck']['deb_checksum']
		action :create_if_missing
	end

	dpkg_package "#{Chef::Config['file_cache_path']}/rundeck-#{node['rundeck']['version']}.deb" do
		action :install
		#notifies :delete, 'file[/etc/rundeck/realm.properties]'
	end

	# Erase the default realm.properties after package install, we manage that
	file "/etc/rundeck/realm.properties" do
		action :nothing
	end

	#adminobj = data_bag_item(node['rundeck']['admin']['data_bag'], node['rundeck']['admin']['data_bag_id'])

#	unless Chef::Config['solo']
		#recipients = search(node['rundeck']['mail']['recipients_data_bag'],node['rundeck']['mail']['recipients_query']).
		#map {|u| u[node['rundeck']['mail']['recipients_field']] }.
		#join(',') rescue []
	#else
		recipients = 'root'
	#end

	# Configuration properties
	template '/etc/rundeck/framework.properties' do
		source 'framework.properties.erb'
		owner 'rundeck'
		group 'rundeck'
		mode 00644
		variables({
			:admin_user => node['username'],
			:admin_pass => node['password'],
			:recipients => recipients
		})
		notifies :restart, "service[rundeckd]"
	end

	template '/etc/rundeck/project.properties' do
		source 'project.properties.erb'
		owner 'rundeck'
		group 'rundeck'
		mode 00644
		variables({ :recipients => recipients })
		notifies :restart, "service[rundeckd]"
	end

	# Featuring Java optimizations
	cookbook_file "/etc/rundeck/profile" do
		source 'profile'
		owner 'rundeck'
		group 'rundeck'
		mode 00644
		action :create
		notifies :restart, "service[rundeckd]"		
	end

	cookbook_file "/etc/rundeck/realm.properties" do
		source 'realm.properties'
		owner 'rundeck'
		group 'rundeck'
		mode 00644
		action :create
	end

		cookbook_file "/etc/rundeck/admin.aclpolicy" do
		source 'admin.aclpolicy'
		owner 'rundeck'
		group 'rundeck'
		mode 00644
		action :create
	end
	
	#rundeck_user adminobj['username'] do
	#	password adminobj['password']
	#	encryption 'md5'
	#	roles %w{ user admin architect deploy build }
	#	action :create
	#end

	#cookbook_file '/etc/logrotate.d/rundeck' do
#		source 'rundeck.logrotate'
#		owner 'root'
#		group 'root'
#		mode 00644
	#end
	
	# SSH private key. Stored in the data bag item as an array
	#unless adminobj['ssh_key'].nil? || adminobj['ssh_key'].empty?
#
	 pkey = "#{node[:rundeck][:home]}/.ssh/id_rsa"

	 Chef::Log.info("Creating the Git Key on Rundeck")
   rundeck_keys = search(:rundeck_keys, "id:production").first

   
   node[:rundeck][:public_key] = rundeck_keys["public_key"] 
   node[:rundeck][:private_key] = rundeck_keys["private_key"]

  directory "#{node[:rundeck][:home]}/.ssh" do
    mode 0700
    owner node[:rundeck][:username]
    group node[:rundeck][:group]
  end

   file "#{node[:rundeck][:home]}/.ssh/id_rsa" do
      Chef::Log.info("The pem_key is: #{node[:rundeck][:private_key]} and the owner should be #{node[:rundeck][:username]}")
      content node[:rundeck][:private_key]
      owner node[:rundeck][:username]
      group node[:rundeck][:group]
      mode 0600
   end

   file "#{node[:rundeck][:home]}/.ssh/id_rsa.pub" do
      Chef::Log.info("The public_key is: #{node[:rundeck][:public_key]}")
      content node[:rundeck][:public_key]
      owner node[:rundeck][:username]
      group node[:rundeck][:group]
      mode 0644
   end

   ruby_block "store rundeck ssh pubkey" do
     block do
       node.set[:rundeck][:pubkey] = File.open("#{pkey}.pub") { |f| f.gets }
     end
   end

   file "#{node[:rundeck][:home]}/.ssh/authorized_keys" do
     action :create
     mode 0600
     owner node[:rundeck][:username]
     group node[:rundeck][:group]
     content node[:rundeck][:pubkey]
   end


	service 'rundeckd' do
		provider Chef::Provider::Service::Upstart if platform?('ubuntu') && node['platform_version'].to_f >= 12.04
		supports :status => true, :restart => true
		action [ :enable, :start ]
	end
