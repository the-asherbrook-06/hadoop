#!/bin/bash

set -e

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

read -p "Enter Spark version to install (e.g. 3.5.6): " SPARK_VERSION
SPARK_DIR_NAME="spark-$SPARK_VERSION-bin-hadoop3"
SPARK_HOME_FULL="$HOME/spark-$SPARK_VERSION"
SPARK_TGZ="$SPARK_DIR_NAME.tgz"

echo -e "${GREEN}📥 Downloading Spark $SPARK_VERSION for Linux (Hadoop 3)...${NC}"
if [ -d "$SPARK_HOME_FULL" ]; then
    echo -e "${GREEN}🔍 Spark already exists at $SPARK_HOME_FULL. Skipping download...${NC}"
else
    wget "https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/$SPARK_TGZ" -O "$SPARK_TGZ"
    tar -xzf "$SPARK_TGZ"
    mv "$SPARK_DIR_NAME" "$SPARK_HOME_FULL"
    rm "$SPARK_TGZ"
fi

echo -e "${GREEN}🌍 Updating ~/.bashrc with Spark environment variables...${NC}"
grep -q "export SPARK_HOME=" ~/.bashrc && \
    sed -i '/export SPARK_HOME=/d' ~/.bashrc

cat <<EOL >> ~/.bashrc

# Spark Environment Variables
export SPARK_HOME=$SPARK_HOME_FULL
export PATH=\$SPARK_HOME/bin:\$SPARK_HOME/sbin:\$PATH
export PYSPARK_PYTHON=python3
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
EOL

# Apply changes for current shell
export SPARK_HOME=$SPARK_HOME_FULL
export PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH
export PYSPARK_PYTHON=python3
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

echo -e "${GREEN}🚀 Verifying Spark installation...${NC}"
if command -v spark-shell &> /dev/null; then
    spark-shell --version
    echo -e "${GREEN}✅ Spark $SPARK_VERSION installed and ready on Ubuntu!${NC}"
else
    echo -e "${RED}❌ spark-shell not found in PATH. Please check your setup.${NC}"
fi
