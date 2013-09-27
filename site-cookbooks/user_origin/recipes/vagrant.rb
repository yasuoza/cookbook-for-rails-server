# Include cookbook dependencies
%w{ build-essential readline xml zlib }.each do |requirement|
  include_recipe requirement
end

# symlink redis-cli into /usr/bin (needed for app_user hooks to work)
link "/usr/bin/redis-cli" do
  to "/usr/local/bin/redis-cli"
end

# Install required packages for app_user
node['app_user']['packages'].each do |pkg|
  package pkg
end

# Install sshkey gem into chef
chef_gem "sshkey" do
  action :install
end

# Create a $HOME/.ssh folder
directory "#{node['app_user']['home']}/.ssh" do
  owner node['app_user']['user']
  group node['app_user']['group']
  mode 0700
end

# Generate and deploy ssh public/private keys
Gem.clear_paths

# Configure app_user user to auto-accept localhost SSH keys
template "#{node['app_user']['home']}/.ssh/config" do
  source "ssh_config.erb"
  owner node['app_user']['user']
  group node['app_user']['group']
  mode 0644
  variables(
    :fqdn => node['fqdn'],
    :trust_local_sshkeys => node['app_user']['trust_local_sshkeys'] || 'no'
  )
end

# Database information
mysql_connexion = { :host     => 'localhost',
                    :username => 'root',
                    :password => node['mysql']['server_root_password'] }

# Create mysql user vagrant
mysql_database_user 'vagrant' do
  connection mysql_connexion
  password 'vagrant'
  action :create
end

# Grant all privelages on all databases/tables from localhost to vagrant
mysql_database_user 'vagrant' do
  connection mysql_connexion
  password 'vagrant'
  action :grant
end

# Append default Display (99.0) in bashrc
template "/etc/bash.bashrc" do
  owner "root"
  group "root"
  mode 0755
  source "bash.bashrc"
end

# Create directory for bundle options.
directory "#{node['app_user']['home']}/.bundle" do
  owner node['app_user']['user']
  group node['app_user']['group']
  mode 0755
end

# Add default options for bundler (fixes bug with charlock_holmes)
template "#{node['app_user']['home']}/.bundle/options" do
  owner node['app_user']['user']
  group node['app_user']['group']
  mode 0644
  source "bundle_options"
end

bash "append my id_rsa.pub" do
  data_bag = Chef::EncryptedDataBagItem.load('users','app')
  ssy_keys = data_bag['ssy_keys']
  user node['app_user']['user']
  authorized_keys = "#{node['app_user']['home']}/.ssh/authorized_keys"

  code <<-EOH
    echo #{ssy_keys} >> #{authorized_keys}
  EOH

  not_if { File.open(authorized_keys).read.scan(ssy_keys).any? }
end
