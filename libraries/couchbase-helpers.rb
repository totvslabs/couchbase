#
# Cookbook Name:: couchbase
# Library:: helper
#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Author:: Julian Dunn <jdunn@opscode.com>
#
# Copyright 2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'net/http'

module CouchbaseHelper
  def self.service_listening?(port)
    begin
      Timeout.timeout(30) do
        begin
          TCPSocket.new('127.0.0.1', port).close
          return true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          return false
        end
      end
      Chef::Log.info 'Connection with couchbase open'
    rescue
      Chef::Log.fatal 'Connection with couchbase refused'
      return false
    end
  end

  def self.endpoint_responding?(url)
    begin
      request = Net::HTTP::Get.new(url)
      response = Net::HTTP.start(url.host, url.port) do |http|
        http.request(request)
      end
    rescue Errno::ECONNREFUSED, Errno::ENETUNREACH
      return false
    end
    if response.kind_of?(Net::HTTPSuccess) ||
          response.kind_of?(Net::HTTPRedirection) ||
          response.kind_of?(Net::HTTPForbidden)
      Chef::Log.debug("GET to #{url} successful")
      return true
    else
      Chef::Log.debug("GET to #{url} returned #{response.code} / #{response.class}")
      return false
    end
  rescue EOFError, Errno::ECONNREFUSED
    return false
  end
end
