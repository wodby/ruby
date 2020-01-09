ARG BASE_IMAGE_TAG

FROM ruby:${BASE_IMAGE_TAG}

ARG RUBY_DEV

ARG WODBY_USER_ID=1000
ARG WODBY_GROUP_ID=1000

ENV RUBY_DEV="${RUBY_DEV}" \
    SSHD_PERMIT_USER_ENV="yes"

ENV APP_ROOT="/usr/src/app" \
    CONF_DIR="/usr/src/conf" \
    FILES_DIR="/mnt/files" \
    SSHD_HOST_KEYS_DIR="/etc/ssh" \
    ENV="/home/wodby/.shrc" \
    \
    GIT_USER_EMAIL="wodby@example.com" \
    GIT_USER_NAME="wodby" \
    \
    RAILS_ENV="development"

RUN set -xe; \
    \
    # Delete existing user/group if uid/gid occupied.
    existing_group=$(getent group "${WODBY_GROUP_ID}" | cut -d: -f1); \
    if [[ -n "${existing_group}" ]]; then delgroup "${existing_group}"; fi; \
    existing_user=$(getent passwd "${WODBY_USER_ID}" | cut -d: -f1); \
    if [[ -n "${existing_user}" ]]; then deluser "${existing_user}"; fi; \
    \
	addgroup -g "${WODBY_GROUP_ID}" -S wodby; \
	adduser -u "${WODBY_USER_ID}" -D -S -s /bin/bash -G wodby wodby; \
	sed -i '/^wodby/s/!/*/' /etc/shadow; \
    \
    # @todo remove, and upgrade imagemagick to 7.x once rmagick starts support it
    # https://github.com/rmagick/rmagick/issues/256
    imagemagick_ver="6.9.6.8-r1"; \
    echo 'http://dl-cdn.alpinelinux.org/alpine/v3.5/main' >> /etc/apk/repositories; \
    apk add --update --no-cache -t .wodby-ruby-run-deps "imagemagick=${imagemagick_ver}"; \
    apk add --update --no-cache -t .wodby-ruby-dev-deps "imagemagick-dev=${imagemagick_ver}"; \
    \
    apk add --update --no-cache -t .wodby-ruby-run-deps \
        bash \
        ca-certificates \
        curl \
        freetype=2.10.1-r0 \
        git \
        gmp=6.1.2-r1 \
        gzip \
        icu-libs=64.2-r0 \
        less \
        libbz2=1.0.8-r1 \
        libjpeg-turbo-utils \
        libjpeg-turbo=2.0.4-r0 \
        libldap=2.4.48-r1 \
        libmemcached-libs=1.0.18-r4 \
        libpng=1.6.37-r1 \
        librdkafka=1.2.2-r0 \
        libxslt=1.1.34-r0 \
        make \
        mariadb-client \
        nano \
        openssh \
        openssh-client \
        patch \
        postgresql-client \
        rabbitmq-c=0.10.0-r0 \
        rsync \
        sqlite-libs \
        su-exec \
        sudo \
        tar \
        tig \
        tmux \
        tzdata \
        unzip \
        wget \
        yaml=0.2.2-r1; \
    \
    if [[ -n "${RUBY_DEV}" ]]; then \
        apk add --update --no-cache -t .wodby-ruby-dev-deps \
            build-base \
            libffi-dev \
            linux-headers \
            mariadb-dev \
            nodejs \
            postgresql-dev \
            sqlite-dev \
            yarn; \
    fi; \
    \
    # Download helper scripts.
    gotpl_url="https://github.com/wodby/gotpl/releases/download/0.1.5/gotpl-alpine-linux-amd64-0.1.5.tar.gz"; \
    wget -qO- "${gotpl_url}" | tar xz -C /usr/local/bin; \
    git clone https://github.com/wodby/alpine /tmp/alpine; \
    cd /tmp/alpine; \
    latest=$(git describe --abbrev=0 --tags); \
    git checkout "${latest}"; \
    mv /tmp/alpine/bin/* /usr/local/bin; \
    \
    # Install redis-cli.
    apk add --update --no-cache redis; \
    mv /usr/bin/redis-cli /tmp/; \
    apk del --purge redis; \
    deluser redis; \
    mv /tmp/redis-cli /usr/bin; \
    \
    install -o wodby -g wodby -d \
        "${APP_ROOT}" \
        "${CONF_DIR}" \
        "${FILES_DIR}/public" \
        "${FILES_DIR}/private" \
        /home/wodby/.ssh; \
    \
    { \
        echo 'export PS1="\u@${WODBY_APP_NAME:-ruby}.${WODBY_ENVIRONMENT_NAME:-container}:\w $ "'; \
        echo "export PATH=${PATH}"; \
    } | tee /home/wodby/.shrc; \
    \
    cp /home/wodby/.shrc /home/wodby/.bashrc; \
    cp /home/wodby/.shrc /home/wodby/.bash_profile; \
    \
    # Configure sudoers
    { \
        echo 'Defaults env_keep += "APP_ROOT FILES_DIR"' ; \
        \
        if [[ -n "${RUBY_DEV}" ]]; then \
            echo 'wodby ALL=(root) NOPASSWD:SETENV:ALL'; \
        else \
            echo -n 'wodby ALL=(root) NOPASSWD:SETENV: ' ; \
            echo -n '/usr/local/bin/gen_ssh_keys, ' ; \
            echo -n '/usr/local/bin/init_container, ' ; \
            echo -n '/usr/sbin/sshd, ' ; \
            echo '/usr/sbin/crond' ; \
        fi; \
    } | tee /etc/sudoers.d/wodby; \
    \
    # Configure ldap
    echo "TLS_CACERTDIR /etc/ssl/certs/" >> /etc/openldap/ldap.conf; \
    \
    touch \
        /etc/ssh/sshd_config \
        /usr/local/etc/unicorn.rb \
        /usr/local/etc/puma.rb \
        /etc/init.d/unicorn; \
    \
    chown wodby:wodby \
        /etc/ssh/sshd_config \
        /usr/local/etc/unicorn.rb \
        /usr/local/etc/puma.rb \
        /etc/init.d/unicorn \
        /home/wodby/.*; \
    \
    rm -rf \
        /etc/crontabs/root \
        /tmp/* \
        /var/cache/apk/*

USER wodby

WORKDIR ${APP_ROOT}
EXPOSE 8000

COPY templates /etc/gotpl/
COPY docker-entrypoint.sh /
COPY bin /usr/local/bin/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["puma", "-C", "/usr/local/etc/puma.rb"]
