# This recipe is based on
# http://www.peterchen.net/2013/02/20/en-how-to-install-mysql-5-6-on-ubuntu-12-04-precise/

deb_package = 'mysql-5.6.13-debian6.0-x86_64.deb'
mysql_version = '5.6.13'

apt_package 'curl' do
  action :install
end

bash 'download mysql5.6 dep' do
  user 'root'
  group 'root'
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    curl http://cdn.mysql.com/Downloads/MySQL-5.6/#{deb_package} -o #{deb_package}
  EOH

  not_if { File.exist? "#{Chef::Config[:file_cache_path]}/#{deb_package}" }
end

dpkg_package "#{Chef::Config[:file_cache_path]}/#{deb_package}" do
  action :install

  not_if { File.exist? "/opt/mysql/server-5.6" }
end

service 'mysql' do
  action :stop
end

bash 'backup old mysql data' do
  code <<-EOH
    cp -rp /var/lib/mysql /var/lib/mysql.old
  EOH

  not_if  "test `mysql --version | sed -e 's/^.*Distrib\s\+//' -e 's/,.*$//'` = #{mysql_version}"
end

%w(mysql-server mysql-server-5.5 mysql-server-core-5.5).each do |pkg|
  apt_package pkg do
    action :remove
  end
end

bash 'set up mysql.server' do
  code <<-EOH
    cp /opt/mysql/server-5.6/support-files/mysql.server /etc/init.d/mysql.server
    update-rc.d mysql.server defaults
    chown -R mysql:mysql /opt/mysql/server-5.6/
  EOH

  not_if  "test `mysql --version | sed -e 's/^.*Distrib\s\+//' -e 's/,.*$//'` = #{mysql_version}"
end

apt_package 'libaio1' do
  action :install

  not_if  "test `mysql --version | sed -e 's/^.*Distrib\s\+//' -e 's/,.*$//'` = #{mysql_version}"
end

ruby_block 'edit my.cnf' do
  block do
    my_cnf = Chef::Util::FileEdit.new('/etc/mysql/my.cnf')
    my_cnf.search_file_delete_line(/table_cache/)
    my_cnf.search_file_replace(/log_slow_queries/, 'slow_query_log_file')
    my_cnf.search_file_replace_line(/basedir/, 'basedir = /opt/mysql/server-5.6')
    my_cnf.insert_line_after_match(/basedir/, 'lc-messages-dir = /opt/mysql/server-5.6/share')
    my_cnf.write_file
  end

  not_if  "test `mysql --version | sed -e 's/^.*Distrib\s\+//' -e 's/,.*$//'` = #{mysql_version}"
end

bash 'install mysql5.6' do
  code <<-EOH
    /opt/mysql/server-5.6/scripts/mysql_install_db --user=mysql --datadir=/var/lib/mysql
    cp /opt/mysql/server-5.6/bin/* /usr/bin/
  EOH

  not_if  "test `mysql --version | sed -e 's/^.*Distrib\s\+//' -e 's/,.*$//'` = #{mysql_version}"
end

service 'mysql.server' do
  action :start
end
