@tool
extends Node2D
## Bölüm sonu bayrağı (bitis.png). Direk tabanı (0,0).


const OLCEK := 1.1


func _draw() -> void:
	var t := Doku.yukle("bitis")
	if t == null:
		return
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(OLCEK, OLCEK))
	draw_texture(t, Hiza.tabana_konum(t))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func gorunen_alan() -> Rect2:
	var t := Doku.yukle("bitis")
	if t == null:
		return Rect2()
	var g := Hiza.gorunen(t)
	return Rect2((Hiza.tabana_konum(t) + g.position) * OLCEK, g.size * OLCEK)
