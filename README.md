# PDF Optimierer

Eine macOS App zum Glätten und Skalieren von PDFs, optimiert für FileMaker und technische Zeichnungen.

## Features

✅ **Glätten für FileMaker** - Konvertiert PDFs in ein FileMaker-kompatibles Format
- Rendert Vektorgrafiken zu hochauflösenden Bildern (300 DPI)
- Optimiert Kontrast und Schärfe
- Behält Original-Dimensionen bei (1:1)
- Behält Metadaten bei
- Entfernt problematische Transparenzen und Ebenen

✅ **PDF Verkleinern** - Skaliert PDFs prozentual
- Flexible Skalierung (z.B. 50% der Originalgröße)
- Behält Seitenverhältnis bei
- Reduziert Dateigröße

✅ **Automatische Installation**
- Installiert alle benötigten Tools automatisch
- Keine manuelle Konfiguration nötig

✅ **Fortschrittsanzeigen**
- macOS Benachrichtigungen während der Verarbeitung
- Log-Datei für Debugging

## Installation

### Voraussetzungen
- macOS 10.15 oder höher
- Python 3 (über Homebrew installiert)

### Schnellstart

1. **Repository klonen:**
   ```bash
   git clone https://github.com/DEIN_USERNAME/pdf-optimierer.git
   cd pdf-optimierer
   ```

2. **App starten:**
   - Doppelklick auf `PDF Optimierer.app`
   - Beim ersten Start werden automatisch alle Dependencies installiert:
     - Homebrew (falls nicht vorhanden)
     - Ghostscript
     - ImageMagick
     - ExifTool
     - PyMuPDF (fitz)
     - Pillow

3. **Bei Sicherheitswarnung:**
   - Rechtsklick auf die App → "Öffnen"
   - Oder: Systemeinstellungen → Sicherheit → "Trotzdem öffnen"

## Verwendung

### Glätten für FileMaker

1. Öffne ein PDF in **Preview** (Vorschau)
2. Starte **PDF Optimierer.app**
3. Wähle **"Glätten für FileMaker"**
4. Die App erstellt `Dateiname_glatt.pdf` im gleichen Ordner

**Wann verwenden:**
- PDF zeigt rote Balken in FileMaker
- PDF hat Transparenzen oder komplexe Ebenen
- Technische Zeichnungen sollen schärfer dargestellt werden

**Technische Details:**
- Rendert mit Ghostscript (300 DPI)
- Erhöht Kontrast um 60%
- Erhöht Schärfe um 40%
- Behält Original-Dimensionen exakt bei
- Kopiert Metadaten (Titel, Autor, Datum, etc.)

### PDF Verkleinern

1. Öffne ein PDF in **Preview**
2. Starte **PDF Optimierer.app**
3. Wähle **"Verkleinern (Skalieren)"**
4. Gib Prozentsatz ein (z.B. `50` für 50%)
5. Die App erstellt `Dateiname_50pct.pdf`

**Wann verwenden:**
- PDF ist zu groß für E-Mail
- Kleinere Druckgröße gewünscht
- Dateigröße reduzieren

## Ausgabe-Dateien

| Funktion | Dateiname | Beispiel |
|----------|-----------|----------|
| Glätten | `Original_glatt.pdf` | `Plan_2024_glatt.pdf` |
| Verkleinern | `Original_XXpct.pdf` | `Plan_2024_50pct.pdf` |

**Hinweis:** Existierende Dateien werden überschrieben.

## Problemlösung

### App startet nicht
1. Prüfe die Log-Datei: `~/Desktop/pdf_optimierer.log`
2. Stelle sicher, dass Preview ein PDF geöffnet hat
3. Gib der App Ausführungsrechte:
   ```bash
   chmod +x "PDF Optimierer.app/Contents/MacOS/PDF_Optimierer"
   ```

### "Permission denied" Fehler
```bash
chmod +x PDF_Optimierer.sh
```

### Dependencies manuell installieren
Falls die automatische Installation fehlschlägt:

```bash
# Homebrew installieren
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Tools installieren
brew install ghostscript imagemagick exiftool

# Python-Pakete installieren
pip3 install PyMuPDF Pillow --break-system-packages
```

### Metadaten fehlen
Die App kopiert automatisch:
- Titel, Autor, Betreff, Keywords
- Creator, Producer
- Erstellungsdatum, Änderungsdatum

Falls Metadaten fehlen, prüfe ob das Original-PDF Metadaten hat:
```bash
exiftool Original.pdf
```

## Technische Details

### Architektur

```
PDF Optimierer.app/
├── Contents/
│   ├── Info.plist
│   └── MacOS/
│       └── PDF_Optimierer (Shell Script)
```

### Workflow: Glätten für FileMaker

```
1. PDF öffnen mit PyMuPDF
   └─> Metadaten auslesen
   └─> Dimensionen jeder Seite auslesen

2. Mit Ghostscript zu PNG rendern (300 DPI)
   └─> Hohe Qualität, professionelles Antialiasing

3. Bildoptimierung mit Pillow
   └─> Kontrast +60%
   └─> Schärfe +40%

4. Neues PDF erstellen mit PyMuPDF
   └─> Exakte Original-Dimensionen
   └─> Original-Metadaten setzen
   └─> Hochqualitative Kompression
```

### Workflow: Verkleinern

```
1. PDF öffnen mit PyMuPDF
2. Für jede Seite:
   └─> Neue Seite mit skalierter Größe erstellen
   └─> Original-Inhalt einpassen
3. Mit Kompression speichern
```

## Dependencies

| Tool | Zweck | Version |
|------|-------|---------|
| Ghostscript | PDF → PNG Rendering | ≥ 10.x |
| ImageMagick | Bildverarbeitung | ≥ 7.x |
| ExifTool | Metadaten (optional) | ≥ 12.x |
| PyMuPDF | PDF-Manipulation | ≥ 1.26 |
| Pillow | Bildoptimierung | ≥ 10.x |

## Bekannte Einschränkungen

- ⚠️ Bei sehr großen PDFs (>100 Seiten) kann die Verarbeitung mehrere Minuten dauern
- ⚠️ Bei sehr großen Seitenformaten (z.B. A0) erscheint eine Warnung (DecompressionBombWarning) - kann ignoriert werden
- ⚠️ Ausgabe-Datei überschreibt existierende Dateien mit gleichem Namen
- ⚠️ PDF muss in Preview geöffnet sein (andere PDF-Viewer werden nicht unterstützt)

## Entwicklung

### Projekt-Struktur
```
pdf-optimierer/
├── README.md                    # Diese Datei
├── PDF_Optimierer.sh           # Haupt-Script
├── PDF Optimierer.app/         # macOS App Bundle
└── pdf_optimierer.log          # Log-Datei (generiert)
```

### Script bearbeiten

1. Script editieren:
   ```bash
   nano PDF_Optimierer.sh
   ```

2. App neu bauen:
   ```bash
   cp PDF_Optimierer.sh "PDF Optimierer.app/Contents/MacOS/PDF_Optimierer"
   chmod +x "PDF Optimierer.app/Contents/MacOS/PDF_Optimierer"
   ```

### Debugging

Log-Datei anzeigen:
```bash
tail -f ~/Desktop/pdf_optimierer.log
```

Script direkt ausführen:
```bash
./PDF_Optimierer.sh
```

## FAQ

**Q: Warum wird das PDF so groß (10-15 MB)?**
A: Das geglättete PDF enthält hochauflösende Bilder (300 DPI) statt Vektorgrafiken. Das garantiert beste Qualität und FileMaker-Kompatibilität.

**Q: Kann ich die Qualität/DPI ändern?**
A: Ja, im Script die Zeile `-r300` ändern (z.B. `-r200` für 200 DPI, kleinere Datei aber weniger scharf).

**Q: Funktioniert es mit anderen PDF-Viewern?**
A: Nein, aktuell nur mit Preview. Andere Viewer können hinzugefügt werden.

**Q: Kann ich mehrere PDFs gleichzeitig verarbeiten?**
A: Nein, nur ein PDF pro Durchlauf. Batch-Verarbeitung könnte hinzugefügt werden.

**Q: Warum Ghostscript statt PyMuPDF zum Rendern?**
A: Ghostscript liefert bessere Qualität bei technischen Zeichnungen und hat professionelleres Antialiasing.

## Lizenz

MIT License - siehe [LICENSE](LICENSE) Datei

## Credits

Entwickelt für die Optimierung technischer Zeichnungen und CAD-Pläne für FileMaker-Datenbanken.

**Tools:**
- [Ghostscript](https://www.ghostscript.com/) - PDF-Rendering
- [PyMuPDF](https://pymupdf.readthedocs.io/) - PDF-Manipulation
- [Pillow](https://python-pillow.org/) - Bildverarbeitung
- [ImageMagick](https://imagemagick.org/) - Bildkonvertierung
- [ExifTool](https://exiftool.org/) - Metadaten-Verwaltung

## Changelog

### Version 1.0.0 (2026-01-23)
- ✨ Initiale Version
- ✨ Glätten für FileMaker mit Kontrast-Optimierung
- ✨ PDF Verkleinern/Skalieren
- ✨ Automatische Dependency-Installation
- ✨ Fortschrittsanzeigen via macOS Notifications
- ✨ Metadaten-Erhaltung
- ✨ Original-Dimensionen bleiben erhalten

## Support

Bei Problemen:
1. Prüfe die Log-Datei: `~/Desktop/pdf_optimierer.log`
2. Öffne ein [Issue auf GitHub](https://github.com/DEIN_USERNAME/pdf-optimierer/issues)
3. Inkludiere:
   - macOS Version
   - Log-Datei
   - Beispiel-PDF (falls möglich)

---

Made with ❤️ for better PDF handling in FileMaker
