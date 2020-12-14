#!/bin/bash

echo "  ___ ___ _      _      _   ___  "
echo " |_ _/ __| |    | |    /_\ | _ ) "
echo "  | |\__ \ |__  | |__ / _ \| _ \ "
echo " |___|___/____| |____/_/ \_\___/ "
echo
echo

echo
echo "It will create 30 nodes."
read -p "Press [Enter] to continue... or [Control + c] to stop..."

WORKDIR=/oasis-vol

REPODIR=$(pwd)

NODELIST=/nodelist.txt

mkdir -p $WORKDIR
mkdir -p $WORKDIR/logs

HOST_IP=$(hostname -I)
HOST_IP=${HOST_IP% }


function entity_init() {
    node_name="$WORKDIR/node"
    mkdir -m700 -p $node_name; 

    entity_name="$WORKDIR/entity"
    mkdir -m700 -p $entity_name;

    oasis-node registry entity init --signer.backend file --signer.dir $WORKDIR/entity

    ENTITY_ID=$(cat $WORKDIR/entity/entity.json | jq '.id')
    ENTITY_ID=${ENTITY_ID:1:-1}

    #echo "node${i}_pub=$ENTITY_ID" >> $NODELIST
    #echo "Generate entity $i"
}

function node_init() {
    cd $WORKDIR/node
    read -p "Enter external ip address : "  HOSTIP
    oasis-node registry node init \
            --signer.backend file \
            --signer.dir $WORKDIR/entity \
            --node.consensus_address $HOSTIP:26656 \
            --node.is_self_signed \
            --node.role validator
}



function entity_update() {
    cd $WORKDIR/entity
    oasis-node registry entity update \
            --signer.backend file \
            --signer.dir $WORKDIR/entity \
            --entity.node.descriptor $WORKDIR/node/node_genesis.json
}

function download_localnet() {
    cd /oasis-vol
    wget https://github.com/tony92151/oasis-aws-deploy/raw/main/localnet.zip
    unzip localnet.zip
}

function update_external_ip() {
    read -p "Select a node config (00~10) : "  NODECON
    read -p "Enter external ip address : "  HOSTIP
    # sed -i "s+{{ node_dir }}+$WORKDIR/nodes/node$i+" $WORKDIR/localnet/nodes/node0000/config.yml
    sed -i "s+{{ external_address }}+$HOSTIP+" $WORKDIR/localnet/nodes/node00$NODECON/config.yml
}

function update_address_book() {
    read -p "Select a node config (00~10) : "  NODECON
    read -p "Enter address book address (If this is genesis node, skip it) : "  ADDRESSBOOK
    sed -i "s+{{ seed_node_address }}+$ADDRESSBOOK+" $WORKDIR/localnet/nodes/node00$NODECON/config.yml
}

# entity_init
# node_init
# entity_update


echo -e "\nDownload example localnet."
download_localnet

echo -e "\nUpdate external ip of your node."
update_external_ip

echo -e "\nUpdate address book."
update_address_book

echo -e "\nTo run, use this"
echo "oasis-node --config /oasis-vol/localnet/nodes/node00$NODECON/config.yml >> /oasis-vol/localnet/logs/node00$NODECON.log 2>&1 &"