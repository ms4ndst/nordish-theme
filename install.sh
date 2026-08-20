#!/usr/bin/env bash
# Installs the Nordish GNOME Shell + GTK legacy themes into ~/.themes
# by copying the theme directories. Re-run this script after pulling
# changes to pick them up (a plain symlink isn't used here, since some
# apps' own theme-reading code behaves differently — or not at all —
# when handed a symlinked theme directory).
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="${HOME}/.themes"

mkdir -p "$DEST_DIR"

for theme in Nordish-Dark Nordish-Light Nordish-Dark-Round Nordish-Light-Round; do
  target="${DEST_DIR}/${theme}"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    rm -rf "$target"
  fi
  [ -L "$target" ] && rm -f "$target"
  cp -rL "${SRC_DIR}/${theme}" "$target"
  echo "Copied ${SRC_DIR}/${theme} -> ${target}"
done

cat <<'EOF'

Done. Next steps:
  1. Install the "User Themes" GNOME Shell extension if you haven't:
       https://extensions.gnome.org/extension/19/user-themes/
  2. Open GNOME Tweaks:
       - Appearance > Shell: select a Nordish-* variant
       - Appearance > Legacy Applications: select a Nordish-* variant
     (Nordish-Dark / Nordish-Light are the flat originals; the
     -Round variants use Lycia's rounded shape language instead.)
  3. Log out/in (or Alt+F2 r Enter on X11) if the shell theme doesn't
     apply immediately.
  4. Re-run this script any time you pull theme updates — since the
     themes are now copied (not symlinked), changes in this repo won't
     show up in ~/.themes until you do.
EOF
