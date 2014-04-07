#
# Cookbook Name:: aws-tools
# Recipe:: default
#

pkgs = value_for_platform(
    ["centos","redhat","fedora"] =>
        {"default" => %w{ }},
    [ "debian", "ubuntu" ] =>
        {"default" => %w{ ruby-dev libxslt-dev libxml2-dev rubygems}},
    "default" => %w{ }
  )

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

gem_package "aws-sdk"


