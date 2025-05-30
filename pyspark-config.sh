#!/bin/bash

set -e

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

echo -e "${GREEN}📦 Installing PySpark via pip...${NC}"
pip3 install pyspark

echo -e "${GREEN}🌍 Configuring PySpark environment variables...${NC}"
grep -q "PYSPARK_DRIVER_PYTHON" ~/.bashrc || cat <<EOL >> ~/.bashrc

# PySpark Environment Variables
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS="notebook"
EOL

# 🌟 Apply for current session
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS="notebook"

echo -e "${GREEN}🧪 Verifying PySpark installation...${NC}"
python3 -c "import pyspark; print('PySpark version:', pyspark.__version__)"

echo -e "${GREEN}✅ PySpark installation and configuration completed successfully!${NC}"
echo -e "${GREEN}▶️ To launch a Jupyter notebook with PySpark kernel:${NC}"
echo "   pyspark"
