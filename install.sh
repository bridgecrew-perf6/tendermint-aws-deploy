GO_VERSION=1.15.1
GO_NANCY_VERSION=1.0.0
GO_NANCY_CHECKSUM=13804837a34c07e7a933b0d6f52c5e580b03ccb209e38fc3d6394b791b414c33
GO_PROTOC_VERSION=3.6.1
GO_PROTOC_GEN_GO_VERSION=1.21.0
GOLANGCILINT_VERSION=1.28.2
GOCOVMERGE_VERSION=b5bfa59ec0adc420475f97f89b58045c721d761c
GOFUMPT_VERSION=abc0db2c416aca0f60ea33c23c76665f6e7ba0b6
RUST_NIGHTLY_VERSION=2020-08-29

DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install  \
    build-essential git gdb cmake \
    curl wget unzip \
    pkg-config software-properties-common \
    python python-pyelftools \
    # for gitlint
    python-pip \
    # for rust openssl
    libssl-dev libcurl4-openssl-dev \
    # for benchmarks
    python3-prometheus-client \
    # for seccomp Go bindings support
    libseccomp-dev \
    # for bubblewrap
    libcap2 && \
    apt-get autoclean && apt-get autoremove && rm -rf /var/cache/apt/archives/* && \
    # for linting Git commits
    pip install gitlint

sudo apt-get -y install pkg-config libssl-dev unzip


GOPATH="/go"
PATH="${HOME}/.cargo/bin:/go/bin:/usr/local/go/bin:${PATH}"

echo "export PATH=\$PATH:/go/bin:/usr/local/go/bin" >>  ~/.bashrc &&\
echo "export GOPATH=/go" >>  ~/.bashrc

# Install protobuf (apt system v3.0 fails to compile our protos).
wget https://github.com/google/protobuf/releases/download/v${GO_PROTOC_VERSION}/protoc-${GO_PROTOC_VERSION}-linux-x86_64.zip
    
sudo unzip protoc-${GO_PROTOC_VERSION}-linux-x86_64.zip -x readme.txt -d /usr
rm protoc-${GO_PROTOC_VERSION}-linux-x86_64.zip
sudo chmod a+rx /usr/bin/protoc

# Install Rust.
curl "https://sh.rustup.rs" -sfo rustup.sh 
sh rustup.sh -y --default-toolchain nightly-${RUST_NIGHTLY_VERSION}
rustup target add x86_64-fortanix-unknown-sgx
rustup component add rustfmt
cargo install --version 0.4.0 fortanix-sgx-tools
cargo install --version 0.8.2 sgxs-tools
cargo install cargo-audit

# Install Go and utilities.
wget https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz 
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz 
rm go${GO_VERSION}.linux-amd64.tar.gz
sudo mkdir -p /go/bin
# Install a specific version of protoc-gen-go.
GO111MODULE=on go get google.golang.org/protobuf/cmd/protoc-gen-go@v${GO_PROTOC_GEN_GO_VERSION}
# Install golangci-lint.
curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | bash -s -- -b /tmp/bin v${GOLANGCILINT_VERSION}
sudo mv /tmp/bin/golangci-lint /go/bin
# Install gocovmerge for e2e coverage.
GO111MODULE=on go get github.com/wadey/gocovmerge@${GOCOVMERGE_VERSION}
# Install nancy for auditing dependencies.
curl -sfL -o nancy https://github.com/sonatype-nexus-community/nancy/releases/download/v${GO_NANCY_VERSION}/nancy-linux.amd64-v${GO_NANCY_VERSION}
echo "${GO_NANCY_CHECKSUM} nancy" | sha256sum -c
sudo mv nancy /go/bin/nancy
sudo chmod +x /go/bin/nancy
# Install gofumpt for code formatting.
GO111MODULE=on go get mvdan.cc/gofumpt@${GOFUMPT_VERSION}
GO111MODULE=on go get mvdan.cc/gofumpt/gofumports@${GOFUMPT_VERSION}

# Install bubblewrap (we need version 0.3.3 which is not available for 18.04).
wget http://archive.ubuntu.com/ubuntu/pool/main/b/bubblewrap/bubblewrap_0.4.1-1_amd64.deb
#echo '1cf9bdae5cfab75f292fad9ee0ef76a7c55243dbc0515709624b2a9573d19447 bubblewrap_0.3.3-2_amd64.deb' | sha256sum -c 
sudo dpkg -i bubblewrap_0.4.1-1_amd64.deb
rm bubblewrap_0.4.1-1_amd64.deb

##############################################################

# Unsafe Non-SGX Environment
OASIS_UNSAFE_SKIP_AVR_VERIFY="1"
OASIS_UNSAFE_SKIP_KM_POLICY="1"

wget https://github.com/oasisprotocol/oasis-core/archive/v20.11.1.zip
unzip v20.11.1.zip
cd oasis-core-20.11.1
sudo make
sudo cp go/oasis-net-runner/oasis-net-runner /usr/local/bin/
sudo cp go/oasis-node/oasis-node /usr/local/bin/
sudo cp go/oasis-remote-signer/oasis-remote-signer /usr/local/bin/

# RUN export OASIS_UNSAFE_SKIP_AVR_VERIFY="1" &&\
#     export OASIS_UNSAFE_KM_POLICY_KEYS="1" &&\
#     export OASIS_UNSAFE_ALLOW_DEBUG_ENCLAVES="1" &&\
#     make

sudo apt-get update && apt-get install -y openssh-server


sudo apt-get update && apt-get -y upgrade
sudo apt-get install -y apt-utils openssh-server software-properties-common
sudo apt-get install -y autotools-dev automake curl git wget zip build-essential gcc pkg-config net-tools nano



sudo chmod +x rejq.sh
echo 'alias rejq=/./rejq.sh' >> ~/.bashrc
