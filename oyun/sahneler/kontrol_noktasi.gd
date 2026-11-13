class_name KontrolNoktasi
extends Area2D
## Kontrol noktası: oyuncu geçince, tehlikeye düştüğünde buraya döner.

signal etkinlesti

var aktif := false


func _ready() -> void:
	add_to_group("kontrol_noktasi")
	body_entered.connect(_govde_girdi)


func _govde_girdi(govde: Node2D) -> void:
	if aktif or not govde is Oyuncu:
		return
	aktif = true
	(govde as Oyuncu).kontrol_noktasi = global_position + Vector2(0, -40)
	$Gorsel.set("aktif", true)
	Ses.cal("dugme")
	etkinlesti.emit()
