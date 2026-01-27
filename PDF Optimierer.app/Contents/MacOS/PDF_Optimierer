#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Funktion für Benachrichtigungen
notify() {
    osascript -e "display notification \"$2\" with title \"PDF Optimierer\" subtitle \"$1\""
}

# Funktion für Dialogs
show_dialog() {
    osascript -e "display dialog \"$1\" with title \"PDF Optimierer\" buttons {\"OK\"} default button 1"
}

# Funktion für Fehler-Dialogs
show_error() {
    osascript -e "display dialog \"❌ Fehler: $1\" with title \"PDF Optimierer\" buttons {\"OK\"} default button 1 with icon stop"
}

# Logging
LOG_FILE="$HOME/Desktop/pdf_optimierer.log"
exec > "$LOG_FILE" 2>&1

echo "=== PDF Optimierer ==="
echo "$(date)"
echo ""

# Schritt 1: Prüfe und installiere Dependencies
notify "Prüfe System" "Überprüfe installierte Tools..."

NEED_INSTALL=()
INSTALL_FAILED=0

# Prüfe Homebrew
if ! command -v brew &> /dev/null; then
    # Prüfe ob Xcode Command Line Tools installiert sind
    if ! xcode-select -p &> /dev/null; then
        notify "Installation 1/4" "Xcode Command Line Tools werden installiert..."

        # Starte Installation automatisch
        xcode-select --install 2>&1

        # Warte auf Bestätigung vom User
        osascript <<'XCODE_WAIT'
display dialog "📦 Xcode Command Line Tools werden installiert

Ein System-Dialog sollte sich geöffnet haben.

✅ Bitte klicke dort auf \"Installieren\" und warte, bis die Installation abgeschlossen ist (5-10 Minuten).

Danach klicke hier auf \"Weiter\", um fortzufahren." buttons {"Weiter"} default button 1 with title "PDF Optimierer - Installation 1/4" with icon note
XCODE_WAIT

        # Prüfe nochmal ob jetzt installiert
        if ! xcode-select -p &> /dev/null; then
            osascript <<'XCODE_FAILED'
display dialog "⚠️ Xcode Command Line Tools nicht installiert!

Die Installation wurde abgebrochen oder ist fehlgeschlagen.

📋 MANUELLE INSTALLATION - Schritt für Schritt:

═══════════════════════════════════════

SCHRITT 1: Xcode Tools installieren
───────────────────────────────────────
Kopiere diesen Befehl ins Terminal:

xcode-select --install

Klicke im Dialog auf \"Installieren\" und warte 5-10 Min.

═══════════════════════════════════════

Nach der Installation starte diese App erneut!" buttons {"Terminal öffnen", "Abbrechen"} default button 1 with title "PDF Optimierer - Manuelle Installation" with icon stop
XCODE_FAILED

            # Öffne Terminal für den User
            open -a Terminal
            exit 1
        fi
    fi

    notify "Installation 2/4" "Homebrew wird installiert... (kann 5-10 Min dauern)"

    # Installiere Homebrew im Terminal (interaktiv)
    osascript <<'BREW_START'
display dialog "📦 Homebrew wird jetzt installiert

Ein Terminal-Fenster öffnet sich.

⚠️ WICHTIG:
• Das Terminal fragt nach deinem Mac-Passwort
• Drücke RETURN wenn gefragt wird
• Warte bis \"Installation successful\" erscheint

✅ Am Ende zeigt Homebrew 2 Befehle an - führe diese aus, oder schließe das Terminal komplett und öffne es neu.

Danach klicke hier auf \"Weiter\"." buttons {"Weiter"} default button 1 with title "PDF Optimierer - Installation 2/4" with icon note
BREW_START

    # Öffne Terminal und führe Installation aus
    osascript -e 'tell application "Terminal" to do script "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""'

    # Warte auf Bestätigung
    osascript <<'BREW_WAIT'
display dialog "Ist die Homebrew-Installation abgeschlossen?

✅ Prüfe im Terminal ob dort \"Installation successful\" steht

⚠️ Hast du die 2 Befehle am Ende ausgeführt (oder Terminal neu gestartet)?

Dann klicke auf \"Fertig\" um fortzufahren." buttons {"Fertig"} default button 1 with title "PDF Optimierer - Installation 2/4" with icon note
BREW_WAIT

    # Füge Homebrew zum PATH hinzu für diese Session
    export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null || true)"

    # Prüfe ob Homebrew jetzt verfügbar ist
    if ! command -v brew &> /dev/null; then
        osascript <<'BREW_FAILED'
display dialog "⚠️ Homebrew nicht gefunden!

Die Installation wurde möglicherweise abgebrochen oder die Pfad-Befehle wurden nicht ausgeführt.

📋 MANUELLE INSTALLATION - Schritt für Schritt:

═══════════════════════════════════════

SCHRITT 1: Xcode Tools (falls noch nicht gemacht)
───────────────────────────────────────
xcode-select --install

═══════════════════════════════════════

SCHRITT 2: Homebrew installieren
───────────────────────────────────────
/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"

⚠️ WICHTIG: Am Ende 2 Befehle ausführen oder Terminal neu starten!

═══════════════════════════════════════

SCHRITT 3: Tools installieren
───────────────────────────────────────
brew install ghostscript
brew install imagemagick
brew install exiftool
brew install python3

═══════════════════════════════════════

SCHRITT 4: Python-Pakete installieren
───────────────────────────────────────
pip3 install PyMuPDF Pillow

Falls Fehler, versuche:
pip3 install PyMuPDF Pillow --break-system-packages

═══════════════════════════════════════

Danach diese App erneut starten!" buttons {"Terminal öffnen", "Abbrechen"} default button 1 with title "PDF Optimierer - Manuelle Installation" with icon stop
BREW_FAILED

        open -a Terminal
        INSTALL_FAILED=1
    else
        notify "✓ Homebrew installiert" "Installation 2/4 abgeschlossen"
    fi
fi

# Prüfe Ghostscript
if ! command -v gs &> /dev/null; then
    NEED_INSTALL+=("ghostscript")
fi

# Prüfe ImageMagick
if ! command -v magick &> /dev/null; then
    NEED_INSTALL+=("imagemagick")
fi

# Prüfe exiftool
if ! command -v exiftool &> /dev/null; then
    NEED_INSTALL+=("exiftool")
fi

# Prüfe ob Python3 installiert werden muss
if ! command -v python3 &> /dev/null; then
    NEED_INSTALL+=("python3")
fi

# Installiere fehlende Tools
if [ ${#NEED_INSTALL[@]} -gt 0 ] && [ $INSTALL_FAILED -eq 0 ]; then
    notify "Installation 3/4" "Installiere ${#NEED_INSTALL[@]} Tool(s)... (kann einige Minuten dauern)"

    if ! brew install "${NEED_INSTALL[@]}" 2>&1; then
        osascript <<TOOLS_FAILED
display dialog "⚠️ Tool-Installation fehlgeschlagen!

Die automatische Installation konnte nicht abgeschlossen werden.

📋 MANUELLE INSTALLATION - Schritt für Schritt:

═══════════════════════════════════════

SCHRITT 3: Tools installieren
───────────────────────────────────────
Kopiere diese Befehle EINZELN ins Terminal:

brew install ghostscript

brew install imagemagick

brew install exiftool

brew install python3

═══════════════════════════════════════

SCHRITT 4: Python-Pakete installieren
───────────────────────────────────────
pip3 install PyMuPDF Pillow

Falls Fehler, versuche:
pip3 install PyMuPDF Pillow --break-system-packages

═══════════════════════════════════════

📄 Details im Log: ~/Desktop/pdf_optimierer.log

Danach diese App erneut starten!" buttons {"Terminal öffnen", "Abbrechen"} default button 1 with title "PDF Optimierer - Manuelle Installation" with icon stop
TOOLS_FAILED
        open -a Terminal
        INSTALL_FAILED=1
    else
        notify "✓ Tools installiert" "Installation 3/4 abgeschlossen"
    fi
fi

# Prüfe Python nochmal (falls gerade installiert)
if ! command -v python3 &> /dev/null && [ $INSTALL_FAILED -eq 0 ]; then
    osascript <<'PYTHON_MISSING'
display dialog "⚠️ Python 3 nicht gefunden!

📋 Bitte installiere Python 3:

brew install python3

Danach diese App erneut starten!" buttons {"Terminal öffnen", "Abbrechen"} default button 1 with title "PDF Optimierer" with icon stop
PYTHON_MISSING
    open -a Terminal
    exit 1
fi

# Prüfe PyMuPDF
if ! python3 -c "import fitz" 2>/dev/null && [ $INSTALL_FAILED -eq 0 ]; then
    notify "Installation 4/4" "Installiere PyMuPDF..."

    # Methode 1: Normaler pip install (funktioniert auf neueren Systemen)
    if ! pip3 install PyMuPDF 2>&1; then
        # Methode 2: Mit --user Flag (funktioniert auf älteren pip-Versionen)
        if ! pip3 install --user PyMuPDF 2>&1; then
            # Methode 3: python3 -m pip (funktioniert wenn pip3 nicht im PATH)
            if ! python3 -m pip install PyMuPDF 2>&1; then
                # Methode 4: Mit --break-system-packages (neuere pip-Versionen)
                if ! pip3 install PyMuPDF --break-system-packages 2>&1; then
                    osascript <<'PYMUPDF_FAILED'
display dialog "⚠️ PyMuPDF Installation fehlgeschlagen!

📋 MANUELLE INSTALLATION - Probiere diese Befehle:

═══════════════════════════════════════

SCHRITT 4a: PyMuPDF installieren
───────────────────────────────────────
Methode 1 (zuerst probieren):
pip3 install PyMuPDF

Methode 2 (falls Methode 1 fehlschlägt):
pip3 install --user PyMuPDF

Methode 3 (falls pip3 nicht gefunden):
python3 -m pip install PyMuPDF

Methode 4 (nur bei \"externally-managed\" Fehler):
pip3 install PyMuPDF --break-system-packages

═══════════════════════════════════════

📄 Log: ~/Desktop/pdf_optimierer.log

Danach diese App erneut starten!" buttons {"Terminal öffnen", "Abbrechen"} default button 1 with title "PDF Optimierer - Manuelle Installation" with icon stop
PYMUPDF_FAILED
                    open -a Terminal
                    INSTALL_FAILED=1
                fi
            fi
        fi
    fi
fi

# Prüfe Pillow
if ! python3 -c "from PIL import Image" 2>/dev/null && [ $INSTALL_FAILED -eq 0 ]; then
    notify "Installation 4/4" "Installiere Pillow..."

    # Methode 1: Normaler pip install
    if ! pip3 install Pillow 2>&1; then
        # Methode 2: Mit --user Flag
        if ! pip3 install --user Pillow 2>&1; then
            # Methode 3: python3 -m pip
            if ! python3 -m pip install Pillow 2>&1; then
                # Methode 4: Mit --break-system-packages
                if ! pip3 install Pillow --break-system-packages 2>&1; then
                    osascript <<'PILLOW_FAILED'
display dialog "⚠️ Pillow Installation fehlgeschlagen!

📋 MANUELLE INSTALLATION - Probiere diese Befehle:

═══════════════════════════════════════

SCHRITT 4b: Pillow installieren
───────────────────────────────────────
Methode 1 (zuerst probieren):
pip3 install Pillow

Methode 2 (falls Methode 1 fehlschlägt):
pip3 install --user Pillow

Methode 3 (falls pip3 nicht gefunden):
python3 -m pip install Pillow

Methode 4 (nur bei \"externally-managed\" Fehler):
pip3 install Pillow --break-system-packages

═══════════════════════════════════════

📄 Log: ~/Desktop/pdf_optimierer.log

Danach diese App erneut starten!" buttons {"Terminal öffnen", "Abbrechen"} default button 1 with title "PDF Optimierer - Manuelle Installation" with icon stop
PILLOW_FAILED
                    open -a Terminal
                    INSTALL_FAILED=1
                fi
            fi
        fi
    fi
fi

if [ $INSTALL_FAILED -eq 1 ]; then
    # Zeige ausführliche Installations-Anleitung - dieser Code wird nur erreicht,
    # wenn eine der spezifischen Installationen bereits einen Dialog gezeigt hat
    exit 1
fi

echo "✓ Alle Dependencies installiert"
notify "Bereit!" "Alle Tools sind installiert"
echo ""

# Schritt 2: Wähle PDF-Datei(en)
pdf_paths=$(osascript <<'APPLESCRIPT' 2>/dev/null
try
    set thePDFs to choose file with prompt "Wähle PDF-Datei(en) zum Optimieren:" of type {"com.adobe.pdf"} with multiple selections allowed
    set posixPaths to {}
    repeat with aPDF in thePDFs
        set end of posixPaths to POSIX path of aPDF
    end repeat
    set text item delimiters to linefeed
    return posixPaths as text
on error
    return "ABGEBROCHEN"
end try
APPLESCRIPT
)

if [[ "$pdf_paths" == "ABGEBROCHEN" ]] || [[ -z "$pdf_paths" ]]; then
    exit 0
fi

# Zähle Anzahl Dateien
file_count=$(echo "$pdf_paths" | wc -l | tr -d ' ')
echo "Anzahl Dateien: $file_count"

# Schritt 3: Zeige Auswahl-Dialog
choice=$(osascript <<APPLESCRIPT 2>/dev/null
try
    set theChoice to button returned of (display dialog "Was möchten Sie tun mit $file_count Datei(en)?" buttons {"Abbrechen", "Verkleinern (Skalieren)", "Glätten für FileMaker"} default button 3 with title "PDF Optimierer")
    return theChoice
on error
    return "ABGEBROCHEN"
end try
APPLESCRIPT
)

echo "Auswahl: $choice"

if [[ "$choice" == "Abbrechen" ]] || [[ "$choice" == "ABGEBROCHEN" ]] || [[ "$choice" == *"User canceled"* ]]; then
    exit 0
fi

# Frage nach Parametern VOR der Schleife
if [[ "$choice" == "Verkleinern (Skalieren)" ]]; then
    # Frage nach Prozent (einmal für alle Dateien)
    scale_percent=$(osascript <<'APPLESCRIPT' 2>/dev/null
set thePercent to text returned of (display dialog "Auf wieviel % soll das PDF skaliert werden?" default answer "50" with title "PDF Verkleinern")
return thePercent
APPLESCRIPT
    )

    if [ -z "$scale_percent" ]; then
        show_error "Keine Prozentangabe!"
        exit 1
    fi

    scale_factor=$(echo "scale=4; $scale_percent / 100" | bc)
else
    # Frage nach Qualität (einmal für alle Dateien)
    quality_choice=$(osascript <<'APPLESCRIPT' 2>/dev/null
try
    set theChoice to button returned of (display dialog "Wähle die Qualität:" buttons {"Normal (200 DPI)", "Hoch (300 DPI)", "Eigener Wert"} default button 2 with title "PDF Optimierer")
    return theChoice
on error
    return "ABGEBROCHEN"
end try
APPLESCRIPT
    )

    if [[ "$quality_choice" == "ABGEBROCHEN" ]] || [[ "$quality_choice" == *"User canceled"* ]]; then
        exit 0
    fi

    # Setze DPI basierend auf Auswahl
    if [[ "$quality_choice" == "Hoch (300 DPI)" ]]; then
        DPI=300
        DPI_DESC="300 DPI"
    elif [[ "$quality_choice" == "Normal (200 DPI)" ]]; then
        DPI=200
        DPI_DESC="200 DPI"
    elif [[ "$quality_choice" == "Eigener Wert" ]]; then
        # Frage nach eigenem DPI-Wert
        custom_dpi=$(osascript <<'APPLESCRIPT' 2>/dev/null
set theDPI to text returned of (display dialog "Eigenen DPI-Wert eingeben:" default answer "250" with title "PDF Optimierer")
return theDPI
APPLESCRIPT
        )

        if [ -z "$custom_dpi" ] || ! [[ "$custom_dpi" =~ ^[0-9]+$ ]]; then
            show_error "Ungültiger DPI-Wert!"
            exit 1
        fi

        DPI=$custom_dpi
        DPI_DESC="${DPI} DPI"
    else
        # Fallback
        DPI=200
        DPI_DESC="200 DPI"
    fi

    # Prüfe zusätzliche Dependencies für Glätten
    echo "Prüfe Dependencies für Glätten-Funktion..."
    MISSING_DEPS=""

    if ! command -v gs &> /dev/null; then
        MISSING_DEPS="${MISSING_DEPS}• Ghostscript (gs)\n"
    fi

    if ! /opt/homebrew/bin/python3 -c "import fitz" 2>/dev/null; then
        MISSING_DEPS="${MISSING_DEPS}• PyMuPDF (Python-Bibliothek)\n"
    fi

    if ! /opt/homebrew/bin/python3 -c "from PIL import Image" 2>/dev/null; then
        MISSING_DEPS="${MISSING_DEPS}• Pillow (Python-Bibliothek)\n"
    fi

    if [ -n "$MISSING_DEPS" ]; then
        osascript <<MISSING
display dialog "⚠️ Fehlende Abhängigkeiten!

Für die Glätten-Funktion fehlen:

$MISSING_DEPS
Bitte installiere diese manuell im Terminal:

brew install ghostscript
pip3 install PyMuPDF Pillow --break-system-packages

Oder führe die Installation erneut aus." buttons {"OK"} default button 1 with title "PDF Optimierer" with icon stop
MISSING
        exit 1
    fi

    echo "✓ Alle Dependencies für Glätten vorhanden"
fi

# Verarbeite jede Datei
file_counter=0
remember_choice=""
while IFS= read -r pdf_path; do
    file_counter=$((file_counter + 1))
    echo ""
    echo "=== Datei $file_counter/$file_count ==="
    echo "PDF-Pfad: $pdf_path"

    notify "Verarbeite $file_counter/$file_count" "$(basename "$pdf_path")"

# Verarbeite basierend auf Auswahl
if [[ "$choice" == "Verkleinern (Skalieren)" ]]; then
    # === VERKLEINERN ===

    notify "Verkleinere PDF" "Skaliere auf ${scale_percent}%..."

    output_dir=$(dirname "$pdf_path")
    base_name=$(basename "$pdf_path" .pdf)
    output_path="${output_dir}/${base_name}_${scale_percent}pct.pdf"

    export PDF_PATH="$pdf_path"
    export OUTPUT_PATH="$output_path"
    export SCALE_FACTOR="$scale_factor"

    /opt/homebrew/bin/python3 << 'PYEND'
import sys
import os
import subprocess

pdf_path = os.environ['PDF_PATH']
output_path = os.environ['OUTPUT_PATH']
scale_factor = float(os.environ['SCALE_FACTOR'])

try:
    import fitz

    print("Öffne PDF...")
    doc = fitz.open(pdf_path)
    print(f"Seiten: {len(doc)}")

    page = doc[0]
    orig_rect = page.rect
    print(f"Original: {orig_rect.width:.0f} x {orig_rect.height:.0f} pt")

    output_doc = fitz.open()

    for i, page in enumerate(doc, 1):
        print(f"Verarbeite Seite {i}...")

        rect = page.rect
        new_width = rect.width * scale_factor
        new_height = rect.height * scale_factor

        new_page = output_doc.new_page(width=new_width, height=new_height)
        new_page.show_pdf_page(new_page.rect, doc, i-1)

    print(f"Neu: {new_width:.0f} x {new_height:.0f} pt")
    print("Speichere...")

    output_doc.save(output_path, garbage=4, deflate=True)
    output_doc.close()
    doc.close()

    size = os.path.getsize(output_path)
    orig_size = os.path.getsize(pdf_path)
    print(f"✓ Gespeichert! ({size:,} Bytes)")
    print(f"Reduzierung: {100 - (size/orig_size*100):.1f}%")

    subprocess.run(['osascript', '-e', f'display notification "PDF verkleinert!" with title "PDF Optimierer"'])

except Exception as e:
    print(f"❌ Fehler: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
PYEND

    if [ -f "$output_path" ]; then
        # Frage ob Original ersetzt werden soll (falls nicht gespeichert)
        if [ -z "$remember_choice" ]; then
            output_basename=$(basename "$output_path")
            if [ $file_count -gt 1 ]; then
                # Bei mehreren Dateien: Option zum Merken anbieten
                replace_choice=$(osascript 2>&1 <<APPLESCRIPT
set theDialog to display dialog "✅ PDF wurde verkleinert!

$output_basename

Was möchten Sie tun?" buttons {"Beide behalten", "Original umbenennen", "Original ersetzen"} default button 2 with title "PDF Optimierer ($file_counter/$file_count)" giving up after 60
set theButton to button returned of theDialog
set theCheckbox to false

if theButton is not "" then
    try
        set checkResult to display dialog "Diese Auswahl für alle verbleibenden Dateien verwenden?" buttons {"Nein", "Ja, für alle merken"} default button 1 with title "PDF Optimierer"
        if button returned of checkResult is "Ja, für alle merken" then
            return theButton & "|REMEMBER"
        else
            return theButton
        end if
    on error
        return theButton
    end try
else
    return "Beide behalten"
end if
APPLESCRIPT
                )

                # Prüfe ob Auswahl gemerkt werden soll
                if [[ "$replace_choice" == *"|REMEMBER" ]]; then
                    remember_choice="${replace_choice%|REMEMBER}"
                    replace_choice="$remember_choice"
                fi
            else
                # Bei einzelner Datei: einfacher Dialog
                replace_choice=$(osascript 2>&1 <<APPLESCRIPT
set theChoice to button returned of (display dialog "✅ PDF wurde verkleinert!

$output_basename

Was möchten Sie tun?" buttons {"Beide behalten", "Original umbenennen", "Original ersetzen"} default button 2 with title "PDF Optimierer")
return theChoice
APPLESCRIPT
                )
            fi
        else
            # Verwende gespeicherte Auswahl
            replace_choice="$remember_choice"
            echo "Verwende gespeicherte Auswahl: $replace_choice"
        fi

        if [[ "$replace_choice" == "Original ersetzen" ]]; then
            echo "=== Original ersetzen ==="
            echo "Original: '$pdf_path'"
            echo "Neue Datei: '$output_path'"

            # Prüfe ob Dateien existieren
            if [ ! -f "$output_path" ]; then
                echo "❌ Neue Datei existiert nicht!"
                show_dialog "⚠️ Neue Datei nicht gefunden!"
                exit 1
            fi

            # Benenne neue Datei um zum Originalnamen (mit Finder)
            echo "Lösche Original..."
            rm -f "$pdf_path"
            echo "✓ Original gelöscht"

            echo "Benenne neue Datei um mit osascript/Finder..."
            # Verwende Finder/osascript um Berechtigungsprobleme zu umgehen
            pdf_basename=$(basename "$pdf_path")
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

            echo "Rename Result: $rename_result"

            if [[ "$rename_result" == "SUCCESS" ]]; then
                echo "✓ Original wurde ersetzt"
                open -R "$pdf_path"
            else
                echo "❌ Finder-Umbenennung fehlgeschlagen: $rename_result"
                echo "Die neue Datei heißt: $(basename "$output_path")"
                show_dialog "⚠️ Original wurde gelöscht, aber Umbenennung fehlgeschlagen!\n\nNeue Datei: $(basename "$output_path")\n\nBitte manuell umbenennen."
                open -R "$output_path"
            fi
        elif [[ "$replace_choice" == "Original umbenennen" ]]; then
            echo "=== Original umbenennen ==="
            echo "Original: '$pdf_path'"
            echo "Neue Datei: '$output_path'"

            # Prüfe ob Dateien existieren
            if [ ! -f "$output_path" ]; then
                echo "❌ Neue Datei existiert nicht!"
                show_dialog "⚠️ Neue Datei nicht gefunden!"
                exit 1
            fi

            # Benenne Original um zu _original
            output_dir=$(dirname "$pdf_path")
            base_name=$(basename "$pdf_path" .pdf)
            original_backup="${output_dir}/${base_name}_original.pdf"

            echo "Benenne Original um zu: $original_backup"
            pdf_basename=$(basename "$pdf_path")
            original_basename=$(basename "$original_backup")

            rename_original=$(osascript 2>&1 <<RENAMEORIGINAL
tell application "Finder"
    try
        set sourceFile to POSIX file "$pdf_path" as alias
        set targetName to "$original_basename"
        set name of sourceFile to targetName
        return "SUCCESS"
    on error errMsg
        return "ERROR: " & errMsg
    end try
end tell
RENAMEORIGINAL
            )

            if [[ "$rename_original" == "SUCCESS" ]]; then
                echo "✓ Original umbenannt zu _original"

                # Benenne neue Datei um zum Originalnamen
                echo "Benenne neue Datei um zum Originalnamen..."
                rename_new=$(osascript 2>&1 <<RENAMENEW
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
RENAMENEW
                )

                if [[ "$rename_new" == "SUCCESS" ]]; then
                    echo "✓ Neue Datei umbenannt zum Originalnamen"
                    open -R "$pdf_path"
                else
                    echo "❌ Umbenennung der neuen Datei fehlgeschlagen: $rename_new"
                    show_dialog "⚠️ Original wurde umbenannt, aber neue Datei konnte nicht umbenannt werden!\n\nBitte manuell umbenennen."
                    open -R "$output_path"
                fi
            else
                echo "❌ Umbenennung des Originals fehlgeschlagen: $rename_original"
                show_dialog "⚠️ Original konnte nicht umbenannt werden!"
                open -R "$pdf_path"
            fi
        elif [[ "$replace_choice" == "Beide behalten" ]]; then
            # Zeige neue Datei im Finder
            open -R "$output_path"
        else
            # Abgebrochen - lösche neue Datei
            rm "$output_path"
            echo "✓ Abgebrochen, neue Datei gelöscht"
        fi
    else
        show_error "PDF wurde nicht erstellt"
        exit 1
    fi

else
    # === GLÄTTEN FÜR FILEMAKER ===

    notify "Glätten für FileMaker" "Verarbeite mit $DPI_DESC..."

    output_dir=$(dirname "$pdf_path")
    base_name=$(basename "$pdf_path" .pdf)
    output_path="${output_dir}/${base_name}_glatt.pdf"

    export PDF_PATH="$pdf_path"
    export OUTPUT_PATH="$output_path"
    export DPI="$DPI"

    /opt/homebrew/bin/python3 << 'PYEND'
import sys
import os
import subprocess
import tempfile
import shutil

try:
    import fitz
    from PIL import Image, ImageEnhance
except ImportError as e:
    print(f"❌ Import-Fehler: {e}")
    sys.exit(1)

pdf_path = os.environ.get('PDF_PATH')
output_path = os.environ.get('OUTPUT_PATH')
dpi = int(os.environ.get('DPI', '300'))

try:
    print(f"Öffne PDF (mit {dpi} DPI)...")
    doc = fitz.open(pdf_path)
    num_pages = len(doc)
    print(f"Seiten: {num_pages}")

    # Speichere Original-Metadaten
    original_metadata = doc.metadata
    print(f"Original-Metadaten: {original_metadata}")

    temp_dir = tempfile.mkdtemp()
    page_info = []

    for page_num in range(num_pages):
        page = doc[page_num]
        rect = page.rect
        page_info.append({'width': rect.width, 'height': rect.height})

    doc.close()

    # Rendere mit Ghostscript
    png_pattern = os.path.join(temp_dir, "page_%03d.png")
    gs_cmd = [
        'gs', '-dNOPAUSE', '-dBATCH', '-dSAFER',
        '-sDEVICE=png16m', f'-r{dpi}',
        '-dTextAlphaBits=4', '-dGraphicsAlphaBits=4',
        f'-sOutputFile={png_pattern}', pdf_path
    ]

    # Starte Ghostscript im Hintergrund
    gs_proc = subprocess.Popen(gs_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    # Zeige Popup während Ghostscript läuft (60 Sek timeout)
    popup_proc = subprocess.Popen(['osascript', '-e', '''
        display dialog "⏳ Rendere Seiten mit Ghostscript...

Bitte warten Sie, dieser Vorgang kann einige Sekunden dauern." with title "PDF Optimierer" buttons {"Läuft..."} default button 1 giving up after 60
    '''])

    # Warte auf Ghostscript
    gs_proc.wait()

    # Beende vorheriges Popup falls noch aktiv
    try:
        popup_proc.terminate()
    except:
        pass

    # Zeige Kontrast-Popup (60 Sek timeout)
    popup_proc = subprocess.Popen(['osascript', '-e', '''
        display dialog "🎨 Optimiere Kontrast und Schärfe...

Fast fertig!" with title "PDF Optimierer" buttons {"Läuft..."} default button 1 giving up after 60
    '''])

    output_doc = fitz.open()

    for page_num in range(len(page_info)):
        png_file = os.path.join(temp_dir, f"page_{page_num + 1:03d}.png")
        info = page_info[page_num]

        img = Image.open(png_file)

        # Kontrast erhöhen
        enhancer = ImageEnhance.Contrast(img)
        img = enhancer.enhance(1.6)

        # Schärfe erhöhen
        sharpness = ImageEnhance.Sharpness(img)
        img = sharpness.enhance(1.4)

        optimized_png = os.path.join(temp_dir, f"optimized_{page_num + 1}.png")
        img.save(optimized_png, 'PNG', optimize=True)
        img.close()

        new_page = output_doc.new_page(width=info['width'], height=info['height'])
        img_rect = fitz.Rect(0, 0, info['width'], info['height'])
        new_page.insert_image(img_rect, filename=optimized_png)

    # Beende vorheriges Popup
    try:
        popup_proc.terminate()
    except:
        pass

    # Zeige Speicher-Popup (60 Sek timeout)
    popup_proc = subprocess.Popen(['osascript', '-e', '''
        display dialog "💾 Speichere PDF...

Noch einen Moment!" with title "PDF Optimierer" buttons {"Läuft..."} default button 1 giving up after 60
    '''])

    # Setze Metadaten vom Original
    print(f"Setze Metadaten: {original_metadata}")
    output_doc.set_metadata(original_metadata)

    output_doc.save(output_path, garbage=4, deflate=True, deflate_images=False)
    output_doc.close()
    shutil.rmtree(temp_dir)

    # Beende Speicher-Popup
    try:
        popup_proc.terminate()
    except:
        pass

    size = os.path.getsize(output_path)
    print(f"✓ PDF erstellt ({size:,} Bytes)")

    subprocess.run(['osascript', '-e', f'display notification "PDF erstellt!" with title "PDF Optimierer"'])

except Exception as e:
    print(f"❌ Fehler: {e}")
    subprocess.run(['osascript', '-e', f'display notification "Fehler!" with title "PDF Optimierer" sound name "Basso"'])
    import traceback
    traceback.print_exc()
    sys.exit(1)
PYEND

    if [ -f "$output_path" ]; then
        echo "✓ Metadaten wurden direkt in Python gesetzt"

        # Frage ob Original ersetzt werden soll (falls nicht gespeichert)
        if [ -z "$remember_choice" ]; then
            output_basename=$(basename "$output_path")
            if [ $file_count -gt 1 ]; then
                # Bei mehreren Dateien: Option zum Merken anbieten
                replace_choice=$(osascript 2>&1 <<APPLESCRIPT
set theDialog to display dialog "✅ PDF wurde geglättet!

$output_basename

Was möchten Sie tun?" buttons {"Beide behalten", "Original umbenennen", "Original ersetzen"} default button 2 with title "PDF Optimierer ($file_counter/$file_count)" giving up after 60
set theButton to button returned of theDialog
set theCheckbox to false

if theButton is not "" then
    try
        set checkResult to display dialog "Diese Auswahl für alle verbleibenden Dateien verwenden?" buttons {"Nein", "Ja, für alle merken"} default button 1 with title "PDF Optimierer"
        if button returned of checkResult is "Ja, für alle merken" then
            return theButton & "|REMEMBER"
        else
            return theButton
        end if
    on error
        return theButton
    end try
else
    return "Beide behalten"
end if
APPLESCRIPT
                )

                # Prüfe ob Auswahl gemerkt werden soll
                if [[ "$replace_choice" == *"|REMEMBER" ]]; then
                    remember_choice="${replace_choice%|REMEMBER}"
                    replace_choice="$remember_choice"
                fi
            else
                # Bei einzelner Datei: einfacher Dialog
                replace_choice=$(osascript 2>&1 <<APPLESCRIPT
set theChoice to button returned of (display dialog "✅ PDF wurde geglättet!

$output_basename

Was möchten Sie tun?" buttons {"Beide behalten", "Original umbenennen", "Original ersetzen"} default button 2 with title "PDF Optimierer")
return theChoice
APPLESCRIPT
                )
            fi
        else
            # Verwende gespeicherte Auswahl
            replace_choice="$remember_choice"
            echo "Verwende gespeicherte Auswahl: $replace_choice"
        fi

        if [[ "$replace_choice" == "Original ersetzen" ]]; then
            echo "=== Original ersetzen ==="
            echo "Original: '$pdf_path'"
            echo "Neue Datei: '$output_path'"

            # Prüfe ob Dateien existieren
            if [ ! -f "$output_path" ]; then
                echo "❌ Neue Datei existiert nicht!"
                show_dialog "⚠️ Neue Datei nicht gefunden!"
                exit 1
            fi

            # Benenne neue Datei um zum Originalnamen (mit Finder)
            echo "Lösche Original..."
            rm -f "$pdf_path"
            echo "✓ Original gelöscht"

            echo "Benenne neue Datei um mit osascript/Finder..."
            # Verwende Finder/osascript um Berechtigungsprobleme zu umgehen
            pdf_basename=$(basename "$pdf_path")
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

            echo "Rename Result: $rename_result"

            if [[ "$rename_result" == "SUCCESS" ]]; then
                echo "✓ Original wurde ersetzt"
                open -R "$pdf_path"
            else
                echo "❌ Finder-Umbenennung fehlgeschlagen: $rename_result"
                echo "Die neue Datei heißt: $(basename "$output_path")"
                show_dialog "⚠️ Original wurde gelöscht, aber Umbenennung fehlgeschlagen!\n\nNeue Datei: $(basename "$output_path")\n\nBitte manuell umbenennen."
                open -R "$output_path"
            fi
        elif [[ "$replace_choice" == "Original umbenennen" ]]; then
            echo "=== Original umbenennen ==="
            echo "Original: '$pdf_path'"
            echo "Neue Datei: '$output_path'"

            # Prüfe ob Dateien existieren
            if [ ! -f "$output_path" ]; then
                echo "❌ Neue Datei existiert nicht!"
                show_dialog "⚠️ Neue Datei nicht gefunden!"
                exit 1
            fi

            # Benenne Original um zu _original
            output_dir=$(dirname "$pdf_path")
            base_name=$(basename "$pdf_path" .pdf)
            original_backup="${output_dir}/${base_name}_original.pdf"

            echo "Benenne Original um zu: $original_backup"
            pdf_basename=$(basename "$pdf_path")
            original_basename=$(basename "$original_backup")

            rename_original=$(osascript 2>&1 <<RENAMEORIGINAL
tell application "Finder"
    try
        set sourceFile to POSIX file "$pdf_path" as alias
        set targetName to "$original_basename"
        set name of sourceFile to targetName
        return "SUCCESS"
    on error errMsg
        return "ERROR: " & errMsg
    end try
end tell
RENAMEORIGINAL
            )

            if [[ "$rename_original" == "SUCCESS" ]]; then
                echo "✓ Original umbenannt zu _original"

                # Benenne neue Datei um zum Originalnamen
                echo "Benenne neue Datei um zum Originalnamen..."
                rename_new=$(osascript 2>&1 <<RENAMENEW
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
RENAMENEW
                )

                if [[ "$rename_new" == "SUCCESS" ]]; then
                    echo "✓ Neue Datei umbenannt zum Originalnamen"
                    open -R "$pdf_path"
                else
                    echo "❌ Umbenennung der neuen Datei fehlgeschlagen: $rename_new"
                    show_dialog "⚠️ Original wurde umbenannt, aber neue Datei konnte nicht umbenannt werden!\n\nBitte manuell umbenennen."
                    open -R "$output_path"
                fi
            else
                echo "❌ Umbenennung des Originals fehlgeschlagen: $rename_original"
                show_dialog "⚠️ Original konnte nicht umbenannt werden!"
                open -R "$pdf_path"
            fi
        elif [[ "$replace_choice" == "Beide behalten" ]]; then
            # Zeige neue Datei im Finder
            open -R "$output_path"
        else
            # Abgebrochen - lösche neue Datei
            rm "$output_path"
            echo "✓ Abgebrochen, neue Datei gelöscht"
        fi
    else
        show_error "PDF wurde nicht erstellt"
        exit 1
    fi
fi

done <<< "$pdf_paths"

echo ""
echo "=== FERTIG ==="
notify "Fertig!" "Alle $file_count Datei(en) verarbeitet"
