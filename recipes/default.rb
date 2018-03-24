#
# Cookbook Name:: learn_chef_httpd
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

group 'testchef' do
  group_name 'testchef'
  gid        403
  action     [:create]
end

user 'testchef' do
  comment  'testchef'
  uid      403
  group    'testchef'
  home     '/home/testchef'
  shell    '/bin/bash'
  system true
  password nil
  manage_home true
  # action   [:create, :manage]
  action   [:create]
end

# user node['deploy_user'] do
#   action :create
#   comment 'Application deploy user'
#   home "/home/#{node['deploy_user']}"
#   shell '/bin/bash'
#   system true
#   manage_home true
# end

directory '/home/testchef/mysources' do
  owner 'testchef'
  group 'testchef'
  mode '0755'
  action :create
end

# git '/home/testchef/mysources' do
#   repository 'https://github.com/wting/autojump.git'
#   revision 'master'
#   action :sync
# end

# bash 'install_autojump' do
#   user 'testchef'
#   cwd '/tmp/mysources/autojump'
#   code <<-EOH
#   bash
#   ./install.py
#   EOH
# end

# git '/home/testchef' do
#   repository 'https://github.com/testchef/dotfiles.git'
#   revision 'master'
#   action :sync
# end

# # シンボリックリンクを作成
# link '/home/testchef/_vimrc' do
#   to '/home/testchef/.vimrc'
# end

# link '/home/testchef/vimrepos' do
#   to '/home/testchef/_.vim'
# end

# link '/home/testchef/_tmux.conf' do
#   to '/home/testchef/.tmux.conf'
# end

# link '/home/testchef/_zshrc' do
#  to '/home/testchef/.zshrc'
# end

