actions :create_if_missing
default_action :create_if_missing if defined?(default_action)

resource_name :couchbase_cluster if respond_to?(:resource_name)
provides :couchbase_cluster if respond_to?(:provides)

attribute :database_path, :kind_of => String, :default => '/opt/couchbase/var/lib/couchbase/data'
attribute :index_path, :kind_of => String, :default => '/opt/couchbase/var/lib/couchbase/data'

attribute :username, :kind_of => String, :default => "Administrator"
attribute :password, :kind_of => String, :default => "password"
attribute :cluster, :kind_of => String, :name_attribute => true
attribute :exists, :kind_of => [TrueClass, FalseClass], :required => true
attribute :memory_quota_mb, :kind_of => Integer, :required => true, :callbacks => {
  "must be at least 256" => lambda { |quota| quota >= 256 }
}
attribute :index_quota_mb, :kind_of => Integer, :required => true, :callbacks => {
  "must be at least 256" => lambda { |quota| quota >= 256 }
}
