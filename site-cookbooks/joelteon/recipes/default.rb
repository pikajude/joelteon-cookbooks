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

site_root = "/vagrant"

execute "install necessary binaries" do
  command "cabal install yesod-bin happy --global"
  creates "/usr/local/bin/yesod"
  notifies :run, "execute[install site dependencies]"
end

execute "install site dependencies" do
  cwd site_root
  environment({
    "LD_LIBRARY_PATH" => "/usr/lib",
    "PKG_CONFIG_PATH" => "/usr/lib/pkgconfig"
  })
  command "cabal install --only-dependencies --force-reinstalls"
end

execute "build" do
  cwd site_root
  environment({
    "LD_LIBRARY_PATH" => "/usr/lib",
    "PKG_CONFIG_PATH" => "/usr/lib/pkgconfig"
  })
  command "cabal configure && cabal build"
end
