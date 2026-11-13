@tool
extends Node2D
## Kahramanın görünümü (taslak B: pelerinli turkuaz kedi).
## İleride bu sahnedeki çizim yerine varliklar/gorsel/oyuncu.png ile bir Sprite2D konabilir;
## oyuncu.gd yalnızca aşağıdaki üç alanı ayarlar: yon, hiz, yerde.

var yon := 1:
	set(d):
		yon = 1 if d >= 0 else -1
		scale.x = yon
var hiz := Vector2.ZERO
var yerde := true

var _zaman := 0.0
var _adim := 0.0


func _process(delta: float) -> void:
	_zaman += delta
	if yerde and absf(hiz.x) > 20.0:
		_adim += delta * absf(hiz.x) * 0.045
	else:
		_adim = lerpf(_adim, roundf(_adim / PI) * PI, 0.3)
	queue_redraw()


func _draw() -> void:
	var k := 3.5
	var sallanma := sin(_adim) if yerde else 0.0
	var ziplama := 0.0 if yerde else clampf(hiz.y / 900.0, -1.0, 1.0)
	var gov_y := -absf(sallanma) * 2.0

	# Gölge
	if yerde:
		draw_colored_polygon(Cizim.elips_noktalari(Vector2(0, 30), Vector2(22, 5)), Renkler.GOLGE)

	# Pelerin (arkada, rüzgârda dalgalanır)
	var dalga := sin(_zaman * 9.0) * 3.0 - clampf(hiz.x * yon / 60.0, 0.0, 6.0) + ziplama * 6.0
	Cizim.cokgen(self, PackedVector2Array([
		Vector2(-4, -6 + gov_y), Vector2(-30, 10 + dalga), Vector2(-24, 22 + dalga * 0.5), Vector2(4, 8 + gov_y),
	]), Renkler.PELERIN, k)
	Cizim.cizgi(self, Vector2(-8, 2 + gov_y), Vector2(-22, 12 + dalga * 0.7), Renkler.PELERIN_KOYU, 2.5)

	# Bacaklar ve botlar
	var b1 := Vector2(-12 + sallanma * 6.0, 18 - maxf(sallanma, 0.0) * 4.0 + ziplama * 2.0)
	var b2 := Vector2(4 - sallanma * 6.0, 18 - maxf(-sallanma, 0.0) * 4.0 + ziplama * 2.0)
	for b in [b1, b2]:
		Cizim.kutu(self, Rect2(b + Vector2(0, -8), Vector2(11, 10)), 4, Renkler.KAHRAMAN_PANTOLON, k)
		Cizim.kutu(self, Rect2(b + Vector2(-2, 2), Vector2(16, 10)), 5, Renkler.BOT, k)

	# Gövde
	Cizim.elips(self, Vector2(0, 8 + gov_y), Vector2(16, 13), Renkler.KAHRAMAN_GOVDE, k)
	# Kol (öne uzanır)
	Cizim.cokgen(self, PackedVector2Array([
		Vector2(10, 2 + gov_y), Vector2(24, -4 + gov_y - ziplama * 8.0), Vector2(27, 2 + gov_y - ziplama * 8.0), Vector2(14, 11 + gov_y),
	]), Renkler.KAHRAMAN_GOVDE, k)
	# Fular
	Cizim.cokgen(self, PackedVector2Array([
		Vector2(-15, -3 + gov_y), Vector2(15, -4 + gov_y), Vector2(12, 3 + gov_y), Vector2(0, 7 + gov_y), Vector2(-12, 3 + gov_y),
	]), Renkler.FULAR, k)
	Cizim.cokgen(self, PackedVector2Array([
		Vector2(-2, 4 + gov_y), Vector2(-6, 15 + gov_y), Vector2(4, 11 + gov_y), Vector2(6, 4 + gov_y),
	]), Renkler.FULAR_KOYU, 2.5)

	# Kulaklar
	var h := Vector2(2, -22 + gov_y)
	Cizim.cokgen(self, PackedVector2Array([h + Vector2(-24, -6), h + Vector2(-22, -32), h + Vector2(-6, -18)]), Renkler.KAHRAMAN, k)
	Cizim.cokgen(self, PackedVector2Array([h + Vector2(8, -18), h + Vector2(24, -32), h + Vector2(25, -6)]), Renkler.KAHRAMAN, k)
	# Kafa
	Cizim.elips(self, h, Vector2(27, 21), Renkler.KAHRAMAN, k)
	Cizim.cizgi(self, h + Vector2(-19, -18), h + Vector2(-17, -12), Renkler.KAHRAMAN_KOYU, 3.0)
	Cizim.cizgi(self, h + Vector2(19, -18), h + Vector2(16, -12), Renkler.KAHRAMAN_KOYU, 3.0)

	# Gözler (büyük, sevimli); göz kırpma
	var kirp := fmod(_zaman, 3.6) < 0.12
	for g in [h + Vector2(-8, -1), h + Vector2(10, -2)]:
		if kirp:
			Cizim.cizgi(self, g + Vector2(-6, 2), g + Vector2(6, 2), Renkler.MUREKKEP, 3.5)
		else:
			Cizim.elips(self, g, Vector2(8, 10.5), Renkler.BEYAZ, 3.0)
			draw_colored_polygon(Cizim.elips_noktalari(g + Vector2(3, 2), Vector2(4.2, 6)), Renkler.MUREKKEP)
			draw_circle(g + Vector2(4.5, -0.5), 1.8, Renkler.BEYAZ)
	# Yanaklar
	draw_colored_polygon(Cizim.elips_noktalari(h + Vector2(-19, 10), Vector2(5, 3)), Renkler.YANAK)
	draw_colored_polygon(Cizim.elips_noktalari(h + Vector2(22, 9), Vector2(4, 3)), Renkler.YANAK)
	# Gülümseme
	draw_arc(h + Vector2(2, 9), 5.0, 0.2, PI - 0.2, 10, Renkler.MUREKKEP, 2.5, true)
