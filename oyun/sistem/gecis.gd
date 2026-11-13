class_name Gecis
extends RefCounted
## Sahne geçişleri: ana menü, bölüm başlatma, yeniden deneme.

const ANA_MENU := "res://arayuz/ana_menu.tscn"


static func bolum_baslat(sira: int = 0) -> void:
	BolumListesi.secili = clampi(sira, 0, BolumListesi.BOLUMLER.size() - 1)
	_degistir(BolumListesi.yol(BolumListesi.secili))


static func yeniden_baslat() -> void:
	_degistir(BolumListesi.yol(BolumListesi.secili))


static func sonraki_var() -> bool:
	return BolumListesi.secili + 1 < BolumListesi.BOLUMLER.size()


static func sonraki_bolum() -> void:
	bolum_baslat(BolumListesi.secili + 1)


static func ana_menu() -> void:
	_degistir(ANA_MENU)


static func _degistir(yol: String) -> void:
	var agac := Engine.get_main_loop() as SceneTree
	agac.paused = false
	agac.change_scene_to_file.call_deferred(yol)
