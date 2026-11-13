@tool
extends Node2D
## Toplanabilir sarılı şeker görünümü (parlayan, hafifçe süzülen).
## İleride varliklar/gorsel/seker.png ile değiştirilebilir.

@export var sallan := true

var _zaman := 0.0


func _ready() -> void:
	# Şekerler aynı anda sallanmasın.
	_zaman = fposmod(global_position.x * 0.013, TAU)


func _process(delta: float) -> void:
	if not sallan:
		return
	_zaman += delta
	queue_redraw()


func _draw() -> void:
	var k := 3.5
	var kayma := Vector2(0, sin(_zaman * 3.0) * 4.0) if sallan else Vector2.ZERO
	var aci := sin(_zaman * 2.0) * 0.18 if sallan else -0.2
	if sallan:
		draw_circle(kayma, 26.0, Renkler.saydam(Renkler.ISILTI, 0.55))
		var p := 0.5 + 0.5 * sin(_zaman * 4.0)
		Cizim.parilti(self, kayma + Vector2(-20, -20), 4.0 + p * 4.0, Renkler.PARILTI)
	draw_set_transform(kayma, aci, Vector2.ONE)
	Cizim.cokgen(self, PackedVector2Array([Vector2(-11, -6), Vector2(-24, -12), Vector2(-22, 10), Vector2(-11, 7)]), Renkler.SEKER_KANAT, k)
	Cizim.cokgen(self, PackedVector2Array([Vector2(11, -6), Vector2(24, -12), Vector2(22, 10), Vector2(11, 7)]), Renkler.SEKER_KANAT, k)
	Cizim.kutu(self, Rect2(-14, -11, 28, 22), 9, Renkler.SEKER_SARI, k)
	Cizim.cizgi(self, Vector2(-4, -7), Vector2(-8, 7), Renkler.SEKER_SERIT, 4.5)
	Cizim.cizgi(self, Vector2(6, -7), Vector2(2, 7), Renkler.SEKER_SERIT, 4.5)
	Cizim.cizgi(self, Vector2(-8, -5), Vector2(-3, -6), Renkler.BEYAZ, 2.5)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
