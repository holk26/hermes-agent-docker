#!/bin/bash
set -e

# Script de migración de configuración local de Hermes a Dokploy
# Empaqueta ~/.hermes en un tarball listo para subir al servidor

HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
BACKUP_DIR="$(pwd)/dokploy-migration"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE="$BACKUP_DIR/hermes-backup-$TIMESTAMP.tar.gz"

echo "═══════════════════════════════════════════════════════"
echo "  Hermes → Dokploy Migration Script"
echo "═══════════════════════════════════════════════════════"
echo ""

if [ ! -d "$HERMES_HOME" ]; then
    echo "❌ No se encontró $HERMES_HOME"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

echo "📦 Empaquetando configuración de Hermes..."
echo "   Origen: $HERMES_HOME"
echo "   Destino: $ARCHIVE"
echo ""

# Crear tarball excluyendo archivos grandes o innecesarios
tar -czf "$ARCHIVE" \
    --exclude='*.log' \
    --exclude='logs/*' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    --exclude='.venv*' \
    --exclude='audio_cache/*' \
    --exclude='image_cache/*' \
    --exclude='cache/*' \
    --exclude='state.db-shm' \
    --exclude='state.db-wal' \
    --exclude='.update_check' \
    --exclude='.skills_prompt_snapshot.json' \
    --exclude='models_dev_cache.json' \
    -C "$HOME" .hermes

ARCHIVE_SIZE=$(du -h "$ARCHIVE" | cut -f1)

echo "✅ Backup creado: $ARCHIVE"
echo "   Tamaño: $ARCHIVE_SIZE"
echo ""
echo "═══════════════════════════════════════════════════════"
echo "  INSTRUCCIONES PARA COMPLETAR LA MIGRACIÓN"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "1. Detén tu instancia local de Hermes para evitar"
echo "   conflictos con Telegram:"
echo ""
echo "   pkill -f 'hermes gateway'"
echo ""
echo "2. Conecta por SSH al servidor de Dokploy:"
echo ""
echo "   ssh root@10.0.0.154"
echo ""
echo "3. En el servidor, encuentra el volumen Docker:"
echo ""
echo "   docker volume ls | grep hermes"
echo ""
echo "4. Extrae el backup en el volumen (reemplaza VOLUME_NAME):"
echo ""
echo "   docker run --rm -v VOLUME_NAME:/opt/data -v /root:/backup alpine:latest \\"
echo "     sh -c 'cd /opt/data && tar -xzf /backup/dokploy-migration/hermes-backup-$TIMESTAMP.tar.gz --strip-components=1'"
echo ""
echo "5. Reinicia el contenedor en Dokploy:"
echo ""
echo "   docker restart hermes-agent"
echo ""
echo "═══════════════════════════════════════════════════════"
echo ""
