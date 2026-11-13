class_name Yay
extends StaticBody2D
## Jöle yay: oyuncu üstüne basınca yükseğe fırlatılır (yüksekteki şekerlere ya da gizli köşeye).
## Konum = taban (zeminin üst kenarına konur, bkz. tema/hiza.gd). Basmayı oyuncu.gd bildirir (ustune_basildi).

signal firlatti

## Fırlatma hızı (px/sn). 1250 ≈ 410 px yükseklik (normal zıplama ≈ 150 px).
@export var guc := 1250.0

var _bekleme := 0.0

@onready var gorsel: Node2D = $Gorsel


func _ready() -> void:
	add_to_group("yay")


func _physics_process(delta: float) -> void:
	_bekleme = maxf(_bekleme - delta, 0.0)


func ustune_basildi(oyuncu: Node) -> void:
	if _bekleme > 0.0 or not oyuncu is Oyuncu:
		return
	_bekleme = 0.2
	(oyuncu as Oyuncu).firlat(guc)
	firlatti.emit()
	Ses.cal("yay")
	Parilti.patlat(self, global_position + Vector2(0, -30), 8, 8.0)
	var t := create_tween()
	t.tween_property(gorsel, "sikisma", 1.0, 0.05)
	t.tween_property(gorsel, "sikisma", -0.35, 0.12).set_ease(Tween.EASE_OUT)
	t.tween_property(gorsel, "sikisma", 0.0, 0.2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
