directory '/home/testchef/dotfiles' do
  owner 'testchef'
  group 'wheel'
  mode '0755'
  action :create
end

git '/home/testchef/dotfiles' do
  repository 'https://github.com/rainbow23/dotfiles.git'
  revision 'master'
  user "testchef"
  group "testchef"
  action :sync
end

# シンボリックリンクを作成
%w{vim vimrc bashrc tmux.conf zshrc}.each do |symlink|
    link '/home/testchef/.' + symlink do
        owner 'testchef'
        group 'wheel'
        mode '0755'
        if symlink == 'vim'
            to '/home/testchef/dotfiles/vimrepos'
        else
            to '/home/testchef/dotfiles/_' + symlink
        end
    end
end

# link '/home/testchef/vimrepos' do
#   owner 'testchef'
#   group 'wheel'
#   mode '0755'
#   to '/home/testchef/dotfiles/_vim'
# end


