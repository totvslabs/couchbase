#
# Cookbook Name:: couchbase
# Recipe:: default
#
# Copyright 2012, getaroom
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
#

# install missing packages
%w{wget gnupg2 python-httplib2}.each do |x|
  package x do
    action :install
    options "--force-yes"
  end
end

cookbook_file '/etc/apt/sources.list.d/couchbase.list' do
  source "repo/ubuntu_couchbase.list"
  mode 0644
  notifies :run, "execute[apt-key couchbase]", :immediately
end

execute "apt-key couchbase" do # ~FC041
  command "wget -O- https://packages.couchbase.com/ubuntu/couchbase.key | apt-key add -"
  action :nothing
end

# Update system
execute "apt-get update" do
  command "apt-get update"
  action :run
end
