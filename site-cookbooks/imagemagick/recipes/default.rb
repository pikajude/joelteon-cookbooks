#
# Cookbook Name:: imagemagick
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

package "libpng-devel"
package "freetype"

imagick_version = "6.8.6-3"
imagick_root = "/usr/imagick-#{imagick_version}"
imagick_src = "#{imagick_root}/src"
imagick_filename = "ImageMagick.tar.gz"
imagick_file = "#{imagick_src}/#{imagick_filename}"
imagick_install_path = "#{imagick_src}/ImageMagick-#{imagick_version}"

directory imagick_src do
  recursive true
  action :create
end

remote_file imagick_file do
  source 'http://www.imagemagick.org/download/ImageMagick.tar.gz'
  checksum "00e7ee13222f36897e24fac69630fe3d1b8050a4d462a496d51cc88e412e938f"
  action :create_if_missing
  notifies :run, "execute[unpack #{imagick_file}]"
end

execute "unpack #{imagick_file}" do
  command "mkdir -p #{imagick_install_path} && tar xzvf #{imagick_file} -C #{imagick_install_path} --strip-components 1"
  notifies :run, "execute[install ImageMagick]"
  creates imagick_install_path
end

execute "install ImageMagick" do
  command "./configure --prefix=/usr && make install"
  cwd imagick_install_path
  creates "/usr/bin/convert"
end
