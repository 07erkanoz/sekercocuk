class_name Bitis
extends Area2D
## Bölüm sonu bayrak direği. Oyuncu direğe ne kadar yüksekten tutunursa o kadar puan alır
## (100–1000). Kısa bitiş animasyonu: oyuncu direkten kayar, bayrak iner, oyuncu birkaç adım
## sağa yürür; sonra "ulasildi" sinyali bir kez verilir.

signal ulasildi
signal tutunuldu(puan: int)

const EN_AZ_PUAN := 100
const EN_COK_PUAN := 1000
const YURUME_SURESI := 0.6

var tamam := false
## Tutunulan yüksekliğe göre verilen puan (tutununca belli olur).
var puan := 0
var tutunma_orani := 0.0

@onready var gorsel: Node2D = $Gorsel


func _ready() -> void:
	add_to_group("bitis")
	body_entered.connect(_govde_girdi)


func direk_boyu() -> float:
	return gorsel.get("DIREK_BOYU")


## Ayak yüksekliğine (zeminden) göre puan: dipte 100, tepede 1000, 100'lük adımlarla.
func puan_hesapla(ayak_y: float) -> int:
	var yukseklik := global_position.y - ayak_y
	tutunma_orani = clampf(yukseklik / (direk_boyu() - 40.0), 0.0, 1.0)
	var adim := int(round(tutunma_orani * float(EN_COK_PUAN - EN_AZ_PUAN) / 100.0))
	return EN_AZ_PUAN + adim * 100


func _govde_girdi(govde: Node2D) -> void:
	if tamam or not govde is Oyuncu or (govde as Oyuncu).can <= 0:
		return
	tamam = true
	var o := govde as Oyuncu
	var ayak := o.global_position.y + Hiza.govde_tabani(o)
	puan = puan_hesapla(ayak)
	tutunuldu.emit(puan)
	Ses.cal("bitis")
	Parilti.patlat(self, o.global_position, 14, 11.0)
	PuanYazisi.goster(self, Vector2(global_position.x, ayak - 30.0), "+%d" % puan)
	o.bitise_tutun()
	o.global_position.x = global_position.x - 16.0
	var dip := global_position.y - Hiza.govde_tabani(o)
	var kayma := clampf((dip - o.global_position.y) / 500.0, 0.15, 0.7)
	var t := create_tween()
	t.tween_property(o, "global_position:y", dip, kayma)
	t.parallel().tween_property(gorsel, "bayrak_konumu", 1.0, kayma)
	t.tween_callback(func() -> void: o.bitise_yuru(1))
	t.tween_interval(YURUME_SURESI)
	t.tween_callback(func() -> void:
		o.bitise_yuru(0)
		ulasildi.emit())
