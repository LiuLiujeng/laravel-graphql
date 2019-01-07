FROM php:7.1-apache
MAINTAINER Yachu

# Install run time deps
RUN set -xe \
        && apt-get update -y && apt-get install --no-install-recommends --no-install-suggests -y \
            build-essential libssl-dev \
        && docker-php-ext-install pdo_mysql \
        && rm -r /var/lib/apt/lists/*

ENV NVM_VERSION 0.33.11
#ENV NODE_VERSION 11.3.0
ENV NODE_VERSION 7.5.0
ENV NVM_DIR /usr/local/nvm
RUN mkdir $NVM_DIR

# RUN groupadd -r node && useradd -r -g node node
# USER node

# install nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN echo "source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default" | bash

RUN npm install -g aglio
# confirm installation
RUN node -v
RUN npm -v

RUN a2enmod rewrite

WORKDIR /var/www

# Copy vendor files
COPY vendor ./vendor

# Copy application files
COPY app ./app
COPY bootstrap ./bootstrap
COPY config ./config
COPY public ./public
COPY routes ./routes
COPY resources ./resources
COPY storage ./storage
COPY .env ./

RUN mkdir ./docs
VOLUME ./docs

RUN chown -R $(whoami):www-data storage \
    && chmod -R 775 storage \
    && chown -R $(whoami):www-data bootstrap/cache \
    && chmod -R 775 bootstrap/cache

RUN sed -i "s|/var/www/html|/var/www/public|g" \
    /etc/apache2/sites-available/default-ssl.conf \
    /etc/apache2/sites-available/000-default.conf \
    /etc/apache2/sites-enabled/000-default.conf ;

EXPOSE 80
RUN service apache2 start
CMD apachectl -D FOREGROUND
