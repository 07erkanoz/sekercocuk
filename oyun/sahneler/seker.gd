class_name Seker
extends Area2D
## Toplanabilir şeker. Oyuncu değince "toplandi" sinyali verir ve kaybolur.

signal toplandi

var alindi := false


func _ready() -> void:
	add_to_group("seker")
	body_entered.connect(_govde_girdi)


func _govde_girdi(govde: Node2D) -> void:
	if alindi or not govde is Oyuncu:
		return
	alindi = true
	toplandi.emit()
	Ses.cal("seker")
	set_deferred("monitoring", false)
	var t := create_tween()
	t.set_parallel(true)
	t.tween_property(self, "scale", Vector2(1.6, 1.6), 0.18)
	t.tween_property(self, "modulate:a", 0.0, 0.18)
	t.chain().tween_callback(queue_free)
