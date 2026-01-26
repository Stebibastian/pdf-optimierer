# PDF Optimierer - Development Log

## Projekt-Übersicht

**Repository**: https://github.com/Stebibastian/pdf-optimierer
**Aktuelle Version**: v1.1.2
**macOS App**: PDF Optimierer.app
**Hauptskript**: PDF_Optimierer.sh

## Wichtige Dateien

```
/Users/realview/Library/Mobile Documents/com~apple~CloudDocs/GitHub/pdf-optimierer/
├── PDF_Optimierer.sh                    # Haupt-Bash-Skript
├── PDF Optimierer.app/                  # macOS App Bundle
│   ├── Contents/
│   │   ├── Info.plist                   # Version: 1.1.2, Build: 4
│   │   ├── MacOS/PDF_Optimierer         # Kopie des Hauptskripts
│   │   └── Resources/AppIcon.icns       # App-Icon
├── README.md                            # Dokumentation
├── DEVELOPMENT_LOG.md                   # Diese Datei - Entwicklungsdokumentation
└── .gitignore                           # Git-Ignores
```

## Funktionen

### 1. Verkleinern (Skalieren)
- Skaliert PDF auf X% der Originalgröße
- Nutzt PyMuPDF (fitz) für PDF-Manipulation
- Erhält Seitenverhältnis bei

### 2. Glätten für FileMaker
- Rendert PDF-Seiten zu PNG mit Ghostscript
- Wendet Kontrast-/Schärfe-Optimierung mit Pillow an
- Unterstützt 200 DPI, 300 DPI oder eigenen Wert
- Setzt Original-Metadaten zurück

### 3. Mehrfachauswahl
- Wähle mehrere PDFs auf einmal
- "Merken"-Funktion: Wende Aktion auf alle Dateien an

### 4. Datei-Aktionen
- **Beide behalten**: Original + neue Datei (mit Suffix)
- **Original umbenennen**: Original → `*_original.pdf`, neue Datei → Originalname
- **Original ersetzen**: Neue Datei ersetzt Original

## Dependencies

### System-Tools (via Homebrew)
- **ghostscript** - PDF → PNG Rendering
- **imagemagick** - Bildverarbeitung
- **exiftool** - Metadaten-Manipulation
- **python3** - Python Runtime

### Python-Pakete (via pip3)
- **PyMuPDF** (fitz) - PDF-Manipulation
- **Pillow** (PIL) - Bildoptimierung

### Installation
```bash
# Xcode Command Line Tools
xcode-select --install

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Tools
brew install ghostscript imagemagick exiftool python3

# Python-Pakete
pip3 install PyMuPDF Pillow --break-system-packages
```

## Versionshistorie

### v1.1.2 (26.01.2026) - AKTUELL
**Kritischer Bugfix für ältere macOS-Versionen**

**Problem**:
- Auf macOS < Sequoia gab osascript IMKClient/IMKInputSession-Warnungen auf stderr
- Mit `2>&1` wurden diese in Variablen umgeleitet
- Resultat: `FileNotFoundError` beim Versuch, Warnung als Dateipfad zu öffnen

**Lösung**:
- Alle osascript-Aufrufe verwenden jetzt `2>/dev/null`
- Vorher: `pdf_paths=$(osascript 2>&1 <<'APPLESCRIPT'`
- Nachher: `pdf_paths=$(osascript <<'APPLESCRIPT' 2>/dev/null`

**Geänderte osascript-Aufrufe**:
- PDF-Dateiauswahl (Zeile 141)
- Funktionsauswahl-Dialog (Zeile 165)
- Prozent-Eingabe für Skalieren (Zeile 184)
- DPI-Auswahl für Glätten (Zeile 198)
- Custom DPI-Eingabe (Zeile 221)

**WICHTIG**: Die osascript-Aufrufe in der **Replace-Choice-Logik** verwenden weiterhin `2>&1`, weil dort echte Fehler gefangen werden müssen!

### v1.1.1 (26.01.2026)
**Bessere Dependency-Prüfung**

- Prüft vor "Glätten" ob Ghostscript, PyMuPDF, Pillow installiert sind
- Zeigt klare Fehlermeldung mit Installationsanweisungen
- Verhindert "PDF wurde nicht erstellt" ohne Erklärung

### v1.1.0 (23.01.2026)
**Major Feature Release**

- ✅ Mehrfachauswahl von PDFs
- ✅ Custom DPI-Option (neben 200/300 DPI)
- ✅ "Für alle merken"-Funktion
- ✅ "Original umbenennen"-Option
- ✅ Verbesserte Installations-Hilfe
- ✅ 60-Sekunden Popups (statt 2-3 Sek)
- ✅ Finder-API statt shell-Befehle (für iCloud Drive)

## Bekannte Probleme & Lösungen

### Problem: iCloud Drive "Operation not permitted"
**Symptom**: `cp`, `ditto`, `rsync` scheitern in iCloud Drive
**Lösung**: Verwende Finder API via AppleScript
```bash
rename_result=$(osascript 2>&1 <<RENAMESCRIPT
tell application "Finder"
    try
        set sourceFile to POSIX file "$output_path" as alias
        set targetName to "$pdf_basename"
        set name of sourceFile to targetName
        return "SUCCESS"
    on error errMsg
        return "ERROR: " & errMsg
    end try
end tell
RENAMESCRIPT
)
```

### Problem: Nested Quotes in Heredocs
**Symptom**: Bash syntax errors bei Apostrophen
**Lösung**:
- Verwende `<<'HEREDOC'` für Single-Quotes
- Extrahiere Variablen vor Heredoc: `output_basename=$(basename "$output_path")`

### Problem: osascript stderr auf älteren macOS
**Symptom**: IMKClient-Warnungen landen in Variablen
**Lösung**: `2>/dev/null` bei osascript (siehe v1.1.2)

## Entwicklungs-Workflow

### Änderungen machen
1. Editiere `PDF_Optimierer.sh`
2. Kopiere zu App-Bundle:
   ```bash
   cp "PDF_Optimierer.sh" "PDF Optimierer.app/Contents/MacOS/PDF_Optimierer"
   chmod +x "PDF Optimierer.app/Contents/MacOS/PDF_Optimierer"
   ```
3. Update `Info.plist` (Version & Build)
4. Touch App für Datum:
   ```bash
   touch "PDF Optimierer.app"
   touch "PDF Optimierer.app/Contents/Info.plist"
   ```

### Release erstellen
```bash
# ZIP erstellen
ditto -c -k --sequesterRsrc --keepParent "PDF Optimierer.app" PDF_Optimierer_v1.1.2.zip

# Git commit
git add -A
git commit -m "v1.1.2 - Beschreibung"
git push

# GitHub Release (gh CLI muss installiert sein)
gh release create v1.1.2 \
  PDF_Optimierer_v1.1.2.zip \
  --title "v1.1.2 - Titel" \
  --notes-file RELEASE_NOTES_v1.1.2.md
```

### GitHub CLI Setup
```bash
# Installieren
brew install gh

# Authentifizieren
gh auth login
# Wähle: GitHub.com → HTTPS → Login with web browser
# Kopiere One-Time-Code und öffne URL
```

## Code-Struktur

### Haupt-Workflow (PDF_Optimierer.sh)

```
1. Logging Setup (~/Desktop/pdf_optimierer.log)
2. Dependency-Check & Installation
   - Homebrew
   - Ghostscript, ImageMagick, exiftool, python3
   - PyMuPDF, Pillow
3. PDF-Auswahl (osascript file picker)
4. Funktionsauswahl (Skalieren / Glätten)
5. Parameter-Abfrage (vor Loop!)
   - Skalieren: Prozent
   - Glätten: DPI (200/300/Custom) + Dependency-Check
6. Loop über alle PDFs
   - Verarbeitung (Python-Script via heredoc)
   - Replace-Choice-Dialog
   - Datei-Aktionen (Beide/Umbenennen/Ersetzen)
7. Fertig!
```

### Python-Verarbeitung

**Skalieren**:
```python
import fitz
doc = fitz.open(pdf_path)
output_doc = fitz.open()
for page in doc:
    new_page = output_doc.new_page(width=w*scale, height=h*scale)
    new_page.show_pdf_page(new_page.rect, doc, page_num)
output_doc.save(output_path)
```

**Glätten**:
```python
import fitz, PIL, subprocess
# 1. PDF → PNG (Ghostscript)
gs_cmd = ['gs', '-sDEVICE=png16m', f'-r{dpi}', ...]
# 2. PNG optimieren (Pillow)
img = Image.open(png)
enhancer = ImageEnhance.Contrast(img)
img = enhancer.enhance(1.2)
# 3. PNG → PDF (PyMuPDF)
output_doc = fitz.open()
new_page.insert_image(rect, filename=png)
output_doc.save(output_path)
```

## Wichtige Code-Locations

### PDF-Auswahl (Zeile 141-154)
```bash
pdf_paths=$(osascript <<'APPLESCRIPT' 2>/dev/null
try
    set thePDFs to choose file with prompt "..." of type {"com.adobe.pdf"} with multiple selections allowed
    # ... return posixPaths
end try
APPLESCRIPT
)
```

### Dependency-Check für Glätten (Zeile 240-274)
```bash
MISSING_DEPS=""
if ! command -v gs &> /dev/null; then
    MISSING_DEPS="${MISSING_DEPS}• Ghostscript (gs)\n"
fi
if ! /opt/homebrew/bin/python3 -c "import fitz" 2>/dev/null; then
    MISSING_DEPS="${MISSING_DEPS}• PyMuPDF (Python-Bibliothek)\n"
fi
# ... Fehlermeldung anzeigen wenn MISSING_DEPS nicht leer
```

### Replace-Choice mit "Merken" (Zeile 242-294)
```bash
remember_choice=""
while IFS= read -r pdf_path; do
    if [ -z "$remember_choice" ]; then
        # Frage Dialog + "Für alle merken?"
        if [[ "$replace_choice" == *"|REMEMBER" ]]; then
            remember_choice="${replace_choice%|REMEMBER}"
        fi
    else
        replace_choice="$remember_choice"
    fi
    # ... Handle replace_choice
done <<< "$pdf_paths"
```

### Original umbenennen (Zeile 341-407 & 500-566)
```bash
# 1. Original → *_original.pdf
rename_original=$(osascript 2>&1 <<RENAMEORIGINAL
tell application "Finder"
    set name of sourceFile to "$original_basename"
end tell
RENAMEORIGINAL
)

# 2. Neue Datei → Originalname
rename_new=$(osascript 2>&1 <<RENAMENEW
tell application "Finder"
    set name of sourceFile to "$pdf_basename"
end tell
RENAMENEW
)
```

## Testing

### Test auf älterem macOS
- User hat macOS < Sequoia
- osascript gibt IMKClient-Warnungen → v1.1.2 fixt das

### Test-Szenarien
1. Einzelne PDF skalieren (50%)
2. Multiple PDFs glätten (300 DPI)
3. Custom DPI (250)
4. "Für alle merken" bei 3+ PDFs
5. Alle Replace-Optionen:
   - Beide behalten
   - Original umbenennen
   - Original ersetzen
6. iCloud Drive (Finder API test)

## Git-Historie

```bash
# Alle Tags anzeigen
git tag

# Letzten Release ansehen
gh release view v1.1.2

# Commits zwischen Versionen
git log v1.1.1..v1.1.2 --oneline
```

## Nächste Schritte / TODOs

- [ ] Eventuell Batch-Modus ohne UI für Automatisierung
- [ ] Fortschrittsbalken für lange Verarbeitungen
- [ ] Einstellungen speichern (letzte DPI-Auswahl)
- [ ] Support für andere Formate (JPEG → PDF)

## Support / Debugging

**Log-Datei**: `~/Desktop/pdf_optimierer.log`

**App manuell starten** (für Fehlerausgabe):
```bash
"/Applications/PDF Optimierer.app/Contents/MacOS/PDF_Optimierer"
```

**Dependencies prüfen**:
```bash
command -v gs && echo "✓ Ghostscript" || echo "✗ Ghostscript fehlt"
command -v convert && echo "✓ ImageMagick" || echo "✗ ImageMagick fehlt"
/opt/homebrew/bin/python3 -c "import fitz" && echo "✓ PyMuPDF" || echo "✗ PyMuPDF fehlt"
/opt/homebrew/bin/python3 -c "from PIL import Image" && echo "✓ Pillow" || echo "✗ Pillow fehlt"
```

## Kontakte

- **GitHub**: @Stebibastian
- **Repository**: https://github.com/Stebibastian/pdf-optimierer
- **Issues**: https://github.com/Stebibastian/pdf-optimierer/issues

---

**Letzte Aktualisierung**: 26.01.2026
**Version**: 1.1.2
**Status**: Produktiv, alle bekannten Bugs gefixt
