# Release Notes

## v1.5.0 - Support für große Bauzeichnungen + Auto-Updater

### Neue Features

- **Auto-Updater**: Neues `update.sh` Script für einfache Updates
  - Prüft automatisch auf neue Versionen
  - Erstellt Backups vor dem Update
  - Aktualisiert sowohl Repository als auch `/Applications`
  - Zeigt Release Notes an

### Verbesserungen

- **Große PDFs unterstützt**: Pillow-Limit auf 500 Mio Pixel erhöht
  - Unterstützt jetzt große Bauzeichnungen (A0, A1, etc.)
  - Behebt "DecompressionBombError" bei PDFs > 178 Mio Pixel
  - Typische Architektur- und Ingenieurpläne funktionieren jetzt

### Technische Details

- `Image.MAX_IMAGE_PIXELS = 500000000` in der Glätten-Funktion
- Neues Script: `update.sh` für automatische Updates

---

## v1.4.0 - Rosetta-Fix, vereinfachter Workflow

### Verbesserungen
- Rosetta-Erkennung für Apple Silicon
- Vereinfachter Workflow
- Aufgeräumtes Repository

---

## v1.3.0 - App-Icon und robustere Installation

### Neue Features
- Eigenes App-Icon
- Robustere Dependency-Installation
- Bessere Fehlermeldungen

---

## v1.2.0 - Metadaten-Erhaltung

### Verbesserungen
- Original-Metadaten werden übernommen (Titel, Autor, Datum)
- Bessere DPI-Auswahl

---

## v1.1.0 - Mehrfachauswahl

### Neue Features
- Mehrere PDFs auf einmal verarbeiten
- Fortschrittsanzeige

---

## v1.0.0 - Erste Version

### Features
- Glätten für FileMaker
- PDF Verkleinern (Skalieren)
- Automatische Dependency-Installation
- Original-Erhaltung (_original.pdf)
