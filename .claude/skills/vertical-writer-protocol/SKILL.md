---
name: vertical-writer-protocol
description: Protocolo de producción del vertical-writer en el 050 Vertical Harness. Define las reglas de transformación del slice_analysis_report en los 5 artefactos finales, el orden de producción obligatorio (proposal→SDS→SDD→testing_plan→execution_plan), las reglas TDD para el execution_plan, el checklist de verificación cruzada entre los 5 artefactos y el self-checklist del Demo Statement. Usar cuando vertical-writer produce los artefactos de la slice activa.
user-invocable: false
agent: vertical-writer
---

## Regla de no-inferencia (absoluta)

No inventar IC-xx, métodos, DTOs, BDD scenarios, módulos ni decisiones de arquitectura que no estén
en el `slice_analysis_report.md` o en los inputs de referencia que se le pasan al writer.

Si un dato necesario no está disponible, marcar con `[PENDIENTE: razón específica]` y continuar
con los demás ítems. No detener la producción por un campo faltante no bloqueante.

Excepción bloqueante: si los IC-xx de la slice no tienen firmas en el SDD (vacío crítico),
reportar `INCOMPLETO` al governor. No producir un SDD sin firmas.

## Inputs del writer

El writer recibe del governor:
- Path a `050_vertical/VS-xx/slice_analysis_report.md`
- Paths a: I-1 (`vertical_slice_plan.md`), I-5 (`contract_definitions.md`), I-7 (`architecture_decision_records.md`), I-8 (`test_strategy_map.md`), I-9 (`bdd_features.md`), I-14 (`domain_glossary.md`)
- Demo Statement (del orchestration_plan)

Leer el `slice_analysis_report.md` completo antes de producir ningún artefacto. Es la fuente
primaria organizada. Los inputs de referencia (I-1, I-5, etc.) se usan para verificar y ampliar,
nunca para reemplazar lo ya extraído en el reporte.

## Orden de producción obligatorio

1. `proposal.md` — **PRIMER tool call** (LL-01)
2. `software_design_specification.md` — segundo
3. `software_design_document.md` — tercero
4. `testing_plan.md` — cuarto
5. `execution_plan.md` — quinto

No producir ningún artefacto fuera de este orden. El proposal define el scope; la SDS define
los flujos; el SDD define la estructura técnica; el testing_plan convierte IC-xx en estrategia
de test; el execution_plan descompone todo en tasks TDD.

## Reglas por artefacto

### Artefacto 1 — proposal.md

**Fuente:** Sección 1 (definición de la slice) y Sección 5 (dependencias) del analysis_report.

**Producir:**
- Resumen ejecutivo en 2-3 frases de valor de negocio (lenguaje del domain_glossary — I-14, sin jerga técnica)
- Tabla de IC-xx implementados: usar los IDs y nombres de la Sección 2 del analysis_report
- Tabla de BDD scenarios cubiertos: usar los IDs y nombres de la Sección 3 del analysis_report
- Tabla de dependencias con slices predecesoras (de Sección 5 del analysis_report)
- Tabla de riesgos (de Sección 4 del analysis_report): RK-xx con probabilidad, impacto y mitigación
- Criterio de Done: citar textualmente de I-1, con referencias a IC-xx y SC-xx/SE-xx específicos
- Valor de negocio para el cliente: párrafo en lenguaje de negocio sobre qué puede hacer el usuario cuando la slice esté completa

**Reglas:**
- No hay campo `Estado: DRAFT` en este artefacto (el governor usa harness-state.json para rastrear el estado).
- El resumen ejecutivo no puede incluir IC-xx, módulos ni términos técnicos — debe ser comprensible para el cliente sin conocimientos técnicos.
- Los IC-xx y BDD scenarios del proposal deben coincidir exactamente con los de I-1 para la slice activa. No agregar ni omitir.

### Artefacto 2 — software_design_specification.md

**Fuente:** Sección 3 del analysis_report (BDD scenarios con AC y políticas de error).

**Producir una sección por cada SC-xx/SE-xx de la slice activa:**
- Given/When/Then completo (de I-9)
- Flujo paso a paso numerado del sistema
- Contrato de datos: Request DTO + Response DTO + método HTTP + endpoint
- Para SE-xx: contrato de error con código HTTP y nombre del DTO de error + política de error de I-12
- Criterio de aceptación verificable: citar textualmente de I-11

**Reglas:**
- Mínimo una sección por cada SC-xx/SE-xx de la slice. Sin excepción.
- No incluir scenarios de otras slices aunque aparezcan en I-9.
- El criterio de aceptación debe ser textual de I-11 — no parafrasear.
- Los nombres de DTOs en la SDS deben coincidir exactamente con los del SDD (Artefacto 3).
  Si el writer asigna un nombre de DTO, debe usarlo consistentemente en todos los artefactos.

### Artefacto 3 — software_design_document.md

**Fuente:** Sección 2 del analysis_report (IC-xx con firmas, DTOs, módulos, DI, estrategias mock).

**Producir una sección por cada IC-xx de la slice activa:**
- Módulo asignado (MOD-xx de I-4): nombre y capa
- Responsabilidad de la interfaz en términos de dominio
- Firma completa de la interfaz: todos los métodos con parámetros tipados y tipo de retorno
- DTOs: request, response y error (con tipos de campos)
- Estrategia de Dependency Injection: clase implementadora + punto de inyección + quien la consume
- Orden de implementación: posición en la secuencia TDD de la slice

**Reglas:**
- La firma de cada IC-xx debe ser completa. Ningún método puede faltar si aparece en I-5.
- Si la firma está marcada como `[PENDIENTE]` en el analysis_report, mantener la nota en el SDD.
  No inventar una firma.
- El lenguaje (tipos, sintaxis) debe seguir el stack del ADR-001 (I-7). No mezclar lenguajes.
- **La firma técnica del SDD es canónica** — la SDS, el testing_plan y el execution_plan deben
  usar exactamente los mismos nombres de métodos e interfaces. Decidir los nombres aquí y
  usarlos consistentemente en los 4 artefactos siguientes.
- No incluir IC-xx de otras slices. Solo las asignadas a la slice activa en I-1.

Al final del SDD: tabla de "Módulos tocados" y sección de "Orden de implementación de componentes"
(de más simple a más complejo, para respetar TDD).

### Artefacto 4 — testing_plan.md

**Fuente:** Sección 2 del analysis_report (estrategia mock/stub por IC-xx de I-8), Sección 3 (BDD scenarios).

**Producir una sección por cada IC-xx de la slice activa:**
- Estrategia mock/stub de I-8: Fake / Mock / Real con descripción de qué se mockea y qué no
- Red phase: lista explícita de tests a escribir PRIMERO (antes de implementar), con nombre del test,
  BDD scenario al que corresponde, tipo (unitario / integración / contrato) y por qué debe fallar inicialmente
- Mock/stub configurable: fragmento de código en el framework del ADR-001 mostrando la configuración base
  del mock/stub para los tests de esta IC-xx (incluyendo stub para error)

Al final:
- Tabla "Pirámide de tests de la slice": nivel (Unitario/Integración/Contrato) + cantidad + descripción
- Tabla "Orden Red → Green por BDD Scenario": para cada SC-xx/SE-xx, los 3 pasos (Red/Green/Refactor)
- Tabla de cobertura esperada: IC-xx con tests / IC-xx total; BDD scenarios con tests / total; % mínimo de cobertura

**Reglas:**
- La Red phase es obligatoria y explícita. No es suficiente con "escribir tests unitarios" — debe
  listar los tests específicos con sus nombres.
- La estrategia mock debe ser coherente con I-8. No decidir una estrategia distinta sin citar
  una razón basada en los inputs.
- Los nombres de tests en la Red phase deben corresponder al IC-xx y al SC-xx/SE-xx que prueban.
  El patrón `test_[escenario]_[condición]` o equivalente del framework del ADR-001.
- El criterio mínimo de cobertura debe ser concreto (ej. ≥80% de líneas en los módulos tocados).
  No escribir "máxima cobertura posible" como criterio.

### Artefacto 5 — execution_plan.md

**Fuente:** Sección 2 del analysis_report (IC-xx y orden de implementación), Artefactos 3 y 4 ya producidos.

**Estructura obligatoria:**
- Features (FT-xx) — agrupaciones funcionales de la slice en términos de negocio
- Tickets (TK-xx) — unidades de trabajo completables por un desarrollador en 1-3 días
- Tasks (TA-xx) — acciones concretas en fases TDD: Red / Green / Refactor

**Reglas de descomposición:**
- Cada Ticket implementa ≤1 IC-xx principal (puede tocar IC-xx auxiliares).
- Cada Ticket tiene ≥1 BDD scenario al que contribuye.
- Cada Ticket tiene Criterio de Done verificable con referencia a SC-xx/SE-xx o IC-xx específicos.
  No escribir "la funcionalidad está implementada" — siempre citar IDs.
- Las Tasks de cada Ticket siguen el orden TDD obligatorio:
  1. **Red:** escribir el test que falla porque [IC-xx] no está implementada. Nombrar el test.
  2. **Green:** implementar [método] de [IC-xx] hasta que el test pase.
  3. **Refactor:** descripción de qué se refactoriza, o "Sin refactor en esta iteración" si no aplica.

**Reglas de cobertura:**
- Todos los IC-xx de la slice activa deben aparecer en ≥1 Task del execution_plan.
- Todos los SC-xx/SE-xx de la slice activa deben aparecer en el Criterio de Done de ≥1 Ticket.
- No crear Tasks sin referencia a IC-xx o SC-xx/SE-xx — toda Task cita qué implementa o prueba.

**Convención de IDs (FT-xx, TK-xx, TA-xx):**
- Los IDs son locales a esta slice. Empezar en FT-01, TK-01, TA-01.
- Documentar la convención en la sección "Convención de IDs" del artefacto.
- Para referenciarlos desde otras slices: `[VS-xx]-FT-01`, `[VS-xx]-TK-02`, etc.

Al final: tabla "Verificación de cobertura de IC-xx" — lista todos los IC-xx de la slice con
la Feature/Ticket/Task donde aparece y estado CUBIERTO o INCOMPLETO.

## Verificación cruzada obligatoria (antes del self-checklist)

Verificar la consistencia entre los 5 artefactos producidos:

**V1 — Firma técnica canónica:**
- [ ] Los nombres de interfaces, métodos y DTOs son idénticos en SDS, SDD y testing_plan.
  Un solo nombre por elemento en todos los artefactos — sin variantes (ej. `getById` vs `findById`).

**V2 — Cobertura de IC-xx:**
- [ ] Todos los IC-xx de la slice activa (de I-1) están en `proposal.md` (tabla de scope).
- [ ] Todos los IC-xx de la slice activa están en `software_design_document.md` con sección propia.
- [ ] Todos los IC-xx de la slice activa tienen sección en `testing_plan.md` con estrategia de mock.
- [ ] Todos los IC-xx de la slice activa aparecen en ≥1 Task del `execution_plan.md`.

**V3 — Cobertura de BDD scenarios:**
- [ ] Todos los SC-xx/SE-xx de la slice activa (de I-1) están en `proposal.md` (tabla de scope).
- [ ] Todos los SC-xx/SE-xx de la slice activa tienen sección propia en `software_design_specification.md`.
- [ ] Todos los SC-xx/SE-xx de la slice activa están referenciados en el Criterio de Done de ≥1 Ticket.

**V4 — Sin IDs inventados:**
- [ ] Ningún IC-xx en SDS, SDD, testing_plan o execution_plan que no exista en I-5 (`contract_definitions.md`).
- [ ] Ningún SC-xx/SE-xx en SDS, testing_plan o execution_plan que no exista en I-9 (`bdd_features.md`).

**V5 — Lenguaje ubicuo:**
- [ ] Los 5 artefactos usan los términos del `domain_glossary.md` (I-14) consistentemente.
  Ningún término de negocio con definición diferente a la del glosario.

**V6 — TDD explícito:**
- [ ] `testing_plan.md` tiene sección "Red phase" con tests nombrados por IC-xx.
- [ ] `execution_plan.md` tiene Tasks Red/Green/Refactor para cada Ticket (o "Sin refactor" documentado).

Si alguna verificación falla, editar el artefacto afectado antes de ejecutar el self-checklist.

## Self-checklist del Demo Statement

Antes de reportar COMPLETED, verificar cada condición del Demo Statement:

- [ ] `proposal.md` cita los IC-xx de la slice según I-1 (tabla de scope)
- [ ] `proposal.md` cita los BDD scenarios de la slice según I-1 (tabla de scope)
- [ ] `proposal.md` describe el valor de negocio en lenguaje no técnico
- [ ] `software_design_specification.md` tiene ≥1 sección por cada BDD scenario de la slice
- [ ] cada sección de la SDS tiene flujo paso a paso, contrato de datos y AC verificable
- [ ] `software_design_document.md` referencia solo IC-xx de I-5 (`contract_definitions.md`)
- [ ] cada IC-xx en el SDD tiene firma técnica completa y estrategia de DI
- [ ] `testing_plan.md` tiene ≥1 estrategia de test por IC-xx de la slice, coherente con I-8
- [ ] `testing_plan.md` define fase Red explícita con tests nombrados por IC-xx
- [ ] `execution_plan.md` descompone la slice en Features → Tickets → Tasks
- [ ] todos los IC-xx de la slice están en ≥1 Task del execution_plan
- [ ] cada Ticket del execution_plan tiene orden TDD (Red→Green→Refactor) y Criterio de Done con IDs
- [ ] los 5 archivos existen en `/050_vertical/[VS-xx]/` con contenido (LL-01 aplicado)

Si todas las condiciones se verifican: reportar `COMPLETED` con paths a los 5 artefactos.
Si alguna condición falla: reportar `INCOMPLETO: <razón específica>`. No reportar COMPLETED.
