@tool
class_name Platform
extends StaticBody2D
## Zemin ve platformlar. Konum = sol üst köşe.
## tur 0 = kurabiye zemin (katı), 1 = yüzen kurabiye, 2 = jöle blok (1 ve 2 alttan geçilebilir).

@export_enum("Zemin", "Kurabiye", "Jöle") var tur := 0:
	set(d):
		tur = d
		_guncelle()
@export var boyut := Vector2(400, 200):
	set(d):
		boyut = d
		_guncelle()


func _ready() -> void:
	_guncelle()


func _guncelle() -> void:
	if not is_node_ready():
		return
	var gorsel := get_node_or_null("Gorsel")
	if gorsel != null:
		gorsel.set("tur", tur)
		gorsel.set("boyut", boyut)
	if Engine.is_editor_hint():
		return
	var sekil := $Sekil as CollisionShape2D
	var dikdortgen := RectangleShape2D.new()
	dikdortgen.size = boyut
	sekil.shape = dikdortgen
	sekil.position = boyut * 0.5
	sekil.one_way_collision = tur != 0
