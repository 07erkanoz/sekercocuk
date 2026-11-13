@tool
extends Node2D
## Can kalbi (gösterge). dolu=false iken boş kalp çizilir.
## İleride varliklar/gorsel/kalp.png ile değiştirilebilir.

@export var dolu := true:
	set(d):
		dolu = d
		queue_redraw()


func _draw() -> void:
	var noktalar := PackedVector2Array()
	for i in 40:
		var t := TAU * float(i) / 40.0
		var x := 16.0 * pow(sin(t), 3)
		var y := -(13.0 * cos(t) - 5.0 * cos(2.0 * t) - 2.0 * cos(3.0 * t) - cos(4.0 * t))
		noktalar.append(Vector2(x, y) * 1.3)
	Cizim.cokgen(self, noktalar, Renkler.KALP if dolu else Renkler.BOS_KALP, 4.5)
	if dolu:
		draw_arc(Vector2(-9, -8), 6.0, PI * 1.05, PI * 1.6, 8, Renkler.saydam(Renkler.BEYAZ, 0.8), 3.5, true)
