#
# Cookbook Name:: joelteon
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "ghc"
include_recipe "postgres"
include_recipe "imagemagick"
include_recipe "joelteon::db"

site_root = "/vagrant"

env = {
  "LD_LIBRARY_PATH" => "/usr/lib",
  "PKG_CONFIG_PATH" => "/usr/lib/pkgconfig"
}

execute "add some envars to /etc/bashrc" do
  command %Q{
    echo 'export PATH=$PATH:/usr/local/bin
#{env.map{|k,v|"export %s=%s" % [k,v]}.join("\n")}' >> /etc/bashrc
  }
  not_if "grep -q PKG_CONFIG_PATH /etc/bashrc"
end

execute "install necessary binaries" do
  command "cabal install yesod-bin happy --global"
  environment env
  creates "/usr/local/bin/yesod"
end

execute "install site dependencies" do
  cwd site_root
  environment env
  command %Q{
    cabal configure
    cabal install --only-dependencies --force-reinstalls
  }
end

execute "build" do
  cwd site_root
  environment env
  command "cabal build"
end
