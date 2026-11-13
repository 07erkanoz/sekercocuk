class_name SurprizKutusu
extends StaticBody2D
## Sürpriz kutusu: oyuncu alttan kafa vurunca kutu zıplar ve içinden şeker (ya da bir kez kalp) çıkar.
## Boşalınca görünümü değişir. Konum = kutunun alt kenarının ortası (bkz. tema/hiza.gd).
## Oyuncu kafa vuruşunu oyuncu.gd bildirir (alttan_vuruldu).

signal seker_verdi
signal kalp_cikti(kalp: Node2D)
signal bosaldi

const KALP := preload("res://sahneler/kalp.tscn")
const SEKER_GORSEL := preload("res://sahneler/gorsel/seker_gorsel.tscn")
const BOYUT := 56.0

@export_enum("Şeker", "Kalp") var icerik := 0
## Şeker kutusundan kaç vuruşta kaç şeker çıkacağı.
@export var seker_adedi := 1

var kalan := 1
var _bekleme := 0.0

@onready var gorsel: Node2D = $Gorsel


func _ready() -> void:
	add_to_group("surpriz_kutusu")
	kalan = seker_adedi if icerik == 0 else 1


## Bölüm toplamına katılacak şeker sayısı.
func seker_sayisi() -> int:
	return seker_adedi if icerik == 0 else 0


func bos_mu() -> bool:
	return kalan <= 0


func _physics_process(delta: float) -> void:
	_bekleme = maxf(_bekleme - delta, 0.0)


func alttan_vuruldu(_oyuncu: Node = null) -> void:
	if _bekleme > 0.0:
		return
	_bekleme = 0.18
	_zipla()
	if kalan <= 0:
		Ses.cal("kutu")
		return
	kalan -= 1
	var ust := global_position + Vector2(0, -BOYUT)
	if icerik == 1:
		var k := KALP.instantiate() as Node2D
		get_parent().add_child(k)
		k.global_position = ust + Vector2(0, -6)
		k.call("cik", ust + Vector2(0, -46))
		kalp_cikti.emit(k)
		Ses.cal("kalp")
	else:
		_seker_firlat(ust)
		seker_verdi.emit()
		Ses.cal("seker")
	Ses.cal("kutu")
	Parilti.patlat(self, ust, 8, 8.0)
	if kalan <= 0:
		gorsel.set("bos", true)
		bosaldi.emit()


func _zipla() -> void:
	var t := create_tween()
	t.tween_property(gorsel, "kayma", -12.0, 0.07).set_ease(Tween.EASE_OUT)
	t.tween_property(gorsel, "kayma", 0.0, 0.1).set_ease(Tween.EASE_IN)


## Kutudan fırlayıp dönerek sönen şeker (sayılması seker_verdi ile olur).
func _seker_firlat(ust: Vector2) -> void:
	var s := SEKER_GORSEL.instantiate() as Node2D
	s.set("sallan", false)
	get_parent().add_child(s)
	s.global_position = ust + Vector2(0, -10)
	s.z_index = 4
	var t := s.create_tween()
	t.tween_property(s, "global_position:y", ust.y - 90.0, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	t.parallel().tween_property(s, "rotation", TAU, 0.35)
	t.tween_property(s, "global_position:y", ust.y - 50.0, 0.15).set_ease(Tween.EASE_IN)
	t.parallel().tween_property(s, "modulate:a", 0.0, 0.15)
	t.tween_callback(s.queue_free)
