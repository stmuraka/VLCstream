#!/bin/bash

redis_server=10.3.3.5

container_name="buck_bunny"
#image="vlcstream/buck_bunny:latest"
#image="vlcstream/buck_bunny:4k"
image="vlcstream/buck_bunny:480p"

this_ip=$(route -n | grep "^0\.0\.0\.0" | awk '{print $NF}' | xargs ip a show dev | grep inet | grep -v inet6 | awk '{print $2'} | cut -d '/' -f1)
#echo "this IP: ${this_ip}"

# check if redis is installed
[[ $(which redis-cli) ]] || sudo apt-get install redis-tools

# remove container if it exists
docker rm -fv ${container_name} > /dev/null 2>&1

# start container
container_id_long=$(docker run -dP --name ${container_name} ${image})
container_id=${container_id_long:0:12}

# Get running port information
container_port=$(docker inspect -f '{{(index (index .NetworkSettings.Ports "8080/tcp") 0).HostPort}}' ${container_id})

# Register with load balancer
redis-cli -h ${redis_server} SET /services/vlc/${this_ip} ${container_port}
#redis-cli -h ${redis_server} KEYS /services/vlc/*

# show container runnign
docker ps | grep ${container_id}
