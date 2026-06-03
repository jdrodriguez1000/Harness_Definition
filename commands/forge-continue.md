Reanuda el harness suspendido del proyecto actual desde el punto exacto de interrupción.

## Cuándo ejecutar

Cuando el usuario escribe `/forge-continue` para retomar un harness previamente suspendido con `/forge-suspend`.

## Pasos

### 1. Obtener timestamp real

```powershell
(Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
```

### 2. Verificar que existe una suspensión activa

Leer `persistence/harness-state.json`.

- Si no existe o no es parseable: informar "No hay harness activo en este directorio. Verifica que estás en la carpeta correcta del proyecto." y detener.
- Buscar el campo `suspension` en el harness activo (mismo orden de prioridad que `/forge-suspend`: 040 → 030 → 020 → 010).
- Si `status != "SUSPENDED"` en ningún harness: informar "No hay harness suspendido en este proyecto. Usa `/forge-discovery` para iniciar o continuar normalmente." y detener.
- Si `suspension == null` pero `status == "SUSPENDED"`: informar "El harness está marcado como suspendido pero no tiene datos de reanudación. Usa `/forge-discovery` e invoca el governor manualmente." y detener.

Extraer del bloque `suspension`:
- `harness` → qué harness reanudar
- `governor_mode` → con qué modo invocar el governor
- `context_note` → resumen del contexto
- `resume_instruction` → instrucción precisa de reanudación

### 3. Registrar evento de reanudación en claude-progress.txt

```powershell
Add-Content -Path "persistence/claude-progress.txt" -Value "[REANUDACIÓN] <timestamp> — Harness <harness> reanudado en modo <governor_mode>. Contexto: <context_note>" -Encoding utf8
```

Si `persistence/claude-progress.txt` no existe, crearlo primero:
```powershell
if (-not (Test-Path "persistence/claude-progress.txt")) { New-Item -ItemType File -Path "persistence/claude-progress.txt" -Force | Out-Null }
```

### 4. Limpiar bloque de suspensión y restaurar status

Leer `persistence/harness-state.json` completo. Aplicar los siguientes cambios al harness activo:

- `suspension` → `null`
- `status` → restaurar según `governor_mode`:

| governor_mode | status a restaurar |
|---|---|
| `INIT` | `PENDING_CONTRACT` |
| `EXECUTE` | `ACTIVE` |
| `POST_CP03` | `ACTIVE` |
| `POST_CP04` | `ACTIVE` |
| `CLOSE` | `ACTIVE` |

**Regla crítica:** Escribir el archivo completo con TODOS los campos previos intactos. No eliminar ni modificar campos de harnesses anteriores.

### 5. Mapear harness a governor

| harness | governor a invocar |
|---|---|
| `010_discovery` | `discovery-governor` |
| `020_specification` | `specification-governor` |
| `030_design` | `design-governor` |
| `040_planning` | `planning-governor` |

### 6. Confirmar e invocar el governor

Mostrar este mensaje exacto:

```
FORGE: Reanudando harness suspendido.

  Harness     : <harness>
  Modo        : <governor_mode>
  Contexto    : <context_note>

Instrucción  : <resume_instruction>
```

Luego invocar inmediatamente el governor correspondiente pasando este mensaje:

```
MODO: <governor_mode>
```

No agregues ningún texto después de invocar el agente. El governor tomará el control del flujo desde ese punto.

## Notas

- El governor invocado ejecutará E10-B (Continuación) y detectará el punto exacto de reanudación leyendo `harness-state.json` y `execution-state.json`.
- El campo `suspension` limpiado en el Paso 4 garantiza que E10-B no retorne `SUSPEND_DETECTED`.
- Si el usuario suspendió durante una entrevista de discovery, el governor detectará el marcador ⏸ en `010_discovery/dialogue_transcript.md` y retomará la entrevista desde ese punto.
