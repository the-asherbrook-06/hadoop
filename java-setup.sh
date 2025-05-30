#!/bin/bash

set -e

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

echo -e "${GREEN}📦 Updating package lists...${NC}"
sudo apt update -y

echo -e "${GREEN}☕ Installing OpenJDK 17...${NC}"
sudo apt install -y openjdk-17-jdk

echo -e "${GREEN}🌍 Setting Java 17 as default...${NC}"
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-17-openjdk-amd64/bin/java 1717
sudo update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java

echo -e "${GREEN}🔍 Verifying Java installation...${NC}"
java -version

echo -e "${GREEN}📝 Configuring JAVA_HOME in ~/.bashrc...${NC}"

if grep -q "export JAVA_HOME=" ~/.bashrc; then
    sed -i 's|export JAVA_HOME=.*|export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64|' ~/.bashrc
else
    echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> ~/.bashrc
fi

echo -e "${GREEN}♻️ Reloading ~/.bashrc...${NC}"
source ~/.bashrc

echo -e "${GREEN}✅ Java 17 setup complete! JAVA_HOME is now set to ${JAVA_HOME}${NC}"
