# Cookbook: node_server

## Descripción
Este cookbook instala Node.js en Ubuntu y levanta una pequeña aplicación "Hello World" escuchando en el puerto 3000 (por defecto).

## Requisitos
- Ubuntu >=20.04
- Chef Infra Client >= 14.0


## Atributos

- `node['node_server']['app_path']`: Directorio donde se creará la aplicación Node.js (por defecto: `/opt/node_hello`)
- `node['node_server']['service_name']`: Nombre del servicio systemd (por defecto: `node_hello`)
- `node['node_server']['port']`: Puerto en el que escucha el servidor (por defecto: `3000`)
- `node['node_server']['node_setup_url']`: URL del script de instalación de Node.js (por defecto: `https://deb.nodesource.com/18.20.6`)


## Uso
Incluir la receta en tu run_list:
```json
{
  "run_list": [
    "recipe[node_server::default]"
  ]
}
