#!/bin/bash

set -e

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

# 🔢 Prompt for Spark version
read -p "Enter Spark version to install (e.g. 4.0.0): " SPARK_VERSION
SPARK_HOME=$HOME/spark-$SPARK_VERSION

echo -e "${GREEN}📥 Downloading and extracting Spark $SPARK_VERSION...${NC}"
if [ -d "$SPARK_HOME" ]; then
    echo "🔍 Spark already exists at $SPARK_HOME. Skipping download..."
else
    wget https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz
    tar -xzf spark-$SPARK_VERSION-bin-hadoop3.tgz
    mv spark-$SPARK_VERSION-bin-hadoop3 $SPARK_HOME
    rm spark-$SPARK_VERSION-bin-hadoop3.tgz
fi

echo -e "${GREEN}🌍 Configuring environment variables...${NC}"
grep -q "SPARK_HOME" ~/.bashrc || cat <<EOL >> ~/.bashrc

# Spark Environment Variables
export SPARK_HOME=$SPARK_HOME
export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin
export PYSPARK_PYTHON=python3
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
EOL

# 🌟 Export for current session
export SPARK_HOME=$SPARK_HOME
export PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

echo -e "${GREEN}🚀 Verifying Spark installation...${NC}"
spark-shell --version

echo -e "${GREEN}✅ Spark $SPARK_VERSION installation completed successfully!${NC}"
