#!/bin/bash

set -e

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

echo -e "${GREEN}🔍 Checking for python3-venv...${NC}"
if ! dpkg -s python3-venv >/dev/null 2>&1; then
    echo -e "${GREEN}📦 Installing python3-venv...${NC}"
    sudo apt update
    sudo apt install -y python3-venv
fi

echo -e "${GREEN}📦 Creating virtual environment at ~/.pyspark-venv...${NC}"
python3 -m venv ~/.pyspark-venv

echo -e "${GREEN}🐍 Activating virtual environment and installing PySpark & Jupyter...${NC}"
~/.pyspark-venv/bin/pip install --upgrade pip
~/.pyspark-venv/bin/pip install pyspark jupyter

echo -e "${GREEN}🧪 Verifying PySpark installation...${NC}"
~/.pyspark-venv/bin/python -c "import pyspark; print('PySpark version:', pyspark.__version__)"

echo -e "${GREEN}🚀 Creating pyspark-run helper script...${NC}"
mkdir -p ~/.local/bin
cat << 'EOF' > ~/.local/bin/pyspark-run
#!/bin/bash
~/.pyspark-venv/bin/python "$@"
EOF
chmod +x ~/.local/bin/pyspark-run

# Add ~/.local/bin to PATH if not already
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.local/bin:$PATH"
fi

echo -e "${GREEN}✅ PySpark virtual environment setup complete!${NC}"
echo -e "${GREEN}▶️ You can now run PySpark scripts globally using:${NC}"
echo "   pyspark-run app.py"
