class_name Hiza
extends RefCounted
## Zemine basma (hiza) kuralı — tüm nesneler ve sonradan eklenecek bölümler için:
##  1. Her görsel düğümün (0,0) noktası nesnenin TABANIdır (ayak, direk dibi, diken tabanı).
##     Görsel, görünen (saydam olmayan) alt kenarını tam y=0'a çizer; PNG'lerin altındaki saydam
##     pay Hiza.gorunen() ile ölçülüp çıkarılır, elle sayı yazılmaz.
##  2. Gövdeli nesnelerde (oyuncu, jöle) Gorsel düğümü çarpışma şeklinin alt kenarına oturtulur.
##  3. Zemin/platform görselinin görünen üst kenarı çarpışmanın üst kenarıdır (y=0).
##  4. Sabit nesneler (bayrak, kontrol noktası, diken, süs) bölümde zeminin üst kenarına konur.

static var _onbellek := {}


## Dokunun saydam olmayan bölgesi (doku pikselleri). Saydam pay = doku boyutu ile bu alanın farkı.
static func gorunen(doku: Texture2D) -> Rect2:
	if doku == null:
		return Rect2()
	var anahtar := doku.get_rid()
	if _onbellek.has(anahtar):
		return _onbellek[anahtar]
	var alan := Rect2(Vector2.ZERO, doku.get_size())
	var im := doku.get_image()
	if im != null:
		if im.is_compressed():
			im.decompress()
		alan = Rect2(im.get_used_rect())
	_onbellek[anahtar] = alan
	return alan


## Doku, görünen alt kenarının ortası "taban" noktasına gelecek biçimde çizilirken sol üst köşesi
## (yerel, ölçek uygulanmadan önce). Yatayda dokunun ortası tabana gelir (eski yerleşim korunur).
static func tabana_konum(doku: Texture2D) -> Vector2:
	return Vector2(-doku.get_size().x * 0.5, -gorunen(doku).end.y)


## "hedef" dikdörtgenine gerilerek çizilen dokunun görünen alanı (yerel koordinat).
static func gerilmis_gorunen(doku: Texture2D, hedef: Rect2) -> Rect2:
	var o := hedef.size / doku.get_size()
	var g := gorunen(doku)
	return Rect2(hedef.position + g.position * o, g.size * o)


## Gövdenin "Sekil" çarpışma şeklinin alt kenarı (gövdenin yerel y'si).
static func govde_tabani(govde: Node2D) -> float:
	var sekil := govde.get_node_or_null("Sekil") as CollisionShape2D
	if sekil == null or sekil.shape == null:
		return 0.0
	return sekil.position.y + sekil.shape.get_rect().end.y


## Gorsel düğümünü gövdenin çarpışma tabanına oturtur (kural 2).
static func gorseli_tabana_oturt(govde: Node2D) -> void:
	var gorsel := govde.get_node_or_null("Gorsel") as Node2D
	if gorsel != null:
		gorsel.position = Vector2(0.0, govde_tabani(govde))
