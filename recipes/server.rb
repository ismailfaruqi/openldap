#
# Cookbook Name:: openldap
# Recipe:: server
#
# Copyright 2008-2009, Opscode, Inc.
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

include_recipe "openldap::client"

if node['openldap']['tls_enabled'] && node['openldap']['manage_ssl']
  cookbook_file node['openldap']['ssl_cert'] do
    source "ssl/#{node['openldap']['server']}_cert.pem"
    mode 00644
    owner "root"
    group "root"
  end
  cookbook_file node['openldap']['ssl_key'] do
    source "ssl/#{node['openldap']['server']}.pem"
    mode 00644
    owner "root"
    group "root"
  end
end

include_recipe "openldap::server_#{node['platform_family']}"

service "slapd" do
  action [:enable, :start]
end

