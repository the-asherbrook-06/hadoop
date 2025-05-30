#!/bin/bash

SPARK_VERSION="3.5.1"
SPARK_DIR="/opt/spark"

# Download and extract Spark
wget https://downloads.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz
sudo tar -xzf spark-$SPARK_VERSION-bin-hadoop3.tgz -C /opt/
sudo mv /opt/spark-$SPARK_VERSION-bin-hadoop3 $SPARK_DIR
rm spark-$SPARK_VERSION-bin-hadoop3.tgz

# Set environment variables
cat <<EOF >> ~/.bashrc
export SPARK_HOME=$SPARK_DIR
export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin
export PYSPARK_PYTHON=python3
EOF

source ~/.bashrc
