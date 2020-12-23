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
#cp -r ISL-BCFL/nodes .

rm -r ISL-BCFL

cd $REPOPATH/nodes
rm -r mytestnet_sen
rm -r mytestnet_val

unzip mytestnet_sen.zip
#unzip mytestnet_val.zip
mv mytestnet_sen mytestnet
cd $REPOPATH

echo -e "\nWe will create 4 nodes (0,1,2,3)."

read -p "Enter node's number: "  NODENUM

echo -e "\nNow, we need four nodes' address."

read -p "Enter validator-node0's address: "  VNODE0
read -p "Enter validator-node1's address: "  VNODE1
read -p "Enter validator-node2's address: "  VNODE2
read -p "Enter validator-node3's address: "  VNODE3

sed -i "s+val0:26656+$VNODE0:26656+" $REPOPATH/nodes/mytestnet/node$NODENUM/config/config.toml
sed -i "s+val1:26656+$VNODE1:26656+" $REPOPATH/nodes/mytestnet/node$NODENUM/config/config.toml
sed -i "s+val2:26656+$VNODE2:26656+" $REPOPATH/nodes/mytestnet/node$NODENUM/config/config.toml
sed -i "s+val3:26656+$VNODE3:26656+" $REPOPATH/nodes/mytestnet/node$NODENUM/config/config.toml


read -p "Enter sentry-node0's address: "  SNODE0
read -p "Enter sentry-node1's address: "  SNODE1
read -p "Enter sentry-node2's address: "  SNODE2
read -p "Enter sentry-node3's address: "  SNODE3

sed -i "s+sen0:26656+$SNODE0:26656+" $REPOPATH/nodes/mytestnet/node$NODENUM/config/config.toml
sed -i "s+sen1:26656+$SNODE1:26656+" $REPOPATH/nodes/mytestnet/node$NODENUM/config/config.toml
sed -i "s+sen2:26656+$SNODE2:26656+" $REPOPATH/nodes/mytestnet/node$NODENUM/config/config.toml
sed -i "s+sen3:26656+$SNODE3:26656+" $REPOPATH/nodes/mytestnet/node$NODENUM/config/config.toml

#node0:26656

sudo docker-compose -f ./compose/docker-compose-$NODENUM.yml up