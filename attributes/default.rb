#
# Cookbook Name:: ow_users
# Attributes:: default
#
# Copyright 2013, OpenWatch FPC
#
# Licensed under the AGPLv3
#

default['ow_users']['active_gids'] = []

default['ow_users']['admins_gid'] = 999
default['ow_users']['app_service_gid'] = 500

default['ow_users']['users_databag_name'] = "users"
default['ow_users']['groups_databag_name'] = "groups"
default['ow_users']['groups_databag_item_name'] = "groups"
default['ow_users']['passwords_databag_name'] = "user-passwords"
default['ow_users']['passwords_databag_item_name'] = "passwords"
