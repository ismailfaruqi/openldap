package "db4-utils" do
  action :upgrade
end

package "openldap-servers" do
  action :upgrade
end

template "#{node['openldap']['dir']}/slapd.conf" do
  source "slapd.conf.erb"
  mode 00640
  owner "ldap"
  group "ldap"
  notifies :restart, "service[slapd]"
end
