@tool
extends Node2D
## Bölüm sonu bayrağı (sarı, onay işaretli). Direk tabanı (0,0).
## İleride varliklar/gorsel/bayrak.png ile değiştirilebilir.

var _zaman := 0.0


func _process(delta: float) -> void:
	_zaman += delta
	queue_redraw()


func _draw() -> void:
	Cizim.cubuk(self, Vector2(0, 0), Vector2(0, -130), Renkler.BAYRAK_DIREK, 9.0)
	var d := sin(_zaman * 4.0) * 5.0
	var bayrak := PackedVector2Array()
	for i in 9:
		var t := float(i) / 8.0
		bayrak.append(Vector2(4 + t * 70.0, -128 + sin(t * PI * 1.5 + _zaman * 4.0) * 5.0 * t - 6.0 * sin(t * PI)))
	for i in 9:
		var t := 1.0 - float(i) / 8.0
		bayrak.append(Vector2(4 + t * 70.0, -72 + sin(t * PI * 1.5 + _zaman * 4.0) * 5.0 * t - 6.0 * sin(t * PI)))
	Cizim.cokgen(self, bayrak, Renkler.BAYRAK, 5.0)
	draw_polyline(PackedVector2Array([Vector2(26, -102 + d * 0.3), Vector2(35, -92 + d * 0.4), Vector2(53, -112 + d * 0.6)]),
		Renkler.MUREKKEP, 6.0, true)
	Cizim.daire(self, Vector2(0, -136), 8.0, Renkler.BAYRAK_TOP, 4.0)
