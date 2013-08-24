#
# Cookbook Name:: postgres
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

package "rpm"

pg_datadir = "/var/lib/pgsql/9.2/data"
pg_bin = "/usr/pgsql-9.2/bin"

execute "use postgres rpm distribution" do
  command "rpm -Uvh http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm"
  not_if "rpm -qa | grep pgdg-centos92"
end

package "postgresql92-devel"
package "postgresql92-server"

execute "update bashrc" do
  command %Q{
    echo 'export PATH=/usr/pgsql-9.2/bin:$PATH' >> /etc/bashrc
  }
  not_if "grep -q pgsql-9.2 /etc/bashrc"
end

execute "init the database" do
  command "#{pg_bin}/initdb -D #{pg_datadir}"
  user "postgres"
  creates "#{pg_datadir}/pg_hba.conf"
end

execute "rename pg_config" do
  command "ln -s /usr/pgsql-9.2/bin/pg_config /usr/bin/pgconfig"
  not_if { File.exists?("/usr/bin/pgconfig") }
end

execute "start the server" do
  command "/etc/init.d/postgresql-9.2 start"
  not_if "/etc/init.d/postgresql-9.2 status | grep -q running"
end
