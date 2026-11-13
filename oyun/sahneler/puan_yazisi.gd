class_name PuanYazisi
extends Label
## Ödül anında yukarı süzülüp sönen kısa yazı ("+100", "Gizli köşe!").
## Stil tema/tema.gd'deki "PuanYazisi" türünden gelir. Kullanım: PuanYazisi.goster(kaynak, konum, "+100")

const SAHNE := "res://sahneler/puan_yazisi.tscn"


static func goster(kaynak: Node, konum: Vector2, yazi: String) -> PuanYazisi:
	var ebeveyn := kaynak.get_parent() if kaynak != null else null
	if ebeveyn == null or not ebeveyn.is_inside_tree():
		return null
	var e := (load(SAHNE) as PackedScene).instantiate() as PuanYazisi
	e.text = yazi
	ebeveyn.add_child(e)
	e.global_position = konum - Vector2(e.size.x * 0.5, 40.0)
	e._canlandir()
	return e


func _ready() -> void:
	theme = Tema.olustur()
	theme_type_variation = "PuanYazisi"
	z_index = 6
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	size = Vector2(240, 44)
	pivot_offset = size * 0.5
	scale = Vector2(0.6, 0.6)


func _canlandir() -> void:
	var t := create_tween()
	t.tween_property(self, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.parallel().tween_property(self, "position:y", position.y - 60.0, 0.8).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "modulate:a", 0.0, 0.25)
	t.tween_callback(queue_free)
