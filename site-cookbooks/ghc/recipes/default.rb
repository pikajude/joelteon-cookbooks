#
# Cookbook Name:: joelteon
# Recipe:: ghc
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'gmp-devel'

ghc_version = '7.6.3'
root = "/usr/ghc-#{ghc_version}"
ghc_src_prefix = "#{root}/src"
ghc_filename = "ghc-#{ghc_version}-x86_64-unknown-linux.tar.bz2"
ghc_install_path = "#{ghc_src_prefix}/ghc-#{ghc_version}"
ghc_file = "#{ghc_src_prefix}/#{ghc_filename}"
ghc_prefix = root

directory ghc_src_prefix do
  recursive true
  action :create
end

remote_file ghc_file do
  source "http://10.0.0.1:8080/ghc-7.6.3-x86_64-unknown-linux.tar.bz2"
  checksum '398dd5fa6ed479c075ef9f638ef4fc2cc0fbf994e1b59b54d77c26a8e1e73ca0'
  action :create_if_missing
end

execute "unpack #{ghc_file}" do
  command %Q{
    mkdir -p #{ghc_install_path} &&
    tar xjvf #{ghc_file} -C #{ghc_install_path} --strip-components 1
  }
  creates ghc_install_path
end

execute "install ghc" do
  command "./configure --prefix=/usr && make install"
  cwd ghc_install_path
  creates "/usr/bin/ghc"
end


cabal_version = '1.16.0.2'
cabal_root = "/usr/cabal-#{cabal_version}"
cabal_src_prefix = "#{cabal_root}/src"
cabal_filename = "cabal-install-#{cabal_version}.tar.gz"
cabal_install_path = "#{cabal_src_prefix}/cabal-#{cabal_version}"
cabal_file = "#{cabal_src_prefix}/#{cabal_filename}"
cabal_prefix = cabal_root

directory cabal_src_prefix do
  recursive true
  action :create
end

remote_file cabal_file do
  source "http://hackage.haskell.org/packages/archive/cabal-install/#{cabal_version}/#{cabal_filename}"
  checksum '66dfacc9f33e668e56904072cadb8a36bd9d6522ba5464c6a36a5de7e65c5698'
  action :create_if_missing
end

execute "unpack #{cabal_file}" do
  command %Q{
    mkdir -p #{cabal_install_path} &&
    tar xzvf #{cabal_file} -C #{cabal_install_path} --strip-components 1
  }
  creates cabal_install_path
end

execute "install cabal" do
  command "sh bootstrap.sh --global"
  cwd cabal_install_path
  creates "/usr/local/bin/cabal"
end

execute "symlink cabal" do
  command "ln -s /usr/local/bin/cabal /usr/bin/cabal"
  creates "/usr/bin/cabal"
end

execute "update cabal package list" do
  command "cabal update"
  creates "/root/.cabal/packages/hackage.haskell.org"
end
