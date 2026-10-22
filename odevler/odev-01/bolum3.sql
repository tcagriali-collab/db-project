-- Ödev 1 - Bölüm 3: SELECT ve WHERE (Hafta 4 lab föyü, llm_ops)
-- Program: Yapay Zeka Operatörlüğü

-- Soru 1: Bütün çağrıların id'si ve model adı
SELECT id, model_name
FROM llm_calls;
-- 12 satır döndü.

-- Soru 2: Model adı ve toplam token sayısı
SELECT model_name AS model,
       prompt_tokens + completion_tokens AS total_tokens
FROM llm_calls;
-- 12 satır döndü.

-- Soru 3: Gecikmesi 2 saniyeyi aşan çağrılar (sütun milisaniye, 2 sn = 2000 ms)
SELECT id, model_name, latency_ms
FROM llm_calls
WHERE latency_ms > 2000;
-- 5 satır döndü. "> 2" yazsaydım 12 satırın hepsi gelirdi.

-- Soru 4: Ece'nin yaptığı çağrılar
SELECT id, model_name, task_type
FROM llm_calls
WHERE user_name = 'Ece';
-- 3 satır döndü.

-- Soru 5: Sohbet (chat) dışındaki çağrılar
SELECT id, task_type
FROM llm_calls
WHERE task_type <> 'chat';
-- 9 satır döndü (12 çağrının 3'ü chat).

-- Soru 6: Adı claude ile başlayan modellere yapılan, 1 saniyeden yavaş çağrılar
SELECT id, model_name, latency_ms
FROM llm_calls
WHERE model_name LIKE 'claude%'
  AND latency_ms > 1000;
-- 2 satır döndü. claude-haiku çağrıları (900 ve 700 ms) 1 saniyenin altında kaldı.

-- Soru 7: Kod veya çeviri işi olan, maliyeti 0.01 doları aşan çağrılar
SELECT id, task_type, cost_usd
FROM llm_calls
WHERE (task_type = 'code' OR task_type = 'translate')
  AND cost_usd > 0.01;
-- 3 satır döndü.

-- Soru 7 (parantezsiz deneme):
SELECT id, task_type, cost_usd
FROM llm_calls
WHERE task_type = 'code' OR task_type = 'translate'
  AND cost_usd > 0.01;
-- 3 satır döndü, fark 0. Parantezsiz sorgu "code OR (translate AND > 0.01)" olarak okunuyor,
-- yani code çağrılarında maliyete bakılmıyor. Bu veride iki code çağrısı da zaten 0.01'in
-- üstünde olduğu için sonuç değişmedi. Sorgu yine de yanlış: ucuz bir code çağrısı eklense listeye girerdi.

-- Soru 8: Gecikmesi 500 ile 1500 ms arasındaki çağrılar
SELECT id, model_name, latency_ms
FROM llm_calls
WHERE latency_ms BETWEEN 500 AND 1500;
-- 3 satır döndü.

-- Soru 9: gpt ailesine yapılan çağrılar
SELECT id, model_name
FROM llm_calls
WHERE model_name IN ('gpt-4o', 'gpt-4o-mini');
-- 4 satır döndü.

-- Soru 10: Model adında "mini" geçen çağrılar
SELECT id, model_name
FROM llm_calls
WHERE model_name LIKE '%mini%';
-- 3 satır döndü. 1 satır bekliyordum (gpt-4o-mini), ama "gemini" kelimesinin
-- içinde de "mini" geçtiği için gemini-flash ve gemini-pro da geldi.

-- Soru 11: Önce kullanıcıya, kullanıcı içinde maliyete (pahalıdan ucuza) göre
SELECT user_name, id, cost_usd
FROM llm_calls
ORDER BY user_name ASC, cost_usd DESC;
-- 12 satır döndü. Kullanıcısı NULL olan 12 numaralı çağrı en sona düştü;
-- Deniz'in maliyeti NULL olan çağrısı ise DESC sıralamada en üste çıktı.

-- Soru 12: En pahalı 3 çağrı
SELECT id, model_name, cost_usd
FROM llm_calls
WHERE cost_usd IS NOT NULL
ORDER BY cost_usd DESC
LIMIT 3;
-- 3 satır döndü. WHERE koymasaydım faturası gelmemiş 11 numaralı çağrı en üstte çıkardı.

-- Soru 13: Hangi iş türleri var?
SELECT DISTINCT task_type
FROM llm_calls
ORDER BY task_type;
-- 5 satır döndü.

-- Soru 14: Kullanıcı adları, tekrarsız, COLLATE olmadan
SELECT DISTINCT user_name
FROM llm_calls
ORDER BY user_name;
-- 6 satır döndü (5 kullanıcı + anonim betik için NULL).

-- Soru 14: Türkçe alfabe sırasıyla
-- İlk denemem: SELECT DISTINCT user_name ... ORDER BY user_name COLLATE "tr-TR-x-icu";
-- Hata: "for SELECT DISTINCT, ORDER BY expressions must appear in select list".
-- COLLATE eklenince ORDER BY'daki ifade SELECT'tekinden farklı sayılıyor, bu yüzden COLLATE'i SELECT'e taşıdım.
SELECT DISTINCT user_name COLLATE "tr-TR-x-icu" AS user_name
FROM llm_calls
ORDER BY user_name;
-- 6 satır döndü. Hiçbir isim yer değiştirmedi, çünkü hiçbir isim Ç, Ğ, İ, Ö, Ş, Ü ile başlamıyor.
-- Oğuz'daki "ğ" ikinci harf olduğu için O'dan sonra karşılaştırmaya gerek kalmıyor.

-- Soru 15: 14 Ekim'den sonra yapılan, 1 saniyeden yavaş çağrılar, en yavaştan başlayarak
SELECT id, model_name, latency_ms
FROM llm_calls
WHERE created_at >= '2026-10-15'
  AND latency_ms > 1000
ORDER BY latency_ms DESC;
-- 5 satır döndü. "14 Ekim'den sonra"yı 15 Ekim ve sonrası olarak aldım.
-- '2026-10-14' yazsaydım 14 Ekim saat 11:47'deki 4 numaralı çağrı da gelirdi (6 satır).
