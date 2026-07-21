# Educational Docker Stack for CAR Mission (Bouar) / Autonomiczny Stack dla Misji w RCA

[PL] Polska wersja opisu znajduje się w dolnej części tego dokumentu.

This repo contains IaC config for a decentralized educational stack in CAR, using Moodle, Kolibri, and Umami, optimized for low-bandwidth environments.

---

## 🚀 Architecture Overview (EN)
Components: Nginx, Moodle/MariaDB, Kolibri, Rachel/Kiwix, Umami/PostgreSQL.

## 🛠 Deployment Strategy (EN)
1. `git clone`
2. `cp .env.example .env` (fill credentials)
3. `docker compose up -d`

---

## 🚀 Przegląd Architektury (PL)
Zestaw aplikacji (Moodle, Kolibri, Rachel, Umami) do pracy offline w RCA.

## 🛠 Strategia Wdrożenia (PL)
1. `git clone`
2. `cp .env.example .env` (uzupełnij hasła)
3. `docker compose up -d`
