@tool
extends Node2D
## Şeker dikenleri (diken.png yatay döşenir). Taban y=0, sol kenar x=0.

const DIKEN_GENISLIGI := 32.0
const DIKEN_BOYU := 40.0

@export var genislik := 96.0:
	set(d):
		genislik = maxf(d, DIKEN_GENISLIGI)
		queue_redraw()


func _draw() -> void:
	var t := Doku.yukle("diken")
	if t == null:
		return
	var adet := maxi(1, int(round(genislik / 64.0)))
	var g := genislik / float(adet)
	for i in adet:
		draw_texture_rect(t, Rect2(g * float(i), -DIKEN_BOYU - 4.0, g, DIKEN_BOYU + 8.0), false)
