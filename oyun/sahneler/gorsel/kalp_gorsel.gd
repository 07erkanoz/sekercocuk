@tool
extends Node2D
## Can simgesi (kalp.png). dolu=false iken soluk ve gri çizilir.

@export var dolu := true:
	set(d):
		dolu = d
		queue_redraw()


func _draw() -> void:
	var t := Doku.yukle("kalp")
	if t == null:
		return
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.5, 1.5))
	draw_texture(t, -t.get_size() * 0.5, Color.WHITE if dolu else Color(0.35, 0.35, 0.4, 0.45))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
