@tool
extends Node2D
## Bölüm sonu bayrağı (bitis.png). Direk tabanı (0,0).


func _draw() -> void:
	var t := Doku.yukle("bitis")
	if t == null:
		return
	var b := t.get_size()
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.1, 1.1))
	draw_texture(t, Vector2(-b.x * 0.5, -b.y + 4.0))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
