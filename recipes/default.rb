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

# directory '/tmp/autojump' do
#   owner 'testchef'
#   group 'testchef'
#   mode '0777'
#   action :create
# end

git '/tmp/autojump' do
  repository 'https://github.com/wting/autojump.git'
  revision 'master'
  user "testchef"
  group "testchef"
  action :sync
end

bash 'install_autojump' do
  # user 'testchef'
  cwd '/tmp/autojump'
  code <<-EOH
  ./install.py
  EOH
end

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

