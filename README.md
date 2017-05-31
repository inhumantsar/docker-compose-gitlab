# GitLab in Docker with docker-compose

## What?

GitLab is a web interface and set of tools which wrap git, a version control system. Git allows users to collaborate on any kind of file while preserving all of the changes made to it, along with information on who made the change and why. GitLab builds on git by providing authentication, a centralized remote location for repositories, visual browsing of repos, testing and deployment functions, and a suite of third-party integrations.

Docker is a _containerization_ system which operates similar to BSD's jails and Solaris's zones. It's called containerization because it's likened to the containers used in shipping. The shipper doesn't need to know what's in the box to do whatever it needs to do in shipping it somewhere. It's just a box constructed to a particular standard with the exact same interfaces as every other box they handle. Docker containers offer a similar functionality for applications. Anyone can build a tiny Linux system with the desired application in a container image, ship that image to any Linux host that can run Docker, and expect that the application will run exactly as it had on its original host. docker-compose is simply a front-end for docker which allows anyone to define, in plaintext, a recipe for launching a cluster of dockerized applications.

## Why?

The goal in using docker-compose to build this out is to get to a point where anyone could take this code and launch or update an application cluster safely, and to do that quickly with no additional resources.

## How?

### Install pre-reqs

* Docker: [Install Docker for Windows](https://docs.docker.com/docker-for-windows/install/)
* docker-compose: On Mac or Windows, it probably came with Docker, otherwise: [Install Docker Compose](https://docs.docker.com/compose/install/)

### Reading material

* [Offical guide to GitLab on Docker](https://docs.gitlab.com/omnibus/docker/)
* [docker-compose documentation](https://docs.docker.com/compose/overview/)
* [GitLab configuration documentation](https://docs.gitlab.com/omnibus/settings/configuration.html)

### Run it

    $ docker-compose up
    ... stuff doing, CTRL+C to quit ...

A bunch of output will scroll by. Once tailed logs like the ones below start showing up, you should be able to access GitLab at http://localhost:8000.

#### Persistence

On startup, docker-compose creates the volumes we're defining in `.env`. All of the important GitLab files persist by default at `/tmp/gitlab`. If you tear down this application and re-run `docker-compose up` it should pick right up where it left off with the same users and data.

    $ ls /tmp/gitlab/
    config  data  logs
    $ cat /tmp/gitlab/config/gitlab.rb
    ## GitLab configuration settings
    ##! This file is generated during initial installation and **is not** modified
    ##! during upgrades.
    ##! Check out the latest version of this file to know about the different
    ...


#### Overriding defaults during development.

Environment variables are a commonly used and easily accessible way to pass runtime configuration to a new container. The `.env` file is used by docker-compose to provide sane, overrideable defaults to the cluster. You can find these in use in the `docker-compose.yml`, their implementation looking suspiciously like shell variable substitution. It is not actually connected to the shell, so nothing fancy will work.

If you're going to be running this locally or testing two gitlabs alongside each other, you'll want to change the ports. You can do this by setting the env vars prior to running `docker-compose`. For example

    $ export HOST_HTTPS="8888"
    $ export HOST_SSH="1234"
    $ export GITLAB_SUBDOMAIN="testingtesting"
    $ docker-compose up

#### Running it in prod

Docker recommends keeping the two configs separate so that the dev environment can evolve without affecting configs meant for prod. `prod.env` provides a place to keep defaults which would be sane for prod. Note that it's called within the `prod.yml` file with `env_file`. This isn't a required practice, but in a CI/CD world, it's good to be specific about what's for dev and what's for prod. Deploying into prod then looks something like this:

    $ docker-compose up -d -f prod.yml

An alternative to using `env_file`, which will inject those env vars into the container, and `prod.env` would be to re-write prod.env as a shell script. Instead of just setting the vars, `export` would be used, then the command to launch into prod would be:

    $ source prod.env.sh && docker-compose up -d -f prod.yml

### Configuring GitLab

    $ cat /tmp/gitlab/config/gitlab.rb |wc -l
    1601

...TODO...
