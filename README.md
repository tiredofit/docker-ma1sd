# github.com/tiredofit/docker-ma1sd

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-ma1sd?style=flat-square)](https://github.com/tiredofit/docker-ma1sd/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/tiredofit/docker-ma1sd/main.yml?branch=main&style=flat-square)](https://github.com/tiredofit/docker-ma1sd/actions)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/ma1sd.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/docker-ma1sd/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/ma1sd.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/docker-ma1sd/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

## About

This will build a Docker Image for [Ma1sd](https://github.com/ma1uta/ma1sd), A Matrix Identity Server

## Maintainer

- [Dave Conroy](https://github.com/tiredofit/)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi Architecture](#multi-architecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Container Options](#container-options)
    - [Application Options](#application-options)
    - [LDAP Options](#ldap-options)
    - [Mail Options](#mail-options)
    - [Database Options](#database-options)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)


## Installation
### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/docker-ma1sd) and is the recommended method of installation.

```bash
docker pull tiredofit/docker-ma1sd:(imagetag)
```
The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Alpine       | `:latest` |

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory      | Description        |
| -------------- | ------------------ |
| `/config`      | Configuration File |
| `/data/certs/` | Signing Keys       |
| `/logs`        | Log files          |

* * *
### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |

#### Container Options

| Variable          | Description                                                          | Default               |
| ----------------- | -------------------------------------------------------------------- | --------------------- |
| `DATA_PATH`       | Data Path                                                            | `/data/`              |
| `CERT_PATH`       | Signing Key Path                                                     | `${DATA_PATH}/certs/` |
| `CONFIG_FILE`     | Configuration File                                                   | `ma1sd.yaml`          |
| `CONFIG_PATH`     | Configuration Path                                                   | `/config/`            |
| `LOG_FILE`        | Log file                                                             | `ma1sd.log`           |
| `LOG_LEVEL`       | Log Level `INFO` `ERROR` `DEBUG`                                     | `INFO`                |
| `LOG_LEVEL_APPS`  | Other applications log level                                         | `ERROR`               |
| `LOG_LEVEL_MA1SD` | Ma1sd Log Level                                                      | ${LOG_LEVEL}          |
| `LOG_PATH`        | Log file Path                                                        | `/logs/`              |
| `LOG_TYPE`        | Display to `FILE` or `CONSOLE`                                       | `FILE`                |
| `LOG_REQUESTS`    | Log all requests                                                     | `FALSE`               |
| `SETUP_MODE`      | Generate Configuration from environment variables `AUTO` or `MANUAL` | `AUTO`                |

#### Application Options

| Variable                        | Description                                   | Default                  |
| ------------------------------- | --------------------------------------------- | ------------------------ |
| `ENABLE_HASH`                   | Enable Hashing                                | `FALSE`                  |
| `ENABLE_INTERNAL_API`           | Enable Internal API                           | `FALSE`                  |
| `ENABLE_LDAP`                   | Enable LDAP Authentication                    | `FALSE`                  |
| `ENABLE_MATRIX_API_V1`          | Enable Matrix Authentication API V1           | `FALSE`                  |
| `ENABLE_MATRIX_API_V2`          | Enable Matrix Authentication API V1           | `TRUE`                   |
| `HASH_DELAY`                    |                                               | `10s`                    |
| `HASH_LOOKUP_REQUESTS`          |                                               | `10`                     |
| `HASH_PEPPER_LENGTH`            |                                               | `20`                     |
| `INVITE_RESOLUTION_PERIOD`      | Resolution period `minutes` `hours` `seconds` | `minutes`                |
| `INVITE_RESOLUTION_TIMER`       | Resoltuion timer                              | `5`                      |
| `INVITE_SHOW_FULL_DISPLAY_NAME` |                                               | `FALSE`                  |
| `LISTEN_PORT`                   | Application Listening Port                    | `8090`                   |
| `MATRIX_DOMAIN`                 | Matrix HomeserverDomain                       | `matrix.org`             |
| `SERVER_NAME`                   | Ma1sd Server Name                             | `ma1sd.${MATRIX_DOMAIN}` |
| `SERVER_PUBLIC_URL`             | Public URL for Server                         | `https://${SERVER_NAME}` |


#### LDAP Options

| Variable                   | Description                      | Default                       |
| -------------------------- | -------------------------------- | ----------------------------- |
| `LDAP_MODE`                | `active_directory` or `openldap` | `openldap`                    |
| `LDAP_ATTRIBUTE_NAME`      | Attribute for displayName        | `displayName`                 |
| `LDAP_ATTRIBUTE_UID_VALUE` | Value for UID (`uid` or `cn`)    | `uid`                         |
| `LDAP_ATTRIBUTE_UID`       | Attribute for UID                | `uid`                         |
| `LDAP_BASE_DN`             | Base DN                          | `dc=example,dc=com`           |
| `LDAP_BIND_DN`             | Bind DN                          |                               |
| `LDAP_BIND_PASS`           | Bind Password                    |                               |
| `LDAP_FILTER`              | LDAP Filter                      | `(objectClass=inetOrgPerson)` |
| `LDAP_LOOKUP`              |                                  | `TRUE`                        |
| `LDAP_PORT`                | LDAP Port                        | `389`                         |
| `LDAP_TLS`                 | Use TLS                          | `FALSE`                       |


#### Mail Options

| Variable        | Description                                                  | Default               |
| --------------- | ------------------------------------------------------------ | --------------------- |
| `SMTP_FROM`     | From address for when sending SMTP                           | `noreply@example.com` |
| `SMTP_TLS_MODE` | `enable` (StarTLS) `force` (StarTLS) `full` (TLS/SSL) `none` | `ENABLE`              |

#### Database Options

| Variable                    | Description                                | Default                |
| --------------------------- | ------------------------------------------ | ---------------------- |
| `DB_ENABLE_POOL`            | (postgres) Enable Pool                     | `FALSE`                |
| `DB_FREE_CONNECTIONS_MAX`   | (postgres) How many free connections       | `5`                    |
| `DB_HOST`                   | (postgres) Postgresql Hostname             |                        |
| `DB_KEEP_ALIVE_INTERVAL_MS` | (postgres) Keep alive in milliseconds      | `30000`                |
| `DB_NAME`                   | (postgres)  Postgresql Name                |                        |
| `DB_PASS`                   | (postgres)  Postgresql Password            |                        |
| `DB_PORT`                   | (postgres)  Postgresql Port                | `5432`                 |
| `DB_SQLITE_NAME`            | (sqlite) Database name                     | `ma1sd.db`             |
| `DB_SQLITE_PATH`            | (sqlite) Databasse Path                    | `${DATA_PATH}/sqlite/` |
| `DB_TEST_POOL`              | (postgres) Test pool before doing any work | `FALSE`                |
| `DB_TIMEOUT`                | (postgres) Database timeout in seconds     | `3600000`              |
| `DB_TYPE`                   | Database type `postgres` or `sqlite`       | `POSTGRES`             |
| `DB_USER`                   | (postgres)  Postgresql User                |                        |

### Networking


| Port | Protocol | Description |
| ---- | -------- | ----------- |
| 8090 | tcp      | ma1sd       |


## Maintenance
### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is) bash
```
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) personalized support.
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

## References

* <[https://](https://github.com/ma1uta/ma1sd)>
