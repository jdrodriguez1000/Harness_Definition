---
name: planning-state-schema
description: Schema y formato de los dos archivos de estado del 040 Planning Harness — persistence/harness-state.json (entrada "040_planning", escrita por planning-governor) y persistence/execution-state.json (orchestration_plan y checkpoints, escrito por planning-orchestrator). Define la Single Writer Rule y las reglas de lectura/escritura para cada campo. Usar cuando planning-orchestrator escribe persistence/execution-state.json o cuando planning-governor lee o escribe la entrada 040 de persistence/harness-state.json.
user-invocable: false
agent: planning-orchestrator
---

Los archivos de persistencia viven en la carpeta `persistence/` del directorio de trabajo del proyecto.

---

## Archivo 1 — persistence/harness-state.json (entrada "040_planning")

**Path:** `persistence/harness-state.json`
**Escritor único (entrada 040):** planning-governor (Instancia A). Ningún otro agente escribe en este archivo.
**Lectores:** planning-orchestrator (lee Sprint Contract al iniciar).

### Contexto: estructura multi-harness

`harness-state.json` fue creado por el 010 y extendido por el 020 y el 030. Contiene entradas de los
harnesses anteriores (`"phase"`, `"status"`, `"sprint_contract"` raíz del 010; `"020_specification"`;
`"030_design"`).

El planning-governor **no modifica ningún campo raíz del 010 ni las claves `"020_specification"` ni
`"030_design"`**. En cambio, agrega/actualiza una clave de primer nivel `"040_planning"` con toda
la información del 040.

**Ejemplo de archivo extendido:**

```json
{
  "phase": "010_discovery",
  "status": "PHASE_COMPLETE",
  "sprint_contract": { "...campos del 010..." },
  "020_specification": { "status": "PHASE_COMPLETE", "...campos del 020..." },
  "030_design": { "status": "PHASE_COMPLETE", "...campos del 030..." },

  "040_planning": {
    "mode": "INICIO | CONTINUACIÓN",
    "sprint_contract": {
      "objective": "Tomar el draft de Vertical Slices del 030 y producir el plan maestro completo del proyecto",
      "inputs": {
        "I1":  "<path a design/test_strategy_map.md>",
        "I2":  "<path a design/architecture_decision_records.md>",
        "I3":  "<path a design/technical_blueprint.md>",
        "I4":  "<path a design/contract_definitions.md>",
        "I5":  "<path a design/dependency_graph.md>",
        "I6":  "<path a specification/bdd_features.md>",
        "I7":  "<path a specification/data_contracts.md>",
        "I8":  "<path a specification/acceptance_criteria.md>",
        "I9":  "<path a specification/error_exception_policy.md>",
        "I10": "<path a discovery/shared_understanding.md>",
        "I11": "<path a discovery/scope_boundaries.md>",
        "I12": "<path a discovery/domain_glossary.md>"
      },
      "vs_draft_summary": "<lista de VS-xx extraídas del draft del 030 con sus tipos>",
      "workers": ["planning-analyst", "planning-writer"],
      "checkpoints": ["CP-01", "CP-02", "CP-03", "CP-04"],
      "done_criteria": [
        "Todas las VS-xx del draft validadas: sobredimensionadas divididas",
        "Todos los IC-xx de contract_definitions.md asignados a ≥1 slice",
        "Todos los BDD scenarios de bdd_features.md asignados a ≥1 slice",
        "project_roadmap.md respeta TB→Crecimiento→MVP→Evolución→Robustez sin dependencias circulares",
        "risk_register.md con ≥1 RK-xx por slice con probabilidad, impacto y mitigación",
        "Aprobación explícita del cliente en CP-04"
      ]
    },
    "status": "PENDING_CONTRACT | ACTIVE | AUDIT_PENDING | IN_REWORK | HOLD | PHASE_COMPLETE",
    "client_approval": {
      "CP-03_draft_review": null,
      "CP-04_formal_approval": null
    },
    "escalations": [],
    "handoff_050": null,
    "last_updated": "<timestamp ISO 8601>"
  }
}
```

**Valores de `"040_planning".status`:**
- `PENDING_CONTRACT` — estado inicial tras E10-A; Sprint Contract aún no aprobado por el cliente
- `ACTIVE` — Sprint Contract aprobado; ejecución en curso
- `AUDIT_PENDING` — CP-04 recibido; planning-evaluator aún no ha corrido
- `IN_REWORK` — rechazo técnico de C; planning-governor re-spawnea el Worker fallido
- `HOLD` — rechazo estratégico; requiere nueva aprobación humana antes de continuar
- `PHASE_COMPLETE` — C emitió APPROVED y planning-governor cerró la fase; activa handoff al 050

**Reglas de lectura para planning-orchestrator:**
- Leer `harness_state["030_design"]["status"]` para verificar que el 030 tiene `"PHASE_COMPLETE"`.
- Leer `harness_state["040_planning"]["sprint_contract"]["inputs"]` para obtener I-1..I-12.
- Leer `harness_state["040_planning"]["mode"]` para determinar si es INICIO o CONTINUACIÓN.
- Si `"040_planning".status` no es `ACTIVE` o `IN_REWORK` → detener y reportar a governor. No orquestar en estado `PENDING_CONTRACT`, `HOLD`, `AUDIT_PENDING` o `PHASE_COMPLETE`.

---

## Archivo 2 — persistence/execution-state.json (040)

**Path:** `persistence/execution-state.json`
**Escritor único:** planning-orchestrator. Ningún otro agente escribe este archivo.
**Lectores:** planning-governor (lee checkpoints y artifacts al decidir gate).

```json
{
  "orchestration_plan": {
    "phase": "040_planning",
    "sequence": [
      "planning-analyst",
      "planning-writer"
    ],
    "inputs": {
      "I1":  "<path a design/test_strategy_map.md o null>",
      "I2":  "<path a design/architecture_decision_records.md o null>",
      "I3":  "<path a design/technical_blueprint.md o null>",
      "I4":  "<path a design/contract_definitions.md o null>",
      "I5":  "<path a design/dependency_graph.md o null>",
      "I6":  "<path a specification/bdd_features.md o null>",
      "I7":  "<path a specification/data_contracts.md o null>",
      "I8":  "<path a specification/acceptance_criteria.md o null>",
      "I9":  "<path a specification/error_exception_policy.md o null>",
      "I10": "<path a discovery/shared_understanding.md o null>",
      "I11": "<path a discovery/scope_boundaries.md o null>",
      "I12": "<path a discovery/domain_glossary.md o null>"
    },
    "demo_statements": {
      "planning-analyst": "Cuando planning-analyst termine, podré observar que plan/planning_analysis_report.md existe y contiene: (a) tabla de validación de granularidad para cada VS-xx del draft del 030, indicando si pasa o requiere división; (b) lista de IC-xx huérfanos (puede ser vacía); (c) lista de BDD scenarios huérfanos (puede ser vacía); (d) matriz de dependencias entre slices derivada de DEP-xx; (e) ≥1 riesgo preliminar por VS-xx.",
      "planning-writer": "Cuando planning-writer termine, podré observar que: vertical_slice_plan.md tiene una entrada VS-xx por cada slice (incluyendo las nuevas si se dividieron), cada una con los 6 campos obligatorios (nombre, tipo, IC-xx, BDD scenarios, Criterio de Done con referencias a IDs, estimación de esfuerzo); project_roadmap.md lista todas las VS-xx en secuencia respetando la estructura TB→Crecimiento→MVP→Evolución→Robustez, con dependencias VS-xx → VS-xx explícitas y los 3 hitos obligatorios marcados; risk_register.md tiene ≥1 RK-xx por VS-xx con probabilidad, impacto y mitigación."
    },
    "starting_point": "null | CP-01 | COMPLETE"
  },
  "last_checkpoint": null,
  "status": "IN_PROGRESS | EXECUTION_COMPLETE | WORKER_FAILED",
  "analysis_path": null,
  "artifacts": {
    "vertical_slice_plan": null,
    "project_roadmap": null,
    "risk_register": null
  },
  "worker_errors": [],
  "last_updated": "<timestamp ISO 8601>"
}
```

**Valores de `last_checkpoint`:**
- `null` — antes de iniciar (orchestration_plan persistido pero ningún Worker ha terminado)
- `"CP-01"` — planning-analyst completado y verificado en disco; `analysis_path` tiene el path
- `"CP-02"` — planning-writer completado y verificado en disco; `artifacts` tiene los 3 paths; `status` pasa a `EXECUTION_COMPLETE`

**Campo `starting_point` en orchestration_plan:**
- `"null"` — arranque desde cero; A debe spawear planning-analyst primero
- `"CP-01"` — planning-analyst ya completado; A debe spawear planning-writer directamente
- `"COMPLETE"` — ambos Workers completados; A debe ir a CP-03

**Estructura de `worker_errors` (cuando `status: WORKER_FAILED`):**
```json
"worker_errors": [
  {
    "worker": "planning-analyst | planning-writer",
    "checkpoint_at_failure": "null | CP-01",
    "error": "<descripción del error — INCOMPLETO reportado por Worker o artefacto ausente en disco>"
  }
]
```

---

## Estructura mínima inicial — persistence/execution-state.json

**Responsable de creación:** planning-governor en E10-A Paso 4.
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
    "vertical_slice_plan": null,
    "project_roadmap": null,
    "risk_register": null
  },
  "worker_errors": [],
  "last_updated": "<timestamp ISO 8601>"
}
```

---

## Single Writer Rule

| Archivo | Escritor | Lectores |
|---------|----------|----------|
| `persistence/harness-state.json` (entrada "040_planning") | planning-governor únicamente | planning-orchestrator |
| `persistence/execution-state.json` | planning-orchestrator únicamente | planning-governor |

Ningún Worker (planning-analyst, planning-writer, planning-reviewer, planning-evaluator) escribe
ninguno de estos archivos. Los Workers solo reportan paths a quien los spawnea.

---

## Reglas de escritura para planning-orchestrator

1. **Persistir orchestration_plan completo antes de que el governor spawee cualquier Worker** (E12). Si falla la escritura, detener el flujo y reportar al governor.
2. **Actualizar `last_checkpoint` inmediatamente** tras recibir CHECKPOINT_OK del governor (post-verificación en disco). No esperar al siguiente paso.
3. **Nunca reescribir campos ya completados.** Al reanudar, conservar `analysis_path` ya registrado — solo completar los campos faltantes.
4. **Actualizar `last_updated`** en cada escritura con timestamp ISO 8601.
5. **El campo `worker_errors` lo escribe B** al registrar CHECKPOINT_FAILED. No lo escriben los Workers.
