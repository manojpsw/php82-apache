# Use the official Ubuntu 20.04 LTS image
FROM ubuntu:20.04

# Update the package repository
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common

# Add PHP repository and install PHP 8
RUN add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    php8.2-common \
    php8.2-mysql \
    php8.2-xml \
    php8.2-xmlrpc \
    php8.2-curl \
    php8.2-gd \
    php8.2-imagick \
    php8.2-cli \
    php8.2-dev \
    php8.2-imap \
    php8.2-mbstring \
    php8.2-opcache \
    php8.2-soap \
    php8.2-zip \
    php8.2-xdebug



COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN apt install -y apache2 
RUN apt install -y apache2-utils 
RUN apt install -y libapache2-mod-php
RUN apt install -y mysql-client
RUN apt install -y git

# Update package lists and install necessary dependencies
RUN apt-get update && \
    apt-get install -y ca-certificates curl gnupg

# Add the Node.js GPG key and configure Node.js repository
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg && \
    NODE_MAJOR=18 && \
    echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# Update package lists again and install Node.js
RUN apt-get update && \
    apt-get install -y nodejs
    
RUN a2enmod rewrite

RUN apt clean 
EXPOSE 80


# Clean up the package cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
CMD ["apache2ctl", "-D", "FOREGROUND"]