class_name HareketliPlatform
extends StaticBody2D
## İki nokta arasında yumuşakça gidip gelen kurabiye platform (alttan geçilebilir).
## Oyuncudan önce (aynı fizik karesinde) taşınır ve hızını constant_linear_velocity ile bildirir;
## böylece üstündeki oyuncu bir kare geride kalmadan taşınır (zemine basma kuralı, ≤1 px).
## Konum = başlangıçtaki sol üst köşe; "hareket" kadar öteye gidip döner (yatay ya da dikey).
## Görünümü Platform ile aynıdır (platform_gorsel, tur 1); görünen üst kenar çarpışmanın üstüdür.

@export var boyut := Vector2(150, 46)
@export var hareket := Vector2(320, 0)
## Bir gidiş-dönüşün süresi (sn).
@export var sure := 4.0
## 0..1: hareketin hangi noktasından başlayacağı.
@export var faz := 0.0

var _baslangic := Vector2.ZERO
var _zaman := 0.0


func _ready() -> void:
	add_to_group("hareketli_platform")
	# Oyuncudan önce hareket eder (sahnede process_physics_priority = -10), üstündeki oyuncu
	# aynı karede taşınır (boşluk kalmaz).
	_baslangic = position
	_zaman = faz * sure
	var sekil := $Sekil as CollisionShape2D
	var dikdortgen := RectangleShape2D.new()
	dikdortgen.size = boyut
	sekil.shape = dikdortgen
	sekil.position = boyut * 0.5
	sekil.one_way_collision = true
	var gorsel := $Gorsel
	gorsel.set("tur", 1)
	gorsel.set("boyut", boyut)
	position = _konum(_zaman)


func _konum(t: float) -> Vector2:
	var oran := 0.5 - 0.5 * cos(TAU * t / maxf(sure, 0.1))
	return _baslangic + hareket * oran


func _physics_process(delta: float) -> void:
	_zaman += delta
	var yeni := _konum(_zaman)
	constant_linear_velocity = (yeni - position) / maxf(delta, 0.0001)
	position = yeni
	# Godot dönüşüm bildirimlerini kare sonunda toplar; çarpışma şekli şimdi güncellensin ki
	# oyuncu bu karede platformun yeni yerine bassın.
	PhysicsServer2D.body_set_state(get_rid(), PhysicsServer2D.BODY_STATE_TRANSFORM, global_transform)
