extends CanvasLayer
## Oyun bitti ekranı (canlar bitince): Tekrar Oyna, Ana Menü.

var dugmeler: Array[Button] = []


func _ready() -> void:
	layer = 30
	process_mode = Node.PROCESS_MODE_ALWAYS


func goster(toplanan: int) -> void:
	var kok := MenuKurucu.kok(self, true)
	var kutu := MenuKurucu.panel(kok, "Oyun Bitti", "Canların bitti. Bir daha dene!\nToplanan şeker: %d" % toplanan)
	dugmeler.append(MenuKurucu.dugme(kutu, "Tekrar Oyna", func() -> void: Gecis.yeniden_baslat()))
	dugmeler.append(MenuKurucu.dugme(kutu, "Ana Menü", func() -> void: Gecis.ana_menu()))
	MenuKurucu.odak_sirasi(dugmeler)
