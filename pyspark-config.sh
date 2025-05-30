#!/bin/bash

set -e

GREEN="\033[0;32m"
NC="\033[0m"

echo -e "${GREEN}📦 Creating virtual environment at ~/.pyspark-venv...${NC}"
python3 -m venv ~/.pyspark-venv

echo -e "${GREEN}📦 Activating virtual environment and installing PySpark + Jupyter Notebook...${NC}"
source ~/.pyspark-venv/bin/activate
pip install --upgrade pip
pip install pyspark jupyter notebook

echo -e "${GREEN}🔧 Creating pyspark-run launcher script...${NC}"
cat << 'EOF' > ~/.pyspark-venv/bin/pyspark-run
#!/bin/bash
source "$HOME/.pyspark-venv/bin/activate"
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS="notebook"

# If a .py file is passed, run it with Python; otherwise, launch PySpark shell
if [[ "$1" == *.py ]]; then
  python "$@"
else
  exec pyspark "$@"
fi
EOF

chmod +x ~/.pyspark-venv/bin/pyspark-run

echo -e "${GREEN}🔗 Linking pyspark-run to ~/bin...${NC}"
mkdir -p ~/bin
ln -sf ~/.pyspark-venv/bin/pyspark-run ~/bin/pyspark-run

if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc; then
  echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
fi

echo -e "${GREEN}✅ PySpark + Jupyter environment setup complete!${NC}"
echo -e "${GREEN}🧪 Verifying installation...${NC}"
~/.pyspark-venv/bin/python -c "import pyspark; print('PySpark version:', pyspark.__version__)"

echo -e "${GREEN}🎉 Usage:${NC}"
echo -e "  ➤ pyspark-run            # Launch Jupyter Notebook with PySpark"
echo -e "  ➤ pyspark-run app.py     # Run a PySpark script"
echo -e "  ➤ pyspark-run --master local[*]   # Launch PySpark shell with options"

echo -e "${GREEN}💡 Restart your terminal or run: source ~/.bashrc${NC}"
