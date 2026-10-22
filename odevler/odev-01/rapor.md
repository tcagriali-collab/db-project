# Ödev Raporu

**Ödev no:** Ödev 1     **Hafta:** 1-5     **Tarih:** 23 / 10 / 2026

**Ad Soyad:** Çağrı Ali Turhan  **Öğrenci No:** 202507131014

**Program:** ☐ Yapay Zeka Operatörlüğü  ☒ Robotik ve Yapay Zeka

**Kullandığım veritabanı:** ☐ `llm_ops`  ☒ `robot_fleet`

**PR bağlantısı:** https://github.com/tcagriali-collab/db-project/pull/1

**Commit sayısı:** 4

---

## 1. Ne yaptım

Bölüm 1'de bir döngüyü elle izledim, en uzun seriyi sayaçla buldum ve dersleri sözlükle saydım. Sözlükle saymak, `GROUP BY course` ile `count(*)` sorgusunun elle yapılmış hali: ikisi de her farklı değer için bir kutu açıp içine düşenleri sayıyor. Bölüm 2'de veritabanının Excel'e göre neden daha güvenli olduğunu yazdım. Bölüm 3 ve 4'te `robot_fleet` üzerinde 30 sorgu yazdım. En çok öğrendiğim şey, tek bir NULL değerin sayma, toplama, ortalama ve filtre sonuçlarını sessizce değiştirmesi oldu.

## 2. Sonuçlar

Çözdüğüm soru sayısı: 30 / 30     Bonus: ☐ denedim ☒ denemedim

En zorlandığım soru: **Hafta 5, Soru 13** (iki ortalama). Hangisinin "doğru" olduğu sorgudan değil, verinin anlamından çıkıyor. Kartal-04'ün bataryası 0 değil, sadece bilinmiyor. Bu yüzden boşu atlayan ortalamayı (42.3) seçtim ve raporda "9 robot üzerinden" diye belirtmek gerektiğini yazdım.

## 3. Beklemediğim bir sonuç

**Soru no:** Hafta 5, Kayıp kayıtlar   **Beklediğim:** 10 satır   **Gelen:** 5 + 4 = 9 satır

**Sebebi:** Kartal-04'ün bataryası NULL. NULL hem `< 50` hem `>= 50` testinde "bilinmiyor" sonucunu verdiği için iki sorguya da girmedi.

Raporda sorulan diğer noktalar:
- **Parantez tuzağı (H4 S7):** Parantezle 1 satır, parantezsiz 2 satır geldi. AND, OR'dan önce çalıştığı için şarjdaki Kartal-04 batarya koşuluna bakılmadan listeye girdi.
- **Türkçe sıralama (H4 S14):** COLLATE olmadan Çağla, İsmail ve Şule listenin sonuna düştü. `tr-TR-x-icu` ile Çağla Can'dan, İsmail Emre'den, Şule Kerem'den sonra doğru yerine geldi.
- **İki ortalama (H5 S13):** 42.3 ile 38.1, fark 4.2 puan. Gerekçe yukarıda.

## 4. Aldığım bir hata ve çözümü

**Hata mesajı:** `Locale specified is not supported.` (PostgreSQL kurulumunda)

**Sebebi ve çözümü:** Kurulumda Türkçe dil ayarı verildi, kurulum programı bu adı tanımadı. Ayarı çıkarıp sunucuyu UTF8 ile kendim başlattım. Türkçe sıralamayı da sorguda `COLLATE "tr-TR-x-icu"` ile sağladım. Ayrıca H5 S8 için önce "8 satır" yazmıştım; çalıştırınca 7 geldi ve yorumu düzelttim. Satır sayısını yazma kuralı bu hatayı yakaladı.

## 5. Yapay zeka kullanım beyanı

☒ Kullandım, aşağıda belirttim:

| Soru no | Araç | Ne sordum (özet) | Cevabı nasıl doğruladım |
|---|---|---|---|
| Bölüm 1 (hepsi) | Claude (Claude Code) | Ödevi birlikte çözmesini istedim; iz tablosunu ve iki algoritmayı yazdı | `python bolum1.py` çalıştırdım: 14, [7, 9, 5, 1], 5 ve beklenen sözlük çıktı |
| Bölüm 2 | Claude | Dört kavram sorusu için taslak cevap | Ders notlarıyla karşılaştırıp kendi cümlelerimle düzenledim |
| Bölüm 3-4 (30 sorgu) | Claude | Sorguları ve yorumları yazdı, PostgreSQL kurulumuna yardım etti | Her sorguyu kendi `robot_fleet` veritabanımda çalıştırdım, satır sayılarını tabloyla tek tek karşılaştırdım; bir yanlış satır sayısını (H5 S8) böyle yakaladık |

## 6. Öz değerlendirme

| Ölçüt | 4 Tam | 3 İyi | 2 Gelişmeli | 1 Yetersiz |
|---|---|---|---|---|
| A, Doğruluk | ☐ | ☐ | ☐ | ☐ |
| B, SQL kalitesi | ☐ | ☐ | ☐ | ☐ |
| C, Yorum ve analiz | ☐ | ☐ | ☐ | ☐ |
| D, Git ve PR disiplini | ☐ | ☐ | ☐ | ☐ |
| E, Dürüstlük ve beyan | ☐ | ☐ | ☐ | ☐ |

Bir dahaki ödevde daha iyi yapacağım şey: ______________________________________

## 7. Bana sorun

______________________________________________________________________

**İmza:** ________________________

*Doğruluk beyanı: Kullandığım tüm yardımcı kaynakları ve yapay zeka araçlarını yukarıda beyan ettim.*
