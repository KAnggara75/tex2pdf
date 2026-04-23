#!/bin/sh
set -e

export PATH="/root/.TinyTeX/bin/x86_64-linux:$PATH"

echo "=== TeX to PDF Converter ==="
echo "MAIN_LATEX_FILE: $MAIN_LATEX_FILE"
echo "OUTPUT_DIR: $OUTPUT_DIR"
echo "CTAN_PACKAGES: $CTAN_PACKAGES"
echo "TOC: $TOC"

if ! command -v tlmgr >/dev/null 2>&1; then
    echo "ERROR: tlmgr not found"
    exit 1
fi

OUTPUT_DIR_ABS="$(cd "$OUTPUT_DIR" && pwd)"
mkdir -p "$OUTPUT_DIR_ABS"

SAFE_PACKAGES="
fontawesome5
blindtext
lua-uni-algos
multicol
"

if [ -n "$CTAN_PACKAGES" ]; then
    echo "Installing CTAN packages..."
    for pkg in $CTAN_PACKAGES; do
        echo "$SAFE_PACKAGES" | grep -w "$pkg" >/dev/null 2>&1 || {
            echo "Skipping unsafe package: $pkg"
            continue
        }

        echo "Installing $pkg..."
        tlmgr install "$pkg" || echo "Failed $pkg"
    done
fi

compile() {
    lualatex -interaction=nonstopmode -halt-on-error \
        -output-directory "$OUTPUT_DIR_ABS" \
        "$1" 2>&1 | tee "$OUTPUT_DIR_ABS/build.log" || {
        echo "ERROR: LaTeX compilation failed"
        exit 1
    }
}

FILE_DIR=$(dirname "$MAIN_LATEX_FILE")
FILE_NAME=$(basename "$MAIN_LATEX_FILE")

cd "$FILE_DIR"

echo "Generating PDF..."

for i in 1 2 3; do
    echo "Pass $i..."
    compile "$FILE_NAME"
done

if [ -n "$GITHUB_OUTPUT" ]; then
    echo "conversion_time=$(date)" >> "$GITHUB_OUTPUT"
fi

echo "Success!"