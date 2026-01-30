This project has been created as part of the 42 curriculum by razaccar.

# Developer documentation
This document describes how to set up, build, run, and maintain the Inception project
from a developer or system administrator perspective.

## Set up the environment from scratch.
### Prerequisites
**System requirements**
- Linux distribution (tested on Ubuntu)
- Sudo privileges
- Internet access (for package installation only)

**Required tools**
- The following tools must be installed on the host system:
- Docker Engine
- Docker Compose
- Make
- OpenSSL (used for TLS certificates)

### Domain name configuration
The project requires a local domain name in the format: `<login>.42.fr`

Add `<IP address> <login>.42.fr` in /etc/hosts file.

### Project directory structure
```
.
├── Makefile
├── secrets/
│   ├── db_root_password.txt
│   ├── db_password.txt
│   └── ...
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── mariadb/
        ├── nginx/
        └── wordpress/
```

### Environment Variables
The `srcs/.env` file centralizes all non-sensitive env configuration values and is loaded by Docker Compose.

Following template is expected:
```
DOMAIN_NAME=login.42.fr
DB_NAME=db_name
DB_USER=wp_user
WP_ADMIN_USER=admin
WP_ADMIN_EMAIL=admin@login.42.fr
WP_USER=user
WP_USER_EMAIL=user@login.42.fr
```

### Secrets management
Sensitive credentials are stored using Docker secrets.
All secret files are located in the `secrets/` directory and must not be committed to git, each file contains only the secret value, without extra spaces or newlines.

### Data and volumes
For data persistance accross rebuilds of the database and WordPress files, docker volumes are mapped to the host machine under:

**MariaDB database** -`/home/<login>/data/mariadb`
**WordPress files**  -`/home/<login>/data/wordpress`


## Build and manage with Makefile and Docker Compose
### Makefile 
The project lifecycle (build, start, stop, cleanup) is fully managed through a Makefile located at the root of the repository.
Internally, the Makefile acts as a wrapper around Docker Compose, ensuring consistent and reproducible commands.

Docker Compose is always executed using the following configuration file:
```
COMPOSE = docker compose -f src/docker-compose.yaml
```
```
make (up)       # Build images and start containers
make down       # Delete containers and network
make stop       # Pause containers
make start      # Resume containers
make restart    # Down + up
make clean      # Remove containers, networks, volumes, and images
make re         # Clean + up
make ps         # Inspect docker processe
```

### Docker compose commands
**Monitoring and logs**
```
docker ps -a        # List all containers (including stopped ones)
dc logs -f          # Follow logs for all services
dc logs -f nginx    # Follow logs for a specific service 
docker stats        # See containers resource usage
```
**Debugging inside containers**
```
docker exec -it mariadb sh                              # Open a shell inside a container 
docker exec -it wordpress php -v                        # Run a command inside a container
docker exec -it mariadb mariadb -u root -p wordpress    # Connect to mariadb wordpress database as root
```
**Images, Volumes and Network**
```
docker image la                     # List Docker images
docker image inspect <image>        # Inspect Docker images
docker image rm <image>             # Remove Docker images
docker network ls                   # List Docker networks
docker network inspect <network>    # Inspect the compose network
docker volume ls                    # List volumes
docker volume inspect <volume>      # Inspect volume
docker volume rm <volume>           # Remove volume
docker system prune                 # Remove unused images, containers, networks
docker system prune -a --volumes    # Aggressive cleanup including unused images + volumes
```
