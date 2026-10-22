-- Ödev 1 - Bölüm 3: SELECT ve WHERE (Hafta 4 lab föyü, robot_fleet)

-- Soru 1: Bütün robotların adı ve modeli
SELECT name, model
FROM robots;
-- 10 satır döndü.

-- Soru 2: Robot adı ve eksik şarj miktarı (100 - batarya)
SELECT name AS robot,
       100 - battery_level AS missing
FROM robots;
-- 10 satır döndü. Kartal-04'ün bataryası NULL olduğu için missing de NULL çıktı.

-- Soru 3: Bataryası 50'nin üstündeki robotlar
SELECT name, battery_level
FROM robots
WHERE battery_level > 50;
-- 4 satır döndü.

-- Soru 4: Bakımdaki robotlar
SELECT name, status
FROM robots
WHERE status = 'maintenance';
-- 1 satır döndü.

-- Soru 5: Görevde olmayan robotlar
SELECT name, status
FROM robots
WHERE status <> 'active';
-- 4 satır döndü.

-- Soru 6: AMR-300 modelinde olup bataryası 40'ın üstündeki robotlar
SELECT name, model, battery_level
FROM robots
WHERE model = 'AMR-300'
  AND battery_level > 40;
-- 2 satır döndü.

-- Soru 7: Şarjda veya bakımda olan, bataryası 50'nin altındaki robotlar
SELECT name, status, battery_level
FROM robots
WHERE (status = 'charging' OR status = 'maintenance')
  AND battery_level < 50;
-- 1 satır döndü.

-- Soru 7 (parantezsiz deneme, YANLIŞ hali):
SELECT name, status, battery_level
FROM robots
WHERE status = 'charging' OR status = 'maintenance'
  AND battery_level < 50;
-- 2 satır döndü. AND, OR'dan önce çalıştığı için sorgu
-- "charging OR (maintenance AND < 50)" olarak okundu;
-- bataryası bilinmeyen Kartal-04 de şarjda olduğu için listeye girdi.

-- Soru 8: Bataryası 15 ile 50 arasındaki robotlar (uçlar dahil)
SELECT name, battery_level
FROM robots
WHERE battery_level BETWEEN 15 AND 50;
-- 3 satır döndü.

-- Soru 9: Depo A veya Depo B'de olmayan robotlar
SELECT name, zone
FROM robots
WHERE zone NOT IN ('Depo A', 'Depo B');
-- 5 satır döndü. Bölgesi NULL olan Mars-03 gelmedi, çünkü NULL ile
-- yapılan karşılaştırmanın sonucu "bilinmiyor" oluyor.

-- Soru 10: Adı "kartal" ile başlayan robotlar (büyük/küçük harf fark etmeksizin)
SELECT name
FROM robots
WHERE name ILIKE 'kartal%';
-- 4 satır döndü. LIKE ile denediğimde 0 satır geldi, çünkü adlar büyük K ile yazılmış.

-- Soru 11: Önce modele (A-Z), model içinde bataryaya (yüksekten düşüğe) göre
SELECT name, model, battery_level
FROM robots
ORDER BY model ASC, battery_level DESC;
-- 10 satır döndü. DESC sıralamada NULL en üstte çıktı (Kartal-04, DRN-X1 grubunun başında).

-- Soru 12: En dolu 3 robot
SELECT name, battery_level
FROM robots
WHERE battery_level IS NOT NULL
ORDER BY battery_level DESC
LIMIT 3;
-- 3 satır döndü. WHERE koymasaydım NULL olan Kartal-04 en üstte gelirdi.

-- Soru 13: Filoda hangi bölgeler var?
SELECT DISTINCT zone
FROM robots
ORDER BY zone;
-- 6 satır döndü (5 bölge + atanmamış robot için bir NULL satırı).

-- Soru 14: Operatör adları, COLLATE olmadan
SELECT operator_name
FROM operators
ORDER BY operator_name;
-- 10 satır döndü. Ç, İ, Ş ile başlayan adlar (Çağla, İsmail, Şule) en sona düştü.

-- Soru 14: Operatör adları, Türkçe alfabe sırasıyla
SELECT operator_name
FROM operators
ORDER BY operator_name COLLATE "tr-TR-x-icu";
-- 10 satır döndü. Çağla Can'dan sonra, İsmail Emre'den sonra, Şule Kerem'den sonra yerine geldi.

-- Soru 15: Dış Alan veya Depo B'deki, görevdeki robotlar, en düşük bataryadan başlayarak
SELECT name, zone, battery_level
FROM robots
WHERE zone IN ('Dış Alan', 'Depo B')
  AND status = 'active'
ORDER BY battery_level ASC;
-- 4 satır döndü.
