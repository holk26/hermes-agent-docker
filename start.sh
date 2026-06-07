#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}   Hermes Agent - Docker Launcher${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo ""

# Verifica que Docker y Docker Compose estén instalados
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker no está instalado${NC}"
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}Error: Docker Compose no está instalado${NC}"
    exit 1
fi

# Detecta docker compose vs docker-compose
if docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
else
    COMPOSE_CMD="docker-compose"
fi

# Verifica que existe la configuración de Hermes
if [ ! -d "$HOME/.hermes" ]; then
    echo -e "${YELLOW}Advertencia: No se encontró ~/.hermes${NC}"
    echo -e "${YELLOW}¿Es la primera vez que ejecutas Hermes?${NC}"
    echo ""
    read -p "¿Quieres ejecutar el setup wizard primero? (s/n): " setup_first
    if [[ $setup_first =~ ^[Ss]$ ]]; then
        mkdir -p ~/.hermes
        docker run -it --rm -v ~/.hermes:/opt/data nousresearch/hermes-agent setup
    else
        echo -e "${RED}Abortando. Crea ~/.hermes primero.${NC}"
        exit 1
    fi
fi

# Muestra información
HARMES_CONFIG="$HOME/.hermes/config.yaml"
if [ -f "$HARMES_CONFIG" ]; then
    echo -e "${GREEN}✓ Configuración encontrada:${NC} $HARMES_CONFIG"
    echo -e "${GREEN}✓ Directorio de datos:${NC} $HOME/.hermes"
fi

echo ""
echo -e "${YELLOW}Opciones disponibles:${NC}"
echo "  1) Iniciar gateway (modo producción, detach)"
echo "  2) Iniciar en modo interactivo (logs en pantalla)"
echo "  3) Abrir chat CLI interactivo"
echo "  4) Detener contenedor"
echo "  5) Actualizar imagen y reiniciar"
echo "  6) Ver estado/logs"
echo "  7) Ejecutar comando dentro del contenedor"
echo "  8) Salir"
echo ""
read -p "Selecciona una opción [1-8]: " option

case $option in
    1)
        echo -e "${BLUE}Iniciando Hermes Agent gateway...${NC}"
        $COMPOSE_CMD up -d
        echo -e "${GREEN}✓ Gateway iniciado en http://localhost:8642${NC}"
        echo -e "${GREEN}✓ Logs: $COMPOSE_CMD logs -f hermes${NC}"
        ;;
    2)
        echo -e "${BLUE}Iniciando Hermes Agent en modo interactivo...${NC}"
        echo -e "${YELLOW}Presiona Ctrl+C para detener${NC}"
        $COMPOSE_CMD up
        ;;
    3)
        echo -e "${BLUE}Abriendo chat CLI interactivo...${NC}"
        docker run -it --rm -v ~/.hermes:/opt/data nousresearch/hermes-agent
        ;;
    4)
        echo -e "${YELLOW}Deteniendo Hermes Agent...${NC}"
        $COMPOSE_CMD down
        echo -e "${GREEN}✓ Contenedor detenido${NC}"
        ;;
    5)
        echo -e "${BLUE}Actualizando imagen...${NC}"
        docker pull nousresearch/hermes-agent:latest
        echo -e "${YELLOW}Reiniciando contenedor...${NC}"
        $COMPOSE_CMD down
        $COMPOSE_CMD up -d
        echo -e "${GREEN}✓ Actualización completada${NC}"
        ;;
    6)
        echo -e "${BLUE}Estado del contenedor:${NC}"
        docker ps --filter "name=hermes-agent" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        echo ""
        echo -e "${BLUE}Últimos logs:${NC}"
        $COMPOSE_CMD logs --tail=50 hermes
        ;;
    7)
        echo -e "${BLUE}Abriendo shell en el contenedor...${NC}"
        docker exec -it hermes-agent /bin/bash
        ;;
    8)
        echo "Saliendo..."
        exit 0
        ;;
    *)
        echo -e "${RED}Opción inválida${NC}"
        exit 1
        ;;
esac
