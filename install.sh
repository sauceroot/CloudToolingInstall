#!/bin/bash

# Ensure package list is updated and the universe repository is added
echo "Updating package list and ensuring 'universe' repository is enabled..."
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository universe
sudo apt-get update

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for Python 3 and install if missing
if ! command_exists python3; then
    echo "Python 3 is not installed. Installing Python 3..."
    sudo apt-get install -y python3
else
    echo "Python 3 is already installed."
fi

# Check for pip for Python 3 and install if missing
if ! command_exists pip3; then
    echo "pip for Python 3 is not installed. Installing pip..."
    sudo apt-get install -y python3-pip
else
    echo "pip for Python 3 is already installed."
fi

# Check for python3-venv specifically and install the correct version
PYTHON_VERSION=$(python3 -V | awk '{print $2}' | cut -d. -f1,2)  # E.g., "3.8"
VENV_PACKAGE="python${PYTHON_VERSION}-venv"

if ! dpkg -s "$VENV_PACKAGE" >/dev/null 2>&1; then
    echo "$VENV_PACKAGE is not installed. Installing $VENV_PACKAGE..."
    sudo apt-get install -y "$VENV_PACKAGE"
else
    echo "$VENV_PACKAGE is already installed."
fi

# Define the target directory for the binary link in the user's home directory
TOOLS_DIR="$HOME/tools"
SCOUTSUITE_DIR="$HOME/ScoutSuite"

# Clone the ScoutSuite repository from GitHub if it does not already exist
if [ ! -d "$SCOUTSUITE_DIR" ]; then
    echo "Cloning ScoutSuite from GitHub into $SCOUTSUITE_DIR..."
    git clone https://github.com/nccgroup/ScoutSuite.git "$SCOUTSUITE_DIR"
else
    echo "ScoutSuite repository already exists in $SCOUTSUITE_DIR. Skipping clone."
fi

# Navigate to the ScoutSuite directory
cd "$SCOUTSUITE_DIR" || { echo "Failed to enter ScoutSuite directory."; exit 1; }

# Create a virtual environment inside the ScoutSuite directory
echo "Creating a virtual environment for ScoutSuite..."
python3 -m venv venv

# Check if the virtual environment was successfully created
if [ ! -d "venv" ]; then
    echo "Failed to create virtual environment. Please check the venv setup."
    exit 1
fi

# Activate the virtual environment
echo "Activating the virtual environment..."
source venv/bin/activate

# Upgrade pip and install ScoutSuite dependencies
echo "Installing ScoutSuite dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Deactivate the virtual environment
deactivate

# Create the tools directory if it doesn't exist
mkdir -p "$TOOLS_DIR"

# Create a wrapper script in tools to activate the venv and run ScoutSuite
echo "Creating ScoutSuite wrapper script in $TOOLS_DIR..."
cat << EOF > "$TOOLS_DIR/scoutsuite"
#!/bin/bash
SCOUTSUITE_DIR=$SCOUTSUITE_DIR
cd $SCOUTSUITE_DIR
source "$SCOUTSUITE_DIR/venv/bin/activate"
if [ "$#" -eq 0 ]; then
    python "$SCOUTSUITE_DIR/scout.py" --help
else
    python "$SCOUTSUITE_DIR/scout.py" "$@"
fi
deactivate
EOF

# Make the wrapper script executable
chmod +x "$TOOLS_DIR/scoutsuite"

echo 'export PATH="$HOME/tools:$PATH"' >> ~/.bashrc
source ~/.bashrc

echo "ScoutSuite has been successfully installed in '$SCOUTSUITE_DIR' with a wrapper in '$TOOLS_DIR'."
echo "$TOOLS_DIR has also been added to your path."
