# Cookbook Name:: db_mysql
# Recipe:: do_symlink_datadir
#
# Copyright (c) 2011 RightScale Inc
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# == Configure system for MySQL
#

service "mysql" do
  action :nothing
end

ruby_block "Delete default datafiles, symlink storage to default datadir" do
  not_if do ::File.symlink?(node[:db_mysql][:datadir]) end
  block do
    require 'fileutils'
    FileUtils.rm_rf(node[:db_mysql][:datadir])
    File.symlink(node[:db_mysql][:datadir_relocate], node[:db_mysql][:datadir])
    FileUtils.chown_R("mysql", "mysql", "#{node[:db_mysql][:datadir_relocate]}")
  end
  notifies :start, "service[mysql]"
end

