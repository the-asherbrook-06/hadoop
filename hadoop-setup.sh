#!/bin/bash

set -e

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

# Ask user Hadoop version to download
read -p "Enter Hadoop version to install (e.g. 3.4.0): " HADOOP_VERSION
HADOOP_HOME=$HOME/hadoop-$HADOOP_VERSION

echo -e "${GREEN}📥 Downloading and extracting Hadoop $HADOOP_VERSION...${NC}"

if [ -d "$HADOOP_HOME" ]; then
    echo "🔍 Hadoop already exists. Skipping download..."
else
    wget https://dlcdn.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
    tar -xzf hadoop-$HADOOP_VERSION.tar.gz
    mv hadoop-$HADOOP_VERSION $HADOOP_HOME
fi

echo -e "${GREEN}📁 Creating necessary directories...${NC}"
mkdir -p $HOME/tmpdata
mkdir -p $HOME/dfsdata/namenode
mkdir -p $HOME/dfsdata/datanode

echo -e "${GREEN}🌍 Configuring environment variables...${NC}"
grep -q "HADOOP_HOME" ~/.bashrc || cat <<EOL >> ~/.bashrc

# Hadoop Environment Variables
export HADOOP_HOME=$HADOOP_HOME
export HADOOP_INSTALL=\$HADOOP_HOME
export HADOOP_MAPRED_HOME=\$HADOOP_HOME
export HADOOP_COMMON_HOME=\$HADOOP_HOME
export HADOOP_HDFS_HOME=\$HADOOP_HOME
export YARN_HOME=\$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native
export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin
export HADOOP_OPTS="-Djava.library.path=\$HADOOP_HOME/lib/native"
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
EOL

source ~/.bashrc

echo -e "${GREEN}⚙️ Setting JAVA_HOME in hadoop-env.sh...${NC}"
sed -i "s|^# export JAVA_HOME=.*|export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64|" $HADOOP_HOME/etc/hadoop/hadoop-env.sh

echo -e "${GREEN}📝 Configuring Hadoop XML files...${NC}"

# core-site.xml
cat > $HADOOP_HOME/etc/hadoop/core-site.xml <<EOL
<configuration>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>$HOME/tmpdata</value>
    </property>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://127.0.0.1:9000</value>
    </property>
</configuration>
EOL

# hdfs-site.xml
cat > $HADOOP_HOME/etc/hadoop/hdfs-site.xml <<EOL
<configuration>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>$HOME/dfsdata/namenode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>$HOME/dfsdata/datanode</value>
    </property>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
EOL

# mapred-site.xml
cat > $HADOOP_HOME/etc/hadoop/mapred-site.xml <<EOL
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
EOL

# yarn-site.xml
cat > $HADOOP_HOME/etc/hadoop/yarn-site.xml <<EOL
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
        <value>org.apache.hadoop.mapred.ShuffleHandler</value>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>127.0.0.1</value>
    </property>
    <property>
        <name>yarn.acl.enable</name>
        <value>0</value>
    </property>
    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PERPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
    </property>
</configuration>
EOL

echo -e "${GREEN}🛠 Formatting Hadoop Namenode...${NC}"
read -p "❗ Proceed to format namenode? (y/n): " confirm
if [[ "$confirm" == "y" ]]; then
    hdfs namenode -format
else
    echo -e "${RED}⚠️ Namenode formatting skipped.${NC}"
fi

echo -e "${GREEN}✅ Hadoop installation and configuration completed successfully!${NC}"
echo "📋 To start Hadoop services: start-dfs.sh && start-yarn.sh"
echo "📋 To verify: jps"
echo "🌐 Hadoop UI: http://localhost:9870"
echo "🌐 YARN UI: http://localhost:8088"
