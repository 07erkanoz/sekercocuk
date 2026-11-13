@tool
extends Node2D
## Sevimli pembe jöle düşmanın görünümü. ezik=true iken yassılmış çizilir.
## İleride varliklar/gorsel/jole.png ile değiştirilebilir.

var yon := -1:
	set(d):
		yon = 1 if d >= 0 else -1
var ezik := false

var _zaman := 0.0


func _process(delta: float) -> void:
	_zaman += delta
	queue_redraw()


func _draw() -> void:
	var k := 4.0
	var sek := 0.0 if ezik else sin(_zaman * 8.0)
	var olcek := Vector2(1.0 + sek * 0.05, 1.0 - sek * 0.06)
	if ezik:
		olcek = Vector2(1.35, 0.35)
	draw_colored_polygon(Cizim.elips_noktalari(Vector2(0, 21), Vector2(28, 5)), Renkler.GOLGE)
	draw_set_transform(Vector2(0, 21), 0.0, olcek)
	# Kubbe + dalgalı alt kenar (yerel koordinatta taban y=0)
	var govde := PackedVector2Array()
	for i in 15:
		var a := PI + PI * float(i) / 14.0
		govde.append(Vector2(cos(a) * 26.0, -18.0 + sin(a) * 26.0))
	for i in 9:
		var x := 26.0 - 52.0 * float(i) / 8.0
		govde.append(Vector2(x + 1.0, -2.0 + (4.0 if i % 2 == 0 else -2.0)))
	Cizim.gecisli_cokgen(self, govde, Renkler.PEMBE_ACIK, Renkler.PEMBE_KOYU, k)
	draw_arc(Vector2(-6, -24), 14.0, PI * 1.05, PI * 1.45, 8, Renkler.saydam(Renkler.BEYAZ, 0.7), 4.5, true)
	# Yüz (yürüdüğü yöne bakar)
	var y := Vector2(4.0 * yon, -18)
	if ezik:
		Cizim.cizgi(self, y + Vector2(-12, 0), y + Vector2(-5, 0), Renkler.MUREKKEP, 3.0)
		Cizim.cizgi(self, y + Vector2(5, 0), y + Vector2(12, 0), Renkler.MUREKKEP, 3.0)
	else:
		draw_colored_polygon(Cizim.elips_noktalari(y + Vector2(-8, 0), Vector2(3.5, 5.5)), Renkler.MUREKKEP)
		draw_colored_polygon(Cizim.elips_noktalari(y + Vector2(8, 0), Vector2(3.5, 5.5)), Renkler.MUREKKEP)
		draw_arc(y + Vector2(0, 7), 4.0, 0.3, PI - 0.3, 8, Renkler.MUREKKEP, 2.5, true)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
