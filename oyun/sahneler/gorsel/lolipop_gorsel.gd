@tool
extends Node2D
## Süs lolipop ağacı (taslak B'deki gibi). Sap tabanı (0,0); boyut düğüm ölçeğiyle ayarlanır.
## İleride varliklar/gorsel/lolipop.png ile değiştirilebilir.


func _draw() -> void:
	Cizim.cubuk(self, Vector2(0, 0), Vector2(0, -180), Renkler.LOLIPOP_SAP, 10.0)
	var m := Vector2(0, -186)
	Cizim.daire(self, m, 62.0, Renkler.LOLIPOP_DIS, 5.0)
	Cizim.daire(self, m, 49.0, Renkler.LOLIPOP_IC, 0.0)
	var sarmal := PackedVector2Array()
	for i in 60:
		var t := float(i) / 59.0
		var a := t * TAU * 2.2
		sarmal.append(m + Vector2(cos(a), sin(a)) * (4.0 + t * 40.0))
	draw_polyline(sarmal, Renkler.LOLIPOP_SARMAL, 13.0, true)
	draw_arc(m, 46.0, PI * 1.1, PI * 1.5, 12, Renkler.saydam(Renkler.BEYAZ, 0.7), 7.0, true)
