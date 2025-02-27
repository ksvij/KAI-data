#!/bin/bash

# Define the repository URL
echo "Connecting to KAI servers"
REPO_URL="https://github.com/ksvij/KAI-data.git"

# Directory where the repository will be cloned
REPO_DIR="~/kai-data"

# Uninstall previous DeepSeek if installed
echo "Uninstalling previous DeepSeek..."
sudo apt-get remove -y deepseek

# Remove DeepSeek-related files
echo "Removing DeepSeek-related files..."
rm -rf ~/deepseek

# Update package list
echo "Updating package list..."
sudo apt-get update

# Upgrade system packages
echo "Upgrading system packages..."
sudo apt-get upgrade -y

# Install Python 3 and pip
echo "Installing Python 3 and pip..."
sudo apt-get install -y python3 python3-pip

# Install virtualenv
echo "Installing virtualenv..."
pip3 install virtualenv --break-system-packages

# Create a directory for the repository if it doesn't exist
echo "Creating directory for the repository..."
mkdir -p $REPO_DIR

echo "Installing UI"
pip install psutil --break-system-packages
# Clone the repository
echo "Cloning the repository..."
git clone $REPO_URL $REPO_DIR

# Navigate to the repository directory
cd $REPO_DIR

# Create a virtual environment
echo "Creating a virtual environment..."
python3 -m venv venv

# Activate the virtual environment
echo "Activating the virtual environment..."
source venv/bin/activate

# Upgrade pip inside the virtual environment
echo "Upgrading pip..."
pip install --upgrade pip

# Install Flask and flask_cors
echo "Installing Flask and flask_cors..."
pip install "Flask[async]" flask_cors --break-system-packages


# Reinstall DeepSeek
echo "Reinstalling DeepSeek..."
pip install deepseek  # Replace with the actual DeepSeek installation command

# Create the run.sh file
echo "Creating run.sh file..."
cat <<EOL > run.sh
#!/bin/bash

# Deactivate any active virtual environment
deactivate 2>/dev/null

# Activate the virtual environment
source venv/bin/activate

# Run the AI server
python3 ai.py
EOL

# Make run.sh executable
echo "Making run.sh executable..."
chmod +x run.sh

# Create .desktop file for easy access
echo "Creating .desktop file..."
cat <<EOL > ~/kai_server.desktop
[Desktop Entry]
Version=1.0
Name=KAI Server
Comment=Start the KAI Server
Exec=$(pwd)/run.sh
Icon=$(pwd)/code-dont-pull-use-install-file/logo.png
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

# Run the AI server
echo "Running the AI server..."
./run.sh
