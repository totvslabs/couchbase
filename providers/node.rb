include Couchbase::Client
include Couchbase::ClusterData

provides :couchbase_node if respond_to?(:provides)
# use_inline_resources if defined?(use_inline_resources)

action :modify do
  load_current_resource
  if @current_resource.database_path != @new_resource.database_path
    post "/nodes/#{new_resource.id}/controller/settings", "path" => @new_resource.database_path
    Chef::Log.info "#{new_resource} modified"
  end
  if @current_resource.index_path != @new_resource.index_path
    post "/nodes/#{new_resource.id}/controller/settings", "index_path" => @new_resource.index_path
    Chef::Log.info "#{new_resource} modified"
  end
  unless @current_resource.exists
    post "/node/controller/setupServices", setup_services
    Chef::Log.info "#{new_resource} modified"
  end
end

private
def load_current_resource
  @current_resource = Chef::ResourceResolver.resolve(:couchbase_node).new(@new_resource.name)
  @current_resource.id @new_resource.id
  @current_resource.database_path node_database_path
  @current_resource.index_path node_index_path
  @current_resource.exists !!pool_data
end

private
def setup_services
  {
    "services" => new_resource.services,
  }
end

private
def node_database_path
  node_data["storage"]["hdd"][0]["path"]
end

private
def node_index_path
  node_data["storage"]["hdd"][0]["index_path"]
end

private
def node_data
  @node_data ||= begin
    response = get "/nodes/#{new_resource.id}"
    Chef::Log.error response.body unless response.kind_of?(Net::HTTPSuccess) || response.body.empty?
    response.value
    JSONCompat.from_json response.body
  end
end
