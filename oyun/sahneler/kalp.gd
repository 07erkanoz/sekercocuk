class_name KalpOdulu
extends Area2D
## Sürpriz kutusundan çıkan kalp: oyuncu değince bir can geri gelir (can doluysa puan verir).

signal alindi_sinyali(oyuncu: Node)

var alindi := false
var _zaman := 0.0
var _taban_y := 0.0

@onready var gorsel: Node2D = $Gorsel


func _ready() -> void:
	add_to_group("kalp_odulu")
	body_entered.connect(_govde_girdi)
	_taban_y = 0.0


## Kutudan yukarı süzülerek çıkar.
func cik(hedef: Vector2) -> void:
	var t := create_tween()
	t.tween_property(self, "global_position", hedef, 0.35).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _process(delta: float) -> void:
	_zaman += delta
	gorsel.position.y = sin(_zaman * 4.0) * 4.0
	gorsel.scale = Vector2.ONE * (1.0 + sin(_zaman * 8.0) * 0.06)


func _govde_girdi(govde: Node2D) -> void:
	if alindi or not govde is Oyuncu:
		return
	alindi = true
	(govde as Oyuncu).can_ekle(1)
	alindi_sinyali.emit(govde)
	Ses.cal("kalp")
	Parilti.patlat(self, global_position, 12, 10.0)
	set_deferred("monitoring", false)
	var t := create_tween()
	t.tween_property(self, "scale", Vector2(1.8, 1.8), 0.18)
	t.parallel().tween_property(self, "modulate:a", 0.0, 0.18)
	t.tween_callback(queue_free)
