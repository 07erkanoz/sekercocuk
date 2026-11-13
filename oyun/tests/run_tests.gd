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
const KUTU := preload("res://sahneler/surpriz_kutusu.tscn")
const YAY := preload("res://sahneler/yay.tscn")
const HAREKETLI := preload("res://sahneler/hareketli_platform.tscn")
const GIZLI := preload("res://sahneler/gizli_alan.tscn")
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
		"test_kutudan_seker_cikar",
		"test_kalp_kutusu_can_verir",
		"test_dusmani_ustten_ezme_odulu",
		"test_dusmana_yandan_degince_can_kaybi",
		"test_yay_oyuncuyu_firlatir",
		"test_hareketli_platformlar_tasir",
		"test_gizli_alan_bonus",
		"test_kontrol_noktasindan_yeniden_dogma",
		"test_bayrak_puani",
		"test_efektler",
		"test_esneme_sikisma",
		"test_paralaks_katmanlari",
		"test_bolum_1_akisi",
		"test_renkler_yalnizca_paletde",
		"test_bolum_1_bastan_sona_oynanabilir",
		"test_zemine_basma_hareketliler",
		"test_zemine_basma_sabit_nesneler",
		"test_zemine_basma_yeni_nesneler",
		"test_ana_menu_odak",
		"test_duraklatma_menusu",
		"test_sonuc_ekranlari_odak",
		"test_ses_dosyasiz_sessiz",
	]
	# İsteğe bağlı süzgeç: ... -s tests/run_tests.gd -- test_adi_parcasi
	var suzgec := Array(OS.get_cmdline_user_args())
	if not suzgec.is_empty():
		testler = testler.filter(func(t: String) -> bool: return suzgec.any(func(p: String) -> bool: return p in t))
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
	await kare(80)  # bayrak animasyonu (kayma + birkaç adım)
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
	dogrula(b.toplam_seker >= 80, "bölüm 1'de en az 80 şeker olmalı (%d)" % b.toplam_seker)
	var bitis_sayisi := 0
	for n in get_nodes_in_group("bitis"):
		if b.is_ancestor_of(n):
			bitis_sayisi += 1
	dogrula(bitis_sayisi == 1, "bölüm 1'de bir bitiş olmalı")
	var dusman := 0
	for n in get_nodes_in_group("dusman"):
		if b.is_ancestor_of(n):
			dusman += 1
	dogrula(dusman >= 3, "bölüm 1'de en az 3 düşman olmalı (%d)" % dusman)
	dogrula(get_nodes_in_group("tehlike").size() >= 2, "bölüm 1'de diken ve çukur olmalı")
	dogrula(get_nodes_in_group("kontrol_noktasi").size() >= 1, "bölüm 1'de kontrol noktası olmalı")
	var kutular := get_nodes_in_group("surpriz_kutusu")
	dogrula(kutular.size() >= 3, "bölüm 1'de en az 3 sürpriz kutusu olmalı")
	dogrula(kutular.any(func(k: Node) -> bool: return k.icerik == 1), "bölüm 1'de kalp çıkan bir kutu olmalı")
	dogrula(get_nodes_in_group("yay").size() >= 1, "bölüm 1'de yay olmalı")
	var hp := get_nodes_in_group("hareketli_platform")
	dogrula(hp.any(func(h: Node) -> bool: return absf(h.hareket.x) > 0.0 and h.hareket.y == 0.0), "yatay hareketli platform yok")
	dogrula(hp.any(func(h: Node) -> bool: return absf(h.hareket.y) > 0.0 and h.hareket.x == 0.0), "dikey hareketli platform yok")
	dogrula(get_nodes_in_group("gizli_alan").size() >= 1, "bölüm 1'de gizli bonus köşesi olmalı")


## Basit bir "bot" sağa koşar; önünde boşluk, duvar/basamak, diken ya da düşman görünce zıplar.
## Bölüm, oyun içi 1–2 dakikada bitirilebilmeli; süre raporlanır.
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
	print("    BOT SURESI: %.1f sn, şeker %d/%d, puan %d, can %d" % [sure, b.seker_sayisi, b.toplam_seker, b.puan, o.can])
	dogrula(tamam[0], "bot bölümü bitiremedi (x=%.0f, can=%d)" % [o.global_position.x, o.can])
	dogrula(sure <= 120.0, "bölüm 2 dakikadan uzun sürdü (%.1f sn)" % sure)
	dogrula(sure >= 60.0, "bot bölümü 1 dakikadan kısa sürede bitirdi (%.1f sn)" % sure)


func _bot_ziplamali(o: Oyuncu, uzay: PhysicsDirectSpaceState2D) -> bool:
	var ayak := o.global_position + Vector2(0, 30)
	# Önde zemin bitiyor mu?
	var bas := ayak + Vector2(46, -4)
	var sorgu := PhysicsRayQueryParameters2D.create(bas, bas + Vector2(0, 60), 1)
	if uzay.intersect_ray(sorgu).is_empty():
		return true
	# Önde duvar/basamak/yay var mı? (diz hizasında yatay ışın)
	var diz := ayak + Vector2(0, -12)
	var duvar := PhysicsRayQueryParameters2D.create(diz, diz + Vector2(48, 0), 1, [o.get_rid()])
	if not uzay.intersect_ray(duvar).is_empty():
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
	dogrula(d.size() == 3, "ana menüde Oyna, Ses ve Çıkış olmalı")
	if d.size() == 3:
		dogrula(d[0].text == "Oyna" and d[2].text == "Çıkış", "ana menü düğme yazıları yanlış")
		dogrula(d[1].text.begins_with("Ses: "), "ses düğmesi 'Ses: Açık/Kapalı' göstermeli")
		d[1].pressed.emit()
		dogrula(d[1].text == "Ses: Kapalı" and not Ses.acik, "ses düğmesi sesi kapatmadı")
		d[1].pressed.emit()
		dogrula(d[1].text == "Ses: Açık" and Ses.acik, "ses düğmesi sesi açmadı")
		dogrula(d[0].has_focus(), "ana menüde ilk düğme odakta olmalı (kol/klavye için)")
		dogrula(d[0].get_node(d[0].focus_neighbor_bottom) == d[1], "Oyna'dan aşağı Ses'e gidilmeli")
		dogrula(d[2].get_node(d[2].focus_neighbor_bottom) == d[0], "odak sırası döngüsel olmalı")
		# Klavye/kol "aşağı" olayı odağı taşır
		var olay := InputEventAction.new()
		olay.action = "ui_down"
		olay.pressed = true
		root.push_input(olay)
		await process_frame
		dogrula(d[1].has_focus(), "ui_down ile odak Ses'e geçmedi")


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


# --- Zemine basma (hiza) testleri ----------------------------------------------
# Kural tema/hiza.gd'de. Ölçüm: görselin gerçekten çizdiği dokunun saydam olmayan alanı
# (Hiza.gorunen) ile zemin görselinin görünen üst kenarı, dünya koordinatında piksel olarak.

const HIZA_TOLERANSI := 1.0


func _bolum_1_kur() -> Bolum:
	var b := (load(BolumListesi.BOLUMLER[0]) as PackedScene).instantiate() as Bolum
	b.set_meta("test_dugumu", true)
	root.add_child(b)
	await kare(3)
	return b


## Nesnenin görselinin görünen alt kenarı (alt kenarın ortası, dünya y'si).
func _gorunen_alt(n: Node2D) -> float:
	var g := n.get_node("Gorsel") as Node2D
	var r: Rect2 = g.call("gorunen_alan")
	dogrula(r.has_area(), "%s görünen alanı boş" % n.name)
	return (g.get_global_transform() * Vector2(r.get_center().x, r.end.y)).y


## Üstüne basılabilen her şey: zemin/platform, hareketli platform, sürpriz kutusu, yay.
func _platformlar(n: Node, liste: Array = []) -> Array:
	for c in n.get_children():
		if c is Platform or c is HareketliPlatform or c is SurprizKutusu or c is Yay:
			liste.append(c)
		_platformlar(c, liste)
	return liste


## x'teki, y'nin hemen altındaki (ya da biraz üstündeki) zeminin görünen üst kenarı (dünya y'si).
func _alttaki_zemin_ustu(b: Node, x: float, y: float) -> float:
	var en_iyi := INF
	for p in _platformlar(b):
		var g := (p as Node2D).get_node("Gorsel") as Node2D
		var r: Rect2 = g.get_global_transform() * g.call("gorunen_alan")
		if x >= r.position.x and x <= r.end.x and r.position.y >= y - 8.0 and r.position.y < en_iyi:
			en_iyi = r.position.y
	return en_iyi


func _basiyor_mu(b: Node, n: Node2D, ne: String) -> void:
	var alt := _gorunen_alt(n)
	var ust := _alttaki_zemin_ustu(b, n.global_position.x, alt)
	dogrula(ust < INF, "%s (%s) altında zemin yok (x=%.0f)" % [ne, n.name, n.global_position.x])
	if ust == INF:
		return
	var bosluk := ust - alt
	dogrula(absf(bosluk) <= HIZA_TOLERANSI,
		"%s (%s) zemine basmıyor: görünen alt %.2f, zemin üstü %.2f, boşluk %.2f px" % [ne, n.name, alt, ust, bosluk])


## Oyuncu ve jöle; bölüm 1'in zemininde ve bir kurabiye platformda.
func test_zemine_basma_hareketliler() -> void:
	var b: Bolum = await _bolum_1_kur()
	var o := b.oyuncu
	await kare(40)
	dogrula(o.is_on_floor(), "oyuncu başlangıç zemininde yerde değil")
	_basiyor_mu(b, o, "oyuncu/zemin")
	# Koşarken her karede de basmalı.
	Input.action_press("sag")
	for i in 30:
		await physics_frame
		if o.is_on_floor():
			_basiyor_mu(b, o, "oyuncu/koşu")
	Input.action_release("sag")

	var p1 := b.get_node("Zemin/Platform1") as Platform
	o.global_position = p1.global_position + Vector2(p1.boyut.x * 0.5, -40.0)
	o.velocity = Vector2.ZERO
	await kare(40)
	dogrula(o.is_on_floor(), "oyuncu platformda yerde değil")
	_basiyor_mu(b, o, "oyuncu/platform")

	var j_zemin: Jole = null
	for n in get_nodes_in_group("dusman"):
		if b.is_ancestor_of(n):
			j_zemin = n
			break
	await kare(10)
	dogrula(j_zemin.is_on_floor(), "jöle zeminde yerde değil")
	_basiyor_mu(b, j_zemin, "jöle/zemin")

	var p2 := b.get_node("Zemin/Platform2") as Platform
	var j := ekle(b, JOLE, p2.global_position + Vector2(p2.boyut.x * 0.5, -30.0), {"mesafe": 30.0}) as Jole
	await kare(40)
	dogrula(j.is_on_floor(), "jöle platformda yerde değil")
	for i in 20:
		await physics_frame
		_basiyor_mu(b, j, "jöle/platform")


## Bitiş, kontrol noktaları, dikenler ve süsler bölüm 1'de zeminin görünen üst kenarında.
func test_zemine_basma_sabit_nesneler() -> void:
	var b: Bolum = await _bolum_1_kur()
	var sayac := {"bitis": 0, "kontrol": 0, "diken": 0, "sus": 0}
	for n in b.find_children("*", "Node2D", true, false):
		var g := n.get_node_or_null("Gorsel")
		if g == null or not g.has_method("gorunen_alan"):
			continue
		if n is Bitis:
			sayac.bitis += 1
		elif n is KontrolNoktasi:
			sayac.kontrol += 1
		elif n is Tehlike:
			sayac.diken += 1
		elif n.get_parent().name == "Suslar":
			sayac.sus += 1
		else:
			continue
		_basiyor_mu(b, n, "sabit nesne")
	dogrula(sayac.bitis == 1 and sayac.kontrol >= 2 and sayac.diken >= 2 and sayac.sus >= 1,
		"sabit nesneler bulunamadı: %s" % [sayac])


# --- Yeni öğeler -------------------------------------------------------------

## Oyuncuyu kutunun altından zıplatır (kafa vuruşu) ve yere inmesini bekler.
func _kafa_vur(b: Bolum, x: float) -> void:
	b.oyuncu.global_position = Vector2(x, ZEMIN_Y - 31)
	b.oyuncu.velocity = Vector2.ZERO
	await kare(4)
	Input.action_press("zipla")
	await kare(20)
	Input.action_release("zipla")
	await kare(40)


func test_kutudan_seker_cikar() -> void:
	var b := alan()
	var k := ekle(b, KUTU, Vector2(300, 470), {"seker_adedi": 2}) as SurprizKutusu
	await baslat(b)
	dogrula(b.toplam_seker == 2, "kutudaki şekerler bölüm toplamına katılmalı (%d)" % b.toplam_seker)
	var verdi := [0]
	k.seker_verdi.connect(func() -> void: verdi[0] += 1)
	await _kafa_vur(b, 300.0)
	dogrula(verdi[0] == 1 and b.seker_sayisi == 1, "kafa vurunca kutudan şeker çıkmadı (%d)" % b.seker_sayisi)
	dogrula(b.puan >= Bolum.SEKER_PUANI, "kutudan çıkan şeker puan vermedi")
	dogrula(not k.bos_mu() and not k.gorsel.bos, "2 şekerli kutu bir vuruşta boşalmamalı")
	await _kafa_vur(b, 300.0)
	dogrula(b.seker_sayisi == 2 and k.bos_mu(), "ikinci vuruşta ikinci şeker çıkıp kutu boşalmalı")
	dogrula(k.gorsel.bos, "boşalan kutunun görünümü değişmedi")
	await _kafa_vur(b, 300.0)
	dogrula(b.seker_sayisi == 2, "boş kutudan şeker çıkmamalı")
	# Kutunun üstüne basılabilir.
	b.oyuncu.global_position = Vector2(300, 380)
	await kare(40)
	dogrula(b.oyuncu.is_on_floor() and b.oyuncu.global_position.y < 470.0 - 56.0, "kutunun üstünde durulamadı")


func test_kalp_kutusu_can_verir() -> void:
	var b := alan()
	var k := ekle(b, KUTU, Vector2(300, 470), {"icerik": 1}) as SurprizKutusu
	await baslat(b)
	dogrula(b.toplam_seker == 0, "kalp kutusu şeker sayılmamalı")
	b.oyuncu.hasar_al(0.0)
	await kare(30)  # sersemleme geçsin
	b.oyuncu._dokunulmaz = 0.0
	var kalp: Array = [null]
	k.kalp_cikti.connect(func(x: Node2D) -> void: kalp[0] = x)
	await _kafa_vur(b, 300.0)
	dogrula(kalp[0] != null, "kalp kutusundan kalp çıkmadı")
	dogrula(k.bos_mu() and k.gorsel.bos, "kalp kutusu bir kez kalp verip boşalmalı")
	if kalp[0] == null:
		return
	b.oyuncu.global_position = kalp[0].global_position
	await kare(4)
	dogrula(b.oyuncu.can == Oyuncu.BASLANGIC_CANI, "kalp alınınca can geri gelmedi (%d)" % b.oyuncu.can)
	dogrula(b.gosterge.gosterilen_can == Oyuncu.BASLANGIC_CANI, "gösterge kalbi göstermedi")
	await _kafa_vur(b, 300.0)
	dogrula(get_nodes_in_group("kalp_odulu").filter(func(x: Node) -> bool: return not x.alindi).is_empty(),
		"kalp kutusundan ikinci kalp çıkmamalı")


func test_dusmani_ustten_ezme_odulu() -> void:
	var b := alan()
	var j := ekle(b, JOLE, Vector2(400, ZEMIN_Y - 22), {"hiz": 0.0}) as Jole
	await baslat(b)
	b.oyuncu.global_position = Vector2(400, ZEMIN_Y - 160)
	b.oyuncu.velocity = Vector2(0, 300)
	var en_dusuk_vy := [0.0]
	var once_puan := b.puan
	for i in 30:
		await physics_frame
		en_dusuk_vy[0] = minf(en_dusuk_vy[0], b.oyuncu.velocity.y)
	dogrula(j.ezik, "üstten basılan jöle ezilmedi")
	dogrula(en_dusuk_vy[0] < -400.0, "ezince oyuncu sekip havalanmadı (vy=%.0f)" % en_dusuk_vy[0])
	dogrula(b.puan == once_puan + Bolum.EZME_PUANI, "ezme puanı verilmedi (%d)" % b.puan)
	dogrula(b.oyuncu.can == Oyuncu.BASLANGIC_CANI, "ezerken can gitmemeli")


func test_dusmana_yandan_degince_can_kaybi() -> void:
	var b := alan()
	var j := ekle(b, JOLE, Vector2(320, ZEMIN_Y - 22), {"hiz": 70.0, "baslangic_yonu": -1}) as Jole
	await baslat(b)
	Input.action_press("sag")
	await kare(30)
	Input.action_release("sag")
	dogrula(b.oyuncu.can == Oyuncu.BASLANGIC_CANI - 1, "yandan değince can gitmedi (%d)" % b.oyuncu.can)
	dogrula(not j.ezik, "yandan değen jöle ezilmemeli")
	dogrula(b.puan == 0, "yandan değmek puan vermemeli")


func test_yay_oyuncuyu_firlatir() -> void:
	var b := alan()
	var y := ekle(b, YAY, Vector2(400, ZEMIN_Y)) as Yay
	await baslat(b)
	var firladi := [false]
	y.firlatti.connect(func() -> void: firladi[0] = true)
	b.oyuncu.global_position = Vector2(400, ZEMIN_Y - 140)
	b.oyuncu.velocity = Vector2.ZERO
	var en_yuksek := INF
	for i in 90:
		await physics_frame
		en_yuksek = minf(en_yuksek, b.oyuncu.global_position.y)
	dogrula(firladi[0], "yaya basınca fırlatma olmadı")
	var yukseklik := (ZEMIN_Y - 34.0 - 30.0) - en_yuksek
	dogrula(yukseklik > 330.0, "yay normal zıplamadan çok yükseğe atmalı (%.0f px)" % yukseklik)
	# Zıplama tuşu basılıyken de güç kaybolmaz.
	b.oyuncu.global_position = Vector2(400, ZEMIN_Y - 140)
	b.oyuncu.velocity = Vector2.ZERO
	await kare(10)
	Input.action_press("zipla")
	en_yuksek = INF
	for i in 90:
		await physics_frame
		en_yuksek = minf(en_yuksek, b.oyuncu.global_position.y)
	Input.action_release("zipla")
	dogrula((ZEMIN_Y - 64.0) - en_yuksek > 330.0, "zıplarken yaya basınca güç kayboldu")


func test_hareketli_platformlar_tasir() -> void:
	var b := alan()
	var yatay := ekle(b, HAREKETLI, Vector2(500, 450), {"hareket": Vector2(300, 0), "sure": 3.0}) as HareketliPlatform
	var dikey := ekle(b, HAREKETLI, Vector2(1200, 500), {"hareket": Vector2(0, -250), "sure": 3.0}) as HareketliPlatform
	await baslat(b)
	var x0 := yatay.global_position.x
	await kare(45)
	dogrula(absf(yatay.global_position.x - x0) > 100.0 and absf(yatay.global_position.y - 450.0) < 0.5, "yatay platform yatay gitmedi")
	var y0 := dikey.global_position.y
	dogrula(absf(dikey.global_position.x - 1200.0) < 0.5 and y0 < 500.0 - 50.0, "dikey platform dikey gitmedi")
	# Oyuncu yatay platformun üstünde taşınır.
	var o := b.oyuncu
	o.global_position = yatay.global_position + Vector2(75, -40)
	o.velocity = Vector2.ZERO
	await kare(10)
	dogrula(o.is_on_floor(), "oyuncu yatay platformda durmadı")
	var fark := o.global_position.x - yatay.global_position.x
	await kare(40)
	dogrula(o.is_on_floor() and absf((o.global_position.x - yatay.global_position.x) - fark) < 4.0, "yatay platform oyuncuyu taşımadı")
	o.global_position = dikey.global_position + Vector2(75, -40)
	o.velocity = Vector2.ZERO
	await kare(10)
	var yy := o.global_position.y
	await kare(40)
	dogrula(o.is_on_floor() and absf(o.global_position.y - yy) > 40.0, "dikey platform oyuncuyu taşımadı")


func test_gizli_alan_bonus() -> void:
	var b := alan()
	var g := ekle(b, GIZLI, Vector2(360, ZEMIN_Y), {"boyut": Vector2(200, 150)}) as GizliAlan
	await baslat(b)
	Input.action_press("sag")
	await kare(50)
	Input.action_release("sag")
	dogrula(g.bulundu_mu and b.bulunan_gizli == 1, "gizli alan bulunmadı")
	dogrula(b.puan == g.bonus_puan, "gizli alan bonus puanı verilmedi (%d)" % b.puan)


func test_kontrol_noktasindan_yeniden_dogma() -> void:
	var b: Bolum = await _bolum_1_kur()
	var orta: KontrolNoktasi = null
	for k in get_nodes_in_group("kontrol_noktasi"):
		if b.is_ancestor_of(k) and absf(k.global_position.x / b.genislik - 0.5) < 0.1:
			orta = k
	dogrula(orta != null, "bölümün ortasında kontrol noktası yok")
	if orta == null:
		return
	var o := b.oyuncu
	o.global_position = orta.global_position + Vector2(-120, -40)
	o.velocity = Vector2.ZERO
	await kare(10)
	Input.action_press("sag")
	await kare(30)
	Input.action_release("sag")
	dogrula(orta.aktif, "orta kontrol noktası etkinleşmedi")
	# Çukura düş: bir can gider, kontrol noktasından devam edilir.
	o.global_position = Vector2(orta.global_position.x + 1500.0, 920.0)
	await kare(10)
	dogrula(o.can == Oyuncu.BASLANGIC_CANI - 1, "çukura düşünce can gitmedi (%d)" % o.can)
	dogrula(absf(o.global_position.x - orta.global_position.x) < 5.0, "kontrol noktasından yeniden doğmadı (x=%.0f)" % o.global_position.x)
	await kare(40)
	dogrula(o.is_on_floor(), "yeniden doğunca zemine inmedi")
	_basiyor_mu(b, o, "oyuncu/yeniden doğma")


func test_bayrak_puani() -> void:
	# 1) Yerden koşarak: en az puan. 2) Yüksekten atlayarak: daha çok puan.
	var b := alan()
	var bitis := ekle(b, BITIS, Vector2(420, ZEMIN_Y)) as Bitis
	await baslat(b)
	dogrula(bitis.puan_hesapla(ZEMIN_Y) == Bitis.EN_AZ_PUAN, "dipte bayrak puanı 100 olmalı")
	dogrula(bitis.puan_hesapla(ZEMIN_Y - 400.0) == Bitis.EN_COK_PUAN, "tepede bayrak puanı 1000 olmalı")
	var orta := bitis.puan_hesapla(ZEMIN_Y - 150.0)
	dogrula(orta > Bitis.EN_AZ_PUAN and orta < Bitis.EN_COK_PUAN, "ortada puan arada olmalı (%d)" % orta)
	var tamam := [false]
	b.bolum_tamamlandi.connect(func(_t: int, _h: int) -> void: tamam[0] = true)
	Input.action_press("sag")
	await kare(40)
	Input.action_release("sag")
	dogrula(bitis.tamam and bitis.puan == Bitis.EN_AZ_PUAN, "yerden tutununca 100 puan olmalı (%d)" % bitis.puan)
	dogrula(not tamam[0] and b.oyuncu.donuk or not tamam[0], "bitiş animasyonu hemen bitmemeli")
	await kare(90)
	dogrula(tamam[0], "bitiş animasyonu sonunda bölüm tamamlanmadı")
	dogrula(b.puan == Bitis.EN_AZ_PUAN, "bayrak puanı bölüm puanına eklenmedi (%d)" % b.puan)
	dogrula(b.oyuncu.global_position.x > 440.0, "bitişte oyuncu birkaç adım yürümedi")
	dogrula(bitis.gorsel.bayrak_konumu > 0.99, "bayrak inmedi")
	var etiket: Label = b.sonuc_ekrani.puan_etiketi
	dogrula(etiket != null and etiket.text == "Puan: %d" % b.puan, "bölüm bitti ekranında puan yok")
	_temizle()
	await physics_frame
	var b2 := alan()
	var bitis2 := ekle(b2, BITIS, Vector2(420, ZEMIN_Y)) as Bitis
	await baslat(b2)
	b2.oyuncu.global_position = Vector2(380, ZEMIN_Y - 300)
	b2.oyuncu.velocity = Vector2(300, 0)
	await kare(10)
	dogrula(bitis2.tamam and bitis2.puan >= 700, "yüksekten tutununca çok puan verilmeli (%d)" % bitis2.puan)
	await kare(100)
	dogrula(b2.bitti and b2.puan == bitis2.puan, "yüksek tutunmada bölüm bitmedi / puan eklenmedi")
	await kare(1)
	_basiyor_mu(b2, b2.oyuncu, "oyuncu/bitiş sonrası")


func _parilti_sayisi() -> int:
	var n := 0
	for c in root.find_children("*", "Node2D", true, false):
		if c is Parilti:
			n += 1
	return n


func test_efektler() -> void:
	var b := alan()
	ekle(b, SEKER, Vector2(320, ZEMIN_Y - 40))
	var j := ekle(b, JOLE, Vector2(900, ZEMIN_Y - 22), {"hiz": 0.0}) as Jole
	await baslat(b)
	Input.action_press("sag")
	var goruldu := false
	for i in 30:
		await physics_frame
		goruldu = goruldu or _parilti_sayisi() > 0
	Input.action_release("sag")
	dogrula(goruldu, "şeker toplayınca parıltı çıkmadı")
	j.ez(b.oyuncu)
	dogrula(_parilti_sayisi() > 0, "düşman ezilince parıltı çıkmadı")
	var yazi := false
	for c in b.get_children():
		yazi = yazi or (c is PuanYazisi and c.text == "+%d" % Bolum.EZME_PUANI)
	dogrula(yazi, "düşman ezilince +100 yazısı çıkmadı")
	await kare(60)
	dogrula(_parilti_sayisi() == 0, "parıltılar kendiliğinden silinmeli")


func test_esneme_sikisma() -> void:
	var b: Bolum = await baslat(alan())
	var g := b.oyuncu.gorsel
	await kare(30)
	Input.action_press("zipla")
	await kare(2)
	dogrula(g.esneme.y > 1.05 and g.esneme.x < 0.95, "zıplarken uzama yok (%s)" % g.esneme)
	Input.action_release("zipla")
	var yassi := false
	for i in 80:
		await physics_frame
		yassi = yassi or (b.oyuncu.is_on_floor() and g.esneme.x > 1.05 and g.esneme.y < 0.95)
	dogrula(yassi, "inişte yassılma yok")
	await kare(30)
	dogrula(g.esneme.distance_to(Vector2.ONE) < 0.02, "esneme normale dönmedi")


func test_paralaks_katmanlari() -> void:
	var g := (load("res://sahneler/gorsel/arka_plan_gorsel.gd") as GDScript)
	var hizlar := [g.RESIM_HIZI, g.BULUT_HIZI, g.TEPE_HIZI, g.YAKIN_TEPE_HIZI]
	dogrula(hizlar.size() >= 3, "en az 3 paralaks katmanı olmalı")
	for i in range(1, hizlar.size()):
		dogrula(hizlar[i] > hizlar[i - 1], "öndeki katman arkadakinden hızlı kaymalı")
	dogrula(hizlar[-1] < 1.0, "arka plan katmanları dünyadan yavaş kaymalı")


## Bölüm akışı: güvenli başlangıç, her yeni öğe önce tek başına, ortada dinlenme alanı.
func test_bolum_1_akisi() -> void:
	var b: Bolum = await _bolum_1_kur()
	var ilk := func(grup: String) -> float:
		var x := INF
		for n in get_nodes_in_group(grup):
			if b.is_ancestor_of(n) and not (n is Tehlike and n.boyut.x > 1000.0):
				x = minf(x, n.global_position.x)
		return x
	var tehlike_ilk: float = ilk.call("tehlike")
	var dusman_ilk: float = ilk.call("dusman")
	var kutu_ilk: float = ilk.call("surpriz_kutusu")
	var yay_ilk: float = ilk.call("yay")
	var hp_ilk: float = ilk.call("hareketli_platform")
	dogrula(minf(tehlike_ilk, dusman_ilk) > 1800.0, "ilk 1800 px güvenli öğrenme alanı olmalı")
	dogrula(kutu_ilk < dusman_ilk and dusman_ilk < yay_ilk and yay_ilk < hp_ilk and hp_ilk < tehlike_ilk,
		"yeni öğeler sırayla tanıtılmalı (kutu %.0f, jöle %.0f, yay %.0f, platform %.0f, diken %.0f)" % [kutu_ilk, dusman_ilk, yay_ilk, hp_ilk, tehlike_ilk])
	# Ortada (kontrol noktası çevresi) en az 1000 px tehlikesiz dinlenme alanı.
	var orta := b.genislik * 0.5
	for n in get_nodes_in_group("tehlike") + get_nodes_in_group("dusman"):
		if b.is_ancestor_of(n) and not (n is Tehlike and n.boyut.x > 1000.0):
			dogrula(absf(n.global_position.x - orta) > 500.0, "dinlenme alanında tehlike var: %s" % n.name)


## Renk kuralı: tema/renkler.gd dışında sabit renk (Color(...), Color.AD, "#rrggbb") yok.
func test_renkler_yalnizca_paletde() -> void:
	var desen := RegEx.create_from_string("Color\\s*\\(|Color8\\s*\\(|Color\\.[A-Z]|\\\"#[0-9a-fA-F]{6}")
	var dosyalar: Array[String] = []
	_dosyalari_topla("res://", dosyalar)
	dogrula(dosyalar.size() > 20, "dosyalar taranamadı")
	for yol in dosyalar:
		if yol == "res://tema/renkler.gd" or yol.begins_with("res://tests/"):
			continue
		var metin := FileAccess.get_file_as_string(yol)
		var m := desen.search(metin)
		dogrula(m == null, "%s içinde sabit renk var: %s" % [yol, m.get_string() if m else ""])


func _dosyalari_topla(klasor: String, liste: Array[String]) -> void:
	var d := DirAccess.open(klasor)
	if d == null:
		return
	for ad in d.get_files():
		if ad.ends_with(".gd") or ad.ends_with(".tscn"):
			liste.append(klasor.path_join(ad))
	for alt in d.get_directories():
		if not alt.begins_with("."):
			_dosyalari_topla(klasor.path_join(alt), liste)


## Kutu, yay, hareketli platform ve bayrak: görünen kenarlar çarpışmaya, tabanlar zemine ≤1 px.
func test_zemine_basma_yeni_nesneler() -> void:
	var b: Bolum = await _bolum_1_kur()
	var sayac := {"kutu": 0, "yay": 0, "hareketli": 0}
	for n in b.find_children("*", "Node2D", true, false):
		if n is SurprizKutusu:
			sayac.kutu += 1
			_gorunen_cakisma(n, "kutu", true)
		elif n is Yay:
			sayac.yay += 1
			_basiyor_mu(b, n, "yay/zemin")
			_gorunen_cakisma(n, "yay", false)
		elif n is HareketliPlatform:
			sayac.hareketli += 1
			var g := (n as Node2D).get_node("Gorsel") as Node2D
			var r: Rect2 = g.get_global_transform() * g.call("gorunen_alan")
			var sekil := (n as Node2D).get_node("Sekil") as CollisionShape2D
			var c: Rect2 = sekil.get_global_transform() * sekil.shape.get_rect()
			dogrula(absf(r.position.y - c.position.y) <= HIZA_TOLERANSI, "%s görünen üst kenar çarpışmadan farklı" % n.name)
	dogrula(sayac.kutu >= 3 and sayac.yay >= 1 and sayac.hareketli >= 2, "yeni nesneler bulunamadı: %s" % [sayac])
	# Oyuncu bir kutunun, yayın yanında ve hareketli platformların üstünde de basmalı.
	var o := b.oyuncu
	var k: SurprizKutusu = get_nodes_in_group("surpriz_kutusu")[0]
	o.global_position = k.global_position + Vector2(0, -56 - 60)
	o.velocity = Vector2.ZERO
	await kare(40)
	dogrula(o.is_on_floor(), "oyuncu kutunun üstünde durmadı")
	_basiyor_mu(b, o, "oyuncu/kutu")
	for h in get_nodes_in_group("hareketli_platform"):
		var hp := h as HareketliPlatform
		o.global_position = hp.global_position + Vector2(hp.boyut.x * 0.5, -40)
		o.velocity = Vector2.ZERO
		await kare(12)
		dogrula(o.is_on_floor(), "oyuncu %s üstünde durmadı" % hp.name)
		for i in 40:
			await physics_frame
			if o.is_on_floor():
				_basiyor_mu(b, o, "oyuncu/" + hp.name)
		break
	var dikey: HareketliPlatform = null
	for h in get_nodes_in_group("hareketli_platform"):
		if h.hareket.y != 0.0:
			dikey = h
	if dikey != null:
		o.global_position = dikey.global_position + Vector2(dikey.boyut.x * 0.5, -40)
		o.velocity = Vector2.ZERO
		await kare(12)
		for i in 60:
			await physics_frame
			if o.is_on_floor():
				_basiyor_mu(b, o, "oyuncu/dikey platform")


## Görünen alan ile çarpışma dikdörtgeni: üst kenar (ve istenirse alt kenar) en çok 1 px farklı.
func _gorunen_cakisma(n: Node2D, ne: String, alt_da: bool) -> void:
	var g := n.get_node("Gorsel") as Node2D
	var r: Rect2 = g.get_global_transform() * g.call("gorunen_alan")
	var sekil := n.get_node("Sekil") as CollisionShape2D
	var c: Rect2 = sekil.get_global_transform() * sekil.shape.get_rect()
	dogrula(absf(r.position.y - c.position.y) <= HIZA_TOLERANSI,
		"%s (%s) görünen üst %.2f, çarpışma üstü %.2f" % [ne, n.name, r.position.y, c.position.y])
	if alt_da:
		dogrula(absf(r.end.y - c.end.y) <= HIZA_TOLERANSI,
			"%s (%s) görünen alt %.2f, çarpışma altı %.2f" % [ne, n.name, r.end.y, c.end.y])
