---
name: design-analysis-schema
description: Schema y formato del archivo design_analysis_report.md del 030 Design Harness. Usar cuando design-analyst escribe el reporte o cuando design-architect lo lee para producir los 5 artefactos finales.
user-invocable: false
agent: design-analyst
---

## Ruta del archivo

`/030_design/design_analysis_report.md`

## Propósito del reporte

El design_analysis_report es el puente entre los 8 inputs del 030 y los 5 artefactos finales.
No produce diseño — organiza y estructura lo que el design-architect necesita para producirlo.
Todo lo que aparezca en este reporte debe ser trazable a uno de los 8 inputs; nada se infiere
ni se inventa. El design-architect no consulta los inputs originales directamente — trabaja
exclusivamente desde este reporte.

## IDs canónicos del reporte

| Prefijo | Concepto | Ejemplo |
|---------|----------|---------|
| CO-xx | Componente / bounded context identificado | CO-01 |
| IC-xx | Interface requerida (derivada de una entidad de data_contracts.md) | IC-03 |
| PT-xx | Patrón de diseño propuesto con justificación | PT-02 |
| RT-xx | Restricción tecnológica (derivada de scope_boundaries.md o shared_understanding.md) | RT-01 |

## Estructura del reporte

```markdown
# Design Analysis Report — 030 Design
Fecha: [fecha]
Producido por: design-analyst
Iteración: [N]

## Inputs analizados

| Input | Path | Estado |
|-------|------|--------|
| bdd_features.md          | /020_specification/bdd_features.md           | leído |
| data_contracts.md        | /020_specification/data_contracts.md         | leído |
| acceptance_criteria.md   | /020_specification/acceptance_criteria.md    | leído |
| error_exception_policy.md| /020_specification/error_exception_policy.md | leído |
| shared_understanding.md  | /010_discovery/shared_understanding.md       | leído |
| domain_glossary.md       | /010_discovery/domain_glossary.md            | leído |
| scope_boundaries.md      | /010_discovery/scope_boundaries.md           | leído |
| failure_behavior.md      | /010_discovery/failure_behavior.md           | leído |

## Bounded Contexts y Componentes (CO-xx)

(Extraídos de bdd_features.md. Cada bounded context del 020 debe tener ≥1 componente.
Usar los términos del domain_glossary.md.)

| ID    | Componente / Bounded Context | Descripción | Actores que interactúan | Fuente en bdd_features |
|-------|------------------------------|-------------|------------------------|----------------------|
| CO-01 | ...                          | ...         | [lista de actores]     | [Feature / Scenario] |

### Responsabilidades por Componente

#### CO-01 — [Nombre del Componente]

| Responsabilidad | Derivada de | Restricciones de scope |
|-----------------|-------------|----------------------|
| ...             | [BDD Scenario / AC-xx] | [scope_boundaries si aplica] |

[repetir por cada componente]

## Interfaces Requeridas (IC-xx)

(Una interface requerida por cada entidad de data_contracts.md que necesita un "puerto"
hacia el exterior: repositorios, servicios externos, notificaciones, APIs. El design-architect
usará estas IC-xx como base para los IC-xx de contract_definitions.md.)

| ID    | Interface requerida | Entidad origen en data_contracts | Tipo | Operaciones esperadas | Componente propietario |
|-------|--------------------|---------------------------------|------|----------------------|----------------------|
| IC-01 | IProductoRepository | Producto                        | Repository | findById, save, listByStock | CO-01 |
| IC-02 | ...                | ...                             | Service / Repository / Notifier / API | ... | ... |

**Tipos de interface:**
- `Repository` — acceso a persistencia de una entidad
- `Service` — lógica de negocio desacoplada de infraestructura
- `Notifier` — envío de notificaciones / mensajes / alertas
- `API` — contrato de entrada/salida hacia clientes externos

### Interfaces de Manejo de Errores

(Derivadas de error_exception_policy.md. Identificar si se requieren interfaces de manejo
centralizado de excepciones o DTOs de error por bounded context.)

| ID    | Interface / DTO de error | Política origen en error_exception_policy | Componente afectado |
|-------|-------------------------|------------------------------------------|-------------------|
| IC-xx | ...                     | ...                                      | CO-xx |

## Restricciones Tecnológicas (RT-xx)

(Extraídas de scope_boundaries.md y shared_understanding.md. Acotan la selección de stack
del design-architect. No son recomendaciones — son límites que el ADR-001 debe respetar.)

| ID    | Restricción | Tipo | Fuente | Impacto en el stack |
|-------|-------------|------|--------|-------------------|
| RT-01 | ...         | Lenguaje / Framework / Infraestructura / Plataforma / Presupuesto | scope_boundaries / shared_understanding | ... |

### Criterios de Selección de Stack

(Síntesis de las restricciones RT-xx para orientar al design-architect al redactar ADR-001.
No se elige el stack aquí — se identifican los criterios de evaluación.)

| Criterio | Derivado de | Peso sugerido |
|----------|-------------|--------------|
| ...      | RT-xx       | alto / medio / bajo |

## Patrones de Diseño Propuestos (PT-xx)

(Cada patrón debe tener una justificación trazable a un problema técnico identificado en los
inputs. El design-architect decide si adoptar cada patrón al producir los artefactos finales.)

| ID    | Patrón | Problema que resuelve | Componentes donde aplica | Fuente del problema |
|-------|--------|----------------------|--------------------------|-------------------|
| PT-01 | Repository | Desacoplar la lógica de dominio del motor de persistencia | CO-xx | IC-xx + data_contracts.md |
| PT-02 | Strategy | Variaciones de reglas de negocio detectadas en bdd_features | CO-xx | BDD Scenario [nombre] |
| PT-03 | ...    | ...                  | ...                      | ... |

### Notas de Testabilidad por Patrón

| Patrón (PT-xx) | Punto de inyección de dependencia | Estrategia de mock/stub sugerida |
|----------------|----------------------------------|----------------------------------|
| PT-01          | Constructor / setter del servicio | Mock del repository con respuesta configurable |
| PT-xx          | ...                              | ... |

## Análisis de Capas Arquitectónicas

(Identificación de las capas del sistema derivadas del modelado del dominio.
Guía al design-architect para construir technical_blueprint.md con desacoplamiento real.)

| Capa | Responsabilidad | Componentes asignados (CO-xx) | Restricciones de dependencia |
|------|-----------------|------------------------------|------------------------------|
| Dominio | Lógica de negocio pura, sin dependencias de infraestructura | CO-xx, CO-xx | No puede importar capas de Infraestructura |
| Aplicación | Orquestación de casos de uso; invoca interfaces (IC-xx) | CO-xx | Solo depende de Dominio e interfaces |
| Infraestructura | Implementaciones concretas de IC-xx (DB, API, Notifier) | CO-xx | Implementa contratos de Aplicación |

## Flujos de Datos Técnicos

(Por cada bounded context principal, describir el flujo desde la entrada hasta la persistencia.
El design-architect lo usará para construir dependency_graph.md.)

### CO-01 — [Nombre del Componente]

```
[Entrada: API / evento / trigger]
  → [Handler / Controller] (Capa Aplicación)
  → [Caso de uso / Service] (Capa Dominio)
  → [IC-xx] (puerto hacia infraestructura)
  → [Implementación concreta] (Capa Infraestructura)
  → [Persistencia / Notificación / Respuesta]
```
Trazable a: [BDD Scenario nombre]

[repetir por cada componente principal]

## Gaps e Ítems de Escalamiento

(Si el analyst detectó ambigüedades irresolubles en los inputs, listarlos aquí.
Si no hay gaps, escribir "Ninguno".)

| ID    | Gap identificado | Input afectado | Impacto en el diseño | Acción requerida |
|-------|-----------------|---------------|----------------------|-----------------|
| GAP-01 | ...            | data_contracts.md | No se puede definir IC-xx sin resolución | Escalar al governor antes de continuar |

## Verificación del Demo Statement (self-checklist)

Antes de reportar COMPLETED, verificar cada condición:

- [ ] `030_design/design_analysis_report.md` existe en disco (Write ejecutado como primer tool call)
- [ ] ≥1 CO-xx por cada bounded context identificado en `bdd_features.md`
- [ ] ≥1 IC-xx por cada entidad de `data_contracts.md` que requiere interface
- [ ] ≥1 PT-xx con justificación trazable a un problema de los inputs
- [ ] ≥1 RT-xx derivada de `scope_boundaries.md`
- [ ] Tabla de Gaps completa (o "Ninguno" explícito)

Si todas las condiciones se verifican: reportar `COMPLETED` con path al archivo.
Si alguna condición falla: reportar `INCOMPLETO: <razón específica>`. No reportar COMPLETED.

## Cobertura

```
Iteración de análisis: [N]
Bounded contexts / componentes identificados: [N]
Interfaces requeridas: [N]
Restricciones tecnológicas: [N]
Patrones de diseño propuestos: [N]
Flujos de datos documentados: [N]
Gaps de escalamiento: [N]
```

## Estado del análisis

`LISTO PARA ARCHITECT` | `ESCALAMIENTO REQUERIDO — [N] gaps bloqueantes`
```

## Reglas de escritura

- **El Write de `030_design/design_analysis_report.md` es el primer tool call** después de
  completar el análisis. Sin excepción. No reportar COMPLETED antes de haber escrito el archivo.
- Asignar IDs secuenciales: componentes `CO-01`, interfaces `IC-01`, restricciones `RT-01`,
  patrones `PT-01`, gaps `GAP-01`.
- Usar exclusivamente los términos del `domain_glossary.md`. Si un concepto técnico no aparece
  en el glosario pero es necesario, incluirlo con nota "(término técnico — no en glosario)".
- No inventar restricciones tecnológicas ni interfaces. Solo lo derivable de los 8 inputs.
- Un gap irresolublecon impacto en diseño → registrar en Gaps e ítems de escalamiento y
  marcar Estado como `ESCALAMIENTO REQUERIDO`.
- Las exclusiones de `scope_boundaries.md` son límites duros — el architect no puede diseñar
  componentes ni interfaces para lo que esté excluido.
- Las operaciones listadas en IC-xx son sugeridas, no definitivas. El design-architect puede
  ajustarlas al producir contract_definitions.md, siempre que mantenga trazabilidad con la
  entidad origen.
