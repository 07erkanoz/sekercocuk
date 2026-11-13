# Şeker Dünyası (Godot 4)

Çocuklar (10–14) için tek bölümlük 2B platform oyunu. Görünüm: taslak B (şeker dünyası).

- Çalıştır: `godot --path .` — Testler: `godot --headless --path . -s res://tests/run_tests.gd`
- Renkler yalnızca `tema/renkler.gd` içinde.
- Yeni bölüm: `bolumler/bolum_N.tscn` oluştur (kök betik `bolumler/bolum.gd`), `bolumler/liste.gd`'ye tek satır ekle.
- Oyun nesneleri `sahneler/`, görünümleri `sahneler/gorsel/` (her görsel tek sahnede; ileride PNG ile değiştirilebilir),
  menüler `arayuz/`, ses yardımcısı `sistem/ses.gd` (dosyalar `varliklar/ses/` altında varsa çalar, yoksa sessiz).
- Kontroller: ←/→, A/D, sol çubuk, yön tuşları ile yürü; Boşluk/W/↑/kol A ile zıpla; Esc/P/kol Start ile duraklat;
  menülerde yön tuşları/çubuk ile gez, Enter/kol A ile seç.
