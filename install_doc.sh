#!/bin/bash

echo "  ___ ___ _      _      _   ___  "
echo " |_ _/ __| |    | |    /_\ | _ ) "
echo "  | |\__ \ |__  | |__ / _ \| _ \ "
echo " |___|___/____| |____/_/ \_\___/ "
echo
echo

echo
echo "It will install docker and run oasis container-node"
read -p "Press [Enter] to continue... or [Control + c] to stop..."


function verify_docker_running() {
  local readonly STDERR_OUTPUT
  STDERR_OUTPUT=$(docker info 2>&1 >/dev/null)
  local readonly RET=$?
  if [[ $RET -eq 0 ]]; then
    return 0
  elif [[ $STDERR_OUTPUT = *"Is the docker daemon running"* ]]; then
    start_docker
  fi
}

function install_docker() {
  curl -sS https://get.docker.com/ | sh > /dev/null 2>&1
}

function install_docker_compose() {
  sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

function start_docker() {
  systemctl start docker.service > /dev/null 2>&1
  systemctl enable docker.service > /dev/null 2>&1
}
install_docker
verify_docker_running
install_docker_compose

echo -e "\nDocker is up."

echo -e "\nTo run container."
sudo docker pull tony92151/tendermint-docker
echo  "sudo docker run -it -p 8022:22 -p 26656:26656 --name oasis1 tony92151/oasis-docker"