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
    notify "Installation" "Homebrew wird installiert... (kann 5-10 Min dauern)"

    # Prüfe ob Xcode Command Line Tools installiert sind
    if ! xcode-select -p &> /dev/null; then
        show_error "Xcode Command Line Tools fehlen!\n\nBitte installiere sie mit:\nxcode-select --install\n\nDanach starte die App erneut."
        exit 1
    fi

    if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 2>&1; then
        show_error "Homebrew Installation fehlgeschlagen!\n\nBitte installiere manuell:\nhttps://brew.sh\n\nSiehe Log: ~/Desktop/pdf_optimierer.log"
        INSTALL_FAILED=1
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

# Installiere fehlende Tools
if [ ${#NEED_INSTALL[@]} -gt 0 ] && [ $INSTALL_FAILED -eq 0 ]; then
    notify "Installation" "Installiere ${#NEED_INSTALL[@]} Tool(s)... (kann einige Minuten dauern)"

    if ! brew install "${NEED_INSTALL[@]}" 2>&1; then
        show_error "Tool-Installation fehlgeschlagen!\n\nBitte installiere manuell:\nbrew install ${NEED_INSTALL[*]}\n\nSiehe Log: ~/Desktop/pdf_optimierer.log"
        INSTALL_FAILED=1
    fi
fi

# Prüfe Python
if ! command -v python3 &> /dev/null; then
    show_error "Python 3 nicht gefunden!\n\nBitte installiere Homebrew Python:\nbrew install python3"
    exit 1
fi

# Prüfe PyMuPDF
if ! python3 -c "import fitz" 2>/dev/null; then
    notify "Installation" "Installiere PyMuPDF..."

    if ! pip3 install PyMuPDF --break-system-packages 2>&1; then
        show_error "PyMuPDF Installation fehlgeschlagen!\n\nBitte installiere manuell:\npip3 install PyMuPDF --break-system-packages"
        INSTALL_FAILED=1
    fi
fi

# Prüfe Pillow
if ! python3 -c "from PIL import Image" 2>/dev/null; then
    notify "Installation" "Installiere Pillow..."

    if ! pip3 install Pillow --break-system-packages 2>&1; then
        show_error "Pillow Installation fehlgeschlagen!\n\nBitte installiere manuell:\npip3 install Pillow --break-system-packages"
        INSTALL_FAILED=1
    fi
fi

if [ $INSTALL_FAILED -eq 1 ]; then
    show_error "Installation nicht vollständig!\n\nBitte siehe:\n- Log: ~/Desktop/pdf_optimierer.log\n- Anleitung: github.com/Stebibastian/pdf-optimierer"
    exit 1
fi

echo "✓ Alle Dependencies installiert"
notify "Bereit!" "Alle Tools sind installiert"
echo ""

# Schritt 2: Zeige Auswahl-Dialog
choice=$(osascript 2>&1 <<'APPLESCRIPT'
tell application "Preview"
    try
        if (count of windows) = 0 then
            return "ERROR: Kein PDF in Preview geöffnet"
        end if
    end try
end tell

set theChoice to button returned of (display dialog "Was möchten Sie tun?" buttons {"Abbrechen", "Verkleinern (Skalieren)", "Glätten für FileMaker"} default button 3 with title "PDF Optimierer")

return theChoice
APPLESCRIPT
)

echo "Auswahl: $choice"

if [[ "$choice" == "ERROR:"* ]] || [[ "$choice" == "Abbrechen" ]]; then
    show_error "Kein PDF in Preview geöffnet oder abgebrochen"
    exit 1
fi

# Hole PDF-Pfad aus Preview
pdf_path=$(osascript 2>&1 <<'APPLESCRIPT'
tell application "Preview"
    try
        if (count of windows) = 0 then
            return "ERROR: Kein Fenster geöffnet"
        end if
        set thePath to path of front document
        return POSIX path of thePath
    on error
        return "ERROR: Kein PDF geöffnet"
    end try
end tell
APPLESCRIPT
)

echo "PDF-Pfad: $pdf_path"

if [[ "$pdf_path" == ERROR* ]]; then
    show_error "$pdf_path"
    exit 1
fi

if [ ! -f "$pdf_path" ]; then
    show_error "Datei nicht gefunden: $pdf_path"
    exit 1
fi

# Verarbeite basierend auf Auswahl
if [[ "$choice" == "Verkleinern (Skalieren)" ]]; then
    # === VERKLEINERN ===

    # Frage nach Prozent
    scale_percent=$(osascript 2>&1 <<'APPLESCRIPT'
set thePercent to text returned of (display dialog "Auf wieviel % soll das PDF skaliert werden?" default answer "50" with title "PDF Verkleinern")
return thePercent
APPLESCRIPT
    )

    if [ -z "$scale_percent" ]; then
        show_error "Keine Prozentangabe!"
        exit 1
    fi

    notify "Verkleinere PDF" "Skaliere auf ${scale_percent}%..."

    scale_factor=$(echo "scale=4; $scale_percent / 100" | bc)

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
        open -R "$output_path"
        show_dialog "✅ PDF wurde verkleinert!\n\n$(basename "$output_path")"
    else
        show_error "PDF wurde nicht erstellt"
        exit 1
    fi

else
    # === GLÄTTEN FÜR FILEMAKER ===

    # Frage nach Qualität
    quality_choice=$(osascript 2>&1 <<'APPLESCRIPT'
set theChoice to button returned of (display dialog "Wähle die Qualität:" buttons {"Abbrechen", "Normal (200 DPI)", "Hoch (300 DPI)"} default button 3 with title "PDF Optimierer")
return theChoice
APPLESCRIPT
    )

    if [[ "$quality_choice" == "Abbrechen" ]]; then
        exit 0
    fi

    # Setze DPI basierend auf Auswahl
    if [[ "$quality_choice" == "Hoch (300 DPI)" ]]; then
        DPI=300
        DPI_DESC="300 DPI"
    else
        DPI=200
        DPI_DESC="200 DPI"
    fi

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

    subprocess.run(['osascript', '-e', f'display notification "Rendere {num_pages} Seite(n)..." with title "PDF Optimierer" subtitle "Schritt 1/3"'])

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
    subprocess.run(gs_cmd, capture_output=True)

    subprocess.run(['osascript', '-e', f'display notification "Optimiere Kontrast..." with title "PDF Optimierer" subtitle "Schritt 2/3"'])

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

    subprocess.run(['osascript', '-e', f'display notification "Speichere PDF..." with title "PDF Optimierer" subtitle "Schritt 3/3"'])

    # Setze Metadaten vom Original
    print(f"Setze Metadaten: {original_metadata}")
    output_doc.set_metadata(original_metadata)

    output_doc.save(output_path, garbage=4, deflate=True, deflate_images=False)
    output_doc.close()
    shutil.rmtree(temp_dir)

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

        open -R "$output_path"
        show_dialog "✅ PDF wurde geglättet!\n\n$(basename "$output_path")"
    else
        show_error "PDF wurde nicht erstellt"
        exit 1
    fi
fi

echo ""
echo "=== FERTIG ==="
