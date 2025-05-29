#!/bin/bash

set -e

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

HIVE_VERSION="3.1.3"
HIVE_DIR="$HOME/hive-$HIVE_VERSION"
HIVE_DOWNLOAD_URL="https://downloads.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz"

echo -e "${GREEN}📥 Downloading Apache Hive $HIVE_VERSION...${NC}"

if [ -d "$HIVE_DIR" ]; then
    echo -e "${GREEN}✅ Hive already downloaded. Skipping...${NC}"
else
    wget "$HIVE_DOWNLOAD_URL" -O apache-hive-$HIVE_VERSION-bin.tar.gz
    tar -xzf apache-hive-$HIVE_VERSION-bin.tar.gz
    mv apache-hive-$HIVE_VERSION-bin "$HIVE_DIR"
fi

echo -e "${GREEN}⚙️ Setting up environment variables...${NC}"

grep -q "HIVE_HOME" ~/.bashrc || cat <<EOL >> ~/.bashrc

# Hive Environment Variables
export HIVE_HOME=$HIVE_DIR
export PATH=\$PATH:\$HIVE_HOME/bin
export HADOOP_HOME=\$HOME/hadoop-3.4.0
export PATH=\$PATH:\$HADOOP_HOME/bin
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
EOL

source ~/.bashrc

echo -e "${GREEN}📂 Creating Hive warehouse directories...${NC}"
mkdir -p $HOME/hive/warehouse
mkdir -p $HOME/hive/tmp
mkdir -p $HOME/hive/logs

echo -e "${GREEN}📝 Configuring Hive default settings...${NC}"

cat > "$HIVE_DIR/conf/hive-site.xml" <<EOL
<configuration>
  <property>
    <name>hive.exec.local.scratchdir</name>
    <value>$HOME/hive/tmp</value>
  </property>
  <property>
    <name>hive.exec.scratchdir</name>
    <value>$HOME/hive/tmp</value>
  </property>
  <property>
    <name>hive.metastore.warehouse.dir</name>
    <value>$HOME/hive/warehouse</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:derby:;databaseName=metastore_db;create=true</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>org.apache.derby.jdbc.EmbeddedDriver</value>
  </property>
</configuration>
EOL

echo -e "${GREEN}🚀 Initializing Hive Metastore...${NC}"
schematool -dbType derby -initSchema || echo -e "${RED}⚠️ Hive schema might already be initialized.${NC}"

echo -e "${GREEN}✅ Hive setup complete!${NC}"
echo "📋 To start Hive, run: hive"
