@tool
extends Node2D
## Toplanabilir şeker (seker.png), hafifçe süzülür.

@export var sallan := true

var _zaman := 0.0


func _ready() -> void:
	_zaman = fposmod(global_position.x * 0.013, TAU)


func _process(delta: float) -> void:
	if not sallan:
		return
	_zaman += delta
	queue_redraw()


func _draw() -> void:
	var kayma := Vector2(0, sin(_zaman * 3.0) * 4.0) if sallan else Vector2.ZERO
	var aci := sin(_zaman * 2.0) * 0.18 if sallan else -0.2
	if sallan:
		draw_circle(kayma, 26.0, Renkler.saydam(Renkler.ISILTI, 0.25))
	var d := Doku.yukle("seker")
	if d == null:
		return
	draw_set_transform(kayma, aci, Vector2(1.7, 1.7))
	draw_texture(d, -d.get_size() * 0.5)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
