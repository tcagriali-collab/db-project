-- Ödev 1 - Bölüm 4: Gruplama ve NULL (Hafta 5 lab föyü, llm_ops)
-- Program: Yapay Zeka Operatörlüğü

-- Soru 1: Kaç çağrı kaydedilmiş?
SELECT count(*) AS cagri_sayisi
FROM llm_calls;
-- 12, yani 8-16 Ekim arasında uygulamaya 12 çağrı yapılmış.

-- Soru 2: Kaç çağrı 2 saniyeden yavaş?
SELECT count(*) AS yavas_cagri
FROM llm_calls
WHERE latency_ms > 2000;
-- 5, yani çağrıların yaklaşık %40'ında kullanıcı 2 saniyeden fazla beklemiş.

-- Soru 3: Toplam maliyet ve toplam token
SELECT sum(cost_usd) AS toplam_maliyet,
       sum(prompt_tokens + completion_tokens) AS toplam_token
FROM llm_calls;
-- 0.0631 dolar | 14340 token. Maliyet 12 değil 11 çağrının toplamı:
-- 11 numaralı çağrının faturası gelmediği için gerçek harcama bundan biraz fazla.

-- Soru 4: Ortalama gecikme, bir ondalık
SELECT round(avg(latency_ms), 1) AS ort_gecikme
FROM llm_calls;
-- 1848.3 ms, yani bir çağrı ortalama 1.8 saniye sürüyor. latency_ms'de boş yok, 12 çağrının hepsi hesaba girdi.

-- Soru 5: En hızlı ve en yavaş çağrı
SELECT min(latency_ms) AS en_hizli,
       max(latency_ms) AS en_yavas
FROM llm_calls;
-- 380 | 4100. En yavaş çağrı en hızlıdan 10 kattan fazla uzun; ikisi farklı iş türü
-- (llama ile classify, claude-sonnet ile code), yani gecikme modele ve işin büyüklüğüne bağlı.

-- Soru 6: Her iş türünde kaç çağrı var?
SELECT task_type, count(*) AS cagri_sayisi
FROM llm_calls
GROUP BY task_type
ORDER BY cagri_sayisi DESC;
-- 5 satır döndü, çünkü 5 farklı iş türü var. Toplamları 3+3+2+2+2 = 12, hiçbir çağrı dışarıda kalmadı.

-- Soru 7: Her model için çağrı sayısı ve toplam maliyet, pahalıdan ucuza
SELECT model_name,
       count(*) AS cagri_sayisi,
       sum(cost_usd) AS toplam_maliyet
FROM llm_calls
GROUP BY model_name
ORDER BY toplam_maliyet DESC;
-- 7 satır döndü. claude-sonnet sadece 2 çağrıyla 0.0384 dolar harcamış, yani toplam maliyetin yarısından fazlası.
-- gpt-4o 3 çağrı ama toplamı 0.0179: faturası gelmeyen 11 numaralı çağrı bu toplama girmedi.

-- Soru 8: Her kullanıcının her iş türünden kaç çağrısı var?
SELECT user_name, task_type, count(*) AS cagri_sayisi
FROM llm_calls
GROUP BY user_name, task_type
ORDER BY user_name, task_type;
-- 12 satır döndü. Beklemediğim satır en sondaki kullanıcısı boş (NULL) "chat" satırı:
-- bu 12 numaralı çağrı, bir kişi değil anonim bir betik yapmış.

-- Soru 9: İkiden fazla çağrı almış modeller ("ikiden fazla" = 2'den büyük, yani en az 3)
SELECT model_name, count(*) AS cagri_sayisi
FROM llm_calls
GROUP BY model_name
HAVING count(*) > 2;
-- 1 satır döndü: gpt-4o (3 çağrı). Diğer modeller en fazla 2 çağrı almış.

-- Soru 10: 500 ms'den yavaş çağrılar; en az 2 çağrısı olan modeller ve ortalama gecikme
SELECT model_name,
       count(*) AS cagri_sayisi,
       round(avg(latency_ms), 1) AS ort_gecikme
FROM llm_calls
WHERE latency_ms > 500
GROUP BY model_name
HAVING count(*) >= 2;
-- 3 satır döndü: claude-sonnet 3650.0, gpt-4o 2383.3, claude-haiku 800.0.
-- WHERE, gruplamadan önce 500 ms'den hızlı 2 çağrıyı (llama 380, gpt-4o-mini 450) eledi.
-- HAVING, gruplamadan sonra tek çağrısı kalan gemini-pro, gemini-flash ve llama-3-8b'yi eledi.

-- Soru 11: NULL avı
SELECT count(*)                  AS satir_sayisi,
       count(model_name)         AS model_dolu,
       count(user_name)          AS user_dolu,
       count(task_type)          AS task_dolu,
       count(prompt_tokens)      AS prompt_dolu,
       count(completion_tokens)  AS completion_dolu,
       count(latency_ms)         AS latency_dolu,
       count(cost_usd)           AS cost_dolu,
       count(created_at)         AS tarih_dolu
FROM llm_calls;
-- 12 | 12 | 11 | 12 | 12 | 12 | 12 | 11 | 12.
-- İki sütunda birer eksik var: user_name (12 numaralı çağrı, anonim betik) ve cost_usd (11 numaralı çağrı, fatura gelmedi).

-- Soru 12: Faturası gelmemiş çağrılar (önce = NULL ile deneme)
SELECT id, model_name, user_name, cost_usd
FROM llm_calls
WHERE cost_usd = NULL;
-- 0 satır döndü. "= NULL" hiçbir satır için doğru olmuyor, sonuç her zaman "bilinmiyor".

-- Soru 12: Doğru hali, IS NULL ile
SELECT id, model_name, user_name, cost_usd
FROM llm_calls
WHERE cost_usd IS NULL;
-- 1 satır döndü: 11 numaralı çağrı (gpt-4o, Deniz). Soru 11'deki cost eksikliğiyle tutarlı.

-- Soru 13: İki ortalama yan yana
SELECT round(avg(cost_usd), 5)              AS bosu_atlayarak,
       round(avg(coalesce(cost_usd, 0)), 5) AS bosu_sifir_sayarak
FROM llm_calls;
-- 0.00574 | 0.00526, fark yaklaşık 0.0005 dolar (yaklaşık %8).
-- Bu veri için boşu atlayan ortalama daha dürüst: 11 numaralı çağrı bedava değil, faturası henüz gelmedi.
-- Üstelik pahalı bir model (gpt-4o) ile yapılmış, ona 0 demek ortalamayı yapay olarak düşürür.
-- Raporda "11 çağrı üzerinden, 1 fatura bekleniyor" diye belirtmek gerekir.

-- Soru 13 (ek): Kayıp kayıtlar
SELECT count(*) AS ucuz
FROM llm_calls
WHERE cost_usd < 0.005;
-- 7
SELECT count(*) AS pahali
FROM llm_calls
WHERE cost_usd >= 0.005;
-- 4, yani 7 + 4 = 11, 12 değil. Faturası gelmeyen 11 numaralı çağrı iki koşula da girmedi,
-- çünkü NULL hem "< 0.005" hem ">= 0.005" testinde "bilinmiyor" sonucunu veriyor.

-- Soru 14: Günlük kullanım raporu
SELECT created_at::date AS gun,
       count(*) AS cagri_sayisi,
       sum(cost_usd) AS toplam_maliyet
FROM llm_calls
GROUP BY gun
ORDER BY gun;
-- 6 satır döndü. En çok çağrı 16 Ekim'de (5 çağrı), ama o günün maliyeti sadece 0.0053 dolar,
-- 2 çağrılık 15 Ekim'in (0.0246) beşte biri. İki sebebi var: o gün çoğunlukla ucuz modeller
-- (llama, gpt-4o-mini, claude-haiku) kullanılmış ve pahalı gpt-4o çağrısının (11) faturası henüz gelmemiş.

-- Soru 15: Gecikmeye göre kategori
SELECT CASE
           WHEN latency_ms < 1000 THEN 'Hızlı'
           WHEN latency_ms < 2500 THEN 'Orta'
           ELSE 'Yavaş'
       END AS kategori,
       count(*) AS cagri_sayisi,
       round(avg(latency_ms), 1) AS ort_gecikme
FROM llm_calls
GROUP BY kategori
ORDER BY ort_gecikme;
-- Hızlı 4 (607.5 ms), Orta 4 (1775.0 ms), Yavaş 4 (3162.5 ms). Çağrılar üç kategoriye eşit dağılmış.
-- Yavaş grubun ortalaması hızlı grubun 5 katı; 4 yavaş çağrının 2'si gpt-4o, 2'si claude-sonnet, yani en pahalı iki model aynı zamanda en yavaşları.
