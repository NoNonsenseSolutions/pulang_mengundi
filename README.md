[![CircleCI](https://circleci.com/gh/pulang-mengundi/pulang_mengundi/tree/master.svg?style=svg)](https://circleci.com/gh/pulang-mengundi/pulang_mengundi/tree/master)

# README

## Setup

* `cp config/application.yml.sample config/application.yml`
* `rake db:create db:schema:load`

## Docker setup

We use [Docker](https://www.docker.com/community-edition) to manage our dependencies for development.

To setup docker, make sure that you follow these steps:

1.  Install [Docker](https://www.docker.com/community-edition#/download) on your computer.
2.  To create the dependencies, in the work directory, run `docker-compose build`.
3.  To install all the required Ruby gems, run `docker-compose run app bundle`.
4.  To setup the right configuration keys, run `cp config/application.yml.sample config/application.yml`.
5.  To setup the seed database, run `docker-compose run app rake db:setup`.
6.  To get the local server up, run `docker-compose up`.
7.  Visit `localhost:3000` for the local server.
