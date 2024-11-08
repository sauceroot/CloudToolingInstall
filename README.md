# CloudToolingInstall - ScoutSuite Installation and Setup Script

This script installs [ScoutSuite](https://github.com/nccgroup/ScoutSuite), an open-source multi-cloud security auditing tool, and configures it for easy access on Ubuntu/Debian systems. The installation includes setting up necessary dependencies, creating a virtual environment, and creating a wrapper script for convenient usage from any directory.

## Requirements

- **Ubuntu/Debian**-based system
- `sudo` privileges for installing packages
- Internet connection for cloning the repository and installing dependencies

## Installation

### Steps

1. **Download the Script**: Download or copy the script provided above and save it as `install_scoutsuite.sh`.
2. **Make the Script Executable**:
   ```bash
   chmod +x install_scoutsuite.sh
   ```
3. **Run the Script**:
   ```bash
   ./install_scoutsuite.sh
   ```

The script will:
- Update package repositories and ensure the `universe` repository is enabled.
- Install Python 3, `pip`, and the specific `python3-venv` package required for creating virtual environments.
- Clone the latest version of the ScoutSuite repository into `~/ScoutSuite`.
- Set up a virtual environment in the ScoutSuite directory and install dependencies from the `requirements.txt` file.
- Create a `tools` directory in your home directory if it doesn't exist.
- Generate a wrapper script in `~/tools` that enables running ScoutSuite from any directory by typing `scoutsuite`.

### Script Breakdown

The script performs the following steps:

1. **Update Package Repositories**: Ensures your system is up-to-date and that the `universe` repository is available for additional packages.

2. **Install Dependencies**:
   - Checks if `python3`, `pip3`, and the correct version of `venv` are installed and installs them if needed.

3. **Clone ScoutSuite**:
   - If `~/ScoutSuite` does not already exist, the script clones the ScoutSuite repository from GitHub.

4. **Set Up a Virtual Environment**:
   - Creates a virtual environment (`venv`) in the ScoutSuite directory, installs dependencies, and deactivates the environment.

5. **Create a Wrapper Script**:
   - The wrapper script is saved to `~/tools/scoutsuite`, allowing you to run ScoutSuite from any directory.
   - This wrapper activates the virtual environment and runs ScoutSuite, keeping the environment active for multiple commands.

6. **Add `~/tools` to PATH**:
   - Updates your `PATH` in `.bashrc`, allowing you to use the `scoutsuite` command globally.

## Usage

After installation, you can run ScoutSuite from any directory:

```bash
scoutsuite aws --help
```

- If no arguments are provided, ScoutSuite displays its help menu.
- The `scoutsuite` command activates the virtual environment and runs ScoutSuite in that environment, enabling you to run multiple commands without reactivating the environment each time.

## Notes

- To activate `~/tools` in your `PATH` immediately, restart your terminal or run:
  ```bash
  source ~/.bashrc
  ```

