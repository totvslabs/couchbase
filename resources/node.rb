actions :modify
default_action :modify if defined?(default_action)

resource_name :couchbase_node if respond_to?(:resource_name)
provides :couchbase_node if respond_to?(:provides)

attribute :username, :kind_of => String, :default => "Administrator"
attribute :password, :kind_of => String, :default => "password"
attribute :id, :kind_of => String, :name_attribute => true
attribute :exists, :kind_of => [TrueClass, FalseClass], :required => true
attribute :database_path, :kind_of => String, :default => '/opt/couchbase/var/lib/couchbase/data'
attribute :index_path, :kind_of => String, :default => '/opt/couchbase/var/lib/couchbase/data'
# "index" for index, "n1ql" for query, "kv" for data and "fts" for search
attribute :services, :kind_of => String, :default => "index,n1ql,kv,fts"
