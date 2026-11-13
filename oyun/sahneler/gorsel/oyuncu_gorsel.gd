@tool
extends Node2D
## Kahraman: AnimatedSprite2D (bekle, koş, zıpla). oyuncu.gd yalnızca yon, hiz, yerde ayarlar.
## (0,0) = ayak tabanı: her karenin görünen alt kenarı y=0'a hizalanır (bkz. tema/hiza.gd).

const OLCEK := 1.45

var yon := 1:
	set(d):
		yon = 1 if d >= 0 else -1
		scale.x = yon
var hiz := Vector2.ZERO
var yerde := true

var _spr: AnimatedSprite2D
## Esneme-sıkışma: zıplarken uzar, inerken yassılır; hızla 1'e döner. Ölçek tabandan uygulanır.
var esneme := Vector2.ONE


func _ready() -> void:
	_spr = AnimatedSprite2D.new()
	_spr.scale = Vector2(OLCEK, OLCEK)
	_spr.centered = false
	var kareler := SpriteFrames.new()
	kareler.remove_animation("default")
	_anim(kareler, "bekle", ["oyuncu"], 1.0)
	_anim(kareler, "kos", ["oyuncu_kos_1", "oyuncu", "oyuncu_kos_2", "oyuncu"], 9.0)
	_anim(kareler, "zipla", ["oyuncu_zipla"], 1.0)
	_spr.sprite_frames = kareler
	add_child(_spr)
	_spr.frame_changed.connect(_tabana_hizala)
	_spr.animation_changed.connect(_tabana_hizala)
	_spr.play("bekle")
	_tabana_hizala()


func _kare_dokusu() -> Texture2D:
	if _spr == null or _spr.sprite_frames == null or not _spr.sprite_frames.has_animation(_spr.animation):
		return null
	return _spr.sprite_frames.get_frame_texture(_spr.animation, _spr.frame)


## Karenin görünen alt kenarı ayak tabanına (y=0) gelsin.
func _tabana_hizala() -> void:
	var t := _kare_dokusu()
	if t != null:
		_spr.offset = Hiza.tabana_konum(t)


## Şu anki karenin ekranda görünen alanı (bu düğümün yerel koordinatında).
func gorunen_alan() -> Rect2:
	var t := _kare_dokusu()
	if t == null:
		return Rect2()
	var g := Hiza.gorunen(t)
	return _spr.transform * Rect2(_spr.offset + g.position, g.size)


func _anim(kareler: SpriteFrames, ad: String, dokular: Array, fps: float) -> void:
	kareler.add_animation(ad)
	kareler.set_animation_speed(ad, fps)
	kareler.set_animation_loop(ad, true)
	for d in dokular:
		var t := Doku.yukle(d)
		if t != null:
			kareler.add_frame(ad, t)


func esne(olcek: Vector2) -> void:
	esneme = olcek


func _process(delta: float) -> void:
	if _spr == null:
		return
	esneme = esneme.lerp(Vector2.ONE, minf(delta * 12.0, 1.0))
	_spr.scale = Vector2(OLCEK, OLCEK) * esneme
	var ad := "zipla" if not yerde else ("kos" if absf(hiz.x) > 20.0 else "bekle")
	if _spr.animation != ad:
		_spr.play(ad)
