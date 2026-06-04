---
name: vertical-evaluator-protocol
description: Protocolo de verificación por dimensión del vertical-evaluator en el 050 Vertical Harness. Define los procedimientos de verificación para D1 (Proposal & SDS Coverage), D2 (SDD Technical Depth), D3 (Testing Plan TDD Traceability), D4 (Execution Plan Actionability) y D5 (Consistency), con los checks cruzados de IDs entre los 5 artefactos y los artefactos de referencia del 040/030/020/010. Usar cuando vertical-evaluator ejecuta la evaluación de los 5 artefactos finales del 050 para la slice activa.
user-invocable: false
agent: vertical-evaluator
---

Procedimientos de verificación para las dimensiones D1–D5. Para cada dimensión, aplicar siempre
el protocolo de dos fases obligatorio (LL-07): Fase 1 (análisis: pros + contras con evidencia
citada del artefacto y sección) → Fase 2 (score con anclas de `vertical-rubric`).

No asignar un score sin haber construido la lista de pros y contras con evidencia concreta.

**Artefactos evaluados (leer directamente del filesystem — sin contexto de ejecución):**

Sustituir `VS-xx` por el ID real de la slice activa en todos los paths.

- `050_vertical/VS-xx/proposal.md`
- `050_vertical/VS-xx/software_design_specification.md`
- `050_vertical/VS-xx/software_design_document.md`
- `050_vertical/VS-xx/testing_plan.md`
- `050_vertical/VS-xx/execution_plan.md`

**Artefactos de referencia (fuentes de verdad independientes — leer para verificar D1–D5):**
- `040_planning/vertical_slice_plan.md` — lista canónica de IC-xx y BDD scenarios de la slice (D1, D4, D5)
- `030_design/contract_definitions.md` — definiciones de IC-xx; firma y DTOs (D2, D5)
- `030_design/test_strategy_map.md` — estrategia mock/stub por IC-xx (D3)
- `020_specification/bdd_features.md` — BDD scenarios SC-xx/SE-xx canónicos (D1, D5)
- `010_discovery/domain_glossary.md` — lenguaje ubicuo del dominio (D5)

**Principio de evaluación independiente:** C lee los artefactos del filesystem sin conocimiento
previo de lo que los Workers produjeron. No confiar en el execution-state.json ni en el
slice_analysis_report.md como fuentes de verdad — solo los 5 artefactos y los artefactos de
referencia son válidos para la evaluación.

---

## D1 — Proposal & SDS Coverage

**Pregunta:** ¿`proposal.md` cita todos los IC-xx y BDD scenarios de la slice según
`vertical_slice_plan.md`? ¿`software_design_specification.md` tiene ≥1 sección por BDD scenario
de la slice con flujo, contrato de datos y AC verificable? ¿Sin BDD scenarios huérfanos?

**Fuente de verificación independiente:** leer `040_planning/vertical_slice_plan.md` directamente,
sección VS-xx activa, para extraer la lista canónica de IC-xx y SC-xx/SE-xx de la slice.

**Fase 1 — qué buscar:**

Pros (registrar con referencia de sección del artefacto):
- `proposal.md` lista cada IC-xx de la slice con nombre de interfaz y descripción funcional.
- `proposal.md` lista cada SC-xx/SE-xx de la slice con nombre, tipo y descripción.
- `software_design_specification.md` tiene sección propia para cada SC-xx/SE-xx de la slice.
- Cada sección de la SDS tiene: Given/When/Then completo, flujo paso a paso, contrato de datos (request + response DTO con campos tipados), código de error esperado (para SE-xx) y criterio de aceptación verificable.
- Los criterios de aceptación en la SDS son trazables a `acceptance_criteria.md` (citar textualmente, no parafrasear).

Contras (registrar con cita concreta — artefacto + sección + ID específico):
- IC-xx en `vertical_slice_plan.md` sección VS-xx que no aparece en `proposal.md` tabla de scope → IC-xx huérfano.
- SC-xx/SE-xx en `vertical_slice_plan.md` sección VS-xx que no aparece en `proposal.md` tabla de scope → scenario huérfano en proposal.
- SC-xx/SE-xx de la slice sin sección propia en `software_design_specification.md` → scenario huérfano en SDS.
- Sección de SC-xx en SDS sin flujo paso a paso (solo descripción general) → gap de D1.
- Sección de SC-xx en SDS sin contrato de datos (sin DTOs de request o response) → gap de D1.
- Sección de SC-xx en SDS sin criterio de aceptación verificable (sin referencia a ID de AC) → gap de D1.
- Sección de SE-xx en SDS sin código de error esperado ni nombre de DTO de error → gap de D1.

**Check cruzado obligatorio:**
1. Extraer lista de IC-xx de la sección VS-xx en `vertical_slice_plan.md` (lista A).
2. Extraer IC-xx listados en `proposal.md` tabla de scope (lista B).
3. IC-xx en A no presentes en B → huérfanos en proposal → contra por cada uno.
4. Extraer lista de SC-xx/SE-xx de la sección VS-xx en `vertical_slice_plan.md` (lista C).
5. Extraer SC-xx/SE-xx listados en `proposal.md` tabla de scope (lista D).
6. SC-xx/SE-xx en C no presentes en D → huérfanos en proposal → contra por cada uno.
7. Extraer secciones de SC-xx/SE-xx en `software_design_specification.md` (lista E).
8. SC-xx/SE-xx en C no presentes en E → huérfanos en SDS → contra por cada uno.

**Fase 2:** asignar score según anclas de `vertical-rubric`.

---

## D2 — SDD Technical Depth

**Pregunta:** ¿`software_design_document.md` referencia solo IC-xx de la slice definidos en
`contract_definitions.md`? ¿Cada IC-xx tiene firma técnica completa, módulo asignado (MOD-xx)
y estrategia de DI? ¿Consistente con el stack del ADR-001?

**Fuente de verificación independiente:** leer `030_design/contract_definitions.md` para extraer
la lista canónica de IC-xx y sus definiciones (firma, DTOs). Leer `040_planning/vertical_slice_plan.md`
sección VS-xx para la lista de IC-xx que deben aparecer en el SDD.

**Fase 1 — qué buscar:**

Pros (registrar con referencia de sección):
- Cada IC-xx de la slice activa tiene sección propia en `software_design_document.md`.
- Cada sección de IC-xx tiene: nombre de interfaz, módulo asignado (MOD-xx), responsabilidad en términos de dominio.
- La firma de la interfaz está completa: todos los métodos con parámetros tipados y tipo de retorno.
- Los DTOs están definidos: request, response y error (con campos y tipos). No falta ningún DTO.
- La estrategia de Dependency Injection está documentada: clase implementadora, punto de inyección, quién la consume.
- El orden de implementación de componentes está documentado al final del SDD.
- El stack (lenguaje, tipos, patrones) es consistente con el ADR-001.
- Los nombres de interfaces y métodos en el SDD son idénticos a los usados en SDS, testing_plan y execution_plan.

Contras (registrar con cita concreta):
- IC-xx de la slice sin sección propia en el SDD → IC-xx faltante → contra directo.
- Sección de IC-xx en SDD sin firma de métodos (solo descripción textual) → contra directo.
- Método de IC-xx en `contract_definitions.md` que no aparece en la firma del SDD → método faltante.
- DTO de request o response definido en `contract_definitions.md` que no aparece en el SDD → DTO faltante.
- DTO de error sin código HTTP ni nombre del DTO → contra.
- Estrategia de DI ausente para una IC-xx → contra.
- Nombre de interfaz o método diferente entre SDD y SDS (ej. `getById` en SDD vs `findById` en SDS) → inconsistencia de firma → contra.
- Tipo de dato incompatible con el stack del ADR-001 (ej. usar `List<T>` en Python puro) → contra.
- IC-xx en el SDD que no existe en `contract_definitions.md` → ID inventado → contra directo.

**Check cruzado obligatorio:**
1. Extraer todos los IC-xx de la sección VS-xx en `vertical_slice_plan.md` (lista A).
2. Extraer todos los IC-xx que tienen sección en `software_design_document.md` (lista B).
3. IC-xx en A no presentes en B → faltantes en SDD → contra por cada uno.
4. IC-xx en B no presentes en `contract_definitions.md` → IC-xx inventados → contra por cada uno.
5. Para cada IC-xx en B: contar métodos en la firma del SDD vs métodos en `contract_definitions.md`. Diferencia → métodos faltantes.

**Fase 2:** asignar score según anclas de `vertical-rubric`.

---

## D3 — Testing Plan TDD Traceability

**Pregunta:** ¿`testing_plan.md` tiene ≥1 estrategia de test por IC-xx de la slice, consistente
con la estrategia mock/stub de `test_strategy_map.md`? ¿Define los tres niveles (unitario,
integración, contrato)? ¿Especifica la fase Red explícitamente?

**Fuente de verificación independiente:** leer `030_design/test_strategy_map.md` para extraer
la estrategia mock/stub definida por el 030 para cada IC-xx de la slice activa.

**Fase 1 — qué buscar:**

Pros (registrar con referencia de sección):
- Cada IC-xx de la slice tiene sección propia en `testing_plan.md` con estrategia de mock/stub.
- La estrategia mock/stub de cada IC-xx es coherente con `test_strategy_map.md` (mismo tipo: Fake/Mock/Real).
- Existe sección "Red phase" explícita con lista de tests a escribir primero, nombrados, con tipo y razón de fallo.
- La Red phase cita el IC-xx y el SC-xx/SE-xx que cada test ejercita.
- El fragmento de mock/stub configurable está presente para cada IC-xx (con código del framework del ADR-001).
- La pirámide de tests está definida con conteos por nivel (unitario, integración, contrato).
- La sección "Orden Red → Green por BDD Scenario" está presente para cada SC-xx/SE-xx de la slice.
- El criterio mínimo de cobertura es concreto y verificable (ej. ≥80% de líneas).

Contras (registrar con cita concreta):
- IC-xx de la slice sin sección en `testing_plan.md` → IC-xx sin cobertura de test → contra directo.
- Estrategia mock para un IC-xx diferente de la definida en `test_strategy_map.md` sin nota justificativa → contra.
- Sección de Red phase ausente (o presente pero sin tests nombrados específicamente) → contra directo.
- Tests en la Red phase sin IC-xx ni SC-xx/SE-xx de referencia → tests abstractos → contra.
- Pirámide de tests ausente o sin conteos → contra.
- Sección "Orden Red → Green" ausente para ≥1 SC-xx/SE-xx de la slice → contra.
- Criterio de cobertura genérico ("la mayor cobertura posible") sin porcentaje o regla concreta → contra menor.
- Fragmento de mock/stub ausente para ≥1 IC-xx → contra.

**Check cruzado obligatorio:**
1. Extraer lista de IC-xx de la sección VS-xx en `vertical_slice_plan.md` (lista A).
2. Extraer IC-xx con sección propia en `testing_plan.md` (lista B).
3. IC-xx en A no presentes en B → sin cobertura de test → contra por cada uno.
4. Para cada IC-xx en B: comparar tipo de mock (Fake/Mock/Real) con `test_strategy_map.md`.
   Discrepancia sin justificación → contra.

**Fase 2:** asignar score según anclas de `vertical-rubric`.

---

## D4 — Execution Plan Actionability

**Pregunta:** ¿`execution_plan.md` descompone la slice en Features → Tickets → Tasks? ¿Cada
Task cita el IC-xx o SC-xx/SE-xx que implementa? ¿Todos los IC-xx de la slice están en ≥1
Task? ¿Orden TDD explícito (Red→Green→Refactor)? ¿Criterio de Done verificable por Ticket?

**Fase 1 — qué buscar:**

Pros (registrar con referencia de sección):
- La estructura jerárquica Features (FT-xx) → Tickets (TK-xx) → Tasks (TA-xx) está presente.
- Cada Task cita el IC-xx o SC-xx/SE-xx que implementa o prueba.
- El orden TDD es explícito en cada Ticket: TA-Red (escribir test), TA-Green (implementar), TA-Refactor (o "Sin refactor documentado").
- Todos los IC-xx de la slice aparecen en ≥1 Task del execution_plan.
- Cada Ticket tiene Criterio de Done verificable con referencia a SC-xx/SE-xx o IC-xx específicos.
- La tabla "Verificación de cobertura de IC-xx" al final del execution_plan está completa y correcta.
- La convención de IDs (FT-xx/TK-xx/TA-xx locales a la slice) está documentada.
- Las Tasks TA-Red describen el test a escribir con nombre concreto del test.
- Las Tasks TA-Green describen el método de IC-xx a implementar.

Contras (registrar con cita concreta):
- IC-xx de la slice sin ninguna Task en el execution_plan → IC-xx sin cobertura → contra directo por cada uno.
- Task sin referencia a IC-xx ni SC-xx/SE-xx → tarea abstracta → contra.
- Ticket sin Criterio de Done o con Criterio de Done genérico ("implementar la funcionalidad") → contra.
- Criterio de Done de Ticket sin referencias a SC-xx/SE-xx ni IC-xx específicos → contra.
- Ticket sin TA-Red (no hay tarea de escribir test primero) → ausencia de TDD → contra.
- TA-Red sin nombre concreto del test → no accionable → contra menor.
- Ticket con solo TA-Green sin TA-Red (implementación sin test previo) → inversión TDD → contra.
- IC-xx en execution_plan que no existe en `vertical_slice_plan.md` sección VS-xx → ID inventado → contra.
- SC-xx/SE-xx en Criterio de Done de Ticket que no existe en `bdd_features.md` → ID inventado → contra.

**Check cruzado obligatorio:**
1. Extraer lista de IC-xx de la sección VS-xx en `vertical_slice_plan.md` (lista A).
2. Extraer todos los IC-xx referenciados en Tasks del `execution_plan.md` (lista B).
3. IC-xx en A no presentes en B → sin Task asignada → contra directo por cada uno.
4. Extraer lista de SC-xx/SE-xx de la sección VS-xx en `vertical_slice_plan.md` (lista C).
5. Verificar que cada SC-xx/SE-xx en C aparece en el Criterio de Done de ≥1 Ticket.
6. SC-xx/SE-xx en C sin Criterio de Done de Ticket → scenario no cubierto → contra.

**Fase 2:** asignar score según anclas de `vertical-rubric`.

---

## D5 — Consistency

**Pregunta:** ¿Sin contradicciones entre los 5 artefactos? ¿Sin IC-xx referenciados que no
existan en `contract_definitions.md`? ¿Sin BDD scenarios que no existan en `bdd_features.md`?
¿Lenguaje ubicuo del glosario usado consistentemente?

**Fase 1 — verificaciones concretas a ejecutar (en orden):**

**Verificación 1 — Firma técnica canónica:**
- Extraer todos los nombres de interfaces y métodos de `software_design_document.md`.
- Verificar que los mismos nombres aparecen en `software_design_specification.md` (DTOs, contratos).
- Verificar que los mismos nombres aparecen en `testing_plan.md` (mocks configurables).
- Verificar que los mismos nombres aparecen en `execution_plan.md` (Tasks que los citan).
- Nombre de interfaz o método diferente entre dos artefactos → contra directo (sin nota de aclaración = contradicción silenciosa).

**Verificación 2 — IC-xx contra fuente de verdad externa:**
- Extraer todos los IC-xx referenciados en cualquiera de los 5 artefactos.
- Leer `030_design/contract_definitions.md`: extraer todos los IC-xx definidos.
- IC-xx en los 5 artefactos que no existe en `contract_definitions.md` → ID inventado → contra directo.

**Verificación 3 — BDD scenarios contra fuente de verdad externa:**
- Extraer todos los SC-xx/SE-xx referenciados en cualquiera de los 5 artefactos.
- Leer `020_specification/bdd_features.md`: extraer todos los SC-xx/SE-xx definidos.
- SC-xx/SE-xx en los 5 artefactos que no existe en `bdd_features.md` → ID inventado → contra directo.

**Verificación 4 — Scope de la slice (sin mezcla entre slices):**
- Extraer lista de IC-xx de la sección VS-xx en `vertical_slice_plan.md` (canónica para la slice activa).
- Verificar que los 5 artefactos no referencian IC-xx de otras slices sin nota explícita de dependencia.
- IC-xx de otra slice en un artefacto sin nota de dependencia → contra.
- Extraer lista de SC-xx/SE-xx de la sección VS-xx en `vertical_slice_plan.md`.
- Verificar que `software_design_specification.md` no tiene secciones para scenarios de otras slices.
- SC-xx/SE-xx de otra slice en la SDS → contra.

**Verificación 5 — Lenguaje ubicuo:**
- Leer `010_discovery/domain_glossary.md`.
- Verificar que los términos de negocio en los 5 artefactos son consistentes con el glosario.
- Un término de negocio usado con definición diferente a la del glosario → contra.
- Un término nuevo sin nota `(término técnico — no en glosario)` → contra menor.

**Regla de veto — definición operacional:**

D5 = 0.0 se asigna cuando existe una contradicción directa y no documentada entre artefactos.
Una inconsistencia documentada (marcada con `[PENDIENTE]` o nota explícita) **no activa el veto**.

Activa el veto:
- `software_design_document.md` llama al método `crearReserva()` pero `software_design_specification.md` lo llama `crear()` — misma interfaz, firma diferente, sin nota.
- `execution_plan.md` asigna IC-04 a tasks de VS-02, pero IC-04 no está en la lista de IC-xx de VS-02 según `vertical_slice_plan.md` — sin nota de dependencia.
- `testing_plan.md` configura mock de IC-05 (de VS-03) en sección de VS-02 — IC-xx de otra slice mezclada.
- `execution_plan.md` tiene Ticket para SE-08 que no aparece en los BDD scenarios de la slice según `bdd_features.md` — ID no reconocido.
- Los 5 artefactos dicen `IReservaRepository` pero `contract_definitions.md` define `IRepositorioReserva` — nombre diferente sin documentar la decisión de renombrar.

No activa el veto:
- Inconsistencia marcada con `[PENDIENTE: razón]` — es conocida y puede resolverse.
- Diferencia menor en un campo DTO que el writer notó y documentó en el artefacto.

**Fase 2:** asignar score. Si existe cualquier contradicción directa y silenciosa → D5 = 0.0.

---

## PATHS DE SALIDA — OBLIGATORIO (LL-03)

C escribe únicamente en la carpeta `eval/`. Nunca escribe en `/050_vertical/`.

1. **verdict.json** — `eval/verdict.json` — append al array existente, entrada con
   `"phase": "050_vertical"` y `"slice_id": "[VS-xx activa]"`.
   Usar el schema de `vertical-verdict-schema`.
2. **metrics_summary.json** — `eval/metrics_summary.json` — append al array existente.
   Usar el schema de `vertical-verdict-schema`.
3. **claude-progress.txt** — `persistence/claude-progress.txt` — registrar auditoría con
   `Add-Content -Encoding utf8`. Formato: `[AUDIT VS-xx 050 VERTICAL] APPROVED/REJECTED — avg [score]`.

C no crea ni modifica ningún archivo en `/050_vertical/VS-xx/`. Si detecta un error en un
artefacto durante la evaluación, lo documenta en el `findings` de `verdict.json` —
no corrige el artefacto directamente.
