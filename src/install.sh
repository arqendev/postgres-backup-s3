#! /bin/sh

set -eux
set -o pipefail

apk update

# install pg_dump from official PostgreSQL repository for version 17+
# Alpine repos only have up to PostgreSQL 16, so use PostgreSQL's official APK repo for newer versions
if [ "${POSTGRES_VERSION}" -ge 17 ] 2>/dev/null; then
    echo "Installing PostgreSQL ${POSTGRES_VERSION} client from official repository..."

    # Add PostgreSQL official repository
    apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main \
        "postgresql${POSTGRES_VERSION}-client"
else
    echo "Installing PostgreSQL client from Alpine repository..."
    # For PostgreSQL 12-16, use Alpine's built-in repos
    apk add postgresql-client
fi

# install gpg
apk add gnupg

apk add aws-cli

# install go-cron
apk add curl
curl -L https://github.com/ivoronin/go-cron/releases/download/v0.0.5/go-cron_0.0.5_linux_${TARGETARCH}.tar.gz -O
tar xvf go-cron_0.0.5_linux_${TARGETARCH}.tar.gz
rm go-cron_0.0.5_linux_${TARGETARCH}.tar.gz
mv go-cron /usr/local/bin/go-cron
chmod u+x /usr/local/bin/go-cron
apk del curl


# cleanup
rm -rf /var/cache/apk/*
