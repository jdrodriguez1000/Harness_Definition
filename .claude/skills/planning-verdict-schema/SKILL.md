---
name: planning-verdict-schema
description: Schema y formato de los dos archivos de salida de planning-evaluator en el 040 Planning Harness — verdict.json (veredicto y scores por dimensión) y metrics_summary.json (métricas objetivas, historial de versiones y timeline). Usar cuando planning-evaluator escribe los resultados de la auditoría.
user-invocable: false
agent: planning-evaluator
---

## Archivos de salida

Escribir en la carpeta `/eval/`. El directorio fue creado por el governor en E10-A.

`verdict.json` y `metrics_summary.json` son **arrays acumulativos** — cada harness y cada ciclo de rework agrega una entrada nueva al final. Nunca se sobreescriben entradas existentes.

---

## Archivo 1 — verdict.json

**Path:** `/eval/verdict.json`

**Formato:** array JSON. Cada entrada corresponde a un ciclo de evaluación de un harness.

```json
[
  {
    "phase": "040_planning",
    "evaluation_version": 1,
    "evaluated_at": "2026-06-03T00:00:00Z",
    "verdict": "APPROVED | REJECTED",
    "veto_triggered": false,
    "scores": {
      "D1_vs_coverage": 0.0,
      "D2_slice_definition_quality": 0.0,
      "D3_roadmap_coherence": 0.0,
      "D4_risk_completeness": 0.0,
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
      "plan/vertical_slice_plan.md",
      "plan/project_roadmap.md",
      "plan/risk_register.md"
    ],
    "reference_artifacts_read": [
      "design/contract_definitions.md",
      "specification/bdd_features.md",
      "discovery/domain_glossary.md"
    ]
  }
]
```

**Reglas:**
- `phase` siempre `"040_planning"` para entradas del 040.
- `evaluation_version` = número de entradas existentes con `"phase": "040_planning"` + 1. Nunca reiniciar a 1.
- `findings` solo incluye dimensiones con score < 0.75 o con observaciones relevantes para el rework.
- Si `veto_triggered: true`, agregar entry en `findings` para D5 con la contradicción específica
  encontrada y los dos artefactos que se contradicen.
- `reference_artifacts_read` lista los artefactos del 010/020/030 que C leyó para verificar D1, D3 y D5
  de forma independiente. Siempre incluye `design/contract_definitions.md` (D1, D3),
  `specification/bdd_features.md` (D1, D3) y `discovery/domain_glossary.md` (D5).
- `evaluated_at` en formato ISO 8601.

---

## Archivo 2 — metrics_summary.json

**Path:** `/eval/metrics_summary.json`

**Formato:** array JSON acumulativo. Cada entrada corresponde a un harness completo.

```json
[
  {
    "project": "[nombre del proyecto]",
    "phase": "040_planning",
    "completed_at": "2026-06-03T00:00:00Z",

    "tipo1_metricas_objetivas": {
      "ic_en_contract_definitions": 0,
      "ic_asignados_en_vertical_slice_plan": 0,
      "ic_sin_slice": 0,
      "bdd_scenarios_en_bdd_features": 0,
      "bdd_scenarios_asignados_en_vertical_slice_plan": 0,
      "bdd_scenarios_sin_slice": 0,
      "slices_totales_en_vertical_slice_plan": 0,
      "slices_con_6_campos": 0,
      "slices_sin_criterio_done_con_ids": 0,
      "slices_sin_estimacion_esfuerzo": 0,
      "slices_en_project_roadmap": 0,
      "hitos_marcados_en_roadmap": 0,
      "dependencias_vs_documentadas": 0,
      "ciclos_detectados": 0,
      "slices_con_riesgo_en_risk_register": 0,
      "slices_sin_riesgo": 0,
      "mitigaciones_genericas": 0,
      "marcadores_pendiente": 0
    },

    "tipo2_scores_evaluacion": {
      "v1": {
        "evaluated_at": "2026-06-03T00:00:00Z",
        "D1_vs_coverage": 0.0,
        "D2_slice_definition_quality": 0.0,
        "D3_roadmap_coherence": 0.0,
        "D4_risk_completeness": 0.0,
        "D5_consistency": 0.0,
        "average": 0.0,
        "veto_triggered": false,
        "result": "APPROVED | REJECTED"
      }
    },

    "artifacts": {
      "vertical_slice_plan": {
        "path": "plan/vertical_slice_plan.md",
        "final_version": 1,
        "revisions": 0
      },
      "project_roadmap": {
        "path": "plan/project_roadmap.md",
        "final_version": 1,
        "revisions": 0
      },
      "risk_register": {
        "path": "plan/risk_register.md",
        "final_version": 1,
        "revisions": 0
      }
    },

    "timeline": {
      "CP01_analyst_complete": "2026-06-03T00:00:00Z | null",
      "CP02_writer_complete": "2026-06-03T00:00:00Z | null",
      "CP03_client_review": "2026-06-03T00:00:00Z | null",
      "CP04_client_approved": "2026-06-03T00:00:00Z | null",
      "audit_complete": "2026-06-03T00:00:00Z | null"
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
- `phase` siempre `"040_planning"` para entradas del 040.
- `tipo1_metricas_objetivas` se obtiene leyendo los 3 artefactos directamente. No inferir — contar los IDs existentes.
  - `ic_en_contract_definitions`: contar IDs IC-xx en `design/contract_definitions.md` (fuente independiente).
  - `ic_asignados_en_vertical_slice_plan`: contar IC-xx únicos mencionados en todas las slices de `vertical_slice_plan.md`.
  - `ic_sin_slice`: `ic_en_contract_definitions` − `ic_asignados_en_vertical_slice_plan`.
  - `bdd_scenarios_en_bdd_features`: contar IDs SC-xx y SE-xx en `specification/bdd_features.md` (fuente independiente).
  - `bdd_scenarios_asignados_en_vertical_slice_plan`: contar SC-xx/SE-xx únicos en `vertical_slice_plan.md`.
  - `bdd_scenarios_sin_slice`: `bdd_scenarios_en_bdd_features` − `bdd_scenarios_asignados_en_vertical_slice_plan`.
  - `slices_totales_en_vertical_slice_plan`: contar secciones VS-xx en `plan/vertical_slice_plan.md`.
  - `slices_con_6_campos`: contar slices que tienen los 6 campos: nombre, tipo, IC-xx, BDD scenarios, Criterio de Done y esfuerzo.
  - `slices_sin_criterio_done_con_ids`: contar slices cuyo Criterio de Done no contiene referencias a IC-xx o SC-xx/SE-xx.
  - `hitos_marcados_en_roadmap`: contar hitos con ★ en `project_roadmap.md` (esperado: 3).
  - `slices_con_riesgo_en_risk_register`: contar VS-xx con ≥1 RK-xx en `risk_register.md`.
  - `slices_sin_riesgo`: `slices_totales_en_vertical_slice_plan` − `slices_con_riesgo_en_risk_register`.
  - `mitigaciones_genericas`: contar RK-xx con mitigación que no referencia IC-xx, slices ni artefactos concretos (texto genérico como "revisar el código", "hacer más testing").
  - `marcadores_pendiente`: contar ocurrencias de `[PENDIENTE` en los 3 artefactos.
- `tipo2_scores_evaluacion` tiene una entrada por cada ciclo de evaluación. Si hubo rework, agregar `"v2": { ... }` sin eliminar `"v1"`.
- `artifacts.*.revisions` = número de veces que ese artefacto fue reescrito por rework.
- `revision_counts.writer_reruns` = veces que planning-writer fue re-ejecutado (por rework post-evaluación).
- `revision_counts.rework_cycles` = veces que C emitió REJECTED y el writer fue re-ejecutado.
- Los timestamps `null` corresponden a checkpoints que no han ocurrido al momento de la evaluación.

---

## Orden de escritura (append)

1. Leer `eval/verdict.json` si existe → obtener array; si no existe → array vacío `[]`.
2. Contar entradas con `"phase": "040_planning"` → `evaluation_version = count + 1`.
3. Construir nueva entrada con scores y veredicto. Agregar al array.
4. Escribir el array completo en `eval/verdict.json`.
5. Leer los 3 artefactos de `/plan/` para métricas Tipo 1 (contar IDs directamente).
6. Leer `design/contract_definitions.md` y `specification/bdd_features.md` para métricas de cobertura independiente.
7. Leer `persistence/execution-state.json` para timestamps de checkpoints y contadores.
8. Leer `eval/metrics_summary.json` si existe → obtener array; si no → array vacío `[]`.
9. Construir nueva entrada de métricas. Agregar al array.
10. Escribir el array completo en `eval/metrics_summary.json`.
