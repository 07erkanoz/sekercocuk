# Varlıklar

- `ses/`: `zipla.wav`, `seker.wav`, `hasar.wav`, `bitis.wav`, `dugme.wav`, `kutu.wav`, `yay.wav`, `ezme.wav`,
  `kalp.wav`, `muzik.ogg` (hepsi `araclar/ses_uret.py` ile üretilir).
  Dosya varsa `sistem/ses.gd` çalar, yoksa oyun sessiz devam eder.
- `gorsel/`: İleride çizim düğümlerinin yerine geçecek PNG'ler. Her görsel tek bir sahnede durur
  (`sahneler/gorsel/*_gorsel.tscn`); o sahnedeki çizimi bir `Sprite2D` ile değiştirmek yeter.
