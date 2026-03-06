#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/../.."
SRC_DIR="$PWD"

read -rp "Entidad en singular (ej: user): " SINGULAR_INPUT
read -rp "Entidad en plural (ej: users): " PLURAL_INPUT

SINGULAR_INPUT="$(echo "$SINGULAR_INPUT" | xargs)"
PLURAL_INPUT="$(echo "$PLURAL_INPUT" | xargs)"

if [ -z "$SINGULAR_INPUT" ] || [ -z "$PLURAL_INPUT" ]; then
  echo "❌ Singular y plural son obligatorios"
  exit 1
fi

SINGULAR_LOWER="$(echo "$SINGULAR_INPUT" | tr '[:upper:]' '[:lower:]')"
PLURAL_LOWER="$(echo "$PLURAL_INPUT" | tr '[:upper:]' '[:lower:]')"
DEFAULT_TARGET="../markitos-it-svc-${PLURAL_LOWER}"

read -rp "Ruta destino [${DEFAULT_TARGET}]: " TARGET_DIR_INPUT
TARGET_DIR_INPUT="$(echo "$TARGET_DIR_INPUT" | xargs)"
TARGET_DIR="${TARGET_DIR_INPUT:-$DEFAULT_TARGET}"

export SRC_DIR TARGET_DIR SINGULAR_INPUT PLURAL_INPUT

to_title() {
    local value="$1"
    value="${value,,}"
    echo "${value^}"
}

SINGULAR_TITLE="$(to_title "$SINGULAR_INPUT")"
PLURAL_TITLE="$(to_title "$PLURAL_INPUT")"
SINGULAR_UPPER="${SINGULAR_INPUT^^}"
PLURAL_UPPER="${PLURAL_INPUT^^}"

apply_replacements() {
    local value="$1"
    value="${value//GOLDENS/$PLURAL_UPPER}"
    value="${value//Goldens/$PLURAL_TITLE}"
    value="${value//goldens/$PLURAL_LOWER}"
    value="${value//GOLDEN/$SINGULAR_UPPER}"
    value="${value//Golden/$SINGULAR_TITLE}"
    value="${value//golden/$SINGULAR_LOWER}"
    echo "$value"
}

if [ -d "$TARGET_DIR" ] && [ "$(find "$TARGET_DIR" -mindepth 1 -maxdepth 1 | head -n 1)" ]; then
    echo "❌ El destino ya existe y no está vacío: $(realpath "$TARGET_DIR")"
    exit 1
fi

[ -d "$TARGET_DIR" ] && rmdir "$TARGET_DIR"

echo "📦 Clonando desde $(realpath "$SRC_DIR") hacia $(realpath -m "$TARGET_DIR")..."
mkdir -p "$TARGET_DIR"
cp -a "$SRC_DIR"/. "$TARGET_DIR"/
rm -rf "$TARGET_DIR/.git"

RENAMED_PATHS=0
while IFS= read -r -d '' PATH_ITEM; do
    BASE_NAME="$(basename "$PATH_ITEM")"
    DIR_NAME="$(dirname "$PATH_ITEM")"
    NEW_BASE="$(apply_replacements "$BASE_NAME")"

    if [ "$NEW_BASE" != "$BASE_NAME" ]; then
        mv "$PATH_ITEM" "$DIR_NAME/$NEW_BASE"
        RENAMED_PATHS=$((RENAMED_PATHS + 1))
    fi
done < <(find "$TARGET_DIR" -depth -mindepth 1 -print0)

UPDATED_FILES=0
while IFS= read -r -d '' FILE_ITEM; do
    if ! grep -Iq . "$FILE_ITEM"; then
        continue
    fi

    if grep -qE 'goldens|golden|Goldens|Golden|GOLDENS|GOLDEN' "$FILE_ITEM"; then
        sed -i \
            -e "s/GOLDENS/${PLURAL_UPPER}/g" \
            -e "s/Goldens/${PLURAL_TITLE}/g" \
            -e "s/goldens/${PLURAL_LOWER}/g" \
            -e "s/GOLDEN/${SINGULAR_UPPER}/g" \
            -e "s/Golden/${SINGULAR_TITLE}/g" \
            -e "s/golden/${SINGULAR_LOWER}/g" \
            "$FILE_ITEM"
        UPDATED_FILES=$((UPDATED_FILES + 1))
    fi
done < <(find "$TARGET_DIR" -type f -print0)

echo "✅ Clonado completado"
echo "📁 Destino........: $(realpath "$TARGET_DIR")"
echo "🔁 Rutas renombradas: $RENAMED_PATHS"
echo "📝 Archivos editados: $UPDATED_FILES"
