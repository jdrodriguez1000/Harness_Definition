---
name: vertical-verdict-schema
description: Schema y formato de los dos archivos de salida de vertical-evaluator en el 050 Vertical Harness — verdict.json (veredicto y scores por dimensión, con slice_id) y metrics_summary.json (métricas objetivas por slice, historial de versiones y timeline). Usar cuando vertical-evaluator escribe los resultados de la auditoría de una slice.
user-invocable: false
agent: vertical-evaluator
---

## Archivos de salida

Escribir en la carpeta `/eval/`. El directorio fue creado por el governor en E10-A.

`verdict.json` y `metrics_summary.json` son **arrays acumulativos** — cada slice y cada ciclo de
rework agrega una entrada nueva al final. Nunca se sobreescriben entradas existentes.

---

## Archivo 1 — verdict.json

**Path:** `/eval/verdict.json`

**Formato:** array JSON. Cada entrada corresponde a un ciclo de evaluación de una slice del 050.

```json
[
  {
    "phase": "050_vertical",
    "slice_id": "VS-xx",
    "evaluation_version": 1,
    "evaluated_at": "2026-06-04T00:00:00Z",
    "verdict": "APPROVED | REJECTED",
    "veto_triggered": false,
    "scores": {
      "D1_proposal_sds_coverage": 0.0,
      "D2_sdd_technical_depth": 0.0,
      "D3_testing_plan_tdd_traceability": 0.0,
      "D4_execution_plan_actionability": 0.0,
      "D5_consistency": 0.0
    },
    "average": 0.0,
    "gate_threshold": 0.75,
    "gate_passed": false,
    "findings": [
      {
        "dimension": "D1 | D2 | D3 | D4 | D5",
        "score": 0.0,
        "reason": "descripción concreta con cita del artefacto y sección",
        "recommendation": "acción específica para mejorar este score en el siguiente ciclo"
      }
    ],
    "artifacts_evaluated": [
      "050_vertical/VS-xx/proposal.md",
      "050_vertical/VS-xx/software_design_specification.md",
      "050_vertical/VS-xx/software_design_document.md",
      "050_vertical/VS-xx/testing_plan.md",
      "050_vertical/VS-xx/execution_plan.md"
    ],
    "reference_artifacts_read": [
      "040_planning/vertical_slice_plan.md",
      "030_design/contract_definitions.md",
      "030_design/test_strategy_map.md",
      "020_specification/bdd_features.md",
      "010_discovery/domain_glossary.md"
    ]
  }
]
```

**Reglas:**
- `phase` siempre `"050_vertical"` para entradas del 050.
- `slice_id` contiene el ID de la slice evaluada (ej. `"VS-02"`). Campo obligatorio — la LL-20 verifica su presencia.
- `evaluation_version` = número de entradas existentes con `"phase": "050_vertical"` **y** `"slice_id": "[VS-xx activa]"` + 1.
  Contar solo las entradas de esa slice específica — no el total de entradas del 050.
- `findings` incluye dimensiones con score < 0.75 o con observaciones relevantes para el rework.
- Si `veto_triggered: true`, agregar entry en `findings` para D5 con la contradicción específica
  encontrada y los dos artefactos que se contradicen.
- `reference_artifacts_read` lista los artefactos leídos como fuentes de verdad independientes.
  Siempre incluye los 5 listados arriba: `vertical_slice_plan.md` (D1, D4, D5), `contract_definitions.md`
  (D2, D5), `test_strategy_map.md` (D3), `bdd_features.md` (D1, D5), `domain_glossary.md` (D5).
- `evaluated_at` en formato ISO 8601.
- Los IDs en `artifacts_evaluated` incluyen el ID real de la slice (ej. `"050_vertical/VS-02/proposal.md"`).

---

## Archivo 2 — metrics_summary.json

**Path:** `/eval/metrics_summary.json`

**Formato:** array JSON acumulativo. Cada entrada corresponde a una slice evaluada del 050.

```json
[
  {
    "project": "[nombre del proyecto]",
    "phase": "050_vertical",
    "slice_id": "VS-xx",
    "slice_nombre": "[nombre descriptivo de la slice]",
    "completed_at": "2026-06-04T00:00:00Z",

    "tipo1_metricas_objetivas": {
      "ic_en_slice_segun_vertical_slice_plan": 0,
      "ic_en_software_design_document": 0,
      "ic_sin_firma_en_sdd": 0,
      "ic_sin_task_en_execution_plan": 0,
      "bdd_scenarios_en_slice_segun_vertical_slice_plan": 0,
      "bdd_scenarios_en_software_design_specification": 0,
      "bdd_scenarios_sin_seccion_en_sds": 0,
      "ic_con_estrategia_mock_en_testing_plan": 0,
      "ic_sin_estrategia_mock": 0,
      "red_phase_explicita_en_testing_plan": true,
      "features_en_execution_plan": 0,
      "tickets_en_execution_plan": 0,
      "tasks_en_execution_plan": 0,
      "tasks_sin_referencia_ic_o_bdd": 0,
      "tickets_sin_criterio_done_con_ids": 0,
      "marcadores_pendiente_total": 0
    },

    "tipo2_scores_evaluacion": {
      "v1": {
        "evaluated_at": "2026-06-04T00:00:00Z",
        "D1_proposal_sds_coverage": 0.0,
        "D2_sdd_technical_depth": 0.0,
        "D3_testing_plan_tdd_traceability": 0.0,
        "D4_execution_plan_actionability": 0.0,
        "D5_consistency": 0.0,
        "average": 0.0,
        "veto_triggered": false,
        "result": "APPROVED | REJECTED"
      }
    },

    "artifacts": {
      "proposal": {
        "path": "050_vertical/VS-xx/proposal.md",
        "final_version": 1,
        "revisions": 0
      },
      "software_design_specification": {
        "path": "050_vertical/VS-xx/software_design_specification.md",
        "final_version": 1,
        "revisions": 0
      },
      "software_design_document": {
        "path": "050_vertical/VS-xx/software_design_document.md",
        "final_version": 1,
        "revisions": 0
      },
      "testing_plan": {
        "path": "050_vertical/VS-xx/testing_plan.md",
        "final_version": 1,
        "revisions": 0
      },
      "execution_plan": {
        "path": "050_vertical/VS-xx/execution_plan.md",
        "final_version": 1,
        "revisions": 0
      }
    },

    "timeline": {
      "CP01_analyst_complete": "2026-06-04T00:00:00Z | null",
      "CP02_writer_complete": "2026-06-04T00:00:00Z | null",
      "CP03_client_review": "2026-06-04T00:00:00Z | null",
      "CP04_client_approved": "2026-06-04T00:00:00Z | null",
      "audit_complete": "2026-06-04T00:00:00Z | null"
    },

    "revision_counts": {
      "analyst_reruns": 0,
      "writer_reruns": 0,
      "rework_cycles": 0,
      "total_iterations": 0
    }
  }
]
```

**Reglas:**
- `phase` siempre `"050_vertical"`.
- `slice_id` es el ID de la slice evaluada (ej. `"VS-02"`). Requerido para identificar la entrada.
- `tipo1_metricas_objetivas` se obtiene leyendo los 5 artefactos de la slice directamente:
  - `ic_en_slice_segun_vertical_slice_plan`: contar IC-xx en la sección VS-xx de `040_planning/vertical_slice_plan.md` (fuente independiente).
  - `ic_en_software_design_document`: contar IC-xx con sección completa en `software_design_document.md`.
  - `ic_sin_firma_en_sdd`: IC-xx en la slice que no tienen firma de métodos en el SDD.
  - `ic_sin_task_en_execution_plan`: IC-xx de la slice que no aparecen en ninguna Task del execution_plan.
  - `bdd_scenarios_en_slice_segun_vertical_slice_plan`: contar SC-xx/SE-xx en la sección VS-xx de `vertical_slice_plan.md`.
  - `bdd_scenarios_en_software_design_specification`: contar secciones SC-xx/SE-xx en `software_design_specification.md`.
  - `bdd_scenarios_sin_seccion_en_sds`: diferencia entre los dos campos anteriores.
  - `ic_con_estrategia_mock_en_testing_plan`: IC-xx de la slice con sección de mock/stub en `testing_plan.md`.
  - `ic_sin_estrategia_mock`: `ic_en_slice` − `ic_con_estrategia_mock_en_testing_plan`.
  - `red_phase_explicita_en_testing_plan`: `true` si el testing_plan tiene sección "Red phase" con tests específicos por IC-xx; `false` si no.
  - `features_en_execution_plan`: contar FT-xx en `execution_plan.md`.
  - `tickets_en_execution_plan`: contar TK-xx en `execution_plan.md`.
  - `tasks_en_execution_plan`: contar TA-xx en `execution_plan.md`.
  - `tasks_sin_referencia_ic_o_bdd`: tasks que no citan ningún IC-xx ni SC-xx/SE-xx.
  - `tickets_sin_criterio_done_con_ids`: tickets cuyo Criterio de Done no contiene referencias a IC-xx o SC-xx/SE-xx.
  - `marcadores_pendiente_total`: contar ocurrencias de `[PENDIENTE` en los 5 artefactos de la slice.
- `tipo2_scores_evaluacion` tiene una entrada por cada ciclo de evaluación. Si hubo rework para esta slice, agregar `"v2": { ... }` sin eliminar `"v1"`.
- `artifacts.*.revisions` = número de veces que ese artefacto fue reescrito por rework (para esta slice).
- `revision_counts.writer_reruns` = veces que vertical-writer fue re-ejecutado para esta slice.
- Los timestamps `null` corresponden a checkpoints que no han ocurrido al momento de la evaluación.

---

## Orden de escritura (append)

1. Leer `eval/verdict.json` si existe → obtener array; si no existe → array vacío `[]`.
2. Contar entradas con `"phase": "050_vertical"` **y** `"slice_id": "[VS-xx activa]"` → `evaluation_version = count + 1`.
3. Construir nueva entrada con scores y veredicto. Agregar al array.
4. Escribir el array completo en `eval/verdict.json`.
5. Leer los 5 artefactos de `/050_vertical/VS-xx/` para métricas Tipo 1 (contar IDs directamente).
6. Leer `040_planning/vertical_slice_plan.md` para obtener IC-xx y BDD scenarios canónicos de la slice (fuente independiente).
7. Leer `persistence/execution-state.json` para timestamps de checkpoints y contadores.
8. Leer `eval/metrics_summary.json` si existe → obtener array; si no → array vacío `[]`.
9. Construir nueva entrada de métricas para la slice activa. Agregar al array.
10. Escribir el array completo en `eval/metrics_summary.json`.

**Nota sobre arrays multi-slice:** `verdict.json` y `metrics_summary.json` acumulan entradas de todas
las slices del proyecto. Al leer estos archivos para obtener la última entrada de una slice específica,
filtrar siempre por `"phase": "050_vertical"` **y** `"slice_id": "[VS-xx]"` — nunca asumir que la
última entrada del array corresponde a la slice activa.
