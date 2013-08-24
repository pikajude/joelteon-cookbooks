#
# Cookbook Name:: joelteon
# Recipe:: ghc
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "git::source"
include_recipe "yum::epel"

package 'autoconf'
package 'automake'
package 'gcc'
package 'glibc-devel'
package 'gmp-devel'
package 'libtool'
package 'make'
package 'ncurses-devel'
package 'perl'
package 'python'

remote_file "#{Chef::Config[:file_cache_path]}/justhub.rpm" do
  source "http://sherkin.justhub.org/el6/RPMS/x86_64/justhub-release-2.0-4.0.el6.x86_64.rpm"
end

package "justhub" do
  source "#{Chef::Config[:file_cache_path]}/justhub.rpm"
end

package "haskell"

git "#{Chef::Config[:file_cache_path]}/ghc" do
  repository "http://git.haskell.org/ghc.git"
  action :sync
end

execute "ghc sync-all" do
  command "./sync-all --testsuite get"
  cwd "#{Chef::Config[:file_cache_path]}/ghc"
end

execute "build ghc" do
  command %{
    perl boot &&
    ./configure &&
    make &&
    make install
  }
  environment({
    "LC_ALL" => "en_US.UTF-8"
  })
  cwd "#{Chef::Config[:file_cache_path]}/ghc"
  not_if '[[ -f LASTBUILD && "$(cat LASTBUILD)" == "$(date +%Y%m%d)" ]]'
end

execute "update last build date" do
  command "date +%Y%m%d > LASTBUILD"
  cwd "#{Chef::Config[:file_cache_path]}/ghc"
end

execute "add /usr/local/bin to PATH" do
  command "echo 'export PATH=/usr/local/bin:$PATH >> /etc/bashrc'"
  not_if "grep -q /usr/local/bin /etc/bashrc"
end

execute "get newest cabal" do
  command "cabal update && cabal install cabal-install"
end
