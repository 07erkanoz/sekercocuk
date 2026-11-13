class_name Oyuncu
extends CharacterBody2D
## Oyuncu karakteri: koşma, zıplama (koyote süresi + zıplama tamponu), 3 can,
## hasardan sonra kısa dokunulmazlık. Çocuk dostu: affedici zamanlamalar.
## Çarpışmaları nesnelere bildirir: alttan kafa vuruşu → alttan_vuruldu(), üstüne basma → ustune_basildi().

signal can_degisti(can: int)
signal hasar_aldi
signal oldu
signal ziplandi

const HIZ := 320.0
const YER_IVMESI := 2600.0
const HAVA_IVMESI := 1900.0
const YER_SURTUNMESI := 3200.0
const YERCEKIMI := 1900.0
const MAKS_DUSUS := 1100.0
const ZIPLAMA_HIZI := -760.0
## Tuş bırakılınca yükselme bu oranda kesilir (kısa/uzun zıplama).
const KISA_ZIPLAMA_ORANI := 0.5
## Kenardan çıktıktan sonra hâlâ zıplanabilen süre.
const KOYOTE_SURESI := 0.14
## Yere değmeden önce basılan zıplama bu süre hatırlanır.
const ZIPLAMA_TAMPONU := 0.16
const DOKUNULMAZLIK_SURESI := 1.5
const SERSEMLEME_SURESI := 0.25
const GERI_TEPME := Vector2(320.0, -430.0)
const EZME_SEKMESI := -620.0
const BASLANGIC_CANI := 3

var can := BASLANGIC_CANI
var kontrol_acik := true
var kontrol_noktasi := Vector2.ZERO
var yon := 1
## Bitiş animasyonunda: fizik dondurulur (direkten kayarken), sonra kendiliğinden yürür.
var donuk := false
var bitirdi := false
var _otomatik_yon := 0
var _havada_en_hizli := 0.0

var _koyote := 0.0
var _tampon := 0.0
var _dokunulmaz := 0.0
var _sersem := 0.0
var _zipliyor := false

@onready var gorsel: Node2D = $Gorsel
@onready var kamera: Camera2D = $Kamera


func _ready() -> void:
	Hiza.gorseli_tabana_oturt(self)
	kontrol_noktasi = global_position


func _physics_process(delta: float) -> void:
	var giris := 0.0
	var zipla_basildi := false
	var zipla_tutuluyor := false
	if donuk:
		velocity = Vector2.ZERO
		_gorseli_guncelle()
		return
	if kontrol_acik and _sersem <= 0.0:
		giris = Input.get_axis("sol", "sag")
		zipla_basildi = Input.is_action_just_pressed("zipla")
		zipla_tutuluyor = Input.is_action_pressed("zipla")
	elif not kontrol_acik:
		giris = float(_otomatik_yon)

	_sersem = maxf(_sersem - delta, 0.0)
	_dokunulmaz = maxf(_dokunulmaz - delta, 0.0)

	# Koyote süresi ve zıplama tamponu
	if is_on_floor():
		_koyote = KOYOTE_SURESI
	else:
		_koyote = maxf(_koyote - delta, 0.0)
	if zipla_basildi:
		_tampon = ZIPLAMA_TAMPONU
	else:
		_tampon = maxf(_tampon - delta, 0.0)

	# Yerçekimi
	if not is_on_floor():
		velocity.y = minf(velocity.y + YERCEKIMI * delta, MAKS_DUSUS)

	# Zıplama
	if _tampon > 0.0 and _koyote > 0.0:
		# Yaydan fırlarken daha güçlü yukarı hız korunur.
		velocity.y = minf(velocity.y, ZIPLAMA_HIZI)
		_tampon = 0.0
		_koyote = 0.0
		ziplandi.emit()
		Ses.cal("zipla")
		_zipliyor = true
		_esne(Vector2(0.78, 1.25))
	elif _zipliyor and velocity.y < -200.0 and not zipla_tutuluyor and kontrol_acik:
		velocity.y *= KISA_ZIPLAMA_ORANI
		_zipliyor = false
	if velocity.y >= 0.0:
		_zipliyor = false

	# Yatay hareket
	if absf(giris) > 0.05:
		var ivme := YER_IVMESI if is_on_floor() else HAVA_IVMESI
		velocity.x = move_toward(velocity.x, giris * HIZ, ivme * delta)
		yon = 1 if giris > 0.0 else -1
	elif _sersem <= 0.0:
		var surtunme := YER_SURTUNMESI if is_on_floor() else HAVA_IVMESI * 0.5
		velocity.x = move_toward(velocity.x, 0.0, surtunme * delta)

	var yerdeydi := is_on_floor()
	if not yerdeydi:
		_havada_en_hizli = maxf(_havada_en_hizli, velocity.y)
	move_and_slide()
	_carpismalari_bildir()
	if is_on_floor() and not yerdeydi and _havada_en_hizli > 350.0:
		_esne(Vector2(1.28, 0.76))
	if is_on_floor():
		_havada_en_hizli = 0.0
	_gorseli_guncelle()


## Kafa vuruşunu (sürpriz kutusu) ve üstüne basmayı (yay) çarpışılan nesneye bildirir.
func _carpismalari_bildir() -> void:
	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		var nesne := c.get_collider()
		if nesne == null:
			continue
		var n := c.get_normal()
		if n.y > 0.7 and nesne.has_method("alttan_vuruldu"):
			nesne.alttan_vuruldu(self)
		elif n.y < -0.7 and nesne.has_method("ustune_basildi"):
			nesne.ustune_basildi(self)


## Zıplama/iniş esneme-sıkışması (görsel tabandan ölçeklenir, ayak zeminde kalır).
func _esne(olcek: Vector2) -> void:
	if gorsel != null and gorsel.has_method("esne"):
		gorsel.esne(olcek)


func _gorseli_guncelle() -> void:
	if gorsel == null:
		return
	gorsel.set("yon", yon)
	gorsel.set("hiz", velocity)
	gorsel.set("yerde", is_on_floor())
	# Dokunulmazken yanıp söner.
	gorsel.visible = _dokunulmaz <= 0.0 or fmod(_dokunulmaz, 0.2) > 0.08


func dokunulmaz_mi() -> bool:
	return _dokunulmaz > 0.0


## Bir candan vazgeçer. Dokunulmazken etkisizdir. Hasar uygulandıysa true döner.
func hasar_al(kaynak_x: float) -> bool:
	if _dokunulmaz > 0.0 or can <= 0 or bitirdi:
		return false
	can -= 1
	_dokunulmaz = DOKUNULMAZLIK_SURESI
	can_degisti.emit(can)
	hasar_aldi.emit()
	Ses.cal("hasar")
	if can <= 0:
		kontrol_acik = false
		velocity = Vector2(0.0, ZIPLAMA_HIZI * 0.6)
		oldu.emit()
		return true
	var geri := signf(global_position.x - kaynak_x)
	if geri == 0.0:
		geri = -float(yon)
	velocity = Vector2(geri * GERI_TEPME.x, GERI_TEPME.y)
	_sersem = SERSEMLEME_SURESI
	return true


## Diken ya da çukur: can kaybı ve son kontrol noktasına dönüş.
func tehlikeye_degdi() -> void:
	if can <= 0 or bitirdi:
		return
	if _dokunulmaz <= 0.0:
		hasar_al(global_position.x)
	if can > 0:
		kontrol_noktasina_don()


func kontrol_noktasina_don() -> void:
	global_position = kontrol_noktasi
	velocity = Vector2.ZERO
	_sersem = 0.0
	_dokunulmaz = maxf(_dokunulmaz, 1.0)
	if kamera != null:
		kamera.reset_smoothing()


## Düşmanın üstüne basınca yukarı sekme.
func sek() -> void:
	velocity.y = EZME_SEKMESI
	_koyote = 0.0
	_zipliyor = false
	_esne(Vector2(0.8, 1.22))


## Yay gibi nesnelerin fırlatması: yukarı "hiz" kadar (tuş bırakılsa da kısalmaz).
func firlat(hiz: float) -> void:
	velocity.y = -absf(hiz)
	_koyote = 0.0
	_tampon = 0.0
	_zipliyor = false
	_esne(Vector2(0.7, 1.35))


## Bir can geri verir (en çok başlangıç canı). Can arttıysa true.
func can_ekle(miktar: int = 1) -> bool:
	if can <= 0 or can >= BASLANGIC_CANI:
		return false
	can = mini(can + miktar, BASLANGIC_CANI)
	can_degisti.emit(can)
	return true


## Bitiş direğine tutununca: kontrol kapanır, fizik donar, hasar alınmaz.
func bitise_tutun() -> void:
	bitirdi = true
	kontrol_acik = false
	donuk = true
	velocity = Vector2.ZERO
	_dokunulmaz = 0.0


## Bitiş animasyonunda kendiliğinden yürüme (1 = sağa, 0 = dur).
func bitise_yuru(yon_: int) -> void:
	donuk = false
	_otomatik_yon = yon_
