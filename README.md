# Live Install Script

This script automates the configuration of the Manjaro Live Environment, including:

* Setting system locale and LANG
* Configuring keyboard layout
* Preparing Calamares for automated installation
* Ensuring working directory and mount paths for headless CLI execution

---

## Usage

To download and run the script directly from GitHub:

```bash
curl -fsSL -H "Cache-Control: no-cache" "https://raw.githubusercontent.com/timbo-dev/workstation-bootstrap/refs/heads/main/live/live-install.sh?t=$(date +%s)" | sudo bash
```

**Notes:**

* The `live-install.sh` script **must be run as root** (`sudo`)
* It will automatically set `LANG=pt_BR.UTF-8` and keyboard layout to `br-abnt2`
* Ensure you are running in a **Live Environment** from `/` directory to avoid mount path issues

---

## Workstation Setup

Once the system is installed, you can run the workstation bootstrap to install all your tools and configurations.

### Clone and Execute

To clone the repository and execute the installer in one line:

```bash
git clone https://github.com/timbo-dev/workstation-bootstrap.git && cd workstation-bootstrap && sudo bash setup/install.sh
```
