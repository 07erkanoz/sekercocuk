@tool
extends Node2D
## arka_plan.png tam ekran; kamerayla çok hafif kayar (paralaks).

const BOYUT := Vector2(1280, 720)


func _process(_delta: float) -> void:
	queue_redraw()


func _kamera_x() -> float:
	if Engine.is_editor_hint() or not is_inside_tree():
		return 0.0
	return -get_viewport().canvas_transform.origin.x


func _draw() -> void:
	var t := Doku.yukle("arka_plan")
	if t == null:
		draw_rect(Rect2(Vector2.ZERO, BOYUT), Renkler.GOK_ORTA)
		return
	var kay := fposmod(_kamera_x() * 0.05, BOYUT.x)
	draw_texture_rect(t, Rect2(Vector2(-kay, 0), BOYUT), false)
	draw_texture_rect(t, Rect2(Vector2(BOYUT.x - kay - 1.0, 0), BOYUT), false)
