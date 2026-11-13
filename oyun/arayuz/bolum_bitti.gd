extends CanvasLayer
## Bölüm bitti ekranı: toplanan şeker, (varsa) Sonraki Bölüm, Tekrar Oyna, Ana Menü.

const SEKER := preload("res://sahneler/gorsel/seker_gorsel.tscn")

var dugmeler: Array[Button] = []
var sonuc_etiketi: Label


func _ready() -> void:
	layer = 30
	process_mode = Node.PROCESS_MODE_ALWAYS


func goster(toplanan: int, toplam: int) -> void:
	var kok := MenuKurucu.kok(self, true)
	var kutu := MenuKurucu.panel(kok, "Bölüm Bitti!")
	var satir := HBoxContainer.new()
	satir.alignment = BoxContainer.ALIGNMENT_CENTER
	satir.add_theme_constant_override("separation", 16)
	kutu.add_child(satir)
	kutu.move_child(satir, 1)
	var simge_yeri := Control.new()
	simge_yeri.custom_minimum_size = Vector2(56, 56)
	var simge := SEKER.instantiate() as Node2D
	simge.position = Vector2(28, 28)
	simge.scale = Vector2(1.3, 1.3)
	simge_yeri.add_child(simge)
	satir.add_child(simge_yeri)
	sonuc_etiketi = MenuKurucu.etiket("%d / %d şeker" % [toplanan, toplam], 40)
	sonuc_etiketi.name = "Sonuc"
	satir.add_child(sonuc_etiketi)
	if toplanan >= toplam and toplam > 0:
		var tebrik := MenuKurucu.etiket("Hepsini topladın, harika!", 28)
		kutu.add_child(tebrik)
		kutu.move_child(tebrik, 2)
	if Gecis.sonraki_var():
		dugmeler.append(MenuKurucu.dugme(kutu, "Sonraki Bölüm", func() -> void: Gecis.sonraki_bolum()))
	dugmeler.append(MenuKurucu.dugme(kutu, "Tekrar Oyna", func() -> void: Gecis.yeniden_baslat()))
	dugmeler.append(MenuKurucu.dugme(kutu, "Ana Menü", func() -> void: Gecis.ana_menu()))
	MenuKurucu.odak_sirasi(dugmeler)
