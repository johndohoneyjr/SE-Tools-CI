#!/usr/bin/env bash

cd ~

# Prerequisites
if [ "$(uname)" == "Darwin" ]; then
    brew install jq
# For Linux
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    sudo apt-get install --assume-yes jq
fi

# Get URLs for most recent versions
# For OS-X
if [ "$(uname)" == "Darwin" ]; then
    terraform_url=$(curl https://releases.hashicorp.com/index.json | jq '{terraform}' | egrep "darwin.*64" | sort --version-sort -r | head -1 | awk -F[\"] '{print $4}')
    packer_url=$(curl https://releases.hashicorp.com/index.json | jq '{packer}' | egrep "darwin.*64" | sort --version-sort -r | head -1 | awk -F[\"] '{print $4}')
# For Linux
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    terraform_url="https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip"
##### - Latest is still Beta
##### $(curl https://releases.hashicorp.com/index.json | jq '{terraform}' | egrep "linux.*amd64" | sort --version-sort -r | head -1 | awk -F[\"] '{print $4}')
#####
    packer_url=$(curl https://releases.hashicorp.com/index.json | jq '{packer}' | egrep "linux.*amd64" | sort --version-sort -r | head -1 | awk -F[\"] '{print $4}')
fi

# Create a move into directory.
cd ~

# Download Terraform. URI: https://www.terraform.io/downloads.html
echo "Downloading $terraform_url."
curl -o terraform.zip $terraform_url
# Unzip and install
unzip terraform.zip


# Download Packer. URI: https://www.packer.io/downloads.html
echo "Downloading $packer_url."
curl -o packer.zip $packer_url
# Unzip and install
unzip packer.zip

mv ~/terraform /usr/bin/terraform
mv ~/packer /usr/bin/packer

