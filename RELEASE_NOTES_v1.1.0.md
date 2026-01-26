## 🎉 Neue Features

### Mehrfachauswahl
- **Mehrere PDFs auf einmal** verarbeiten
- **Auswahl merken** - Wähle einmal "Original umbenennen" und alle folgenden Dateien werden automatisch gleich behandelt
- Fortschrittsanzeige zeigt "Datei 2/5" etc.

### Custom DPI
- Zusätzlich zu 200 DPI und 300 DPI kannst du jetzt **eigene DPI-Werte** eingeben (z.B. 150, 250, 400)

### Neue Dateihandling-Option: "Original umbenennen"
- **Original** wird zu `Dokument_original.pdf`
- **Neue Datei** wird zu `Dokument.pdf`
- Perfekt zum direkten Hochladen ohne manuelles Umbenennen!

### Kein Preview mehr nötig
- Direkter **Datei-Picker** statt Preview-Abhängigkeit
- Einfacher und schneller zu bedienen

### Verbesserte Installations-Hilfe
- **Detaillierte Anleitungen** bei Installations-Fehlern
- Schritt-für-Schritt Anweisungen für:
  - Xcode Command Line Tools
  - Homebrew Installation
  - Manuelle Tool-Installation

## ✨ Verbesserungen

- **Keine Zugriffsrechte-Fehler mehr**: Nur noch "Im Finder zeigen" statt Datei öffnen
- **iCloud Drive Support**: Berechtigungsprobleme mit Finder API umgangen
- **Bessere Fortschrittsdialoge**: Bleiben 60 Sekunden sichtbar (statt 2 Sekunden)
- **Popups ersetzen sich**: Neue Dialoge schließen automatisch die vorherigen

## 🐛 Bugfixes

- Bash-Syntax-Fehler durch Apostroph in AppleScript behoben
- Nested quotes in Heredocs korrigiert
- Alle Quote-Probleme in Command Substitutions behoben

## 📦 Installation

1. **ZIP herunterladen** (siehe unten)
2. **Entpacken** (Doppelklick auf ZIP)
3. **App starten** - Beim ersten Start werden alle Tools automatisch installiert

Die App installiert automatisch:
- Homebrew
- Ghostscript
- ImageMagick
- ExifTool
- Python-Pakete (PyMuPDF, Pillow)

---

💡 **Tipp**: Bei mehreren Dateien einmal "Ja, für alle merken" wählen und alle werden automatisch gleich verarbeitet!
