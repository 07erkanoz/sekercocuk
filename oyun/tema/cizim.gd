class_name Cizim
extends RefCounted
## Taslak B'nin kalın mürekkep çizgili çizgi film görünümü için çizim yardımcıları.
## Görsel sahneler (sahneler/gorsel/*) bu fonksiyonları _draw() içinde kullanır.

const KALINLIK := 5.0


static func elips_noktalari(merkez: Vector2, yaricap: Vector2, adim: int = 28) -> PackedVector2Array:
	var noktalar := PackedVector2Array()
	for i in adim:
		var a := TAU * float(i) / float(adim)
		noktalar.append(merkez + Vector2(cos(a) * yaricap.x, sin(a) * yaricap.y))
	return noktalar


## Dolu çokgen + mürekkep kenar çizgisi.
static func cokgen(ci: CanvasItem, noktalar: PackedVector2Array, dolgu: Color, kalinlik: float = KALINLIK) -> void:
	ci.draw_colored_polygon(noktalar, dolgu)
	if kalinlik > 0.0:
		kenar(ci, noktalar, kalinlik)


## Yukarıdan aşağı renk geçişli çokgen (taslaktaki linearGradient karşılığı).
static func gecisli_cokgen(ci: CanvasItem, noktalar: PackedVector2Array, ust: Color, alt: Color, kalinlik: float = KALINLIK) -> void:
	var en_ust := INF
	var en_alt := -INF
	for n in noktalar:
		en_ust = minf(en_ust, n.y)
		en_alt = maxf(en_alt, n.y)
	var renkler := PackedColorArray()
	for n in noktalar:
		var t := 0.0 if en_alt <= en_ust else (n.y - en_ust) / (en_alt - en_ust)
		renkler.append(ust.lerp(alt, t))
	ci.draw_polygon(noktalar, renkler)
	if kalinlik > 0.0:
		kenar(ci, noktalar, kalinlik)


static func kenar(ci: CanvasItem, noktalar: PackedVector2Array, kalinlik: float = KALINLIK) -> void:
	var kapali := noktalar.duplicate()
	kapali.append(noktalar[0])
	ci.draw_polyline(kapali, Renkler.MUREKKEP, kalinlik, true)


static func elips(ci: CanvasItem, merkez: Vector2, yaricap: Vector2, dolgu: Color, kalinlik: float = KALINLIK) -> void:
	cokgen(ci, elips_noktalari(merkez, yaricap), dolgu, kalinlik)


static func daire(ci: CanvasItem, merkez: Vector2, yaricap: float, dolgu: Color, kalinlik: float = KALINLIK) -> void:
	elips(ci, merkez, Vector2(yaricap, yaricap), dolgu, kalinlik)


## Köşeleri yuvarlatılmış kutu.
static func kutu(ci: CanvasItem, alan: Rect2, yaricap: float, dolgu: Color, kalinlik: float = KALINLIK) -> void:
	var sb := StyleBoxFlat.new()
	sb.bg_color = dolgu
	sb.set_corner_radius_all(int(yaricap))
	sb.corner_detail = 8
	sb.set_border_width_all(int(kalinlik))
	sb.border_color = Renkler.MUREKKEP
	sb.anti_aliasing = true
	ci.draw_style_box(sb, alan)


## Yuvarlak uçlu çizgi.
static func cizgi(ci: CanvasItem, a: Vector2, b: Vector2, renk: Color, kalinlik: float) -> void:
	ci.draw_line(a, b, renk, kalinlik, true)
	ci.draw_circle(a, kalinlik * 0.5, renk)
	ci.draw_circle(b, kalinlik * 0.5, renk)


## Kenar çizgili kalın çubuk (lolipop sapı, bayrak direği gibi).
static func cubuk(ci: CanvasItem, a: Vector2, b: Vector2, renk: Color, kalinlik: float) -> void:
	cizgi(ci, a, b, Renkler.MUREKKEP, kalinlik + KALINLIK * 2.0)
	cizgi(ci, a, b, renk, kalinlik)


## Zemine dikili çubuk: yuvarlak alt ucun görünen dibi tam "taban"da olur (bkz. tema/hiza.gd).
static func dikili_cubuk(ci: CanvasItem, taban: Vector2, tepe: Vector2, renk: Color, kalinlik: float) -> void:
	var a := taban + (tepe - taban).normalized() * cubuk_yaricapi(kalinlik)
	cubuk(ci, a, tepe, renk, kalinlik)


## cubuk() ile çizilen çubuğun mürekkep kenarı dahil yarı kalınlığı.
static func cubuk_yaricapi(kalinlik: float) -> float:
	return (kalinlik + KALINLIK * 2.0) * 0.5


## Dört köşeli parıltı yıldızı.
static func parilti(ci: CanvasItem, merkez: Vector2, boy: float, renk: Color) -> void:
	var k := boy * 0.25
	var noktalar := PackedVector2Array([
		merkez + Vector2(0, -boy), merkez + Vector2(k, -k), merkez + Vector2(boy, 0), merkez + Vector2(k, k),
		merkez + Vector2(0, boy), merkez + Vector2(-k, k), merkez + Vector2(-boy, 0), merkez + Vector2(-k, -k),
	])
	ci.draw_colored_polygon(noktalar, renk)
