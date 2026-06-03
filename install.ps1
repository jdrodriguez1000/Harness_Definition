# FORGE - Script de instalacion en maquina nueva
# Uso: irm https://raw.githubusercontent.com/jdrodriguez1000/Harness_Definition/main/install.ps1 | iex

$repo   = "https://github.com/jdrodriguez1000/Harness_Definition.git"
$folder = "Harness_Definition"

Write-Host "=== FORGE Installer ===" -ForegroundColor Cyan
Write-Host "Destino: $(Get-Location)\$folder"
Write-Host ""

# --- Clonar repo ---
if (Test-Path $folder) {
    Write-Host "[SKIP] '$folder' ya existe - omitiendo clone" -ForegroundColor Yellow
} else {
    Write-Host "Clonando FORGE desde GitHub..." -ForegroundColor White
    git clone $repo $folder
    if (-not $?) {
        Write-Host "[ERROR] git clone fallo. Verifica tu conexion y que git este instalado." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""

# --- Ejecutar setup ---
$forgeHome    = Join-Path (Get-Location).Path $folder
$setupScript  = Join-Path $forgeHome "forge-setup.ps1"

Write-Host "Ejecutando forge-setup.ps1..." -ForegroundColor White
& $setupScript -ForgeHome $forgeHome

Write-Host ""
Write-Host "=== FORGE instalado correctamente ===" -ForegroundColor Green
Write-Host "Abre Claude en la carpeta de un proyecto nuevo y escribe /forge-init" -ForegroundColor Cyan
