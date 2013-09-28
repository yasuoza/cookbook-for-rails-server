# Include cookbook dependencies
%w{ build-essential readline xml zlib
    redisio::install redisio::enable }.each do |requirement|
  include_recipe requirement
end

# symlink redis-cli into /usr/bin (needed for app_user hooks to work)
link "/usr/bin/redis-cli" do
  to "/usr/local/bin/redis-cli"
end

