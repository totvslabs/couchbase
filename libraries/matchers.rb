if defined?(ChefSpec)
  ChefSpec.define_matcher :couchbase_node
  ChefSpec.define_matcher :couchbase_settings
  ChefSpec.define_matcher :couchbase_cluster
  ChefSpec.define_matcher :couchbase_bucket

  def modify_couchbase_node(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:couchbase_node, :modify, resource_name)
  end
  def modify_couchbase_node(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:couchbase_settings, :modify, resource_name)
  end
  def modify_couchbase_node(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:couchbase_cluster, :create_if_missing, resource_name)
  end
  def modify_couchbase_node(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:couchbase_bucket, :create, resource_name)
  end
end
