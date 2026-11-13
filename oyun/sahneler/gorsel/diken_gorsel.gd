@tool
extends Node2D
## Şeker dikenleri (diken.png yatay döşenir). Taban y=0, sol kenar x=0.

const DIKEN_GENISLIGI := 32.0
const DIKEN_BOYU := 40.0

@export var genislik := 96.0:
	set(d):
		genislik = maxf(d, DIKEN_GENISLIGI)
		queue_redraw()


## i. dikenin çizim dikdörtgeni: doku DIKEN_BOYU + 8 yüksekliğe gerilir, görünen alt kenarı y=0'a gelir.
func _dikdortgen(t: Texture2D, i: int, adet: int) -> Rect2:
	var g := genislik / float(adet)
	var boy := DIKEN_BOYU + 8.0
	var alt := Hiza.gorunen(t).end.y * boy / t.get_size().y
	return Rect2(g * float(i), -alt, g, boy)


func _adet() -> int:
	return maxi(1, int(round(genislik / 64.0)))


func _draw() -> void:
	var t := Doku.yukle("diken")
	if t == null:
		return
	for i in _adet():
		draw_texture_rect(t, _dikdortgen(t, i, _adet()), false)


func gorunen_alan() -> Rect2:
	var t := Doku.yukle("diken")
	if t == null:
		return Rect2()
	var alan := Hiza.gerilmis_gorunen(t, _dikdortgen(t, 0, _adet()))
	for i in range(1, _adet()):
		alan = alan.merge(Hiza.gerilmis_gorunen(t, _dikdortgen(t, i, _adet())))
	return alan
