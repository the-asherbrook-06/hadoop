#!/bin/bash

# Variables (modify if needed)
HIVE_VERSION="3.1.3"
HIVE_DOWNLOAD_URL="https://downloads.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz"
INSTALL_DIR="/usr/local"
HIVE_HOME="${INSTALL_DIR}/hive"
HADOOP_HOME="/usr/local/hadoop"  # Change this if your Hadoop is installed elsewhere

# Check if running as root for permission to write to /usr/local
if [[ $EUID -ne 0 ]]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

echo "Downloading Apache Hive $HIVE_VERSION..."
wget $HIVE_DOWNLOAD_URL -O /tmp/apache-hive-${HIVE_VERSION}-bin.tar.gz

if [ $? -ne 0 ]; then
  echo "Download failed! Exiting."
  exit 1
fi

echo "Extracting Hive..."
tar -xzf /tmp/apache-hive-${HIVE_VERSION}-bin.tar.gz -C $INSTALL_DIR

echo "Removing any existing Hive installation..."
rm -rf $HIVE_HOME

echo "Renaming extracted folder to $HIVE_HOME"
mv ${INSTALL_DIR}/apache-hive-${HIVE_VERSION}-bin $HIVE_HOME

echo "Setting environment variables in /etc/profile.d/hive.sh..."

cat <<EOL > /etc/profile.d/hive.sh
export HIVE_HOME=$HIVE_HOME
export PATH=\$PATH:\$HIVE_HOME/bin
export HADOOP_HOME=$HADOOP_HOME
export PATH=\$PATH:\$HADOOP_HOME/bin
EOL

chmod +x /etc/profile.d/hive.sh

echo "Sourcing environment variables..."
source /etc/profile.d/hive.sh

echo "Copying hive-site.xml template..."
cp $HIVE_HOME/conf/hive-default.xml.template $HIVE_HOME/conf/hive-site.xml

echo "Initializing Hive schema with embedded Derby DB..."
$HIVE_HOME/bin/schematool -initSchema -dbType derby

echo "Hive installation complete!"
echo "You can now run Hive using the command: hive"

