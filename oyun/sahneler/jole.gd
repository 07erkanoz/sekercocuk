class_name Jole
extends CharacterBody2D
## İleri geri yürüyen basit jöle düşman. Yandan değerse oyuncu can kaybeder,
## üstüne zıplanırsa ezilir ve oyuncu seker.

signal ezildi

const YERCEKIMI := 1900.0

@export var hiz := 70.0
## Başlangıç noktasından her iki yana en fazla bu kadar yürür.
@export var mesafe := 140.0
@export var baslangic_yonu := -1

var yon := -1
var ezik := false
var _baslangic_x := 0.0

@onready var gorsel: Node2D = $Gorsel
@onready var vurus: Area2D = $Vurus


func _ready() -> void:
	Hiza.gorseli_tabana_oturt(self)
	add_to_group("dusman")
	_baslangic_x = global_position.x
	yon = 1 if baslangic_yonu >= 0 else -1


func _physics_process(delta: float) -> void:
	if ezik:
		return
	if not is_on_floor():
		velocity.y = minf(velocity.y + YERCEKIMI * delta, 1100.0)
	velocity.x = yon * hiz
	move_and_slide()
	var uzak := (global_position.x - _baslangic_x) * yon > mesafe
	if is_on_wall() or uzak or (is_on_floor() and not _onde_zemin_var()):
		yon = -yon
	gorsel.set("yon", yon)
	_oyuncuyu_denetle()


func _onde_zemin_var() -> bool:
	var uzay := get_world_2d().direct_space_state
	var bas := global_position + Vector2(yon * 26.0, 0.0)
	var sorgu := PhysicsRayQueryParameters2D.create(bas, bas + Vector2(0, 50), collision_mask, [get_rid()])
	return not uzay.intersect_ray(sorgu).is_empty()


func _oyuncuyu_denetle() -> void:
	for govde in vurus.get_overlapping_bodies():
		if govde is Oyuncu:
			var oyuncu := govde as Oyuncu
			if oyuncu.can <= 0:
				continue
			var ustten := oyuncu.velocity.y > 40.0 and oyuncu.global_position.y < global_position.y - 14.0
			if ustten:
				ez(oyuncu)
				return
			oyuncu.hasar_al(global_position.x)


func ez(oyuncu: Oyuncu = null) -> void:
	if ezik:
		return
	ezik = true
	gorsel.set("ezik", true)
	if oyuncu != null:
		oyuncu.sek()
	ezildi.emit()
	Ses.cal("seker")
	collision_layer = 0
	vurus.set_deferred("monitoring", false)
	var t := create_tween()
	t.tween_interval(0.35)
	t.tween_property(self, "modulate:a", 0.0, 0.25)
	t.tween_callback(queue_free)
