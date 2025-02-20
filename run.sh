#!/bin/bash

# Deactivate any active virtual environment
deactivate 2>/dev/null

# Activate the virtual environment
source venv/bin/activate

# Run the AI server
python3 ai2.py
