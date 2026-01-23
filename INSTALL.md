# Installation Guide

## Schnellstart (Empfohlen)

1. **Repository klonen oder herunterladen:**
   ```bash
   git clone https://github.com/DEIN_USERNAME/pdf-optimierer.git
   cd pdf-optimierer
   ```

2. **App starten:**
   - Doppelklick auf `PDF Optimierer.app`
   - Die App installiert automatisch alle benötigten Tools

3. **Bei Sicherheitswarnung:**
   - Rechtsklick → "Öffnen"
   - Oder: Systemeinstellungen → Sicherheit → "Trotzdem öffnen"

Das war's! Beim ersten Start werden automatisch installiert:
- Homebrew (falls nicht vorhanden)
- Ghostscript, ImageMagick, ExifTool
- Python-Pakete (PyMuPDF, Pillow)

---

## Manuelle Installation

Falls die automatische Installation nicht funktioniert:

### 1. Homebrew installieren
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Tools installieren
```bash
brew install ghostscript imagemagick exiftool
```

### 3. Python-Pakete installieren
```bash
pip3 install PyMuPDF Pillow --break-system-packages
```

### 4. App ausführbar machen
```bash
chmod +x "PDF Optimierer.app/Contents/MacOS/PDF_Optimierer"
```

---

## Überprüfung

Teste ob alle Tools installiert sind:

```bash
# Ghostscript
gs --version

# ImageMagick
magick --version

# ExifTool
exiftool -ver

# Python-Pakete
python3 -c "import fitz; print('PyMuPDF:', fitz.__version__)"
python3 -c "from PIL import Image; print('Pillow OK')"
```

Erwartete Ausgabe:
```
GPL Ghostscript 10.x.x
Version: ImageMagick 7.x.x
12.x
PyMuPDF: 1.26.x
Pillow OK
```

---

## Deinstallation

### App entfernen
```bash
rm -rf "PDF Optimierer.app"
rm ~/Desktop/pdf_optimierer.log
```

### Tools entfernen (optional)
```bash
brew uninstall ghostscript imagemagick exiftool
pip3 uninstall PyMuPDF Pillow
```

---

## Troubleshooting

### "App kann nicht geöffnet werden"
macOS blockiert Apps von nicht verifizierten Entwicklern:
1. Rechtsklick auf App → "Öffnen"
2. Im Dialog: "Öffnen" bestätigen

### "Permission denied"
```bash
chmod +x PDF_Optimierer.sh
chmod +x "PDF Optimierer.app/Contents/MacOS/PDF_Optimierer"
```

### Homebrew Installation schlägt fehl
1. Xcode Command Line Tools installieren:
   ```bash
   xcode-select --install
   ```
2. Homebrew erneut versuchen

### Python-Pakete können nicht installiert werden
Wenn `pip3 install` fehlschlägt:
```bash
# Mit --user Flag
pip3 install --user PyMuPDF Pillow

# Oder mit sudo (nicht empfohlen)
sudo pip3 install PyMuPDF Pillow
```

### App startet aber macht nichts
1. Prüfe Log-Datei:
   ```bash
   cat ~/Desktop/pdf_optimierer.log
   ```
2. Stelle sicher, dass Preview ein PDF geöffnet hat
3. Teste Script direkt:
   ```bash
   ./PDF_Optimierer.sh
   ```

---

## Systemanforderungen

- **Betriebssystem:** macOS 10.15 (Catalina) oder höher
- **Architektur:** Intel oder Apple Silicon (M1/M2/M3)
- **Speicher:** Mindestens 2 GB RAM
- **Festplatte:** 500 MB für Tools + temporärer Speicher für PDF-Verarbeitung
- **Python:** Version 3.8 oder höher (über Homebrew)

---

## Updates

### App aktualisieren
```bash
cd pdf-optimierer
git pull origin main
```

### Tools aktualisieren
```bash
brew update
brew upgrade ghostscript imagemagick exiftool

pip3 install --upgrade PyMuPDF Pillow
```

---

## Nächste Schritte

Nach der Installation:
1. Lies die [README.md](README.md) für Verwendung
2. Öffne ein Test-PDF in Preview
3. Starte die App und teste beide Funktionen
4. Bei Problemen: [Issues](https://github.com/DEIN_USERNAME/pdf-optimierer/issues)
