include_recipe "vim::source"
include_recipe "tmux"

%w{git}.each do |pkg|
    package pkg do
        action :install
    end
end

data_bag('users').each do |id|
    u = data_bag_item('users', id)

    user u['id'] do
        shell    u['shell']
        uid      u['uid']
        gid      u['gid']
        password u['password']
        manage_home true
        action   [:nothing]
    end.run_action(:create)

    group 'wheel' do
      action  [:create]
      members u['id']
      append true
    end

    bash 'set_defalut_shell_to_zsh' do
      cwd ::Dir.home(u['id'])
      code <<-EOH
        chsh -s /bin/zsh
      EOH
    end

    autojump_path = '/home/' + u['id'] + '/autojump'
    git autojump_path do
      repository 'https://github.com/wting/autojump.git'
      revision   'master'
      user       u['id']
      group      'wheel'
      action     :sync
      notifies :run, "bash[install_autojump]"
      not_if { ::File.directory?(autojump_path) }
    end

    bash 'install_autojump' do
      environment ({ 'HOME' => ::Dir.home(u['id']), 'USER' => u['id']})
      cwd autojump_path
      code <<-EOH
      ./install.py
      EOH
    end

    tmux_plugin_manager_path = ::Dir.home(u['id']) + '/.tmux/plugins/tpm'
    bash 'install_tmux_plugin_manager' do
      environment ({ 'HOME' => ::Dir.home(u['id']), 'USER' => u['id']})
      cwd ::Dir.home(u['id'])
      code <<-EOH
      git clone https://github.com/tmux-plugins/tpm #{tmux_plugin_manager_path}
      EOH
      not_if { ::File.directory?(tmux_plugin_manager_path) }
    end
end
