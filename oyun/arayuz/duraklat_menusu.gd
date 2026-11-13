extends CanvasLayer
## Duraklatma menüsü (Esc / P / kol Start). Devam Et, Baştan Başla, Ana Menü.

var dugmeler: Array[Button] = []
var acik := false
var _kok: Control


func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	_kok = MenuKurucu.kok(self, true)
	var kutu := MenuKurucu.panel(_kok, "Duraklatıldı")
	dugmeler.append(MenuKurucu.dugme(kutu, "Devam Et", kapat))
	dugmeler.append(MenuKurucu.dugme(kutu, "Baştan Başla", func() -> void: Gecis.yeniden_baslat()))
	dugmeler.append(MenuKurucu.dugme(kutu, "Ana Menü", func() -> void: Gecis.ana_menu()))
	_kok.visible = false


func _unhandled_input(olay: InputEvent) -> void:
	if olay.is_action_pressed("duraklat"):
		if acik:
			kapat()
		else:
			ac()
		get_viewport().set_input_as_handled()
	elif acik and olay.is_action_pressed("ui_cancel"):
		kapat()
		get_viewport().set_input_as_handled()


func ac() -> void:
	var bolum := get_parent() as Bolum
	if bolum != null and bolum.bitti:
		return
	if get_tree().paused:
		return
	acik = true
	_kok.visible = true
	get_tree().paused = true
	MenuKurucu.odak_sirasi(dugmeler)


func kapat() -> void:
	if not acik:
		return
	acik = false
	_kok.visible = false
	get_tree().paused = false
