# Plan de Construcción — 050 Vertical Harness

## Meta

Construir el harness completo para la fase Vertical implementando el Patrón Universal de Fase
de `Insumos/metodologia.md`. Este plan es el blueprint que guía la construcción del harness
operativo completo.

El 050 toma el plan maestro del 040 (`040_planning/vertical_slice_plan.md`) y trabaja
**una slice a la vez**: produce los 5 artefactos de implementación para la slice activa,
el cliente los aprueba, y el harness hace handoff al 060 Isolation para ejecutar esa slice.
Al completar el ciclo 060→070 para la slice, el 050 retoma la siguiente. El harness corre
**N veces** — una por cada VS-xx del plan maestro.

### Checklist de completitud

El harness completo debe contener estas 7 secciones:
- [ ] Fase 0 — Definición Estructural
- [ ] Fase 1 — Diseño Agéntico (6 sub-secciones)
- [ ] Sprint Contract (plantilla)
- [ ] Workers Especializados
- [ ] Rúbrica de Evaluación (con few-shot y anclas)
- [ ] Handoff Artifact → 060
- [ ] Flujo del Arnés (12.1–12.5)

---

## Sección 1 — Fase 0: Definición Estructural

### Propósito

Transformar el plan maestro del 040 en artefactos de implementación concretos y accionables,
slice por slice. El Vertical Harness no diseña arquitectura ni planifica el proyecto global —
especifica e implementa **una sola slice** cada vez que corre. Sus 5 artefactos son la fuente
de verdad para el 060 Isolation y el 070 Development:

1. Determina qué hace la slice (Proposal + SDS).
2. Define cómo se construye técnicamente (SDD).
3. Especifica cómo se prueba bajo TDD (Testing Plan).
4. Descompone la construcción en Features → Tickets → Tasks accionables (Execution Plan).

### Precondición obligatoria

El 050 no puede iniciarse sin que el 040 esté `PHASE_COMPLETE` en `harness-state.json`
bajo la clave `"040_planning"`. Si el 040 no está completo, el vertical-governor debe
detener el flujo y notificar al humano.

### Naturaleza iterativa

El 050 corre **N veces**, una por cada VS-xx del `vertical_slice_plan.md`. En cada
invocación trabaja **una sola slice activa**. El estado de cada slice se persiste en
`harness-state.json` bajo la clave `"050_vertical.slices"`:

| Estado por slice | Significado |
|-----------------|-------------|
| `PENDING`        | Sin iniciar — los 5 documentos aún no han sido producidos |
| `DOCS_READY`     | Los 5 artefactos están producidos, aprobados y evaluados — esperando 060+070 |
| `SLICE_COMPLETE` | El ciclo completo 050→060→070 terminó para esta slice |

El 050 marca `PHASE_COMPLETE` cuando todas las VS-xx del `project_roadmap.md` están en `SLICE_COMPLETE`.

### Inputs

El 050 hereda **todos** los artefactos producidos por los harnesses anteriores. Para la
**slice activa**, los inputs primarios son:

| # | Input | Fuente | Descripción |
|---|-------|--------|-------------|
| I-1 | `vertical_slice_plan.md` | `/040_planning/` | **Principal** — Definición formal de la slice activa: IC-xx, BDD scenarios, Criterio de Done, esfuerzo |
| I-2 | `project_roadmap.md` | `/040_planning/` | Secuencia y dependencias entre slices — contexto de qué viene antes y después |
| I-3 | `risk_register.md` | `/040_planning/` | Riesgos específicos de la slice activa (RK-xx) |
| I-4 | `technical_blueprint.md` | `/030_design/` | Módulos (MOD-xx) y estructura de capas relevantes para la slice |
| I-5 | `contract_definitions.md` | `/030_design/` | Interfaces (IC-xx) y DTOs a implementar en esta slice |
| I-6 | `dependency_graph.md` | `/030_design/` | DEP-xx: dependencias de componentes que afectan la slice |
| I-7 | `architecture_decision_records.md` | `/030_design/` | Stack y patrones decididos — el SDD debe respetarlos |
| I-8 | `test_strategy_map.md` | `/030_design/` | Mock/stub strategy por IC-xx — base para el Testing Plan |
| I-9 | `bdd_features.md` | `/020_specification/` | BDD scenarios (SC-xx/SE-xx) asignados a la slice activa |
| I-10 | `data_contracts.md` | `/020_specification/` | Entidades relevantes para la slice activa |
| I-11 | `acceptance_criteria.md` | `/020_specification/` | AC de los BDD scenarios de la slice activa |
| I-12 | `error_exception_policy.md` | `/020_specification/` | Políticas de error aplicables a la slice activa |
| I-13 | `shared_understanding.md` | `/010_discovery/` | Contexto de dominio y restricciones del proyecto |
| I-14 | `domain_glossary.md` | `/010_discovery/` | Lenguaje ubicuo — todos los artefactos del 050 deben usarlo |
| I-15 | `scope_boundaries.md` | `/010_discovery/` | Restricciones que acotan la implementación |
| I-16 | `failure_behavior.md` | `/010_discovery/` | Comportamientos de fallo ya resueltos |
| I-17 | `050_vertical/VS-xx/*.md` (previas) | `/050_vertical/` | Artefactos de slices ya completadas — contexto de implementación acumulado |

### Proceso (5 pasos)

1. **Identificación y contextualización de la slice activa** — Leer I-1 para extraer la
   definición completa de la slice activa: nombre, tipo, lista de IC-xx, lista de BDD
   scenarios, Criterio de Done y esfuerzo. Leer I-2 para identificar slices predecesoras
   y cuáles de sus artefactos ya están disponibles en `050_vertical/`. Leer I-3 para los
   riesgos específicos de esta slice.

2. **Análisis técnico de la slice** — Para los IC-xx de la slice activa: leer sus definiciones
   en I-5 (firmas de métodos, DTOs), sus estrategias de mock en I-8, y sus módulos en I-4.
   Para los BDD scenarios: leer sus AC en I-11 y sus políticas de error en I-12. Producir el
   `slice_analysis_report.md` con toda la información organizada y acotada a la slice activa.

3. **Producción del Proposal y SDS** — El Proposal describe el valor de negocio de la slice,
   su scope (IC-xx + BDD scenarios), dependencias con otras slices y riesgos. El SDS especifica
   funcionalmente qué debe hacer la slice: flujos de usuario por BDD scenario, contratos de
   datos, comportamiento de errores y criterios de aceptación verificables.

4. **Producción del SDD y Testing Plan** — El SDD describe CÓMO implementar la slice: qué
   módulos tocará, cuáles IC-xx implementará (con firma técnica), qué DTOs usará, cómo se
   inyectan las dependencias, en qué orden se implementan los componentes. El Testing Plan
   convierte los BDD scenarios en tests concretos siguiendo la estrategia de mock de I-8:
   qué se prueba con unitarios, qué con integración, qué con contrato.

5. **Producción del Execution Plan** — Descomponer el SDD en Features → Tickets → Tasks con
   orden TDD (Red → Green → Refactor por task). Cada task cita el IC-xx o SC-xx/SE-xx que
   implementa. Cada ticket tiene un Criterio de Done verificable. El Execution Plan es la
   fuente de verdad para el 060 Isolation y el 070 Development.

### Outputs (artefactos)

| Artefacto | Path | Descripción |
|-----------|------|-------------|
| Proposal | `/050_vertical/VS-xx/proposal.md` | Valor de negocio, scope (IC-xx + BDD), dependencias y riesgos de la slice |
| Software Design Specification | `/050_vertical/VS-xx/software_design_specification.md` | QUÉ hace la slice: flujos BDD, contratos de datos, comportamiento de errores, AC verificables |
| Software Design Document | `/050_vertical/VS-xx/software_design_document.md` | CÓMO se implementa: módulos, IC-xx con firmas, DTOs, DI, orden de implementación |
| Testing Plan | `/050_vertical/VS-xx/testing_plan.md` | Estrategia TDD: BDD→tests, mock/stub por IC-xx, pirámide de tests (unitario/integración/contrato) |
| Execution Plan | `/050_vertical/VS-xx/execution_plan.md` | Features → Tickets → Tasks en orden TDD (Red→Green→Refactor), IC-xx y SC-xx por task |

Artefacto intermedio (no entregado al 060):
- `/050_vertical/VS-xx/slice_analysis_report.md` — producido por vertical-analyst, consumido por vertical-writer

**Nota sobre el path de salida:** `VS-xx` es el ID de la slice activa (ej. `VS-03`).
Cada slice tiene su propia subcarpeta en `/050_vertical/`.

### Criterio de Done (por slice)

La slice se considera `DOCS_READY` cuando se cumplen **todas** las condiciones:
1. Los 5 artefactos existen en `/050_vertical/VS-xx/` y tienen contenido.
2. `proposal.md` cita los IC-xx y BDD scenarios de la slice tal como aparecen en I-1.
3. `software_design_specification.md` cubre todos los BDD scenarios asignados a la slice en I-9.
4. `software_design_document.md` referencia solo IC-xx definidos en I-5 y módulos de I-4.
5. `testing_plan.md` tiene ≥1 estrategia de test por IC-xx de la slice, consistente con I-8.
6. `execution_plan.md` tiene todos los IC-xx de la slice asignados a ≥1 task en orden TDD.
7. El cliente ha aprobado explícitamente los artefactos en CP-04.

### Criterio de Done (harness completo)

El 050 marca `PHASE_COMPLETE` cuando todas las VS-xx del `project_roadmap.md` tienen estado
`SLICE_COMPLETE` en `harness-state.json`.

### Tipo de artefacto y ciclo adaptado

Vertical produce **artefactos de implementación por slice** — una combinación de especificación,
diseño técnico y planificación táctica. El ciclo SDD+TDD se adapta así:

| Ciclo estándar | Adaptación para Vertical |
|----------------|--------------------------|
| SPEC | Análisis de la slice activa: IC-xx, BDD scenarios, riesgos, dependencias con slices previas |
| HUMAN REVIEW | Cliente aprueba los 5 artefactos en CP-03: scope, enfoque técnico, plan de ejecución |
| RED | Demo Statements: "cuando termine, podré observar que todos los IC-xx de la slice tienen estrategia de implementación y test" |
| GREEN | Artefactos producidos por Workers |
| REFACTOR | Verificación de lenguaje ubicuo, consistencia entre los 5 artefactos y con I-5, I-8, I-9 |
| EVAL | Auditoría de C con rúbrica D1-D5 |

---

## Sección 2 — Fase 1: Diseño Agéntico

### 2.1 Instancias y Roles

| Instancia | Agente | Rol | Responsabilidades | Escribe en |
|-----------|--------|-----|-------------------|------------|
| A — Governor | `vertical-governor` | Director de Slice | Verifica precondición del 040; determina slice activa; propone Sprint Contract por slice; gestiona CP-03 y CP-04; coordina ciclo 050→060→070 | `persistence/harness-state.json` |
| B — Orchestrator | `vertical-orchestrator` | Capataz Técnico | Lee contrato; escribe Demo Statements en orchestration_plan; persiste plan antes de spawear; registra checkpoints; verifica artefactos en disco (Pending Verification) | `persistence/execution-state.json` |
| C — Evaluator | `vertical-evaluator` | Auditor Independiente | Lee los 5 artefactos de la slice sin contexto de ejecución; aplica rúbrica; emite APPROVED/REJECTED | `eval/verdict.json`, `eval/metrics_summary.json` |

Jerarquía de llamadas (nunca se viola):
- A → B (para ejecutar), A → C (para auditar). Nunca simultáneo.
- **A spawnea Workers directamente** (LL-21).
- C NO llama a nadie. Solo lee del filesystem.

**Nota arquitectónica (LL-21):** El governor spawnea los Workers directamente (vertical-analyst,
vertical-writer). El orchestrator opera en modos PLAN/CHECKPOINT: persiste el estado pero no
spawnea Workers.

**Todos los agentes son exclusivos del 050.** No comparten ni heredan instrucciones de harnesses anteriores.

### 2.2 Workers Especializados

| Worker | Micro-tarea | Inputs que recibe | Output (path) |
|--------|-------------|-------------------|---------------|
| `vertical-analyst` | Lee los inputs I-1..I-17 enfocándose en la slice activa. Extrae: IC-xx de la slice, BDD scenarios de la slice, datos relevantes, políticas de error, riesgos específicos (RK-xx), artefactos de slices previas como contexto. Produce slice_analysis_report.md | Paths a I-1..I-17 + ID de slice activa | `/050_vertical/VS-xx/slice_analysis_report.md` |
| `vertical-writer` | Lee slice_analysis_report.md + inputs de referencia. Produce los 5 artefactos finales en orden. | Path a slice_analysis_report.md + paths a I-1, I-5, I-7, I-8, I-9, I-14 | `/050_vertical/VS-xx/proposal.md`, `software_design_specification.md`, `software_design_document.md`, `testing_plan.md`, `execution_plan.md` |

**Secuenciación:** vertical-analyst → vertical-writer (dependencia estricta, no paralela).

Cada Worker escribe sus artefactos al filesystem y reporta a A **solo el path**, nunca el
contenido (E6 — Regla de Referencias Ligeras).

### Demo Statements (ADJ-13 — obligatorio)

El vertical-orchestrator (modo PLAN) escribe un Demo Statement por Worker en el `orchestration_plan`
antes de que el governor spawnee ningún Worker.

**Demo Statement para vertical-analyst:**
> "Cuando vertical-analyst termine, podré observar que `050_vertical/[VS-xx]/slice_analysis_report.md`
> existe y contiene: (a) lista de IC-xx asignados a la slice activa extraída de I-1 y I-5;
> (b) lista de BDD scenarios (SC-xx/SE-xx) asignados a la slice extraída de I-1 y I-9;
> (c) riesgos específicos de la slice extraídos de I-3 (RK-xx); (d) dependencias con slices
> previas extraídas de I-2; (e) políticas de error relevantes de I-12 por cada IC-xx o BDD
> scenario de la slice."

**Demo Statement para vertical-writer:**
> "Cuando vertical-writer termine, podré observar que: `proposal.md` cita los IC-xx y BDD
> scenarios de la slice y describe el valor de negocio; `software_design_specification.md`
> tiene ≥1 sección por BDD scenario de la slice con flujo, datos y AC verificables;
> `software_design_document.md` referencia solo IC-xx de I-5 e incluye firma técnica y
> estrategia de DI para cada uno; `testing_plan.md` tiene ≥1 estrategia de test por IC-xx
> consistente con I-8; `execution_plan.md` descompone la slice en Features → Tickets →
> Tasks en orden TDD (Red→Green→Refactor), con todos los IC-xx asignados a ≥1 task."

Cada Worker ejecuta un self-checklist contra su Demo Statement al terminar.
- Si puede verificar todas las condiciones: reporta `COMPLETED`.
- Si no puede: reporta `INCOMPLETO: <razón específica>`. No reporta COMPLETED si alguna condición falla.

### Pending Verification (ADJ-13)

Después de que un Worker reporta COMPLETED, el orchestrator (en modo CHECKPOINT) verifica en
disco que el artefacto esperado existe y tiene contenido antes de registrar el checkpoint.
- Si el artefacto no existe o está vacío: retornar `CHECKPOINT_FAILED` al governor.
- Solo si el artefacto existe en disco: registrar el checkpoint y retornar `CHECKPOINT_OK`.

El governor, al recibir `CHECKPOINT_FAILED`, no spawnea el siguiente Worker. Registra
`WORKER_FAILED` en execution-state.json y escala al humano.

### 2.3 Política de Herramientas (P7)

| Agente | Herramientas permitidas | Restricciones |
|--------|------------------------|---------------|
| vertical-governor | Read, Write, Bash, Agent, AskUserQuestion | NUNCA escribe en `/050_vertical/` directamente |
| vertical-orchestrator | Read, Write | NUNCA escribe en `/050_vertical/`; solo en `persistence/execution-state.json` |
| vertical-analyst | Read, Write | Solo produce `/050_vertical/VS-xx/slice_analysis_report.md` |
| vertical-writer | Read, Write, Edit | Produce los 5 artefactos en `/050_vertical/VS-xx/`; puede editar para corregir antes del self-checklist |
| vertical-reviewer | Read, Write | Lee de `/050_vertical/VS-xx/` y artefactos del 030/020; escribe solo `050_vertical/VS-xx/review_report.md` |
| vertical-evaluator | Read, Write | Lee de `/050_vertical/VS-xx/` y artefactos de referencia; escribe solo en `eval/` |

Política de Fallback ante fallo de herramienta (3 niveles — E5):
1. **Reintento** (hasta 2x): reintentar si falla por error transitorio.
2. **Fallback**: si no se puede derivar un dato de los inputs, marcarlo con `[PENDIENTE: razón]`
   en el artefacto y continuar con los demás ítems.
3. **Escalamiento**: registrar en `execution-state.json` bajo `worker_errors`, notificar a A.
   A escala al humano vía `AskUserQuestion`. Sin inventar información de implementación.

### 2.4 Política de Escalamiento (P6, E8)

Escalar al humano (detener flujo) en los siguientes casos:
- Los IC-xx asignados a la slice activa no existen en `contract_definitions.md` (inconsistencia del 040).
- Un BDD scenario asignado a la slice no tiene AC en `acceptance_criteria.md`.
- La slice activa tiene dependencias con una slice predecesora que no está en estado `SLICE_COMPLETE`.
- El vertical-writer no puede producir el SDD porque los ADR o el technical_blueprint son
  insuficientes para los IC-xx de la slice.
- El cliente rechaza la estructura de la slice y solicita reformular su scope — escalar al
  100 Change Harness si el cambio afecta el plan maestro del 040.

En todos los casos: A registra el bloqueo en `harness-state.json` bajo `escalations` y
notifica al humano con contexto completo.

### 2.5 Checkpoints Canónicos (E5)

| ID | Momento | Qué persiste B |
|----|---------|----------------|
| CP-01 | Tras vertical-analyst | Path a `050_vertical/VS-xx/slice_analysis_report.md` en execution-state.json |
| CP-02 | Tras vertical-writer (draft) | Paths a los 5 artefactos en execution-state.json; marca `EXECUTION_COMPLETE` |
| CP-03 | Cliente revisa draft | A presenta los 5 artefactos al cliente; registra feedback en `harness-state.json` |
| CP-04 | Cliente aprueba formalmente | A registra aprobación en `harness-state.json`; spawnea C para auditoría |

### 2.6 Trigger de Context Reset (E2)

Criterios (el que ocurra primero):

- **Conductual (primario):** señales de ansiedad contextual: referenciar IC-xx que no están
  en la slice activa, mezclar BDD scenarios de otra slice, producir SDD inconsistente con el
  stack del ADR-001, declarar artefactos COMPLETED sin ejecutar el self-checklist.
- **Cuantitativo (secundario):** ≥70% de tokens usados.

Acción ante reset: continuar desde el último checkpoint guardado en `execution-state.json`
usando el Ritual E10-B (Continuación). Nunca reiniciar desde cero.

---

## Sección 3 — Sprint Contract (Plantilla)

Template que A propone al humano **por cada slice activa** antes de spawear B. Requiere aprobación explícita.

```
SPRINT CONTRACT — 050 Vertical Harness
=====================================
Objetivo    : Producir los 5 artefactos de implementación para la slice activa [VS-xx].
Fase        : 050 — Vertical
Slice activa: [VS-xx] — [nombre de la slice] ([tipo: TB / Crecimiento / MVP / Evolución / Robustez])
Modo        : [INICIO DE SLICE | CONTINUACIÓN DE SLICE]
Precondición: 040 Planning — PHASE_COMPLETE ✓
              Slices predecesoras con estado SLICE_COMPLETE: [lista o "ninguna"]

Scope de la slice [VS-xx]:
  IC-xx asignados : [lista de IC-xx extraída de vertical_slice_plan.md]
  BDD scenarios   : [lista de SC-xx/SE-xx de la slice]
  Criterio de Done: [criterio del plan maestro para esta slice]
  Esfuerzo (040)  : [XS/S/M/L/XL]
  Riesgos (RK-xx) : [lista de RK-xx del risk_register para esta slice]

Inputs disponibles:
  Desde /040_planning/:
  - vertical_slice_plan.md       : [confirmado — slice [VS-xx] definida]
  - project_roadmap.md           : [confirmado]
  - risk_register.md             : [confirmado — [N] riesgos para [VS-xx]]
  Desde /030_design/:
  - technical_blueprint.md       : [confirmado — módulos relevantes: MOD-xx...]
  - contract_definitions.md      : [confirmado — IC-xx de la slice: ...]
  - dependency_graph.md          : [confirmado]
  - architecture_decision_records.md: [confirmado — stack: ...]
  - test_strategy_map.md         : [confirmado — estrategias mock para IC-xx de la slice]
  Desde /020_specification/:
  - bdd_features.md              : [confirmado — BDD de la slice: SC-xx...]
  - data_contracts.md            : [confirmado]
  - acceptance_criteria.md       : [confirmado]
  - error_exception_policy.md    : [confirmado]
  Desde /010_discovery/:
  - shared_understanding.md      : [confirmado]
  - domain_glossary.md           : [confirmado]
  - scope_boundaries.md          : [confirmado]
  - failure_behavior.md          : [confirmado]

Workers activados:
  - vertical-analyst → /050_vertical/[VS-xx]/slice_analysis_report.md
  - vertical-writer  → /050_vertical/[VS-xx]/proposal.md
                       /050_vertical/[VS-xx]/software_design_specification.md
                       /050_vertical/[VS-xx]/software_design_document.md
                       /050_vertical/[VS-xx]/testing_plan.md
                       /050_vertical/[VS-xx]/execution_plan.md

Checkpoints : CP-01, CP-02, CP-03, CP-04
Criterio Done (esta slice):
  (1) Los 5 artefactos existen en /050_vertical/[VS-xx]/ con contenido
  (2) SDS cubre todos los BDD scenarios de la slice
  (3) SDD referencia solo IC-xx de la slice definidos en contract_definitions.md
  (4) Testing Plan tiene ≥1 estrategia de test por IC-xx, consistente con test_strategy_map.md
  (5) Execution Plan descompone todos los IC-xx en tasks TDD (Red→Green→Refactor)
  (6) Aprobación explícita del cliente en CP-04

Próxima acción: spawear vertical-orchestrator en modo PLAN para persistir el orchestration_plan
```

---

## Sección 4 — Rúbrica de Evaluación (Instancia C)

### Dimensiones de evaluación

| ID | Dimensión | Descripción | Score |
|----|-----------|-------------|-------|
| D1 | Proposal & SDS Coverage | `proposal.md` cita todos los IC-xx y BDD scenarios de la slice según `vertical_slice_plan.md`. `software_design_specification.md` tiene ≥1 sección por BDD scenario con flujo, contrato de datos y AC verificables. Sin BDD scenarios huérfanos | 0.0–1.0 |
| D2 | SDD Technical Depth | `software_design_document.md` referencia solo IC-xx de la slice definidos en `contract_definitions.md`. Cada IC-xx tiene firma técnica, módulo asignado (MOD-xx) y estrategia de DI. Consistente con el stack del ADR-001 | 0.0–1.0 |
| D3 | Testing Plan TDD Traceability | `testing_plan.md` tiene ≥1 estrategia de test por IC-xx de la slice, consistente con la estrategia mock/stub de `test_strategy_map.md`. Define los tres niveles (unitario, integración, contrato) y el orden Red→Green de las pruebas | 0.0–1.0 |
| D4 | Execution Plan Actionability | `execution_plan.md` descompone la slice en Features → Tickets → Tasks. Cada Task cita el IC-xx o SC-xx/SE-xx que implementa. Todos los IC-xx de la slice están en ≥1 Task. Orden TDD explícito (Red→Green→Refactor). Criterio de Done verificable por Ticket | 0.0–1.0 |
| D5 | Consistency | Sin contradicciones entre los 5 artefactos. Sin IC-xx referenciados que no existan en `contract_definitions.md`. Sin BDD scenarios referenciados que no existan en `bdd_features.md`. Lenguaje ubicuo del glosario usado consistentemente | 0.0–1.0 |

**Gate de paso:** Score promedio ≥ 0.75 en todas las dimensiones.
**Regla de veto:** Si D5 = 0.0, rechazo automático independientemente de otras dimensiones.

**Nota:** La rúbrica se aplica **por slice**. Cada entrada en `eval/verdict.json` incluye el
ID de la slice evaluada (`"slice_id": "VS-xx"`).

### Anclas de calibración (few-shot — E3)

> Dominio de referencia: Sistema de Reservas para Restaurante "La Terraza"
> (de Test_Harness_002). Slices hipotéticas: VS-01 Tracer Bullet (login + GET /reservas/{id}),
> VS-02 Crecimiento (CRUD reservas), VS-03 MVP (notificaciones + confirmaciones),
> VS-04 Evolución (historial + reportes), VS-05 Robustez (manejo de errores + recovery).
> Slice de referencia para las anclas: **VS-02 Crecimiento**.

**Score 0.2** — `proposal.md` lista el nombre de la slice sin IC-xx ni BDD scenarios.
`software_design_specification.md` tiene una descripción general sin secciones por BDD
scenario. `software_design_document.md` menciona módulos genéricos sin interfaces concretas
ni firmas de métodos. `testing_plan.md` dice "escribir tests unitarios e integración" sin
estrategia específica por IC-xx. `execution_plan.md` lista tareas de alto nivel sin orden TDD.

> Ejemplo: SDS de VS-02 dice "implementar CRUD de reservas" sin secciones para SC-05
> (crear reserva), SC-06 (modificar reserva), SC-07 (cancelar reserva). SDD menciona
> "módulo de reservas" sin IC-xx específicas ni firmas. Testing Plan: "testear CRUD con
> pytest". Execution Plan: "Tarea 1: Implementar creación. Tarea 2: Implementar
> modificación." Sin orden Red→Green→Refactor. IC-03 (IDisponibilidadService) no aparece
> en ningún artefacto pese a estar en la slice.

**Score 0.5** — `proposal.md` con IC-xx y BDD scenarios parciales (≥50% de la slice).
`software_design_specification.md` con ≥50% de BDD scenarios con sección completa.
`software_design_document.md` con IC-xx identificadas pero sin firmas de métodos completas
o con 1-2 IC-xx faltantes. `testing_plan.md` con estrategias para IC-xx principales pero
sin mocks específicos configurables. `execution_plan.md` con Features y Tickets pero sin
Tasks granulares ni orden TDD explícito.

> Ejemplo: SDS de VS-02 tiene secciones para SC-05 (crear reserva) y SC-06 (modificar)
> pero omite SC-07 (cancelar). SDD define IReservaRepository con 3 métodos pero omite
> `cancelar(id, motivo)`. Testing Plan menciona mock de IReservaRepository pero no
> especifica el stub para `findByFecha`. Execution Plan: Feature "CRUD Reservas" →
> Tickets (Crear, Modificar, Cancelar) pero sin Tasks por Ticket ni orden TDD.

**Score 0.8** — Todos los IC-xx y ≥90% de BDD scenarios cubiertos. `software_design_specification.md`
completa con flujos y AC. `software_design_document.md` con todas las IC-xx y firmas pero
con 1-2 DTOs faltantes. `testing_plan.md` con estrategia completa pero sin definir la Red
phase explícitamente (qué tests fallarán primero). `execution_plan.md` con Tasks granulares
y orden TDD pero sin Criterio de Done por Ticket.

> Ejemplo: SDD de VS-02 define IReservaRepository con todos los métodos y sus firmas
> pero omite el DTO de error `ReservaConflictoDTO`. Testing Plan: todos los IC-xx con
> mocks incluyendo stubs configurables, pero no especifica qué test escribir primero en
> la fase Red. Execution Plan: Ticket "Crear Reserva" → Tasks (Red: escribir test SC-05,
> Green: implementar `crear()`, Refactor: extraer validación) pero sin "Criterio de Done:
> test de integración pasa para SC-05."

**Score 1.0** — Los 5 artefactos completos y consistentes entre sí. `proposal.md` con
todos los IC-xx y BDD scenarios de la slice, valor de negocio claro y riesgos RK-xx
específicos. `software_design_specification.md` con sección por BDD scenario: flujo paso
a paso, DTOs de request/response, código de error esperado, AC verificable. `software_design_document.md`
con todas las IC-xx con firma completa, DTOs incluyendo errores, módulo asignado (MOD-xx),
estrategia de DI, orden de implementación de componentes. `testing_plan.md` con Red phase
explícita (lista de tests a escribir primero por IC-xx), mock/stub configurable por IC-xx,
pirámide de tests equilibrada. `execution_plan.md` con Features → Tickets → Tasks en
orden TDD, Criterio de Done por Ticket con referencias a SC-xx o IC-xx.

> Ejemplo (VS-02 score 1.0): Proposal — IC: IReservaRepository(CRUD),
> IDisponibilidadService; BDD: SC-05, SC-06, SC-07, SE-04; valor: "el recepcionista puede
> gestionar reservas sin papel"; riesgo: "RK-02 — conflicto de reservas simultáneas,
> mitigación: lock optimista en IReservaRepository.crear()". SDS SC-05: flujo = POST
> /reservas → validar disponibilidad → crear → 201 + ReservaDTO; error SE-04 = 409 +
> ReservaConflictoDTO si mesa ocupada; AC = "dado mesa libre, POST /reservas con datos
> válidos → 201 y reserva en BD". SDD: IReservaRepository { crear(ReservaDTO): Reserva;
> modificar(id, PatchDTO): Reserva; cancelar(id, motivo): void; findByFecha(Date):
> Reserva[] }; DI: ReservaService inyecta IReservaRepository + IDisponibilidadService vía
> constructor. Testing Plan: Red phase — test_crear_mesa_libre (SC-05),
> test_crear_mesa_ocupada (SE-04); IReservaRepository mock con pytest-mock configurable.
> Execution Plan: Ticket "Crear Reserva" → Tasks: Red (test SC-05 + SE-04), Green
> (ReservaService.crear + validación), Refactor (extraer a IDisponibilidadService);
> Criterio de Done: SC-05 y SE-04 pasan con cobertura ≥80%. Sin IC-xx referenciada
> que no exista en contract_definitions.md.

### Output de C

```json
// eval/verdict.json — nueva entrada appended al array existente
{
  "phase": "050_vertical",
  "slice_id": "VS-xx",
  "evaluation_version": 1,
  "evaluated_at": "<timestamp>",
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
  "findings": [],
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
```

---

## Sección 5 — Handoff Artifact → 060 Isolation Harness

El 050 entrega al 060 los siguientes artefactos **por slice activa**. El 060 no puede
iniciarse para una slice sin que `harness-state.json` tenga `"050_vertical.slices.VS-xx": "DOCS_READY"`.

```
/050_vertical/VS-xx/
├── proposal.md                          → Scope y valor de la slice para orientar al equipo
├── software_design_specification.md     → QUÉ implementar: BDD scenarios + AC verificables
├── software_design_document.md          → CÓMO implementar: IC-xx con firmas + DI + orden
├── testing_plan.md                      → Estrategia TDD: mocks + pirámide + Red phase
└── execution_plan.md                    → Features → Tickets → Tasks en orden TDD

/040_planning/                           → El 060 hereda los 3 artefactos del 040
├── vertical_slice_plan.md
├── project_roadmap.md
└── risk_register.md

/030_design/                             → El 060 hereda los 5 artefactos del 030
├── technical_blueprint.md
├── contract_definitions.md
├── dependency_graph.md
├── architecture_decision_records.md
└── test_strategy_map.md

/020_specification/                      → El 060 hereda los 4 artefactos del 020
├── bdd_features.md
├── data_contracts.md
├── acceptance_criteria.md
└── error_exception_policy.md

/010_discovery/                          → El 060 hereda los 4 artefactos del 010
├── shared_understanding.md
├── domain_glossary.md
├── scope_boundaries.md
└── failure_behavior.md
```

**Ciclo de vida completo por slice:**

```
050 produce 5 artefactos → DOCS_READY
          ↓
    060 Isolation Harness ejecuta la slice
          ↓
    070 Development Harness construye la slice
          ↓
    070 CLOSE escribe "050_vertical.slices.VS-xx": "SLICE_COMPLETE" en harness-state.json
          ↓
    050 governor retoma: detecta VS-xx SLICE_COMPLETE → selecciona siguiente PENDING
          ↓
    (loop hasta que todas las slices sean SLICE_COMPLETE)
          ↓
    050 marca "050_vertical.status": "PHASE_COMPLETE"
```

**Nota de handshake con 070:** el governor del 070 Development Harness es responsable de
escribir `"050_vertical.slices.VS-xx": "SLICE_COMPLETE"` en `harness-state.json` al cerrar
la slice. Esta es la única escritura cross-harness permitida en FORGE.

---

## Sección 6 — Flujo del Arnés (12.1–12.5)

### 12.1 Inicialización (Instancia A — vertical-governor)

**Precondición absoluta — antes de cualquier acción:**
Verificar que `persistence/harness-state.json` existe y que la clave `"040_planning"` tiene
`"status": "PHASE_COMPLETE"`.

Si no existe o el status del 040 es distinto de `"PHASE_COMPLETE"`: **detener flujo**. Notificar:
> "El 040 Planning debe completarse antes de iniciar el 050 Vertical. Estado actual: [valor encontrado]."

**Determinación del modo:**
- No existe clave `"050_vertical"` en `harness-state.json` → **Modo INICIO** → ejecutar Ritual E10-A
- Existe clave `"050_vertical"` con `status != "PHASE_COMPLETE"` → **Modo CONTINUACIÓN** → ejecutar Ritual E10-B
- `"050_vertical.status" == "PHASE_COMPLETE"` → notificar al humano que el 050 ya está completo
- Existe pero corrupta → `git restore persistence/harness-state.json`; si persiste, detener y reportar

**Ritual E10-A — Inicio:**
1. Verificar directorio y ambiente
2. Crear carpeta `/050_vertical/` con verificación post-creación (ADJ-20):
   ```powershell
   if (-not (Test-Path "050_vertical")) { New-Item -ItemType Directory "050_vertical" | Out-Null }
   if (-not (Test-Path "050_vertical")) { # registrar error crítico y detener }
   ```
3. Leer `040_planning/vertical_slice_plan.md` y `040_planning/project_roadmap.md`.
   Extraer la lista completa de VS-xx en orden del roadmap.
4. Leer `persistence/harness-state.json` completo. Agregar clave `"050_vertical"` con:
   ```json
   {
     "status": "PENDING_CONTRACT",
     "active_slice": null,
     "slices": { "VS-01": "PENDING", "VS-02": "PENDING" }
   }
   ```
   Sin modificar ninguna clave existente (raíz ni `"040_planning"`).
5. Seleccionar el primer VS-xx del roadmap como `active_slice`. Verificar que sus slices
   predecesoras (según I-2) tienen estado `SLICE_COMPLETE` o que no tiene predecesoras.
   Si una predecesora no está `SLICE_COMPLETE`: escalar al humano con el bloqueo.
6. Actualizar `active_slice` en `harness-state.json`. Crear subcarpeta `/050_vertical/VS-xx/`.
7. Inicializar `persistence/execution-state.json` para el 050 con estructura mínima.
8. Prueba básica de sanidad: escribir y leer archivo de prueba en `/050_vertical/VS-xx/`.
9. Registrar arranque en `persistence/claude-progress.txt` con `Add-Content -Encoding utf8`.

**Ritual E10-B — Continuación:**
1. Verificar directorio y ambiente
2. `git log --oneline -10` para orientación
3. Leer `persistence/claude-progress.txt` (estado narrativo)
4. Cargar `persistence/harness-state.json` (estado del 050: slices, active_slice)
5. Leer `persistence/execution-state.json` (último checkpoint alcanzado)
6. Determinar situación según estado:

| Estado en harness-state.json | Situación | Siguiente acción |
|------------------------------|-----------|-----------------|
| `slices[active_slice] == "SLICE_COMPLETE"` (llegada de 070) | 070 completó la slice activa | Seleccionar siguiente PENDING; si no hay → ejecutar Cierre Total |
| `050_vertical.status == "AUDIT_PENDING"` | Post-CP04, auditoría pendiente | Ir a Auditoría (verificar eval/verdict.json con slice_id correcto) |
| `last_checkpoint == "CP-02"` o `status == "EXECUTION_COMPLETE"` | Draft listo | Presentar artefactos al cliente (CP-03) |
| `last_checkpoint == "CP-01"` | Analyst completado | Continuar con vertical-writer (re-spawear) |
| `last_checkpoint == null` y `status == "ACTIVE"` | Inicio de slice | Continuar con vertical-analyst (re-spawear) |
| `050_vertical.status == "PENDING_CONTRACT"` | Sin Sprint Contract | Proponer Sprint Contract al cliente |

7. Al seleccionar una nueva slice: crear `/050_vertical/VS-xx/` si no existe; reiniciar
   `execution-state.json` para la nueva slice.
8. Prueba básica de sanidad.

**Reporte al humano (obligatorio tras inicialización):**
1. Estado encontrado (modo, slice activa, progreso general del 050)
2. Resumen de slices: cuántas PENDING / DOCS_READY / SLICE_COMPLETE de N total
3. Sprint Contract para la slice activa (Inicio de slice) o vigente (Continuación)
4. Próxima acción concreta

**Gate de aprobación humana:**
- Aprobado → A escribe Sprint Contract en clave `"050_vertical"` de `harness-state.json`
  y actualiza `status` a `"ACTIVE"`. Spawea B en modo PLAN.
- Ajuste requerido → A incorpora cambios, vuelve a presentar
- Cancelación → A registra en `claude-progress.txt`, detiene flujo

### 12.2 Ejecución Técnica (Instancia B — vertical-orchestrator + Workers)

1. A spawea vertical-orchestrator en `[MODO: PLAN]`. Orchestrator:
   - Lee Sprint Contract desde `"050_vertical"` en `harness-state.json`
   - Lee `knowledge/` si existe
   - Determina starting_point desde execution-state.json (CP-01, o null si inicio de slice)
   - Escribe orchestration_plan completo con Demo Statements para cada Worker,
     incluyendo el ID de slice activa en todos los paths
   - Retorna `PLAN_RESULT`

2. A recibe PLAN_RESULT. Según starting_point:
   - `null` → spawear vertical-analyst
   - `CP-01` → spawear vertical-writer (saltar analyst)
   - `COMPLETE` → ir directamente a CP-03

3. **vertical-analyst** (si starting_point == null):
   - Recibe paths a I-1..I-17, el ID de slice activa y el Demo Statement
   - Lee los inputs enfocándose en la slice activa
   - Produce `/050_vertical/VS-xx/slice_analysis_report.md` como PRIMER tool call (LL-01)
   - Ejecuta self-checklist contra Demo Statement
   - Si COMPLETED: reporta path a A
   - Si INCOMPLETO: reporta razón a A; A registra WORKER_FAILED y escala al humano

4. A spawea vertical-orchestrator en `[MODO: CHECKPOINT-01]` con path al slice_analysis_report.md.
   Orchestrator verifica en disco (Pending Verification) y retorna CHECKPOINT_OK o CHECKPOINT_FAILED.

5. **vertical-writer** (si CP-01 alcanzado):
   - Recibe path a slice_analysis_report.md + paths a I-1, I-5, I-7, I-8, I-9, I-14 + Demo Statement
   - Produce los 5 artefactos en orden obligatorio:
     `proposal.md` → `software_design_specification.md` → `software_design_document.md`
     → `testing_plan.md` → `execution_plan.md`
   - `proposal.md` es el PRIMER tool call (LL-01)
   - Ejecuta self-checklist cruzado entre los 5 artefactos + Demo Statement
   - Si COMPLETED: reporta paths a A
   - Si INCOMPLETO: reporta razón a A; A registra WORKER_FAILED

6. A spawea vertical-orchestrator en `[MODO: CHECKPOINT-02]` con paths a los 5 artefactos.
   Orchestrator verifica en disco y retorna CHECKPOINT_OK o CHECKPOINT_FAILED.

### 12.2.5 — Revisión pre-CP-03 (vertical-reviewer)

Tras recibir `CHECKPOINT_OK` del CP-02, A spawea vertical-reviewer pasando paths a los 5
artefactos + paths a I-1 (`vertical_slice_plan.md`), I-5 (`contract_definitions.md`),
I-8 (`test_strategy_map.md`) e I-9 (`bdd_features.md`).

**4 verificaciones obligatorias del reviewer (mentalidad Abogado del Diablo):**

- **V1 — IC-xx en `software_design_document.md` ↔ `contract_definitions.md`:**
  Extraer IC-xx referenciadas en el SDD; verificar que existen en contract_definitions.
  IC-xx en SDD sin definición en contract_definitions → CRITICAL.
  IC-xx de la slice en vertical_slice_plan.md que no aparece en SDD → CRITICAL.

- **V2 — BDD scenarios en `software_design_specification.md` ↔ `bdd_features.md`:**
  Extraer SC-xx/SE-xx de la SDS; verificar que existen en bdd_features.
  Scenario en SDS que no existe en bdd_features → CRITICAL.
  Scenario de la slice en vertical_slice_plan.md que no aparece en SDS → CRITICAL.

- **V3 — `testing_plan.md` ↔ `test_strategy_map.md`:**
  Para cada IC-xx de la slice, verificar que testing_plan tiene estrategia de mock/stub
  coherente con test_strategy_map. Mock strategy incompatible o ausente → CRITICAL.

- **V4 — `execution_plan.md` cubre todos los IC-xx de la slice:**
  Extraer IC-xx del vertical_slice_plan para la slice activa; verificar que cada IC-xx
  aparece en ≥1 Task del execution_plan con orden TDD explícito. IC-xx sin task → CRITICAL.

Reviewer produce `050_vertical/VS-xx/review_report.md` como PRIMER tool call (LL-01).
Retorna: `REVIEW_COMPLETE, REVIEW_RESULT: CLEAN | HAS_ISSUES, CRITICAL_COUNT: <n>, MINOR_COUNT: <n>`.

Si `CRITICAL_COUNT > 0`: A no presenta a CP-03. Re-spawea vertical-writer con referencia al
review_report.md. Ciclo continúa desde paso 5 de 12.2.

### 12.3 Auditoría y Gate de Aprobación (Instancia C + A)

**Paso 1 — Gate intermedio (A):**
- A verifica que `execution-state.json` tiene `EXECUTION_COMPLETE` y reviewer retornó `CLEAN`
- A presenta los 5 artefactos de `/050_vertical/VS-xx/` al cliente para revisión (CP-03)
- **IMPORTANTE (ADJ-23):** Registrar `[CP-03 050 VS-xx]` en `claude-progress.txt` con
  `Add-Content -Encoding utf8` ANTES de presentar los artefactos. Aunque el cliente incluya
  aprobación en la misma respuesta del CP-03, presentar CP-04 como `AskUserQuestion` separado.
- A incorpora feedback del cliente si hay cambios menores
- A presenta CP-04: `AskUserQuestion` separado e independiente para aprobación formal

**Paso 2 — Tras aprobación CP-04:**
- A escribe `"050_vertical.status": "AUDIT_PENDING"` en `harness-state.json`
- A registra `[AUDIT_PENDING 050 VS-xx]` en `claude-progress.txt`
- A spawea vertical-evaluator pasando paths a los 5 artefactos + paths I-1, I-5, I-8, I-9, I-14

**Paso 3 — Auditoría (C — vertical-evaluator):**
- C lee los 5 artefactos de la slice activa desde el filesystem (sin contexto de ejecución)
- C lee `040_planning/vertical_slice_plan.md`, `030_design/contract_definitions.md`,
  `030_design/test_strategy_map.md`, `020_specification/bdd_features.md`,
  `010_discovery/domain_glossary.md` como referencia para D1–D5
- C evalúa contra rúbrica (Sección 4) — dos fases: análisis con citas → score (LL-07)
- C escribe (PATHS DE SALIDA — OBLIGATORIO: solo en `eval/`, nunca en `/050_vertical/`):
  - `eval/verdict.json` — append al array existente, entry con `"phase": "050_vertical"`
    y `"slice_id": "VS-xx"`
  - `eval/metrics_summary.json` — append al array existente
- C registra auditoría en `persistence/claude-progress.txt`

**Paso 4 — Decisión final (A — GateKeeper):**

```
## Cierre de slice — ANTES DE CUALQUIER ACCIÓN — VERIFICACIÓN OBLIGATORIA (LL-20):
1. Leer eval/verdict.json.
2. Verificar que existe al menos una entrada con "phase": "050_vertical"
   Y "slice_id": "[VS-xx activa]".
3. Si NO existe → DETENER completamente. Ejecutar la sección Auditoría ahora.
   No continuar bajo ninguna circunstancia sin esta verificación.
```

- A lee `eval/verdict.json`, filtra por `"phase": "050_vertical"` y `"slice_id": "[VS-xx activa]"`,
  toma la última entrada
- **APPROVED** → A ejecuta 12.5 Cierre de Slice
- **REJECTED** → A activa protocolo 12.4

### 12.4 Protocolo de Rechazo y Reintento

**Rechazo Técnico** (artefacto no cumple rúbrica):
- C escribe rechazo detallado en `eval/verdict.json`
- A marca `"050_vertical.status": "IN_REWORK"` en `harness-state.json`
- A spawea vertical-orchestrator en modo PLAN pasando referencia al rechazo
- Orchestrator escribe nuevo plan; A spawea solo el Worker que produce los artefactos fallidos
- B lee `knowledge/lessons_learned.md` antes de re-ejecutar
- Ciclo continúa desde 12.3

**Rechazo Estratégico** (cliente rechaza el scope o el enfoque técnico de la slice):
- A detiene flujo, marca `"050_vertical.status": "HOLD"` en `harness-state.json`
- A actualiza Sprint Contract con los cambios de scope
- Si el rechazo implica modificar el plan maestro del 040 → escalar al 100 Change Harness
- Sin avance hasta nueva aprobación humana explícita

**Registro de aprendizaje:**
- Todo rechazo registrado en `knowledge/lessons_learned.md` al cierre del ciclo

### 12.5 Cierre

#### Cierre de Slice (DOCS_READY)

1. A actualiza `harness-state.json`: `"050_vertical.slices.VS-xx": "DOCS_READY"`,
   `"050_vertical.status": "ACTIVE"`, `"active_slice": null`
2. A actualiza `knowledge/lessons_learned.md` con hallazgos de la slice
3. A actualiza `knowledge/decisions_library.md` con decisiones técnicas específicas de la
   slice. **NO limitarse a hitos procedimentales** (ADJ-22) — incluir decisiones de diseño
   sustantivas (ej. decisiones de DI, patrones aplicados, estructura del Execution Plan).
4. A notifica al humano: lista de 5 artefactos producidos para VS-xx, paths, estado DOCS_READY,
   progreso general (N slices completadas de M total)
5. A registra cierre de slice en `persistence/claude-progress.txt` con `Add-Content -Encoding utf8`
6. A hace commit: `docs(050-vertical): VS-xx DOCS_READY — 5 artefactos producidos`

**Handoff al 060:**
A pregunta al humano si desea continuar con el 060 Isolation para la slice VS-xx.
- Sí → A registra `"handoff_060": {"status": "DEPLOYED", "slice": "VS-xx"}`, ejecuta deploy
  via `$env:HARNESS_DEPLOY_SCRIPT 060`, instruye al humano: **"Reinicia la sesión y ejecuta
  /forge-restart. El CLAUDE.md detectará el estado DEPLOYED y arrancará el 060 para VS-xx."**
- No → A registra `"handoff_060": {"status": "PENDING_HANDOFF", "slice": "VS-xx"}` en
  `harness-state.json`

Registrar evento en `claude-progress.txt` en cualquier caso.

#### Cierre Total del Harness (PHASE_COMPLETE)

Cuando el governor detecta en E10-B que no quedan slices en estado PENDING o DOCS_READY
(el 070 marcó la última slice como SLICE_COMPLETE):

1. A verifica que todas las VS-xx en `harness-state.json` tienen estado `SLICE_COMPLETE`
2. A marca `"050_vertical.status": "PHASE_COMPLETE"` en `harness-state.json`
3. A actualiza `knowledge/lessons_learned.md` con hallazgos del ciclo completo (cross-slice)
4. A actualiza `knowledge/decisions_library.md` con decisiones de implementación transversales
5. A notifica al humano: todas las VS-xx completadas, proyecto construido, paths de todos los
   artefactos producidos a lo largo de las N slices
6. A registra cierre total en `persistence/claude-progress.txt`
7. A hace commit final: `docs(050-vertical): PHASE_COMPLETE — todas las slices completadas`

---

## Notas de construcción

### Agentes a crear (todos nuevos, sin herencia de harnesses anteriores)

```
.claude/agents/
├── vertical-governor.md      — Instancia A (modos INIT/EXECUTE/POST_CP03/POST_CP04/CLOSE)
├── vertical-orchestrator.md  — Instancia B (modos 050_vertical/CHECKPOINT/WORKER_FAILED — sin Agent tool)
├── vertical-analyst.md       — Worker 1 (tools: Read, Write)
├── vertical-writer.md        — Worker 2 (tools: Read, Write, Edit)
├── vertical-reviewer.md      — Control pre-CP-03 (tools: Read, Write)
└── vertical-evaluator.md     — Instancia C (tools: Read, Write — solo escribe en eval/)
```

### Skills a crear

```
.claude/skills/
├── vertical-state-schema/        — Schema de "050_vertical" en harness-state.json (con slices dict) + execution-state.json
├── vertical-analysis-schema/     — Schema de slice_analysis_report.md (IC-xx, BDD, riesgos, deps, errores)
├── vertical-analyst-protocol/    — Protocolo de extracción enfocada en slice activa (17 inputs, scope filter)
├── vertical-synthesis-schema/    — Schema de los 5 artefactos finales (proposal, SDS, SDD, testing_plan, execution_plan)
├── vertical-writer-protocol/     — Reglas de transformación analysis→5 artefactos + orden TDD obligatorio
├── vertical-rubric/              — Rúbrica D1-D5 con anclas 0.2/0.5/0.8/1.0 calibradas en dominio La Terraza
├── vertical-verdict-schema/      — verdict.json + metrics_summary.json (phase: "050_vertical", slice_id: "VS-xx")
└── vertical-evaluator-protocol/  — Verificación D1-D5 + cross-checks de IDs entre los 5 artefactos
```

### Cambios en infraestructura compartida

| Archivo | Cambio requerido |
|---------|-----------------|
| `templates/client-project-CLAUDE.md` | Agregar condición: si 040 PHASE_COMPLETE y 050 no → invocar vertical-governor; manejar DOCS_READY por slice |
| `deploy-harness.ps1` | Agregar soporte para harness `050` en la lógica de selección |
| `.claude/agents/planning-governor.md` | Handoff al 050: verificar que usa `$env:HARNESS_DEPLOY_SCRIPT 050` correctamente |

### IDs de referencia cruzada

| Artefacto | ID | Formato | Origen |
|-----------|-----|---------|--------|
| Todos los artefactos | Interface Contract | IC-xx | Heredado del 030 |
| Todos los artefactos | BDD Scenario | SC-xx / SE-xx | Heredado del 020 |
| Todos los artefactos | Módulo | MOD-xx | Heredado del 030 |
| slice_analysis_report | Riesgo de slice | RK-xx | Heredado del 040 |
| execution_plan | Feature | FT-xx | Nuevo en 050 — local a la slice |
| execution_plan | Ticket | TK-xx | Nuevo en 050 — local a la slice |
| execution_plan | Task | TA-xx | Nuevo en 050 — local a la slice |

**Nota:** Los IDs FT-xx, TK-xx y TA-xx son locales a cada slice. Para evitar ambigüedad
al referenciarlos desde artefactos de otras slices, prefijar con el ID de slice:
VS-02-FT-01, VS-02-TK-03. El vertical-writer decide y documenta la convención en el
execution_plan.

### Lecciones críticas a aplicar (LL-01 a LL-29)

| Lección | Aplicación en 050 |
|---------|------------------|
| LL-01 | Workers: el `proposal.md` es el PRIMER tool call del vertical-writer (sin excepción) |
| LL-02 | vertical-orchestrator tiene sección REGLAS DE ESCRITURA — nunca escribe en `/050_vertical/` |
| LL-03 | vertical-evaluator tiene bloque PATHS DE SALIDA — escribir solo en `eval/` |
| LL-04 + LL-20 | Cierre de slice: verificación de eval/verdict.json con `slice_id: "VS-xx"` como PRIMER tool call |
| LL-05 | Timestamps reales en governor y orchestrator |
| LL-06 | Protocolo de 5 pasos para checkpoints — obligatorio en orchestrator |
| LL-07 | Evaluador: análisis con citas → score (dos fases, nunca invertir) |
| LL-10 | vertical-governor NUNCA escribe en `/050_vertical/` directamente |
| LL-13 | Orchestrator verifica artefacto en disco antes de registrar checkpoint |
| LL-17 | Si la rúbrica verifica frases textuales, el synthesis-schema debe especificarlas exactas |
| LL-20 | Cierre de slice: verificación con slice_id correcto como PRIMER tool call del Cierre |
| LL-21 | vertical-orchestrator SIN Agent tool; governor spawnea workers directamente |
| LL-22 | Handoff al 060 instruye reinicio de sesión, no spawn directo |
| LL-24 | Demo Statements citan las secciones obligatorias de cada artefacto |
| LL-25 | CP-03 y CP-04 siempre como AskUserQuestion separadas |
| LL-27 | vertical-reviewer entre CP-02 y CP-03 (verifica IDs cruzados entre los 5 artefactos) |
| LL-29 | vertical-writer tiene "RUTA DE ESCRITURA — OBLIGATORIO" con path exacto `/050_vertical/VS-xx/` |
| ADJ-13 | Demo Statements en orchestration_plan; Pending Verification post-worker |
| ADJ-24 | claude-progress.txt: usar `Add-Content -Encoding utf8`, nunca Write |
