#!/bin/bash
set -e

# System setup
apt update && apt upgrade -y
apt install -y curl gnupg software-properties-common

# PostgreSQL setup
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /usr/share/keyrings/postgresql.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/postgresql.list
apt update

# Install dependencies
apt install -y build-essential pkg-config libpth-dev libavcodec-dev libavutil-dev \
    libavformat-dev libswscale-dev libwebp-dev libopencv-dev libgeoip-dev git wget \
    curl sudo postgresql-11

# Configure PostgreSQL
sed -i "/max_connections =/d" /etc/postgresql/11/main/postgresql.conf
echo "max_connections = 1024" >> /etc/postgresql/11/main/postgresql.conf
service postgresql start
su - postgres -c "psql -c \"CREATE USER meguca WITH LOGIN PASSWORD 'meguca' CREATEDB\""
su - postgres -c "createdb -T template0 -E UTF8 -O meguca meguca"

# Install Go 1.13.1

wget https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.13.1.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
source /etc/profile

# Install Node.js 14.5.0
wget https://nodejs.org/dist/v14.5.0/node-v14.5.0-linux-x64.tar.xz
tar -xf node-v14.5.0-linux-x64.tar.xz -C /usr/local --strip-components=1

# Install Rust 1.47.0
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustup install 1.47.0
rustup default 1.47.0

# For some reason I tried and it didn't run the first time so... again?
tar -C /usr/local -xzf go1.13.1.linux-amd64.tar.gz 
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile 
source /etc/profile

# Clone project
git clone -b v6 https://github.com/bakape/shamichan.git meguca
cd meguca

# Make will fail but we want to continue
make || true

# Modify thumbnailer files 
THUMBNAILER_PATH="$(go env GOPATH)/pkg/mod/github.com/bakape/thumbnailer/v2@v2.7.1"
cp ffmpeg-fix/ffmpeg.h "${THUMBNAILER_PATH}/ffmpeg.h"
cp ffmpeg-fix/ffmpeg.c "${THUMBNAILER_PATH}/ffmpeg.c"
cp ffmpeg-fix/ffmpeg.go "${THUMBNAILER_PATH}/ffmpeg.go"

# Final make attempt, should work alright
make

# IF EVERYTHING GOES ALRIGHT THIS GOES WELL
./meguca
