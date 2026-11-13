@tool
extends Node2D
## Sürpriz kutusu görünümü: sarı, kalın mürekkep çizgili kutu, ortasında şeker. Boşalınca (bos=true)
## kurabiye rengine döner, şeker simgesi kaybolur. (0,0) = kutunun alt kenarının ortası (bkz. tema/hiza.gd);
## görünen alan çarpışma kutusunun tam üstüdür: üstüne basılır, altından kafa vurulur.

const BOYUT := 56.0

@export var bos := false:
	set(d):
		bos = d
		queue_redraw()
## Vurulunca kutunun anlık yukarı kayması (zıplama animasyonu).
var kayma := 0.0:
	set(d):
		kayma = d
		queue_redraw()

var _zaman := 0.0


func _process(delta: float) -> void:
	if bos or Engine.is_editor_hint():
		return
	_zaman += delta
	queue_redraw()


func gorunen_alan() -> Rect2:
	return Rect2(-BOYUT * 0.5, -BOYUT + kayma, BOYUT, BOYUT)


func _draw() -> void:
	var r := gorunen_alan()
	var ic := r.grow(-5.0)
	if bos:
		Cizim.kutu(self, r, 10.0, Renkler.KUTU_BOS)
		for n in [Vector2(-12, -14), Vector2(10, -20), Vector2(-4, -36), Vector2(13, -40), Vector2(-15, -44)]:
			draw_circle(n + Vector2(0, kayma), 3.0, Renkler.KUTU_BOS_KOYU)
		return
	Cizim.kutu(self, r, 10.0, Renkler.KUTU)
	# Üstte açık, altta koyu şerit: yuvarlak, şekerli bir blok hissi.
	draw_rect(Rect2(ic.position + Vector2(5, 2), Vector2(ic.size.x - 10, 6)), Renkler.KUTU_ACIK)
	draw_rect(Rect2(ic.position + Vector2(5, ic.size.y - 8), Vector2(ic.size.x - 10, 5)), Renkler.KUTU_KOYU)
	for k in [Vector2(-18, -46), Vector2(18, -46), Vector2(-18, -10), Vector2(18, -10)]:
		draw_circle(k + Vector2(0, kayma), 2.5, Renkler.KUTU_KOYU)
	var d := Doku.yukle("seker")
	if d != null:
		var sallanma := sin(_zaman * 4.0) * 0.12
		draw_set_transform(r.get_center(), -0.2 + sallanma, Vector2(1.15, 1.15))
		draw_texture(d, -d.get_size() * 0.5)
		draw_set_transform(Vector2.ZERO)
	var parla := 0.5 + 0.5 * sin(_zaman * 5.0)
	Cizim.parilti(self, r.position + Vector2(BOYUT - 10, 9), 4.0 + parla * 3.0, Renkler.PARILTI)
