#!/bin/bash
usage() {
  echo "Start docker-compose GitLab stack, perform CI runner registration, tail logs."
  echo ""
  echo "Usage: ./start.sh [env file]"
  echo "  env file -- path to a file containing .env var overrides"
}

### did the user pass an env file?
if [ ! -z $1 ]; then
  if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ "$1" == "help" ]; then
    usage
    exit 0
  elif [ -f $1 ]; then
    source $1
  else
    echo "ERROR: Could not find a env file called '$1'"
    echo ""
    usage
    exit 1
  fi
fi

### start up docker-compose services in the background
docker-compose up -d

### register the ci runner with gitlab
# d-c names containers after the parent folder of the d-c.yml file, we want to be specific
# so we're going to guess this name to get the container id
guess_prefix=`basename $(pwd) | sed -e 's/[-_]//g'`
guess="${guess_prefix}_runner"
containerid=$(docker ps | grep ${guess} | cut -d' ' -f1)
docker exec -it ${containerid} gitlab-runner register

docker-compose logs -f --tail=100 runner web
