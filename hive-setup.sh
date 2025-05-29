#!/bin/bash

set -e

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

HIVE_VERSION="4.0.1"
HIVE_HOME="$HOME/hive-$HIVE_VERSION"
HIVE_ARCHIVE="apache-hive-$HIVE_VERSION-bin.tar.gz"
HIVE_URL="https://dlcdn.apache.org/hive/hive-$HIVE_VERSION/$HIVE_ARCHIVE"

echo -e "${GREEN}📥 Downloading Apache Hive $HIVE_VERSION...${NC}"

if [ -d "$HIVE_HOME" ]; then
    echo "🔍 Hive already installed at $HIVE_HOME"
else
    wget "$HIVE_URL"
    tar -xzf "$HIVE_ARCHIVE"
    mv "apache-hive-$HIVE_VERSION-bin" "$HIVE_HOME"
    rm "$HIVE_ARCHIVE"
fi

echo -e "${GREEN}🌍 Configuring environment variables...${NC}"

if ! grep -q "HIVE_HOME" ~/.bashrc; then
    cat <<EOL >> ~/.bashrc

# Apache Hive Environment Variables
export HIVE_HOME=$HIVE_HOME
export PATH=\$PATH:\$HIVE_HOME/bin
export HADOOP_HOME=\$HOME/hadoop-3.4.0
export PATH=\$PATH:\$HADOOP_HOME/bin
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
EOL
    echo -e "${GREEN}✅ Environment variables added to ~/.bashrc${NC}"
fi

source ~/.bashrc

echo -e "${GREEN}🛠 Setting up Hive configuration...${NC}"

mkdir -p "$HIVE_HOME/conf"

cat > "$HIVE_HOME/conf/hive-site.xml" <<EOL
<?xml version="1.0"?>
<configuration>
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:derby:;databaseName=metastore_db;create=true</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>org.apache.derby.jdbc.EmbeddedDriver</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionUserName</name>
        <value>APP</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionPassword</name>
        <value>mine</value>
    </property>
</configuration>
EOL

echo -e "${GREEN}✅ Hive $HIVE_VERSION setup complete!${NC}"
echo "🧪 You can now run: hive"
