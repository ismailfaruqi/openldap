case node['platform']
when "ubuntu"
  package "db4.8-util" do
    action :upgrade
  end

  directory node['openldap']['preseed_dir'] do
    action :create
    recursive true
    mode 00700
    owner "root"
    group "root"
  end

  cookbook_file "#{node['openldap']['preseed_dir']}/slapd.seed" do
    source "slapd.seed"
    mode 00600
    owner "root"
    group "root"
  end

  package "slapd" do
    response_file "slapd.seed"
    action :upgrade
  end
else
  package "db4.2-util" do
    action :upgrade
  end

  package "slapd" do
    action :upgrade
  end
end

if (node['platform'] == "ubuntu")
  template "/etc/default/slapd" do
    source "default_slapd.erb"
    owner "root"
    group "root"
    mode 00644
  end

  directory "#{node['openldap']['dir']}/slapd.d" do
    recursive true
    owner "openldap"
    group "openldap"
    action :create
  end

  execute "slapd-config-convert" do
    command "slaptest -f #{node['openldap']['dir']}/slapd.conf -F #{node['openldap']['dir']}/slapd.d/"
    user "openldap"
    action :nothing
    notifies :start, "service[slapd]", :immediately
  end

  template "#{node['openldap']['dir']}/slapd.conf" do
    source "slapd.conf.erb"
    mode 00640
    owner "openldap"
    group "openldap"
    notifies :stop, "service[slapd]", :immediately
    notifies :run, "execute[slapd-config-convert]"
  end
else
  case node['platform']
  when "debian","ubuntu"
    template "/etc/default/slapd" do
      source "default_slapd.erb"
      owner "root"
      group "root"
      mode 00644
    end
  end

  template "#{node['openldap']['dir']}/slapd.conf" do
    source "slapd.conf.erb"
    mode 00640
    owner "openldap"
    group "openldap"
    notifies :restart, "service[slapd]"
  end
end
