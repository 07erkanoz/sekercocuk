@tool
extends Node2D
## Bölüm sonu bayrak direği: uzun, baston şeker çizgili direk, tepede top, sarı yıldızlı bayrak.
## Direk tabanı (0,0); görünen alt kenar y=0 (bkz. tema/hiza.gd). bayrak_konumu 0 = tepede, 1 = dipte.
## Taslak B'deki bitis.png bayrağının büyütülmüş, tutunulabilir hali.

const DIREK_BOYU := 330.0
const KALINLIK := 10.0
const TOP := 12.0
const BAYRAK_BOYU := Vector2(74, 50)

@export var bayrak_konumu := 0.0:
	set(d):
		bayrak_konumu = clampf(d, 0.0, 1.0)
		queue_redraw()

var _zaman := 0.0


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	_zaman += delta
	queue_redraw()


func _draw() -> void:
	var tepe := Vector2(0, -DIREK_BOYU)
	Cizim.dikili_cubuk(self, Vector2.ZERO, tepe, Renkler.BASTON, KALINLIK)
	var y := -14.0
	while y > -DIREK_BOYU + 6.0:
		draw_line(Vector2(-KALINLIK * 0.5, y), Vector2(KALINLIK * 0.5, y - 8.0), Renkler.BASTON_SERIT, 5.0, true)
		y -= 20.0
	Cizim.daire(self, tepe + Vector2(0, -TOP + 2.0), TOP, Renkler.BAYRAK_TOP, 4.0)
	# Bayrak: direğin sağında, hafifçe dalgalanır.
	var ust := lerpf(-DIREK_BOYU + 14.0, -BAYRAK_BOYU.y - 18.0, bayrak_konumu)
	var noktalar := PackedVector2Array()
	var adim := 8
	for i in adim + 1:
		var t := float(i) / float(adim)
		noktalar.append(Vector2(8.0 + t * BAYRAK_BOYU.x, ust + sin(_zaman * 6.0 - t * 4.0) * 4.0 * t))
	for i in range(adim, -1, -1):
		var t := float(i) / float(adim)
		noktalar.append(Vector2(8.0 + t * BAYRAK_BOYU.x, ust + BAYRAK_BOYU.y + sin(_zaman * 6.0 - t * 4.0) * 4.0 * t))
	Cizim.cokgen(self, noktalar, Renkler.BAYRAK, 4.5)
	var m := Vector2(8.0 + BAYRAK_BOYU.x * 0.45, ust + BAYRAK_BOYU.y * 0.5)
	var yildiz := PackedVector2Array()
	for i in 10:
		var a := -PI * 0.5 + TAU * float(i) / 10.0
		var r := 14.0 if i % 2 == 0 else 6.0
		yildiz.append(m + Vector2(cos(a), sin(a)) * r)
	Cizim.cokgen(self, yildiz, Renkler.KREMA_PEMBE, 3.0)


func gorunen_alan() -> Rect2:
	var r := Cizim.cubuk_yaricapi(KALINLIK)
	var ust := -DIREK_BOYU - TOP * 2.0
	return Rect2(-r, ust, r + 8.0 + BAYRAK_BOYU.x, -ust)
