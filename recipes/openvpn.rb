#
# Cookbook Name:: chef-rundeck
# Recipe:: aws_plugin
#
# Copyright 2012, Jason Bain <jason.bain@tealium.com>
#
#
#add the openvpn package in order to scritp vpn connections to VPCs.
package "openvpn" do
  action :install
end

directory "#{node[:rundeck][:home]}/.openvpn" do
    mode 0700
    owner node[:rundeck][:username]
    group node[:rundeck][:group]
  end

file "/etc/rundeck/ca.crt" do
   Chef::Log.info("The ca cert to use to connect to the access servers in qa")
   source 'ca.crt'
   mode 0600
   action :create
end

file "/etc/rundeck/rundeck.crt" do
   Chef::Log.info("The private cert for the rundeck user to use to connect to the access servers in qa")
   source 'rundeck.crt'
   mode 0600
   action :create
end

file "/etc/rundeck/rundeck.key" do
   Chef::Log.info("The private key to use to connect to the access servers in qa")
   source 'rundeck.key'
   mode 0600
   action :create
end

