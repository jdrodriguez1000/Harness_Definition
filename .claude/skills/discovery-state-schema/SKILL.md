---
name: discovery-state-schema
description: Schema y formato de los dos archivos de estado del 010 Discovery Harness — persistence/harness-state.json (Sprint Contract, escrito por discovery-governor) y persistence/execution-state.json (orchestration_plan y checkpoints, escrito por discovery-orchestrator). Define la Single Writer Rule y las reglas de lectura/escritura para cada campo. Usar cuando discovery-orchestrator escribe persistence/execution-state.json o cuando discovery-governor lee o escribe persistence/harness-state.json.
user-invocable: false
agent: discovery-orchestrator
---

Los tres archivos de persistencia viven en la carpeta `persistence/` del directorio de trabajo del proyecto. Crearlos si no existen.

---

## Archivo 1 — persistence/harness-state.json

**Path:** `persistence/harness-state.json`
**Escritor único:** discovery-governor (Instance A). Ningún otro agente escribe este archivo.
**Lectores:** discovery-orchestrator (lee Sprint Contract al iniciar).

```json
{
  "phase": "010_discovery",
  "mode": "INICIO | CONTINUACIÓN",
  "sprint_contract": {
    "objective": "Capturar intención pura del cliente y producir los 4 artefactos de Discovery",
    "inputs": {
      "I1": "<path o descripción del brief inicial>",
      "I2": "<path o descripción del contexto de negocio>",
      "I3": "<lista de restricciones conocidas>"
    },
    "workers": [
      "discovery-dialoguer",
      "discovery-analyst",
      "discovery-synthesizer"
    ],
    "checkpoints": ["CP-01", "CP-02", "CP-03", "CP-04"],
    "done_criteria": [
      "aprobación explícita del cliente en Shared Understanding Document",
      "sin contradicciones nuevas en 2 rondas consecutivas",
      "todos los actores con ≥1 objetivo de valor",
      "≥1 respuesta sobre comportamiento ante fallos"
    ]
  },
  "status": "ACTIVE | IN_REWORK | HOLD | PHASE_COMPLETE",
  "client_approval": {
    "CP-03_draft_review": null,
    "CP-04_formal_approval": null
  },
  "escalations": [],
  "overrides": [],
  "last_updated": "<timestamp ISO 8601>",
  "suspension": null
}
```

El campo `"overrides"` es un array de objetos. Cada objeto representa un override registrado por el usuario vía `/forge-override`. Estructura de cada elemento:
```json
{
  "id": "OV-001",
  "timestamp": "<ISO 8601>",
  "harness": "010_discovery",
  "texto": "<texto del override tal como lo escribió el usuario>",
  "status": "ACTIVE"
}
```
- El campo `"overrides"` es escrito por el comando `/forge-override` (no por el governor).
- El governor solo lo lee (en E10-A.7) para incorporar los constraints duros al Sprint Contract.

El campo `suspension` es `null` cuando el harness no está suspendido. Cuando `/forge-suspend` es invocado, el governor escribe el bloque completo:
```json
"suspension": {
  "timestamp": "<ISO 8601>",
  "harness": "010_discovery",
  "governor_mode": "INIT | EXECUTE | POST_CP03 | POST_CP04",
  "last_checkpoint": "null | CP-01 | CP-02 | CP-03",
  "context_note": "<descripción libre del estado al momento de suspender>",
  "resume_instruction": "<qué hacer al reanudar — instrucción para E10-B o para el workflow>"
}
```

**Valores de `status`:**
- `ACTIVE` — ejecución en curso (estado inicial tras aprobación del Sprint Contract)
- `IN_REWORK` — rechazo técnico de C; discovery-governor re-spawnea discovery-orchestrator
- `HOLD` — rechazo estratégico; requiere nueva aprobación humana antes de continuar
- `SUSPENDED` — harness suspendido por `/forge-suspend`; esperando `/forge-resume` para continuar
- `PHASE_COMPLETE` — C emitió APPROVED y discovery-governor cerró la fase; activa handoff al 020

**Reglas de lectura para discovery-orchestrator:**
- Leer `sprint_contract.inputs` para obtener I-1, I-2, I-3 antes de persistir orchestration_plan.
- Leer `mode` para determinar si es INICIO o CONTINUACIÓN.
- Si `status` no es `ACTIVE` o `IN_REWORK` → detener y reportar a governor. No orquestar en estado HOLD o PHASE_COMPLETE.

---

## Archivo 2 — persistence/execution-state.json

**Path:** `persistence/execution-state.json`
**Escritor único:** discovery-orchestrator. Ningún otro agente escribe este archivo.
**Lectores:** discovery-governor (lee checkpoints y artifacts al decidir gate).

```json
{
  "orchestration_plan": {
    "phase": "010_discovery",
    "sequence": [
      "discovery-dialoguer",
      "discovery-analyst",
      "discovery-synthesizer"
    ],
    "inputs": {
      "I1": "<valor copiado de persistence/harness-state.json>",
      "I2": "<valor copiado de persistence/harness-state.json>",
      "I3": "<valor copiado de persistence/harness-state.json>"
    }
  },
  "last_checkpoint": null,
  "status": "IN_PROGRESS | EXECUTION_COMPLETE | WORKER_FAILED",
  "transcript_path": null,
  "analysis_path": null,
  "artifacts": {
    "shared_understanding": null,
    "scope_boundaries": null,
    "domain_glossary": null,
    "failure_behavior": null
  },
  "worker_errors": [],
  "last_updated": "<timestamp ISO 8601>"
}
```

**Valores de `last_checkpoint`:**
- `null` — antes de iniciar (orchestration_plan persistido pero ningún Worker ha terminado)
- `"CP-01"` — discovery-dialoguer completado; `transcript_path` tiene el path
- `"CP-02"` — discovery-analyst completado; `analysis_path` tiene el path
- `"CP-03"` — discovery-synthesizer completado; `artifacts` tiene los 4 paths; `status` pasa a `EXECUTION_COMPLETE`

**Estructura de `worker_errors` (cuando `status: WORKER_FAILED`):**
```json
"worker_errors": [
  {
    "worker": "discovery-dialoguer | discovery-analyst | discovery-synthesizer",
    "checkpoint_at_failure": "null | CP-01 | CP-02",
    "error": "<descripción del error>"
  }
]
```

---

---

## Archivo 3 — persistence/claude-progress.txt

**Path:** `persistence/claude-progress.txt`
**Escritor único:** discovery-governor. Ningún otro agente escribe este archivo.
**Lectores:** discovery-governor (lectura en E10-B Paso 3 para orientarse).

**Formato de línea (una entrada por evento):**
```
[TIPO_EVENTO] [timestamp ISO 8601] — <descripción libre del evento>
```

**Tipos de evento válidos:**

| Tipo | Momento |
|------|---------|
| `INICIO` | discovery-governor arranca E10-A (Modo INICIO) |
| `E10-A COMPLETO` | Ritual de inicio completado; carpetas, archivos y git listos |
| `E10-B REANUDACIÓN` | Ritual de continuación completado; estado reconstituido |
| `SPRINT_CONTRACT_APROBADO` | Cliente aprobó el Sprint Contract; ejecución autorizada |
| `CP-01` | discovery-dialoguer completó el transcript |
| `CP-02` | discovery-analyst completó el analysis report (listo para síntesis) |
| `CP-03` | discovery-synthesizer completó los 4 artefactos; draft presentado al cliente |
| `CP-04` | Cliente aprobó formalmente el Shared Understanding Document |
| `CONTEXT_RESET` | discovery-dialoguer emitió señal de reset; reanudando vía E10-B |
| `RECHAZO TÉCNICO` | discovery-evaluator emitió REJECTED por razones técnicas |
| `RECHAZO ESTRATÉGICO` | discovery-evaluator emitió REJECTED por razones estratégicas |
| `CANCELADO` | Humano canceló el harness en gate del Sprint Contract |
| `SUSPENSIÓN` | `/forge-suspend` fue invocado; estado de ejecución persistido en harness-state.json |
| `CIERRE` | Fase 010 Discovery COMPLETA; artefactos listos para 020 |

**Reglas:**
- Una línea por evento. Solo el timestamp varía; el formato es fijo.
- Regla append-only: nunca modificar ni eliminar entradas anteriores. Solo agregar al final.
- No usar este archivo para logs de depuración ni mensajes intermedios de Workers.

---

## Creación inicial — persistence/execution-state.json

**Responsable:** discovery-governor en E10-A Paso 3.
**Regla:** governor crea el archivo con estructura mínima; orchestrator escribe `orchestration_plan` y checkpoints sobre ese archivo ya existente. Si orchestrator llega y no existe (escenario de fallo), crea la estructura mínima como fallback antes de escribir su `orchestration_plan`.

Estructura mínima inicial (escrita por governor):
```json
{
  "orchestration_plan": null,
  "last_checkpoint": null,
  "status": "PENDING",
  "transcript_path": null,
  "analysis_path": null,
  "artifacts": {
    "shared_understanding": null,
    "scope_boundaries": null,
    "domain_glossary": null,
    "failure_behavior": null
  },
  "worker_errors": [],
  "last_updated": "<timestamp ISO 8601>"
}
```

---

## Single Writer Rule

| Archivo | Escritor | Lectores |
|---------|----------|----------|
| `persistence/harness-state.json` | discovery-governor únicamente | discovery-orchestrator |
| `persistence/execution-state.json` | discovery-orchestrator únicamente | discovery-governor |

Ningún Worker (discovery-dialoguer, discovery-analyst, discovery-synthesizer, discovery-evaluator) escribe ninguno de estos archivos. Los Workers solo reportan paths a quien los spawnea.

---

## Reglas de escritura para discovery-orchestrator

1. **Persistir orchestration_plan completo antes de spawear cualquier Worker** (E12). Si falla la escritura, detener el flujo.
2. **Actualizar `last_checkpoint` inmediatamente** al recibir confirmación de un Worker. No esperar al siguiente paso.
3. **Nunca reescribir campos ya completados.** Al reanudar, conservar `transcript_path` y `analysis_path` ya registrados — solo completar los campos faltantes.
4. **Actualizar `last_updated`** en cada escritura con timestamp ISO 8601.
