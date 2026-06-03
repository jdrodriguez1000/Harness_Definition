Suspende el harness activo de forma ordenada, persiste el estado de reanudación en harness-state.json y confirma al usuario.

## Cuándo ejecutar

Cuando el usuario necesita interrumpir el trabajo en curso en un proyecto FORGE. El comando persiste el estado exacto para que /forge-resume pueda retomar sin pérdida de contexto.

## Pasos

### 1. Obtener timestamp real

```powershell
(Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
```

### 2. Verificar que existe un harness activo

Leer `persistence/harness-state.json`.

- Si no existe o no es parseable: informar al usuario "No hay harness activo en este directorio. Verifica que estás en la carpeta correcta del proyecto." y detener.
- Si ya hay un harness en estado `"SUSPENDED"`: mostrar el contexto existente y preguntar si desea sobreescribir.
- Si existe y es válido: continuar.

### 3. Identificar el harness activo

Recorrer en orden descendente para encontrar el harness más reciente que no está `PHASE_COMPLETE`:

**Prioridad de búsqueda (de más reciente a más antiguo):**
1. Si existe `"040_planning"` y su `status != "PHASE_COMPLETE"` → harness activo: **040**, clave JSON: `"040_planning"`, phase_id: `"040_planning"`
2. Si existe `"030_design"` y su `status != "PHASE_COMPLETE"` → harness activo: **030**, clave JSON: `"030_design"`, phase_id: `"030_design"`
3. Si existe `"020_specification"` y su `status != "PHASE_COMPLETE"` → harness activo: **020**, clave JSON: `"020_specification"`, phase_id: `"020_specification"`
4. Si el campo raíz `status != "PHASE_COMPLETE"` → harness activo: **010**, clave JSON: raíz, phase_id: `"010_discovery"`

Si ningún harness está activo (todos son PHASE_COMPLETE): informar "Todos los harnesses del proyecto están completos. No hay estado que suspender." y detener.

### 4. Leer estado de ejecución

Leer `persistence/execution-state.json`.
Extraer: `last_checkpoint`, `status` del execution-state.

Si no existe `persistence/execution-state.json`: asumir `last_checkpoint: null` y `status: "PENDING"`.

### 5. Detectar worker activo y construir contexto

#### Caso especial — dialoguer en progreso (solo harness 010)

**Condición:** harness activo == 010 Y `last_checkpoint == null` Y existe `010_discovery/dialogue_transcript.md` Y el transcript NO contiene la línea `"Estado global: COMPLETO"`

Si se cumple esta condición:

1. Leer `010_discovery/dialogue_transcript.md`.
2. Identificar en el transcript: cuántas secciones de stakeholder aparecen (buscar marcadores de inicio de entrevista como `## Entrevista` o `## Stakeholder`), y si hay alguna ronda parcialmente completada.
3. Escribir marcador de suspensión AL FINAL del transcript (append):

```markdown

---
## ⏸ PUNTO DE SUSPENSIÓN — <timestamp>

**Estado al suspender:**
- Transcript incompleto — entrevista interrumpida antes de "Estado global: COMPLETO"
- Stakeholders con secciones en el transcript: ver secciones anteriores para detalle
- Nota: el dialoguer puede retomar desde este punto usando `/forge-resume`

**Para reanudar:** El governor reconocerá este marcador al retomar con `/forge-resume`.

---
```

4. Construir contexto:
   - `governor_mode`: `"EXECUTE"`
   - `context_note`: `"Harness 010 Discovery suspendido durante entrevista de discovery. Dialoguer en progreso con transcript incompleto (sin 'Estado global: COMPLETO')."`
   - `resume_instruction`: `"Retomar entrevista desde el punto de suspensión. Leer el marcador ⏸ al final de 010_discovery/dialogue_transcript.md para contexto. Reinvocar el governor con [MODO: EXECUTE] y dialoguer_complete: false."`

#### Caso general — inferir contexto desde estado

**Paso A — Aplicar tabla base:**

Usar la combinación de `status` del harness activo y `last_checkpoint` del execution-state:

| harness.status | last_checkpoint | execution.status | governor_mode | context_note | resume_instruction |
|---|---|---|---|---|---|
| `PENDING_CONTRACT` | — | — | `INIT` | Sprint Contract pendiente de aprobación del cliente | Invocar governor con [MODO: INIT] para presentar Sprint Contract al cliente |
| `ACTIVE` | `null` | `IN_PROGRESS` o `PENDING` | `EXECUTE` | Ejecución iniciada, primer worker no completado | Invocar governor con [MODO: EXECUTE] para continuar desde el inicio |
| `ACTIVE` | `CP-01` | `IN_PROGRESS` | `EXECUTE` | Primer worker completo, segundo worker pendiente | Invocar governor con [MODO: EXECUTE]; el orchestrator detectará el starting_point = CP-01 |
| `ACTIVE` | `CP-02` o posterior | `EXECUTION_COMPLETE` | `POST_CP03` | Workers completados, pendiente revisión CP-03 del cliente | Invocar governor con [MODO: POST_CP03] para presentar artefactos |
| `IN_REWORK` | — | — | `POST_CP03` | Rework en progreso tras revisión del cliente | Invocar governor con [MODO: POST_CP03] para continuar rework |

Si la combinación no coincide con ninguna fila: construir context_note descriptivo con los valores exactos leídos y resume_instruction genérica: "Invocar el governor con [MODO: INIT] para que E10-B detecte el estado correcto."

**Paso B — Verificar si CP-03 ya fue aprobado (override obligatorio):**

Después de aplicar la tabla, leer el campo `client_approval.CP-03_draft_review` del harness activo en `harness-state.json`.

Si `client_approval.CP-03_draft_review != null` → el cliente ya aprobó el draft. Sobreescribir:
- `governor_mode`: `POST_CP04`
- `context_note`: `"CP-03 aprobado por el cliente. Pendiente aprobación formal CP-04."`
- `resume_instruction`: `"Invocar governor con [MODO: POST_CP04] para proceder con la aprobación formal del cliente."`

Este override aplica independientemente de lo que haya inferido la tabla base.

### 6. Construir y escribir bloque de suspensión

Leer `persistence/harness-state.json` completo (para preservar todos los campos de harnesses anteriores).

Construir el bloque de suspensión:
```json
"suspension": {
  "timestamp": "<timestamp real del Paso 1>",
  "harness": "<phase_id del harness activo>",
  "governor_mode": "<governor_mode inferido>",
  "last_checkpoint": "<valor de execution-state.last_checkpoint, o null>",
  "context_note": "<context_note construido en Paso 5>",
  "resume_instruction": "<resume_instruction construido en Paso 5>"
}
```

**Para harness 010 (clave raíz):** actualizar el campo raíz `"status"` a `"SUSPENDED"` y agregar/reemplazar el campo raíz `"suspension"` con el bloque anterior.

**Para harnesses 020-040 (clave anidada):** actualizar `harness-state.json["<clave_JSON>"]["status"]` a `"SUSPENDED"` y agregar/reemplazar `harness-state.json["<clave_JSON>"]["suspension"]` con el bloque anterior.

**Regla crítica:** Escribir el archivo completo con TODOS los campos previos intactos. No eliminar ni modificar campos de harnesses anteriores.

### 7. Registrar evento en claude-progress.txt

```powershell
Add-Content -Path "persistence/claude-progress.txt" -Value "[SUSPENSIÓN] <timestamp> — Harness <phase_id> suspendido en modo <governor_mode>. Contexto: <context_note>" -Encoding utf8
```

### 8. Confirmar al usuario

```
FORGE: Harness suspendido correctamente.

  Harness     : <phase_id>
  Checkpoint  : <last_checkpoint o "antes del primer checkpoint">
  Modo activo : <governor_mode>
  Contexto    : <context_note>

Para reanudar en la próxima sesión, escribe /forge-continue.
```

## Notas

- Si `persistence/claude-progress.txt` no existe, crearlo antes de hacer el append.
- No invocar ningún governor ni agente — este comando opera directamente sobre los archivos de estado.
- El transcript del dialoguer conserva toda la información ya recopilada; el marcador de suspensión es informativo, no destructivo.
