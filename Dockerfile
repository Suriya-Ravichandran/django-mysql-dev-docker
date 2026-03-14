FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    mysql-server \
    pkg-config \
    libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Copy project files
COPY . /app

# Create virtual environment
RUN python3 -m venv /app/venv

# Install dependencies
RUN /app/venv/bin/pip install --upgrade pip && \
    /app/venv/bin/pip install -r requirements.txt

# Add volume for MySQL data
VOLUME ["/var/lib/mysql"]

# Expose ports
EXPOSE 8000
EXPOSE 3306

# Start MySQL and Django
CMD ["/bin/bash", "-c", "service mysql start && /app/venv/bin/python manage.py runserver 0.0.0.0:8000"]