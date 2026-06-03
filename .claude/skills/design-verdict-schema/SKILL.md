---
name: design-verdict-schema
description: Schema y formato de los dos archivos de salida de design-evaluator en el 030 Design Harness — verdict.json (veredicto y scores por dimensión) y metrics_summary.json (métricas objetivas, historial de versiones y timeline). Usar cuando design-evaluator escribe los resultados de la auditoría.
user-invocable: false
agent: design-evaluator
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
    "phase": "030_design",
    "evaluation_version": 1,
    "evaluated_at": "2026-06-01T00:00:00Z",
    "verdict": "APPROVED | REJECTED",
    "veto_triggered": false,
    "scores": {
      "D1_blueprint_coverage": 0.0,
      "D2_contract_completeness": 0.0,
      "D3_testability": 0.0,
      "D4_adr_completeness": 0.0,
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
      "030_design/technical_blueprint.md",
      "030_design/contract_definitions.md",
      "030_design/dependency_graph.md",
      "030_design/architecture_decision_records.md",
      "030_design/test_strategy_map.md"
    ],
    "reference_artifacts_read": [
      "020_specification/bdd_features.md",
      "020_specification/data_contracts.md",
      "010_discovery/domain_glossary.md"
    ]
  }
]
```

**Reglas:**
- `phase` siempre `"030_design"` para entradas del 030.
- `evaluation_version` = número de entradas existentes con `"phase": "030_design"` + 1. Nunca reiniciar a 1.
- `findings` solo incluye dimensiones con score < 0.75 o con observaciones relevantes para el rework.
- Si `veto_triggered: true`, agregar entry en `findings` para D5 con la contradicción específica
  encontrada y los dos artefactos que se contradicen.
- `reference_artifacts_read` lista los artefactos del 010/020 que C leyó para verificar D1, D2 y D5
  de forma independiente. Siempre incluye `020_specification/bdd_features.md` (D1),
  `020_specification/data_contracts.md` (D2) y `010_discovery/domain_glossary.md` (D5).
- `evaluated_at` en formato ISO 8601.

---

## Archivo 2 — metrics_summary.json

**Path:** `/eval/metrics_summary.json`

**Formato:** array JSON acumulativo. Cada entrada corresponde a un harness completo.

```json
[
  {
    "project": "[nombre del proyecto]",
    "phase": "030_design",
    "completed_at": "2026-06-01T00:00:00Z",

    "tipo1_metricas_objetivas": {
      "bounded_contexts_en_bdd": 0,
      "modulos_en_blueprint": 0,
      "bounded_contexts_sin_modulo": 0,
      "entidades_en_data_contracts_020": 0,
      "interfaces_ic_en_contract_definitions": 0,
      "dtos_en_contract_definitions": 0,
      "interfaces_sin_dto_error": 0,
      "interfaces_ic_con_ts_en_test_strategy": 0,
      "interfaces_ic_sin_ts": 0,
      "opciones_evaluadas_en_adr001": 0,
      "adrs_totales": 0,
      "patrones_pt_en_analysis_report": 0,
      "patrones_sin_adr": 0,
      "dependencias_dep_en_dependency_graph": 0,
      "slices_en_guia_vertical": 0,
      "marcadores_pendiente": 0
    },

    "tipo2_scores_evaluacion": {
      "v1": {
        "evaluated_at": "2026-06-01T00:00:00Z",
        "D1_blueprint_coverage": 0.0,
        "D2_contract_completeness": 0.0,
        "D3_testability": 0.0,
        "D4_adr_completeness": 0.0,
        "D5_consistency": 0.0,
        "average": 0.0,
        "veto_triggered": false,
        "result": "APPROVED | REJECTED"
      }
    },

    "artifacts": {
      "technical_blueprint": {
        "path": "030_design/technical_blueprint.md",
        "final_version": 1,
        "revisions": 0
      },
      "contract_definitions": {
        "path": "030_design/contract_definitions.md",
        "final_version": 1,
        "revisions": 0
      },
      "dependency_graph": {
        "path": "030_design/dependency_graph.md",
        "final_version": 1,
        "revisions": 0
      },
      "architecture_decision_records": {
        "path": "030_design/architecture_decision_records.md",
        "final_version": 1,
        "revisions": 0
      },
      "test_strategy_map": {
        "path": "030_design/test_strategy_map.md",
        "final_version": 1,
        "revisions": 0
      }
    },

    "timeline": {
      "CP01_analyst_complete": "2026-06-01T00:00:00Z | null",
      "CP02_architect_complete": "2026-06-01T00:00:00Z | null",
      "CP03_client_review": "2026-06-01T00:00:00Z | null",
      "CP04_client_approved": "2026-06-01T00:00:00Z | null",
      "audit_complete": "2026-06-01T00:00:00Z | null"
    },

    "revision_counts": {
      "analyst_reruns": 0,
      "architect_reruns": 0,
      "rework_cycles": 0,
      "total_iterations": 0
    }
  }
]
```

**Reglas:**
- `phase` siempre `"030_design"` para entradas del 030.
- `tipo1_metricas_objetivas` se obtiene leyendo los 5 artefactos directamente. No inferir — contar los IDs existentes.
  - `bounded_contexts_en_bdd`: contar Features o grupos de Scenarios en `020_specification/bdd_features.md` (fuente independiente — no leer el analysis_report).
  - `modulos_en_blueprint`: contar IDs MOD-xx en `030_design/technical_blueprint.md`.
  - `bounded_contexts_sin_modulo`: contar bounded contexts del 020 que no tienen MOD-xx correspondiente.
  - `entidades_en_data_contracts_020`: contar entidades EN-xx en `020_specification/data_contracts.md` (fuente independiente).
  - `interfaces_ic_en_contract_definitions`: contar IDs IC-xx en `030_design/contract_definitions.md`.
  - `dtos_en_contract_definitions`: contar IDs DTO-xx en `030_design/contract_definitions.md`.
  - `interfaces_ic_con_ts_en_test_strategy`: contar IC-xx que tienen al menos un TS-xx en `030_design/test_strategy_map.md`.
  - `slices_en_guia_vertical`: contar secciones de Vertical Slices en `030_design/test_strategy_map.md` (esperado: 3).
  - `marcadores_pendiente`: contar ocurrencias de `[PENDIENTE` en los 5 artefactos.
- `tipo2_scores_evaluacion` tiene una entrada por cada ciclo de evaluación. Si hubo rework, agregar `"v2": { ... }` sin eliminar `"v1"`.
- `artifacts.*.revisions` = número de veces que ese artefacto fue reescrito por rework.
- `revision_counts.architect_reruns` = veces que design-architect fue re-ejecutado (por rework post-evaluación).
- `revision_counts.rework_cycles` = veces que C emitió REJECTED y el architect fue re-ejecutado.
- Los timestamps `null` corresponden a checkpoints que no han ocurrido al momento de la evaluación.

---

## Orden de escritura (append)

1. Leer `eval/verdict.json` si existe → obtener array; si no existe → array vacío `[]`.
2. Contar entradas con `"phase": "030_design"` → `evaluation_version = count + 1`.
3. Construir nueva entrada con scores y veredicto. Agregar al array.
4. Escribir el array completo en `eval/verdict.json`.
5. Leer los 5 artefactos de `/030_design/` para métricas Tipo 1 (contar IDs directamente).
6. Leer `020_specification/bdd_features.md` y `020_specification/data_contracts.md` para métricas de cobertura independiente.
7. Leer `persistence/execution-state.json` para timestamps de checkpoints y contadores.
8. Leer `eval/metrics_summary.json` si existe → obtener array; si no → array vacío `[]`.
9. Construir nueva entrada de métricas. Agregar al array.
10. Escribir el array completo en `eval/metrics_summary.json`.
