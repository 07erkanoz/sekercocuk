class_name GizliAlan
extends Area2D
## Gizli bonus köşesi: oyuncu ilk girişte parıltı, "Gizli köşe!" yazısı ve bonus puan alır.
## Konum = alanın sol alt köşesi; alan yukarı ve sağa "boyut" kadar uzanır. İçine şekerler konur.

signal bulundu

@export var boyut := Vector2(400, 200)
@export var bonus_puan := 500

var bulundu_mu := false


func _ready() -> void:
	add_to_group("gizli_alan")
	var sekil := $Sekil as CollisionShape2D
	var dikdortgen := RectangleShape2D.new()
	dikdortgen.size = boyut
	sekil.shape = dikdortgen
	sekil.position = Vector2(boyut.x * 0.5, -boyut.y * 0.5)
	body_entered.connect(_govde_girdi)


func _govde_girdi(govde: Node2D) -> void:
	if bulundu_mu or not govde is Oyuncu:
		return
	bulundu_mu = true
	Ses.cal("kalp")
	Parilti.patlat(govde, govde.global_position + Vector2(0, -40), 16, 12.0)
	PuanYazisi.goster(govde, govde.global_position + Vector2(0, -60), "Gizli köşe!")
	bulundu.emit()
