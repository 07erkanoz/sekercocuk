@tool
extends Node2D
## Pembe jöle düşman (dusman.png). ezik=true iken yassılmış çizilir.

var yon := -1:
	set(d):
		yon = 1 if d >= 0 else -1
var ezik := false

var _zaman := 0.0


func _process(delta: float) -> void:
	_zaman += delta
	queue_redraw()


func _draw() -> void:
	var d := Doku.yukle("dusman")
	if d == null:
		return
	var sek := 0.0 if ezik else sin(_zaman * 8.0)
	var olcek := Vector2(1.0 + sek * 0.05, 1.0 - sek * 0.06) * 1.0
	if ezik:
		olcek = Vector2(1.35, 0.35)
	draw_colored_polygon(Cizim.elips_noktalari(Vector2(0, 21), Vector2(28, 5)), Renkler.GOLGE)
	var b := d.get_size()
	draw_set_transform(Vector2(0, 23), 0.0, olcek * Vector2(1.0, 1.0))
	draw_texture(d, Vector2(-b.x * 0.5, -b.y))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
