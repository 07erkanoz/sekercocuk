@tool
extends Node2D
## Zemin ve platform görünümü. Sol üst köşe (0,0), boyut kadar alan kaplar.
## tur: 0 = kurabiye zemin (pembe kremalı), 1 = yüzen kurabiye, 2 = jöle blok.
## İleride varliklar/gorsel/*.png ile (NinePatchRect/TextureRect) değiştirilebilir.

@export_enum("Zemin", "Kurabiye", "Jöle") var tur := 0:
	set(d):
		tur = d
		queue_redraw()
@export var boyut := Vector2(400, 200):
	set(d):
		boyut = d
		queue_redraw()


func _draw() -> void:
	match tur:
		0:
			_zemin()
		1:
			_kurabiye()
		_:
			_jole()


func _zemin() -> void:
	var w := boyut.x
	var h := boyut.y
	Cizim.gecisli_cokgen(self, PackedVector2Array([Vector2(0, 0), Vector2(w, 0), Vector2(w, h), Vector2(0, h)]),
		Renkler.HAMUR_ACIK, Renkler.HAMUR_KOYU, 5.0)
	# Kırıntı deseni
	var y := 48.0
	var satir := 0
	while y < h - 8.0:
		var x := 14.0 + (29.0 if satir % 2 == 1 else 0.0)
		while x < w - 12.0:
			Cizim.cizgi(self, Vector2(x, y), Vector2(x + 5, y + 2), Renkler.KIRINTI, 4.0)
			draw_circle(Vector2(x + 22, y - 18), 2.5, Renkler.KIRINTI_ACIK)
			x += 58.0
		y += 44.0
		satir += 1
	# Pembe krema ve damlalar
	var krema := PackedVector2Array([Vector2(-6, -12), Vector2(w + 6, -12)])
	var x2 := w + 6.0
	var i := 0
	while x2 > -6.0:
		var sonraki := maxf(x2 - 46.0, -6.0)
		var orta := (x2 + sonraki) * 0.5
		var damla := 14.0 if i % 3 != 1 else 26.0
		krema.append(Vector2(x2, 14))
		krema.append(Vector2(orta + 10, 16))
		for a in 7:
			var aci := PI * float(a) / 6.0
			krema.append(Vector2(orta + cos(aci) * 7.0, 16.0 + damla - 7.0 + sin(aci) * 7.0))
		krema.append(Vector2(orta - 10, 16))
		x2 = sonraki
		i += 1
	krema.append(Vector2(-6, 14))
	Cizim.cokgen(self, krema, Renkler.KREMA_PEMBE, 5.0)
	# Serpme şekerler
	var sx := 26.0
	var j := 0
	while sx < w - 20.0:
		var a := Vector2(sx, -2 + (j % 3) * 3.0)
		Cizim.cizgi(self, a, a + Vector2(8, 2 - (j % 2) * 5.0), Renkler.SERPME, 4.0)
		sx += 41.0
		j += 1


func _kurabiye() -> void:
	var w := boyut.x
	var h := boyut.y
	Cizim.kutu(self, Rect2(0, 0, w, h), 20, Renkler.HAMUR_ACIK, 5.0)
	draw_rect(Rect2(10, h * 0.62, w - 20, h * 0.25), Renkler.saydam(Renkler.HAMUR_KOYU, 0.45))
	var x := 18.0
	while x < w - 18.0:
		Cizim.cizgi(self, Vector2(x, h * 0.6), Vector2(x + 3, h * 0.6), Renkler.KURABIYE_CIZGI, 3.0)
		x += 19.0
	# Üst krema
	var krema := PackedVector2Array([Vector2(6, 2), Vector2(w - 6, 2)])
	var x2 := w - 6.0
	var i := 0
	while x2 > 6.0:
		var sonraki := maxf(x2 - 24.0, 6.0)
		krema.append(Vector2(x2, 14 + (6.0 if i % 2 == 0 else 2.0)))
		krema.append(Vector2((x2 + sonraki) * 0.5, 24 + (2.0 if i % 2 == 0 else -4.0)))
		x2 = sonraki
		i += 1
	krema.append(Vector2(6, 16))
	Cizim.cokgen(self, krema, Renkler.KURABIYE_KREMA, 4.0)
	var sx := 22.0
	var j := 0
	while sx < w - 20.0:
		var renk := Renkler.KREMA_PEMBE if j % 2 == 0 else Renkler.SEKER_SERIT
		Cizim.cizgi(self, Vector2(sx, 9), Vector2(sx + 6, 11 - (j % 2) * 4.0), renk, 3.5)
		sx += 26.0
		j += 1


func _jole() -> void:
	var w := boyut.x
	var h := boyut.y
	Cizim.kutu(self, Rect2(0, 0, w, h), 22, Renkler.JOLE_KOYU, 5.0)
	Cizim.kutu(self, Rect2(4, 4, w - 8, h * 0.55), 18, Renkler.JOLE_ACIK, 0.0)
	var dalga := PackedVector2Array()
	var x := 10.0
	while x <= w - 10.0:
		dalga.append(Vector2(x, h * 0.5 + sin(x * 0.16) * 5.0))
		x += 4.0
	draw_polyline(dalga, Renkler.JOLE_CIZGI, 3.0, true)
	Cizim.cizgi(self, Vector2(22, 12), Vector2(w - 40, 12), Renkler.saydam(Renkler.BEYAZ, 0.7), 5.0)
	Cizim.cizgi(self, Vector2(16, h - 22), Vector2(16, h - 14), Renkler.JOLE_PARLAK, 4.0)
