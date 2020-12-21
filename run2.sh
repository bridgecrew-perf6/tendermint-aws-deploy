#!/bin/bash

echo "  ___ ___ _      _      _   ___  "
echo " |_ _/ __| |    | |    /_\ | _ ) "
echo "  | |\__ \ |__  | |__ / _ \| _ \ "
echo " |___|___/____| |____/_/ \_\___/ "
echo
echo

echo
echo "RUN!!!!"
read -p "Press [Enter] to continue... or [Control + c] to stop..."

REPOPATH=$(pwd)

git clone https://github.com/Intelligent-Systems-Lab/ISL-BCFL

cp -r ISL-BCFL/script .
cp -r ISL-BCFL/nodes .

rm -r ISL-BCFL

cd $REPOPATH/nodes
rm -r mytestnet

unzip mytestnet.zip
cd $REPOPATH

echo -e "\nWe will create 4 nodes (0,1,2,3)."

read -p "Enter node's number: "  NODENUM

echo -e "\nNow, we need four nodes' address."

read -p "Enter node0's address: "  NODE0
read -p "Enter node1's address: "  NODE1
read -p "Enter node2's address: "  NODE2
read -p "Enter node3's address: "  NODE3
sed -i "s+node0:26656+$NODE0:26656+" $REPOPATH/nodes/mytestnet/node$NODENUM/config/config.toml
sed -i "s+node1:26656+$NODE1:26656+" $REPOPATH/nodes/mytestnet/node$NODENUM/config/config.toml
sed -i "s+node2:26656+$NODE2:26656+" $REPOPATH/nodes/mytestnet/node$NODENUM/config/config.toml
sed -i "s+node3:26656+$NODE3:26656+" $REPOPATH/nodes/mytestnet/node$NODENUM/config/config.toml

#node0:26656

sudo docker-compose -f ./compose/docker-compose-$NODENUM.yml up