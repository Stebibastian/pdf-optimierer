# Contributing to PDF Optimierer

Vielen Dank für dein Interesse an PDF Optimierer! 🎉

## Wie kann ich beitragen?

### Bug Reports

Wenn du einen Bug findest:

1. Prüfe ob das Problem bereits als [Issue](https://github.com/DEIN_USERNAME/pdf-optimierer/issues) existiert
2. Falls nicht, erstelle ein neues Issue mit:
   - **Beschreibung:** Was ist passiert?
   - **Erwartetes Verhalten:** Was sollte passieren?
   - **Schritte zur Reproduktion:** Wie kann der Bug nachgestellt werden?
   - **Umgebung:** macOS Version, Hardware
   - **Log-Datei:** Inhalt von `~/Desktop/pdf_optimierer.log`
   - **Screenshot:** Falls relevant

### Feature Requests

Hast du eine Idee für ein neues Feature?

1. Prüfe ob die Idee bereits als [Issue](https://github.com/DEIN_USERNAME/pdf-optimierer/issues) existiert
2. Öffne ein neues Issue mit:
   - **Beschreibung:** Was soll das Feature tun?
   - **Use Case:** Wofür wird es benötigt?
   - **Alternativen:** Gibt es Workarounds?

### Pull Requests

1. **Fork** das Repository
2. **Clone** deinen Fork:
   ```bash
   git clone https://github.com/DEIN_USERNAME/pdf-optimierer.git
   cd pdf-optimierer
   ```

3. **Erstelle einen Branch:**
   ```bash
   git checkout -b feature/mein-feature
   ```

4. **Mache deine Änderungen:**
   - Editiere `PDF_Optimierer.sh`
   - Teste gründlich
   - Update die README falls nötig

5. **Baue die App neu:**
   ```bash
   cp PDF_Optimierer.sh "PDF Optimierer.app/Contents/MacOS/PDF_Optimierer"
   chmod +x "PDF Optimierer.app/Contents/MacOS/PDF_Optimierer"
   ```

6. **Commit deine Änderungen:**
   ```bash
   git add .
   git commit -m "Add: Beschreibung deiner Änderung"
   ```

7. **Push zu GitHub:**
   ```bash
   git push origin feature/mein-feature
   ```

8. **Erstelle einen Pull Request** auf GitHub

## Code-Richtlinien

### Shell Script
- Verwende `#!/bin/bash` als Shebang
- Kommentiere komplexe Logik
- Nutze aussagekräftige Variablennamen
- Fehlerbehandlung mit `set -e` wo sinnvoll

### Python (Embedded)
- PEP 8 Stil wo möglich
- Kommentiere nicht-triviale Operationen
- Fehlerbehandlung mit try/except
- Ausgaben für Debugging mit `print()`

### Commit Messages
Verwende das Format:
```
Type: Kurze Beschreibung

- Detail 1
- Detail 2
```

**Types:**
- `Add:` Neues Feature
- `Fix:` Bug Fix
- `Update:` Verbesserung
- `Docs:` Dokumentation
- `Refactor:` Code-Umstrukturierung
- `Test:` Tests hinzugefügt

**Beispiele:**
```
Add: Batch-Verarbeitung für mehrere PDFs

- Fügt Dialog zur Auswahl mehrerer PDFs hinzu
- Verarbeitet PDFs sequentiell
- Zeigt Fortschritt für jede Datei
```

```
Fix: Metadaten gehen bei Skalierung verloren

- Kopiert jetzt alle Metadaten auch beim Skalieren
- Testet auf PDF mit vollständigen Metadaten
```

## Testing

Vor dem Pull Request:

1. **Teste beide Funktionen:**
   - Glätten für FileMaker
   - PDF Verkleinern

2. **Teste mit verschiedenen PDFs:**
   - Klein (1 Seite)
   - Groß (10+ Seiten)
   - Mit/ohne Metadaten
   - Verschiedene Seitengrößen

3. **Prüfe Log-Datei:**
   ```bash
   tail -f ~/Desktop/pdf_optimierer.log
   ```

4. **Teste Fehlerbehandlung:**
   - Kein PDF geöffnet
   - Ungültige Eingaben
   - Abbruch durch User

## Entwicklungsumgebung

### Voraussetzungen
```bash
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Dependencies
brew install ghostscript imagemagick exiftool

# Python packages
pip3 install PyMuPDF Pillow --break-system-packages
```

### Debugging
```bash
# Script direkt ausführen
./PDF_Optimierer.sh

# Log live verfolgen
tail -f ~/Desktop/pdf_optimierer.log

# App-Bundle inspizieren
ls -la "PDF Optimierer.app/Contents/MacOS/"
```

## Architektur

```
PDF_Optimierer.sh
├── Dependency Check & Installation
├── Dialog: Funktionsauswahl
│
├── Verkleinern
│   ├── Dialog: Prozent-Eingabe
│   └── Python: PyMuPDF Skalierung
│
└── Glätten für FileMaker
    ├── Python: Metadaten auslesen (PyMuPDF)
    ├── Ghostscript: PDF → PNG (300 DPI)
    ├── Python: Kontrast/Schärfe (Pillow)
    └── Python: PNG → PDF mit Metadaten (PyMuPDF)
```

## Ideen für zukünftige Features

- [ ] Batch-Verarbeitung mehrerer PDFs
- [ ] Drag & Drop Support
- [ ] Anpassbare DPI-Einstellung
- [ ] OCR-Integration
- [ ] Wasserzeichen hinzufügen
- [ ] Support für andere PDF-Viewer (Adobe Reader, etc.)
- [ ] Progress Bar statt nur Benachrichtigungen
- [ ] PDF/A Konvertierung
- [ ] Konfigurationsdatei für Default-Einstellungen
- [ ] Command-Line Interface (CLI)

Hast du andere Ideen? Öffne ein Issue!

## Code of Conduct

- Sei respektvoll und konstruktiv
- Hilf anderen bei Problemen
- Dokumentiere deine Änderungen
- Teste vor dem Pull Request

## Fragen?

Öffne ein [Issue](https://github.com/DEIN_USERNAME/pdf-optimierer/issues) oder schreibe eine E-Mail.

Danke für deine Beiträge! 🚀
