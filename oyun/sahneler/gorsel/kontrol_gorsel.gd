@tool
extends Node2D
## Kontrol noktası: küçük lolipop tabela. Etkinleşince renklenir ve parlar. Taban (0,0).
## İleride varliklar/gorsel/kontrol.png ile değiştirilebilir.

@export var aktif := false:
	set(d):
		aktif = d
		queue_redraw()

var _zaman := 0.0


func _process(delta: float) -> void:
	if aktif:
		_zaman += delta
		queue_redraw()


func _draw() -> void:
	Cizim.cubuk(self, Vector2(0, 0), Vector2(0, -70), Renkler.LOLIPOP_SAP, 7.0)
	var m := Vector2(0, -86)
	if aktif:
		draw_circle(m, 34.0 + sin(_zaman * 3.0) * 3.0, Renkler.saydam(Renkler.ISILTI, 0.6))
		Cizim.daire(self, m, 24.0, Renkler.LOLIPOP_DIS, 4.5)
		Cizim.daire(self, m, 16.0, Renkler.LOLIPOP_IC, 0.0)
		draw_arc(m, 9.0, 0.0, TAU * 0.8, 16, Renkler.LOLIPOP_SARMAL, 5.0, true)
		Cizim.parilti(self, m + Vector2(26, -24), 7.0, Renkler.PARILTI)
	else:
		Cizim.daire(self, m, 24.0, Renkler.BULUT, 4.5)
		draw_arc(m, 9.0, 0.0, TAU * 0.8, 16, Renkler.GOLGE, 5.0, true)
