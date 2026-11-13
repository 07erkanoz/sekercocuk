extends SceneTree
## Başsız testler (eklentisiz). Çalıştırma:
##   godot --headless --path . -s res://tests/run_tests.gd
## Başarısızlıkta çıkış kodu 1; hepsi geçerse 0 ve "TUM TESTLER GECTI".

const OYUNCU := preload("res://sahneler/oyuncu.tscn")
const PLATFORM := preload("res://sahneler/platform.tscn")
const SEKER := preload("res://sahneler/seker.tscn")
const JOLE := preload("res://sahneler/jole.tscn")
const DIKEN := preload("res://sahneler/diken.tscn")
const CUKUR := preload("res://sahneler/cukur.tscn")
const BITIS := preload("res://sahneler/bitis.tscn")
const KONTROL := preload("res://sahneler/kontrol_noktasi.tscn")
const BOLUM_BETIGI := preload("res://bolumler/bolum.gd")

const ZEMIN_Y := 600.0

var _gecen := 0
var _kalan := 0
var _test_adi := ""
var _hatalar: Array[String] = []


func _initialize() -> void:
	_calistir.call_deferred()


func _calistir() -> void:
	var testler := [
		"test_giris_haritasi",
		"test_saga_giris_ilerler",
		"test_sola_giris_geri_gider",
		"test_zeminde_zipla_yukselir",
		"test_koyote_suresi",
		"test_ziplama_tamponu",
		"test_seker_sayaci_artar",
		"test_dusmana_degince_can_azalir",
		"test_dokunulmazlik",
		"test_dusmani_ezme",
		"test_dikene_degince_can_azalir_ve_geri_doner",
		"test_cukura_dusunce_can_azalir",
		"test_kontrol_noktasi",
		"test_can_sifirda_oyun_biter",
		"test_bitise_degince_bolum_tamamlanir",
		"test_bolum_listesi",
		"test_bolum_1_yapisi",
		"test_bolum_1_bastan_sona_oynanabilir",
		"test_ana_menu_odak",
		"test_duraklatma_menusu",
		"test_sonuc_ekranlari_odak",
		"test_ses_dosyasiz_sessiz",
	]
	for ad in testler:
		_test_adi = ad
		var once := _hatalar.size()
		await call(ad)
		_temizle()
		await physics_frame
		if _hatalar.size() == once:
			_gecen += 1
			print("  GECTI  ", ad)
		else:
			_kalan += 1
			print("  KALDI  ", ad)
	print("")
	print("%d test geçti, %d test kaldı" % [_gecen, _kalan])
	if _kalan == 0:
		print("TUM TESTLER GECTI")
		quit(0)
	else:
		for h in _hatalar:
			printerr(h)
		quit(1)


# --- Yardımcılar -------------------------------------------------------------

func dogrula(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hatalar.append("[%s] %s" % [_test_adi, mesaj])
		printerr("    HATA: ", mesaj)


func _temizle() -> void:
	for eylem in ["sol", "sag", "zipla", "duraklat"]:
		Input.action_release(eylem)
	paused = false
	for c in root.get_children():
		if c.has_meta("test_dugumu"):
			root.remove_child(c)
			c.queue_free()


func kare(n: int = 1) -> void:
	for i in n:
		await physics_frame


## Düz zeminli küçük bir test bölümü kurar; oyuncu yerde başlar.
func alan(oyuncu_x: float = 200.0, zemin_parcalari: Array = [[-200.0, 3000.0]]) -> Bolum:
	var b := BOLUM_BETIGI.new() as Bolum
	b.name = "TestBolum"
	b.genislik = 4000.0
	b.set_meta("test_dugumu", true)
	for p in zemin_parcalari:
		var z := PLATFORM.instantiate()
		z.position = Vector2(p[0], ZEMIN_Y)
		z.boyut = Vector2(p[1], 200)
		b.add_child(z)
	var o := OYUNCU.instantiate()
	o.name = "Oyuncu"
	o.position = Vector2(oyuncu_x, ZEMIN_Y - 31)
	b.add_child(o)
	return b


func ekle(b: Bolum, sahne: PackedScene, konum: Vector2, ozellikler: Dictionary = {}) -> Node2D:
	var d := sahne.instantiate() as Node2D
	d.position = konum
	for k in ozellikler:
		d.set(k, ozellikler[k])
	b.add_child(d)
	return d


func baslat(b: Bolum) -> Bolum:
	root.add_child(b)
	await kare(6)
	return b


# --- Testler -----------------------------------------------------------------

func test_giris_haritasi() -> void:
	for eylem in ["sol", "sag", "zipla", "duraklat", "onay"]:
		dogrula(InputMap.has_action(eylem), "giriş eylemi yok: " + eylem)
		if not InputMap.has_action(eylem):
			continue
		var klavye := false
		var kol := false
		for o in InputMap.action_get_events(eylem):
			klavye = klavye or o is InputEventKey
			kol = kol or o is InputEventJoypadButton or o is InputEventJoypadMotion
		dogrula(klavye and kol, "%s hem klavye hem kol olayı içermeli" % eylem)
	var boyut := Vector2i(ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height"))
	dogrula(boyut == Vector2i(1280, 720), "pencere 1280x720 olmalı")


func test_saga_giris_ilerler() -> void:
	var b: Bolum = await baslat(alan())
	var x0 := b.oyuncu.global_position.x
	Input.action_press("sag")
	await kare(30)
	Input.action_release("sag")
	dogrula(b.oyuncu.global_position.x > x0 + 80.0, "sağa giriş ile ilerlemedi (%.1f → %.1f)" % [x0, b.oyuncu.global_position.x])


func test_sola_giris_geri_gider() -> void:
	var b: Bolum = await baslat(alan(600.0))
	var x0 := b.oyuncu.global_position.x
	Input.action_press("sol")
	await kare(30)
	Input.action_release("sol")
	dogrula(b.oyuncu.global_position.x < x0 - 80.0, "sola giriş ile geri gitmedi")


func test_zeminde_zipla_yukselir() -> void:
	var b: Bolum = await baslat(alan())
	dogrula(b.oyuncu.is_on_floor(), "oyuncu başlangıçta yerde olmalı")
	var y0 := b.oyuncu.global_position.y
	Input.action_press("zipla")
	await kare(12)
	var y1 := b.oyuncu.global_position.y
	Input.action_release("zipla")
	dogrula(y1 < y0 - 60.0, "zıplayınca yükselmedi (%.1f → %.1f)" % [y0, y1])
	await kare(80)
	dogrula(b.oyuncu.is_on_floor(), "zıpladıktan sonra yere dönmedi")


func test_koyote_suresi() -> void:
	# Zemin 400'de bitiyor; oyuncu kenardan koşup düştükten hemen sonra zıplayabilmeli.
	var b: Bolum = await baslat(alan(330.0, [[-200.0, 600.0]]))
	Input.action_press("sag")
	var dustu := false
	for i in 60:
		await kare()
		if not b.oyuncu.is_on_floor():
			dustu = true
			break
	dogrula(dustu, "oyuncu kenardan düşmedi")
	await kare(3)  # ~0.05 sn havada; koyote süresi 0.14 sn
	var y0 := b.oyuncu.global_position.y
	Input.action_press("zipla")
	await kare(8)
	Input.action_release("zipla")
	Input.action_release("sag")
	dogrula(b.oyuncu.global_position.y < y0 - 30.0, "koyote süresi içinde zıplama çalışmadı")


func test_ziplama_tamponu() -> void:
	var b: Bolum = await baslat(alan())
	b.oyuncu.global_position.y = ZEMIN_Y - 31 - 40  # yere 40 px kala havada
	b.oyuncu.velocity.y = 300.0
	await kare()
	dogrula(not b.oyuncu.is_on_floor(), "oyuncu havada olmalı")
	Input.action_press("zipla")  # yere değmeden önce basıldı
	await kare(1)
	Input.action_release("zipla")
	var en_dusuk_y := b.oyuncu.global_position.y
	var yukseldi := false
	for i in 30:
		await kare()
		if b.oyuncu.velocity.y < -100.0:
			yukseldi = true
	dogrula(yukseldi, "yere değmeden basılan zıplama hatırlanmadı (tampon) y=%.1f" % en_dusuk_y)


func test_seker_sayaci_artar() -> void:
	var b := alan()
	var s := ekle(b, SEKER, Vector2(320, ZEMIN_Y - 40))
	await baslat(b)
	dogrula(b.toplam_seker == 1, "toplam şeker 1 olmalı")
	var sinyal := [0]
	b.seker_degisti.connect(func(n: int) -> void: sinyal[0] = n)
	Input.action_press("sag")
	await kare(40)
	Input.action_release("sag")
	dogrula(b.seker_sayisi == 1, "şekere değince sayaç artmadı (%d)" % b.seker_sayisi)
	dogrula(sinyal[0] == 1, "seker_degisti sinyali gelmedi")
	dogrula(b.gosterge.gosterilen_seker == 1, "gösterge şeker sayısını güncellemedi")
	dogrula(not is_instance_valid(s) or s.alindi, "şeker toplandı olarak işaretlenmedi")


func test_dusmana_degince_can_azalir() -> void:
	var b := alan()
	ekle(b, JOLE, Vector2(300, ZEMIN_Y - 22), {"hiz": 70.0})
	await baslat(b)
	var hasar := [0]
	b.oyuncu.hasar_aldi.connect(func() -> void: hasar[0] += 1)
	await kare(60)
	dogrula(b.oyuncu.can == Oyuncu.BASLANGIC_CANI - 1, "düşmana değince can azalmadı (can=%d)" % b.oyuncu.can)
	dogrula(hasar[0] == 1, "hasar_aldi sinyali bir kez gelmeli (%d)" % hasar[0])
	dogrula(b.gosterge.gosterilen_can == b.oyuncu.can, "gösterge canı güncellemedi")


func test_dokunulmazlik() -> void:
	var b: Bolum = await baslat(alan())
	dogrula(b.oyuncu.hasar_al(0.0), "ilk hasar uygulanmalı")
	dogrula(not b.oyuncu.hasar_al(0.0), "dokunulmazken ikinci hasar uygulanmamalı")
	dogrula(b.oyuncu.can == Oyuncu.BASLANGIC_CANI - 1, "dokunulmazlık canı korumadı")
	await kare(int(Oyuncu.DOKUNULMAZLIK_SURESI * 60.0) + 10)
	dogrula(not b.oyuncu.dokunulmaz_mi(), "dokunulmazlık bitmedi")
	dogrula(b.oyuncu.hasar_al(0.0), "dokunulmazlık bitince hasar alınmalı")


func test_dusmani_ezme() -> void:
	var b := alan()
	var j := ekle(b, JOLE, Vector2(400, ZEMIN_Y - 22), {"hiz": 0.0})
	await baslat(b)
	var ezildi := [false]
	j.ezildi.connect(func() -> void: ezildi[0] = true)
	b.oyuncu.global_position = Vector2(400, ZEMIN_Y - 140)
	b.oyuncu.velocity = Vector2(0, 200)
	await kare(30)
	dogrula(ezildi[0], "üstten düşülen jöle ezilmedi")
	dogrula(b.oyuncu.can == Oyuncu.BASLANGIC_CANI, "jöleyi ezerken can gitmemeli")


func test_dikene_degince_can_azalir_ve_geri_doner() -> void:
	var b := alan()
	ekle(b, DIKEN, Vector2(300, ZEMIN_Y), {"boyut": Vector2(96, 22)})
	await baslat(b)
	var baslangic := b.oyuncu.kontrol_noktasi
	Input.action_press("sag")
	await kare(25)
	Input.action_release("sag")
	await kare(2)
	dogrula(b.oyuncu.can == Oyuncu.BASLANGIC_CANI - 1, "dikene değince can azalmadı (can=%d)" % b.oyuncu.can)
	dogrula(b.oyuncu.global_position.distance_to(baslangic) < 40.0, "dikenden sonra kontrol noktasına dönmedi")


func test_cukura_dusunce_can_azalir() -> void:
	var b := alan(330.0, [[-200.0, 600.0], [700.0, 600.0]])
	ekle(b, CUKUR, Vector2(-200, 1000), {"boyut": Vector2(2000, 200)})
	await baslat(b)
	var baslangic := b.oyuncu.kontrol_noktasi
	Input.action_press("sag")
	await kare(20)
	Input.action_release("sag")
	await kare(50)
	dogrula(b.oyuncu.can == Oyuncu.BASLANGIC_CANI - 1, "çukura düşünce can azalmadı (can=%d)" % b.oyuncu.can)
	dogrula(b.oyuncu.global_position.y < ZEMIN_Y, "çukurdan sonra geri dönmedi")
	dogrula(b.oyuncu.global_position.distance_to(baslangic) < 80.0, "çukurdan sonra kontrol noktasına dönmedi")


func test_kontrol_noktasi() -> void:
	var b := alan()
	var k := ekle(b, KONTROL, Vector2(320, ZEMIN_Y))
	await baslat(b)
	Input.action_press("sag")
	await kare(25)
	Input.action_release("sag")
	dogrula(k.aktif, "kontrol noktası etkinleşmedi")
	dogrula(absf(b.oyuncu.kontrol_noktasi.x - 320.0) < 1.0, "oyuncunun dönüş noktası güncellenmedi")
	b.oyuncu.global_position = Vector2(900, ZEMIN_Y - 31)
	b.oyuncu.tehlikeye_degdi()
	await kare(2)
	dogrula(absf(b.oyuncu.global_position.x - 320.0) < 5.0, "tehlikeden sonra son kontrol noktasına dönmedi")


func test_can_sifirda_oyun_biter() -> void:
	var b: Bolum = await baslat(alan())
	var bitti := [false]
	b.oyun_bitti.connect(func() -> void: bitti[0] = true)
	for i in Oyuncu.BASLANGIC_CANI:
		b.oyuncu.tehlikeye_degdi()
		b.oyuncu._dokunulmaz = 0.0
		await kare(2)
	dogrula(b.oyuncu.can == 0, "can 0 olmalı (%d)" % b.oyuncu.can)
	dogrula(bitti[0], "can 0 olunca oyun_bitti sinyali gelmedi")
	dogrula(b.bitti, "bölüm bitti olarak işaretlenmedi")
	dogrula(b.sonuc_ekrani != null and b.sonuc_ekrani.name.begins_with("OyunBitti"), "oyun bitti ekranı açılmadı")
	dogrula(paused, "oyun bitti ekranında oyun durmalı")


func test_bitise_degince_bolum_tamamlanir() -> void:
	var b := alan()
	ekle(b, SEKER, Vector2(280, ZEMIN_Y - 40))
	ekle(b, SEKER, Vector2(1500, ZEMIN_Y - 40))
	ekle(b, BITIS, Vector2(420, ZEMIN_Y))
	await baslat(b)
	var sonuc := [-1, -1]
	b.bolum_tamamlandi.connect(func(t: int, h: int) -> void:
		sonuc[0] = t
		sonuc[1] = h)
	Input.action_press("sag")
	await kare(50)
	Input.action_release("sag")
	dogrula(sonuc[0] == 1 and sonuc[1] == 2, "bolum_tamamlandi sinyali (1/2) gelmedi: %s" % [sonuc])
	dogrula(b.sonuc_ekrani != null and b.sonuc_ekrani.name.begins_with("BolumBitti"), "bölüm bitti ekranı açılmadı")
	var etiket: Label = b.sonuc_ekrani.sonuc_etiketi
	dogrula(etiket != null and etiket.text.begins_with("1 / 2"), "bölüm bitti ekranında şeker sayısı yok")


func test_bolum_listesi() -> void:
	dogrula(BolumListesi.BOLUMLER.size() >= 1, "bölüm listesi boş")
	for yol in BolumListesi.BOLUMLER:
		dogrula(ResourceLoader.exists(yol), "listedeki bölüm yok: " + yol)


func test_bolum_1_yapisi() -> void:
	var b := (load(BolumListesi.BOLUMLER[0]) as PackedScene).instantiate() as Bolum
	b.set_meta("test_dugumu", true)
	root.add_child(b)
	await kare(3)
	dogrula(b.oyuncu != null, "bölüm 1'de Oyuncu yok")
	dogrula(b.toplam_seker >= 20, "bölüm 1'de en az 20 şeker olmalı (%d)" % b.toplam_seker)
	var bitis_sayisi := 0
	for n in get_nodes_in_group("bitis"):
		if b.is_ancestor_of(n):
			bitis_sayisi += 1
	dogrula(bitis_sayisi == 1, "bölüm 1'de bir bitiş olmalı")
	var dusman := 0
	for n in get_nodes_in_group("dusman"):
		if b.is_ancestor_of(n):
			dusman += 1
	dogrula(dusman >= 1, "bölüm 1'de düşman yok")
	dogrula(get_nodes_in_group("tehlike").size() >= 2, "bölüm 1'de diken ve çukur olmalı")
	dogrula(get_nodes_in_group("kontrol_noktasi").size() >= 1, "bölüm 1'de kontrol noktası yok")


## Basit bir "bot" sağa koşar; önünde boşluk, diken ya da düşman görünce zıplar.
## Bölüm, oyun içi 2 dakikadan kısa sürede bitirilebilmeli.
func test_bolum_1_bastan_sona_oynanabilir() -> void:
	var b := (load(BolumListesi.BOLUMLER[0]) as PackedScene).instantiate() as Bolum
	b.set_meta("test_dugumu", true)
	root.add_child(b)
	await kare(3)
	var tamam := [false]
	b.bolum_tamamlandi.connect(func(_t: int, _h: int) -> void: tamam[0] = true)
	var o := b.oyuncu
	var uzay := o.get_world_2d().direct_space_state
	var basili_kare := 0
	var kareler := 0
	Input.action_press("sag")
	while kareler < 120 * 60 and not tamam[0] and not b.bitti:
		kareler += 1
		if basili_kare > 0:
			basili_kare -= 1
			if basili_kare == 0:
				Input.action_release("zipla")
		elif o.is_on_floor() and _bot_ziplamali(o, uzay):
			Input.action_press("zipla")
			basili_kare = 22
		await physics_frame
	Input.action_release("sag")
	Input.action_release("zipla")
	var sure := kareler / 60.0
	print("    bot: %.1f sn, şeker %d/%d, can %d" % [sure, b.seker_sayisi, b.toplam_seker, o.can])
	dogrula(tamam[0], "bot bölümü bitiremedi (x=%.0f, can=%d)" % [o.global_position.x, o.can])
	dogrula(sure < 120.0, "bölüm 2 dakikadan uzun sürdü")


func _bot_ziplamali(o: Oyuncu, uzay: PhysicsDirectSpaceState2D) -> bool:
	var ayak := o.global_position + Vector2(0, 30)
	# Önde zemin bitiyor mu?
	var bas := ayak + Vector2(46, -4)
	var sorgu := PhysicsRayQueryParameters2D.create(bas, bas + Vector2(0, 60), 1)
	if uzay.intersect_ray(sorgu).is_empty():
		return true
	for n in get_nodes_in_group("tehlike") + get_nodes_in_group("dusman"):
		var hedef := n as Node2D
		if hedef == null or (n is Jole and (n as Jole).ezik):
			continue
		var dx := hedef.global_position.x - o.global_position.x
		var dy := absf(hedef.global_position.y - ayak.y)
		if n is Tehlike and (n as Tehlike).boyut.x > 1000.0:
			continue
		if dx > 20.0 and dx < 110.0 and dy < 60.0:
			return true
	return false


func test_ana_menu_odak() -> void:
	var m := (load("res://arayuz/ana_menu.tscn") as PackedScene).instantiate()
	m.set_meta("test_dugumu", true)
	root.add_child(m)
	await process_frame
	await process_frame
	var d: Array[Button] = m.dugmeler
	dogrula(d.size() == 2, "ana menüde Oyna ve Çıkış olmalı")
	if d.size() == 2:
		dogrula(d[0].text == "Oyna" and d[1].text == "Çıkış", "ana menü düğme yazıları yanlış")
		dogrula(d[0].has_focus(), "ana menüde ilk düğme odakta olmalı (kol/klavye için)")
		dogrula(d[0].get_node(d[0].focus_neighbor_bottom) == d[1], "Oyna'dan aşağı Çıkış'a gidilmeli")
		dogrula(d[1].get_node(d[1].focus_neighbor_bottom) == d[0], "odak sırası döngüsel olmalı")
		# Klavye/kol "aşağı" olayı odağı taşır
		var olay := InputEventAction.new()
		olay.action = "ui_down"
		olay.pressed = true
		root.push_input(olay)
		await process_frame
		dogrula(d[1].has_focus(), "ui_down ile odak Çıkış'a geçmedi")


func test_duraklatma_menusu() -> void:
	var b: Bolum = await baslat(alan())
	var menu: Node = b.get_node("DuraklatMenusu")
	var olay := InputEventAction.new()
	olay.action = "duraklat"
	olay.pressed = true
	root.push_input(olay)
	await process_frame
	dogrula(paused and menu.acik, "duraklat tuşu oyunu durdurmadı")
	await process_frame
	dogrula(menu.dugmeler.size() == 3 and menu.dugmeler[0].has_focus(), "duraklatma menüsünde ilk düğme odakta olmalı")
	var olay2 := InputEventAction.new()
	olay2.action = "duraklat"
	olay2.pressed = true
	root.push_input(olay2)
	await process_frame
	dogrula(not paused and not menu.acik, "duraklat tuşu ikinci basışta devam ettirmedi")


func test_sonuc_ekranlari_odak() -> void:
	var b: Bolum = await baslat(alan())
	b._bitise_ulasildi()
	await process_frame
	await process_frame
	var d: Array[Button] = b.sonuc_ekrani.dugmeler
	var yazilar := d.map(func(x: Button) -> String: return x.text)
	dogrula("Tekrar Oyna" in yazilar and "Ana Menü" in yazilar, "bölüm bitti ekranında Tekrar Oyna / Ana Menü yok")
	dogrula(d.size() > 0 and d[0].has_focus(), "bölüm bitti ekranında ilk düğme odakta olmalı")


func test_ses_dosyasiz_sessiz() -> void:
	# Ses dosyaları olmasa da çağrılar hata vermeden geçmeli.
	for ad in ["zipla", "seker", "hasar", "bitis", "dugme", "olmayan_ses"]:
		Ses.cal(ad)
	Ses.muzik_baslat()
	Ses.muzik_durdur()
	dogrula(true, "")
