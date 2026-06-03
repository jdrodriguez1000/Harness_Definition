Despliega el FORGE Discovery Harness (010) en el proyecto actual.

## Pasos

1. Lee `~/.forge/forge.config.json` con PowerShell y extrae el valor de `forge_home`.

2. Ejecuta el script de deployment apuntando a la carpeta actual:
   ```powershell
   $config = Get-Content "$HOME\.forge\forge.config.json" | ConvertFrom-Json
   & "$($config.forge_home)\deploy-harness.ps1" -Harness 010 -Destino (Get-Location).Path
   ```

3. Si el script termina sin errores, muestra este mensaje exacto:
   ```
   FORGE: Discovery Harness desplegado correctamente.
   Siguiente paso: escribe /forge-discovery para iniciar el harness.
   ```

4. Si ocurre un error (forge.config.json no existe, deploy falla), explica el problema
   y sugiere correr `forge-setup.ps1` desde la carpeta de Harness_Definition.

## Notas
- No inicies el harness ni invoques ningun agente — este comando solo hace el deploy.
- No preguntes nada al usuario antes de ejecutar.
