include_recipe "couchbase::dependencies"

remote_file File.join(Chef::Config[:file_cache_path], node['couchbase']['server']['package_file']) do
  source node['couchbase']['server']['package_full_url']
  action :create_if_missing
end

dpkg_package File.join(Chef::Config[:file_cache_path], node['couchbase']['server']['package_file']) do
  action :install
  not_if "dpkg -l couchbase-server-#{node['couchbase']['server']['edition'] } | grep -E '^ii'"
end

service node['couchbase']['server']['service_name'] do
  action [:stop, :disable]
end
