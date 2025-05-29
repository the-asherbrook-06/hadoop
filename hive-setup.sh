#!/bin/bash

set -e

# Define colors for output
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

# Define Hive version and installation directory
HIVE_VERSION="3.1.3"
HIVE_HOME="$HOME/hive-$HIVE_VERSION"
HIVE_ARCHIVE="apache-hive-$HIVE_VERSION-bin.tar.gz"
HIVE_DOWNLOAD_URL="https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/$HIVE_ARCHIVE"

echo -e "${GREEN}📥 Downloading Apache Hive $HIVE_VERSION...${NC}"

# Download and extract Hive if not already present
if [ -d "$HIVE_HOME" ]; then
    echo "🔍 Hive already exists at $HIVE_HOME. Skipping download..."
else
    wget "$HIVE_DOWNLOAD_URL"
    tar -xzf "$HIVE_ARCHIVE"
    mv "apache-hive-$HIVE_VERSION-bin" "$HIVE_HOME"
    rm "$HIVE_ARCHIVE"
fi

echo -e "${GREEN}🌍 Configuring environment variables...${NC}"

# Add Hive environment variables to .bashrc if not already present
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
else
    echo -e "${RED}⚠️ Hive environment variables already set in ~/.bashrc${NC}"
fi

# Source the updated .bashrc
source ~/.bashrc

echo -e "${GREEN}🛠 Setting up Hive configuration...${NC}"

# Create Hive configuration directory if it doesn't exist
mkdir -p "$HIVE_HOME/conf"

# Create hive-site.xml with basic configuration
cat > "$HIVE_HOME/conf/hive-site.xml" <<EOL
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:derby:;databaseName=metastore_db;create=true</value>
        <description>JDBC connect string for a JDBC metastore</description>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>org.apache.derby.jdbc.EmbeddedDriver</value>
        <description>Driver class name for a JDBC metastore</description>
    </property>
    <property>
        <name>hive.metastore.warehouse.dir</name>
        <value>$HOME/hive-warehouse</value>
        <description>Location of default database for the warehouse</description>
    </property>
</configuration>
EOL

# Create warehouse directory
mkdir -p "$HOME/hive-warehouse"

echo -e "${GREEN}✅ Hive configuration complete
