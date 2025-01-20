#
# Cookbook:: node_server
# Recipe:: default
#
# Instala Node.js, configura una app "Hello World" y la levanta como servicio.
#
# 0. Corregir los repositorios de apt para Ubuntu 23.10 EOL
bash 'fix_sources_list' do
  code <<-EOH
    sed -i 's|http://archive.ubuntu.com/ubuntu|http://old-releases.ubuntu.com/ubuntu|g' /etc/apt/sources.list
    sed -i 's|http://security.ubuntu.com/ubuntu|http://old-releases.ubuntu.com/ubuntu|g' /etc/apt/sources.list
  EOH
  not_if "grep -q 'old-releases.ubuntu.com' /etc/apt/sources.list"
end

# 1. Instalar Node.js desde repositorio oficial
bash 'install_nodejs' do
  code <<-EOH
    curl -sL https://deb.nodesource.com/setup_18.x | bash -
    apt-get update
    apt-get install -y nodejs
  EOH
  not_if 'which node'
end


# 2. Crear el directorio para la aplicación
directory node['node_server']['app_path'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

# 3. Crear el archivo de la aplicación Node.js
file "#{node['node_server']['app_path']}/app.js" do
  content <<-EOH
  const http = require('http');
  const port = #{node['node_server']['port']};

  const requestHandler = (request, response) => {
    console.log("Recibida petición en: " + request.url);
    response.end("Hola desde Node.js en Chef!");
  }

  const server = http.createServer(requestHandler);

  server.listen(port, (err) => {
    if (err) {
      return console.log('Error al iniciar el servidor:', err);
    }
    console.log(`Servidor corriendo en puerto ${port}`);
  });
  EOH
  mode '0755'
end

# 4. Crear el archivo package.json 
file "#{node['node_server']['app_path']}/package.json" do
  content <<-EOH
  {
    "name": "node_hello",
    "version": "1.0.0",
    "description": "Proyecto Hola Mundo en Node",
    "main": "app.js",
    "scripts": {
      "start": "node app.js"
    }
  }
  EOH
  mode '0755'
end

# 5. Plantilla para el servicio systemd
template "/etc/systemd/system/#{node['node_server']['service_name']}.service" do
  source 'node_server.service.erb'
  mode '0644'
  variables(
    app_path: node['node_server']['app_path'],
    service_name: node['node_server']['service_name']
  )
  notifies :run, 'execute[daemon-reload]', :immediately
end

# 6. Recargar demonios y habilitar/iniciar servicio
execute 'daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

service node['node_server']['service_name'] do
  action [:enable, :start]
end
