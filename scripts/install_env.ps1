<#
.SYNOPSIS
  Install or update conda environments on Windows (PowerShell)

USAGE
  .\install_env.ps1 -Mode prod -EnvName <name> -EnvFile <path>
  .\install_env.ps1 -Mode dev  -EnvName <name> -EnvFile <path>

DESCRIPTION
  - prod: removes and recreates the environment from ENV_FILE
  - dev: updates the environment from ENV_FILE and installs pre-commit
#>

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('prod','dev')]
    [string]$Mode,

    [Parameter(Mandatory=$true)]
    [string]$EnvName,

    [Parameter(Mandatory=$true)]
    [string]$EnvFile
)

Write-Host "[install_env.ps1] Mode=$Mode EnvName=$EnvName EnvFile=$EnvFile"

# Use conda only (you can swap with mamba if needed)
$installer = "conda"

# Function to remove environment
function Remove-CondaEnv {
    Write-Host "[install_env.ps1] Checking if environment '$EnvName' exists..."
    try { & conda deactivate 2>$null } catch { }

    $envs = & $installer env list | ForEach-Object { ($_ -split '\s+')[0] }
    if ($envs -contains $EnvName) {
        Write-Host "[install_env.ps1] Removing environment '$EnvName'..."
        try {
            & $installer env remove -n $EnvName -y --quiet
            Write-Host "[install_env.ps1] Environment '$EnvName' removed successfully."
        } catch {
            Write-Warning "[install_env.ps1] Failed to remove environment '$EnvName' (continuing)..."
        }
    } else {
        Write-Host "[install_env.ps1] Environment '$EnvName' does not exist, skipping removal."
    }
}

# Function to create environment
function Create-CondaEnv {
    Write-Host "[install_env.ps1] Creating environment '$EnvName' from '$EnvFile'..."
    try {
        & $installer env create -n $EnvName --file $EnvFile -y -q
        Write-Host "[install_env.ps1] Environment '$EnvName' created successfully."
        Write-Host "[install_env.ps1] To activate: conda activate $EnvName"
    } catch {
        Write-Error "[install_env.ps1] Failed to create environment: $_"
        exit 1
    }
}

# Function to update dev environment
function Update-DevEnv {
    Write-Host "[install_env.ps1] Updating development dependencies into '$EnvName' from '$EnvFile'..."
    try {
        & $installer env update -n $EnvName --file $EnvFile -q
        Write-Host "[install_env.ps1] Development dependencies installed."
    } catch {
        Write-Error "[install_env.ps1] Failed to update dev dependencies: $_"
        exit 1
    }

    Write-Host "[install_env.ps1] Installing pre-commit into $EnvName..."
    try {
        & conda run -n $EnvName pre-commit install
    } catch {
        Write-Warning "[install_env.ps1] Failed to install pre-commit (continuing)..."
    }
}

# Main logic
switch ($Mode) {
    'prod' {
        Remove-CondaEnv
        Create-CondaEnv
    }
    'dev' {
        Update-DevEnv
    }
    default {
        Write-Error "Unknown mode: $Mode"
        exit 2
    }
}

Write-Host "[install_env.ps1] Done"
