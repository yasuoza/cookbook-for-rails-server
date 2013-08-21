# Set attributes for the git user
default['app_user']['user'] = "vagrant"
default['app_user']['group'] = "vagrant"
default['app_user']['home'] = "/home/vagrant"

default['app_user']['packages'] = %w{
  vim curl wget checkinstall libxslt-dev nodejs
  libcurl4-openssl-dev libssl-dev libmysql++-dev
  libicu-dev libc6-dev libyaml-dev python python-dev
}
