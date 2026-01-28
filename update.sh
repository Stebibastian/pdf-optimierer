#!/bin/bash

# PDF Optimierer - Auto-Updater
# Prüft auf Updates und aktualisiert die App automatisch

set -e

REPO_URL="https://api.github.com/repos/Stebibastian/pdf-optimierer/releases/latest"
CURRENT_VERSION="1.5.0"
APP_NAME="PDF Optimierer"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Finde installierte App (prüfe /Applications und lokales Verzeichnis)
if [ -d "/Applications/PDF Optimierer.app" ]; then
    APP_PATH="/Applications/PDF Optimierer.app"
elif [ -d "$SCRIPT_DIR/PDF Optimierer.app" ]; then
    APP_PATH="$SCRIPT_DIR/PDF Optimierer.app"
else
    APP_PATH=""
fi

# Farben für Terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== PDF Optimierer Updater ===${NC}"
echo ""

# Zeige gefundene App
if [ -n "$APP_PATH" ]; then
    echo -e "Installierte App: ${BLUE}${APP_PATH}${NC}"
else
    echo -e "${YELLOW}Hinweis: Keine installierte App gefunden.${NC}"
    echo "Die App wird nur im Repository aktualisiert."
fi
echo ""

# Funktion: Version vergleichen
version_gt() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"
}

# Funktion: Zeige Spinner
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while ps -p $pid > /dev/null 2>&1; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "      \b\b\b\b\b\b"
}

# Prüfe ob curl verfügbar
if ! command -v curl &> /dev/null; then
    echo -e "${RED}Fehler: curl nicht gefunden!${NC}"
    exit 1
fi

# Prüfe ob jq verfügbar (optional, Fallback mit grep)
USE_JQ=false
if command -v jq &> /dev/null; then
    USE_JQ=true
fi

echo -e "Aktuelle Version: ${YELLOW}v${CURRENT_VERSION}${NC}"
echo -n "Prüfe auf Updates..."

# Hole neueste Version von GitHub
RESPONSE=$(curl -s "$REPO_URL" 2>/dev/null)

if [ -z "$RESPONSE" ]; then
    echo -e " ${RED}Fehler!${NC}"
    echo "Konnte GitHub nicht erreichen. Prüfe deine Internetverbindung."
    exit 1
fi

# Parse Version (mit jq oder grep)
if [ "$USE_JQ" = true ]; then
    LATEST_VERSION=$(echo "$RESPONSE" | jq -r '.tag_name' | sed 's/^v//')
    DOWNLOAD_URL=$(echo "$RESPONSE" | jq -r '.assets[0].browser_download_url')
    RELEASE_NOTES=$(echo "$RESPONSE" | jq -r '.body')
else
    LATEST_VERSION=$(echo "$RESPONSE" | grep -o '"tag_name": *"[^"]*"' | head -1 | sed 's/"tag_name": *"v\{0,1\}\([^"]*\)"/\1/')
    DOWNLOAD_URL=$(echo "$RESPONSE" | grep -o '"browser_download_url": *"[^"]*\.zip"' | head -1 | sed 's/"browser_download_url": *"\([^"]*\)"/\1/')
fi

if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" = "null" ]; then
    echo -e " ${RED}Fehler!${NC}"
    echo "Konnte Version nicht ermitteln."
    exit 1
fi

echo -e " ${GREEN}OK${NC}"
echo -e "Neueste Version:  ${GREEN}v${LATEST_VERSION}${NC}"
echo ""

# Vergleiche Versionen
if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    echo -e "${GREEN}Du hast bereits die neueste Version!${NC}"
    exit 0
fi

if version_gt "$LATEST_VERSION" "$CURRENT_VERSION"; then
    echo -e "${YELLOW}Update verfügbar: v${CURRENT_VERSION} -> v${LATEST_VERSION}${NC}"
    echo ""

    # Zeige Release Notes (falls verfügbar)
    if [ "$USE_JQ" = true ] && [ -n "$RELEASE_NOTES" ] && [ "$RELEASE_NOTES" != "null" ]; then
        echo -e "${BLUE}Release Notes:${NC}"
        echo "$RELEASE_NOTES" | head -20
        echo ""
    fi

    # Frage Benutzer
    read -p "Möchtest du jetzt updaten? (j/n) " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Jj]$ ]]; then
        echo "Update abgebrochen."
        exit 0
    fi

    # Prüfe Download-URL
    if [ -z "$DOWNLOAD_URL" ] || [ "$DOWNLOAD_URL" = "null" ]; then
        echo -e "${YELLOW}Kein automatischer Download verfügbar.${NC}"
        echo ""
        echo "Bitte manuell aktualisieren:"
        echo -e "${BLUE}git pull origin main${NC}"
        echo ""
        echo "Oder lade die neueste Version herunter:"
        echo -e "${BLUE}https://github.com/Stebibastian/pdf-optimierer/releases/latest${NC}"
        exit 0
    fi

    # Download starten
    echo ""
    echo -n "Lade Update herunter..."

    TEMP_DIR=$(mktemp -d)
    TEMP_ZIP="$TEMP_DIR/update.zip"

    if curl -sL "$DOWNLOAD_URL" -o "$TEMP_ZIP"; then
        echo -e " ${GREEN}OK${NC}"
    else
        echo -e " ${RED}Fehler!${NC}"
        rm -rf "$TEMP_DIR"
        exit 1
    fi

    # Entpacken
    echo -n "Entpacke Update..."

    if unzip -q "$TEMP_ZIP" -d "$TEMP_DIR"; then
        echo -e " ${GREEN}OK${NC}"
    else
        echo -e " ${RED}Fehler!${NC}"
        rm -rf "$TEMP_DIR"
        exit 1
    fi

    # Installieren
    echo -n "Installiere Update..."

    # Finde die App im entpackten Verzeichnis
    EXTRACTED_APP=$(find "$TEMP_DIR" -name "PDF Optimierer.app" -type d 2>/dev/null | head -1)

    if [ -z "$EXTRACTED_APP" ]; then
        echo -e " ${RED}Fehler!${NC}"
        echo "Konnte App nicht im Download finden."
        rm -rf "$TEMP_DIR"
        exit 1
    fi

    # Backup erstellen
    BACKUP_DIR="$SCRIPT_DIR/.backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    # Backup der Repository-App
    if [ -d "$SCRIPT_DIR/PDF Optimierer.app" ]; then
        cp -R "$SCRIPT_DIR/PDF Optimierer.app" "$BACKUP_DIR/"
    fi

    # Backup der installierten App (falls in /Applications)
    if [ -n "$APP_PATH" ] && [ "$APP_PATH" != "$SCRIPT_DIR/PDF Optimierer.app" ]; then
        cp -R "$APP_PATH" "$BACKUP_DIR/"
    fi

    # Repository-App aktualisieren
    rm -rf "$SCRIPT_DIR/PDF Optimierer.app"
    cp -R "$EXTRACTED_APP" "$SCRIPT_DIR/"

    # Installierte App aktualisieren (falls in /Applications)
    if [ -n "$APP_PATH" ] && [ "$APP_PATH" = "/Applications/PDF Optimierer.app" ]; then
        echo -n "Aktualisiere /Applications..."
        rm -rf "/Applications/PDF Optimierer.app"
        cp -R "$EXTRACTED_APP" "/Applications/"
        echo -e " ${GREEN}OK${NC}"
    fi

    # Scripts aktualisieren
    if [ -f "$TEMP_DIR/"*"/PDF_Optimierer.sh" ]; then
        cp "$TEMP_DIR/"*"/PDF_Optimierer.sh" "$SCRIPT_DIR/"
    fi

    if [ -f "$TEMP_DIR/"*"/update.sh" ]; then
        cp "$TEMP_DIR/"*"/update.sh" "$SCRIPT_DIR/"
        chmod +x "$SCRIPT_DIR/update.sh"
    fi

    # Aufräumen
    rm -rf "$TEMP_DIR"

    echo -e " ${GREEN}OK${NC}"
    echo ""
    echo -e "${GREEN}=== Update erfolgreich! ===${NC}"
    echo -e "Version: ${GREEN}v${LATEST_VERSION}${NC}"
    echo ""
    echo "Du kannst die App jetzt starten:"
    if [ -d "/Applications/PDF Optimierer.app" ]; then
        echo -e "${BLUE}open \"/Applications/PDF Optimierer.app\"${NC}"
    else
        echo -e "${BLUE}open \"$SCRIPT_DIR/PDF Optimierer.app\"${NC}"
    fi
    echo ""
    echo -e "Backup erstellt in: ${YELLOW}$BACKUP_DIR${NC}"

else
    echo -e "${GREEN}Du hast bereits die neueste Version (oder eine neuere).${NC}"
fi
