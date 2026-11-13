#!/usr/bin/env bash
# Şeker Dünyası'nı kullanıcı klasörüne kurar (kök yetkisi gerekmez).
# Dışa aktarılmış dist/seker-dunyasi.x86_64 varsa onu, yoksa `godot --path` yedeğini kullanır.
set -euo pipefail
KOK="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HEDEF="$HOME/.local/share/seker-dunyasi"
SIMGE_DIR="$HOME/.local/share/icons"
UYG_DIR="$HOME/.local/share/applications"

mkdir -p "$HEDEF" "$SIMGE_DIR" "$UYG_DIR"

if [ -x "$KOK/dist/seker-dunyasi.x86_64" ]; then
  install -m 755 "$KOK/dist/seker-dunyasi.x86_64" "$HEDEF/seker-dunyasi.x86_64"
  CALISTIR='exec "$DIR/seker-dunyasi.x86_64" "$@"'
else
  command -v godot >/dev/null || { echo "godot bulunamadı ve dışa aktarılmış sürüm yok" >&2; exit 1; }
  (cd "$KOK/oyun" && godot --headless --path . --import >/dev/null 2>&1 || true)
  rm -rf "$HEDEF/oyun"
  mkdir -p "$HEDEF/oyun"
  cp -r "$KOK/oyun/." "$HEDEF/oyun/"
  rm -rf "$HEDEF/oyun/tests" "$HEDEF/oyun/export_presets.cfg"
  CALISTIR='exec godot --path "$DIR/oyun" "$@"'
fi

cat > "$HEDEF/seker-dunyasi.sh" <<SH
#!/usr/bin/env bash
DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
$CALISTIR
SH
chmod 755 "$HEDEF/seker-dunyasi.sh"

install -m 644 "$KOK/oyun/varliklar/gorsel/simge.png" "$SIMGE_DIR/seker-dunyasi.png"

cat > "$UYG_DIR/seker-dunyasi.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=Şeker Dünyası
Comment=Şekerleri topla, zıpla ve bölümü bitir: şeker dünyasında küçük bir platform oyunu
Exec=$HEDEF/seker-dunyasi.sh
Icon=$SIMGE_DIR/seker-dunyasi.png
Terminal=false
Categories=Game;
DESKTOP
chmod 644 "$UYG_DIR/seker-dunyasi.desktop"
command -v update-desktop-database >/dev/null && update-desktop-database "$UYG_DIR" 2>/dev/null || true
echo "Kuruldu: $UYG_DIR/seker-dunyasi.desktop"
