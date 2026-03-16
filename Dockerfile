FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    mysql-server \
    pkg-config \
    libmysqlclient-dev \
    nano \
    vim \
    curl \
    wget \
    git \
    gcc \
    g++ \
    make \
    build-essential \
    nodejs \
    npm \
    default-jdk \
    php \
    htop \
    net-tools \
    iputils-ping \
    telnet \
    netcat \
    unzip \
    zip \
    software-properties-common \
    ca-certificates \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . /app

RUN python3 -m venv /app/venv

RUN /app/venv/bin/pip install --upgrade pip && \
    /app/venv/bin/pip install -r requirements.txt

# Create persistent data directory
RUN mkdir -p /data/mysql /data/django

# Link MySQL data
RUN rm -rf /var/lib/mysql && ln -s /data/mysql /var/lib/mysql

# Volumes
VOLUME ["/data"]

EXPOSE 8000
EXPOSE 3306

# Start MySQL and Django
CMD ["/bin/bash", "-c", "\
if [ ! -d /data/mysql/mysql ]; then \
    mysqld --initialize-insecure --user=mysql --datadir=/data/mysql; \
fi && \
service mysql start && \
sleep 5 && \
mysql -u root -e \"ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;\" || true && \
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e \"CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};\" && \
echo 'Starting Django server...' && \
/app/venv/bin/python manage.py migrate && \
/app/venv/bin/python manage.py runserver 0.0.0.0:8000"]