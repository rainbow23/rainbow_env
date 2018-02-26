#
# Cookbook Name:: learn_chef_httpd
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
package 'httpd'

service 'httpd' do
    action [:enable, :start]
end

group 'rainbow'

user 'rainbow' do
    group  'rainbow'
    system true
    shell  '/bin/bash'
end

template '/var/www/html/index.html' do # ~FC033
    source 'index.html.erb'
    mode   '0644'
    owner  'rainbow'
    group  'rainbow'
end

git '/tmp/mysources' do
  repository 'git clone git://github.com/joelthelion/autojump.git'
  revision 'master'
  action :sync
end

bash 'install_something' do
  user 'root'
  cwd '/tmp/autojump'
  code <<-EOH
  bash
  ./install.py
  sed -i -e '$a[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh' /home/rainbow/.bashrc
  sed -i -e '$a[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh' /home/rainbow/.bash_profile
  EOH
end
