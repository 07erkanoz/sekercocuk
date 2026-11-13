@tool
extends Node2D
## Çizgili şeker dikenleri. Taban y=0, sol kenar x=0; genişlik kadar diken dizilir.
## İleride varliklar/gorsel/diken.png (yatay döşenen) ile değiştirilebilir.

const DIKEN_GENISLIGI := 32.0
const DIKEN_BOYU := 40.0

@export var genislik := 96.0:
	set(d):
		genislik = maxf(d, DIKEN_GENISLIGI)
		queue_redraw()


func _draw() -> void:
	var adet := maxi(1, int(round(genislik / DIKEN_GENISLIGI)))
	var g := genislik / float(adet)
	for i in adet:
		var x := g * float(i)
		var uc := Vector2(x + g * 0.5, -DIKEN_BOYU)
		Cizim.cokgen(self, PackedVector2Array([Vector2(x + 1, 0), uc, Vector2(x + g - 1, 0)]), Renkler.BASTON, 0.0)
		# Pembe şerit
		Cizim.cokgen(self, PackedVector2Array([
			Vector2(x + g * 0.22, -DIKEN_BOYU * 0.42), Vector2(x + g * 0.5, -DIKEN_BOYU * 0.75),
			Vector2(x + g * 0.62, -DIKEN_BOYU * 0.65), Vector2(x + g * 0.30, -DIKEN_BOYU * 0.2),
		]), Renkler.BASTON_SERIT, 0.0)
		Cizim.kenar(self, PackedVector2Array([Vector2(x + 1, 0), uc, Vector2(x + g - 1, 0)]), 4.0)
	Cizim.kutu(self, Rect2(-4, -6, genislik + 8, 12), 6, Renkler.BASTON_SERIT, 4.0)
