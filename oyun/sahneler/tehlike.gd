@tool
class_name Tehlike
extends Area2D
## Diken ya da çukur: oyuncu değince bir can gider ve son kontrol noktasına döner.
## Konum = alanın sol alt köşesi; alan yukarı ve sağa doğru "boyut" kadar uzanır.

@export var boyut := Vector2(96, 22):
	set(d):
		boyut = d
		_guncelle()


func _ready() -> void:
	_guncelle()
	if Engine.is_editor_hint():
		return
	add_to_group("tehlike")
	body_entered.connect(_govde_girdi)


func _guncelle() -> void:
	if not is_node_ready():
		return
	var sekil := get_node_or_null("Sekil") as CollisionShape2D
	if sekil != null and not Engine.is_editor_hint():
		var dikdortgen := RectangleShape2D.new()
		dikdortgen.size = boyut
		sekil.shape = dikdortgen
		sekil.position = Vector2(boyut.x * 0.5, -boyut.y * 0.5)
	var gorsel := get_node_or_null("Gorsel")
	if gorsel != null:
		gorsel.set("genislik", boyut.x)


func _govde_girdi(govde: Node2D) -> void:
	if govde is Oyuncu:
		(govde as Oyuncu).tehlikeye_degdi.call_deferred()
