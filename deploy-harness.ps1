#Requires -Version 5.1
param(
    [Parameter(Mandatory)][string]$Harness,
    [Parameter(Mandatory)][string]$Destino
)

$ErrorActionPreference = 'Stop'

$mapa = @{
    '010' = 'discovery'
    '020' = 'specification'
    '030' = 'design'
    '040' = 'planning'
    '050' = 'iteration'
    '060' = 'isolation'
    '070' = 'execution'
    '080' = 'verification'
    '090' = 'deployment'
}

# --- Validaciones ---

if (-not $mapa.ContainsKey($Harness)) {
    Write-Error "Harness '$Harness' no reconocido. Harnesses validos: $($mapa.Keys | Sort-Object | Join-String -Separator ', ')"
    exit 1
}

if (-not (Test-Path $Destino -PathType Container)) {
    Write-Error "El directorio destino '$Destino' no existe. Crealo antes de ejecutar este script."
    exit 1
}

$prefijo         = $mapa[$Harness]
$origenAgentes   = Join-Path $PSScriptRoot '.claude\agents'
$origenSkills    = Join-Path $PSScriptRoot '.claude\skills'
$origenTemplates = Join-Path $PSScriptRoot 'templates'

$destinoAgentes  = Join-Path $Destino '.claude\agents'
$destinoSkills   = Join-Path $Destino '.claude\skills'
$destinoClaude   = Join-Path $Destino '.claude'

Write-Host ""
Write-Host "=== deploy-harness.ps1 ===" -ForegroundColor Cyan
Write-Host "Harness : $Harness ($prefijo-*)"
Write-Host "Destino : $Destino"
Write-Host ""

# --- Crear estructura de directorios ---

New-Item -ItemType Directory -Force $destinoAgentes | Out-Null
New-Item -ItemType Directory -Force $destinoSkills  | Out-Null

# --- Hot-swap: limpiar archivos del harness en destino ---

$agentesEliminados = @()
$skillsEliminadas  = @()

$agentesExistentes = Get-ChildItem "$destinoAgentes\$prefijo-*.md" -ErrorAction SilentlyContinue
foreach ($f in $agentesExistentes) {
    Remove-Item $f.FullName -Force
    $agentesEliminados += $f.Name
}

$skillsExistentes = Get-ChildItem $destinoSkills -Directory -Filter "$prefijo-*" -ErrorAction SilentlyContinue
foreach ($d in $skillsExistentes) {
    Remove-Item $d.FullName -Recurse -Force
    $skillsEliminadas += $d.Name
}

# --- Copiar agentes ---

$agentesCargados = @()
$agentesOrigen = Get-ChildItem "$origenAgentes\$prefijo-*.md" -ErrorAction SilentlyContinue

if ($agentesOrigen.Count -eq 0) {
    Write-Warning "No se encontraron agentes con prefijo '$prefijo-*' en $origenAgentes"
} else {
    foreach ($f in $agentesOrigen) {
        Copy-Item $f.FullName -Destination $destinoAgentes
        $agentesCargados += $f.Name
    }
}

# --- Copiar skills ---

$skillsCargadas = @()
$skillsOrigen = Get-ChildItem $origenSkills -Directory -Filter "$prefijo-*" -ErrorAction SilentlyContinue

if ($skillsOrigen.Count -eq 0) {
    Write-Warning "No se encontraron skills con prefijo '$prefijo-*' en $origenSkills"
} else {
    foreach ($d in $skillsOrigen) {
        Copy-Item $d.FullName -Destination $destinoSkills -Recurse
        $skillsCargadas += $d.Name
    }
}

# --- Copiar templates (solo primer deployment) ---

$settingsAplicado = $false
$claudeMdAplicado = $false
$settingsOmitido  = $false
$claudeMdOmitido  = $false

$destinoSettings = Join-Path $destinoClaude 'settings.json'
$origenSettings  = Join-Path $origenTemplates 'client-project-settings.json'

if (-not (Test-Path $destinoSettings)) {
    if (Test-Path $origenSettings) {
        Copy-Item $origenSettings $destinoSettings
        $settingsAplicado = $true
    } else {
        Write-Warning "Template 'client-project-settings.json' no encontrado en $origenTemplates"
    }
} else {
    $settingsOmitido = $true
}

$destinoClaudeMd = Join-Path $Destino 'CLAUDE.md'
$origenClaudeMd  = Join-Path $origenTemplates 'client-project-CLAUDE.md'

# CLAUDE.md se sobreescribe siempre: el template evoluciona con cada harness.
# settings.json en cambio se omite si ya existe (el cliente puede haberlo personalizado).
if (Test-Path $origenClaudeMd) {
    Copy-Item $origenClaudeMd $destinoClaudeMd -Force
    $claudeMdAplicado = $true
} else {
    Write-Warning "Template 'client-project-CLAUDE.md' no encontrado en $origenTemplates"
}

# --- Copiar workflows (siempre sobreescribir, igual que CLAUDE.md) ---

$origenWorkflows  = Join-Path $origenTemplates 'workflows'
$destinoWorkflows = Join-Path $destinoClaude 'workflows'

New-Item -ItemType Directory -Force $destinoWorkflows | Out-Null

$workflowsCargados = @()
$workflowsOrigen = Get-ChildItem "$origenWorkflows\*.md" -ErrorAction SilentlyContinue
foreach ($f in $workflowsOrigen) {
    Copy-Item $f.FullName -Destination $destinoWorkflows -Force
    $workflowsCargados += $f.Name
}

# --- Copiar default_stacks.md (siempre sobreescribir — referencia de stack del equipo) ---

$origenStacks  = Join-Path $origenTemplates 'default_stacks.md'
$destinoStacks = Join-Path $Destino 'default_stacks.md'
$stacksCargado = $false

if (Test-Path $origenStacks) {
    Copy-Item $origenStacks $destinoStacks -Force
    $stacksCargado = $true
} else {
    Write-Warning "Template 'default_stacks.md' no encontrado en $origenTemplates"
}

# --- Inyectar path del deploy script en settings.json (para handoff automático entre harnesses) ---

$settingsPath = Join-Path $destinoClaude 'settings.json'
if (Test-Path $settingsPath) {
    $settingsObj = Get-Content $settingsPath -Raw | ConvertFrom-Json
} else {
    $settingsObj = [PSCustomObject]@{ permissions = [PSCustomObject]@{ allow = @() } }
}
if (-not ($settingsObj.PSObject.Properties['env'])) {
    $settingsObj | Add-Member -NotePropertyName 'env' -NotePropertyValue ([PSCustomObject]@{}) -Force
}
$settingsObj.env | Add-Member -NotePropertyName 'HARNESS_DEPLOY_SCRIPT' -NotePropertyValue $PSCommandPath -Force
$settingsObj | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding utf8

# --- Reporte final ---

Write-Host "--- Limpieza (hot-swap) ---" -ForegroundColor Yellow
if ($agentesEliminados.Count -gt 0) {
    $agentesEliminados | ForEach-Object { Write-Host "  [eliminado] agentes\$_" }
} else {
    Write-Host "  (ningun agente previo del harness $Harness en destino)"
}
if ($skillsEliminadas.Count -gt 0) {
    $skillsEliminadas | ForEach-Object { Write-Host "  [eliminada]  skills\$_" }
} else {
    Write-Host "  (ninguna skill previa del harness $Harness en destino)"
}

Write-Host ""
Write-Host "--- Agentes copiados ($($agentesCargados.Count)) ---" -ForegroundColor Green
$agentesCargados | ForEach-Object { Write-Host "  [OK] .claude\agents\$_" }

Write-Host ""
Write-Host "--- Skills copiadas ($($skillsCargadas.Count)) ---" -ForegroundColor Green
$skillsCargadas | ForEach-Object { Write-Host "  [OK] .claude\skills\$_" }

Write-Host ""
Write-Host "--- Templates ---" -ForegroundColor Green
if ($settingsAplicado) { Write-Host "  [OK]      .claude\settings.json (creado)" }
if ($settingsOmitido)  { Write-Host "  [omitido] .claude\settings.json (ya existia - no sobreescrito)" }
if ($claudeMdAplicado) { Write-Host "  [OK]      CLAUDE.md (aplicado)" }
if ($stacksCargado)   { Write-Host "  [OK]      default_stacks.md (aplicado)" }

Write-Host ""
Write-Host "--- Workflows copiados ($($workflowsCargados.Count)) ---" -ForegroundColor Green
if ($workflowsCargados.Count -gt 0) {
    $workflowsCargados | ForEach-Object { Write-Host "  [OK] .claude\workflows\$_" }
} else {
    Write-Warning "No se encontraron workflows en $origenWorkflows"
}

Write-Host ""
Write-Host "--- Configuración ---" -ForegroundColor Green
Write-Host "  [OK] HARNESS_DEPLOY_SCRIPT inyectado en .claude\settings.json"

Write-Host ""
Write-Host "=== Deployment completado ===" -ForegroundColor Cyan
Write-Host "Siguiente paso: abrir Claude Code en '$Destino'"
Write-Host ""
