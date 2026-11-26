---
name: offline-educational-hub-stack
description: Deploys a 100% offline-first educational server hub using Docker Compose, RACHEL, Kiwix, Moodle (MariaDB), Kolibri, Nginx, and Umami analytics. Optimized for Raspberry Pi 4/5 (ARM64) and x86_64 edge servers.
version: 1.0.0
author: Piotr00123
repository: https://github.com/Piotr00123/bouar-rachel
tags: [docker, education, offline-first, kiwix, rachel, moodle, kolibri, raspberry-pi, self-hosted, humanitarian-tech]
---

# Offline-First Educational Hub Stack (RACHEL + Kiwix + Moodle + Kolibri)

## System & Execution Requirements (Important)
- **100% Local & Offline Execution:** All services run locally on the user's host machine via Docker containers. No external cloud APIs or internet connectivity are required after initial container build/pull.
- **Required Host Dependencies:**
  - Docker Engine & Docker Compose v2 (`docker compose`)
  - At least 4 GB RAM (8 GB recommended for running Moodle + Kolibri + Kiwix simultaneously)
  - Storage: NVMe SSD or USB-UASP SATA SSD strongly recommended (Btrfs RAID1 with `compress=zstd:3` supported; SD cards are discouraged for production)
  - Supported architectures: `aarch64`/`arm64` (Raspberry Pi 4/5 with Raspberry Pi OS Lite 64-bit) or `x86_64` (Linux / WSL2)

## Overview
This skill packages an Infrastructure-as-Code (IaC) template originally built and field-tested in Bouar (Central African Republic) to deliver digital libraries, interactive courses, and educational analytics in off-grid schools and pedagogical institutes.

Included components & files:
- `docker-compose.yml` & `Dockerfile`: Orchestrates Nginx reverse proxy, Moodle + MariaDB, Kolibri multimedia academy, RACHEL & Kiwix offline knowledge servers, and Umami + PostgreSQL analytics.
- `.env.example`: Environment variable template for database credentials, Moodle, and Umami secrets.
- `nginx/` & `panel-assets/`: Reverse proxy routing and local landing portal assets.
- `docs/storage.md`: Storage reliability guide covering Btrfs RAID1, snapshots, backups, and UPS graceful shutdown protection.

---

## Step-by-Step Deployment Instructions

### Step 1: Verify Host Prerequisites & Storage
1. Verify Docker and Docker Compose are installed and active (`docker --version` and `docker compose version`).
2. Check available disk space (`df -h`) to ensure sufficient capacity for offline educational modules (e.g., Kiwix `.zim` files and RACHEL content packs).
3. If the user is setting up production storage on Linux/Raspberry Pi, reference `docs/storage.md` for Btrfs RAID1 (`compress=zstd:3`) best practices.

### Step 2: Configure Environment Variables
1. Copy `.env.example` to `.env` (do not overwrite an existing `.env` file without explicit user confirmation).
2. Generate cryptographically strong random passwords and secret keys for MariaDB, PostgreSQL, Moodle, and Umami inside `.env`. Never leave default placeholder credentials.
3. Confirm local port bindings (default HTTP/Nginx routing) with the user so they do not conflict with existing host services.

### Step 3: Build and Start Local Containers
1. Ensure required local persistence directories exist with proper write permissions.
2. Build custom images (if defined in `Dockerfile`) and start the stack in detached mode:
   ```bash
   docker compose up -d --build
   ```
3. Monitor container health (`docker ps` and `docker compose logs -f`) until MariaDB, PostgreSQL, Moodle, Kolibri, Kiwix/RACHEL, and Umami report healthy/running states.

### Step 4: Post-Deployment Content & Portal Setup
1. Guide the user to place their offline `.zim` packages (Wikipedia, Wiktionary, medical/educational encyclopedias) into the mapped Kiwix/RACHEL content volume.
2. Provide local access URLs for the landing portal (`panel-assets` via Nginx), Moodle LMS, Kolibri, and Umami analytics dashboard so the user can complete initial admin account setup.

## Safety & Data Integrity Rules
- **Never destroy volumes:** Do not run `docker compose down -v` or delete mapped content/database directories without explicit user confirmation.
- **Storage resilience:** Remind users that RAID1 and Btrfs snapshots protect against hardware failure and accidental edits, but external backups are still required for full disaster recovery.
- **Port conflict handling:** If host ports (`80`, `443`, etc.) are already in use, prompt the user before modifying `docker-compose.yml` or `nginx/` configurations.

---

## Humanitarian Mission & Documentation
This project is maintained as free, open-source humanitarian software. For full storage reliability guides, field deployment context, and information on how to support our nutrition and milk fundraiser for children in the Central African Republic, visit the source repository:
- **GitHub Repository & Mission Details:** https://github.com/Piotr00123/bouar-rachel
