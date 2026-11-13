extends SceneTree
## Bölüm 1'in ekran görüntüsünü alır (Xvfb altında, başsız olmayan Godot ile):
##   xvfb-run -a godot --path oyun -s res://../araclar/ekran_al.gd -- ../ciktilar/ekran_bolum1.png
## Betik oyun/ içine kopyalanarak da çalıştırılabilir (araclar/linux_kur.sh'a gerek yok).
## İkinci argüman bir x verilirse oyuncu o noktada zemine bırakılır ve durduğu an çekilir:
##   ... -- ../ciktilar/ekran_zemin.png 15120

func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var yol := args[0] if args.size() > 0 else "ekran_bolum1.png"
	var sahne := (load("res://bolumler/bolum_1.tscn") as PackedScene).instantiate()
	root.add_child(sahne)
	for i in 90:
		await process_frame
	var oyuncu := sahne.find_child("Oyuncu", true, false) as CharacterBody2D
	if oyuncu != null and args.size() > 1:
		oyuncu.global_position = Vector2(float(args[1]), 500.0)
		oyuncu.velocity = Vector2.ZERO
		var kamera := oyuncu.get_node_or_null("Kamera") as Camera2D
		for i in 120:
			await process_frame
		if kamera != null:
			kamera.reset_smoothing()
		for i in 10:
			await process_frame
		print("oyuncu yerde: ", oyuncu.is_on_floor(), " ", oyuncu.global_position)
	elif oyuncu != null:
		Input.action_press("sag")
		for i in 60:
			await process_frame
		Input.action_release("sag")
		for i in 30:
			await process_frame
	await RenderingServer.frame_post_draw
	var im := root.get_texture().get_image()
	var e := im.save_png(yol)
	print("ekran: ", yol, " ", im.get_size(), " ", e)
	quit()
