class_name Ses
extends RefCounted
## Ses yardımcısı. varliklar/ses/ altındaki dosyalar varsa çalar, yoksa sessizce geçer.
## Beklenen dosyalar: zipla, seker, hasar, bitis, dugme, kutu, yay, ezme, kalp (.wav), muzik.ogg
## Kullanım: Ses.cal("zipla"), Ses.muzik_baslat(), Ses.muzik_durdur()

const KLASOR := "res://varliklar/ses/"
const MUZIK := "muzik.ogg"

static var _onbellek := {}
static var _muzik: AudioStreamPlayer
## Ses açık/kapalı (ana menüdeki düğme).
static var acik := true


static func ac_kapat() -> void:
	acik = not acik
	if acik:
		muzik_baslat()
	else:
		muzik_durdur()


## Kısa bir efekt çalar (ad uzantısız: "zipla" → zipla.wav).
static func cal(ad: String) -> void:
	if not acik:
		return
	var akis := _yukle(ad + ".wav")
	if akis == null:
		return
	var kok := _kok()
	if kok == null:
		return
	var oynatici := AudioStreamPlayer.new()
	oynatici.stream = akis
	oynatici.process_mode = Node.PROCESS_MODE_ALWAYS
	oynatici.finished.connect(oynatici.queue_free)
	kok.add_child(oynatici)
	oynatici.play()


static func muzik_baslat() -> void:
	if not acik:
		return
	if is_instance_valid(_muzik) and _muzik.playing:
		return
	var akis := _yukle(MUZIK)
	if akis == null:
		akis = _yukle("muzik.wav")
		if akis is AudioStreamWAV:
			var w := akis as AudioStreamWAV
			w.loop_mode = AudioStreamWAV.LOOP_FORWARD
			w.loop_begin = 0
			w.loop_end = w.data.size() / (2 if w.format == AudioStreamWAV.FORMAT_16_BITS else 1) / (2 if w.stereo else 1)
	if akis == null:
		return
	var kok := _kok()
	if kok == null:
		return
	if akis is AudioStreamOggVorbis:
		(akis as AudioStreamOggVorbis).loop = true
	if not is_instance_valid(_muzik):
		_muzik = AudioStreamPlayer.new()
		_muzik.process_mode = Node.PROCESS_MODE_ALWAYS
		_muzik.volume_db = -8.0
		kok.add_child(_muzik)
	_muzik.stream = akis
	_muzik.play()


static func muzik_durdur() -> void:
	if is_instance_valid(_muzik):
		_muzik.stop()


static func _kok() -> Node:
	var agac := Engine.get_main_loop() as SceneTree
	return agac.root if agac != null else null


static func _yukle(dosya: String) -> AudioStream:
	if _onbellek.has(dosya):
		return _onbellek[dosya]
	var yol := KLASOR + dosya
	var akis: AudioStream = null
	if ResourceLoader.exists(yol):
		akis = load(yol) as AudioStream
	elif FileAccess.file_exists(yol):
		# İçe aktarılmamış (yeni kopyalanmış) dosyalar için doğrudan okuma.
		if dosya.ends_with(".wav"):
			akis = AudioStreamWAV.load_from_file(yol)
		elif dosya.ends_with(".ogg"):
			akis = AudioStreamOggVorbis.load_from_file(yol)
	_onbellek[dosya] = akis
	return akis
