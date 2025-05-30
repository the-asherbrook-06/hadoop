#!/bin/bash

SPARK_VERSION="3.5.6"
SPARK_HOME_PATH="$HOME/spark-$SPARK_VERSION"

# Remove old Spark env lines
sed -i '/export SPARK_HOME=/d' ~/.bashrc
sed -i '/export PATH=.*SPARK_HOME/d' ~/.bashrc
sed -i '/export PYSPARK_PYTHON=/d' ~/.bashrc
sed -i '/export JAVA_HOME=.*openjdk/d' ~/.bashrc

# Append correct Spark environment variables
cat <<EOL >> ~/.bashrc

# Spark Environment
export SPARK_HOME=$SPARK_HOME_PATH
export PATH=\$SPARK_HOME/bin:\$SPARK_HOME/sbin:\$PATH
export PYSPARK_PYTHON=python3
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
EOL

# Apply changes immediately
export SPARK_HOME=$SPARK_HOME_PATH
export PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH
export PYSPARK_PYTHON=python3
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

echo "✅ .bashrc cleaned and updated for Spark $SPARK_VERSION"
