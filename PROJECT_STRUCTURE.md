# Projekt-Struktur

```
pdf-optimierer/
├── README.md                      # Haupt-Dokumentation
├── INSTALL.md                     # Installations-Anleitung
├── CONTRIBUTING.md                # Beitrags-Richtlinien
├── LICENSE                        # MIT Lizenz
├── .gitignore                     # Git Ignores
│
├── PDF_Optimierer.sh             # Haupt-Script (Bash + Python)
├── AppIcon.png                   # App-Icon Quelldatei (1024x1024)
│
├── PDF Optimierer.app/           # macOS App Bundle
│   └── Contents/
│       ├── Info.plist            # App Metadaten
│       ├── MacOS/
│       │   └── PDF_Optimierer    # Ausführbares Script (Kopie)
│       └── Resources/
│           └── AppIcon.icns      # App-Icon (macOS Format)
│
└── pdf_optimierer.log            # Log-Datei (generiert)
```

## Datei-Beschreibungen

### Dokumentation

| Datei | Beschreibung |
|-------|--------------|
| `README.md` | Vollständige Dokumentation, Features, Verwendung, FAQ |
| `INSTALL.md` | Installations-Anleitung mit Troubleshooting |
| `CONTRIBUTING.md` | Guide für Contributors, Code-Richtlinien |
| `LICENSE` | MIT Lizenz |
| `.gitignore` | Git Ignore-Regeln (Logs, macOS Files, etc.) |

### Ressourcen

| Datei | Beschreibung |
|-------|--------------|
| `AppIcon.png` | App-Icon Quelldatei (1024x1024 PNG) |
| `AppIcon.icns` | macOS Icon im App-Bundle (Resources/) |

### Hauptcode

| Datei | Beschreibung | Zeilen |
|-------|--------------|--------|
| `PDF_Optimierer.sh` | Haupt-Script mit allen Funktionen | ~330 |

**Script-Aufbau:**
```bash
1. Funktions-Definitionen (notify, show_dialog, etc.)
2. Dependency-Check & Installation
3. Auswahl-Dialog (Glätten vs. Verkleinern)
4. Verarbeitung:
   a) Verkleinern → Python (PyMuPDF)
   b) Glätten → Ghostscript + Python (Pillow + PyMuPDF)
5. Metadaten kopieren
6. Erfolgs-Dialog & Finder öffnen
```

### App Bundle

```
PDF Optimierer.app/
├── Contents/
│   ├── Info.plist                # Bundle-Info (Name, Version, etc.)
│   ├── MacOS/
│   │   └── PDF_Optimierer        # Haupt-Executable
│   └── Resources/
│       └── AppIcon.icns          # App-Icon (alle Größen: 16-1024px)
```

**Info.plist Schlüssel-Felder:**
- `CFBundleExecutable`: Name des ausführbaren Scripts
- `CFBundleIconFile`: AppIcon (verweist auf Resources/AppIcon.icns)
- `CFBundleIdentifier`: com.local.pdfoptimierer
- `CFBundleName`: PDF Optimierer
- `CFBundleShortVersionString`: 1.2.0

## Workflow-Diagramm

### Glätten für FileMaker
```
User startet App
      ↓
Wählt "Glätten"
      ↓
[Python] Öffne PDF mit PyMuPDF
      ├─> Lese Metadaten
      └─> Lese Dimensionen
      ↓
[Ghostscript] Rendere PDF → PNG (300 DPI)
      ↓
[Python/Pillow] Optimiere Bild
      ├─> Kontrast +60%
      └─> Schärfe +40%
      ↓
[Python/PyMuPDF] PNG → PDF
      ├─> Setze Original-Dimensionen
      └─> Setze Original-Metadaten
      ↓
Speichere als "Name_glatt.pdf"
      ↓
Öffne im Finder
```

### Verkleinern
```
User startet App
      ↓
Wählt "Verkleinern"
      ↓
Gibt Prozent ein (z.B. 50)
      ↓
[Python/PyMuPDF] Öffne PDF
      ↓
Für jede Seite:
      ├─> Berechne neue Größe (50%)
      ├─> Erstelle neue Seite
      └─> Skaliere Inhalt
      ↓
Speichere als "Name_50pct.pdf"
      ↓
Öffne im Finder
```

## Technologie-Stack

### Tools (via Homebrew)
- **Ghostscript 10.x** - PDF Rendering Engine
- **ImageMagick 7.x** - Bildkonvertierung (PNG → PDF)
- **ExifTool 12.x** - Metadaten (Fallback)

### Python-Pakete
- **PyMuPDF 1.26.x** (`fitz`) - PDF Manipulation, Metadaten
- **Pillow 10.x** (`PIL`) - Bildoptimierung (Kontrast, Schärfe)

### Native
- **Bash** - Shell-Scripting, Workflow-Orchestrierung
- **AppleScript** - macOS Dialoge, Preview-Integration
- **osascript** - Benachrichtigungen

## Code-Statistiken

```
PDF_Optimierer.sh:
  - Zeilen: ~330
  - Bash: ~60%
  - Python (embedded): ~30%
  - AppleScript (embedded): ~10%

Funktionen:
  - notify()          → macOS Benachrichtigungen
  - show_dialog()     → Info-Dialoge
  - show_error()      → Fehler-Dialoge
  - Dependency Check  → Automatische Installation
  - Glätten           → Hauptfunktion 1
  - Verkleinern       → Hauptfunktion 2
```

## Externe Dependencies

### Laufzeit (automatisch installiert)
- Homebrew
- Ghostscript, ImageMagick, ExifTool
- PyMuPDF, Pillow

### Build/Entwicklung
- macOS 10.15+
- Xcode Command Line Tools
- Git

### Optional
- GitHub CLI (`gh`) für Pull Requests

## Log-Datei

**Location:** `~/Desktop/pdf_optimierer.log`

**Inhalt:**
```bash
=== PDF Optimierer ===
2026-01-23 15:28:21

✓ Alle Dependencies installiert

Auswahl: Glätten für FileMaker
PDF-Pfad: /path/to/file.pdf

PDF: /path/to/file.pdf
Output: /path/to/file_glatt.pdf

Öffne PDF...
Seiten: 1
Original-Metadaten: {...}

[Ghostscript Output]
✓ Ghostscript Rendering abgeschlossen

[Python Output]
Seite 1/1: Kontrast optimiert ✓

Speichere PDF...
Setze Metadaten: {...}
✓ PDF erstellt (11,512,634 Bytes)

✓ Metadaten wurden direkt in Python gesetzt

=== FERTIG ===
```

## Datenfluss

```
Input: PDF in Preview
  ↓
[App] Hole PDF-Pfad via AppleScript
  ↓
[Bash] Entscheide Funktion (Glätten/Verkleinern)
  ↓
[Python] Verarbeite PDF
  ├─> Temporäre Dateien in /tmp/
  └─> Ausgabe: name_glatt.pdf oder name_Xpct.pdf
  ↓
[Bash] Öffne Finder
  ↓
Output: Optimiertes PDF
```

## Temporäre Dateien

Während der Verarbeitung:
```
/var/folders/.../tmp[random]/
├── page_001.png          # Ghostscript Output
├── page_002.png
├── optimized_1.png       # Pillow Output
├── optimized_2.png
└── [gelöscht nach Abschluss]
```

## Sicherheit

- ✅ Keine externen API-Calls
- ✅ Lokale Verarbeitung
- ✅ Keine Daten werden hochgeladen
- ✅ Temporäre Dateien werden gelöscht
- ✅ Keine Registry/Preferences-Änderungen
- ⚠️ Script hat Zugriff auf Preview-Dokumente

## Performance

Typische Verarbeitungszeiten (M1 Mac):

| PDF-Größe | Seiten | Glätten | Verkleinern |
|-----------|--------|---------|-------------|
| 500 KB | 1 | ~5s | ~1s |
| 2 MB | 5 | ~15s | ~2s |
| 10 MB | 20 | ~60s | ~5s |
| 50 MB | 100 | ~5min | ~20s |

**Limitierende Faktoren:**
- Ghostscript Rendering (CPU-intensiv)
- Seitengröße (große Pläne = mehr Pixel)
- Dateisystem (SSD vs. HDD)

## Speicherbedarf

- **Runtime:** ~200-500 MB RAM
- **Temporär:** ~50-200 MB pro Seite
- **Output:** ~10-20 MB pro geglättete Seite (300 DPI)

## Zukünftige Erweiterungen

Siehe [CONTRIBUTING.md](CONTRIBUTING.md) für Feature-Ideen.
