# LAMD_stack_containers

A backend services with Content Management Program as Drupal with MariaDB running on Apache using Linux.

The main goal is to create a stack of containers on Linux with the following services:

- Linux as OS
- Apache as web server
- MariaDB as database
- Drupal as CMS

__Drupal__ should be allowed to access the database and the database should be allowed to access Drupal but thourgh different networks. So the network should be divided into two parts: __extnet__ and __intnet__. Drupal should be able to access the web server via __extnet__ and host should communicate with DB using __intnet__. Given this configuration the database should not be accessible from the outside.

## Prerequisites

This is intended to be run on a Linux machine. It has been tested on 22.04.1 LTS Jammy. It should work on other Linux distributions, but you may need to install some packages

---

## Usage

To build the stack, run:

```bash
make build
```

Run the following command to start (It also builds) the stack:

```bash
make up
```

To stop the services, run:

```bash
make down
```

Be careful, as this will bring down the entire stack, including the database and perhaps other containers you may have running.

To backup the database, run:

```bash
make backup
```

---

## Configuration

The configuration is done through environment variables. The following variables are available:

```env
# .env is used for build ARGs
COMPOSER_VERSION=2.4.4
DRUPAL_VERSION=9.4.8

# .env.prod is used for envoriment variables inside the container
ENV_DB_HOST
ENV_DB_NAME
ENV_DB_USER
ENV_DB_PASSWORD
ENV_DRUPAL_ADMIN
ENV_DRUPAL_ADMIN_PASS
ENV_DRUPAL_ADMIN_EMAIL
ENV_DRUPAL_SITE_NAME
```
