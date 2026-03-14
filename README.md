# Django MySQL Application (Docker)

A Dockerized Django application running on Ubuntu with MySQL database support. This image provides a ready-to-run development environment with Python virtual environment, Django framework, and MySQL server.

---

## Features

* Ubuntu 22.04 base image
* Python 3 virtual environment
* Django web framework
* MySQL database server
* Preconfigured development server
* Exposed ports for web and database access

---

## Pull Image

```bash
docker pull suriyaravichandran/django-app:latest
```

---

## Run Container

```bash
docker run -d \
-p 8000:8000 \
-p 3306:3306 \
--name django-container \
suriyaravichandran/django-app
```

---

## Access Application

Open in browser:

```
http://localhost:8000
```

---

# MySQL Security Setup

Enter the container:

```bash
docker exec -it django-container bash
```

Login to MySQL:

```bash
mysql
```

Set a secure root password:

```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'StrongPassword123';
FLUSH PRIVILEGES;
```

---

# Create Database

Create a database for Django:

```sql
CREATE DATABASE mydb;
```

Check databases:

```sql
SHOW DATABASES;
```

Exit MySQL:

```sql
exit;
```

---

# Update Django Database Settings

Edit your Django `settings.py` file:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'mydb',
        'USER': 'root',
        'PASSWORD': 'StrongPassword123',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}
```

---

# Run Migrations

Inside the container:

```bash
/app/venv/bin/python manage.py migrate
```

---

# Restart Docker Container

After configuration changes, restart the container:

```bash
docker restart django-container
```

Check running containers:

```bash
docker ps
```

View logs if needed:

```bash
docker logs django-container
```

---

# Ports

| Port | Service                |
| ---- | ---------------------- |
| 8000 | Django Web Application |
| 3306 | MySQL Database         |

---

# Security Recommendations

* Use strong database passwords.
* Avoid exposing MySQL port publicly in production.
* Use environment variables for secrets in production environments.

---

# Author

Suriya Ravichandran
Python Django Full-Stack Developer
