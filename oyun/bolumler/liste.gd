class_name BolumListesi
extends RefCounted
## Oyundaki bölümlerin sırası. Yeni bölüm eklemek için listeye tek satır yazmak yeter:
##     "res://bolumler/bolum_2.tscn",

const BOLUMLER := [
	"res://bolumler/bolum_1.tscn",
]

## Şu an oynanan bölümün sırası (0'dan başlar).
static var secili := 0


static func yol(sira: int) -> String:
	return BOLUMLER[sira]
