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


func _draw() -> void:
	match tur:
		1:
			var p := Doku.yukle("platform")
			if p != null:
				draw_texture_rect(p, Rect2(Vector2(-4, -6), Vector2(boyut.x + 8, maxf(boyut.y, 32.0))), false)
		_:
			var z := Doku.yukle("zemin")
			if z != null:
				var renk := Color.WHITE if tur == 0 else Color(1.0, 0.7, 0.85)
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
