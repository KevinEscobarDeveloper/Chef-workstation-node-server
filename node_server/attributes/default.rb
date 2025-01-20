default['node-server']['node_version']='14.21.3'

# Directorio donde se alojará la aplicación Node.js
default['node_server']['app_path'] = '/opt/node_hello'

# Nombre del servicio systemd
default['node_server']['service_name'] = 'node_hello'

# Puerto en el que escucha la aplicación Node.js
default['node_server']['port'] = 3000

# Versión o "setup script" para Node.js
default['node_server']['node_setup_url'] = 'https://deb.nodesource.com/18.20.6'