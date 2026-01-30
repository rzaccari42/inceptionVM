*This project has been created as part of the 42 curriculum by razaccar.*

# Inception

## Description

**Inception** is a system administration project focused on discovering and mastering **Docker** and **Docker Compose** by building a complete, secure, and modular web infrastructure.
The goal is to deploy a WordPress website using multiple containers, each running a single service, and connected together through a dedicated Docker network.
The infrastructure is designed to be reproducible, isolated, and compliant with modern best practices in containerization and security.

This project includes:
- An **NGINX** container acting as the sole entry point, serving HTTPS traffic only
- A **WordPress** container running with **PHP-FPM**
- A **MariaDB** container for persistent database storage
- Dedicated **Docker volumes** for database data and WordPress files
- Environment-based configuration and secret management
- A fully automated setup using **Docker Compose** and a **Makefile**

---

## Project Overview & Design Choices

### Why Docker?

Docker allows packaging applications and their dependencies into isolated containers, ensuring consistency across environments and simplifying deployment and maintenance.

Key design principles used in this project:
- **One service per container**
- **No pre-built images** (all images are built from custom Dockerfiles)
- **Stateless containers**, with persistent data stored in volumes
- **Security-first approach**, with TLS, non-root services where applicable, and no secrets hardcoded in images

### Virtual Machines vs Docker

| Virtual Machines | Docker |
|------------------|--------|
| Emulate full operating systems | Share the host kernel |
| Heavier resource usage | Lightweight and fast |
| Slower startup times | Near-instant startup |
| Strong isolation | Process-level isolation |

Docker was chosen for its efficiency, portability, and suitability for microservice-style architectures.

---

### Secrets vs Environment Variables

- **Environment Variables**
  - Used for non-sensitive configuration (service names, database names, domains)
  - Easy to override and integrate with Docker Compose

- **Docker Secrets**
  - Used for sensitive data (database passwords, credentials)
  - Not baked into images
  - Read at runtime from protected files

This separation improves security and follows industry best practices.

---

### Docker Network vs Host Network

- **Host Network**
  - Containers share the host’s network stack
  - Less isolation
  - Forbidden by the subject

- **Docker Network**
  - Isolated internal network
  - Containers communicate via service names
  - Better security and flexibility

This project uses a **custom Docker bridge network** to connect services safely.

---

### Docker Volumes vs Bind Mounts

| Docker Volumes | Bind Mounts |
|---------------|-------------|
| Managed by Docker | Managed by host filesystem |
| Portable | Host-dependent |
| Safer defaults | Easier to misconfigure |
| Ideal for production data | Useful for development |

Docker volumes are used here to ensure persistence and portability of WordPress and database data.

---

## Instructions

### Prerequisites

- Docker
- Docker Compose
- GNU Make
- A Linux-based environment (as required by the subject)

---

### Execution

From the root of the repository:

```
make (up)       # Build images and start containers
make down       # Delete containers and network
make stop       # Pause containers
make start      # Resume containers
make restart    # down + up
make clean      # Remove containers, networks, volumes, and images
make re         # clean + up
make ps         # inspect docker processes
```

## Ressources

### References

<ins>Web links</ins>
[Docker official documentation](https://docs.docker.com)
[NGINX Beginner's guide](https://nginx.org/en/docs/beginners_guide.html)
[NGINX HTTPS configuration (SSL/TLS)](https://nginx.org/en/docs/http/configuring_https_servers.html)
[Transport Layer Security - Wikipedia](https://en.wikipedia.org/wiki/Transport_Layer_Security)
[Understanding PHP-FPM](https://dev.to/arsalanmee/understanding-php-fpm-a-comprehensive-guide-3ng8)
[FastCGI Process Manager (FPM) Installation and configuration](https://www.php.net/manual/en/install.fpm.php)
[MariaDB official documentation](https://mariadb.com/docs/server/mariadb-quickstart-guides/mariadb-advanced-sql-guide)
[Basic SQL database querries](https://systemweakness.com/setup-mariadb-using-the-command-line-interface-cli-6c3103b34cb3)
[WordPress Developer resource - CLI commands](https://developer.wordpress.org/cli/commands/)

CLI manuals for docker, docker compose and mariadb.

### AI usage

AI tools were used as a support resource to assist with notions understanding,
verification of compliance with project requirements, problem/error analysis
throughout the whole process of implementation.

Contextual reasoning and design support:
- Explain interactions between project components (NGINX, WordPress, MariaDB, Docker networking, volumes).
- Answer context-specific questions based on the project constraints and existing architecture.
- Validate design choices by relating them to the inception requirements.

Code:
- NGINX certificate generation in entrypoint sript.
- Installation of programs required by the services/containers.
