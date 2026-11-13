extends SceneTree
## Bölüm 1'in ekran görüntüsünü alır (Xvfb altında, başsız olmayan Godot ile):
##   xvfb-run -a godot --path oyun -s res://../araclar/ekran_al.gd -- ../ciktilar/ekran_bolum1.png
## Betik oyun/ içine kopyalanarak da çalıştırılabilir (araclar/linux_kur.sh'a gerek yok).

func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var yol := args[0] if args.size() > 0 else "ekran_bolum1.png"
	var sahne := (load("res://bolumler/bolum_1.tscn") as PackedScene).instantiate()
	root.add_child(sahne)
	for i in 90:
		await process_frame
	var oyuncu := sahne.find_child("Oyuncu", true, false)
	if oyuncu != null:
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
