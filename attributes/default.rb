# Package
default['rundeck']['version'] = '2.0.1-1-GA'
default['rundeck']['deb_url'] = "http://download.rundeck.org/deb/rundeck-#{node['rundeck']['version']}.deb"
default['rundeck']['deb_checksum'] = 'f488a0c2a878b218ebba04879f601023'
default['rundeck']['rpm_url'] = 'http://repo.rundeck.org/latest.rpm'

# Framework configuration

default['rundeck']['node_name'] = node.name

default['rundeck']['mail'] = {
	'hostname'		=> 'localhost',
	'port'     		=> 25,
	'username' 		=> nil,
	'password' 		=> nil,
	'from'     		=> 'ops@example.com',
	'tls'      		=> false
}

default['rundeck']['home'] = '/var/lib/rundeck'

default['rundeck']['mail']['recipients_data_bag'] = 'users'
default['rundeck']['mail']['recipients_query'] = 'notify:true'
default['rundeck']['mail']['recipients_field'] = 'email'

default['rundeck']['admin']['data_bag'] = 'cookies'
default['rundeck']['admin']['data_bag_id'] = 'rundeck'

default['rundeck']['proxy']['hostname'] = 'servers.ops.tlium.com'
default['rundeck']['proxy']['default'] = false

default['rundeck']['ssh']['user'] = 'rundeck-ssh'
default['rundeck']['ssh']['timeout'] = 30000
default['rundeck']['ssh']['port'] = 22

default['rundeck']['chef']['port'] = 9998

default['rundeck']['username'] = 'rundeck'
default['rundeck']['group'] = 'rundeck'
default['rundeck']['password'] = 'rundeck'

default['rundeck']['admin_user'] = 'admin'
default['rundeck']['admin_pass'] = 'AdminPass'
