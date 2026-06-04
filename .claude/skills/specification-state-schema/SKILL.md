---
name: specification-state-schema
description: Schema y formato de los dos archivos de estado del 020 Specification Harness — persistence/harness-state.json (entrada "020_specification", escrita por specification-governor) y persistence/execution-state.json (orchestration_plan y checkpoints, escrito por specification-orchestrator). Define la Single Writer Rule y las reglas de lectura/escritura para cada campo. Usar cuando specification-orchestrator escribe persistence/execution-state.json o cuando specification-governor lee o escribe la entrada 020 de persistence/harness-state.json.
user-invocable: false
agent: specification-orchestrator
---

Los archivos de persistencia viven en la carpeta `persistence/` del directorio de trabajo del proyecto.

---

## Archivo 1 — persistence/harness-state.json (entrada "020_specification")

**Path:** `persistence/harness-state.json`
**Escritor único (entrada 020):** specification-governor (Instance A). Ningún otro agente escribe en este archivo.
**Lectores:** specification-orchestrator (lee Sprint Contract al iniciar).

### Contexto: estructura multi-harness

`harness-state.json` fue creado por el 010. En su formato original (plano), los campos raíz
(`"phase"`, `"status"`, `"sprint_contract"`, etc.) pertenecen al 010 Discovery.

El specification-governor **no modifica los campos raíz del 010**. En cambio, agrega/actualiza
una clave de primer nivel `"020_specification"` con toda la información del 020.

**Ejemplo de archivo extendido:**

```json
{
  "phase": "010_discovery",
  "status": "PHASE_COMPLETE",
  "sprint_contract": { "...campos del 010..." },
  "client_approval": { "...del 010..." },
  "escalations": [],
  "last_updated": "<timestamp del 010>",

  "020_specification": {
    "mode": "INICIO | CONTINUACIÓN",
    "sprint_contract": {
      "objective": "Transformar los artefactos del Discovery en contratos formales de comportamiento y datos",
      "inputs": {
        "I1": "<path a 010_discovery/shared_understanding.md>",
        "I2": "<path a 010_discovery/domain_glossary.md>",
        "I3": "<path a 010_discovery/scope_boundaries.md>",
        "I4": "<path a 010_discovery/failure_behavior.md>"
      },
      "pending_resolutions": [
        {
          "item_id": "<id del ítem PENDIENTE del failure_behavior.md>",
          "description": "<texto del ítem>",
          "resolution": "<respuesta del cliente>"
        }
      ],
      "workers": ["specification-analyst", "specification-writer"],
      "checkpoints": ["CP-01", "CP-02", "CP-03", "CP-04"],
      "done_criteria": [
        "Todos los actores del 010 tienen ≥1 escenario BDD de camino feliz",
        "Todos los ítems PENDIENTE del failure_behavior.md tienen política definida",
        "Sin contradicciones entre artefactos",
        "Aprobación explícita del cliente en CP-04"
      ]
    },
    "status": "ACTIVE | IN_REWORK | HOLD | SUSPENDED | PHASE_COMPLETE",
    "client_approval": {
      "CP-03_draft_review": null,
      "CP-04_formal_approval": null
    },
    "escalations": [],
    "overrides": [],
    "last_updated": "<timestamp ISO 8601>",
    "suspension": null
  }
}
```

El campo `"overrides"` es un array de objetos. Cada objeto representa un override registrado por el usuario vía `/forge-override`. Estructura de cada elemento:
```json
{
  "id": "OV-001",
  "timestamp": "<ISO 8601>",
  "harness": "020_specification",
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
  "harness": "020_specification",
  "governor_mode": "INIT | EXECUTE | POST_CP03 | POST_CP04",
  "last_checkpoint": "null | CP-01 | CP-02",
  "context_note": "<descripción libre del estado al momento de suspender>",
  "resume_instruction": "<qué hacer al reanudar>"
}
```

**Valores de `"020_specification".status`:**
- `ACTIVE` — ejecución en curso (estado inicial tras aprobación del Sprint Contract)
- `IN_REWORK` — rechazo técnico de C; specification-governor re-spawnea specification-orchestrator
- `HOLD` — rechazo estratégico; requiere nueva aprobación humana antes de continuar
- `SUSPENDED` — harness suspendido por `/forge-suspend`; esperando `/forge-resume` para continuar
- `PHASE_COMPLETE` — C emitió APPROVED y specification-governor cerró la fase; activa handoff al 030

**Reglas de lectura para specification-orchestrator:**
- Leer `harness_state["status"]` (raíz) para verificar que el 010 tiene `"PHASE_COMPLETE"`.
- Leer `harness_state["020_specification"]["sprint_contract"]["inputs"]` para obtener I-1, I-2, I-3, I-4.
- Leer `harness_state["020_specification"]["sprint_contract"]["pending_resolutions"]` para resoluciones de ítems PENDIENTE.
- Leer `harness_state["020_specification"]["mode"]` para determinar si es INICIO o CONTINUACIÓN.
- Si `"020_specification".status` no es `ACTIVE` o `IN_REWORK` → detener y reportar a governor. No orquestar en estado HOLD o PHASE_COMPLETE.

---

## Archivo 2 — persistence/execution-state.json (020)

**Path:** `persistence/execution-state.json`
**Escritor único:** specification-orchestrator. Ningún otro agente escribe este archivo.
**Lectores:** specification-governor (lee checkpoints y artifacts al decidir gate).

```json
{
  "orchestration_plan": {
    "phase": "020_specification",
    "sequence": [
      "specification-analyst",
      "specification-writer"
    ],
    "inputs": {
      "I1": "<path a 010_discovery/shared_understanding.md o null>",
      "I2": "<path a 010_discovery/domain_glossary.md o null>",
      "I3": "<path a 010_discovery/scope_boundaries.md o null>",
      "I4": "<path a 010_discovery/failure_behavior.md o null>"
    },
    "pending_resolutions_available": true
  },
  "last_checkpoint": null,
  "status": "IN_PROGRESS | EXECUTION_COMPLETE | WORKER_FAILED",
  "analysis_path": null,
  "early_eval": null,
  "artifacts": {
    "bdd_features": null,
    "data_contracts": null,
    "acceptance_criteria": null,
    "error_exception_policy": null
  },
  "worker_errors": [],
  "last_updated": "<timestamp ISO 8601>"
}
```

**Valores de `last_checkpoint`:**
- `null` — antes de iniciar (orchestration_plan persistido pero ningún Worker ha terminado)
- `"CP-01"` — specification-analyst completado; `analysis_path` tiene el path
- `"CP-02"` — specification-writer completado; `artifacts` tiene los 4 paths; `status` pasa a `EXECUTION_COMPLETE`

**Estructura de `early_eval` (escrita por B tras recibir resultado de C):**
```json
"early_eval": {
  "evaluated_at": "<timestamp ISO 8601>",
  "score": 0.0,
  "passed": false,
  "notes": "<razón breve del score — solo para diagnóstico interno>"
}
```
- `passed: true` cuando `score >= 0.7`.
- Este campo NO genera `eval/verdict.json` — es una señal interna de calidad.

**Estructura de `worker_errors` (cuando `status: WORKER_FAILED`):**
```json
"worker_errors": [
  {
    "worker": "specification-analyst | specification-writer",
    "checkpoint_at_failure": "null | CP-01",
    "error": "<descripción del error>"
  }
]
```

---

## Estructura mínima inicial — persistence/execution-state.json

**Responsable de creación:** specification-governor en E10-A Paso 4.
**Regla:** governor crea el archivo con estructura mínima; orchestrator escribe `orchestration_plan` y checkpoints sobre ese archivo ya existente. Si orchestrator llega y no existe (escenario de fallo), crea la estructura mínima como fallback antes de escribir su `orchestration_plan`.

```json
{
  "orchestration_plan": null,
  "last_checkpoint": null,
  "status": "PENDING",
  "analysis_path": null,
  "early_eval": null,
  "artifacts": {
    "bdd_features": null,
    "data_contracts": null,
    "acceptance_criteria": null,
    "error_exception_policy": null
  },
  "worker_errors": [],
  "last_updated": "<timestamp ISO 8601>"
}
```

---

## Single Writer Rule

| Archivo | Escritor | Lectores |
|---------|----------|----------|
| `persistence/harness-state.json` (entrada "020_specification") | specification-governor únicamente | specification-orchestrator |
| `persistence/execution-state.json` | specification-orchestrator únicamente | specification-governor |
| `contract/020_specification.md` | specification-governor únicamente | humanos (lectura) |

Ningún Worker (specification-analyst, specification-writer, specification-evaluator) escribe ninguno de estos archivos. Los Workers solo reportan paths a quien los spawnea.

`contract/020_specification.md` es una copia legible del Sprint Contract aprobado, escrita por el governor en el Paso 1 de EXECUTE. No es un archivo de estado — no se lee programáticamente. La carpeta `contract/` la crea el governor si no existe.

---

## Reglas de escritura para specification-orchestrator

1. **Persistir orchestration_plan completo antes de spawear cualquier Worker** (E12). Si falla la escritura, detener el flujo.
2. **Actualizar `last_checkpoint` inmediatamente** al recibir confirmación de un Worker. No esperar al siguiente paso.
3. **Nunca reescribir campos ya completados.** Al reanudar, conservar `analysis_path` ya registrado — solo completar los campos faltantes.
4. **Actualizar `last_updated`** en cada escritura con timestamp ISO 8601.
5. **El campo `early_eval` lo escribe B** (no C) después de recibir el resultado de C inline. C no escribe en este archivo.
