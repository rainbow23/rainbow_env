# Cookbook Name:: learn_chef_httpd
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
%w{git vim}.each do |pkg|
    package pkg do
        action :install
    end
end

user 'testchef' do
  home     '/home/testchef'
  shell    '/bin/bash'
  password "$1$/xCc5j.9$BWyiV6YAKSdfWS43G1gwB1"
  manage_home true
  action   [:create]
end

group 'wheel' do
  action  [:create]
  members ["testchef"]
  append true
end

directory '/tmp/autojump' do
  owner 'testchef'
  group 'wheel'
  mode '0777'
  action :create
end

git '/tmp/autojump' do
  repository 'https://github.com/wting/autojump.git'
  revision 'master'
  user "testchef"
  group "wheel"
  action :sync
end

bash 'install_autojump' do
  # user 'testchef'
  cwd '/tmp/autojump'
  code <<-EOH
  ./install.py
  EOH
end
