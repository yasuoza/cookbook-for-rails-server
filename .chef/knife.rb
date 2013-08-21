cookbook_path ["cookbooks", "site-cookbooks"]
node_path     "nodes"
role_path     nil
data_bag_path "data_bags"
encrypted_data_bag_secret "#{ENV['HOME']}/.chef/data_bag_key"

knife[:berkshelf_path] = "cookbooks"
