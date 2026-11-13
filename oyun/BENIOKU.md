# Şeker Dünyası (Godot 4)

Çocuklar (10–14) için tek bölümlük 2B platform oyunu. Görünüm: taslak B (şeker dünyası).

- Çalıştır: `godot --path .` — Testler: `godot --headless --path . -s res://tests/run_tests.gd`
- Renkler yalnızca `tema/renkler.gd` içinde.
- Yeni bölüm: `bolumler/bolum_N.tscn` oluştur (kök betik `bolumler/bolum.gd`), `bolumler/liste.gd`'ye tek satır ekle.
- Oyun nesneleri `sahneler/`, görünümleri `sahneler/gorsel/` (her görsel tek sahnede; ileride PNG ile değiştirilebilir),
  menüler `arayuz/`, ses yardımcısı `sistem/ses.gd` (dosyalar `varliklar/ses/` altında varsa çalar, yoksa sessiz).
- Kontroller: ←/→, A/D, sol çubuk, yön tuşları ile yürü; Boşluk/W/↑/kol A ile zıpla; Esc/P/kol Start ile duraklat;
  menülerde yön tuşları/çubuk ile gez, Enter/kol A ile seç.
- Zemine basma (hiza) kuralı (`tema/hiza.gd`): her görselin (0,0) noktası nesnenin tabanıdır ve görsel, PNG'nin
  altındaki saydam payı `Hiza.gorunen()` ile çıkarıp görünen alt kenarını tam y=0'a çizer; oyuncu/jöle gibi gövdelerde
  `Hiza.gorseli_tabana_oturt()` görseli çarpışma şeklinin alt kenarına koyar, zemin/platform görselinin görünen üst
  kenarı çarpışmanın üstüdür. Bölümde bayrak, kontrol noktası, diken ve süsleri zeminin üst y'sine koy (örn. 600);
  `test_zemine_basma_*` testleri boşluğu piksel olarak ölçer (en çok 1 px).
- Yeniden kullanılabilir oyun öğeleri (`sahneler/`): `surpriz_kutusu.tscn` (alttan vurunca şeker ya da bir kez
  kalp; `icerik`, `seker_adedi`), `kalp.tscn`, `yay.tscn` (`guc`), `hareketli_platform.tscn` (`hareket`, `sure`;
  yatay ya da dikey), `gizli_alan.tscn` (bonus köşe, `bonus_puan`), `kontrol_noktasi.tscn`, `bitis.tscn`
  (bayrak direği: tutunma yüksekliğine göre 100–1000 puan + kısa bitiş animasyonu), efektler `parilti.tscn` ve
  `puan_yazisi.tscn` (stili `tema/tema.gd`'deki `PuanYazisi`). Kafa vuruşu ve üstüne basmayı `oyuncu.gd`
  çarpışmadan bildirir (`alttan_vuruldu()`, `ustune_basildi()`); yeni nesneler bu iki yöntemi yazması yeterli.
- Hiza: kutu ve yayın görünen üst kenarı çarpışmanın üstüdür, tabanları (0,0); hareketli platform oyuncudan önce
  taşınır ve çarpışmasını aynı karede günceller. `test_zemine_basma_yeni_nesneler` bunları ölçer.
- Bölüm 1 akışı: öğrenme alanı → kutu → jöle → yay → hareketli platformlar → tehlikeler → ortada dinlenme
  + kontrol noktası → birleşimler (yay ile yukarıdaki gizli köşe) → merdiven + bayrak. Bölüm, geçici bir üretici
  betikle yazıldı; elle düzenlenebilir. Ekran görüntüsü: `godot --path . -s res://../araclar/ekran_al.gd --
  ../ciktilar/bolum1_x.png <x> [y]`. Testleri süzerek çalıştırma: `... -s tests/run_tests.gd -- kutu bayrak`.
