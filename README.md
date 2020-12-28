# tendermint-aws-deploy

In this repo, we try to deploy oasis-nodes but fail.

So we start to deploy tendermint nodes.
https://github.com/Intelligent-Systems-Lab/ISL-BCFL


## Install

1. Install env

```bash=
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get install unzip
wget -qO - https://github.com/tony92151/tendermint-aws-deploy/raw/main/install_doc.sh | bash
```

2. Download pre-config validator node data and setup

```bash=
git clone https://github.com/tony92151/tendermint-aws-deploy
cd tendermint-aws-deploy
sudo bash run_val.sh
```

3. Download pre-config sentry node data and setup

```bash=
git clone https://github.com/tony92151/tendermint-aws-deploy
cd tendermint-aws-deploy
sudo bash run_sen.sh
```
