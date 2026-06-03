# FORGE - Script de configuracion por maquina
# Instala el config global y los slash commands de Claude.
# Uso directo:  .\forge-setup.ps1
# Uso desde install.ps1: .\forge-setup.ps1 -ForgeHome "C:\ruta\a\Harness_Definition"

param(
    [string]$ForgeHome = $PSScriptRoot
)

Write-Host "--- forge-setup.ps1 ---"
Write-Host "ForgeHome: $ForgeHome"
Write-Host ""

# --- Config global ~/.forge/forge.config.json ---
$forgeConfigDir = Join-Path $HOME ".forge"
if (-not (Test-Path $forgeConfigDir)) {
    New-Item -ItemType Directory -Path $forgeConfigDir | Out-Null
}

$configPath = Join-Path $forgeConfigDir "forge.config.json"
@{ forge_home = $ForgeHome } | ConvertTo-Json | Out-File -FilePath $configPath -Encoding utf8 -Force
Write-Host "[OK] Config: $configPath"

# --- Slash commands ~/.claude/commands/ ---
$claudeCommandsDir = Join-Path $HOME ".claude\commands"
if (-not (Test-Path $claudeCommandsDir)) {
    New-Item -ItemType Directory -Path $claudeCommandsDir | Out-Null
}

$commandsSource = Join-Path $ForgeHome "commands"

foreach ($src in (Get-ChildItem -Path $commandsSource -Filter "*.md" -File)) {
    $dst = Join-Path $claudeCommandsDir $src.Name
    Copy-Item -Path $src.FullName -Destination $dst -Force
    Write-Host "[OK] Slash command: /$($src.BaseName)"
}

Write-Host ""
Write-Host "Setup completo."
