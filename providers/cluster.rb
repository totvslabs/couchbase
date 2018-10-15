include Couchbase::Client
include Couchbase::ClusterData

provides :couchbase_cluster if respond_to?(:provides)
# use_inline_resources if defined?(use_inline_resources)

action :create_if_missing do
  load_current_resource
  unless @current_resource.exists
    post "/pools/default", "memoryQuota" => @new_resource.memory_quota_mb
    post "/pools/default", "indexMemoryQuota" => @new_resource.index_quota_mb
    Chef::Log.info "#{new_resource} created"
  end
end

private
def load_current_resource
  @current_resource = Chef::ResourceResolver.resolve(:couchbase_cluster).new(@new_resource.name)
  @current_resource.cluster @new_resource.cluster
  @current_resource.exists !!pool_data
  @current_resource.memory_quota_mb pool_memory_quota_mb if @current_resource.exists
  @current_resource.index_quota_mb pool_index_quota_mb if @current_resource.exists
end
