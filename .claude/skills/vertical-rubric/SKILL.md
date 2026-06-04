---
name: vertical-rubric
description: Rúbrica de evaluación del 050 Vertical Harness. Define las 5 dimensiones de evaluación, las anclas de calibración (0.2/0.5/0.8/1.0), la regla de gate (≥0.75) y la regla de veto (D5=0.0). Usar cuando vertical-evaluator evalúa los 5 artefactos finales del Vertical para la slice activa.
user-invocable: false
agent: vertical-evaluator
---

## Dimensiones de evaluación

| ID | Dimensión | Pregunta central |
|----|-----------|-----------------|
| D1 | Proposal & SDS Coverage | ¿`proposal.md` cita todos los IC-xx y BDD scenarios de la slice según `vertical_slice_plan.md`? ¿`software_design_specification.md` tiene ≥1 sección por BDD scenario con flujo, contrato de datos y AC verificable? ¿Sin BDD scenarios huérfanos? |
| D2 | SDD Technical Depth | ¿`software_design_document.md` referencia solo IC-xx de la slice definidos en `contract_definitions.md`? ¿Cada IC-xx tiene firma técnica completa, módulo asignado (MOD-xx) y estrategia de DI? ¿Consistente con el stack del ADR-001? |
| D3 | Testing Plan TDD Traceability | ¿`testing_plan.md` tiene ≥1 estrategia de test por IC-xx de la slice, consistente con la estrategia mock/stub de `test_strategy_map.md`? ¿Define los tres niveles (unitario, integración, contrato)? ¿Especifica la fase Red explícitamente? |
| D4 | Execution Plan Actionability | ¿`execution_plan.md` descompone la slice en Features → Tickets → Tasks? ¿Cada Task cita el IC-xx o SC-xx/SE-xx que implementa? ¿Todos los IC-xx de la slice están en ≥1 Task? ¿Orden TDD explícito (Red→Green→Refactor)? ¿Criterio de Done verificable por Ticket? |
| D5 | Consistency | ¿Sin contradicciones entre los 5 artefactos? ¿Sin IC-xx referenciados que no existan en `contract_definitions.md`? ¿Sin BDD scenarios que no existan en `bdd_features.md`? ¿Lenguaje ubicuo del glosario usado consistentemente? |

**Gate de paso:** promedio ≥ 0.75 en todas las dimensiones.
**Regla de veto:** si D5 = 0.0, veredicto REJECTED inmediato sin calcular promedio.

**Nota:** La rúbrica se aplica **por slice**. Cada evaluación corresponde a un VS-xx específico.
La entrada en `eval/verdict.json` incluye `"slice_id": "VS-xx"`.

---

## Anclas de calibración

> Dominio de referencia: Sistema de Reservas para Restaurante "La Terraza" (Test_Harness_002).
> Slices hipotéticas: VS-01 Tracer Bullet (login + GET /reservas/{id}),
> VS-02 Crecimiento (CRUD reservas), VS-03 MVP (notificaciones + confirmaciones),
> VS-04 Evolución (historial + reportes), VS-05 Robustez (manejo de errores + recovery).
> Slice de referencia para las anclas: **VS-02 Crecimiento**.

### Score 0.2 — Cobertura mínima, gaps críticos

**D1:** `proposal.md` lista el nombre de la slice sin IC-xx ni BDD scenarios. `software_design_specification.md`
tiene una descripción general sin secciones por BDD scenario.
**D2:** `software_design_document.md` menciona módulos genéricos sin IC-xx específicas ni firmas de métodos.
**D3:** `testing_plan.md` dice "escribir tests unitarios e integración" sin estrategia específica por IC-xx
ni mocks configurables.
**D4:** `execution_plan.md` lista tareas de alto nivel sin Features/Tickets/Tasks ni orden TDD.
**D5:** IC-xx referenciados que no existen en `contract_definitions.md`, o BDD scenarios de otra slice mezclados.

> Ejemplo: SDS de VS-02 dice "implementar CRUD de reservas" sin secciones para SC-05 (crear reserva),
> SC-06 (modificar reserva), SC-07 (cancelar reserva). SDD menciona "módulo de reservas" sin IC-xx
> específicas ni firmas. Testing Plan: "testear CRUD con pytest". Execution Plan: "Tarea 1: Implementar
> creación. Tarea 2: Implementar modificación." Sin orden Red→Green→Refactor. IC-03
> (IDisponibilidadService) no aparece en ningún artefacto pese a estar en la slice.

### Score 0.5 — Cobertura parcial, gaps importantes

**D1:** `proposal.md` con IC-xx y BDD scenarios parciales (≥50% de la slice). `software_design_specification.md`
con ≥50% de BDD scenarios con sección completa.
**D2:** `software_design_document.md` con IC-xx identificadas pero sin firmas de métodos completas
o con 1-2 IC-xx faltantes. DTOs de request/response presentes pero DTOs de error ausentes.
**D3:** `testing_plan.md` con estrategias para IC-xx principales pero sin mocks específicos configurables
y sin definir la fase Red explícitamente.
**D4:** `execution_plan.md` con Features y Tickets pero sin Tasks granulares ni orden TDD explícito.
Criterios de Done genéricos ("implementar funcionalidad").
**D5:** 1-2 inconsistencias entre artefactos; IC-xx listadas con nombre diferente entre SDS y SDD.

> Ejemplo: SDS de VS-02 tiene secciones para SC-05 (crear reserva) y SC-06 (modificar) pero omite SC-07
> (cancelar). SDD define IReservaRepository con 3 métodos pero omite `cancelar(id, motivo)`. Testing Plan
> menciona mock de IReservaRepository pero no especifica el stub para `findByFecha`. Execution Plan:
> Feature "CRUD Reservas" → Tickets (Crear, Modificar, Cancelar) pero sin Tasks por Ticket ni orden TDD.

### Score 0.8 — Cobertura completa, gaps menores

**D1:** Todos los IC-xx y ≥90% de BDD scenarios cubiertos. `software_design_specification.md` completa
con flujos y AC, pero 1-2 scenarios de error sin detalle de DTO de error.
**D2:** Todas las IC-xx con firmas completas pero 1-2 DTOs faltantes (ej. DTO de error específico).
Estrategia de DI documentada para las IC-xx principales pero incompleta para servicios auxiliares.
**D3:** Estrategia completa con mocks configurables para todos los IC-xx, pero sin definir la fase Red
explícitamente (qué tests escribir primero).
**D4:** Tasks granulares con orden TDD, pero 1-2 Tickets sin Criterio de Done con referencias a IDs.
Todos los IC-xx cubiertos en ≥1 Task.
**D5:** 1 inconsistencia menor (un método con nombre ligeramente diferente entre SDS y SDD, o un campo
de DTO con tipo diferente en proposal y SDD — no contradictorio pero impreciso).

> Ejemplo: SDD de VS-02 define IReservaRepository con todos los métodos y sus firmas pero omite el DTO
> de error `ReservaConflictoDTO`. Testing Plan: todos los IC-xx con mocks incluyendo stubs configurables,
> pero no especifica qué test escribir primero en la fase Red. Execution Plan: Ticket "Crear Reserva" →
> Tasks (Red: escribir test SC-05, Green: implementar `crear()`, Refactor: extraer validación) pero sin
> "Criterio de Done: test de integración pasa para SC-05."

### Score 1.0 — Cobertura completa, sin gaps

**D1:** `proposal.md` con todos los IC-xx y BDD scenarios de la slice (igual que I-1), valor de negocio
claro y riesgos RK-xx específicos. `software_design_specification.md` con sección por cada BDD scenario:
flujo paso a paso, DTOs de request/response, código de error esperado, AC verificable cita textual de I-11.
**D2:** Todas las IC-xx con firma completa (todos los métodos), DTOs incluyendo errores, módulo asignado
(MOD-xx), estrategia de DI con clase implementadora y punto de inyección, orden de implementación de
componentes. Stack consistente con ADR-001 en cada decisión.
**D3:** Red phase explícita (lista de tests a escribir primero por IC-xx), mock/stub configurable por
IC-xx con código de ejemplo, pirámide de tests equilibrada con conteos por nivel.
**D4:** Features → Tickets → Tasks en orden TDD, Criterio de Done por Ticket con referencias a SC-xx
o IC-xx. Todos los IC-xx de la slice en ≥1 Task. Convención de IDs FT-xx/TK-xx/TA-xx documentada.
**D5:** Sin contradicciones entre los 5 artefactos. Ningún IC-xx ni SC-xx en un artefacto que no exista
en I-5 o I-9. Lenguaje ubicuo de I-14 usado consistentemente. Firmas de métodos idénticas entre SDS, SDD y Testing Plan.

> Ejemplo (VS-02 score 1.0): Proposal — IC: IReservaRepository(CRUD), IDisponibilidadService; BDD: SC-05,
> SC-06, SC-07, SE-04; valor: "el recepcionista puede gestionar reservas sin papel"; riesgo: "RK-02 —
> conflicto de reservas simultáneas, mitigación: lock optimista en IReservaRepository.crear()".
> SDS SC-05: flujo = POST /reservas → validar disponibilidad → crear → 201 + ReservaDTO; error SE-04 =
> 409 + ReservaConflictoDTO si mesa ocupada; AC = "dado mesa libre, POST /reservas con datos válidos →
> 201 y reserva en BD". SDD: IReservaRepository { crear(ReservaDTO): Reserva; modificar(id, PatchDTO):
> Reserva; cancelar(id, motivo): void; findByFecha(Date): Reserva[] }; DI: ReservaService inyecta
> IReservaRepository + IDisponibilidadService vía constructor. Testing Plan: Red phase —
> test_crear_mesa_libre (SC-05), test_crear_mesa_ocupada (SE-04); IReservaRepository mock con
> pytest-mock configurable. Execution Plan: Ticket "Crear Reserva" → Tasks: Red (test SC-05 + SE-04),
> Green (ReservaService.crear + validación), Refactor (extraer a IDisponibilidadService); Criterio de
> Done: SC-05 y SE-04 pasan con cobertura ≥80%. Sin IC-xx referenciada que no exista en contract_definitions.md.

---

## Aplicación de la regla de veto (D5 = 0.0)

D5 = 0.0 se asigna cuando existe una contradicción directa y no documentada entre artefactos.
Ejemplos concretos para el dominio La Terraza:

- `execution_plan.md` asigna IC-04 (IHistorialService) a VS-02, pero IC-04 no está en la lista de IC-xx de VS-02 según `vertical_slice_plan.md` y no hay nota explicando la adición.
- `software_design_document.md` llama al método `crearReserva()` pero `software_design_specification.md` lo llama `crear()` — misma interfaz, firma diferente, sin documentar la decisión.
- `testing_plan.md` define un mock para IC-05 (de VS-03) que no pertenece a VS-02 — IC-xx de otra slice mezclado.
- `execution_plan.md` tiene un Ticket para SE-08 que no aparece en los BDD scenarios de VS-02 según `bdd_features.md`.
- Los 5 artefactos dicen `IReservaRepository` pero `contract_definitions.md` define `IRepositorioReserva` — nombre diferente sin documentar la decisión de renombrar.

Una inconsistencia documentada (marcada con `[PENDIENTE]` o en nota explícita) no activa el veto —
es una inconsistencia conocida que puede resolverse. Solo la contradicción silenciosa activa el veto.
