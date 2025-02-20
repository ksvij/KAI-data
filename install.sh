#!/bin/bash

# Uninstall previous KAI server
echo "Uninstalling previous KAI server..."
rm -rf ~/kai_server.desktop ~/.local/share/applications/kai_server.desktop venv

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install Python 3 and pip
echo "Installing Python 3 and pip..."
sudo apt-get install -y python3 python3-pip

# Install virtualenv
echo "Installing virtualenv..."
pip3 install virtualenv --break-system-packages

# Create a virtual environment
echo "Creating a virtual environment..."
python3 -m venv venv

# Activate the virtual environment
echo "Activating the virtual environment..."
source venv/bin/activate

# Install Flask and flask_cors
echo "Installing Flask and flask_cors..."
pip install Flask flask_cors --break-system-packages
pip install "Flask[async]" flask_cors --break-system-packages


# Getting AI files...
echo "Getting AI files..."
# Placeholder for getting AI files (you can replace this with actual commands if necessary)

# Install DeepSeek...
echo "Installing DeepSeek..."
# Placeholder for installing DeepSeek (you can replace this with actual commands if necessary)

# Create the run.sh file
echo "Creating run.sh file..."
cat <<EOL > run.sh
#!/bin/bash

# Deactivate any active virtual environment
deactivate 2>/dev/null

# Activate the virtual environment
source venv/bin/activate

# Run the AI server
python3 ai2.py
EOL

# Make run.sh executable
echo "Making run.sh executable..."
chmod +x run.sh

# Create .desktop file
echo "Creating .desktop file..."
cat <<EOL > ~/kai_server.desktop
[Desktop Entry]
Version=1.0
Name=-KAI Server-
Comment=Start the KAI Server
Exec=$(pwd)/run.sh
Icon=$(pwd)/logo.png
Terminal=true
Type=Application
Categories=Development;
EOL

# Make .desktop file executable
echo "Making .desktop file executable..."
chmod +x ~/kai_server.desktop

# Move .desktop file to applications directory
echo "Moving .desktop file to applications directory..."
mv ~/kai_server.desktop ~/.local/share/applications/

# Print success message
echo "Environment setup complete! To activate the virtual environment, run 'source venv/bin/activate'."

echo "Inatalling lib. Flask,Flask-Cors,asyncio,subprocess and re"
pip install Flask Flask-Cors asyncio subprocess re --break-system-packages
pip install subprocess --break-system-packages
pip install "Flask[async]" flask_cors --break-system-packages -vvv


# Run the AI server
echo "Running the AI server..."
./run.sh
