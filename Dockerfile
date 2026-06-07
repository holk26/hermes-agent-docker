# Dockerfile extendido para Hermes Agent en Dokploy
# Basado en la imagen oficial de NousResearch
# Incluye configuración personalizada del usuario

FROM nousresearch/hermes-agent:latest

# Crear directorio de datos y copiar configuración esencial
# La imagen base maneja permisos automáticamente al iniciar
RUN mkdir -p /opt/data

# Copiar archivos de configuración (sin secretos)
# Los skills se descargan automáticamente al iniciar el contenedor
COPY config.yaml /opt/data/config.yaml
COPY SOUL.md /opt/data/SOUL.md
COPY memories/ /opt/data/memories/

# Asegurar permisos permisivos para que la imagen base pueda re-mapearlos
RUN chmod -R 777 /opt/data

# IMPORTANTE: No usar USER — la imagen base de Hermes debe ejecutarse como root
# y usa HERMES_UID/HERMES_GID para mapear al usuario host.
# El punto de entrada y comando por defecto vienen de la imagen base.
