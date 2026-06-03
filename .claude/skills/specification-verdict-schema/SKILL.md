---
name: specification-verdict-schema
description: Schema y formato del archivo de salida de specification-evaluator en el 020 Specification Harness — verdict.json (veredicto, scores por dimensión con pesos y métricas del ciclo). Usar cuando specification-evaluator escribe los resultados de la auditoría.
user-invocable: false
agent: specification-evaluator
---

## Archivo de salida

Escribir en la carpeta `/eval/`. El directorio fue creado por el governor en E10-A.

`verdict.json` es un **array acumulativo** — cada ciclo de evaluación agrega una entrada nueva
al final. Nunca sobreescribir entradas existentes.

---

## verdict.json

**Path:** `/eval/verdict.json`

**Formato:** array JSON. Cada entrada corresponde a un ciclo de evaluación.

```json
[
  {
    "phase": "020_specification",
    "generated_at": "2026-01-01T00:00:00Z",
    "evaluation_version": 1,
    "artifacts_evaluated": [
      "020_specification/bdd_features.md",
      "020_specification/data_contracts.md",
      "020_specification/acceptance_criteria.md",
      "020_specification/error_exception_policy.md"
    ],
    "dimensions": {
      "D1_bdd_coverage":              { "score": 0.0, "weight": 0.20, "notes": "..." },
      "D2_data_contract_completeness": { "score": 0.0, "weight": 0.25, "notes": "..." },
      "D3_ac_traceability":            { "score": 0.0, "weight": 0.20, "notes": "..." },
      "D4_error_policy_completeness":  { "score": 0.0, "weight": 0.20, "notes": "..." },
      "D5_consistency":                { "score": 0.0, "weight": 0.15, "notes": "..." }
    },
    "average_score": 0.0,
    "decision": "APPROVED | REJECTED",
    "veto_triggered": false,
    "rejection_reasons": [],
    "cycle_metrics": {
      "workers_executed": ["specification-analyst", "specification-writer"],
      "checkpoints_passed": ["CP-01", "CP-02"],
      "rework_cycles": 0,
      "rejection_cycles": 0,
      "minor_issues": [],
      "analysis_path": "020_specification/spec_analysis_report.md",
      "approved_at": "2026-01-01T00:00:00Z",
      "sprint_contract_approved_at": "2026-01-01T00:00:00Z"
    }
  }
]
```

**Reglas:**
- `phase` siempre `"020_specification"`.
- `evaluation_version` = número de entradas existentes con `"phase": "020_specification"` + 1.
  Nunca reiniciar a 1.
- `dimensions`: usar exactamente los nombres de clave canónicos listados — no renombrar ni abreviar.
- `notes`: citar artefacto + sección concreta que respalda el score (pros y contras resumidos en
  una o dos frases).
- `rejection_reasons`: lista de strings con las razones de rechazo si `decision: "REJECTED"`.
  Lista vacía `[]` si APPROVED.
- `rejection_cycles` = `evaluation_version - 1` (cada versión previa fue un REJECTED).
- `cycle_metrics.minor_issues`: lista de strings con los issues menores reportados por
  specification-reviewer. Vacío si no hubo issues menores.
- `approved_at`: timestamp del CP-04 (aprobación del cliente). Si no está disponible en el
  contexto, usar `null`.
- `sprint_contract_approved_at`: timestamp en que el Sprint Contract fue aprobado por el cliente.
  Si no está disponible, usar `null`.
- `generated_at` en formato ISO 8601.

---

## Orden de escritura (4 pasos)

1. Leer `eval/verdict.json` si existe → array existente; si no existe → `[]`.
2. Contar entradas con `"phase": "020_specification"` → `evaluation_version = count + 1`.
3. Construir nueva entrada con el schema completo (dimensions + cycle_metrics). Agregar al array.
4. Escribir el array completo en `eval/verdict.json`.
