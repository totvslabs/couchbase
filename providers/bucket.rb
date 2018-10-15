include Couchbase::Client
include Couchbase::ClusterData

provides :couchbase_bucket if respond_to?(:provides)
# use_inline_resources if defined?(use_inline_resources)

action :create do
  load_current_resource
  if !@current_resource.exists
    create_bucket
  elsif @current_resource.memory_quota_mb != new_memory_quota_mb
    modify_bucket
  end
end

private
def load_current_resource
  @current_resource = Chef::ResourceResolver.resolve(:couchbase_bucket).new(@new_resource.name)
  @current_resource.bucket @new_resource.bucket
  @current_resource.proxy_port @new_resource.proxy_port
  @current_resource.exists !!bucket_data

  if @current_resource.exists
    @current_resource.type bucket_type
    @current_resource.memory_quota_mb bucket_memory_quota_mb
    @current_resource.replicas bucket_replicas
    @current_resource.proxy_port proxy_port
  end
end

private
def create_bucket
  post "/pools/default/buckets", create_params
  Chef::Log.info "#{new_resource} created"
end

private
def modify_bucket
  post "/pools/default/buckets/#{new_resource.bucket}", modify_params
  Chef::Log.info "#{new_resource} memory_quota_mb changed to #{new_memory_quota_mb}"
end

private
def create_params
  {
    "authType" => new_resource.authtype || "none",
    "saslPassword" =>  new_resource.saslpassword || "",
    "bucketType" => new_api_type,
    "name" => new_resource.bucket,
    "ramQuotaMB" => new_memory_quota_mb,
    "proxyPort" => new_resource.proxy_port,
    "replicaNumber" => new_resource.replicas || 0,
    "flushEnabled" => new_resource.flush_enabled || 0,
  }
end

private
def new_api_type
  new_resource.type == "couchbase" ? "membase" : new_resource.type
end

private
def modify_params
  {
    "ramQuotaMB" => new_memory_quota_mb,
  }
end

private
def new_memory_quota_mb
  new_resource.memory_quota_mb || (new_resource.memory_quota_percent * pool_memory_quota_mb).to_i
end

private
def bucket_memory_quota_mb
  (bucket_data["quota"]["rawRAM"] / 1024 / 1024).to_i
end

private
def bucket_replicas
  bucket_data["replicaNumber"]
end

private
def proxy_port
  bucket_data["proxyPort"]
end

private
def bucket_type
  bucket_data["bucketType"] == "membase" ? "couchbase" : bucket_data["bucketType"]
end

private
def flush_enabled
  bucket_data["flush_enabled"]
end

private
def bucket_data
  return @bucket_data if instance_variable_defined? "@bucket_data"

  @bucket_data ||= begin
    response = get "/pools/default/buckets/#{new_resource.bucket}"
    response.error! unless response.kind_of?(Net::HTTPSuccess) || response.kind_of?(Net::HTTPNotFound)
    JSONCompat.from_json response.body if response.kind_of? Net::HTTPSuccess
  end
end
