actions :modify
default_action :modify if defined?(default_action)

resource_name :couchbase_settings if respond_to?(:resource_name)
provides :couchbase_settings if respond_to?(:provides)

attribute :username, :kind_of => String, :default => "Administrator"
attribute :password, :kind_of => String, :default => "password"
attribute :group, :kind_of => String, :name_attribute => true
attribute :settings, :kind_of => Hash, :required => true
