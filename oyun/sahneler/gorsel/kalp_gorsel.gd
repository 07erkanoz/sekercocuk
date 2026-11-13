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
	draw_texture(t, -t.get_size() * 0.5, Renkler.BEYAZ if dolu else Renkler.BOS_KALP)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
