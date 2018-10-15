actions :create
default_action :create if defined?(default_action)

resource_name :couchbase_bucket if respond_to?(:resource_name)
provides :couchbase_bucket if respond_to?(:provides)

attribute :database_path, :kind_of => String, :default => '/opt/couchbase/var/lib/couchbase/data'
attribute :index_path, :kind_of => String, :default => '/opt/couchbase/var/lib/couchbase/data'

attribute :username, :kind_of => String, :default => "Administrator"
attribute :password, :kind_of => String, :default => "password"
attribute :authtype, :kind_of => String, :default => "none"
attribute :saslpassword, :kind_of => String, :default => ""
attribute :proxy_port, :kind_of => Integer
attribute :bucket, :kind_of => String, :name_attribute => true
attribute :exists, :kind_of => [TrueClass, FalseClass], :required => true
attribute :flush_enabled, :kind_of => Integer
attribute :memory_quota_mb, :kind_of => Integer, :callbacks => {
  "must be at least 100" => lambda { |quota| quota >= 100 }
}
attribute :memory_quota_percent, :kind_of => Numeric, :callbacks => {
  "must be a positive number" => lambda { |percent| percent > 0.0 },
  "must be less than or equal to 1.0" => lambda { |percent| percent <= 1.0 }
}
attribute :replicas, :kind_of => [Integer, FalseClass], :default => 1, :callbacks => {
  "must be a non-negative integer" => lambda { |replicas| !replicas || replicas > -1 }
}
attribute :type, :kind_of => String, :default => "couchbase", :callbacks => {
  "must be either couchbase or memcached" => lambda { |type| %w(couchbase memcached).include? type }
}
