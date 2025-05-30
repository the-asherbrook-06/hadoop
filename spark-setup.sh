#!/bin/bash

set -e

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

read -p "Enter Spark version to install (e.g. 3.5.6): " SPARK_VERSION
SPARK_DIR_NAME="spark-$SPARK_VERSION-bin-hadoop3"
SPARK_TGZ="$SPARK_DIR_NAME.tgz"
SPARK_HOME="$HOME/spark-$SPARK_VERSION"

echo -e "${GREEN}📥 Downloading Spark $SPARK_VERSION for Linux (Hadoop 3)...${NC}"
if [ -d "$SPARK_HOME" ]; then
    echo -e "${GREEN}🔍 Spark already exists at $SPARK_HOME. Skipping download...${NC}"
else
    wget "https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/$SPARK_TGZ" -O "$SPARK_TGZ"
    tar -xzf "$SPARK_TGZ"
    mv "$SPARK_DIR_NAME" "$SPARK_HOME"
    rm "$SPARK_TGZ"
fi

echo -e "${GREEN}🌍 Configuring environment variables...${NC}"
if ! grep -q "export SPARK_HOME=$SPARK_HOME" ~/.bashrc; then
    cat <<EOL >> ~/.bashrc

# Spark Environment Variables
export SPARK_HOME=$SPARK_HOME
export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin
export PYSPARK_PYTHON=python3
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
EOL
fi

# Apply changes for current session
export SPARK_HOME=$SPARK_HOME
export PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH
export PYSPARK_PYTHON=python3
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

echo -e "${GREEN}🚀 Verifying Spark installation...${NC}"
if command -v spark-shell &>/dev/null && command -v spark-submit &>/dev/null; then
    echo -e "${GREEN}✅ spark-shell version:${NC}"
    spark-shell --version
    echo -e "${GREEN}✅ spark-submit version:${NC}"
    spark-submit --version
    echo -e "${GREEN}✅ Spark $SPARK_VERSION installed successfully on Ubuntu!${NC}"
else
    echo -e "${RED}❌ Spark installation incomplete. spark-shell or spark-submit not found in PATH.${NC}"
fi
