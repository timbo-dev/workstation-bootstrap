$VM_NAME = "manjaro-dev"
$ISO_URL = "https://download.manjaro.org/gnome/25.0.10/manjaro-gnome-25.0.10-minimal-251013-linux612.iso"
$ISO_PATH = "$PSScriptRoot\manjaro.iso"
$VDI_PATH = "$PSScriptRoot\$VM_NAME.vdi"

$RAM = 8192
$CPUS = 4
$DISK_SIZE = 50000 # MB
$VBoxDir = "C:\Program Files\Oracle\VirtualBox"

$ErrorActionPreference = 'Stop'

function Test-VMExists {
    param (
        [Parameter(Mandatory)]
        [string]$Name
    )

    $vms = & VBoxManage list vms
    return $vms -match "`"$Name`""
}

function Stop-VMIfRunning {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    $runningVMs = & VBoxManage list runningvms

    if ($runningVMs -match "`"$Name`"") {
        Write-Host "[INFO] VM '$Name' está rodando. Desligando..."
        & VBoxManage controlvm $Name poweroff
        Start-Sleep -Seconds 3
    }
}

function Remove-VM {
    param (
        [Parameter(Mandatory)]
        [string]$Name
    )

    Write-Host "[INFO] Removendo VM '$Name'..."
    VBoxManage unregistervm $Name --delete
}

function Ensure-Command {
    param (
        [Parameter(Mandatory)]
        [string]$Command,

        [Parameter(Mandatory)]
        [string]$WingetId
    )

    if (Get-Command $Command -ErrorAction SilentlyContinue) {
        Write-Host "[OK] $Command já está disponível"
        return
    }

    Write-Host "[INFO] $Command não encontrado. Instalando..."

    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "[ERROR] winget não está disponível neste sistema"
        exit 1
    }

    winget install --id $WingetId -e --accept-package-agreements --accept-source-agreements

    Write-Host "[INFO] Reabrir o terminal pode ser necessário"
}

function Ensure-Path {
    param (
        [Parameter(Mandatory)]
        [string]$PathToAdd
    )

    $currentPaths = $env:Path -split ';'

    if ($currentPaths -contains $PathToAdd) {
        Write-Host "[OK] Path já contém $PathToAdd"
        return
    }

    Write-Host "[INFO] Adicionando $PathToAdd ao PATH (sessão atual)"
    $env:Path += ";$PathToAdd"
}

# 1. Ensure VirtualBox is available FIRST
if (Test-Path "$VBoxDir\VBoxManage.exe") {
    Ensure-Path -PathToAdd $VBoxDir
}

Ensure-Command -Command "VBoxManage" -WingetId "Oracle.VirtualBox"

# 2. Now it is safe to check for existing VMs
if (Test-VMExists -Name $VM_NAME) {
    Write-Host "[WARN] VM '${VM_NAME}' já existe"
    Stop-VMIfRunning -Name $VM_NAME
    Remove-VM -Name $VM_NAME
}

# 3. Clean up VDI if it exists but wasn't deleted by unregistervm (or if script failed previously)
if (Test-Path $VDI_PATH) {
    Write-Host "[INFO] Removendo disco antigo $VDI_PATH..."
    Remove-Item -Path $VDI_PATH -Force
}

Write-Host "[INFO] Baixando ISO do Manjaro..."
if (-not (Test-Path $ISO_PATH)) {
    Invoke-WebRequest $ISO_URL -OutFile $ISO_PATH
}

Write-Host "[INFO] Criando VM..."
VBoxManage createvm --name $VM_NAME --ostype ArchLinux_64 --register

VBoxManage modifyvm $VM_NAME `
  --memory $RAM `
  --cpus $CPUS `
  --vram 128 `
  --graphicscontroller vmsvga `
  --clipboard bidirectional `
  --draganddrop bidirectional `
  --audio none `
  --nic1 nat

Write-Host "[INFO] Criando disco..."
VBoxManage createmedium disk --filename $VDI_PATH --size $DISK_SIZE

VBoxManage storagectl $VM_NAME --name "SATA" --add sata --controller IntelAhci
VBoxManage storageattach $VM_NAME --storagectl "SATA" --port 0 --device 0 --type hdd --medium $VDI_PATH
VBoxManage storageattach $VM_NAME --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium $ISO_PATH

Write-Host "[INFO] Iniciando VM..."
VBoxManage startvm $VM_NAME
