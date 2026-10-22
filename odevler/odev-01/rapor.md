# Ödev Raporu

**Ödev no:** Ödev 1     **Hafta:** 1-5     **Tarih:** 23 / 10 / 2026

**Ad Soyad:** Çağrı Ali Turhan  **Öğrenci No:** 202507131014

**Program:** ☒ Yapay Zeka Operatörlüğü  ☐ Robotik ve Yapay Zeka

**Kullandığım veritabanı:** ☒ `llm_ops`  ☐ `robot_fleet`

**PR bağlantısı:** https://github.com/tcagriali-collab/db-project/pull/1

**Commit sayısı:** 5

---

## 1. Ne yaptım

Bölüm 1'de bir döngüyü elle izledim, en uzun seriyi sayaçla buldum ve dersleri sözlükle saydım. Sözlükle saymak `GROUP BY course` + `count(*)` sorgusunun elle yapılmış hali: ikisi de her farklı değer için bir kutu açıp içine düşenleri sayıyor. Bölüm 2'de veritabanının Excel'e göre neden güvenli olduğunu yazdım. Bölüm 3 ve 4'te `llm_ops` üzerinde 30 sorgu yazdım. En çok öğrendiğim şey, tek bir NULL değerin toplam, ortalama ve filtre sonuçlarını sessizce değiştirmesi oldu.

## 2. Sonuçlar

Çözdüğüm soru sayısı: 30 / 30     Bonus: ☒ denedim (`robot_fleet` sürümü, `bonus_robot_fleet/` klasöründe)

En zorlandığım soru: **Hafta 5, Soru 13** (iki ortalama). Hangisinin doğru olduğu sorgudan değil, verinin anlamından çıkıyor. 11 numaralı çağrı bedava değil, faturası henüz gelmedi; bu yüzden boşu atlayan ortalamayı (0.00574 $) seçtim.

## 3. Beklemediğim bir sonuç

**Soru no:** Hafta 4, Soru 10   **Beklediğim:** 1 satır   **Gelen:** 3 satır

**Sebebi:** `LIKE '%mini%'` sadece gpt-4o-mini'yi değil, "ge**mini**" kelimesini içeren gemini-flash ve gemini-pro'yu da getirdi.

- **Parantez tuzağı (H4 S7):** Parantezli de parantezsiz de 3 satır geldi, fark 0. Parantezsiz sorgu code çağrılarında maliyete bakmıyor, ama bu veride iki code çağrısı zaten 0.01 $'ın üstünde. Sorgu yanlış, sadece veri hatayı göstermedi.
- **Türkçe sıralama (H4 S14):** Hiçbir isim yer değiştirmedi; hiçbir kullanıcı adı Ç, Ğ, İ, Ö, Ş, Ü ile başlamıyor.
- **Kayıp kayıtlar (H5):** `cost_usd < 0.005` 7, `>= 0.005` 4 satır; 11 eder, 12 değil. Faturası gelmeyen çağrı (NULL) iki koşula da girmedi.
- **İki ortalama (H5 S13):** 0.00574 ile 0.00526, fark yaklaşık 0.0005 $ (%8). Eksik çağrı pahalı bir gpt-4o çağrısı; 0 saymak ortalamayı yapay olarak düşürür.

## 4. Aldığım bir hata ve çözümü

**Hata mesajı:** `ERROR: for SELECT DISTINCT, ORDER BY expressions must appear in select list` (H4 S14)

**Sebebi ve çözümü:** `ORDER BY user_name COLLATE "tr-TR-x-icu"` yazınca sıralama ifadesi SELECT'teki `user_name`'den farklı sayıldı. COLLATE'i SELECT'e taşıdım: `SELECT DISTINCT user_name COLLATE "tr-TR-x-icu" AS user_name`.

## 5. Yapay zeka kullanım beyanı

☒ Kullandım:

| Soru no | Araç | Ne sordum (özet) | Cevabı nasıl doğruladım |
|---|---|---|---|
| Bölüm 1 | Claude (Claude Code) | Ödevi birlikte çözmesini istedim; iz tablosu ve iki algoritma | `python bolum1.py` çalıştırdım: 14, [7, 9, 5, 1], 5 ve beklenen sözlük |
| Bölüm 2 | Claude | Dört kavram sorusu için taslak | Ders notlarıyla karşılaştırdım |
| Bölüm 3-4 | Claude | Sorgular, yorumlar, PostgreSQL kurulumu | Her sorguyu kendi `llm_ops` veritabanımda çalıştırıp satır sayılarını tabloyla karşılaştırdım; iki yanlış yorumu böyle düzelttik |

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
