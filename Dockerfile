FROM php:8.1-apache

# Instalacja kompletnego zestawu narzędzi dla skryptów pobierania RACHEL
RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    wget \
    curl \
    rsync \
    binutils \
    unzip \
    && docker-php-ext-install pdo pdo_sqlite \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Przełączenie konfiguracji PHP w tryb produkcyjny
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Tworzenie symlinków dla kompatybilności ze starym kodem RACHEL
RUN ln -s /bin/wget /usr/bin/wget || true
RUN ln -s /usr/bin/rsync /bin/rsync || true
