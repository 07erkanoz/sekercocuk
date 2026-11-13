class_name Bolum
extends Node2D
## Her bölüm sahnesinin kök betiği. Bölüm sahnesi yalnızca oyun nesnelerini içerir
## (Oyuncu, Platform, HareketliPlatform, Seker, SurprizKutusu, Yay, Jole, Diken, Cukur,
## KontrolNoktasi, GizliAlan, Bitis); gösterge, duraklatma ve sonuç ekranlarını bu betik ekler.
## Puan: şeker 10, düşman ezme 100, gizli köşe 500, bayrak 100–1000.

signal seker_degisti(sayi: int)
signal puan_degisti(puan: int)
signal bolum_tamamlandi(toplanan: int, toplam: int)
signal oyun_bitti

const GOSTERGE := preload("res://arayuz/gosterge.tscn")
const DURAKLAT := preload("res://arayuz/duraklat_menusu.tscn")
const BOLUM_BITTI := preload("res://arayuz/bolum_bitti.tscn")
const OYUN_BITTI := preload("res://arayuz/oyun_bitti.tscn")
const ARKA_PLAN := preload("res://sahneler/arka_plan.tscn")
const SEKER_PUANI := 10
const EZME_PUANI := 100

@export var bolum_adi := "Bölüm"
## Kameranın gidebileceği en sağ nokta.
@export var genislik := 4000.0
## Sonuç ekranlarından sonra oyun durdurulsun mu? (testlerde kapatılabilir)
@export var bitince_duraklat := true

var seker_sayisi := 0
var toplam_seker := 0
var puan := 0
var bulunan_gizli := 0
var bitti := false
var oyuncu: Oyuncu
var gosterge: Node
var sonuc_ekrani: Node


func _ready() -> void:
	get_tree().paused = false
	oyuncu = get_node_or_null("Oyuncu") as Oyuncu
	add_child(ARKA_PLAN.instantiate())
	for s in get_tree().get_nodes_in_group("seker"):
		if is_ancestor_of(s):
			toplam_seker += 1
			s.toplandi.connect(_seker_toplandi)
	for k in get_tree().get_nodes_in_group("surpriz_kutusu"):
		if is_ancestor_of(k):
			toplam_seker += k.seker_sayisi()
			k.seker_verdi.connect(_seker_toplandi)
	for d in get_tree().get_nodes_in_group("dusman"):
		if is_ancestor_of(d) and d.has_signal("ezildi"):
			d.ezildi.connect(_dusman_ezildi.bind(d))
	for g in get_tree().get_nodes_in_group("gizli_alan"):
		if is_ancestor_of(g):
			g.bulundu.connect(_gizli_bulundu.bind(g))
	for b in get_tree().get_nodes_in_group("bitis"):
		if is_ancestor_of(b):
			b.ulasildi.connect(_bitise_ulasildi)
			b.tutunuldu.connect(puan_ekle)
	gosterge = GOSTERGE.instantiate()
	add_child(gosterge)
	add_child(DURAKLAT.instantiate())
	if oyuncu != null:
		oyuncu.can_degisti.connect(_can_degisti)
		oyuncu.oldu.connect(_oyuncu_oldu)
		oyuncu.kamera.limit_right = int(genislik)
		oyuncu.kamera.reset_smoothing()
		gosterge.can_goster(oyuncu.can)
	gosterge.seker_goster(seker_sayisi)
	Ses.muzik_baslat()


func _seker_toplandi() -> void:
	seker_sayisi += 1
	gosterge.seker_goster(seker_sayisi)
	seker_degisti.emit(seker_sayisi)
	puan_ekle(SEKER_PUANI)


func puan_ekle(miktar: int) -> void:
	puan += miktar
	puan_degisti.emit(puan)


func _dusman_ezildi(dusman: Node2D) -> void:
	puan_ekle(EZME_PUANI)
	if is_instance_valid(dusman):
		PuanYazisi.goster(dusman, dusman.global_position + Vector2(0, -20), "+%d" % EZME_PUANI)


func _gizli_bulundu(alan: GizliAlan) -> void:
	bulunan_gizli += 1
	puan_ekle(alan.bonus_puan)


func _can_degisti(can: int) -> void:
	gosterge.can_goster(can)


func _bitise_ulasildi() -> void:
	if bitti:
		return
	bitti = true
	if oyuncu != null:
		oyuncu.kontrol_acik = false
	bolum_tamamlandi.emit(seker_sayisi, toplam_seker)
	sonuc_ekrani = BOLUM_BITTI.instantiate()
	add_child(sonuc_ekrani)
	sonuc_ekrani.goster(seker_sayisi, toplam_seker, puan)
	_durdur()


func _oyuncu_oldu() -> void:
	if bitti:
		return
	bitti = true
	oyun_bitti.emit()
	sonuc_ekrani = OYUN_BITTI.instantiate()
	add_child(sonuc_ekrani)
	sonuc_ekrani.goster(seker_sayisi)
	_durdur()


func _durdur() -> void:
	if bitince_duraklat:
		get_tree().paused = true
