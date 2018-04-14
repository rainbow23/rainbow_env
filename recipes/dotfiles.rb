data_bag('users').each do |id|
    u = data_bag_item('users', id)
    dot_files_path = '/home/' + u['id'] + '/dotfiles'

    git dot_files_path do
      repository 'https://github.com/rainbow23/dotfiles.git'
      revision 'master'
      user u['id']
      group 'wheel'
      action :sync
      notifies :run, "bash[dotfiles_permission]"
    end

    bash "dotfiles_permission" do
        cwd ::Dir.home(u['id'])
        code <<-EOH
        chmod 755 -R ./dotfiles
        EOH
    end

    # シンボリックリンクを作成
    %w{vim vimrc bashrc tmux.conf zshrc}.each do |symlink|
        link '/home/' + u['id'] + '/.' + symlink do
            owner u['id']
            group 'wheel'
            mode '0755'
            if symlink == 'vim'
                to dot_files_path + '/vimrepos'
            else
                to dot_files_path + '/_' + symlink
            end
        end
    end

    vimplug_path = ::Dir.home(u['id']) + '/.vim/autoload/plug.vim'

    bash 'install_vimplug' do
      environment ({ 'HOME' => ::Dir.home(u['id']), 'USER' => u['id']})
      code <<-EOH
      curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      EOH
      not_if { ::File.directory?(vimplug_path) }
    end
end
