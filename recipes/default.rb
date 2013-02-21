#
# Cookbook Name:: ow_users
# Recipe:: default
#
# Copyright 2013, OpenWatch FPC
#
# Licensed under the AGPLv3
#

include_recipe "user"

# Create an "admins" group on the system
group "admins" do
  gid     999
end

users_databag_name = 'users'
passwords_databag_name = "user-passwords"
passwords_item_name = "passwords"

users = data_bag(users_databag_name)
passwords = Chef::EncryptedDataBagItem.load(passwords_databag_name, passwords_item_name)
admins = []

users.each do |username|
  # This causes a round-trip to the server for each admin in the data bag
  user = data_bag_item(users_databag_name, username)

  if user['gid'] == 999
    admins.push(username)
  end

  user_account username do
    comment   user['comment']
    ssh_keys  user['ssh_keys']
    uid       user['uid']
    gid       user['gid']
    password  passwords[username]
    home      home
  end
end

# Add the admins
group "admins" do
  members admins
end
