@tool
extends Node2D
## Pembe-turkuaz gökyüzü, güneş, gökkuşağı, bulutlar ve katmanlı tepeler (paralaks).
## Kamera konumunu ana tuvalden okur; menüde bulutlar yavaşça kayar.

const BOYUT := Vector2(1280, 720)

var _zaman := 0.0


func _process(delta: float) -> void:
	_zaman += delta
	queue_redraw()


func _kamera_x() -> float:
	if Engine.is_editor_hint() or not is_inside_tree():
		return 0.0
	return -get_viewport().canvas_transform.origin.x


func _draw() -> void:
	var kx := _kamera_x()
	var w := BOYUT.x
	var h := BOYUT.y
	# Gökyüzü (üç duraklı geçiş)
	var orta := h * 0.48
	draw_polygon(PackedVector2Array([Vector2(0, 0), Vector2(w, 0), Vector2(w, orta), Vector2(0, orta)]),
		PackedColorArray([Renkler.GOK_UST, Renkler.GOK_UST, Renkler.GOK_ORTA, Renkler.GOK_ORTA]))
	draw_polygon(PackedVector2Array([Vector2(0, orta), Vector2(w, orta), Vector2(w, h), Vector2(0, h)]),
		PackedColorArray([Renkler.GOK_ORTA, Renkler.GOK_ORTA, Renkler.GOK_ALT, Renkler.GOK_ALT]))
	# Güneş
	draw_circle(Vector2(1080 - fposmod(kx * 0.02, 200.0), 141), 67.0, Renkler.saydam(Renkler.GUNES, 0.85))
	# Bulutlar
	var bulut_kay := kx * 0.08 + _zaman * 8.0
	for b in [Vector2(221, 137), Vector2(694, 77), Vector2(1086, 220), Vector2(-44, 243)]:
		var x := fposmod(b.x - bulut_kay + 200.0, w + 400.0) - 200.0
		_bulut(Vector2(x, b.y), 0.85)
	# Gökkuşağı
	var gx := 998.0 - fposmod(kx * 0.05, w + 500.0)
	if gx < -260.0:
		gx += w + 500.0
	for g in [[180.0, 27.0, Renkler.GOKKUSAGI_1], [155.0, 23.0, Renkler.GOKKUSAGI_2], [132.0, 23.0, Renkler.GOKKUSAGI_3]]:
		draw_arc(Vector2(gx, 409), g[0], PI, TAU, 40, Renkler.saydam(g[2], 0.65), g[1], true)
	# Tepeler
	_tepe(436.0, 60.0, 0.0042, kx * 0.15, Renkler.TEPE_UZAK, 1.3)
	_tepe(486.0, 64.0, 0.0050, kx * 0.25, Renkler.TEPE_ORTA, 2.1)
	_tepe(536.0, 50.0, 0.0058, kx * 0.38, Renkler.TEPE_YAKIN, 0.7)
	# Yapraklar
	for y in [Vector2(389, 466), Vector2(634, 489), Vector2(970, 492)]:
		var x := fposmod(y.x - kx * 0.25, w + 100.0) - 50.0
		draw_set_transform(Vector2(x, y.y), 0.7, Vector2.ONE)
		draw_colored_polygon(Cizim.elips_noktalari(Vector2.ZERO, Vector2(13, 26)), Renkler.saydam(Renkler.YAPRAK, 0.65))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _tepe(taban: float, genlik: float, siklik: float, kayma: float, renk: Color, faz: float) -> void:
	var noktalar := PackedVector2Array()
	var x := 0.0
	while x <= BOYUT.x:
		var u := (x + kayma) * siklik
		var y := taban - absf(sin(u + faz)) * genlik - sin(u * 2.3 + faz) * genlik * 0.25
		noktalar.append(Vector2(x, y))
		x += 16.0
	noktalar.append(Vector2(BOYUT.x, BOYUT.y))
	noktalar.append(Vector2(0, BOYUT.y))
	draw_colored_polygon(noktalar, renk)


func _bulut(konum: Vector2, olcek: float) -> void:
	var r := Renkler.BULUT
	for d in [[Vector2(25, 34), 22.0], [Vector2(50, 22), 30.0], [Vector2(85, 30), 24.0], [Vector2(110, 40), 18.0]]:
		draw_circle(konum + d[0] * olcek, d[1] * olcek, r)
	draw_rect(Rect2(konum + Vector2(10, 38) * olcek, Vector2(118, 20) * olcek), r)
	Cizim.cizgi(self, konum + Vector2(14, 68) * olcek, konum + Vector2(90, 68) * olcek, Renkler.saydam(r, 0.55), 6.0 * olcek)
