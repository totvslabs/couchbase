include_recipe "couchbase::install"

service node['couchbase']['server']['service_name'] do
  action [:stop, :disable]
end
