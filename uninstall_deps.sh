#!/bin/bash
# PDF Optimierer - Dependency-Deinstallation
# Entfernt alle von der App installierten Tools zum Testen des Installers
#
# Verwendung: ./uninstall_deps.sh [--all]
#   --all  = Auch Homebrew selbst deinstallieren

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "═══════════════════════════════════════"
echo "  PDF Optimierer - Dependency Removal"
echo "═══════════════════════════════════════"
echo ""

REMOVE_HOMEBREW=false
if [[ "$1" == "--all" ]]; then
    REMOVE_HOMEBREW=true
fi

# Zusammenfassung zeigen
echo -e "${YELLOW}Folgendes wird deinstalliert:${NC}"
echo ""
echo "  Homebrew-Pakete:"
command -v gs &>/dev/null && echo -e "    ${RED}✗${NC} ghostscript" || echo "    ✓ ghostscript (nicht installiert)"
command -v magick &>/dev/null && echo -e "    ${RED}✗${NC} imagemagick" || echo "    ✓ imagemagick (nicht installiert)"
command -v exiftool &>/dev/null && echo -e "    ${RED}✗${NC} exiftool" || echo "    ✓ exiftool (nicht installiert)"

echo ""
echo "  Python-Pakete:"
python3 -c "import fitz" 2>/dev/null && echo -e "    ${RED}✗${NC} PyMuPDF" || echo "    ✓ PyMuPDF (nicht installiert)"
python3 -c "from PIL import Image" 2>/dev/null && echo -e "    ${RED}✗${NC} Pillow" || echo "    ✓ Pillow (nicht installiert)"

if $REMOVE_HOMEBREW; then
    echo ""
    echo -e "  ${RED}⚠️  Homebrew wird KOMPLETT entfernt!${NC}"
fi

echo ""
echo "═══════════════════════════════════════"
read -p "Fortfahren? (j/N) " confirm
if [[ "$confirm" != "j" && "$confirm" != "J" ]]; then
    echo "Abgebrochen."
    exit 0
fi
echo ""

# --- Python-Pakete entfernen ---
echo -e "${YELLOW}[1/3] Python-Pakete entfernen...${NC}"

# Python3 finden
PYTHON_CMD=""
if [ -x /opt/homebrew/bin/python3 ]; then
    PYTHON_CMD="/opt/homebrew/bin/python3"
elif [ -x /usr/local/bin/python3 ]; then
    PYTHON_CMD="/usr/local/bin/python3"
elif command -v python3 &>/dev/null; then
    PYTHON_CMD="python3"
fi

if [ -n "$PYTHON_CMD" ]; then
    for pkg in PyMuPDF Pillow; do
        if "$PYTHON_CMD" -m pip show "$pkg" &>/dev/null; then
            echo "  Entferne $pkg..."
            if "$PYTHON_CMD" -m pip uninstall -y "$pkg" 2>/dev/null; then
                echo -e "  ${GREEN}✓${NC} $pkg entfernt"
            elif "$PYTHON_CMD" -m pip uninstall -y "$pkg" --break-system-packages 2>/dev/null; then
                echo -e "  ${GREEN}✓${NC} $pkg entfernt (break-system-packages)"
            elif PIP_BREAK_SYSTEM_PACKAGES=1 "$PYTHON_CMD" -m pip uninstall -y "$pkg" 2>/dev/null; then
                echo -e "  ${GREEN}✓${NC} $pkg entfernt (env override)"
            else
                echo -e "  ${RED}⚠️ $pkg konnte nicht entfernt werden${NC}"
            fi
        else
            echo "  $pkg nicht installiert, überspringe"
        fi
    done
else
    echo "  python3 nicht gefunden, überspringe Python-Pakete"
fi
echo ""

# --- Homebrew-Pakete entfernen ---
echo -e "${YELLOW}[2/3] Homebrew-Pakete entfernen...${NC}"

BREW_CMD=""
if [ -x /opt/homebrew/bin/brew ]; then
    BREW_CMD="/opt/homebrew/bin/brew"
elif [ -x /usr/local/bin/brew ]; then
    BREW_CMD="/usr/local/bin/brew"
elif command -v brew &>/dev/null; then
    BREW_CMD="brew"
fi

if [ -n "$BREW_CMD" ]; then
    for pkg in ghostscript imagemagick exiftool; do
        if "$BREW_CMD" list "$pkg" &>/dev/null; then
            echo "  Entferne $pkg..."
            if "$BREW_CMD" uninstall "$pkg" 2>&1; then
                echo -e "  ${GREEN}✓${NC} $pkg entfernt"
            elif "$BREW_CMD" uninstall --ignore-dependencies "$pkg" 2>&1; then
                echo -e "  ${GREEN}✓${NC} $pkg entfernt (ignore-dependencies)"
            else
                echo -e "  ${RED}⚠️ $pkg konnte nicht entfernt werden${NC}"
            fi
        else
            echo "  $pkg nicht installiert, überspringe"
        fi
    done
else
    echo "  Homebrew nicht gefunden, überspringe"
fi
echo ""

# --- Optional: Homebrew entfernen ---
echo -e "${YELLOW}[3/3] Homebrew...${NC}"

if $REMOVE_HOMEBREW; then
    if [ -n "$BREW_CMD" ]; then
        echo -e "  ${RED}Entferne Homebrew komplett...${NC}"
        echo ""
        read -p "  LETZTE WARNUNG: Homebrew und ALLE Pakete werden gelöscht. Sicher? (j/N) " confirm2
        if [[ "$confirm2" == "j" || "$confirm2" == "J" ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
        else
            echo "  Homebrew-Entfernung übersprungen"
        fi
    else
        echo "  Homebrew nicht installiert"
    fi
else
    echo "  Homebrew bleibt installiert (nutze --all zum Entfernen)"
fi

# --- Ergebnis ---
echo ""
echo "═══════════════════════════════════════"
echo -e "${GREEN}Deinstallation abgeschlossen!${NC}"
echo ""
echo "Status nach Deinstallation:"
echo ""
command -v brew &>/dev/null && echo -e "  Homebrew:    ${GREEN}installiert${NC}" || echo -e "  Homebrew:    ${RED}nicht installiert${NC}"
command -v gs &>/dev/null && echo -e "  Ghostscript: ${GREEN}installiert${NC}" || echo -e "  Ghostscript: ${RED}entfernt${NC}"
command -v magick &>/dev/null && echo -e "  ImageMagick: ${GREEN}installiert${NC}" || echo -e "  ImageMagick: ${RED}entfernt${NC}"
command -v exiftool &>/dev/null && echo -e "  ExifTool:    ${GREEN}installiert${NC}" || echo -e "  ExifTool:    ${RED}entfernt${NC}"
python3 -c "import fitz" 2>/dev/null && echo -e "  PyMuPDF:     ${GREEN}installiert${NC}" || echo -e "  PyMuPDF:     ${RED}entfernt${NC}"
python3 -c "from PIL import Image" 2>/dev/null && echo -e "  Pillow:      ${GREEN}installiert${NC}" || echo -e "  Pillow:      ${RED}entfernt${NC}"
echo ""
echo "Starte jetzt 'PDF Optimierer.app' um den Installer zu testen."
echo "═══════════════════════════════════════"
