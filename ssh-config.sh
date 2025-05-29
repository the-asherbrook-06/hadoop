#!/bin/bash

set -e

GREEN="\033[0;32m"
NC="\033[0m"

echo -e "${GREEN}🔐 Installing and configuring SSH...${NC}"
sudo apt install openssh-server openssh-client -y

echo -e "${GREEN}🔐 Generating SSH key (No passphrase)...${NC}"
if [ -f ~/.ssh/id_rsa ]; then
    echo "🔍 SSH key already exists. Skipping..."
else
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
fi
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

echo -e "${GREEN}✅ SSH setup complete! Test passwordless SSH by running: ssh localhost${NC}"
