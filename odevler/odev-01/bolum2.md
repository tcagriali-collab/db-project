# Ödev 1 - Bölüm 2: Veritabanı kavramları

## 1. Excel ile veri tutmanın sorunları

Birincisi, aynı bilgi birden fazla dosyada tekrar eder ve biri güncellenip diğeri unutulunca veriler birbiriyle çelişir; veritabanında bilgi tek tabloda tutulur, diğer tablolar ona anahtarla bağlanır. İkincisi, birden fazla kişi aynı dosyayı aynı anda düzenleyince değişiklikler birbirinin üstüne yazılır; DBMS eş zamanlı erişimi yönetir. Üçüncüsü, Excel'de bir hücreye yanlış tipte veri (sayı yerine yazı, boş değer) girilmesini engelleyen bir şey yoktur; veritabanında sütun tipleri ve kısıtlar (NOT NULL, CHECK) hatalı veriyi baştan reddeder.

## 2. Birincil anahtar

Birincil anahtar, tablodaki her satırı tek başına ve kesin olarak ayırt eden sütundur; boş olamaz ve tekrar edemez. Öğrenci numarası iyi bir birincil anahtardır çünkü okul her öğrenciye farklı bir numara verir ve bu numara değişmez. Ad soyad ise iyi değildir: aynı isimde iki öğrenci olabilir, ayrıca isim evlilik ya da yazım düzeltmesi gibi nedenlerle değişebilir.

## 3. DBMS ve veritabanı farkı

Veritabanı, düzenli şekilde saklanan verinin kendisidir (örneğin `robot_fleet` içindeki tablolar ve satırlar). DBMS ise bu veriyi saklayan, sorguları çalıştıran, kullanıcı yetkilerini ve eş zamanlı erişimi yöneten yazılımdır. PostgreSQL bir DBMS'tir; `robot_fleet` ise PostgreSQL'in içinde duran bir veritabanıdır.

## 4. Aynı kaydı aynı anda iki kişi değiştirirse

Önlem alınmazsa ikinci kişinin kaydı birincinin yaptığı değişikliği fark ettirmeden ezer ve bir güncelleme kaybolur; DBMS bunu kilitler ve transaction'larla sıraya koyarak önler.
