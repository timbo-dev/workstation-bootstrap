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
curl -fsSL https://raw.githubusercontent.com/timbo-dev/workstation-bootstrap/refs/heads/main/live/live-install.sh | sudo bash
```

**Notes:**

* The script **must be run as root** (`sudo`)
* It will automatically set `LANG=pt_BR.UTF-8` and keyboard layout to `br-abnt2`
* Ensure you are running in a **Live Environment** from `/` directory to avoid mount path issues
