#!/usr/bin/env bash
set -euo pipefail

#:[.'.]:>- ===================================================================================
#:[.'.]:>- Marco Antonio - markitos devsecops kulture
#:[.'.]:>- The Way of the Artisan
#:[.'.]:>- markitos.es.info@gmail.com
#:[.'.]:>- 🌍 https://github.com/orgs/markitos-it/repositories
#:[.'.]:>- 🌍 https://github.com/orgs/markitos-public/repositories
#:[.'.]:>- 📺 https://www.youtube.com/@markitos_devsecops
#:[.'.]:>- ===================================================================================

#:[.'.]:>- Descripción:
#:[.'.]:>- Script de configuración inicial para nuevos proyectos clonados desde la plantilla golden.
#:[.'.]:>- Configura los puertos de PostgreSQL y del servicio gRPC en docker-compose.yml
#:[.'.]:>- y se auto-elimina del Makefile y los READMEs tras ejecutarse.

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT=$(readlink -f "$SCRIPT_DIR/../..")

echo
echo -e "${CYAN}🛠️  Configuración inicial del proyecto clonado${NC}"
echo -e "${CYAN}================================================${NC}"
echo
echo "  Este script configurará:"
echo "  - Puerto de PostgreSQL en docker-compose.yml"
echo "  - Puerto local del servicio gRPC en docker-compose.yml"
echo "  - Se auto-eliminará del Makefile y READMEs al finalizar"
echo

#:[.'.]:>- Solicitar puerto de PostgreSQL
while true; do
    echo -e "${YELLOW}➤  Puerto para PostgreSQL${NC}"
    echo    "   (sugerido: 55433)"
    read -r -p "   Puerto PostgreSQL [55433]: " POSTGRES_PORT
    POSTGRES_PORT="${POSTGRES_PORT:-55433}"

    if [[ "$POSTGRES_PORT" =~ ^[0-9]{1,5}$ ]] && [ "$POSTGRES_PORT" -ge 1024 ] && [ "$POSTGRES_PORT" -le 65535 ]; then
        echo -e "   ${GREEN}✅ Puerto PostgreSQL: ${POSTGRES_PORT}${NC}"
        break
    else
        echo "   ❌ Puerto inválido. Debe ser un número entre 1024 y 65535."
    fi
    echo
done

echo

#:[.'.]:>- Solicitar puerto local del servicio gRPC
while true; do
    echo -e "${YELLOW}➤  Puerto local para el servicio gRPC${NC}"
    echo    "   (sugerido: 3001)"
    read -r -p "   Puerto servicio gRPC [3001]: " SVC_PORT
    SVC_PORT="${SVC_PORT:-3001}"

    if [[ "$SVC_PORT" =~ ^[0-9]{1,5}$ ]] && [ "$SVC_PORT" -ge 1024 ] && [ "$SVC_PORT" -le 65535 ]; then
        echo -e "   ${GREEN}✅ Puerto servicio gRPC: ${SVC_PORT}${NC}"
        break
    else
        echo "   ❌ Puerto inválido. Debe ser un número entre 1024 y 65535."
    fi
    echo
done

echo

#:[.'.]:>- Actualizar docker-compose.yml: puerto de PostgreSQL
DOCKER_COMPOSE="$PROJECT_ROOT/docker-compose.yml"

echo -e "${CYAN}📝 Actualizando docker-compose.yml...${NC}"

#:[.'.]:>- Reemplazar puerto PostgreSQL (valor por defecto 55433)
sed -i "s/\${POSTGRES_PORT:-55433}/${POSTGRES_PORT}/g" "$DOCKER_COMPOSE"

#:[.'.]:>- Reemplazar puerto del servicio (mapeo host:contenedor)
#:[.'.]:>- Patrón: - "XXXX:3000" -> - "SVC_PORT:3000"
sed -i 's|ports:\n.*"[0-9]*:3000"|ports:\n      - "'"$SVC_PORT"':3000"|' "$DOCKER_COMPOSE"
#:[.'.]:>- Alternativa con perl para multilinea si sed no captura bien:
perl -i -0pe 's|(ports:\s*\n\s*- ")[0-9]+(":3000")|${1}'"$SVC_PORT"'${2}|' "$DOCKER_COMPOSE"

echo -e "   ${GREEN}✅ docker-compose.yml actualizado${NC}"
echo "      POSTGRES_PORT  → $POSTGRES_PORT"
echo "      SERVICE_PORT   → $SVC_PORT:3000"

echo

#:[.'.]:>- Auto-eliminar target 'clone' y referencia en .PHONY del Makefile
MAKEFILE="$PROJECT_ROOT/Makefile"

echo -e "${CYAN}🗑️  Limpiando Makefile (eliminando target clone)...${NC}"

#:[.'.]:>- Eliminar 'clone' de la línea .PHONY
sed -i 's/ clone//' "$MAKEFILE"
sed -i 's/clone //' "$MAKEFILE"

#:[.'.]:>- Eliminar bloque del target clone (líneas desde "clone:" hasta la siguiente línea en blanco o target)
perl -i -0pe 's/\nclone:[^\n]*\n\tbash bin\/app\/clone\.sh\n/\n/' "$MAKEFILE"

#:[.'.]:>- Eliminar línea del help que menciona make clone
sed -i '/make clone/d' "$MAKEFILE"

echo -e "   ${GREEN}✅ Makefile limpiado${NC}"

echo

#:[.'.]:>- Limpiar READMEs: eliminar líneas que mencionan make clone
for readme in "$PROJECT_ROOT/README.md" "$PROJECT_ROOT/README.es.md"; do
    if [ -f "$readme" ]; then
        echo -e "${CYAN}🗑️  Limpiando $(basename "$readme")...${NC}"
        sed -i '/make clone/d' "$readme"
        echo -e "   ${GREEN}✅ $(basename "$readme") limpiado${NC}"
    fi
done

echo
echo -e "${GREEN}🎉 Configuración completada.${NC}"
echo "   Ahora puedes ejecutar: ${CYAN}make start${NC}"
echo
