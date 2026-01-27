# v1.3.0 - App-Icon & robustere Installation

## Neuerungen

### App-Icon
- Eigenes Icon im macOS-Stil: rotes PDF-Dokument mit grünem Optimierungs-Badge
- Wird im Dock, Finder und Launchpad angezeigt
- Alle macOS-Größen enthalten (16px bis 1024px)

### Robustere automatische Installation
- **Einzelinstallation**: Homebrew-Pakete werden jetzt einzeln installiert — wenn ein Paket fehlschlägt, werden die anderen trotzdem installiert
- **`brew update`**: Wird nach frischer Homebrew-Installation automatisch ausgeführt
- **Retry-Logik**: Jedes Brew-Paket wird bis zu 3x versucht (mit 3s Pause)
- **Dynamische Pfad-Erkennung**: brew, pip3 und python3 werden automatisch an mehreren Orten gesucht (`/opt/homebrew/bin`, `/usr/local/bin`, `$PATH`)
- **Verbesserte pip-Installation**: 5 verschiedene Methoden werden automatisch durchprobiert

## Installation

1. **[Download PDF_Optimierer_v1.3.0.zip](https://github.com/Stebibastian/pdf-optimierer/releases/download/v1.3.0/PDF_Optimierer_v1.3.0.zip)**
2. ZIP entpacken
3. `PDF Optimierer.app` doppelklicken
4. Bei Sicherheitswarnung: Systemeinstellungen → Datenschutz & Sicherheit → "Dennoch öffnen"

## Vollständiger Changelog

- App-Icon hinzugefügt (AppIcon.icns + AppIcon.png Quelldatei)
- Homebrew-Pakete einzeln statt alle auf einmal installiert
- `brew update` nach frischer Installation
- Retry-Logik (3 Versuche) für jedes Brew-Paket
- Hilfsfunktionen `find_brew`, `find_pip3`, `find_python3` für robuste Pfad-Erkennung
- `install_pip_package` Funktion mit 5 Fallback-Methoden
- PATH und `brew shellenv` werden nach jeder Installation neu geladen
- Hardcodierte `/opt/homebrew/bin/python3` Pfade durch dynamische Suche ersetzt
- Version: 1.3.0, Build: 6
