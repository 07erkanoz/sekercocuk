# Plan

| # | İş | Sınıf | Model | Durum | Bitmiş sayılır |
|---|---|---|---|---|---|
| 24 | Taslak A: Yumuşak pastel çayır | derin | claude-code/opus | bitti | taslaklar/a-pastel/index.html ve 1280x720 boyutunda ekran.png var, sahnede karakter, platformlar, yıldızlar ve gösterge görünüyor. |
| 25 | Taslak B: Parlak çizgi film şeker dünyası | derin | codex/gpt-6.1-sol | bitti | taslaklar/b-seker/index.html ve 1280x720 boyutunda ekran.png var, sahnede karakter, platformlar, toplanacak nesneler, düşman ve gösterge görünüyor. |
| 26 | Taslak C: Kâğıttan kesme orman macerası | derin | claude-code/opus | bitti | taslaklar/c-kagit/index.html ve 1280x720 boyutunda ekran.png var, sahnede karakter, katmanlı orman, platformlar, toplanacak nesneler ve gösterge görünüyor. |
| 27 | Denetim: #24 Taslak A: Yumuşak pastel çayır | standart | groq/openai/gpt-oss-120b | bitti | Kanıtlı bir karar |
| 28 | Denetim: #24 Taslak A: Yumuşak pastel çayır | standart | groq/openai/gpt-oss-120b | bitti | Kanıtlı bir karar |
| 29 | Denetim: #26 Taslak C: Kâğıttan kesme orman macerası | standart | groq/openai/gpt-oss-120b | bitti | Kanıtlı bir karar |
| 30 | Denetim: #25 Taslak B: Parlak çizgi film şeker dünyası | standart | groq/openai/gpt-oss-120b | bitti | Kanıtlı bir karar |
| 31 | Oyun çekirdeği ve tek bölüm | derin | claude-code/opus | bitti | Başsız testlerin hepsi geçiyor; bölüm baştan sona oynanabilir, menüler klavye ve kolla gezilebilir. |
| 32 | Şeker dünyası görselleri | gorsel | codex/imagegen | bitti | Listelenen tüm PNG'ler istenen boyutlarda mevcut ve önizleme paftası taslak B'ye uyuyor. |
| 33 | Ses efektleri ve müzik | standart | claude-code/sonnet | bitti | Betik çalışıyor ve altı ses dosyası üretiliyor. |
| 34 | Görsel/ses bağlama ve Linux sürümü | standart | claude-code/sonnet | bitti | Testler geçiyor, oyun uygulama menüsüne kurulu, ciktilar/ekran_bolum1.png var. |
| 35 | Son gözden geçirme | standart | claude-code/sonnet | bitti | Sekiz maddenin hepsi için GEÇTİ/KALDI içeren rapor verildi. |
| 36 | Denetim: #33 Ses efektleri ve müzik | standart | codex/gpt-6.1-sol | bitti | Kanıtlı bir karar |
| 37 | Denetim: #32 Şeker dünyası görselleri | standart | claude-code/sonnet | bitti | Kanıtlı bir karar |
| 38 | Denetim: #32 Şeker dünyası görselleri | standart | claude-code/sonnet | bitti | Kanıtlı bir karar |
| 39 | Denetim: #31 Oyun çekirdeği ve tek bölüm | standart | claude-code/sonnet | bitti | Kanıtlı bir karar |
| 40 | Denetim: #34 Görsel/ses bağlama ve Linux sürümü | standart | codex/gpt-6.1-sol | bitti | Kanıtlı bir karar |
| 41 | Sabit renkleri renk paletine taşı | hizli | groq/openai/gpt-oss-120b | bitti | İki dosyada da sabit renk kalmamış, renkler renkler.gd'den geliyor ve tüm testler geçiyor. |
| 42 | Bölüm 1'i 1–2 dakikalık oyuna uzat | standart | claude-code/sonnet | bitti | Tüm testler geçiyor, bot bölüm 1'i bitiriyor ve süresi en az 40 saniye (yaklaşık 45–75 saniye). Bölüm kademeli zorlaşıyor. |
| 43 | Düzeltmelerden sonra son kontrol | standart | claude-code/sonnet | bitti | 7 maddenin hepsi için GEÇTİ ya da KALDI ile gerekçeli bir rapor verilmiş. |
| 44 | Denetim: #42 Bölüm 1'i 1–2 dakikalık oyuna uzat | standart | codex/gpt-6.1-sol | bitti | Kanıtlı bir karar |
| 45 | Havada durma hatasının nedenini bul | derin | claude-code/opus | bitti | Her nesne türü için ölçülmüş boşluk, kesin neden, ilgili dosya/özellik ve somut düzeltme önerisi raporlandı. |
| 46 | Karakter ve nesnelerin zemine tam basmasını sağla | derin | claude-code/opus | bitti | Başsız testler (yeni zemin hizası testi dahil) geçiyor; ciktilar/ekran_zemin.png'de oyuncu, düşman ve nesneler zeminle boşluksuz temas ediyor; görünüm ve oynanı |
| 47 | Bölüm 1'e Mario tadında oynanış ve süs ekle | derin | claude-code/opus | bitti | Listedeki 9 madde bölümde yer alıyor; tüm başsız testler (yeni testler dahil) geçiyor; bot bölümü 60–120 sn'de bitiriyor; renkler.gd dışında sabit renk yok; cik |
| 48 | Denetim: #46 Karakter ve nesnelerin zemine tam basmasını sağla | standart | claude-code/sonnet | bitti | Kanıtlı bir karar |
| 49 | Denetim: #46 Karakter ve nesnelerin zemine tam basmasını sağla | standart | claude-code/sonnet | bitti | Kanıtlı bir karar |
| 50 | Denetim: #47 Bölüm 1'e Mario tadında oynanış ve süs ekle | standart | claude-code/sonnet | bitti | Kanıtlı bir karar |
| 56 | Zemin düzeltmesi ve yeni oynanıştan sonra son kontrol | standart | claude-code/sonnet | bitti | 7 maddenin hepsi GEÇTİ ya da KALDI olarak, kanıtıyla raporlanmış; testlerin sonucu yazılmış. |
