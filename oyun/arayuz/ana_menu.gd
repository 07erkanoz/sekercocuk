extends Control
## Başlangıç ekranı: Oyna, Çıkış.

const ARKA_PLAN := preload("res://sahneler/arka_plan.tscn")
const KAHRAMAN := preload("res://sahneler/gorsel/oyuncu_gorsel.tscn")
const SEKER := preload("res://sahneler/gorsel/seker_gorsel.tscn")
const LOLIPOP := preload("res://sahneler/gorsel/lolipop_gorsel.tscn")

var dugmeler: Array[Button] = []


func _ready() -> void:
	get_tree().paused = false
	add_child(ARKA_PLAN.instantiate())
	var sahne := Node2D.new()
	add_child(sahne)
	for l in [[Vector2(150, 700), 1.0, -0.12], [Vector2(1130, 700), 1.15, 0.1]]:
		var lol := LOLIPOP.instantiate() as Node2D
		lol.position = l[0]
		lol.scale = Vector2.ONE * l[1]
		lol.rotation = l[2]
		sahne.add_child(lol)
	var kahraman := KAHRAMAN.instantiate() as Node2D
	kahraman.position = Vector2(300, 600)
	kahraman.scale = Vector2(2.2, 2.2)
	sahne.add_child(kahraman)
	for s in [Vector2(930, 200), Vector2(1010, 300), Vector2(260, 260)]:
		var seker := SEKER.instantiate() as Node2D
		seker.position = s
		seker.scale = Vector2(1.4, 1.4)
		sahne.add_child(seker)

	var kok := MenuKurucu.kok(self, false)
	var kutu := MenuKurucu.panel(kok, "Şeker Dünyası", "Koş, zıpla, şekerleri topla!")
	dugmeler.append(MenuKurucu.dugme(kutu, "Oyna", func() -> void: Gecis.bolum_baslat(0)))
	var ses_dugmesi := MenuKurucu.dugme(kutu, "Ses: Açık", func() -> void: pass)
	ses_dugmesi.name = "Ses"
	var ses_yazisi := func() -> void: ses_dugmesi.text = "Ses: Açık" if Ses.acik else "Ses: Kapalı"
	ses_yazisi.call()
	ses_dugmesi.pressed.connect(func() -> void:
		Ses.ac_kapat()
		ses_yazisi.call())
	dugmeler.append(ses_dugmesi)
	dugmeler.append(MenuKurucu.dugme(kutu, "Çıkış", func() -> void: get_tree().quit()))
	var ipucu := MenuKurucu.etiket("Yürü: ← → / A D / sol çubuk     Zıpla: Boşluk / ↑ / A tuşu", 20)
	ipucu.position = Vector2(0, 664)
	ipucu.size = Vector2(1280, 40)
	kok.add_child(ipucu)
	MenuKurucu.odak_sirasi(dugmeler)
	Ses.muzik_baslat()
