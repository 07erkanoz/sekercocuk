extends CanvasLayer
## Oyun içi gösterge (taslak B'deki gibi büyük, simgeli): şeker sayısı, canlar, duraklat simgesi.

const SEKER := preload("res://sahneler/gorsel/seker_gorsel.tscn")
const KALP := preload("res://sahneler/gorsel/kalp_gorsel.tscn")

var seker_etiketi: Label
var kalpler: Array[Node2D] = []
var gosterilen_seker := 0
var gosterilen_can := 0


func _ready() -> void:
	layer = 10
	var kok := Control.new()
	kok.set_anchors_preset(Control.PRESET_FULL_RECT)
	kok.mouse_filter = Control.MOUSE_FILTER_IGNORE
	kok.theme = Tema.olustur()
	add_child(kok)

	var seker_paneli := Panel.new()
	seker_paneli.position = Vector2(28, 25)
	seker_paneli.size = Vector2(200, 83)
	kok.add_child(seker_paneli)
	var simge := SEKER.instantiate() as Node2D
	simge.set("sallan", false)
	simge.position = Vector2(56, 41)
	simge.scale = Vector2(1.25, 1.25)
	seker_paneli.add_child(simge)
	seker_etiketi = Label.new()
	seker_etiketi.position = Vector2(100, 8)
	seker_etiketi.size = Vector2(90, 66)
	seker_etiketi.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	seker_etiketi.add_theme_font_size_override("font_size", 46)
	seker_paneli.add_child(seker_etiketi)

	var can_paneli := Panel.new()
	can_paneli.position = Vector2(245, 25)
	can_paneli.size = Vector2(220, 83)
	kok.add_child(can_paneli)
	for i in Oyuncu.BASLANGIC_CANI:
		var kalp := KALP.instantiate() as Node2D
		kalp.position = Vector2(46 + i * 64, 43)
		kalp.scale = Vector2(1.05, 1.05)
		can_paneli.add_child(kalp)
		kalpler.append(kalp)

	# Duraklat simgesi (Esc / Start)
	var duraklat := Panel.new()
	duraklat.position = Vector2(1174, 25)
	duraklat.size = Vector2(77, 77)
	kok.add_child(duraklat)
	duraklat.draw.connect(func() -> void:
		Cizim.cizgi(duraklat, Vector2(29, 26), Vector2(29, 51), Renkler.MUREKKEP, 9.0)
		Cizim.cizgi(duraklat, Vector2(48, 26), Vector2(48, 51), Renkler.MUREKKEP, 9.0))
	seker_goster(0)
	can_goster(Oyuncu.BASLANGIC_CANI)


func seker_goster(sayi: int) -> void:
	gosterilen_seker = sayi
	seker_etiketi.text = "%02d" % sayi
	if sayi > 0:
		var t := create_tween()
		seker_etiketi.pivot_offset = seker_etiketi.size * 0.5
		t.tween_property(seker_etiketi, "scale", Vector2(1.25, 1.25), 0.06)
		t.tween_property(seker_etiketi, "scale", Vector2.ONE, 0.12)


func can_goster(can: int) -> void:
	gosterilen_can = can
	for i in kalpler.size():
		kalpler[i].set("dolu", i < can)
