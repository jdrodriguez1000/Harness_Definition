---
name: vertical-state-schema
description: Schema y formato de los dos archivos de estado del 050 Vertical Harness — persistence/harness-state.json (entrada "050_vertical" con slices dict, escrita por vertical-governor) y persistence/execution-state.json (orchestration_plan y checkpoints por slice, escrito por vertical-orchestrator). Define la Single Writer Rule y las reglas de lectura/escritura para cada campo. Usar cuando vertical-orchestrator escribe persistence/execution-state.json o cuando vertical-governor lee o escribe persistence/harness-state.json.
user-invocable: false
agent: vertical-orchestrator
---

Los archivos de persistencia viven en la carpeta `persistence/` del directorio de trabajo del proyecto.

---

## Archivo 1 — persistence/harness-state.json (entrada "050_vertical")

**Path:** `persistence/harness-state.json`
**Escritor único (entrada 050):** vertical-governor (Instancia A). Ningún otro agente escribe en este archivo.
**Lectores:** vertical-orchestrator (lee Sprint Contract y active_slice al iniciar).

### Contexto: estructura multi-harness

`harness-state.json` fue creado por el 010 y extendido por el 020, 030 y 040. Contiene entradas de los
harnesses anteriores.

El vertical-governor **no modifica ningún campo raíz del 010 ni las claves `"020_specification"`,
`"030_design"` ni `"040_planning"`**. En cambio, agrega/actualiza una clave de primer nivel
`"050_vertical"` con toda la información del 050.

**Ejemplo de archivo extendido:**

```json
{
  "phase": "010_discovery",
  "status": "PHASE_COMPLETE",
  "sprint_contract": { "...campos del 010..." },
  "020_specification": { "status": "PHASE_COMPLETE" },
  "030_design":        { "status": "PHASE_COMPLETE" },
  "040_planning":      { "status": "PHASE_COMPLETE" },

  "050_vertical": {
    "status": "PENDING_CONTRACT | ACTIVE | AUDIT_PENDING | IN_REWORK | HOLD | SUSPENDED | PHASE_COMPLETE",
    "active_slice": "VS-01 | null",
    "slices": {
      "VS-01": "PENDING | DOCS_READY | SLICE_COMPLETE | PROD_READY",
      "VS-02": "PENDING | DOCS_READY | SLICE_COMPLETE | PROD_READY"
    },
    "sprint_contract": {
      "objective": "Producir los 5 artefactos de implementación para la slice activa [VS-xx]",
      "slice_activa": "VS-xx",
      "slice_nombre": "[nombre de la slice]",
      "slice_tipo": "Tracer Bullet | Crecimiento | MVP | Evolución | Robustez",
      "ic_asignados": ["IC-01", "IC-02"],
      "bdd_scenarios": ["SC-01", "SC-02", "SE-01"],
      "criterio_done": "[criterio del vertical_slice_plan.md para esta slice]",
      "esfuerzo": "XS | S | M | L | XL",
      "riesgos": ["RK-01"],
      "inputs": {
        "I1":  "<path a 040_planning/vertical_slice_plan.md>",
        "I2":  "<path a 040_planning/project_roadmap.md>",
        "I3":  "<path a 040_planning/risk_register.md>",
        "I4":  "<path a 030_design/technical_blueprint.md>",
        "I5":  "<path a 030_design/contract_definitions.md>",
        "I6":  "<path a 030_design/dependency_graph.md>",
        "I7":  "<path a 030_design/architecture_decision_records.md>",
        "I8":  "<path a 030_design/test_strategy_map.md>",
        "I9":  "<path a 020_specification/bdd_features.md>",
        "I10": "<path a 020_specification/data_contracts.md>",
        "I11": "<path a 020_specification/acceptance_criteria.md>",
        "I12": "<path a 020_specification/error_exception_policy.md>",
        "I13": "<path a 010_discovery/shared_understanding.md>",
        "I14": "<path a 010_discovery/domain_glossary.md>",
        "I15": "<path a 010_discovery/scope_boundaries.md>",
        "I16": "<path a 010_discovery/failure_behavior.md>",
        "I17": "<path a 050_vertical/VS-xx/*.md previas o null>"
      },
      "workers": ["vertical-analyst", "vertical-writer"],
      "checkpoints": ["CP-01", "CP-02", "CP-03", "CP-04"],
      "done_criteria": [
        "Los 5 artefactos existen en /050_vertical/VS-xx/ con contenido",
        "SDS cubre todos los BDD scenarios de la slice",
        "SDD referencia solo IC-xx de la slice definidos en contract_definitions.md",
        "Testing Plan tiene ≥1 estrategia de test por IC-xx, consistente con test_strategy_map.md",
        "Execution Plan descompone todos los IC-xx en tasks TDD (Red→Green→Refactor)",
        "Aprobación explícita del cliente en CP-04"
      ]
    },
    "client_approval": {
      "CP-03_draft_review": null,
      "CP-04_formal_approval": null
    },
    "escalations": [],
    "overrides": [],
    "handoff_060": null,
    "last_updated": "<timestamp ISO 8601>",
    "suspension": null
  }
}
```

El campo `"overrides"` es un array de objetos escritos por `/forge-override`. Estructura de cada elemento:
```json
{
  "id": "OV-001",
  "timestamp": "<ISO 8601>",
  "harness": "050_vertical",
  "texto": "<texto del override tal como lo escribió el usuario>",
  "status": "ACTIVE"
}
```
- El governor solo lee este campo (en E10-A/E10-B) para incorporar constraints duros al Sprint Contract.
- El campo es escrito por el comando `/forge-override`, no por el governor.

El campo `"suspension"` es `null` cuando el harness no está suspendido. Cuando `/forge-suspend` es
invocado, el governor escribe el bloque completo:
```json
"suspension": {
  "timestamp": "<ISO 8601>",
  "harness": "050_vertical",
  "governor_mode": "INIT | EXECUTE | POST_CP03 | POST_CP04",
  "last_checkpoint": "null | CP-01 | CP-02",
  "context_note": "<descripción libre del estado al momento de suspender>",
  "resume_instruction": "<qué hacer al reanudar>"
}
```

**Valores de `"050_vertical".status`:**
- `PENDING_CONTRACT` — estado inicial tras E10-A; Sprint Contract aún no aprobado por el cliente
- `ACTIVE` — Sprint Contract aprobado; ejecución en curso (o entre slices)
- `AUDIT_PENDING` — CP-04 recibido para la slice activa; vertical-evaluator aún no ha corrido
- `IN_REWORK` — rechazo técnico de C; vertical-governor re-spawnea el Worker fallido
- `HOLD` — rechazo estratégico; requiere nueva aprobación humana antes de continuar
- `SUSPENDED` — harness suspendido por `/forge-suspend`; esperando `/forge-continue` para reanudar
- `PHASE_COMPLETE` — todas las VS-xx están en `PROD_READY`; el ciclo completo 050→060→070→080 finalizó para cada slice

**Valores de `"050_vertical.slices"` por cada VS-xx:**
- `PENDING` — sin iniciar; los 5 artefactos aún no han sido producidos
- `DOCS_READY` — los 5 artefactos producidos, aprobados y evaluados; esperando 060+070+080
- `SLICE_COMPLETE` — el ciclo 050→060→070 completó para esta slice (escrito por el 070); esperando 080
- `PROD_READY` — el ciclo 050→060→070→080 completó para esta slice (escrito por el 080); slice disponible para deploy vía el 090

**Nota cross-harness:** Las únicas escrituras cross-harness permitidas en FORGE son:
- `"SLICE_COMPLETE"` — escrita por el governor del 070 Development Harness.
- `"PROD_READY"` — escrita por el governor del 080 Harness cuando la slice supera su gate final.

**Reglas de lectura para vertical-orchestrator:**
- Leer `harness_state["040_planning"]["status"]` para verificar `"PHASE_COMPLETE"`.
- Leer `harness_state["050_vertical"]["sprint_contract"]` para obtener la slice activa y los inputs.
- Leer `harness_state["050_vertical"]["active_slice"]` para determinar VS-xx.
- Si `"050_vertical".status` no es `ACTIVE` o `IN_REWORK` → detener y reportar al governor.

---

## Archivo 2 — persistence/execution-state.json (050 — por slice)

**Path:** `persistence/execution-state.json`
**Escritor único:** vertical-orchestrator. Ningún otro agente escribe este archivo.
**Lectores:** vertical-governor (lee checkpoints y artifacts al decidir gate).

**Nota:** El execution-state se reinicia al comenzar cada nueva slice. El governor reinicializa
la estructura mínima en E10-A Paso 7 / E10-B Paso 7 antes de spawnear el orchestrator para la nueva slice.

```json
{
  "orchestration_plan": {
    "phase": "050_vertical",
    "active_slice": "VS-xx",
    "sequence": [
      "vertical-analyst",
      "vertical-writer"
    ],
    "inputs": {
      "I1":  "<path a 040_planning/vertical_slice_plan.md o null>",
      "I2":  "<path a 040_planning/project_roadmap.md o null>",
      "I3":  "<path a 040_planning/risk_register.md o null>",
      "I4":  "<path a 030_design/technical_blueprint.md o null>",
      "I5":  "<path a 030_design/contract_definitions.md o null>",
      "I6":  "<path a 030_design/dependency_graph.md o null>",
      "I7":  "<path a 030_design/architecture_decision_records.md o null>",
      "I8":  "<path a 030_design/test_strategy_map.md o null>",
      "I9":  "<path a 020_specification/bdd_features.md o null>",
      "I10": "<path a 020_specification/data_contracts.md o null>",
      "I11": "<path a 020_specification/acceptance_criteria.md o null>",
      "I12": "<path a 020_specification/error_exception_policy.md o null>",
      "I13": "<path a 010_discovery/shared_understanding.md o null>",
      "I14": "<path a 010_discovery/domain_glossary.md o null>",
      "I15": "<path a 010_discovery/scope_boundaries.md o null>",
      "I16": "<path a 010_discovery/failure_behavior.md o null>",
      "I17": "<paths a artefactos de slices previas o null>"
    },
    "demo_statements": {
      "vertical-analyst": "Cuando vertical-analyst termine, podré observar que 050_vertical/[VS-xx]/slice_analysis_report.md existe y contiene: (a) lista de IC-xx asignados a la slice activa extraída de I-1 y I-5; (b) lista de BDD scenarios (SC-xx/SE-xx) asignados a la slice extraída de I-1 y I-9; (c) riesgos específicos de la slice extraídos de I-3 (RK-xx); (d) dependencias con slices previas extraídas de I-2; (e) políticas de error relevantes de I-12 por cada IC-xx o BDD scenario de la slice.",
      "vertical-writer": "Cuando vertical-writer termine, podré observar que: proposal.md cita los IC-xx y BDD scenarios de la slice y describe el valor de negocio; software_design_specification.md tiene ≥1 sección por BDD scenario de la slice con flujo, datos y AC verificables; software_design_document.md referencia solo IC-xx de I-5 e incluye firma técnica y estrategia de DI para cada uno; testing_plan.md tiene ≥1 estrategia de test por IC-xx consistente con I-8; execution_plan.md descompone la slice en Features → Tickets → Tasks en orden TDD (Red→Green→Refactor), con todos los IC-xx asignados a ≥1 task."
    },
    "starting_point": "null | CP-01 | COMPLETE"
  },
  "last_checkpoint": null,
  "status": "IN_PROGRESS | EXECUTION_COMPLETE | WORKER_FAILED",
  "analysis_path": null,
  "artifacts": {
    "proposal": null,
    "software_design_specification": null,
    "software_design_document": null,
    "testing_plan": null,
    "execution_plan": null
  },
  "worker_errors": [],
  "last_updated": "<timestamp ISO 8601>"
}
```

**Valores de `last_checkpoint`:**
- `null` — antes de iniciar (orchestration_plan persistido pero ningún Worker ha terminado)
- `"CP-01"` — vertical-analyst completado y verificado en disco; `analysis_path` tiene el path
- `"CP-02"` — vertical-writer completado y verificado en disco; `artifacts` tiene los 5 paths; `status` pasa a `EXECUTION_COMPLETE`

**Campo `starting_point` en orchestration_plan:**
- `"null"` — arranque desde cero; A debe spawear vertical-analyst primero
- `"CP-01"` — vertical-analyst ya completado; A debe spawear vertical-writer directamente
- `"COMPLETE"` — ambos Workers completados; A debe ir a CP-03

**Estructura de `worker_errors` (cuando `status: WORKER_FAILED`):**
```json
"worker_errors": [
  {
    "worker": "vertical-analyst | vertical-writer",
    "checkpoint_at_failure": "null | CP-01",
    "error": "<descripción del error — INCOMPLETO reportado por Worker o artefacto ausente en disco>"
  }
]
```

---

## Estructura mínima inicial — persistence/execution-state.json

**Responsable de creación (por slice):** vertical-governor en E10-A Paso 7 / E10-B Paso 7.
**Regla:** governor crea el archivo con estructura mínima al iniciar cada slice; orchestrator escribe
`orchestration_plan` y checkpoints sobre ese archivo ya existente. Si orchestrator llega y no existe
(escenario de fallo), crea la estructura mínima como fallback antes de escribir su `orchestration_plan`.

```json
{
  "orchestration_plan": null,
  "last_checkpoint": null,
  "status": "PENDING",
  "analysis_path": null,
  "artifacts": {
    "proposal": null,
    "software_design_specification": null,
    "software_design_document": null,
    "testing_plan": null,
    "execution_plan": null
  },
  "worker_errors": [],
  "last_updated": "<timestamp ISO 8601>"
}
```

---

## Single Writer Rule

| Archivo | Escritor | Lectores |
|---------|----------|----------|
| `persistence/harness-state.json` (entrada "050_vertical") | vertical-governor únicamente | vertical-orchestrator |
| `persistence/harness-state.json` (slices[VS-xx] = "SLICE_COMPLETE") | vertical-governor (070 escribe la excepción cross-harness) | vertical-governor |
| `persistence/execution-state.json` | vertical-orchestrator únicamente | vertical-governor |

Ningún Worker (vertical-analyst, vertical-writer, vertical-reviewer, vertical-evaluator) escribe
ninguno de estos archivos. Los Workers solo reportan paths a quien los spawnea.

---

## Reglas de escritura para vertical-orchestrator

1. **Persistir orchestration_plan completo antes de que el governor spawee cualquier Worker** (E12). Si falla la escritura, detener el flujo y reportar al governor.
2. **Actualizar `last_checkpoint` inmediatamente** tras recibir CHECKPOINT_OK del governor (post-verificación en disco). No esperar al siguiente paso.
3. **Nunca reescribir campos ya completados.** Al reanudar, conservar `analysis_path` ya registrado — solo completar los campos faltantes.
4. **Actualizar `last_updated`** en cada escritura con timestamp ISO 8601.
5. **El campo `worker_errors` lo escribe B** al registrar CHECKPOINT_FAILED. No lo escriben los Workers.
6. **Incluir `active_slice` en el orchestration_plan.** El ID VS-xx de la slice activa debe estar presente en todos los paths del plan para evitar ambigüedad en proyectos con múltiples slices.
