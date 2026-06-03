---
name: discovery-verdict-schema
description: Schema y formato de los dos archivos de salida de discovery-evaluator en el 010 Discovery Harness — verdict.json (veredicto y scores por dimensión) y metrics_summary.json (métricas objetivas, historial de versiones y timeline). Usar cuando discovery-evaluator escribe los resultados de la auditoría.
user-invocable: false
agent: discovery-evaluator
---

## Archivos de salida

Crear la carpeta `/eval/` si no existe antes de escribir.

`verdict.json` y `metrics_summary.json` son **arrays acumulativos** — cada harness y cada ciclo de rework agrega una entrada nueva al final del array. Nunca se sobreescriben entradas existentes.

---

## Archivo 1 — verdict.json

**Path:** `/eval/verdict.json`

**Formato:** array JSON. Cada entrada corresponde a un ciclo de evaluación de un harness.

```json
[
  {
    "phase": "010_discovery",
    "evaluation_version": 1,
    "evaluated_at": "2026-05-26T00:00:00Z",
    "verdict": "APPROVED | REJECTED",
    "veto_triggered": false,
    "scores": {
      "D1_actor_coverage": 0.0,
      "D2_intent_clarity": 0.0,
      "D3_contradiction_management": 0.0,
      "D4_failure_coverage": 0.0,
      "D5_explicit_approval": 0.0
    },
    "average": 0.0,
    "gate_threshold": 0.75,
    "gate_passed": false,
    "findings": [
      {
        "dimension": "D1 | D2 | D3 | D4 | D5",
        "score": 0.0,
        "reason": "descripción concreta de por qué recibe este score",
        "recommendation": "acción específica para mejorar este score en el siguiente ciclo"
      }
    ],
    "artifacts_evaluated": [
      "/discovery/shared_understanding.md",
      "/discovery/scope_boundaries.md",
      "/discovery/domain_glossary.md",
      "/discovery/failure_behavior.md"
    ]
  }
]
```

**Reglas:**
- `phase` identifica el harness: `"010_discovery"`, `"020_specification"`, etc.
- `evaluation_version` incrementa por ciclo dentro del mismo harness: contar las entradas existentes con el mismo `phase` y sumar 1.
- `findings` solo incluye dimensiones con score < 0.75 o con observaciones relevantes.
- Si `veto_triggered: true`, agregar en `findings` un entry para D5 explicando el veto.
- `evaluated_at` en formato ISO 8601.

---

## Archivo 2 — metrics_summary.json

**Path:** `/eval/metrics_summary.json`

**Formato:** array JSON acumulativo. Cada entrada corresponde a un harness completo.

```json
[
 {
  "project": "[nombre del proyecto]",
  "phase": "010_discovery",
  "completed_at": "2026-05-26T00:00:00Z",

  "tipo1_metricas_objetivas": {
    "stakeholders_entrevistados": 0,
    "actores_sistema_identificados": 0,
    "objetivos_de_valor_totales": 0,
    "contradicciones_resueltas": 0,
    "contradicciones_abiertas": 0,
    "escenarios_de_fallo": 0,
    "terminos_glosario": 0,
    "exclusiones_scope": 0,
    "iteraciones_aclaracion": 0,
    "items_unresolved": 0
  },

  "tipo2_scores_evaluacion": {
    "v1": {
      "evaluated_at": "2026-05-26T00:00:00Z",
      "D1_actor_coverage": 0.0,
      "D2_intent_clarity": 0.0,
      "D3_contradiction_management": 0.0,
      "D4_failure_coverage": 0.0,
      "D5_explicit_approval": 0.0,
      "average": 0.0,
      "veto_triggered": false,
      "result": "APPROVED | REJECTED"
    }
  },

  "artifacts": {
    "shared_understanding": {
      "path": "/discovery/shared_understanding.md",
      "final_version": 1,
      "revisions": 0,
      "approved_by_client_at": "2026-05-26T00:00:00Z | null"
    },
    "scope_boundaries": {
      "path": "/discovery/scope_boundaries.md",
      "final_version": 1,
      "revisions": 0
    },
    "domain_glossary": {
      "path": "/discovery/domain_glossary.md",
      "final_version": 1,
      "revisions": 0
    },
    "failure_behavior": {
      "path": "/discovery/failure_behavior.md",
      "final_version": 1,
      "revisions": 0
    }
  },

  "timeline": {
    "CP01_transcript_complete": "2026-05-26T00:00:00Z | null",
    "CP02_analysis_clean": "2026-05-26T00:00:00Z | null",
    "CP03_synthesis_complete": "2026-05-26T00:00:00Z | null",
    "CP04_client_approved": "2026-05-26T00:00:00Z | null",
    "audit_complete": "2026-05-26T00:00:00Z | null"
  },

  "revision_counts": {
    "clarification_loops": 0,
    "rework_cycles": 0,
    "total_iterations": 0
  }
 }
]
```

**Reglas:**
- `phase` siempre `"010_discovery"` para entradas del 010.
- `tipo2_scores_evaluacion` tiene una entrada por cada ciclo de evaluación de C dentro de este harness. Si hubo rework, agregar `"v2": { ... }` sin eliminar `"v1"`.
- `tipo1_metricas_objetivas` se obtiene leyendo `analysis_report.md` (sección Cobertura). No inferir — leer los números directamente del reporte.
- Los timestamps `null` corresponden a checkpoints que aún no ocurrieron al momento de la evaluación.
- `artifacts.*.revisions` = número de veces que ese artefacto fue reescrito por rework (0 en el primer ciclo limpio).
- `revision_counts.clarification_loops` = iteraciones del bucle discovery-analyst → discovery-dialoguer.
- `revision_counts.rework_cycles` = veces que C rechazó y B re-ejecutó workers.
- `revision_counts.total_iterations` = clarification_loops + rework_cycles.

---

## Orden de escritura (append)

1. Leer `eval/verdict.json` si existe → obtener array; si no existe → array vacío `[]`.
2. Contar entradas con `"phase": "010_discovery"` → `evaluation_version = count + 1`.
3. Construir nueva entrada con scores y veredicto. Agregar al array.
4. Escribir el array completo en `eval/verdict.json`.
5. Leer `discovery/analysis_report.md` para extraer métricas Tipo 1.
6. Leer `persistence/execution-state.json` para timestamps de checkpoints y contadores.
7. Leer `eval/metrics_summary.json` si existe → obtener array; si no → array vacío `[]`.
8. Construir nueva entrada de métricas. Agregar al array.
9. Escribir el array completo en `eval/metrics_summary.json`.
