# v1.1.1 - Bugfix Release

## 🐛 Fehlerbehebung

### Bessere Dependency-Prüfung
- **Fix**: "PDF wurde nicht erstellt" Fehler bei fehlenden Dependencies
- Die App prüft nun **vor** der Verarbeitung, ob alle benötigten Tools installiert sind
- Bei fehlenden Abhängigkeiten wird eine **klare Fehlermeldung** mit Installationsanweisungen angezeigt
- Betrifft speziell die "Glätten für FileMaker" Funktion, die Ghostscript und Pillow benötigt

### Was wird geprüft?
- ✅ Ghostscript (gs) - für PDF-Rendering
- ✅ PyMuPDF (fitz) - für PDF-Verarbeitung
- ✅ Pillow (PIL) - für Bildoptimierung

### Fehlermeldung
Wenn eine Abhängigkeit fehlt, zeigt die App jetzt:
- Welche Tools/Bibliotheken fehlen
- Die genauen Installationsbefehle
- Hinweis auf manuelle Installation

---

## 📦 Installation

1. Lade `PDF_Optimierer_v1.1.1.zip` herunter
2. Entpacke die ZIP-Datei
3. Bewege `PDF Optimierer.app` in deinen Programme-Ordner
4. Beim ersten Start werden alle Dependencies automatisch installiert

Bei Problemen mit der Installation siehe [README.md](https://github.com/Stebibastian/pdf-optimierer#readme)

---

**Vollständige Änderungen**: https://github.com/Stebibastian/pdf-optimierer/compare/v1.1.0...v1.1.1
