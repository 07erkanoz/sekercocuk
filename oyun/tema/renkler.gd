class_name Renkler
extends RefCounted
## Taslak B (parlak çizgi film şeker dünyası) renk paleti.
## Oyundaki TÜM renkler burada tanımlıdır; başka dosyada renk kodu yazılmaz.

# Çizgi ve yazı
const MUREKKEP := Color("21172d")
const BEYAZ := Color("ffffff")
const KREM := Color("fff8e5")

# Gökyüzü ve uzak manzara
const GOK_UST := Color("ffb1dc")
const GOK_ORTA := Color("ffd3e8")
const GOK_ALT := Color("8df0e2")
const ARKA := Color("79e7df")
const GUNES := Color("fff4ae")
const BULUT := Color("fff6f1")
const GOKKUSAGI_1 := Color("ff98c4")
const GOKKUSAGI_2 := Color("ffe79d")
const GOKKUSAGI_3 := Color("b7f9e6")
const TEPE_UZAK := Color("c5a2eb")
const TEPE_ORTA := Color("84d9ce")
const TEPE_YAKIN := Color("5ec9b3")
const YAPRAK := Color("c8f6c9")

# Kurabiye zemin ve platformlar
const HAMUR_ACIK := Color("ffc16b")
const HAMUR_KOYU := Color("df8549")
const KIRINTI := Color("b76b3e")
const KIRINTI_ACIK := Color("ffd591")
const KREMA_PEMBE := Color("ff85ca")
const SERPME := Color("fff4b7")
const KURABIYE_KREMA := Color("fff2da")
const KURABIYE_CIZGI := Color("b96b39")
const JOLE_ACIK := Color("c0ff78")
const JOLE_KOYU := Color("5ed958")
const JOLE_CIZGI := Color("329c48")
const JOLE_PARLAK := Color("cfff8c")

# Düşman jöle
const PEMBE_ACIK := Color("ff9ddc")
const PEMBE_KOYU := Color("ed48b5")

# Şeker, kalp, parıltı
const SEKER_SARI := Color("ffd84c")
const SEKER_KANAT := Color("fff29a")
const SEKER_SERIT := Color("ff8c44")
const PARILTI := Color("fff9cf")
const ISILTI := Color("fffbb0")
const KALP := Color("ff658b")

# Lolipop, baston şeker, bayrak
const LOLIPOP_DIS := Color("ff749b")
const LOLIPOP_IC := Color("ffd572")
const LOLIPOP_SARMAL := Color("ff679a")
const LOLIPOP_SAP := Color("fff6da")
const BASTON := Color("fff8e0")
const BASTON_SERIT := Color("ff719c")
const BAYRAK := Color("ffdf55")
const BAYRAK_DIREK := Color("fff7d9")
const BAYRAK_TOP := Color("fff6d1")

# Kahraman
const KAHRAMAN := Color("4ce1df")
const KAHRAMAN_GOVDE := Color("40d7d5")
const KAHRAMAN_KOYU := Color("22a4b5")
const KAHRAMAN_PANTOLON := Color("2bb9cb")
const PELERIN := Color("ff5b72")
const PELERIN_KOYU := Color("ce365b")
const FULAR := Color("ffd24a")
const FULAR_KOYU := Color("ffbf38")
const BOT := Color("fff1c4")
const YANAK := Color("ff8eb8")
const AGIZ := Color("fff8e4")

# Ön plan bitkileri
const BITKI := Color("72e886")
const MOR_BITKI := Color("bc8de4")
const PEMBE_BITKI := Color("ffadd7")

# Yarı saydam tonlar
const GOLGE := Color(0.129, 0.090, 0.176, 0.16)
const PERDE := Color(0.129, 0.090, 0.176, 0.45)
const BOS_KALP := Color(0.129, 0.090, 0.176, 0.15)


## Bir palet renginin saydamlığını değiştirir.
static func saydam(renk: Color, alfa: float) -> Color:
	return Color(renk, alfa)
