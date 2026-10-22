-- Ödev 1 - Bölüm 4: Gruplama ve NULL (Hafta 5 lab föyü, robot_fleet)

-- Soru 1: Filoda kaç robot var?
SELECT count(*) AS robot_sayisi
FROM robots;
-- 10, yani filoda 10 robot kayıtlı; Bölüm 3 Soru 1'deki 10 satırla tutarlı.

-- Soru 2: Kaç robot görevde?
SELECT count(*) AS aktif_robot
FROM robots
WHERE status = 'active';
-- 6, yani filonun %60'ı şu an çalışıyor, 4 robot şarjda, bakımda ya da kapalı.

-- Soru 3: Bütün bataryaların toplamı
SELECT sum(battery_level) AS toplam_batarya
FROM robots;
-- 381. sum() NULL'u atladığı için bu toplam 10 değil 9 robotun toplamı.

-- Soru 4: Ortalama batarya, bir ondalık
SELECT round(avg(battery_level), 1) AS ort_batarya
FROM robots;
-- 42.3, yani 381 / 9. Bölme 10'a değil 9'a yapıldı, Kartal-04 hesaba girmedi.

-- Soru 5: En düşük ve en yüksek batarya
SELECT min(battery_level) AS en_dusuk,
       max(battery_level) AS en_yuksek
FROM robots;
-- 0 | 91. 0 olan Atlas-03 kapalı (offline) robot, yani bu bir hata değil gerçek bir boş batarya.

-- Soru 6: Her durumda kaç robot var?
SELECT status, count(*) AS robot_sayisi
FROM robots
GROUP BY status
ORDER BY robot_sayisi DESC;
-- 4 satır döndü, çünkü tabloda 4 farklı durum var (active 6, charging 2, maintenance 1, offline 1).
-- Satırların toplamı 10, yani hiçbir robot dışarıda kalmadı.

-- Soru 7: Her model için robot sayısı ve ortalama batarya
SELECT model,
       count(*) AS robot_sayisi,
       round(avg(battery_level), 1) AS ort_batarya
FROM robots
GROUP BY model
ORDER BY model;
-- AMR-200: 3 robot, ort. 32.3 | AMR-300: 3 robot, ort. 37.0 | DRN-X1: 4 robot, ort. 57.7.
-- DRN-X1'in ortalaması 4 değil 3 robottan hesaplandı (Kartal-04 NULL), yani en iyi görünen model aslında eksik veriyle öne çıkıyor.

-- Soru 8: Her bölgede, her durumdan kaç robot var?
SELECT zone, status, count(*) AS robot_sayisi
FROM robots
GROUP BY zone, status
ORDER BY zone, status;
-- 7 satır döndü. Beklemediğim satır: bölgesi boş (NULL) bir "active" satırı.
-- Bu Mars-03; henüz bir bölgeye atanmadığı halde görevde görünüyor.

-- Soru 9: Birden fazla robotu olan modeller
SELECT model, count(*) AS robot_sayisi
FROM robots
GROUP BY model
HAVING count(*) > 1;
-- 3 satır döndü, yani üç modelin de birden fazla robotu var; HAVING hiçbir grubu elemedi.

-- Soru 10: Sadece görevdeki robotlar; en az 2 robotu olan modeller ve ortalama batarya
SELECT model,
       count(*) AS aktif_robot,
       round(avg(battery_level), 1) AS ort_batarya
FROM robots
WHERE status = 'active'
GROUP BY model
HAVING count(*) >= 2;
-- 2 satır döndü: AMR-300 (3 robot, 37.0) ve DRN-X1 (2 robot, 54.5).
-- WHERE görevde olmayan 4 robotu gruplamadan önce eledi; HAVING ise
-- tek aktif robotu kalan AMR-200'ü (sadece Atlas-01) gruplamadan sonra eledi.

-- Soru 11: NULL avı
SELECT count(*)              AS satir_sayisi,
       count(name)           AS name_dolu,
       count(model)          AS model_dolu,
       count(status)         AS status_dolu,
       count(battery_level)  AS batarya_dolu,
       count(zone)           AS zone_dolu,
       count(operator_name)  AS operator_dolu
FROM robots;
-- 10 | 10 | 10 | 10 | 9 | 9 | 9.
-- battery_level, zone ve operator_name sütunlarında birer eksik var:
-- batarya Kartal-04'ün (sensör arızası), bölge ve operatör Mars-03'ün (henüz atanmadı).

-- Soru 12: Bilgisi eksik olan robotlar (önce = NULL ile deneme)
SELECT name, battery_level, zone, operator_name
FROM robots
WHERE battery_level = NULL
   OR zone = NULL
   OR operator_name = NULL;
-- 0 satır döndü. "= NULL" hiçbir zaman doğru olmuyor, sonuç her satır için "bilinmiyor" çıkıyor.

-- Soru 12: Doğru hali, IS NULL ile
SELECT name, battery_level, zone, operator_name
FROM robots
WHERE battery_level IS NULL
   OR zone IS NULL
   OR operator_name IS NULL;
-- 2 satır döndü: Kartal-04 ve Mars-03. Soru 11'deki üç eksik bu iki robota ait.

-- Soru 13: İki ortalama yan yana
SELECT round(avg(battery_level), 1)              AS bosu_atlayarak,
       round(avg(coalesce(battery_level, 0)), 1) AS bosu_sifir_sayarak
FROM robots;
-- 42.3 | 38.1, yani fark 4.2 puan.
-- Bu veri için 42.3 daha dürüst: Kartal-04'ün bataryası 0 değil, sadece sensörü bozuk olduğu için bilinmiyor.
-- Ona 0 demek, olmayan bir boş bataryayı rapora eklemek olur. Ama raporda "9 robot üzerinden" diye belirtmek gerekir.

-- Soru 13 (ek): Kayıp kayıtlar
SELECT count(*) AS elli_alti
FROM robots
WHERE battery_level < 50;
-- 5
SELECT count(*) AS elli_ve_ustu
FROM robots
WHERE battery_level >= 50;
-- 4, yani 5 + 4 = 9, 10 değil. Bir robot (Kartal-04) iki koşula da girmedi,
-- çünkü NULL hem "< 50" hem ">= 50" testinde "bilinmiyor" sonucunu veriyor.

-- Soru 14: Operatörleri işe giriş yılına göre say
SELECT extract(YEAR FROM hired_at) AS giris_yili,
       count(*) AS operator_sayisi
FROM operators
GROUP BY giris_yili
ORDER BY giris_yili;
-- 2023: 1 | 2024: 3 | 2025: 4 | 2026: 2. İşe alım 2025'te zirve yapmış,
-- yani operatörlerin yarıdan fazlası (6/10) son iki yılda gelmiş.

-- Soru 15: Bataryaya göre kategori
SELECT CASE
           WHEN battery_level IS NULL THEN 'Bilinmiyor'
           WHEN battery_level < 20    THEN 'Kritik'
           WHEN battery_level < 60    THEN 'Düşük'
           ELSE 'Normal'
       END AS kategori,
       count(*) AS robot_sayisi
FROM robots
GROUP BY kategori
ORDER BY robot_sayisi DESC;
-- Kritik 4, Düşük 2, Normal 3, Bilinmiyor 1. Filonun 4 robotu 20'nin altında,
-- bunlardan Mars-02 (9) ve Kartal-01 (18) hâlâ görevde, yani yakında duracaklar.

-- Soru 15 (ek): IS NULL satırı en sona taşınınca
SELECT CASE
           WHEN battery_level < 20    THEN 'Kritik'
           WHEN battery_level < 60    THEN 'Düşük'
           WHEN battery_level >= 60   THEN 'Normal'
           WHEN battery_level IS NULL THEN 'Bilinmiyor'
       END AS kategori,
       count(*) AS robot_sayisi
FROM robots
GROUP BY kategori
ORDER BY robot_sayisi DESC;
-- Sonuç değişmedi: Kartal-04 yine "Bilinmiyor"a düştü. Çünkü NULL ile yapılan
-- her karşılaştırma doğru olmuyor, CASE ilk üç satırı atlayıp IS NULL'a ulaşıyor.
-- Ama son satırı "ELSE 'Normal'" yazsaydım, Kartal-04 yanlışlıkla Normal'e düşerdi.
