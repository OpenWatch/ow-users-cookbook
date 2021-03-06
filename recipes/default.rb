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

Chef::Log.info("Got users #{users}")

users.each do |username|
  # This causes a round-trip to the server for each admin in the data bag
  user = data_bag_item(users_databag_name, username)

  uid = user['uid']
  gid = user['gid']
  Chef::Log.info("Attemping to create user #{username} with id #{uid}")

  # If the group is registered in our group data bag, create it
  if gids.has_key?(gid.to_s())
    group gids.fetch(gid.to_s()) do
      gid     gid
    end
    Chef::Log.info("Created group with gid #{gid}")
  end

  if active_gids.include? gid
    user_account username do
      comment   (defined?(user['comment']) ? user['comment'] : "")
      ssh_keys  (defined?(user['ssh_keys']) ? user['ssh_keys'] : "")
      uid       uid
      gid       gid
      password  passwords[username]
    end

  end

end