---
name: design-architect-protocol
description: Protocolo de producción del design-architect en el 030 Design Harness. Define las reglas de transformación de design_analysis_report a los 5 artefactos finales, el orden obligatorio de producción y el self-checklist cruzado. Usar cuando design-architect produce los artefactos o verifica su consistencia antes de reportar.
user-invocable: false
agent: design-architect
---

## Regla de no-inferencia (absoluta)

No generar módulos, interfaces, patrones ni decisiones de stack que no estén derivados del
`design_analysis_report.md`. Si la información es ambigua o falta, registrar con
`[PENDIENTE: descripción]`, no inventar completitud técnica.

Excepción controlada: para el ADR-001, si el analyst identificó RT-xx pero no hay una preferencia
de stack explícita en los inputs, seleccionar el stack mínimo consistente con las RT-xx y documentar
explícitamente la ausencia de preferencia en el "Contexto" del ADR-001.

---

## Orden de producción obligatorio

Producir siempre en este orden. No alterar la secuencia.

1. `architecture_decision_records.md` — ADR-001 primero. Define el stack. Sin él, ningún otro artefacto puede mencionar tecnologías concretas.
2. `technical_blueprint.md` — Define capas y MOD-xx. Requiere ADR-001 para la sintaxis de los skeletons.
3. `contract_definitions.md` — Formaliza las IC-xx del analysis_report con firmas de métodos y DTOs. Requiere ADR-001 para los tipos.
4. `dependency_graph.md` — Documenta DEP-xx entre MOD-xx e IC-xx. Requiere contract_definitions.md completo.
5. `test_strategy_map.md` — Cubre cada IC-xx con TS-xx e incluye la Guía de Vertical Slices. Requiere todos los anteriores.

**El Write de cada artefacto es el primer tool call después de completar su producción.
Sin excepción. No pasar al siguiente artefacto antes de haber escrito el actual en disco.**

---

## Reglas de transformación por artefacto

### architecture_decision_records.md — Transformar RT-xx y PT-xx en ADRs

**RT-xx → contexto del ADR-001:**

Cada RT-xx del analysis_report es una restricción dura para la selección de stack. Incluir
en la sección "Contexto" del ADR-001:
- La lista de RT-xx con su descripción exacta del analysis_report.
- El peso de cada RT-xx en la decisión (alto / medio / bajo).

Una RT-xx de peso alto elimina directamente una opción de stack — documentar esto en la
tabla "Opciones evaluadas" marcando la opción eliminada con `[incompatible con RT-xx]`.

**ADR-001 — Stack seleccionado:**

Reglas de la tabla "Opciones evaluadas":
- Mínimo 2 opciones reales. No incluir opciones obviamente descartables.
- Para cada opción: ≥2 pros y ≥2 contras concretos (no genéricos).
- Si una opción es eliminada por una RT-xx: mencionar la RT-xx en "Contras".

Reglas de "Criterios de decisión":
- Derivar los criterios de las RT-xx y del contexto del sistema (escala, equipo, integración).
- No inventar criterios no mencionados en los inputs.
- La opción seleccionada debe ganar en ≥50% de los criterios de peso alto.

**PT-xx → ADR adicional (patrón de diseño):**

Un ADR adicional por cada PT-xx que represente un patrón de diseño mayor (Repository, Strategy,
Factory, Observer, etc.). No crear ADR por detalles de implementación (ej. cómo nombrar variables).

Para cada ADR de patrón:
- El "Contexto" describe el problema técnico concreto del analysis_report que motiva el patrón.
- La "Decisión" describe cómo se aplica el patrón en este sistema con los CO-xx afectados.
- Las "Consecuencias aceptadas" son específicas al dominio (no genéricas del patrón).

Regla de trazabilidad: cada ADR-002..N debe referenciar el PT-xx origen del analysis_report.

---

### technical_blueprint.md — Transformar CO-xx en MOD-xx

**CO-xx → MOD-xx:**

Correspondencia 1-a-1 mínima: cada CO-xx del analysis_report genera al menos un MOD-xx. Un
bounded context complejo (múltiples responsabilidades en CO-xx) puede generar más de un MOD-xx,
pero un MOD-xx no puede corresponder a más de un CO-xx.

Reglas de asignación de capa a cada MOD-xx:
- Si el CO-xx contiene lógica de negocio pura → capa Dominio.
- Si el CO-xx orquesta casos de uso → capa Aplicación.
- Si el CO-xx gestiona persistencia, APIs externas o notificaciones → capa Infraestructura.
- Si un CO-xx tiene responsabilidades en múltiples capas (lo más común), crear la estructura
  de carpetas `domain/`, `application/`, `infrastructure/` dentro del MOD-xx.

Reglas de la "Estructura de carpetas":
- Usar el lenguaje definido en ADR-001 para las extensiones de archivo (`.py`, `.ts`, etc.).
- Los nombres de carpetas y archivos usan el lenguaje ubicuo del `domain_glossary.md`.
- Cada archivo en el skeleton corresponde a una clase o interface concreta (no archivos genéricos).

Reglas del "Skeleton de clases":
- Mostrar firmas de métodos, no implementaciones.
- Los métodos del skeleton se derivan de las operaciones de las IC-xx del analysis_report.
- No agregar métodos que no correspondan a operaciones identificadas en el analysis_report.
- Si un método es incierto, marcarlo con `# [PENDIENTE: verificar operación en IC-xx]`.

---

### contract_definitions.md — Formalizar IC-xx del analysis_report en contratos completos con DTO-xx

**IC-xx (analyst) → IC-xx (formalizado):**

Cada IC-xx del analysis_report tiene exactamente una entrada en `contract_definitions.md`.
Sin IC-xx del analysis_report sin contrato formal.

Reglas de las firmas de métodos:
- Derivar los métodos de las operaciones listadas en la IC-xx del analysis_report.
  El analyst listó operaciones como verbos (findById, save, list, send, notify) — transformarlas
  en métodos con tipos del lenguaje definido en ADR-001.
- Si el analysis_report no especifica los tipos exactos, usar los tipos de las entidades de
  `data_contracts.md` del 020 como referencia.
- Cada método que retorna datos debe retornar un DTO-xx, no una entidad de dominio directamente.
- Cada método que puede fallar debe tener un tipo de retorno que permita representar el error
  (Optional, Result type, o lanzar excepción — según la convención del ADR-001).

**IC-xx → DTO-xx (asociados a IC-xx):**

Para cada IC-xx, crear:
- ≥1 DTO-xx de request o response para la operación principal.
- ≥1 DTO-xx de error que incluya: código, mensaje, campo_afectado (opcional).

Reglas de los DTOs:
- Los campos del DTO se derivan de los atributos de la entidad en `data_contracts.md` del 020.
- No incluir campos que no existan en la entidad de `data_contracts.md` (regla de no-inferencia).
- Los tipos de los campos usan los tipos primitivos del lenguaje del ADR-001.
- Usar el decorator o convención del ADR-001 para DTOs (ej. `@dataclass` en Python, `interface` en TypeScript).

Regla especial para IC-xx de tipo Notifier:
- El DTO de request describe el evento que dispara la notificación.
- El DTO de response describe el resultado (enviado / fallido / pendiente).
- No usar tipos genéricos como `dict` o `object` — siempre DTOs tipados.

---

### dependency_graph.md — Transformar MOD-xx e IC-xx en DEP-xx

**IC-xx + MOD-xx → DEP-xx:**

Para cada IC-xx de `contract_definitions.md`, crear al menos un DEP-xx que documente:
- El MOD-xx que usa la IC-xx (cliente de la interface).
- El MOD-xx que implementa la IC-xx (implementación concreta — capa Infraestructura).
- El tipo de dependencia: Inyección de dependencia (el más común), Invocación directa, o Evento.

Regla de coherencia con ADR-001:
- El mecanismo de DI debe ser el definido en ADR-001. Si ADR-001 no especificó un framework de
  DI, documentar la estrategia de inyección manual (ej. "constructor injection sin framework").
- El scope (request / singleton / transient) se deriva de la naturaleza de la IC-xx:
  - Repository / Service → singleton es lo más común.
  - Notifier → singleton si el cliente es stateless.
  - Casos de uso → request scope si son stateful.

Reglas de las "Reglas de Dependencia":
- No eliminar las 4 reglas base del schema. Pueden ampliarse con reglas específicas del dominio.
- Si el analysis_report identificó dependencias entre bounded contexts, documentar cómo se
  resuelven via IC-xx (no imports directos entre módulos de dominio).

---

### test_strategy_map.md — Transformar IC-xx en TS-xx y Guía de Vertical Slices

**IC-xx → TS-xx:**

Cada IC-xx de `contract_definitions.md` genera exactamente un TS-xx. Sin IC-xx sin TS-xx.

Reglas de selección del nivel de test:
- `Unitario` (por defecto): para IC-xx de tipo Repository o Service cuyo comportamiento es
  lógica de negocio pura. El mock simula la persistencia o el servicio externo.
- `Integración`: para IC-xx de tipo Repository que acceden a una base de datos real o IC-xx
  de tipo API que llaman a un servicio real. El test usa infraestructura de test (ej. DB en memoria).
- `Contrato`: para IC-xx que definen el contrato entre dos componentes; el test verifica
  que la implementación cumple la interface (no la lógica interna).

Reglas del Mock/Stub de referencia:
- Usar la herramienta de mock del ADR-001 (ej. pytest-mock, Mockito, jest.fn()).
- El mock de referencia muestra solo los métodos que los tests del análisis necesitan.
- Los valores de retorno del mock se derivan de los SE-xx y SC-xx del `bdd_features.md` del 020.

Reglas de "Casos de test derivados de BDD":
- Derivar los casos de test de los SC-xx y SE-xx ya identificados para esta IC-xx en el
  analysis_report (el analyst los listó en las operaciones de cada IC-xx).
- Si no hay SC-xx asociados explícitos, buscar en `bdd_features.md` los Scenarios que
  involucran la entidad propietaria de la IC-xx.
- Al menos 2 casos de test por IC-xx: uno para el camino feliz y uno para el manejo de error.

**PT-xx → orientación del mock en TS-xx:**

Si el analysis_report tiene un PT-xx de tipo Strategy o Factory asociado a un CO-xx, los
TS-xx de ese CO-xx deben incluir un caso de test específico para verificar la variabilidad
del patrón (ej. que diferentes implementaciones del Strategy retornan resultados distintos).

**Guía de Vertical Slices (ADJ-04):**

Producir las 3 secciones: Tracer Bullet, MVP, Robustez. Esta sección es input directo para
el 040 Planning — debe ser completa, no un resumen.

Reglas de selección del Tracer Bullet:
- Seleccionar el SC-xx más simple que atraviese todas las capas del sistema (Dominio →
  Aplicación → Infraestructura → respuesta).
- El scope debe incluir exactamente 1 IC-xx de tipo Repository y 1 caso de uso.
- Si hay dudas, elegir el SC-xx de la funcionalidad más core según el `shared_understanding.md`.

Reglas del scope de MVP:
- Incluir todos los SC-xx de los flujos principales (caminos felices) del sistema.
- Incluir los SE-xx de manejo de error más críticos (los que tienen EP-xx en `error_exception_policy.md`).
- El MVP debe ser demostrable al cliente sin funcionalidades secundarias.

Reglas del scope de Robustez:
- Incluir todos los SC-xx y SE-xx restantes.
- Mencionar explícitamente qué umbrales de cobertura de test aplican (si `acceptance_criteria.md` los define).
- Si `acceptance_criteria.md` no define umbrales, escribir `[PENDIENTE: definir umbral de cobertura]`.

---

## Self-checklist del Demo Statement (ejecutar antes de reportar)

El governor pasa el Demo Statement al architect en el prompt de invocación. Antes de reportar
COMPLETED, verificar cada condición del Demo Statement contra los artefactos escritos en disco.

Demo Statement de referencia (del orchestration_plan):
> "Cuando design-architect termine, podré observar que: `technical_blueprint.md` define
> la estructura de capas y ≥1 módulo (MOD-xx) por bounded context; `contract_definitions.md`
> tiene ≥1 interface (IC-xx) por entidad de data_contracts.md; `dependency_graph.md` describe
> la estrategia de inyección de dependencias; `architecture_decision_records.md` incluye
> ADR-001 (stack) con opciones evaluadas y justificación; `test_strategy_map.md` cubre
> cada IC-xx con su estrategia de mock/stub."

Verificación del self-checklist:

- [ ] `design/architecture_decision_records.md` existe en disco con contenido
- [ ] ADR-001 tiene ≥2 opciones evaluadas con pros/contras y criterios de decisión con peso
- [ ] `design/technical_blueprint.md` existe en disco con contenido
- [ ] ≥1 MOD-xx por cada CO-xx del analysis_report
- [ ] `design/contract_definitions.md` existe en disco con contenido
- [ ] ≥1 IC-xx por cada IC-xx del analysis_report
- [ ] ≥1 DTO-xx de request/response + ≥1 DTO-xx de error por IC-xx
- [ ] `design/dependency_graph.md` existe en disco con contenido
- [ ] ≥1 DEP-xx por IC-xx que describe el punto de inyección
- [ ] `design/test_strategy_map.md` existe en disco con contenido
- [ ] ≥1 TS-xx por IC-xx con nivel de test y herramienta de mock
- [ ] Sección "Guía de Vertical Slices" con las 3 subsecciones: Tracer Bullet, MVP, Robustez

Si alguna condición falla: corregir con Edit antes de reportar. No reportar COMPLETED si alguna condición falla.

Si alguna condición falla por un gap bloqueante no resuelto (ej. ambigüedad de RT-xx que
impide seleccionar el stack): reportar `INCOMPLETO: <razón específica>` al governor. No
inventar una solución para desbloquear la condición.

---

## Checklist de consistencia cruzada (aplicar antes del self-checklist del Demo Statement)

Esta verificación es previa al self-checklist. Si algún ítem falla, corregir con Edit antes
de pasar al self-checklist del Demo Statement.

### Consistencia analysis_report → artefactos finales

- [ ] Cada CO-xx del analysis_report tiene ≥1 MOD-xx en `technical_blueprint.md`
- [ ] Cada IC-xx del analysis_report tiene ≥1 IC-xx en `contract_definitions.md`
- [ ] Cada PT-xx del analysis_report tiene ≥1 ADR en `architecture_decision_records.md`
- [ ] Cada RT-xx del analysis_report aparece en el contexto del ADR-001

### Consistencia entre artefactos finales

- [ ] Cada IC-xx de `contract_definitions.md` tiene ≥1 DEP-xx en `dependency_graph.md`
- [ ] Cada IC-xx de `contract_definitions.md` tiene ≥1 TS-xx en `test_strategy_map.md`
- [ ] Ningún artefacto menciona una tecnología no definida en ADR-001
- [ ] El lenguaje de los skeletons de código en `technical_blueprint.md` coincide con ADR-001
- [ ] Los tipos de los métodos en `contract_definitions.md` usan los tipos del lenguaje de ADR-001
- [ ] Las herramientas de mock en `test_strategy_map.md` son las del stack de ADR-001
- [ ] Los DEP-xx de `dependency_graph.md` referencian IC-xx que existen en `contract_definitions.md`

### Consistencia de lenguaje (domain_glossary)

- [ ] Los nombres de módulos (MOD-xx), interfaces (IC-xx) y DTOs (DTO-xx) usan términos del
  `domain_glossary.md` del 010. No crear nombres técnicos genéricos si el glosario define el término.
- [ ] Si un término nuevo es necesario (concepto técnico sin equivalente en el glosario), marcarlo
  con `[GLOSARIO: pendiente — nombre]` en el artefacto donde aparece por primera vez.

### Consistencia con artefactos del 020

- [ ] Los campos de los DTOs en `contract_definitions.md` son consistentes con los atributos de
  las entidades en `specification/data_contracts.md`. No agregar campos que no existan en el 020.
- [ ] Los TS-xx referencian SC-xx y SE-xx de `specification/bdd_features.md` que efectivamente
  existen. No referenciar IDs inventados.
- [ ] La Guía de Vertical Slices en `test_strategy_map.md` referencia SC-xx de
  `specification/bdd_features.md` para definir el scope de cada slice.
