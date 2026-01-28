# PDF Optimierer

Eine macOS App zum Glätten und Skalieren von PDFs, optimiert für FileMaker und technische Zeichnungen.

[![Download](https://img.shields.io/badge/Download-Latest%20Release-blue?style=for-the-badge)](https://github.com/Stebibastian/pdf-optimierer/releases/latest)
[![macOS](https://img.shields.io/badge/macOS-10.15+-000000?style=flat-square&logo=apple)](https://www.apple.com/macos/)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

## Features

- **Glätten für FileMaker** - Rendert PDFs als hochauflösende Bilder (wählbare DPI), optimiert Kontrast und Schärfe, entfernt problematische Transparenzen und Ebenen
- **PDF Verkleinern** - Skaliert PDFs prozentual (z.B. 50%), reduziert Dateigröße
- **Automatische Installation** - Installiert alle benötigten Tools beim ersten Start
- **Original-Erhaltung** - Das Original wird automatisch als `_original.pdf` umbenannt, die neue Datei bekommt den Originalnamen
- **Metadaten** - Titel, Autor, Datum etc. werden vom Original übernommen
- **Mehrfachauswahl** - Mehrere PDFs auf einmal verarbeiten

## Installation

### Download (Empfohlen)

1. **[Download PDF Optimierer (Latest)](https://github.com/Stebibastian/pdf-optimierer/releases/latest)**
2. Entpacke die ZIP-Datei
3. Doppelklick auf `PDF Optimierer.app`
4. Bei Sicherheitswarnung: **Systemeinstellungen** > **Datenschutz & Sicherheit** > **"Dennoch öffnen"**
5. Beim ersten Start werden alle Tools automatisch installiert

### Mit Git

```bash
git clone https://github.com/Stebibastian/pdf-optimierer.git
open "pdf-optimierer/PDF Optimierer.app"
```

### Voraussetzungen

- macOS 10.15 (Catalina) oder höher
- Internetverbindung (beim ersten Start)
- Ca. 500 MB freier Speicherplatz

## Verwendung

1. Starte **PDF Optimierer.app**
2. Wähle eine oder mehrere PDF-Dateien
3. Wähle **"Glätten für FileMaker"** oder **"Verkleinern (Skalieren)"**
4. Das Original wird als `_original.pdf` gesichert, die neue Datei bekommt den Originalnamen

### Glätten für FileMaker

Konvertiert Vektor-PDFs in gerasterte, FileMaker-kompatible PDFs. Ideal wenn:
- PDFs rote Balken in FileMaker zeigen
- Transparenzen oder komplexe Ebenen Probleme machen
- Technische Zeichnungen schärfer dargestellt werden sollen

### PDF Verkleinern

Skaliert PDFs prozentual (z.B. 50% der Originalgröße). Ideal für:
- E-Mail-Versand
- Kleinere Druckgrößen
- Dateigröße reduzieren

## Update

### Automatisches Update

```bash
cd pdf-optimierer
./update.sh
```

Das Update-Script:
- Prüft auf neue Versionen auf GitHub
- Erstellt automatisch ein Backup
- Aktualisiert sowohl das Repository als auch die App in `/Applications`
- Zeigt Release Notes an

### Manuelles Update

```bash
cd pdf-optimierer
git pull origin main
cp "PDF Optimierer.app" /Applications/
```

## Deinstallation

Um alle von der App installierten Dependencies zu entfernen:

```bash
cd pdf-optimierer
./uninstall_deps.sh
```

Das Script entfernt Ghostscript, ImageMagick, ExifTool, Pillow und PyMuPDF. Homebrew bleibt installiert (mit `--all` wird auch Homebrew entfernt).

## Problemlösung

- **Log-Datei:** `~/Desktop/pdf_optimierer.log`
- **App blockiert:** Systemeinstellungen > Datenschutz & Sicherheit > "Dennoch öffnen"
- **Installation fehlgeschlagen:** Log-Datei prüfen, App erneut starten
- **Permission denied:** `chmod +x "PDF Optimierer.app/Contents/MacOS/PDF_Optimierer"`

## Dependencies

Werden beim ersten Start automatisch installiert:

| Tool | Zweck |
|------|-------|
| Ghostscript | PDF-Rendering |
| ImageMagick | Bildverarbeitung |
| ExifTool | Metadaten |
| PyMuPDF | PDF-Manipulation |
| Pillow | Bildoptimierung |

## Entwicklung

```bash
# Script bearbeiten
nano PDF_Optimierer.sh

# App aktualisieren
cp PDF_Optimierer.sh "PDF Optimierer.app/Contents/MacOS/PDF_Optimierer"
chmod +x "PDF Optimierer.app/Contents/MacOS/PDF_Optimierer"

# Debugging
tail -f ~/Desktop/pdf_optimierer.log
```

## Lizenz

MIT License - siehe [LICENSE](LICENSE)
