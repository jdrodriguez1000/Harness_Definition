---
name: planning-analysis-schema
description: Schema y formato del archivo planning_analysis_report.md del 040 Planning Harness. Usar cuando planning-analyst escribe el reporte o cuando planning-writer lo lee para producir los 3 artefactos finales.
user-invocable: false
agent: planning-analyst
---

## Ruta del archivo

`/plan/planning_analysis_report.md`

## Propósito del reporte

El planning_analysis_report es el puente entre los 12 inputs del 040 y los 3 artefactos finales.
No produce el plan — organiza y estructura lo que planning-writer necesita para producirlo.
Todo lo que aparezca en este reporte debe ser trazable a uno de los 12 inputs; nada se infiere
ni se inventa. El planning-writer no consulta los inputs originales directamente — trabaja
exclusivamente desde este reporte (más I-1, I-4, I-6 e I-12 para referencia directa en los artefactos).

## IDs canónicos del reporte

| Prefijo | Concepto | Ejemplo |
|---------|----------|---------|
| VS-xx | Vertical Slice (tomados del draft del 030; nuevos si hay división) | VS-03 |
| IC-xx | Interface de `design/contract_definitions.md` a asignar a slices | IC-05 |
| SC-xx / SE-xx | Escenario BDD de `specification/bdd_features.md` a asignar a slices | SC-07 |
| DEP-xx | Dependencia de `design/dependency_graph.md` que impone orden entre slices | DEP-02 |
| RK-xx | Riesgo preliminar identificado por slice | RK-03 |

## Estructura del reporte

```markdown
# Planning Analysis Report — 040 Planning
Fecha: [fecha]
Producido por: planning-analyst
Iteración: [N]

## Inputs analizados

| Input | Path | Estado |
|-------|------|--------|
| test_strategy_map.md           | /design/test_strategy_map.md           | leído |
| architecture_decision_records.md | /design/architecture_decision_records.md | leído |
| technical_blueprint.md         | /design/technical_blueprint.md         | leído |
| contract_definitions.md        | /design/contract_definitions.md        | leído |
| dependency_graph.md            | /design/dependency_graph.md            | leído |
| bdd_features.md                | /specification/bdd_features.md         | leído |
| data_contracts.md              | /specification/data_contracts.md       | leído |
| acceptance_criteria.md         | /specification/acceptance_criteria.md  | leído |
| error_exception_policy.md      | /specification/error_exception_policy.md | leído |
| shared_understanding.md        | /discovery/shared_understanding.md     | leído |
| scope_boundaries.md            | /discovery/scope_boundaries.md         | leído |
| domain_glossary.md             | /discovery/domain_glossary.md          | leído |

## Sección 1 — VS-xx del Draft del 030

(Lista completa de slices extraídas de la sección "Guía de Vertical Slices" de test_strategy_map.md.
Si el draft no tiene esa sección o no tiene los 3 hitos mínimos — Tracer Bullet, MVP, Robustez —
registrar en Gaps y marcar Estado como ESCALAMIENTO REQUERIDO.)

| VS-xx | Nombre | Tipo | IC-xx en draft | BDD scenarios en draft | Observación |
|-------|--------|------|----------------|------------------------|-------------|
| VS-01 | [nombre] | Tracer Bullet | [lista IC-xx] | [lista SC/SE] | pasa / requiere división |
| VS-xx | ...    | Crecimiento / MVP / Evolución / Robustez | ... | ... | ... |

## Sección 2 — Validación de Granularidad

(Para cada VS-xx, verificar las 3 reglas de límite máximo:
  - Máx. 3 IC-xx nuevas por slice
  - Máx. 2 MOD-xx nuevos por slice
  - Máx. 10 BDD scenarios nuevos por slice
Slices que excedan cualquier límite deben dividirse. Documentar la división propuesta.)

| VS-xx | IC-xx nuevas | MOD-xx nuevos | BDD scenarios nuevos | Resultado | División propuesta |
|-------|-------------|---------------|---------------------|-----------|-------------------|
| VS-01 | [N]         | [N]           | [N]                 | PASA / DIVIDE | VS-01 → VS-01a + VS-01b |
| VS-xx | ...         | ...           | ...                 | ...       | ... |

### Slices nuevas por división (si aplica)

(Documentar las slices nuevas creadas por división. Decidir y documentar la convención de
nomenclatura usada: VS-xxA/VS-xxB o numeración secuencial desde el último VS existente.)

Convención elegida: [VS-xxA/VS-xxB | numeración secuencial — VS-NN]
Razón: [justificación de la convención elegida]

| VS-xx nuevo | Origen | Nombre | Tipo | IC-xx asignados | BDD scenarios asignados |
|-------------|--------|--------|------|-----------------|------------------------|
| VS-xxA      | VS-xx  | ...    | ...  | ...             | ...                     |
| VS-xxB      | VS-xx  | ...    | ...  | ...             | ...                     |

## Sección 3 — Asignación de IC-xx

(Lista canónica de IC-xx de contract_definitions.md. Verificar que cada uno aparece en ≥1 slice
del draft (o en las slices nuevas por división). Registrar los huérfanos para asignación.)

| IC-xx | Interface | Slice asignada | Estado |
|-------|-----------|----------------|--------|
| IC-01 | I[Nombre] | VS-xx          | ASIGNADO |
| IC-xx | ...       | [NINGUNA]      | HUÉRFANO |

### IC-xx huérfanos y asignación propuesta

(Para cada IC-xx huérfano, identificar la slice más coherente semánticamente y proponer asignación.)

| IC-xx | Interface | Asignación propuesta | Justificación |
|-------|-----------|---------------------|---------------|
| IC-xx | ...       | VS-xx               | [razón semántica] |

Total IC-xx en contract_definitions.md: [N]
Total IC-xx asignados (incluyendo propuestas): [N]
Total IC-xx huérfanos tras asignación: [0 si completo]

## Sección 4 — Asignación de BDD Scenarios

(Lista canónica de SC-xx/SE-xx de bdd_features.md. Verificar que cada uno aparece en ≥1 slice.
Registrar los huérfanos para asignación.)

| SC/SE-xx | Feature / Scenario | Slice asignada | Estado |
|----------|--------------------|----------------|--------|
| SC-01    | [nombre]           | VS-xx          | ASIGNADO |
| SC-xx    | ...                | [NINGUNA]      | HUÉRFANO |

### BDD scenarios huérfanos y asignación propuesta

| SC/SE-xx | Scenario | Asignación propuesta | Justificación |
|----------|----------|---------------------|---------------|
| SC-xx    | ...      | VS-xx               | [razón semántica] |

Total BDD scenarios en bdd_features.md: [N]
Total BDD scenarios asignados (incluyendo propuestas): [N]
Total BDD scenarios huérfanos tras asignación: [0 si completo]

## Sección 5 — Matriz de Dependencias entre Slices

(Derivada de DEP-xx en dependency_graph.md. Lógica: si la slice B necesita implementar una
IC-xx que la slice A produce, entonces B depende de A. Verificar que el orden Tracer Bullet →
Crecimiento → MVP → Evolución → Robustez no tiene ciclos.)

| Slice dependiente | Depende de | IC-xx / DEP-xx que crea la dependencia | Tipo |
|-------------------|------------|----------------------------------------|------|
| VS-02             | VS-01      | IC-01 (DEP-01) — necesita la interfaz del login para continuar | obligatoria |
| VS-xx             | VS-xx      | IC-xx (DEP-xx) — [razón]              | obligatoria / recomendada |

### Verificación de ciclos

| Posible ciclo detectado | Descripción | Requiere escalamiento |
|-------------------------|-------------|----------------------|
| VS-xx ↔ VS-xx           | [descripción del ciclo] | SÍ / NO |

(Si hay ciclos irresolubles → registrar en Gaps y escalar al governor.)

## Sección 6 — Riesgos Preliminares por Slice

(≥1 riesgo por cada VS-xx de la lista final. Incluir slices nuevas por división.
Los riesgos formales (RK-xx) los produce planning-writer — aquí se documentan preliminarmente
para orientar al writer. Asignar IDs RK-xx provisionales.)

| RK-xx | VS-xx | Descripción del riesgo | Categoría | Probabilidad tentativa | Impacto tentativo |
|-------|-------|----------------------|-----------|----------------------|-------------------|
| RK-01 | VS-01 | [descripción] | Técnica / Dependencia / Ambigüedad / Arquitectura | Alta / Media / Baja | Alto / Medio / Bajo |
| RK-xx | VS-xx | ...           | ...       | ...                  | ...               |

**Categorías de riesgo:**
- `Técnica` — complejidad de implementación o tecnología incierta
- `Dependencia` — servicio externo, API de tercero o dependencia no controlada
- `Ambigüedad` — requisito no resuelto en los inputs del 030/020/010
- `Arquitectura` — decisión de diseño del 030 que podría requerir revisión en la implementación

## Gaps e Ítems de Escalamiento

(Si el analyst detectó problemas bloqueantes, listarlos aquí. Si no hay gaps, escribir "Ninguno".)

| ID      | Gap identificado | Input afectado | Impacto en el plan | Acción requerida |
|---------|-----------------|---------------|-------------------|-----------------|
| GAP-01  | ...             | test_strategy_map.md | No se puede planificar sin resolución | Escalar al governor antes de continuar |

## Verificación del Demo Statement (self-checklist)

Antes de reportar COMPLETED, verificar cada condición:

- [ ] `plan/planning_analysis_report.md` existe en disco (Write ejecutado como primer tool call — LL-01)
- [ ] Tabla de validación de granularidad completa para cada VS-xx del draft del 030
- [ ] Lista de IC-xx huérfanos completa (puede ser vacía — debe ser explícita)
- [ ] Lista de BDD scenarios huérfanos completa (puede ser vacía — debe ser explícita)
- [ ] Matriz de dependencias entre slices derivada de DEP-xx con verificación de ciclos
- [ ] ≥1 riesgo preliminar (RK-xx provisional) por cada VS-xx de la lista final
- [ ] Tabla de Gaps completa (o "Ninguno" explícito)

Si todas las condiciones se verifican: reportar `COMPLETED` con path al archivo.
Si alguna condición falla: reportar `INCOMPLETO: <razón específica>`. No reportar COMPLETED.

## Cobertura

```
Iteración de análisis: [N]
VS-xx del draft del 030: [N]
VS-xx divididas: [N]
VS-xx de la lista final: [N]
IC-xx totales en contract_definitions.md: [N]
IC-xx huérfanos detectados: [N]
BDD scenarios totales en bdd_features.md: [N]
BDD scenarios huérfanos detectados: [N]
Dependencias entre slices identificadas: [N]
Ciclos detectados: [N]
Riesgos preliminares identificados: [N]
Gaps de escalamiento: [N]
```

## Estado del análisis

`LISTO PARA WRITER` | `ESCALAMIENTO REQUERIDO — [N] gaps bloqueantes`
```

## Reglas de escritura

- **El Write de `plan/planning_analysis_report.md` es el primer tool call** después de
  completar el análisis. Sin excepción. No reportar COMPLETED antes de haber escrito el archivo.
- Asignar IDs secuenciales: VS-xx de reutiliza del draft del 030 (no se reasignan); nuevas por
  división según la convención documentada en Sección 2; riesgos preliminares RK-xx; gaps GAP-01.
- Usar exclusivamente los términos del `domain_glossary.md`. Si un concepto técnico no aparece
  en el glosario pero es necesario, incluirlo con nota "(término técnico — no en glosario)".
- No inventar IC-xx ni BDD scenarios. Solo los que existen en contract_definitions.md y bdd_features.md.
- Un gap irresolublecon impacto bloqueante → registrar en Gaps e ítems de escalamiento y
  marcar Estado como `ESCALAMIENTO REQUERIDO`.
- Las exclusiones de `scope_boundaries.md` son límites duros — no asignar a slices trabajo
  que esté fuera del alcance acordado.
- Si el draft del 030 no contiene la sección "Guía de Vertical Slices" o no tiene los 3 hitos
  mínimos (Tracer Bullet, MVP, Robustez) → escalamiento inmediato. No continuar sin ese input.
