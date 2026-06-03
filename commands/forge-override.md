Registra una restricción vinculante del usuario e inyecta un override en el harness activo.

## Cuándo ejecutar

Cuando el usuario escribe `/forge-override "texto"` en un momento de revisión — Sprint Contract (Paso B) o CP-03 (Paso D) — para corregir una decisión del harness con una restricción propia que debe respetarse como fuente de verdad.

## Pasos

### 1. Extraer el texto del override

El texto del override es el argumento que el usuario escribió después de `/forge-override`.

- Si no hay argumento o está vacío: informar al usuario "Uso: /forge-override \"descripción de la restricción\"" y detener.

### 2. Obtener timestamp real

```powershell
(Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
```

### 3. Verificar harness activo

Leer `persistence/harness-state.json`.

- Si no existe: informar "No hay harness activo en este directorio. Verifica que estás en la carpeta correcta del proyecto." y detener.
- Identificar el harness activo con el mismo orden de prioridad que `/forge-suspend`: 040 → 030 → 020 → 010.
- Si todos los harnesses están en `PHASE_COMPLETE`: informar "Todos los harnesses están completos. No hay nada que overridear." y detener.

Extraer: `phase_id` (ej. `"030_design"`) y `status` del harness activo.

### 4. Generar ID del override

Leer el campo `"overrides"` del harness activo en `harness-state.json`.

- Si el campo no existe o está vacío → ID: `OV-001`
- Si tiene N elementos → ID: `OV-<N+1 con padding de 3 dígitos>` (ej. `OV-002`, `OV-010`)

### 5. Registrar en harness-state.json

Construir el objeto override:
```json
{
  "id": "<ID generado>",
  "timestamp": "<timestamp del Paso 2>",
  "harness": "<phase_id del harness activo>",
  "texto": "<texto del override>",
  "status": "ACTIVE"
}
```

Agregar este objeto al array `"overrides"` del harness activo. Si el campo `"overrides"` no existe en la entrada del harness, crearlo como array vacío antes de agregar.

Actualizar `"last_updated"` del harness activo con el timestamp.

**Regla crítica:** Escribir el archivo completo con TODOS los campos previos intactos. No eliminar ni modificar campos de harnesses anteriores ni de la raíz.

### 6. Registrar en persistence/overrides.md

Si `persistence/overrides.md` no existe, crear con cabecera:
```markdown
# Overrides del Proyecto

Restricciones vinculantes registradas por el usuario durante la ejecución de los harnesses FORGE.
Los harnesses futuros leen este archivo en su inicialización (E10-A) para respetar estas restricciones.

---
```

Agregar al final del archivo:
```markdown
## <ID> — <timestamp>

**Harness:** <phase_id>
**Restricción:** <texto del override>
**Status:** ACTIVE

---
```

### 7. Registrar evento en persistence/claude-progress.txt

```powershell
Add-Content -Path "persistence/claude-progress.txt" -Value "[OVERRIDE] <timestamp> — <ID> registrado en <phase_id>. Restricción: `"<texto>`"" -Encoding utf8
```

Si `persistence/claude-progress.txt` no existe, crearlo primero:
```powershell
if (-not (Test-Path "persistence/claude-progress.txt")) { New-Item -ItemType File -Path "persistence/claude-progress.txt" -Force | Out-Null }
```

### 8. Confirmar y retornar resultado

Mostrar este mensaje exacto al usuario:

```
FORGE: Override registrado.

  ID          : <ID>
  Harness     : <phase_id>
  Restricción : <texto del override>

Esta restricción es ahora vinculante para el harness activo y quedará disponible
para harnesses futuros en persistence/overrides.md.
```

Retornar el siguiente bloque (para que el ciclo activo lo lea y decida cómo continuar):

```
FORGE_OVERRIDE_RESULT:
  id: <ID>
  texto: <texto del override>
  constraint_str: "[OVERRIDE VINCULANTE — <ID>] <texto del override>"
```

## Comportamiento del ciclo tras el FORGE_OVERRIDE_RESULT

El ciclo activo lee el `FORGE_OVERRIDE_RESULT` y actúa según el momento en que el usuario usó `/forge-override`:

**En Sprint Contract (Paso B):**
→ Volver al Paso A incluyendo `adjustment_request: <constraint_str>`.
→ El governor re-genera el Sprint Contract con la restricción como constraint duro.

**En CP-03 (Paso D):**
→ Invocar el governor con `[MODO: POST_CP03]`, `cp03_decision: rework`, `changes: <constraint_str>`.
→ El governor re-ejecuta el worker afectado. La restricción no es negociable.

## Notas

- No invocar ningún governor directamente. El ciclo activo lee el `FORGE_OVERRIDE_RESULT` y decide cómo continuar.
- Si el usuario invoca `/forge-override` fuera de un momento de revisión (ej. durante ejecución técnica), el override queda registrado en `persistence/` de todas formas. El ciclo lo notará al llegar al próximo gate.
- Múltiples overrides son acumulativos. Si hay más de un override ACTIVE, el ciclo concatena todos los `constraint_str` antes de pasarlos al governor.
- Los overrides registrados en `persistence/overrides.md` son leídos por los governors de harnesses futuros en su E10-A para aplicarlos como restricciones desde el inicio.
