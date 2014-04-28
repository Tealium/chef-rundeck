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
