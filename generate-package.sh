#!/bin/bash
#
# generate-package.sh - Build installable tar.gz packages for each Plymouth theme.
#
# Each tarball contains the theme directory directly at the root, so it can be
# extracted and installed as-is (e.g. to /usr/share/plymouth/themes/<theme>/).
#
# Usage:
#   ./generate-package.sh [VERSION]
#
# If VERSION is omitted it defaults to 1.2 (matching the current release).

set -e

VERSION="${1:-1.2}"

# List of themes. Each must follow the layout: <theme>/<theme>/
THEMES=(
    debian-logo
    fedora-logo
    fedora-logo-spinner
)

for theme in "${THEMES[@]}"; do
    src_dir="${theme}/${theme}"
    if [[ ! -d "$src_dir" ]]; then
        echo "Skipping '$theme': directory '$src_dir' not found." >&2
        continue
    fi

    output="${theme}-${VERSION}.tar.gz"

    # --transform renames "<theme>/<theme>" -> "<theme>" so the archive root
    # is the installable theme directory.
    tar -czf "$output" \
        --transform "s,^${theme}/${theme},${theme}," \
        "$src_dir"

    echo "Created $output"
done
