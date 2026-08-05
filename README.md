# Educational Docker Stack for CAR Mission (Bouar) / Autonomiczny Stack dla Misji w RCA

[PL] Polska wersja opisu znajduje się w dolnej części tego dokumentu.

This repo contains IaC config for a decentralized educational stack in CAR, using Moodle, Kolibri, and Umami, optimized for low-bandwidth environments.

---

# 💾 Installing Raspberry Pi OS

## Supported Storage

The system can be installed on:

- NVMe SSD
- SATA SSD connected via USB-UASP enclosure

SD cards are not recommended for production deployments.

## Step 1 - Install Raspberry Pi OS

Using Raspberry Pi Imager:

1. Select:

```text
Raspberry Pi OS Lite (64-bit)
```

2. Select target storage:
   - NVMe SSD
   - or SATA SSD

3. Configure:
   - hostname
   - username
   - password
   - SSH enabled

4. Write the image.

## Step 2 - First Boot

Connect through SSH:

```bash
ssh USER@raspberrypi.local
```

Verify storage:

```bash
lsblk
```

## Step 3 - Update System

```bash
sudo apt update
sudo apt full-upgrade -y
sudo reboot
```

Verify operating system:

```bash
cat /etc/os-release
```

---

# ✅ Prerequisites

Install Git:

```bash
sudo apt install -y git
```

Install Docker:

```bash
curl -fsSL https://get.docker.com | sh
```

Add current user to Docker group:

```bash
sudo usermod -aG docker $USER
```

Reboot:

```bash
sudo reboot
```

Verify installation:

```bash
docker --version
docker compose version
```

---

# 🏗 Storage and Reliability Design

## Target Architecture

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
Educational Services
```

## Storage Design

Target deployment uses:

- Btrfs filesystem
- RAID1 redundancy
- SSD storage
- Zstandard compression

Recommended mount option:

```text
compress=zstd:3
```

## Data Protection Layers

1. RAID1 redundancy
2. Btrfs snapshots
3. External backups

Important:

```text
RAID1 is NOT a backup.
Snapshots are NOT backups.
```

## UPS

UPS functionality provides:

- battery monitoring
- graceful shutdown
- filesystem protection

---

# 🚀 Architecture Overview

Components:

- Nginx
- Moodle
- MariaDB
- Kolibri
- Rachel
- Kiwix
- Umami
- PostgreSQL

Goals:

- Offline education
- Knowledge distribution
- Low-bandwidth operation
- Educational analytics

---

# 🛠 Deployment Strategy

Clone repository:

```bash
git clone <repository-url>
cd <repository-directory>
```

Create configuration:

```bash
cp .env.example .env
```

Edit configuration and fill required credentials.

Start stack:

```bash
docker compose up -d
```

Verify services:

```bash
docker ps
```

Check logs:

```bash
docker compose logs -f
```

Stop stack:

```bash
docker compose down
```

Restart stack:

```bash
docker compose restart
```

---

# 🔄 Recovery Philosophy

A complete deployment should be recoverable using only:

- Raspberry Pi OS Lite
- Docker
- This repository
- Backup files

Long-term goal:

```bash
git clone ...
./install.sh
./restore.sh
```

without any manual configuration.

---

# 📚 Additional Documentation


- docs/storage.md

---

# 🇵🇱 Polska Wersja

Repozytorium zawiera konfigurację Infrastructure as Code (IaC) dla zdecentralizowanej platformy edukacyjnej wdrożonej w Republice Środkowoafrykańskiej (RCA). System został zaprojektowany do pracy offline i przy bardzo ograniczonym dostępie do Internetu.

---

# 💾 Instalacja Raspberry Pi OS

## Obsługiwane Nośniki

System może zostać zainstalowany na:

- dysku NVMe
- dysku SSD SATA podłączonym przez obudowę USB-UASP

Karty SD nie są zalecane do produkcyjnych wdrożeń.

## Krok 1 - Instalacja Raspberry Pi OS

Za pomocą Raspberry Pi Imager:

1. Wybierz:

```text
Raspberry Pi OS Lite (64-bit)
```

2. Wybierz nośnik:
   - NVMe SSD
   - lub SSD SATA

3. Skonfiguruj:
   - hostname
   - użytkownika
   - hasło
   - SSH

4. Wgraj system.

## Krok 2 - Pierwsze Uruchomienie

Połącz się przez SSH:

```bash
ssh UZYTKOWNIK@raspberrypi.local
```

Sprawdź wykryte dyski:

```bash
lsblk
```

## Krok 3 - Aktualizacja Systemu

```bash
sudo apt update
sudo apt full-upgrade -y
sudo reboot
```

Sprawdź wersję systemu:

```bash
cat /etc/os-release
```

---

# ✅ Wymagania Wstępne

Zainstaluj Git:

```bash
sudo apt install -y git
```

Zainstaluj Docker:

```bash
curl -fsSL https://get.docker.com | sh
```

Dodaj użytkownika do grupy Docker:

```bash
sudo usermod -aG docker $USER
```

Uruchom system ponownie:

```bash
sudo reboot
```

Zweryfikuj instalację:

```bash
docker --version
docker compose version
```

---

# 🏗 Architektura Pamięci i Niezawodności

## Architektura Docelowa

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
Usługi Edukacyjne
```

## Pamięć Masowa

Docelowa konfiguracja wykorzystuje:

- Btrfs
- RAID1
- dyski SSD
- kompresję Zstandard

Zalecane ustawienie:

```text
compress=zstd:3
```

## Warstwy Ochrony Danych

1. RAID1
2. Snapshoty Btrfs
3. Kopie zapasowe

Ważne:

```text
RAID1 NIE jest kopią zapasową.
Snapshot NIE jest kopią zapasową.
```

## UPS

UPS zapewnia:

- monitorowanie baterii
- bezpieczne wyłączanie systemu
- ochronę systemu plików podczas zaniku zasilania

---

# 🚀 Przegląd Architektury

Komponenty:

- Nginx
- Moodle
- MariaDB
- Kolibri
- Rachel
- Kiwix
- Umami
- PostgreSQL

Cele:

- edukacja offline
- lokalna dystrybucja wiedzy
- praca przy ograniczonym dostępie do Internetu
- statystyki wykorzystania treści edukacyjnych

---

# 🛠 Strategia Wdrożenia

Sklonuj repozytorium:

```bash
git clone <repository-url>
cd <repository-directory>
```

Utwórz konfigurację:

```bash
cp .env.example .env
```

Uzupełnij wymagane hasła i ustawienia.

Uruchom usługi:

```bash
docker compose up -d
```

Sprawdź uruchomione kontenery:

```bash
docker ps
```

Sprawdź logi:

```bash
docker compose logs -f
```

Zatrzymaj usługi:

```bash
docker compose down
```

Uruchom ponownie:

```bash
docker compose restart
```

---

# 🔄 Filozofia Odtwarzania

Kompletne środowisko powinno dać się odtworzyć przy użyciu wyłącznie:

- Raspberry Pi OS Lite
- Docker
- repozytorium Git
- backupu

Docelowo proces powinien sprowadzać się do:

```bash
git clone ...
./install.sh
./restore.sh
```

bez potrzeby wykonywania dodatkowej ręcznej konfiguracji.

---

# 📚 Dodatkowa Dokumentacja

- docs/storage.md
