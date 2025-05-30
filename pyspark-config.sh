#!/bin/bash

# Optional PySpark config (for Jupyter integration, if needed)

# Set environment for PySpark
cat <<EOF >> ~/.bashrc
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS="notebook"
EOF

source ~/.bashrc
