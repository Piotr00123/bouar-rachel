# Storage Architecture and Data Protection

This document describes storage configuration, RAID1 redundancy, data protection strategy and disaster recovery procedures.

---

# Architecture Overview

Target architecture:

```text
SSD 1
+
SSD 2
↓
Btrfs RAID1
↓
compress=zstd:3
↓
Docker
↓
Applications
```

Storage layer responsibilities:

- disk redundancy
- filesystem integrity
- compression
- snapshots
- disaster recovery

---

# Why Btrfs?

Btrfs provides:

- native RAID1
- snapshots
- checksumming
- online balancing
- online disk replacement
- transparent compression

Benefits:

- protection against silent data corruption
- easier administration
- simplified disaster recovery

---

# RAID1 Principle

RAID1 stores a copy of data on both drives.

```text
Write
↓
SSD1
SSD2
```

If one disk fails:

- applications continue to operate
- data remains available
- damaged drive can be replaced

Important:

```text
RAID1 is NOT a backup.
```

RAID1 protects against:

- disk failure

RAID1 does NOT protect against:

- accidental deletion
- malware
- corrupted backups
- theft
- fire

---

# Compression

Recommended mount option:

```text
compress=zstd:3
```

Benefits:

- less disk usage
- fewer SSD writes
- better SSD lifespan
- potentially faster reads

---

# Creating Btrfs RAID1

Verify disks:

```bash
lsblk
```

Example:

```text
/dev/sda
/dev/sdb
```

Create filesystem:

```bash
sudo mkfs.btrfs -m raid1 -d raid1 /dev/sda /dev/sdb
```

Create mountpoint:

```bash
sudo mkdir /data
```

Mount:

```bash
sudo mount /dev/sda /data
```

Verify RAID:

```bash
sudo btrfs filesystem show
```

---

# Recommended Mount Configuration

Edit:

```bash
sudo nano /etc/fstab
```

Example:

```text
UUID=<uuid> /data btrfs defaults,compress=zstd:3 0 0
```

Reload:

```bash
sudo mount -a
```

Verify:

```bash
mount | grep btrfs
```

---

# Monthly Scrub

Scrubbing validates checksums and repairs damaged blocks automatically.

Run:

```bash
sudo btrfs scrub start /data
```

Check status:

```bash
sudo btrfs scrub status /data
```

Recommended frequency:

```text
Once per month
```

---

# Snapshots

Create snapshots before:

- upgrades
- configuration changes
- Docker updates

Example:

```bash
sudo btrfs subvolume snapshot \
/data \
/data/.snapshots/before-update
```

List snapshots:

```bash
sudo btrfs subvolume list /data
```

---

# Docker Integration

Recommended location:

```text
/data/docker
```

Example:

```text
/data/docker
├── postgres
├── moodle
├── kolibri
├── kiwix
└── backups
```

Docker itself remains unchanged.

Recommended Docker Storage Driver:

```text
overlay2
```

---

# Replacing Failed Drive

Current state:

```text
SSD1 OK
SSD2 FAILED
```

Replace failed disk.

Verify devices:

```bash
lsblk
```

Start replacement:

```bash
sudo btrfs replace start \
<failed-device> \
<new-device> \
/data
```

Check progress:

```bash
sudo btrfs replace status /data
```

---

# Backup Strategy

Three independent protection layers:

## Layer 1

Btrfs RAID1

Protects against:

```text
single drive failure
```

## Layer 2

Snapshots

Protects against:

```text
bad upgrades
accidental modifications
```

## Layer 3

External Backup

Protects against:

```text
system loss
device theft
human error
site disaster
```

---

# Disaster Recovery

Minimal recovery requirements:

- replacement Raspberry Pi
- replacement SSD
- Git repository
- backup archive

Recovery workflow:

```bash
Install Raspberry Pi OS
Install Docker
Clone repository
Restore backup
Start containers
```

Target recovery workflow:

```bash
git clone ...
./install.sh
./restore.sh
```

with no manual intervention.

---

# Safety First Principles

1. SSD storage only
2. RAID1 redundancy
3. Btrfs filesystem
4. zstd compression
5. Monthly scrub
6. Snapshots before updates
7. External backups
8. UPS-protected shutdown


--------

# Architektura Pamięci Masowej i Ochrona Danych

Dokument opisuje konfigurację pamięci masowej, redundancję RAID1, strategię ochrony danych oraz procedury odzyskiwania po awarii.

---

# Architektura

Docelowa architektura:

```text
SSD 1
+
SSD 2
↓
Btrfs RAID1
↓
compress=zstd:3
↓
Docker
↓
Aplikacje
```

Warstwa pamięci odpowiada za:

- redundancję danych
- integralność systemu plików
- kompresję
- snapshoty
- odzyskiwanie po awarii

---

# Dlaczego Btrfs?

Btrfs zapewnia:

- natywny RAID1
- snapshoty
- sumy kontrolne danych
- balansowanie danych online
- wymianę dysków bez wyłączania systemu
- transparentną kompresję

Korzyści:

- ochrona przed cichą korupcją danych
- prostsza administracja
- łatwiejsze odzyskiwanie po awarii

---

# Zasada RAID1

RAID1 przechowuje kopię danych na obu dyskach.

```text
Zapis
↓
SSD1
SSD2
```

Jeżeli jeden dysk ulegnie awarii:

- aplikacje nadal działają
- dane pozostają dostępne
- uszkodzony dysk można wymienić

Ważne:

```text
RAID1 NIE jest kopią zapasową.
```

RAID1 chroni przed:

- awarią pojedynczego dysku

RAID1 nie chroni przed:

- przypadkowym usunięciem danych
- błędami użytkownika
- uszkodzonym backupem
- kradzieżą sprzętu
- pożarem
- katastrofą lokalizacji

---

# Kompresja

Zalecana opcja montowania:

```text
compress=zstd:3
```

Korzyści:

- mniejsze zużycie miejsca
- mniej zapisów na SSD
- dłuższa żywotność dysków
- szybszy odczyt wielu typów danych

---

# Tworzenie Btrfs RAID1

Sprawdź dyski:

```bash
lsblk
```

Przykład:

```text
/dev/sda
/dev/sdb
```

Utwórz system plików RAID1:

```bash
sudo mkfs.btrfs -m raid1 -d raid1 /dev/sda /dev/sdb
```

Utwórz punkt montowania:

```bash
sudo mkdir /data
```

Zamontuj:

```bash
sudo mount /dev/sda /data
```

Sprawdź konfigurację:

```bash
sudo btrfs filesystem show
```

---

# Zalecana Konfiguracja Montowania

Edytuj:

```bash
sudo nano /etc/fstab
```

Przykład:

```text
UUID=<uuid> /data btrfs defaults,compress=zstd:3 0 0
```

Załaduj konfigurację:

```bash
sudo mount -a
```

Zweryfikuj:

```bash
mount | grep btrfs
```

---

# Miesięczny Scrub

Scrub sprawdza integralność danych i automatycznie naprawia błędy, jeśli poprawna kopia istnieje na drugim dysku.

Uruchomienie:

```bash
sudo btrfs scrub start /data
```

Sprawdzenie statusu:

```bash
sudo btrfs scrub status /data
```

Zalecana częstotliwość:

```text
Raz w miesiącu
```

---

# Snapshoty

Snapshot wykonuj przed:

- aktualizacją systemu
- aktualizacją Dockera
- zmianami konfiguracji
- aktualizacją aplikacji

Przykład:

```bash
sudo btrfs subvolume snapshot \
/data \
/data/.snapshots/przed-aktualizacja
```

Lista snapshotów:

```bash
sudo btrfs subvolume list /data
```

---

# Integracja z Dockerem

Zalecana lokalizacja danych:

```text
/data/docker
```

Przykład:

```text
/data/docker
├── postgres
├── moodle
├── kolibri
├── kiwix
├── baserow
├── n8n
└── backups
```

Docker nie wymaga specjalnej konfiguracji.

Zalecany sterownik:

```text
overlay2
```

---

# Wymiana Uszkodzonego Dysku

Stan początkowy:

```text
SSD1 OK
SSD2 AWARIA
```

Wymień uszkodzony dysk.

Sprawdź urządzenia:

```bash
lsblk
```

Rozpocznij wymianę:

```bash
sudo btrfs replace start \
<uszkodzony_dysk> \
<nowy_dysk> \
/data
```

Sprawdź postęp:

```bash
sudo btrfs replace status /data
```

---

# Strategia Backupów

System wykorzystuje trzy niezależne warstwy ochrony.

## Warstwa 1

Btrfs RAID1

Chroni przed:

```text
awarią pojedynczego dysku
```

## Warstwa 2

Snapshoty

Chronią przed:

```text
błędną aktualizacją
przypadkową zmianą konfiguracji
```

## Warstwa 3

Zewnętrzny Backup

Chroni przed:

```text
utratą całego systemu
kradzieżą sprzętu
błędem użytkownika
katastrofą lokalizacji
```

---

# Odzyskiwanie po Awarii

Minimalne wymagania:

- nowe Raspberry Pi
- nowy dysk SSD
- repozytorium Git
- archiwum backupu

Procedura:

```bash
Instalacja Raspberry Pi OS
Instalacja Docker
Klonowanie repozytorium
Odtworzenie backupu
Uruchomienie kontenerów
```

Docelowy proces:

```bash
git clone ...
./install.sh
./restore.sh
```

bez dodatkowych ręcznych działań.

---

# Zasady "Safety First"

1. Wyłącznie dyski SSD
2. Redundancja RAID1
3. System plików Btrfs
4. Kompresja zstd
5. Miesięczny scrub
6. Snapshot przed każdą większą zmianą
7. Zewnętrzne kopie zapasowe
8. Bezpieczne wyłączanie przez UPS
``
