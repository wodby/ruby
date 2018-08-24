ARG BASE_IMAGE_TAG

FROM wodby/base-ruby:${BASE_IMAGE_TAG}

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
    GEM_HOME="/home/wodby/.gem/ruby/${RUBY_MAJOR}.0" \
    RAILS_ENV="development"

ENV BUNDLE_PATH="${GEM_HOME}" \
    BUNDLE_APP_CONFIG="${GEM_HOME}" \
    PATH="${GEM_HOME}/bin:${GEM_HOME}/gems/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN set -xe; \
    \
    addgroup -g 82 -S www-data; \
    adduser -u 82 -D -S -G www-data www-data; \
    \
    # Delete existing user/group if uid/gid occupied.
    existing_group=$(getent group "${WODBY_GROUP_ID}" | cut -d: -f1); \
    if [[ -n "${existing_group}" ]]; then delgroup "${existing_group}"; fi; \
    existing_user=$(getent passwd "${WODBY_USER_ID}" | cut -d: -f1); \
    if [[ -n "${existing_user}" ]]; then deluser "${existing_user}"; fi; \
    \
	addgroup -g "${WODBY_GROUP_ID}" -S wodby; \
	adduser -u "${WODBY_USER_ID}" -D -S -s /bin/bash -G wodby wodby; \
	adduser wodby www-data; \
	sed -i '/^wodby/s/!/*/' /etc/shadow; \
    \
    echo 'http://dl-cdn.alpinelinux.org/alpine/v3.5/main' >> /etc/apk/repositories; \
    \
    apk add --update --no-cache -t .ruby-rundeps \
        freetype=2.8.1-r3 \
        git \
        gmp=6.1.2-r1 \
        icu-libs=59.1-r1 \
        imagemagick=6.9.6.8-r1 \
        less \
        libbz2=1.0.6-r6 \
        libjpeg-turbo-utils \
        libjpeg-turbo=1.5.2-r0 \
        libldap=2.4.45-r3 \
        libmemcached-libs=1.0.18-r2 \
        libpng=1.6.34-r1 \
        librdkafka=0.11.1-r1 \
        libxslt=1.1.31-r0 \
        make \
        mariadb-client=10.1.32-r0 \
        nano \
        nodejs=8.9.3-r1 \
        openssh \
        openssh-client \
        patch \
        postgresql-client=10.5-r0 \
        rabbitmq-c=0.8.0-r3 \
        rsync \
        sqlite-libs=3.21.0-r1 \
        su-exec \
        sudo \
        tig \
        tmux \
        tzdata \
        yaml=0.1.7-r0; \
    \
    apk add --update --no-cache -t .ruby-build-deps \
        build-base \
        libffi-dev \
        linux-headers \
        imagemagick-dev=6.9.6.8-r1 \
        postgresql-dev \
        sqlite-dev \
        mariadb-dev; \
    \
    # Install redis-cli.
    apk add --update --no-cache redis; \
    mkdir -p /tmp/pkgs-bins; \
    mv /usr/bin/redis-cli /tmp/; \
    apk del --purge redis; \
    deluser redis; \
    mv /tmp/redis-cli /usr/bin; \
    \
    install -o wodby -g wodby -d \
        "${APP_ROOT}" \
        "${CONF_DIR}" \
        /home/wodby/.ssh; \
    \
    install -o www-data -g www-data -d \
        /home/www-data/.ssh \
        "${FILES_DIR}/public" \
        "${FILES_DIR}/private"; \
    \
    chmod -R 775 "${FILES_DIR}"; \
    \
    cd /home/wodby; \
    { \
        echo 'git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }'; \
        echo 'source "https://rubygems.org"'; \
        echo 'gem "bcrypt", "3.1.12"'; \
        echo 'gem "bindex", "0.5.0"'; \
        echo 'gem "bootsnap", "1.3.1"'; \
        echo 'gem "bson", "4.3.0"'; \
        echo 'gem "byebug", "10.0.2"'; \
        echo 'gem "eventmachine", "1.2.7"'; \
        echo 'gem "ffi", "1.9.25"'; \
        echo 'gem "hitimes", "1.3.0"'; \
        echo 'gem "http_parser.rb", "0.6.0"'; \
        echo 'gem "jaro_winkler", "1.5.1"'; \
        echo 'gem "kgio", "2.11.2"'; \
        echo 'gem "msgpack", "1.2.4"'; \
        echo 'gem "mysql2", "0.5.2"'; \
        echo 'gem "nio4r", "2.3.1"'; \
        echo 'gem "nokogiri", "1.8.4"'; \
        echo 'gem "nokogumbo", "1.5.0"'; \
        echo 'gem "oj", "3.6.6"'; \
        echo 'gem "pg", "1.0.0"'; \
        echo 'gem "posix-spawn", "0.3.13"'; \
        echo 'gem "puma", "3.12.0"'; \
        echo 'gem "raindrops", "0.19.0"'; \
        echo 'gem "rmagick", "2.16.0"'; \
        echo 'gem "sqlite3", "1.3.13"'; \
        echo 'gem "unf_ext", "0.0.7.5"'; \
        echo 'gem "unicorn", "5.4.1"'; \
        echo 'gem "websocket-driver", "0.7.0"'; \
        \
    } | tee Gemfile; \
    \
    su-exec wodby bundle install --path /home/wodby/.gem; \
    rm Gemfile*; \
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
            echo -n '/usr/local/bin/files_chmod, ' ; \
            echo -n '/usr/local/bin/files_chown, ' ; \
            echo -n '/usr/local/bin/files_sync, ' ; \
            echo -n '/usr/local/bin/gen_ssh_keys, ' ; \
            echo -n '/usr/local/bin/init_container, ' ; \
            echo -n '/etc/init.d/unicorn, ' ; \
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
    apk del --purge .ruby-build-deps; \
    rm -rf \
        /etc/crontabs/root \
        /tmp/* \
        /var/cache/apk/*

USER wodby

WORKDIR ${APP_ROOT}
EXPOSE 8080

COPY templates /etc/gotpl/
COPY docker-entrypoint.sh /
COPY bin /usr/local/bin/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sudo", "-E", "/etc/init.d/unicorn"]
