# Dockerfile extendido para Hermes Agent
# Basado en la imagen oficial de NousResearch
# Usa esto si necesitas instalar dependencias adicionales o personalizar el contenedor

FROM nousresearch/hermes-agent:latest

# Instala dependencias adicionales si las necesitas
# USER root
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     tu-paquete \
#     && rm -rf /var/lib/apt/lists/*

# Copia archivos personalizados si los tienes
# COPY custom-scripts/ /opt/custom-scripts/

# Vuelve al usuario por defecto de la imagen base
# USER hermes

# El punto de entrada y comando por defecto vienen de la imagen base
# Puedes sobreescribirlos en docker-compose.yml o al ejecutar docker run
