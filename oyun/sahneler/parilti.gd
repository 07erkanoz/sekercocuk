class_name Parilti
extends Node2D
## Kısa parıltı patlaması: dört köşeli yıldızlar ve küçük şeker kırıntıları dışa saçılıp söner.
## Kullanım: Parilti.patlat(kaynak_dugum, dunya_konumu)  (kaynağın ebeveynine eklenir).
## Şeker toplama, düşman ezme, kutu vurma, yay, kalp ve gizli köşe bu sahneyi kullanır.

const SAHNE := "res://sahneler/parilti.tscn"
const SURE := 0.5

@export var adet := 10
@export var hiz := 220.0
@export var boy := 9.0

var _parcalar: Array = []
var _zaman := 0.0


static func patlat(kaynak: Node, konum: Vector2, adet_: int = 10, boy_: float = 9.0) -> Parilti:
	var ebeveyn := kaynak.get_parent() if kaynak != null else null
	if ebeveyn == null or not ebeveyn.is_inside_tree():
		return null
	var p := (load(SAHNE) as PackedScene).instantiate() as Parilti
	p.adet = adet_
	p.boy = boy_
	ebeveyn.add_child(p)
	p.global_position = konum
	return p


func _ready() -> void:
	z_index = 5
	var renkler := [Renkler.PARILTI, Renkler.SEKER_SARI, Renkler.KREMA_PEMBE, Renkler.BEYAZ, Renkler.JOLE_ACIK]
	for i in adet:
		var a := TAU * (float(i) + randf() * 0.6) / float(adet)
		var h := hiz * randf_range(0.55, 1.0)
		_parcalar.append({
			"hiz": Vector2(cos(a), sin(a)) * h,
			"renk": renkler[i % renkler.size()],
			"yildiz": i % 2 == 0,
			"boy": boy * randf_range(0.7, 1.15),
		})


func _process(delta: float) -> void:
	_zaman += delta
	if _zaman >= SURE:
		queue_free()
		return
	queue_redraw()


func _draw() -> void:
	var t := _zaman / SURE
	var kalan := 1.0 - t
	for p in _parcalar:
		# Yavaşlayarak dışa açılır (ease-out).
		var konum: Vector2 = p.hiz * SURE * (1.0 - kalan * kalan) * 0.5
		var renk: Color = Renkler.saydam(p.renk, kalan)
		var b: float = p.boy * (0.5 + kalan * 0.5)
		if p.yildiz:
			Cizim.parilti(self, konum, b, renk)
		else:
			draw_circle(konum, b * 0.4, renk)
