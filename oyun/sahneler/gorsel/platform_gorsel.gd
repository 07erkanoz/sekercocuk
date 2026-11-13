@tool
extends Node2D
## Zemin ve platform görünümü (zemin.png, platform.png). Sol üst köşe (0,0).
## tur: 0 = zemin, 1 = yüzen kurabiye platform, 2 = jöle blok (zemin dokusu pembe tonlu).

@export_enum("Zemin", "Kurabiye", "Jöle") var tur := 0:
	set(d):
		tur = d
		queue_redraw()
@export var boyut := Vector2(400, 200):
	set(d):
		boyut = d
		queue_redraw()


## Kurabiye platform dokusunun çizim dikdörtgeni: görünen sol/sağ ve üst kenar çarpışma
## dikdörtgeninin kenarlarına denk gelir (bkz. tema/hiza.gd); kalınlık eskisi gibi.
func _kurabiye_dikdortgeni(p: Texture2D) -> Rect2:
	var g := Hiza.gorunen(p)
	var olcek := Vector2(boyut.x / g.size.x, maxf(boyut.y, p.get_size().y) / p.get_size().y)
	return Rect2(-g.position * olcek, p.get_size() * olcek)


## Görünen alan (yerel). Üst kenarı çarpışmanın üst kenarı (y=0) olmalı.
func gorunen_alan() -> Rect2:
	if tur == 1:
		var p := Doku.yukle("platform")
		return Rect2() if p == null else Hiza.gerilmis_gorunen(p, _kurabiye_dikdortgeni(p))
	var z := Doku.yukle("zemin")
	var ust := 0.0 if z == null else Hiza.gorunen(z).position.y
	return Rect2(0.0, 0.0, boyut.x, boyut.y - ust)


func _draw() -> void:
	match tur:
		1:
			var p := Doku.yukle("platform")
			if p != null:
				draw_texture_rect(p, _kurabiye_dikdortgeni(p), false)
		_:
			var z := Doku.yukle("zemin")
			if z != null:
				# Dokunun üstünde saydam pay varsa görünen üst kenar y=0'a gelsin.
				draw_set_transform(Vector2(0.0, -Hiza.gorunen(z).position.y))
				var renk := Renkler.BEYAZ if tur == 0 else Renkler.PLATFORM_PINK
				# Üst sıra kremalı; altı kremasız kısımla döşenir (krema tekrarlanmasın).
				var x := 0.0
				while x < boyut.x:
					var w := minf(64.0, boyut.x - x)
					draw_texture_rect_region(z, Rect2(x, 0, w, minf(64.0, boyut.y)), Rect2(0, 0, w, minf(64.0, boyut.y)), renk)
					var y := 64.0
					while y < boyut.y:
						var hh := minf(32.0, boyut.y - y)
						draw_texture_rect_region(z, Rect2(x, y, w, hh), Rect2(0, 32, w, hh), renk)
						y += 32.0
					x += 64.0
				draw_set_transform(Vector2.ZERO)
