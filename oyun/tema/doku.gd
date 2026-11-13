class_name Doku
extends RefCounted
## varliklar/gorsel/ altındaki PNG'leri yükler (içe aktarılmamışsa doğrudan dosyadan okur).

const KLASOR := "res://varliklar/gorsel/"
static var _onbellek := {}


static func yukle(ad: String) -> Texture2D:
	if _onbellek.has(ad):
		return _onbellek[ad]
	var yol := KLASOR + ad + ".png"
	var doku: Texture2D = null
	if ResourceLoader.exists(yol):
		doku = load(yol) as Texture2D
	elif FileAccess.file_exists(yol):
		var im := Image.load_from_file(yol)
		if im != null:
			doku = ImageTexture.create_from_image(im)
	_onbellek[ad] = doku
	return doku
