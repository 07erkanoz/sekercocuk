@tool
extends Node2D
## Katman katman kayan (paralaks) arka plan. En arkada arka_plan.png (gökyüzü, güneş, uzak tepeler)
## sabit durur; önünde çizimle eklenen bulutlar ve iki tepe sırası kamerayla giderek daha hızlı
## kayar. Taslak B'nin renkleri ve yumuşak, kenarsız arka plan tarzı korunur.

const BOYUT := Vector2(1280, 720)
## Katmanların kamera hızına oranı (arkadan öne).
const RESIM_HIZI := 0.0
const BULUT_HIZI := 0.12
const TEPE_HIZI := 0.22
const YAKIN_TEPE_HIZI := 0.38


func _process(_delta: float) -> void:
	queue_redraw()


func _kamera() -> Vector2:
	if Engine.is_editor_hint() or not is_inside_tree():
		return Vector2.ZERO
	return -get_viewport().canvas_transform.origin


func _draw() -> void:
	var k := _kamera()
	var t := Doku.yukle("arka_plan")
	if t == null:
		draw_rect(Rect2(Vector2.ZERO, BOYUT), Renkler.GOK_ORTA)
	else:
		# Gökyüzü uzakta: resim sabit durur (güneş, bulutlar, uzak tepeler); döşeme dikişi oluşmaz.
		draw_texture_rect(t, Rect2(Vector2(-k.x * RESIM_HIZI, 0), BOYUT), false)
	# Kamera yukarı çıkınca (yay, gizli köşe) yakın katmanlar biraz aşağı kayar.
	var dikey := clampf(-k.y, 0.0, 400.0)
	_bulutlar(k.x * BULUT_HIZI, dikey * 0.1)
	_tepeler(k.x * TEPE_HIZI, 548.0 + dikey * 0.2, 46.0, 520.0, Renkler.TEPE_PARALAKS)
	_tepeler(k.x * YAKIN_TEPE_HIZI + 210.0, 590.0 + dikey * 0.35, 40.0, 380.0, Renkler.TEPE_PARALAKS_YAKIN)


## Yatayda tekrar eden yumuşak bulutlar (resimdeki bulutlarla aynı biçim: kenarsız, krem).
func _bulutlar(kay: float, dy: float) -> void:
	const ARALIK := 1600.0
	var kume := [Vector3(180, 205, 1.0), Vector3(760, 160, 0.8), Vector3(1220, 250, 0.65)]
	var bas := -fposmod(kay, ARALIK)
	var x := bas
	while x < BOYUT.x + 200.0:
		for b in kume:
			_bulut(Vector2(x + b.x, b.y + dy), b.z)
		x += ARALIK


func _bulut(m: Vector2, o: float) -> void:
	var renk := Renkler.BULUT_UZAK
	draw_circle(m + Vector2(-38, 6) * o, 24.0 * o, renk)
	draw_circle(m + Vector2(0, -8) * o, 34.0 * o, renk)
	draw_circle(m + Vector2(40, 6) * o, 24.0 * o, renk)
	draw_rect(Rect2(m + Vector2(-60, 6) * o, Vector2(120, 24) * o), renk)
	draw_circle(m + Vector2(-60, 18) * o, 12.0 * o, renk)
	draw_circle(m + Vector2(60, 18) * o, 12.0 * o, renk)


## Ekranın altında, yuvarlak tümsekli bir tepe sırası (kayan, sonsuz tekrar).
func _tepeler(kay: float, taban: float, yukseklik: float, dalga: float, renk: Color) -> void:
	var noktalar := PackedVector2Array()
	var adim := 24.0
	var x := 0.0
	while x <= BOYUT.x + adim:
		var dx := x + kay
		var y := taban - yukseklik * (0.55 + 0.45 * sin(dx * TAU / dalga)) * (0.8 + 0.2 * sin(dx * TAU / (dalga * 2.7)))
		noktalar.append(Vector2(x, y))
		x += adim
	noktalar.append(Vector2(BOYUT.x + adim, BOYUT.y))
	noktalar.append(Vector2(0, BOYUT.y))
	draw_colored_polygon(noktalar, renk)
