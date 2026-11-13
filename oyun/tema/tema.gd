class_name Tema
extends RefCounted
## Menüler ve gösterge için ortak arayüz teması (renkler Renkler'den gelir).

static var _tema: Theme


static func olustur() -> Theme:
	if _tema != null:
		return _tema
	var t := Theme.new()
	var yazi := SystemFont.new()
	yazi.font_names = PackedStringArray(["Fredoka", "Baloo 2", "Nunito", "Comic Neue", "Noto Sans", "DejaVu Sans", "sans-serif"])
	yazi.font_weight = 800
	t.default_font = yazi
	t.default_font_size = 30

	t.set_stylebox("normal", "Button", kutu(Renkler.KREM, 5))
	t.set_stylebox("hover", "Button", kutu(Renkler.SEKER_KANAT, 5))
	t.set_stylebox("pressed", "Button", kutu(Renkler.SEKER_SARI, 5))
	t.set_stylebox("hover_pressed", "Button", kutu(Renkler.SEKER_SARI, 5))
	t.set_stylebox("disabled", "Button", kutu(Renkler.BULUT, 5))
	# Odak (klavye/kol ile seçili düğme): kalın pembe çerçeve, uzaktan da belli olsun.
	var odak := StyleBoxFlat.new()
	odak.draw_center = false
	odak.set_border_width_all(7)
	odak.border_color = Renkler.PEMBE_KOYU
	odak.set_corner_radius_all(32)
	odak.set_expand_margin_all(8)
	odak.anti_aliasing = true
	t.set_stylebox("focus", "Button", odak)
	for ad in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color", "font_hover_pressed_color"]:
		t.set_color(ad, "Button", Renkler.MUREKKEP)
	t.set_font_size("font_size", "Button", 34)

	t.set_stylebox("panel", "PanelContainer", panel_kutusu())
	t.set_stylebox("panel", "Panel", panel_kutusu())
	t.set_color("font_color", "Label", Renkler.MUREKKEP)
	# Oyun içinde uçuşan puan / bilgi yazısı (+100, Gizli köşe! ...).
	t.set_type_variation("PuanYazisi", "Label")
	t.set_font_size("font_size", "PuanYazisi", 30)
	t.set_color("font_color", "PuanYazisi", Renkler.MUREKKEP)
	t.set_color("font_outline_color", "PuanYazisi", Renkler.KREM)
	t.set_constant("outline_size", "PuanYazisi", 10)
	_tema = t
	return t


static func kutu(renk: Color, kenar: int) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = renk
	sb.set_border_width_all(kenar)
	sb.border_color = Renkler.MUREKKEP
	sb.set_corner_radius_all(26)
	sb.corner_detail = 8
	sb.content_margin_left = 34
	sb.content_margin_right = 34
	sb.content_margin_top = 12
	sb.content_margin_bottom = 12
	sb.anti_aliasing = true
	return sb


static func panel_kutusu() -> StyleBoxFlat:
	var sb := kutu(Renkler.KREM, 5)
	sb.set_corner_radius_all(30)
	sb.shadow_color = Renkler.GOLGE
	sb.shadow_offset = Vector2(2, 8)
	sb.shadow_size = 2
	sb.content_margin_left = 22
	sb.content_margin_right = 22
	sb.content_margin_top = 10
	sb.content_margin_bottom = 10
	return sb
