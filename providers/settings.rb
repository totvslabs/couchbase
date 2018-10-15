provides :couchbase_settings if respond_to?(:provides)
# use_inline_resources if defined?(use_inline_resources)

include Couchbase::Client

action :modify do
  unless settings_match?
    post "/settings/#{new_resource.group}", new_resource.settings
    Chef::Log.info "#{new_resource} modified"
  end
end

def load_current_resource
  @current_resource = Chef::ResourceResolver.resolve(:couchbase_settings).new(@new_resource.name)
  @current_resource.group @new_resource.group
  @current_resource.settings settings_data
end

def settings_match?
  # By comparing what is new against what is current, since password is not returned as part of
  # current, we avoid resetting the password continuously, which logs users out of the GUI
  @current_resource.settings.all? { |key, value| @new_resource.settings[key.to_s] == value }
end

def settings_data
  @settings_data ||= begin
    response = get "/settings/#{new_resource.group}"
    Chef::Log.error response.body unless response.kind_of?(Net::HTTPSuccess) || response.body.to_s.empty?
    response.value
    JSONCompat.from_json response.body
  end
end
