name             'ow_users'
maintainer       'OpenWatch FPC'
maintainer_email 'chris@openwatch.net'
license          'AGPLv3'
description      'Installs/Configures ow_users'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "user", "~> 0.3.0"
depends "sudo"

attribute "ow_users/admins_gid",
  :display_name => "Admins GID",
  :description => "Group ID of the Admins Group",
  :default => "999"