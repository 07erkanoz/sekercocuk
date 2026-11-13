# Şeker Dünyası

LifeOS Ekip tutar: ekip kaldığı yerden devam etmek için bu dosyaları okur.

**Hedef:** Çocuklar için basit, renkli bir 2B platform oyunu yapmak istiyorum. Linux'ta çalışsın.

## Proje kartı

- **Amaç:** Linux'ta çalışan, şeker dünyası görünümlü, küçük bir 2B platform oyunu denemesi yapmak: tek bölümde koş, zıpla, şekerleri topla ve bölümü bitir. Beğenilirse sonra büyütülecek.
- **Hedef kitle:** 10–14 yaş arası çocuklar ve oyunu onlar için açan ebeveynler
- **Kapsamda:** Godot 4 (GDScript) ile tek oyunculu 2B platform oyunu
- **Kapsamda:** Tek oynanabilir karakter ve kısa, tek bir bölüm: koşma, zıplama, toplanacak şekerler, basit bir düşman ya da engel, bölüm sonu
- **Kapsamda:** Seçilen taslak B'deki (taslaklar/b-seker/ekran.png) parlak, çizgi film tadında şeker dünyası görünümü
- **Kapsamda:** Klavye ve oyun kolu desteği
- **Kapsamda:** Kısa Türkçe arayüz: başlangıç ekranı, gösterge (şeker sayısı, can), bölüm bitti ekranı
- **Kapsamda:** Ses efektleri ve basit müzik
- **Kapsamda:** Linux'ta tek tıkla açılan sürüm (uygulama menüsünde simgesi olur)
- **Kapsamda:** Sonradan bölüm eklemeyi kolaylaştıracak düzen
- **Kapsamda:** Karakterin, düşmanların ve diğer nesnelerin zemine tam basması (kullanıcının bildirdiği havada durma hatasının düzeltilmesi)
- **Kapsam dışı:** İlk aşamada birden çok bölüm ya da dünya (6 bölüm, 2 dünya sonraya kaldı)
- **Kapsam dışı:** Çevrim içi oyun, hesap, reklam, uygulama içi satın alma
- **Kapsam dışı:** Windows/macOS/mobil sürüm
- **Kapsam dışı:** Kişisel veri toplama
- **Başarı ölçütü:** Oyun bu Linux PC'de uygulama menüsünden açılıyor ve bölüm baştan sona oynanabiliyor
- **Başarı ölçütü:** Klavye ve oyun kolu ile hareket, zıplama ve menülerde gezinme çalışıyor
- **Başarı ölçütü:** Hareket, toplama, can kaybı ve bölüm bitirme için yazılan otomatik testler (başsız Godot) geçiyor
- **Başarı ölçütü:** Karakter ve düşmanlar zeminde dururken görselin alt kenarı ile zeminin görünen üst kenarı arasındaki boşluk en çok 1 piksel; bunu ölçen bir otomatik test geçiyor ve ekran görüntüsünde boşluk görünmüyor
- **Başarı ölçütü:** Bölümün ekran görüntüsü alınıyor ve taslak B'nin görünümüne uyuyor
- **Başarı ölçütü:** 10–14 yaş bir çocuk bölümü açıklama okumadan, ilk birkaç denemede bitirebiliyor

## Kararlar

- Oyunu hangi araçla yapalım?: **Godot 4 (GDScript)**
- Oyun hangi yaştaki çocuklar için?: **10–14 yaş**
- Çocuk oyunu neyle oynayacak?: **Klavye ve oyun kolu**
- İlk sürüm ne büyüklükte olsun?: **Orta: 6 bölüm, 2 dünya**
- Hangi görünüm olsun?: **B: Şeker dünyası**
- Oyun hangi araçla yapılsın?: **Godot 4 (GDScript)**
- Oyun hangi yaştaki çocuklar için?: **10–14 yaş**
- Çocuk oyunu neyle oynayacak?: **Klavye ve gamepad**
- Plan: **onaylandı**
- Plan: **onaylandı**
