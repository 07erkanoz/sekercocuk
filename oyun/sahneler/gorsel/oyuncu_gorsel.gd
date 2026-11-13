@tool
extends Node2D
## Kahraman: AnimatedSprite2D (bekle, koş, zıpla). oyuncu.gd yalnızca yon, hiz, yerde ayarlar.

var yon := 1:
	set(d):
		yon = 1 if d >= 0 else -1
		scale.x = yon
var hiz := Vector2.ZERO
var yerde := true

var _spr: AnimatedSprite2D


func _ready() -> void:
	_spr = AnimatedSprite2D.new()
	_spr.scale = Vector2(1.45, 1.45)
	_spr.position = Vector2(0, -16)
	var kareler := SpriteFrames.new()
	kareler.remove_animation("default")
	_anim(kareler, "bekle", ["oyuncu"], 1.0)
	_anim(kareler, "kos", ["oyuncu_kos_1", "oyuncu", "oyuncu_kos_2", "oyuncu"], 9.0)
	_anim(kareler, "zipla", ["oyuncu_zipla"], 1.0)
	_spr.sprite_frames = kareler
	add_child(_spr)
	_spr.play("bekle")


func _anim(kareler: SpriteFrames, ad: String, dokular: Array, fps: float) -> void:
	kareler.add_animation(ad)
	kareler.set_animation_speed(ad, fps)
	kareler.set_animation_loop(ad, true)
	for d in dokular:
		var t := Doku.yukle(d)
		if t != null:
			kareler.add_frame(ad, t)


func _process(_delta: float) -> void:
	if _spr == null:
		return
	var ad := "zipla" if not yerde else ("kos" if absf(hiz.x) > 20.0 else "bekle")
	if _spr.animation != ad:
		_spr.play(ad)
