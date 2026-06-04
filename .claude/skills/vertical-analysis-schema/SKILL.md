---
name: vertical-analysis-schema
description: Schema y formato del archivo slice_analysis_report.md del 050 Vertical Harness. Usar cuando vertical-analyst escribe el reporte de análisis de la slice activa, o cuando vertical-writer lo lee para producir los 5 artefactos finales.
user-invocable: false
agent: vertical-analyst
---

## Ruta del archivo

`/050_vertical/VS-xx/slice_analysis_report.md`

El directorio `/050_vertical/VS-xx/` ya existe (creado por el governor en E10-A/E10-B).
Sustituir `VS-xx` por el ID real de la slice activa (ej. `/050_vertical/VS-02/slice_analysis_report.md`).

## Propósito del reporte

El slice_analysis_report es el puente entre los 17 inputs del 050 y los 5 artefactos finales.
Organiza y estructura lo que vertical-writer necesita para producir los 5 artefactos, **enfocado
exclusivamente en la slice activa**. No analiza el proyecto completo — filtra y acota todo a la
VS-xx activa.

Regla de no-inferencia: Todo lo que aparezca en este reporte debe ser trazable a uno de los 17
inputs. Nada se inventa. Si un dato no puede obtenerse de los inputs disponibles, se marca con
`[PENDIENTE: razón]` y se registra en Gaps.

## IDs canónicos del reporte

| Prefijo | Concepto | Origen |
|---------|----------|--------|
| IC-xx | Interface Contract de la slice activa | `030_design/contract_definitions.md` (I-5) |
| SC-xx | BDD Scenario (happy path) de la slice | `020_specification/bdd_features.md` (I-9) |
| SE-xx | BDD Scenario (error path) de la slice | `020_specification/bdd_features.md` (I-9) |
| MOD-xx | Módulo del technical_blueprint relevante para la slice | `030_design/technical_blueprint.md` (I-4) |
| RK-xx | Riesgo específico de la slice | `040_planning/risk_register.md` (I-3) |
| DEP-xx | Dependencia con otra slice | `030_design/dependency_graph.md` (I-6) |
| VS-xx | Slice predecesora con artefactos disponibles | `040_planning/project_roadmap.md` (I-2) |

## Estructura del reporte

```markdown
# Slice Analysis Report — 050 Vertical
Slice activa: [VS-xx] — [nombre de la slice]
Tipo: [Tracer Bullet | Crecimiento | MVP | Evolución | Robustez]
Fecha: [fecha]
Producido por: vertical-analyst
Iteración: [N]

## Inputs analizados

| Input | Path | Estado |
|-------|------|--------|
| vertical_slice_plan.md         | /040_planning/vertical_slice_plan.md         | leído |
| project_roadmap.md             | /040_planning/project_roadmap.md             | leído |
| risk_register.md               | /040_planning/risk_register.md               | leído |
| technical_blueprint.md         | /030_design/technical_blueprint.md           | leído |
| contract_definitions.md        | /030_design/contract_definitions.md          | leído |
| dependency_graph.md            | /030_design/dependency_graph.md              | leído |
| architecture_decision_records.md | /030_design/architecture_decision_records.md | leído |
| test_strategy_map.md           | /030_design/test_strategy_map.md             | leído |
| bdd_features.md                | /020_specification/bdd_features.md           | leído |
| data_contracts.md              | /020_specification/data_contracts.md         | leído |
| acceptance_criteria.md         | /020_specification/acceptance_criteria.md    | leído |
| error_exception_policy.md      | /020_specification/error_exception_policy.md | leído |
| shared_understanding.md        | /010_discovery/shared_understanding.md       | leído |
| domain_glossary.md             | /010_discovery/domain_glossary.md            | leído |
| scope_boundaries.md            | /010_discovery/scope_boundaries.md           | leído |
| failure_behavior.md            | /010_discovery/failure_behavior.md           | leído |
| artefactos previas (I-17)      | /050_vertical/VS-xx/*.md                     | leído / no existen |

## Sección 1 — Definición de la Slice Activa

(Extraído directamente de I-1: vertical_slice_plan.md, sección VS-xx.)

**Nombre:** [nombre de la slice]
**Tipo:** [tipo]
**IC-xx asignados:** [lista de IC-xx de I-1]
**BDD Scenarios asignados:** [lista de SC-xx/SE-xx de I-1]
**Criterio de Done:** [criterio de I-1]
**Esfuerzo estimado:** [XS/S/M/L/XL de I-1]
**Riesgos (RK-xx):** [lista de RK-xx de I-3 para esta slice]

### Slices predecesoras (de I-2)

| VS-xx predecesora | Estado en harness-state.json | Artefactos disponibles en /050_vertical/ |
|-------------------|------------------------------|------------------------------------------|
| VS-xx             | SLICE_COMPLETE               | proposal.md, sdd.md, ...                |
| VS-xx             | DOCS_READY                   | proposal.md, sdd.md, ...                |

(Si no hay predecesoras: escribir "Ninguna — slice sin dependencias".)

## Sección 2 — IC-xx de la Slice Activa

(Para cada IC-xx asignado a esta slice según I-1, extraer de I-5 la definición completa.)

### IC-xx completo

| Campo | Detalle |
|-------|---------|
| ID | IC-xx |
| Nombre de interfaz | I[Nombre] |
| Módulo asignado (I-4) | MOD-xx — [nombre del módulo] |
| Firma de métodos (I-5) | `[método1(params): ReturnType]`, `[método2(params): ReturnType]` |
| DTOs de request | [nombre del DTO con campos] |
| DTOs de response | [nombre del DTO con campos] |
| DTOs de error | [nombre del DTO de error con código HTTP] |
| Estrategia mock/stub (I-8) | Fake / Mock / Real — [descripción de la estrategia de I-8] |
| Dependencias DEP-xx (I-6) | [DEP-xx o "ninguna"] |

(Repetir subsección para cada IC-xx de la slice activa. Solo los IC-xx de esta slice — no de otras.)

### Verificación: todos los IC-xx de I-1 están cubiertos

| IC-xx de I-1 | Definición encontrada en I-5 | Estado |
|--------------|------------------------------|--------|
| IC-xx        | SÍ / NO                      | OK / GAP |

## Sección 3 — BDD Scenarios de la Slice Activa

(Para cada SC-xx/SE-xx asignado a esta slice según I-1, extraer de I-9 y I-11.)

### SC-xx / SE-xx completo

| Campo | Detalle |
|-------|---------|
| ID | SC-xx / SE-xx |
| Nombre del scenario | [nombre del BDD scenario] |
| Feature de origen (I-9) | [nombre de la Feature en bdd_features.md] |
| Given / When / Then (I-9) | [pasos BDD] |
| Criterio de aceptación (I-11) | [AC verificable] |
| IC-xx relacionados | [IC-xx que este scenario ejercita] |
| Código de error esperado (I-12) | [código HTTP + DTO de error, o "N/A"] |
| Política de error (I-12) | [política aplicable o "N/A"] |

(Repetir subsección para cada BDD scenario de la slice activa.)

### Verificación: todos los BDD scenarios de I-1 están cubiertos

| SC/SE-xx de I-1 | AC encontrado en I-11 | Política de error en I-12 | Estado |
|-----------------|----------------------|--------------------------|--------|
| SC-xx           | SÍ / NO              | SÍ / N/A                 | OK / GAP |

## Sección 4 — Riesgos Específicos de la Slice

(De I-3: risk_register.md, filtrado por VS-xx activa.)

| RK-xx | Descripción | Categoría | Probabilidad | Impacto | Mitigación |
|-------|-------------|-----------|--------------|---------|------------|
| RK-xx | [descripción] | [categoría] | Alta/Media/Baja | Alto/Medio/Bajo | [mitigación concreta] |

(Si no hay riesgos en I-3 para esta slice: escribir "Ninguno registrado en risk_register.md para [VS-xx]".)

## Sección 5 — Dependencias con Slices Previas

(De I-2: project_roadmap.md, DEP-xx relevantes de I-6.)

| Slice predecesora | IC-xx que aporta | DEP-xx | Impacto en la implementación |
|-------------------|-----------------|--------|------------------------------|
| VS-xx             | IC-xx           | DEP-xx | [qué necesita la slice activa de esta predecesora] |

(Si no hay dependencias: escribir "Ninguna — slice independiente".)

### Contexto de slices previas (de I-17)

(Resumir los hallazgos relevantes de los artefactos de slices anteriores en /050_vertical/ que
impactan la implementación de la slice activa. Ej.: decisiones de DI en VS-01 que VS-02 debe respetar.)

[Resumen de decisiones de implementación previas relevantes, o "No hay slices previas completadas".]

## Sección 6 — Restricciones y Contexto de Dominio

(Restricciones del proyecto que acotan la implementación de esta slice, de I-13, I-14, I-15, I-16.)

| Restricción | Fuente | Impacto en la slice |
|-------------|--------|---------------------|
| [restricción] | scope_boundaries.md (I-15) | [qué no se puede implementar] |
| [término] | domain_glossary.md (I-14) | [convención de naming a respetar] |
| [comportamiento de fallo] | failure_behavior.md (I-16) | [cómo manejar este fallo en la slice] |

### Stack tecnológico (de I-7 — ADR-001)

[Resumen del stack: lenguaje, framework, ORM, testing framework. El SDD debe respetar estas decisiones.]

## Gaps e Ítems de Escalamiento

(Si el analyst detectó problemas bloqueantes, listarlos aquí. Si no hay gaps, escribir "Ninguno".)

| ID | Gap identificado | Input afectado | Impacto en los artefactos | Acción requerida |
|----|-----------------|---------------|--------------------------|-----------------|
| GAP-01 | ... | contract_definitions.md | IC-xx de la slice sin definición de métodos | Escalar al governor |

## Verificación del Demo Statement (self-checklist)

Antes de reportar COMPLETED, verificar cada condición del Demo Statement:

- [ ] `050_vertical/[VS-xx]/slice_analysis_report.md` existe en disco (Write ejecutado como primer tool call — LL-01)
- [ ] Sección 2 contiene definición completa de cada IC-xx asignado a la slice (de I-1 y I-5)
- [ ] Sección 3 contiene AC y política de error para cada BDD scenario de la slice (de I-9, I-11, I-12)
- [ ] Sección 4 lista los riesgos RK-xx específicos de la slice (de I-3)
- [ ] Sección 5 documenta las dependencias con slices previas (de I-2)
- [ ] Sección 6 incluye restricciones de scope y stack tecnológico del ADR-001 (de I-7, I-15)
- [ ] Tabla de Gaps completa (o "Ninguno" explícito)

Si todas las condiciones se verifican: reportar `COMPLETED` con path al archivo.
Si alguna condición falla: reportar `INCOMPLETO: <razón específica>`. No reportar COMPLETED.

## Cobertura

```
Slice activa: [VS-xx]
IC-xx en la slice (de I-1): [N]
IC-xx con definición completa en I-5: [N]
IC-xx sin definición (GAP): [N]
BDD scenarios en la slice (de I-1): [N]
BDD scenarios con AC en I-11: [N]
BDD scenarios sin AC (GAP): [N]
Riesgos RK-xx para esta slice: [N]
Dependencias con slices previas: [N]
Gaps de escalamiento: [N]
```

## Estado del análisis

`LISTO PARA WRITER` | `ESCALAMIENTO REQUERIDO — [N] gaps bloqueantes`
```

## Reglas de escritura

- **El Write de `/050_vertical/VS-xx/slice_analysis_report.md` es el primer tool call** después de
  completar el análisis. Sin excepción. No reportar COMPLETED antes de haber escrito el archivo.
- Solo incluir IC-xx que pertenecen a la slice activa según I-1. No analizar IC-xx de otras slices.
- Solo incluir BDD scenarios que pertenecen a la slice activa según I-1.
- El path del archivo incluye el ID real de la slice (ej. `050_vertical/VS-02/slice_analysis_report.md`).
- No inventar IC-xx, métodos ni DTOs. Si no están en I-5, marcar como GAP.
- No inventar BDD scenarios. Solo los asignados a la slice en I-1 y definidos en I-9.
- Usar exclusivamente los términos del `domain_glossary.md` (I-14). Si un término técnico no está
  en el glosario, incluirlo con nota "(término técnico — no en glosario)".
