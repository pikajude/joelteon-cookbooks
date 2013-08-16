#
# Cookbook Name:: joelteon
# Recipe:: db
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

psql_user "joelteon" do
  host "localhost"
  password "joelteon"
  not_if "psql -U postgres -c '\\du' | grep -q joelteon"
end

psql_database "joelteon" do
  host "localhost"
  owner "joelteon"
  encoding "DEFAULT"
  not_if "psql -U postgres -c '\\list' | grep -q joelteon"
end
