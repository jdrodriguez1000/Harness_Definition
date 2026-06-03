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

**Prioridad 1 — Harness nuevo desplegado (post-transición):**

| Condición | Harness a iniciar |
|---|---|
| `handoff_020.status == "DEPLOYED"` Y `020_specification` no existe en el JSON | Ciclo 020 Specification |
| `handoff_030.status == "DEPLOYED"` Y `030_design` no existe en el JSON | Ciclo 030 Design |
| `handoff_040.status == "DEPLOYED"` Y `040_planning` no existe en el JSON | Ciclo 040 Planning |

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

### 4. Confirmar y ejecutar

Mostrar este mensaje exacto:

```
FORGE: Reanudando sesión.

  Harness : <harness detectado>
  Estado  : <descripción del estado — "Iniciando nuevo harness" o "Continuando harness en progreso">
```

Leer el archivo de ciclo correspondiente y ejecutarlo desde el Paso A. No spawear el governor directamente — el ciclo es el punto de entrada correcto.

## Notas

- Para harnesses en estado `DEPLOYED`: el ciclo arrancará el governor en `[MODO: INIT]`, que ejecutará E10-A (inicio limpio).
- Para harnesses en progreso: el ciclo arrancará el governor en `[MODO: INIT]`, que ejecutará E10-B (continuación) y detectará el punto exacto de reanudación.
- Si el harness está `SUSPENDED` (suspendido con `/forge-suspend`): usar `/forge-continue` en su lugar.
