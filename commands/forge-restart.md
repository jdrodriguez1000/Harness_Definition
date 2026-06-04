Retoma el harness activo del proyecto actual tras un reinicio de sesión.

## Cuándo ejecutar

Cuando el usuario escribe `/forge-restart` después de reiniciar Claude Code en un directorio de proyecto FORGE — ya sea tras el deploy de un nuevo harness o al retomar un harness en progreso.

## Pasos

### 1. Verificar directorio de proyecto

Leer `persistence/harness-state.json`.

- Si no existe: informar "No hay harness activo en este directorio. Verifica que estás en la carpeta correcta del proyecto." y detener.
- Si no es parseable: informar "persistence/harness-state.json está corrupto. Intervención manual requerida." y detener.

### 2. Determinar qué harness ejecutar

Evaluar el estado en este orden de prioridad:

**Prioridad 1a — Harness nuevo desplegado (post-transición):**

| Condición | Harness a iniciar |
|---|---|
| `handoff_020.status == "DEPLOYED"` Y `020_specification` no existe en el JSON | Ciclo 020 Specification |
| `handoff_030.status == "DEPLOYED"` Y `030_design` no existe en el JSON | Ciclo 030 Design |
| `handoff_040.status == "DEPLOYED"` Y `040_planning` no existe en el JSON | Ciclo 040 Planning |

**Prioridad 1b — Harness siguiente pendiente de deploy (PENDING_HANDOFF):**

Si ninguna condición de Prioridad 1a aplica, buscar el primer `handoff_0XX.status == "PENDING_HANDOFF"` en este orden: `handoff_040` → `handoff_030` → `handoff_020`.

Si se encuentra un `PENDING_HANDOFF`:

| handoff con PENDING_HANDOFF | Harness a desplegar | Governor a verificar |
|---|---|---|
| `handoff_020` | 020 | `.claude/agents/specification-governor.md` |
| `handoff_030` | 030 | `.claude/agents/design-governor.md` |
| `handoff_040` | 040 | `.claude/agents/planning-governor.md` |

Ejecutar este flujo:
1. Preguntar al usuario: "El harness anterior está completo pero el siguiente aún no fue desplegado. ¿Deseas desplegarlo ahora y continuar?"
2. Si sí:
   - Ejecutar: `& "$env:HARNESS_DEPLOY_SCRIPT" -Harness <N> -Destino (Get-Location).Path`
   - Verificar que el deploy tuvo éxito: `Test-Path "<governor-path>"`
   - Si la verificación pasa:
     - Actualizar `handoff_0XX.status = "DEPLOYED"` en `persistence/harness-state.json`
     - Notificar: "Deploy completado. Reinicia la sesión de Claude Code en este directorio y ejecuta /forge-restart para continuar."
     - Detener (el harness arrancará en el próximo reinicio).
   - Si la verificación falla:
     - Notificar: "El script de deploy no copió los agentes correctamente (<governor-path> no existe). El estado NO fue actualizado. Ejecuta manualmente: `& '$env:HARNESS_DEPLOY_SCRIPT' -Harness <N> -Destino '<ruta>'` y luego ejecuta /forge-restart."
     - Detener.
3. Si no:
   - Notificar: "Cuando quieras continuar, ejecuta /forge-restart."
   - Detener.

**Prioridad 2 — Harness activo en progreso:**

Buscar el primer harness con `status != "PHASE_COMPLETE"` en este orden: `040_planning` → `030_design` → `020_specification` → `010_discovery` (el más reciente primero).

**Sin caso aplicable:**
- Si todos los harnesses están en `PHASE_COMPLETE`: informar "Todos los harnesses activos están completos. No hay nada que reanudar." y detener.
- Si `harness-state.json` existe pero no contiene ningún harness conocido: informar "Estado inesperado en harness-state.json. Revisa el archivo manualmente." y detener.

### 3. Mapear harness a ciclo y governor

| Harness | Ciclo a leer | Governor |
|---|---|---|
| `010_discovery` | `.claude/workflows/ciclo_010_discovery.md` | `discovery-governor` |
| `020_specification` | `.claude/workflows/ciclo_020_specification.md` | `specification-governor` |
| `030_design` | `.claude/workflows/ciclo_030_design.md` | `design-governor` |
| `040_planning` | `.claude/workflows/ciclo_040_planning.md` | `planning-governor` |

### 4. Verificar disponibilidad del governor

Antes de ejecutar el ciclo, verificar que el archivo del governor existe en el directorio de trabajo:

| Harness | Archivo a verificar |
|---|---|
| `010_discovery` | `.claude/agents/discovery-governor.md` |
| `020_specification` | `.claude/agents/specification-governor.md` |
| `030_design` | `.claude/agents/design-governor.md` |
| `040_planning` | `.claude/agents/planning-governor.md` |

Si el archivo no existe: detener con este mensaje exacto y no continuar bajo ninguna circunstancia:
```
El agente <governor>.md no está disponible en .claude/agents/. El deploy del harness <N> puede no haberse completado correctamente. Ejecuta: & "$env:HARNESS_DEPLOY_SCRIPT" -Harness <N> -Destino "<ruta del proyecto>" y luego ejecuta /forge-restart nuevamente.
```

### 5. Confirmar y ejecutar

Mostrar este mensaje exacto:

```
FORGE: Reanudando sesión.

  Harness : <harness detectado>
  Estado  : <descripción del estado — "Iniciando nuevo harness" o "Continuando harness en progreso">
```

**OBLIGATORIO — secuencia exacta:**
1. Leer el archivo de ciclo completo (ruta de la tabla del Paso 3).
2. Ejecutar las instrucciones del ciclo comenzando por el Paso A, exactamente como están escritas en el archivo.
3. El Paso A del ciclo es quien invoca el governor — esa es la única invocación correcta.

**PROHIBIDO — ninguna de estas acciones está permitida:**
- NO usar el Agent tool para invocar el governor antes de leer el ciclo.
- NO invocar `Agent(subagent_type: '<governor-name>')` directamente desde forge-restart.
- NO ejecutar el protocolo del governor inline (leer su archivo .md y seguirlo fuera del ciclo).
- NO tomar ningún atajo que evite ejecutar el ciclo desde el Paso A.

## Notas

- Para harnesses en estado `DEPLOYED`: el ciclo arrancará el governor en `[MODO: INIT]`, que ejecutará E10-A (inicio limpio).
- Para harnesses en progreso: el ciclo arrancará el governor en `[MODO: INIT]`, que ejecutará E10-B (continuación) y detectará el punto exacto de reanudación.
- Si el harness está `SUSPENDED` (suspendido con `/forge-suspend`): usar `/forge-continue` en su lugar.
