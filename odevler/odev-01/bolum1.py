# Ödev 1 - Bölüm 1: Algoritma ve izleme

# ---------------------------------------------------------------
# Soru 1.1: İz sürme
# ---------------------------------------------------------------
# Kodu çalıştırmadan önce elle izlediğim tablo:
#
# | i | numbers[i] | çift mi? | total | result         |
# |---|------------|----------|-------|----------------|
# | - | -          | -        | 0     | []             |  (başlangıç)
# | 0 | 4          | evet     | 4     | []             |
# | 1 | 7          | hayır    | 4     | [7]            |
# | 2 | 2          | evet     | 6     | [7]            |
# | 3 | 9          | hayır    | 6     | [7, 9]         |
# | 4 | 5          | hayır    | 6     | [7, 9, 5]      |
# | 5 | 1          | hayır    | 6     | [7, 9, 5, 1]   |
# | 6 | 8          | evet     | 14    | [7, 9, 5, 1]   |
#
# Tahminim: 14 ve [7, 9, 5, 1]
# Çalıştırınca: 14 ve [7, 9, 5, 1] -> tahminim tuttu.
# (Çift sayılar toplanıyor, tek sayılar listeye ekleniyor.)

print("--- Soru 1.1 ---")
numbers = [4, 7, 2, 9, 5, 1, 8]
total = 0
result = []

for i in range(len(numbers)):
    if numbers[i] % 2 == 0:
        total = total + numbers[i]
    else:
        result.append(numbers[i])

print(total)
print(result)


# ---------------------------------------------------------------
# Soru 1.2: En uzun seri
# ---------------------------------------------------------------
# Sözde kod:
#   mevcut_seri = 0
#   en_uzun = 0
#   her okuma için:
#       eğer okuma > eşik ise:
#           mevcut_seri'yi 1 artır
#           eğer mevcut_seri > en_uzun ise en_uzun = mevcut_seri
#       değilse:
#           mevcut_seri = 0   (seri bozuldu, baştan say)
#   en_uzun'u yazdır
#
# Not: "eşiğin üzerinde" dediği için > kullandım, 22'nin kendisi seriye girmiyor.

print("--- Soru 1.2 ---")


def en_uzun_seri(readings, threshold):
    mevcut_seri = 0
    en_uzun = 0
    for value in readings:
        if value > threshold:
            mevcut_seri = mevcut_seri + 1
            if mevcut_seri > en_uzun:
                en_uzun = mevcut_seri
        else:
            mevcut_seri = 0
    return en_uzun


readings = [18, 21, 23, 25, 24, 26, 27, 19, 20, 22, 23, 24, 25, 26]
threshold = 22

print(en_uzun_seri([18, 25, 26, 27, 19], 22))  # örnek, 3 olmalı
print(en_uzun_seri(readings, threshold))       # 5 (23, 25, 24, 26, 27)


# ---------------------------------------------------------------
# Soru 1.3: Elle gruplama
# ---------------------------------------------------------------
# Sözlükte anahtar = ders adı, değer = o dersi alan öğrenci sayısı.
# Ders sözlükte yoksa 1 ile başlatıyorum, varsa 1 artırıyorum.
# Bu, SQL'deki  SELECT course, count(*) FROM records GROUP BY course;
# sorgusunun elle yapılmış hali.

print("--- Soru 1.3 ---")
records = [
    {"student": "Ece", "course": "VTYS"},
    {"student": "Ali", "course": "Yapay Zeka"},
    {"student": "Ece", "course": "Yapay Zeka"},
    {"student": "Can", "course": "VTYS"},
    {"student": "Ali", "course": "VTYS"},
    {"student": "Ece", "course": "Robotik"},
]

counts = {}
for record in records:
    course = record["course"]
    if course in counts:
        counts[course] = counts[course] + 1
    else:
        counts[course] = 1

print(counts)
