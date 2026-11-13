class_name MenuKurucu
extends RefCounted
## Menü ekranları için ortak yapı taşları: karartma perdesi, ortalanmış panel,
## düğmeler ve klavye/kol odak sırası.


## Ekranı kaplayan kök Control (temalı). Karartma isteniyorsa yarı saydam perde ekler.
static func kok(ebeveyn: Node, karart: bool) -> Control:
	var kok_dugum := Control.new()
	kok_dugum.name = "Kok"
	kok_dugum.set_anchors_preset(Control.PRESET_FULL_RECT)
	kok_dugum.theme = Tema.olustur()
	kok_dugum.mouse_filter = Control.MOUSE_FILTER_STOP
	ebeveyn.add_child(kok_dugum)
	if karart:
		var perde := ColorRect.new()
		perde.color = Renkler.PERDE
		perde.set_anchors_preset(Control.PRESET_FULL_RECT)
		kok_dugum.add_child(perde)
	return kok_dugum


## Ortada başlıklı bir panel; içine düğme eklenecek dikey kutuyu döndürür.
static func panel(kok_dugum: Control, baslik: String, aciklama: String = "") -> VBoxContainer:
	var merkez := CenterContainer.new()
	merkez.set_anchors_preset(Control.PRESET_FULL_RECT)
	kok_dugum.add_child(merkez)
	var kutu := PanelContainer.new()
	kutu.name = "Panel"
	merkez.add_child(kutu)
	var dikey := VBoxContainer.new()
	dikey.name = "Dugmeler"
	dikey.add_theme_constant_override("separation", 18)
	dikey.custom_minimum_size = Vector2(440, 0)
	kutu.add_child(dikey)
	var b := etiket(baslik, 52)
	b.name = "Baslik"
	dikey.add_child(b)
	if aciklama != "":
		var a := etiket(aciklama, 30)
		a.name = "Aciklama"
		dikey.add_child(a)
	var bosluk := Control.new()
	bosluk.custom_minimum_size = Vector2(0, 6)
	dikey.add_child(bosluk)
	return dikey


static func etiket(yazi: String, boy: int) -> Label:
	var e := Label.new()
	e.text = yazi
	e.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	e.add_theme_font_size_override("font_size", boy)
	return e


static func dugme(kutu: Container, yazi: String, islev: Callable) -> Button:
	var d := Button.new()
	d.text = yazi
	d.name = yazi.replace(" ", "")
	d.focus_mode = Control.FOCUS_ALL
	d.custom_minimum_size = Vector2(0, 74)
	d.process_mode = Node.PROCESS_MODE_ALWAYS
	d.pressed.connect(func() -> void:
		Ses.cal("dugme")
		islev.call())
	kutu.add_child(d)
	return d


## Düğmeleri yukarı/aşağı (ve sağ/sol) ile döngüsel gezilecek şekilde bağlar, ilkine odaklar.
static func odak_sirasi(dugmeler: Array[Button]) -> void:
	var n := dugmeler.size()
	for i in n:
		var d := dugmeler[i]
		var onceki := dugmeler[(i - 1 + n) % n]
		var sonraki := dugmeler[(i + 1) % n]
		d.focus_neighbor_top = d.get_path_to(onceki)
		d.focus_neighbor_bottom = d.get_path_to(sonraki)
		d.focus_neighbor_left = d.get_path_to(d)
		d.focus_neighbor_right = d.get_path_to(d)
		d.focus_previous = d.get_path_to(onceki)
		d.focus_next = d.get_path_to(sonraki)
	if n > 0:
		var ilk := dugmeler[0]
		(func() -> void:
			if is_instance_valid(ilk) and ilk.is_inside_tree():
				ilk.grab_focus()).call_deferred()
