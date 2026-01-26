# PDF Optimierer

Eine macOS App zum Glätten und Skalieren von PDFs, optimiert für FileMaker und technische Zeichnungen.

[![Download](https://img.shields.io/badge/Download-Latest%20Release-blue?style=for-the-badge)](https://github.com/Stebibastian/pdf-optimierer/releases/latest)
[![macOS](https://img.shields.io/badge/macOS-10.15+-000000?style=flat-square&logo=apple)](https://www.apple.com/macos/)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

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

### Für Endbenutzer (Einfach)

**Option 1: Direct Download (Empfohlen)**
1. **[📥 Download PDF Optimierer v1.0.1](https://github.com/Stebibastian/pdf-optimierer/releases/latest/download/PDF_Optimierer_v1.0.1.zip)** (nur die App, ~5 KB)
2. Entpacke die ZIP-Datei
3. **Doppelklick auf `PDF Optimierer.app`**
5. **Bei Sicherheitswarnung (nur beim ersten Mal!):**

   macOS blockiert die App. **So öffnest du sie:**

   - Öffne **Systemeinstellungen** → **Datenschutz & Sicherheit**
   - Scrolle nach unten zu: *"PDF Optimierer.app wurde blockiert"*
   - Klicke **"Dennoch öffnen"** → **"Öffnen"** bestätigen

   ✅ Danach startet die App normal und du musst das nie wieder machen!

6. Fertig! Die App installiert alle benötigten Tools automatisch beim ersten Start

**Option 2: Mit Git**
```bash
git clone https://github.com/Stebibastian/pdf-optimierer.git
cd pdf-optimierer
open "PDF Optimierer.app"
```

### Voraussetzungen
- macOS 10.15 (Catalina) oder höher
- Internetverbindung (für automatische Installation der Tools)
- Ca. 500 MB freier Speicherplatz

### Was wird automatisch installiert?
Beim ersten Start installiert die App automatisch:
- ✅ Homebrew (falls nicht vorhanden)
- ✅ Ghostscript
- ✅ ImageMagick
- ✅ ExifTool
- ✅ PyMuPDF (Python-Paket)
- ✅ Pillow (Python-Paket)

⏱️ **Hinweis:** Die Installation kann beim ersten Start 5-10 Minuten dauern. Du wirst über den Fortschritt per Benachrichtigung informiert.

### Manuelle Installation (falls automatisch fehlschlägt)

Falls die automatische Installation nicht funktioniert:

**1. Xcode Command Line Tools installieren:**
```bash
xcode-select --install
```

**2. Homebrew installieren:**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**⚠️ WICHTIG nach Homebrew-Installation:**

Am Ende der Installation zeigt Homebrew zwei Befehle an, die du ausführen musst. Sie sehen so aus:

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
```

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**Kopiere diese Befehle aus DEINEM Terminal** (nicht von hier) und führe sie aus!

Alternativ: **Schließe das Terminal komplett und öffne es neu.**

**3. Tools einzeln installieren:**

Kopiere jeden Befehl einzeln und führe ihn aus:

```bash
brew install ghostscript
```

```bash
brew install imagemagick
```

```bash
brew install exiftool
```

```bash
brew install python3
```

**4. Python-Pakete installieren:**

**Methode 1 (Empfohlen):**
```bash
pip3 install --break-system-packages PyMuPDF
```

```bash
pip3 install --break-system-packages Pillow
```

**Methode 2 (falls Methode 1 nicht klappt):**
```bash
python3 -m pip install PyMuPDF
```

```bash
python3 -m pip install Pillow
```

**5. App erneut starten**

📋 **Bei Problemen:** Siehe Log-Datei `~/Desktop/pdf_optimierer.log`

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

### ⚠️ "App wurde blockiert" - macOS Gatekeeper

**Problem:** Beim ersten Start wird die App von macOS blockiert mit der Meldung *"PDF Optimierer.app wurde blockiert, um deinen Mac zu schützen"*

**Lösung (einfachste Methode):**

1. **Systemeinstellungen** öffnen (oder Systemeinstellungen > Datenschutz & Sicherheit)
2. Scrolle nach unten bis zur Meldung: *"PDF Optimierer.app wurde blockiert"*
3. Klicke auf den Button **"Dennoch öffnen"**
4. Im Bestätigungs-Dialog: Klicke **"Öffnen"**
5. ✅ Die App startet nun und du musst das nie wieder machen

**Alternative Methode:**
- **Rechtsklick** (Ctrl+Klick) auf die App → **"Öffnen"** wählen (statt Doppelklick)
- Im Dialog: **"Öffnen"** bestätigen

**Warum wird die App blockiert?**
Die App ist nicht mit einem Apple Developer Zertifikat signiert (kostet $99/Jahr). Der komplette Quellcode ist hier auf GitHub einsehbar und Open Source - die App ist sicher zu verwenden.

### ❌ "Installation fehlgeschlagen"

**Problem:** Die automatische Installation der Tools schlägt fehl.

**Häufigste Ursachen:**

1. **Xcode Command Line Tools fehlen:**
   ```bash
   xcode-select --install
   ```
   Warte bis die Installation abgeschlossen ist, dann App erneut starten.

2. **Netzwerkprobleme:** Stelle sicher, dass eine Internetverbindung besteht.

3. **Berechtigungen:** Das Terminal-Fenster öffnet sich evtl. und fragt nach dem Admin-Passwort.

**Manuelle Installation (siehe oben):** Falls die automatische Installation mehrfach fehlschlägt, verwende die manuelle Installation.

### ❌ "PDF wurde nicht erstellt"

**Problem:** Die App läuft durch, aber das PDF wird nicht erstellt.

**Lösung:**
1. Prüfe die **Log-Datei** auf dem Desktop: `pdf_optimierer.log`
2. Häufigste Ursachen:
   - **Kein PDF in Preview geöffnet** → Öffne erst ein PDF in Preview
   - **Python-Pakete fehlen** → Siehe "Installation fehlgeschlagen"
   - **Schreibrechte fehlen** → Stelle sicher, dass du Schreibrechte im PDF-Ordner hast
   - **Festplatte voll** → Prüfe freien Speicherplatz (mind. 500 MB)

3. **Debugging:**
   ```bash
   # Script direkt im Terminal testen
   cd "/Pfad/zum/Ordner"
   ./PDF_Optimierer.sh
   ```

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
chmod +x "PDF Optimierer.app/Contents/MacOS/PDF_Optimierer"
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
