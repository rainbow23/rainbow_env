# Cookbook Name:: learn_chef_httpd
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

%w{git vim}.each do |pkg|
    package pkg do
        action :install
    end
end

data_bag('users').each do |id|
    u = data_bag_item('users', id)

    user u['id'] do
        shell    u['shell']
        uid       u['uid']
        gid       u['gid']
        password u['password']
        manage_home true
        action   [:nothing]
    end.run_action(:create)

    group 'wheel' do
      action  [:create]
      members u['id']
      append true
    end

    autojump_path = '/home/' + u['id'] + '/autojump'

    git autojump_path do
      repository 'https://github.com/wting/autojump.git'
      revision 'master'
      user u['id']
      group 'wheel'
      action :sync
    end

    bash 'install_autojump' do
      environment ({ 'HOME' => ::Dir.home(u['id']), 'USER' => u['id']})
      cwd autojump_path
      code <<-EOH
      ./install.py
      EOH
    end
end
