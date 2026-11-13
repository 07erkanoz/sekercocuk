@tool
extends Node2D
## Pembe jöle düşman (dusman.png). ezik=true iken yassılmış çizilir.
## (0,0) = taban: dokunun görünen alt kenarı y=0'da, esneme tabandan yapılır (bkz. tema/hiza.gd).

var yon := -1:
	set(d):
		yon = 1 if d >= 0 else -1
var ezik := false

var _zaman := 0.0


func _process(delta: float) -> void:
	_zaman += delta
	queue_redraw()


func _olcek() -> Vector2:
	if ezik:
		return Vector2(1.35, 0.35)
	var sek := sin(_zaman * 8.0)
	return Vector2(1.0 + sek * 0.05, 1.0 - sek * 0.06)


func _draw() -> void:
	var d := Doku.yukle("dusman")
	if d == null:
		return
	draw_colored_polygon(Cizim.elips_noktalari(Vector2.ZERO, Vector2(28, 5)), Renkler.GOLGE)
	draw_set_transform(Vector2.ZERO, 0.0, _olcek())
	draw_texture(d, Hiza.tabana_konum(d))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


## Dokunun görünen alanı (yerel; gölge hariç).
func gorunen_alan() -> Rect2:
	var d := Doku.yukle("dusman")
	if d == null:
		return Rect2()
	var g := Hiza.gorunen(d)
	return Transform2D(0.0, _olcek(), 0.0, Vector2.ZERO) * Rect2(Hiza.tabana_konum(d) + g.position, g.size)
