FROM php:7.4-fpm

# Set working directory
ENV LARAVEL_PATH=/srv/app
WORKDIR $LARAVEL_PATH

# Install system dependencies
RUN apt-get update && apt-get install -y build-essential cron curl locales zip unzip git

# Setup cron job
RUN (crontab -l ; echo "* * * * * /usr/local/bin/php /srv/app/artisan schedule:run >> /dev/null 2>&1") | crontab

# Install supervisord
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord

# Install caddy
COPY --from=caddy:2.0.0 /usr/bin/caddy /usr/local/bin/caddy

# Install PHP extensions
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions intl bcmath gd pdo_mysql pdo_pgsql opcache redis uuid exif pcntl zip
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install composer & app dependencies
COPY --from=composer:1.10.5 /usr/bin/composer /usr/local/bin/composer
COPY composer.json composer.json
COPY composer.lock composer.lock
# TODO remove prestissimo when composer hits v2
RUN composer global require hirak/prestissimo --no-plugins --no-scripts
RUN composer install --prefer-dist --no-scripts --no-dev --no-autoloader && rm -rf /root/.composer

# Node & yarn
ENV NODE_VERSION="v8.17.0"
ENV NVM_DIR=/root/.nvm

RUN mkdir -p $NVM_DIR \
    && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install ${NODE_VERSION} \
    && nvm use ${NODE_VERSION} \
    && nvm alias ${NODE_VERSION} \
    && ln -s `npm bin --global` /root/.node-bin

RUN echo "" >> ~/.bashrc \
    && echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc

RUN . "$NVM_DIR/nvm.sh" && curl -o- -L https://yarnpkg.com/install.sh | bash \
    && echo "" >> ~/.bashrc \
    && echo 'export PATH="$HOME/.yarn/bin:$PATH"' >> ~/.bashrc

# Copy app
COPY --chown=www-data:www-data . $LARAVEL_PATH/
COPY ./.deploy/config/php/local.ini /usr/local/etc/php/conf.d/local.ini
RUN chmod -R 775 $LARAVEL_PATH/storage

# Production webpack build
RUN . $HOME/.nvm/nvm.sh && . $HOME/.bashrc && yarn && yarn encore prod

# Set any ENVs
ARG APP_DEBUG=${APP_DEBUG}
ARG APP_DEBUG=${APP_DEBUG}
ARG APP_URL=${APP_URL}
ARG APP_KEY=${APP_KEY}

ARG DB_CONNECTION=${DB_CONNECTION}
ARG DB_HOST=${DB_HOST}
ARG DB_PORT=${DB_PORT}
ARG DB_DATABASE=${DB_DATABASE}
ARG DB_USERNAME=${DB_USERNAME}
ARG DB_PASSWORD=${DB_PASSWORD}
ARG REDIS_HOST=${REDIS_HOST}
ARG REDIS_PASSWORD=${REDIS_PASSWORD}
ARG REDIS_PORT=${REDIS_PORT}
ARG DB_USE_CONFIG_FOR_TESTING=${DB_USE_CONFIG_FOR_TESTING}

ARG CACHE_DRIVER=${CACHE_DRIVER}

ARG SESSION_DRIVER=${SESSION_DRIVER}

ARG QUEUE_CONNECTION=${QUEUE_CONNECTION}

ARG MAIL_DRIVER=${MAIL_DRIVER}
ARG MAILGUN_DOMAIN=${MAILGUN_DOMAIN}
ARG MAILGUN_SECRET=${MAILGUN_SECRET}

ARG ROUTES_CACHE=${ROUTES_CACHE}
ARG ASSET_CACHE=${ASSET_CACHE}
ARG DATABASE_TEMPLATES=${DATABASE_TEMPLATES}
ARG LINK_POLICY=${LINK_POLICY}
ARG ENABLE_CSRF=${ENABLE_CSRF}

# Start app
EXPOSE 80
COPY ./.deploy/entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
