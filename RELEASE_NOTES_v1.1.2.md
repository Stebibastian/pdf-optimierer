# v1.1.2 - Kritischer Bugfix für ältere macOS-Versionen

## 🐛 Kritischer Bugfix

### Fix: "PDF wurde nicht erstellt" auf älteren macOS-Versionen
- **Problem**: Auf macOS-Versionen vor Sequoia (< 15.0) gab osascript IMKClient/IMKInputSession-Warnungen auf stderr aus
- Diese Warnungen wurden fälschlicherweise als PDF-Pfade interpretiert
- Resultat: `FileNotFoundError` beim Versuch, die Warnung als Datei zu öffnen
- **Lösung**: Alle osascript-Aufrufe filtern jetzt stderr mit `2>/dev/null`

### Betroffene Funktionen
Dieser Bugfix betrifft **alle** Funktionen:
- ✅ PDF-Datei(en) auswählen
- ✅ Verkleinern (Skalieren)
- ✅ Glätten für FileMaker (alle DPI-Optionen)

### Technische Details
**Vorher:**
```bash
pdf_paths=$(osascript 2>&1 <<'APPLESCRIPT'
```
Problem: `2>&1` leitet stderr nach stdout um → Warnungen landen in der Variable

**Nachher:**
```bash
pdf_paths=$(osascript <<'APPLESCRIPT' 2>/dev/null
```
Lösung: `2>/dev/null` unterdrückt stderr → nur saubere Ausgabe in Variable

---

## 📦 Installation

1. Lade `PDF_Optimierer_v1.1.2.zip` herunter
2. Entpacke die ZIP-Datei
3. Bewege `PDF Optimierer.app` in deinen Programme-Ordner
4. Beim ersten Start werden alle Dependencies automatisch installiert

**Wichtig für User mit älteren macOS-Versionen:** Dieses Update behebt das Problem, dass PDFs nicht verarbeitet werden konnten!

---

**Vollständige Änderungen**: https://github.com/Stebibastian/pdf-optimierer/compare/v1.1.1...v1.1.2
