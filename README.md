# oasis-aws-deploy

In this repo, we try to deploy oasis-nodes but fail.

So we start to deploy tendermint nodes.
https://github.com/Intelligent-Systems-Lab/ISL-BCFL


## Install

1. Install env

```bash=
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get install unzip
wget -qO - https://github.com/tony92151/oasis-aws-deploy/raw/main/install_doc.sh | bash
```

2. Download pre-config node data and setup

```bash=
#wget https://github.com/tony92151/oasis-aws-deploy/raw/main/run1.sh && bash run1.sh


git clone https://github.com/tony92151/oasis-aws-deploy
cd oasis-aws-deploy
sudo bash run2.sh
```