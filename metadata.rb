name             "couchbase"
maintainer       "Julian C. Dunn"
maintainer_email "jdunn@chef.io"
license          "MIT"
description      "Installs and configures Couchbase Server."
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "1.6.2"
issues_url       "https://github.com/disney/couchbase/issues"
source_url       "https://github.com/disney/couchbase"

%w{debian ubuntu centos redhat oracle amazon scientific}.each do |os|
  supports os
end

%w{apt openssl}.each do |d|
  depends d
end

recipe "couchbase::default", "Installs couchbase-server"
