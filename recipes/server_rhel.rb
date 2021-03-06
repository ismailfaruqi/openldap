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

template "/etc/sysconfig/ldap" do
  source "default_slapd.erb"
  mode 644
  owner "root"
  group "root"
  notifies :restart, "service[slapd]"
end

template "#{node['openldap']['dir']}/slapd.d/cn=config/olcDatabase={0}config.ldif" do
  source "olcDatabase={0}config.ldif.erb"
  mode 00640
  owner "ldap"
  group "ldap"
  notifies :restart, "service[slapd]"
end

template "#{node['openldap']['dir']}/slapd.d/cn=config/olcDatabase={1}monitor.ldif" do
  source "olcDatabase={1}monitor.ldif.erb"
  mode 00640
  owner "ldap"
  group "ldap"
  notifies :restart, "service[slapd]"
end

template "#{node['openldap']['dir']}/slapd.d/cn=config/olcDatabase={2}bdb.ldif" do
  source "olcDatabase={2}bdb.ldif.erb"
  mode 00640
  owner "ldap"
  group "ldap"
  notifies :restart, "service[slapd]"
end