---
name: design-evaluator-protocol
description: Protocolo de verificación por dimensión del design-evaluator en el 030 Design Harness. Define los procedimientos de verificación para D1 (Blueprint Coverage), D2 (Contract Completeness), D3 (Testability), D4 (ADR Completeness) y D5 (Consistency), con los checks cruzados entre los 5 artefactos. Usar cuando design-evaluator ejecuta la evaluación de los 5 artefactos finales del 030.
user-invocable: false
agent: design-evaluator
---

Procedimientos de verificación para las dimensiones D1–D5. Para cada dimensión, aplicar siempre
el protocolo de dos fases obligatorio (LL-07): Fase 1 (análisis: pros + contras con evidencia
citada del artefacto y sección) → Fase 2 (score con anclas de `design-rubric`).

No asignar un score sin haber construido la lista de pros y contras con evidencia concreta.

---

## D1 — Blueprint Coverage

**Pregunta:** ¿Todos los bounded contexts de `bdd_features.md` tienen ≥1 módulo (MOD-xx)
en `technical_blueprint.md` con estructura de capas coherente?

**Fuente de verificación independiente:** leer `specification/bdd_features.md` directamente
para identificar los bounded contexts. No depender del `design_analysis_report.md` — este
puede tener gaps. Los bounded contexts en BDD se identifican por Features o grupos de Scenarios
relacionados por actor o dominio.

**Fase 1 — qué buscar:**

Pros (registrar con referencia de sección):
- Módulos MOD-xx presentes en `technical_blueprint.md` con nombre reconocible como bounded context.
- Cada MOD-xx tiene estructura de capas (al menos `domain/` e `infrastructure/`).
- Skeletons de clases e interfaces presentes para las responsabilidades principales del módulo.
- Resumen de módulos al final del artefacto que lista todos los MOD-xx con su CO-xx origen.

Contras (registrar con cita concreta — artefacto + sección + ID):
- Bounded context identificado en `bdd_features.md` sin MOD-xx correspondiente en el blueprint.
- MOD-xx sin estructura de capas (solo una carpeta raíz sin subdivisión de responsabilidades).
- MOD-xx en el resumen que no tiene su sección de detalle en el artefacto.
- Skeletons de clases con nombres genéricos que no usan el lenguaje ubicuo del `domain_glossary.md`.
- MOD-xx que agrupa bounded contexts de dominios diferentes sin justificación.

**Fase 2:** asignar score según anclas de `design-rubric`.

---

## D2 — Contract Completeness

**Pregunta:** ¿Todas las entidades de `data_contracts.md` del 020 tienen interface técnica
(IC-xx) y DTOs en `contract_definitions.md`? ¿Sin entidades huérfanas ni interfaces sin entidad?

**Fuente de verificación independiente:** leer `specification/data_contracts.md` directamente
para extraer la lista de entidades EN-xx. Verificar cobertura contra `design/contract_definitions.md`.

**Fase 1 — qué buscar:**

Pros (registrar con referencia de sección):
- Cada entidad EN-xx del 020 tiene al menos una IC-xx en `contract_definitions.md`.
- Cada IC-xx tiene métodos tipados con tipos del lenguaje del ADR-001 (no pseudocódigo genérico).
- Cada IC-xx tiene ≥1 DTO-xx de request/response y ≥1 DTO-xx de error.
- Tabla de resumen de contratos presente y coherente con las secciones de detalle.
- Tabla de resumen de DTOs presente y lista todos los DTO-xx definidos.

Contras (registrar con cita concreta):
- Entidad EN-xx del 020 sin IC-xx correspondiente en `contract_definitions.md` (entidad huérfana).
- IC-xx sin métodos definidos o con métodos sin tipos (pseudocódigo).
- IC-xx sin ningún DTO-xx asociado.
- IC-xx sin DTO-xx de error (solo DTO de request/response).
- DTO-xx con campos que no existen en la entidad EN-xx de `data_contracts.md` del 020
  (violación de la regla de no-inferencia del architect).
- IC-xx en `contract_definitions.md` sin IC-xx origen en el `design_analysis_report.md`
  (interface inventada sin base en el análisis).

**Check cruzado obligatorio:**
Para cada IC-xx en `contract_definitions.md`, verificar que existe una IC-xx correspondiente en `design/design_analysis_report.md`
(`IC-xx origen (analysis_report): IC-xx`). Si una IC-xx en contract_definitions no tiene origen en el analysis_report,
registrar como contra directo.

**Fase 2:** asignar score.

---

## D3 — Testability

**Pregunta:** ¿Cada interface (IC-xx) tiene ≥1 TS-xx en `test_strategy_map.md`? ¿La Guía de
Vertical Slices tiene las 3 secciones obligatorias? ¿La estrategia de DI en `dependency_graph.md`
es coherente con la testabilidad?

**Fase 1 — qué buscar:**

Pros (registrar con referencia de sección):
- Cada IC-xx de `contract_definitions.md` tiene al menos un TS-xx en `test_strategy_map.md`.
- Cada TS-xx especifica herramienta de mock/stub (no genérica — concreta del stack del ADR-001).
- Cada TS-xx incluye casos de test derivados de BDD con SC-xx o SE-xx referenciados.
- La Guía de Vertical Slices tiene las 3 secciones: Tracer Bullet, MVP y Robustez.
- Cada sección de la Guía tiene: scope (módulos + interfaces), artefactos técnicos necesarios y criterio de éxito.
- La estrategia de DI en `dependency_graph.md` usa puntos de inyección por constructor (coherente con TDD).

Contras (registrar con cita concreta):
- IC-xx en `contract_definitions.md` sin TS-xx en `test_strategy_map.md`.
- TS-xx con herramienta genérica ("usar un mock" sin especificar qué herramienta del stack).
- TS-xx sin casos de test derivados de BDD o con referencias a SC-xx/SE-xx inexistentes.
- Guía de Vertical Slices incompleta: falta alguna de las 3 secciones obligatorias.
- Sección de Vertical Slices sin criterio de éxito concreto.
- Mock/stub de referencia en TS-xx que usa tipos genéricos (dict, object) en lugar de los DTOs
  definidos en `contract_definitions.md`.

**Check cruzado obligatorio:**
1. Extraer todos los IC-xx de `contract_definitions.md`.
2. Extraer todos los IC-xx referenciados en `test_strategy_map.md` (tabla de resumen de cobertura).
3. Identificar IC-xx presentes en contract_definitions pero ausentes en test_strategy_map → contra directo por cada una.

**Fase 2:** asignar score.

---

## D4 — ADR Completeness

**Pregunta:** ¿ADR-001 incluye contexto con RT-xx, ≥2 opciones evaluadas con pros/contras,
criterios de decisión con peso y decisión final justificada? ¿Cada patrón mayor tiene su ADR?

**Fase 1 — qué buscar:**

Pros (registrar con referencia de sección):
- ADR-001 existe y tiene sección "Contexto" que menciona las RT-xx del 030.
- ADR-001 tiene ≥2 opciones evaluadas con ≥2 pros y ≥2 contras por opción.
- ADR-001 tiene tabla "Criterios de decisión" con peso (alto/medio/bajo) por criterio.
- ADR-001 tiene sección "Consecuencias aceptadas" con trade-offs específicos al sistema.
- ADRs adicionales para cada PT-xx del design_analysis_report (patrón Repository, Strategy, etc.).
- Cada ADR adicional referencia el PT-xx origen y describe el problema concreto que resuelve.

Contras (registrar con cita concreta):
- ADR-001 ausente (falta el primer ADR).
- ADR-001 con menos de 2 opciones evaluadas.
- ADR-001 con opciones evaluadas pero sin criterios de decisión con peso.
- ADR-001 sin sección "Consecuencias aceptadas" o con consecuencias genéricas no específicas al dominio.
- Patrón de diseño mencionado en `technical_blueprint.md` o `contract_definitions.md` sin ADR correspondiente.
- ADR adicional que no referencia el PT-xx origen del analysis_report.

**Verificación de coherencia ADR-001 → artefactos:**
- Leer el stack seleccionado en ADR-001 (lenguaje, framework, ORM).
- Verificar que los skeletons en `technical_blueprint.md` usan ese lenguaje.
- Verificar que los tipos de datos en `contract_definitions.md` son tipos de ese lenguaje.
- Verificar que las herramientas de mock en `test_strategy_map.md` son del ecosistema de ese lenguaje.
- Cualquier discrepancia → contra para D4 Y contra para D5.

**Fase 2:** asignar score.

---

## D5 — Consistency

**Pregunta:** ¿Sin contradicciones entre los 5 artefactos? ¿Sin contradicciones con los inputs
del 020/010? ¿Lenguaje ubicuo del glosario usado consistentemente?

**Fase 1 — verificaciones concretas a ejecutar (en orden):**

**Verificación 1 — Tecnología consistente (ADR-001 como árbitro):**
Leer el stack del ADR-001. Verificar en cada uno de los otros 4 artefactos:
- `technical_blueprint.md`: ¿los skeletons usan el lenguaje del ADR-001?
- `contract_definitions.md`: ¿los tipos son del lenguaje del ADR-001?
- `dependency_graph.md`: ¿el mecanismo de DI es compatible con el framework del ADR-001?
- `test_strategy_map.md`: ¿las herramientas de mock son del ecosistema del ADR-001?
Cualquier tecnología no definida en ADR-001 que aparezca en otros artefactos → contra directo.

**Verificación 2 — IDs cruzados entre artefactos:**
- Cada MOD-xx en `technical_blueprint.md` debe aparecer en la tabla de dependencias de `dependency_graph.md`.
- Cada IC-xx en `contract_definitions.md` debe tener ≥1 DEP-xx en `dependency_graph.md`.
- Cada IC-xx en `contract_definitions.md` debe tener ≥1 TS-xx en `test_strategy_map.md`.
- Cada DEP-xx en `dependency_graph.md` debe referenciar un IC-xx que existe en `contract_definitions.md`.
- Cada TS-xx en `test_strategy_map.md` debe referenciar un IC-xx que existe en `contract_definitions.md`.

Para cada ID referenciado que no existe en el artefacto esperado → registrar como contra.

**Verificación 3 — Coherencia con inputs del 020:**
- Leer `specification/bdd_features.md`: ¿los actores y bounded contexts están representados en el blueprint?
- Leer `specification/data_contracts.md`: ¿los campos de los DTOs en `contract_definitions.md`
  corresponden a los atributos de las entidades del 020? Un campo presente en un DTO pero ausente
  en la entidad EN-xx del 020 sin justificación → contra.
- Los SC-xx y SE-xx referenciados en `test_strategy_map.md` deben existir en `bdd_features.md`.

**Verificación 4 — Lenguaje ubicuo:**
- Leer `discovery/domain_glossary.md`.
- Verificar que los nombres de módulos (MOD-xx), interfaces (IC-xx), clases y DTOs en los 5
  artefactos corresponden a los términos del glosario cuando existe un término equivalente.
- Un término de negocio usado con definición diferente a la del glosario → contra.
- Un término nuevo sin `[GLOSARIO: pendiente — nombre]` → contra menor.

**Verificación 5 — Reglas de arquitectura respetadas:**
- `technical_blueprint.md` declara reglas de dependencia entre capas. Verificar que
  `dependency_graph.md` no tiene DEP-xx que violen esas reglas (ej. un módulo de Dominio
  dependiendo de Infraestructura directamente sin IC-xx intermedia).
- Las reglas de dependencia en `dependency_graph.md` son consistentes entre sí (sin DEP-xx
  que se contradigan mutuamente).

**Regla de veto — definición operacional:**
- **Activa el veto (D5 = 0.0):** contradicción directa y silenciosa entre artefactos. Ejemplos:
  - `technical_blueprint.md` usa TypeScript pero ADR-001 seleccionó Python.
  - `contract_definitions.md` define `IC-01` con método `save()` pero `test_strategy_map.md`
    muestra un mock de `IC-01` con método `store()` sin nota de discrepancia.
  - `dependency_graph.md` tiene `DEP-05: MOD-02-Dominio → BD-Postgres` (dependencia directa de
    Dominio a infraestructura) cuando `technical_blueprint.md` declaró que Dominio no importa Infraestructura.
- **No activa el veto:** inconsistencia documentada con marcador `[PENDIENTE]` o nota explícita.
  Es una advertencia, no una contradicción silenciosa.

**Fase 2:** asignar score. Si existe cualquier contradicción directa y silenciosa → D5 = 0.0.
