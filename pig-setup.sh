#!/bin/bash

# Apache Pig Version
PIG_VERSION="0.17.0"
PIG_DIR="pig-$PIG_VERSION"
PIG_TAR="$PIG_DIR.tar.gz"
PIG_DOWNLOAD_URL="https://downloads.apache.org/pig/$PIG_VERSION/$PIG_TAR"

# Target installation directory
INSTALL_DIR="/usr/local"

# Check if Hadoop is installed
if ! command -v hadoop &> /dev/null; then
    echo "Hadoop not found. Please install Hadoop before running this script."
    exit 1
fi

# Download Pig
echo "Downloading Apache Pig $PIG_VERSION..."
wget "$PIG_DOWNLOAD_URL" -P /tmp || { echo "Download failed"; exit 1; }

# Extract Pig
echo "Extracting Pig..."
tar -xvzf /tmp/$PIG_TAR -C /tmp || { echo "Extraction failed"; exit 1; }

# Move to /usr/local
echo "Installing Pig to $INSTALL_DIR..."
sudo mv /tmp/$PIG_DIR "$INSTALL_DIR/pig"

# Add environment variables to .bashrc
echo "Configuring environment variables..."
cat <<EOL >> ~/.bashrc

# Apache Pig
export PIG_HOME=$INSTALL_DIR/pig
export PATH=\$PATH:\$PIG_HOME/bin
export PIG_CLASSPATH=\$HADOOP_HOME/etc/hadoop
EOL

# Apply changes
echo "Reloading environment variables..."
source ~/.bashrc

# Verify installation
echo "Verifying Pig installation..."
pig -version

echo "Apache Pig installation completed successfully."
