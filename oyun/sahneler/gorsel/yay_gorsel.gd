@tool
extends Node2D
## Jöle yay: kurabiye taban üstünde yeşil, parlak jöle tepe. Basılınca (sikisma 0..1) yassılır.
## (0,0) = taban; görünen alt kenar y=0, dinlenirken görünen üst kenar çarpışmanın üstü (-YUKSEKLIK).

const GENISLIK := 60.0
const YUKSEKLIK := 34.0
const TABAN := 14.0

var sikisma := 0.0:
	set(d):
		sikisma = clampf(d, -0.4, 1.0)
		queue_redraw()


func _ust() -> float:
	return -YUKSEKLIK * (1.0 - sikisma * 0.45)


func gorunen_alan() -> Rect2:
	var u := _ust()
	return Rect2(-GENISLIK * 0.5, u, GENISLIK, -u)


func _draw() -> void:
	var yari := Cizim.KALINLIK * 0.5
	var alt := -TABAN + 2.0
	var ust := _ust() + yari
	var genis := GENISLIK * 0.5 - yari
	# Jöle kubbe (çizgisinin dış kenarı görünen alanın sınırında).
	var kubbe := PackedVector2Array()
	var adim := 18
	for i in adim + 1:
		var a := PI + PI * float(i) / float(adim)
		kubbe.append(Vector2(cos(a) * genis, alt + sin(a) * (alt - ust)))
	Cizim.gecisli_cokgen(self, kubbe, Renkler.JOLE_ACIK, Renkler.JOLE_KOYU)
	draw_arc(Vector2(-6, alt - (alt - ust) * 0.35), (alt - ust) * 0.45, PI * 1.15, PI * 1.45, 8,
		Renkler.JOLE_PARLAK, 5.0, true)
	draw_circle(Vector2(10, alt - (alt - ust) * 0.65), 3.0, Renkler.saydam(Renkler.BEYAZ, 0.8))
	# Kurabiye taban: kenarı dikdörtgenin içine çizilir, alt kenar tam y=0.
	Cizim.kutu(self, Rect2(-GENISLIK * 0.5, -TABAN, GENISLIK, TABAN), 6.0, Renkler.HAMUR_ACIK)
	for x in [-16.0, 0.0, 16.0]:
		draw_circle(Vector2(x, -TABAN * 0.5), 2.0, Renkler.KIRINTI)
