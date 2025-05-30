#!/bin/bash

set -e

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
VENV_DIR="$HOME/.pyspark-venv"

echo -e "${GREEN}📦 Installing python3-venv for Python $PYTHON_VERSION...${NC}"
sudo apt update
sudo apt install -y python$PYTHON_VERSION-venv

echo -e "${GREEN}📦 Creating virtual environment at $VENV_DIR...${NC}"
python3 -m venv "$VENV_DIR"

echo -e "${GREEN}📦 Activating virtual environment and installing PySpark + Jupyter...${NC}"
source "$VENV_DIR/bin/activate"
pip install --upgrade pip
pip install pyspark jupyter
deactivate

echo -e "${GREEN}🌍 Configuring PySpark environment variables in ~/.bashrc...${NC}"
grep -q "PYSPARK_DRIVER_PYTHON" ~/.bashrc || cat <<EOL >> ~/.bashrc

# PySpark Environment Variables
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS="notebook"
EOL

# Create a launcher script for easy execution
BIN_PATH="/usr/local/bin/pyspark-run"
echo -e "${GREEN}⚙️  Creating global 'pyspark-run' launcher script at $BIN_PATH...${NC}"
sudo tee "$BIN_PATH" > /dev/null <<EOF
#!/bin/bash
source "$VENV_DIR/bin/activate"
if [ -z "\$1" ]; then
    exec pyspark
else
    exec python3 "\$1"
fi
EOF
sudo chmod +x "$BIN_PATH"

echo -e "${GREEN}🧪 Verifying PySpark installation...${NC}"
"$VENV_DIR/bin/python" -c "import pyspark; print('PySpark version:', pyspark.__version__)"

echo -e "${GREEN}✅ PySpark installation and configuration completed successfully!${NC}"
echo -e "${GREEN}▶️ To run a PySpark script: ${NC}"
echo -e "   pyspark-run app.py"
echo -e "${GREEN}▶️ To launch Jupyter Notebook with PySpark: ${NC}"
echo -e "   pyspark-run"
