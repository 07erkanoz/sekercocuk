class_name Bitis
extends Area2D
## Bölüm sonu bayrağı. Oyuncu değince "ulasildi" sinyali bir kez verilir.

signal ulasildi

var tamam := false


func _ready() -> void:
	add_to_group("bitis")
	body_entered.connect(_govde_girdi)


func _govde_girdi(govde: Node2D) -> void:
	if tamam or not govde is Oyuncu or (govde as Oyuncu).can <= 0:
		return
	tamam = true
	Ses.cal("bitis")
	ulasildi.emit()
