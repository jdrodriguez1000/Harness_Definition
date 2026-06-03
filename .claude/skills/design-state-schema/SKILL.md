---
name: design-state-schema
description: Schema y formato de los dos archivos de estado del 030 Design Harness — persistence/harness-state.json (entrada "030_design", escrita por design-governor) y persistence/execution-state.json (orchestration_plan y checkpoints, escrito por design-orchestrator). Define la Single Writer Rule y las reglas de lectura/escritura para cada campo. Usar cuando design-orchestrator escribe persistence/execution-state.json o cuando design-governor lee o escribe la entrada 030 de persistence/harness-state.json.
user-invocable: false
agent: design-orchestrator
---

Los archivos de persistencia viven en la carpeta `persistence/` del directorio de trabajo del proyecto.

---

## Archivo 1 — persistence/harness-state.json (entrada "030_design")

**Path:** `persistence/harness-state.json`
**Escritor único (entrada 030):** design-governor (Instance A). Ningún otro agente escribe en este archivo.
**Lectores:** design-orchestrator (lee Sprint Contract al iniciar).

### Contexto: estructura multi-harness

`harness-state.json` fue creado por el 010 y extendido por el 020. Contiene entradas de los
harnesses anteriores con sus campos raíz (`"phase"`, `"status"`, `"sprint_contract"`, etc.)
pertenecientes al 010 Discovery, y la clave `"020_specification"` del 020.

El design-governor **no modifica los campos raíz del 010 ni la clave `"020_specification"`**.
En cambio, agrega/actualiza una clave de primer nivel `"030_design"` con toda la información
del 030.

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
    "status": "PHASE_COMPLETE",
    "...campos del 020..."
  },

  "030_design": {
    "mode": "INICIO | CONTINUACIÓN",
    "sprint_contract": {
      "objective": "Transformar los contratos formales del 020 en un plano arquitectónico técnico",
      "inputs": {
        "I1": "<path a 020_specification/bdd_features.md>",
        "I2": "<path a 020_specification/data_contracts.md>",
        "I3": "<path a 020_specification/acceptance_criteria.md>",
        "I4": "<path a 020_specification/error_exception_policy.md>",
        "I5": "<path a 010_discovery/shared_understanding.md>",
        "I6": "<path a 010_discovery/domain_glossary.md>",
        "I7": "<path a 010_discovery/scope_boundaries.md>",
        "I8": "<path a 010_discovery/failure_behavior.md>"
      },
      "tech_constraints": "<restricciones tecnológicas extraídas de scope_boundaries.md>",
      "workers": ["design-analyst", "design-architect"],
      "checkpoints": ["CP-01", "CP-02", "CP-03", "CP-04"],
      "done_criteria": [
        "ADR-001 documenta el stack con contexto, opciones evaluadas y justificación",
        "Todos los bounded contexts del 020 tienen ≥1 módulo en technical_blueprint.md",
        "Todas las entidades del 020 tienen interface + DTOs en contract_definitions.md",
        "Cada interface tiene estrategia de mock/stub en test_strategy_map.md",
        "Aprobación explícita del cliente en CP-04"
      ]
    },
    "status": "PENDING_CONTRACT | ACTIVE | AUDIT_PENDING | IN_REWORK | HOLD | SUSPENDED | PHASE_COMPLETE",
    "client_approval": {
      "CP-03_draft_review": null,
      "CP-04_formal_approval": null
    },
    "escalations": [],
    "overrides": [],
    "handoff_040": null,
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
  "harness": "030_design",
  "texto": "<texto del override tal como lo escribió el usuario>",
  "status": "ACTIVE"
}
```
- El campo `"overrides"` es escrito por el comando `/forge-override` (no por el governor).
- El governor solo lo lee (en E10-A.8) para incorporar los constraints duros al Sprint Contract.
- `"status": "ACTIVE"` indica que la restricción está vigente. No se cambia a otro valor en la implementación actual.

El campo `suspension` es `null` cuando el harness no está suspendido. Cuando `/forge-suspend` es invocado, el governor escribe el bloque completo:
```json
"suspension": {
  "timestamp": "<ISO 8601>",
  "harness": "030_design",
  "governor_mode": "INIT | EXECUTE | POST_CP03 | POST_CP04",
  "last_checkpoint": "null | CP-01 | CP-02",
  "context_note": "<descripción libre del estado al momento de suspender>",
  "resume_instruction": "<qué hacer al reanudar>"
}
```

**Valores de `"030_design".status`:**
- `PENDING_CONTRACT` — estado inicial tras E10-A; Sprint Contract aún no aprobado por el cliente
- `ACTIVE` — Sprint Contract aprobado; ejecución en curso
- `AUDIT_PENDING` — CP-04 recibido; design-evaluator aún no ha corrido
- `IN_REWORK` — rechazo técnico de C; design-governor re-spawnea el Worker fallido
- `HOLD` — rechazo estratégico; requiere nueva aprobación humana antes de continuar
- `SUSPENDED` — harness suspendido por `/forge-suspend`; esperando `/forge-resume` para continuar
- `PHASE_COMPLETE` — C emitió APPROVED y design-governor cerró la fase; activa handoff al 040

**Reglas de lectura para design-orchestrator:**
- Leer `harness_state["020_specification"]["status"]` para verificar que el 020 tiene `"PHASE_COMPLETE"`.
- Leer `harness_state["030_design"]["sprint_contract"]["inputs"]` para obtener I-1..I-8.
- Leer `harness_state["030_design"]["mode"]` para determinar si es INICIO o CONTINUACIÓN.
- Si `"030_design".status` no es `ACTIVE` o `IN_REWORK` → detener y reportar a governor. No orquestar en estado `PENDING_CONTRACT`, `HOLD`, `AUDIT_PENDING` o `PHASE_COMPLETE`.

---

## Archivo 2 — persistence/execution-state.json (030)

**Path:** `persistence/execution-state.json`
**Escritor único:** design-orchestrator. Ningún otro agente escribe este archivo.
**Lectores:** design-governor (lee checkpoints y artifacts al decidir gate).

```json
{
  "orchestration_plan": {
    "phase": "030_design",
    "sequence": [
      "design-analyst",
      "design-architect"
    ],
    "inputs": {
      "I1": "<path a 020_specification/bdd_features.md o null>",
      "I2": "<path a 020_specification/data_contracts.md o null>",
      "I3": "<path a 020_specification/acceptance_criteria.md o null>",
      "I4": "<path a 020_specification/error_exception_policy.md o null>",
      "I5": "<path a 010_discovery/shared_understanding.md o null>",
      "I6": "<path a 010_discovery/domain_glossary.md o null>",
      "I7": "<path a 010_discovery/scope_boundaries.md o null>",
      "I8": "<path a 010_discovery/failure_behavior.md o null>"
    },
    "demo_statements": {
      "design-analyst": "Cuando design-analyst termine, podré observar que 030_design/design_analysis_report.md existe y contiene: ≥1 componente (CO-xx) por bounded context identificado en bdd_features.md; ≥1 interface requerida (IC-xx) por entidad en data_contracts.md; ≥1 patrón de diseño (PT-xx) con justificación; ≥1 restricción tecnológica (RT-xx) derivada de scope_boundaries.md.",
      "design-architect": "Cuando design-architect termine, podré observar que: technical_blueprint.md define la estructura de capas y ≥1 módulo (MOD-xx) por bounded context; contract_definitions.md tiene ≥1 interface (IC-xx) por entidad de data_contracts.md; dependency_graph.md describe la estrategia de inyección de dependencias; architecture_decision_records.md incluye ADR-001 (stack) con opciones evaluadas y justificación; test_strategy_map.md cubre cada IC-xx con su estrategia de mock/stub."
    },
    "starting_point": "null | CP-01 | COMPLETE"
  },
  "last_checkpoint": null,
  "status": "IN_PROGRESS | EXECUTION_COMPLETE | WORKER_FAILED",
  "analysis_path": null,
  "artifacts": {
    "technical_blueprint": null,
    "contract_definitions": null,
    "dependency_graph": null,
    "architecture_decision_records": null,
    "test_strategy_map": null
  },
  "worker_errors": [],
  "last_updated": "<timestamp ISO 8601>"
}
```

**Valores de `last_checkpoint`:**
- `null` — antes de iniciar (orchestration_plan persistido pero ningún Worker ha terminado)
- `"CP-01"` — design-analyst completado y verificado en disco; `analysis_path` tiene el path
- `"CP-02"` — design-architect completado y verificado en disco; `artifacts` tiene los 5 paths; `status` pasa a `EXECUTION_COMPLETE`

**Campo `starting_point` en orchestration_plan:**
- `"null"` — arranque desde cero; A debe spawear design-analyst primero
- `"CP-01"` — design-analyst ya completado; A debe spawear design-architect directamente
- `"COMPLETE"` — ambos Workers completados; A debe ir a CP-03

**Estructura de `worker_errors` (cuando `status: WORKER_FAILED`):**
```json
"worker_errors": [
  {
    "worker": "design-analyst | design-architect",
    "checkpoint_at_failure": "null | CP-01",
    "error": "<descripción del error — INCOMPLETO reportado por Worker o artefacto ausente en disco>"
  }
]
```

---

## Estructura mínima inicial — persistence/execution-state.json

**Responsable de creación:** design-governor en E10-A Paso 4.
**Regla:** governor crea el archivo con estructura mínima; orchestrator escribe `orchestration_plan`
y checkpoints sobre ese archivo ya existente. Si orchestrator llega y no existe (escenario de
fallo), crea la estructura mínima como fallback antes de escribir su `orchestration_plan`.

```json
{
  "orchestration_plan": null,
  "last_checkpoint": null,
  "status": "PENDING",
  "analysis_path": null,
  "artifacts": {
    "technical_blueprint": null,
    "contract_definitions": null,
    "dependency_graph": null,
    "architecture_decision_records": null,
    "test_strategy_map": null
  },
  "worker_errors": [],
  "last_updated": "<timestamp ISO 8601>"
}
```

---

## Single Writer Rule

| Archivo | Escritor | Lectores |
|---------|----------|----------|
| `persistence/harness-state.json` (entrada "030_design") | design-governor únicamente | design-orchestrator |
| `persistence/execution-state.json` | design-orchestrator únicamente | design-governor |

Ningún Worker (design-analyst, design-architect, design-evaluator) escribe ninguno de estos
archivos. Los Workers solo reportan paths a quien los spawnea.

---

## Reglas de escritura para design-orchestrator

1. **Persistir orchestration_plan completo antes de que el governor spawee cualquier Worker** (E12). Si falla la escritura, detener el flujo y reportar al governor.
2. **Actualizar `last_checkpoint` inmediatamente** tras recibir CHECKPOINT_OK del governor (post-verificación en disco). No esperar al siguiente paso.
3. **Nunca reescribir campos ya completados.** Al reanudar, conservar `analysis_path` ya registrado — solo completar los campos faltantes.
4. **Actualizar `last_updated`** en cada escritura con timestamp ISO 8601.
5. **El campo `worker_errors` lo escribe B** al registrar CHECKPOINT_FAILED. No lo escriben los Workers.
