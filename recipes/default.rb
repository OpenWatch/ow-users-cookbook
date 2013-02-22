#
# Cookbook Name:: ow_users
# Recipe:: default
#
# Copyright 2013, OpenWatch FPC
#
# Licensed under the AGPLv3
#

active_gids = node['ow_users']['active_gids']

default_gid = node['ow_users']['default_gid']

users_databag_name = node['ow_users']['users_databag_name']
groups_databag_name = node['ow_users']['groups_databag_name']
groups_item_name = node['ow_users']['groups_databag_item_name']
passwords_databag_name = node['ow_users']['passwords_databag_name']
passwords_item_name = node['ow_users']['passwords_databag_item_name']

users = data_bag(users_databag_name)
gids_item = data_bag_item(groups_databag_name, groups_item_name)
gids = gids_item["gids"]
passwords = Chef::EncryptedDataBagItem.load(passwords_databag_name, passwords_item_name)
admins = []

users.each do |username|
  # This causes a round-trip to the server for each admin in the data bag
  user = data_bag_item(users_databag_name, username)

  # If the group is registered in our group data bag, create it
  if gids.has_key?(user['gid'])
    group gids.fetch(user['gid']) do
      gid     user['gid']
    end
  end

  if active_gids.include? user['gid']
    user_account username do
      comment   (defined?(user['comment']) ? user['comment'] : "")
      ssh_keys  (defined?(user['ssh_keys']) ? user['ssh_keys'] : "")
      uid       user['uid']
      gid       user['gid']
      password  passwords[username]
    end

  end

end