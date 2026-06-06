# Ajustes Pendientes de Implementación

Registro de ajustes identificados que aún no han sido implementados.

> **Historial completo:** ver `support/history/ajustes_design.md` (ADJ-13..ADJ-32 del 030 Design Harness) y `support/history/ajustes_vertical.md` (ADJ-04..ADJ-37 del 050 Vertical Harness).

---

## Tabla de Estado

| ID     | Descripción                                                                                                 | Prioridad     | Estado    |
| ------ | ----------------------------------------------------------------------------------------------------------- | ------------- | --------- |
| IMP-22 | No hay mecanismo de knowledge cross-project — aprendizajes no viajan entre proyectos                        | SIGNIFICATIVA | DISEÑADO — PENDIENTE IMPL. |
| IMP-28 | No existe dashboard HTML en tiempo real para observar el progreso del harness                               | MENOR         | PENDIENTE |
| ADJ-06 | Harness 060 Isolation: limitar ejecución a la vertical slice / iteración activa                             | MENOR         | DISEÑADO — documentado en blueprint del 050 (Sesión 79); pendiente de implementar en el 060 |
| ADJ-07 | Harness 070 Execution: renombrar a "070 Development Harness" y reasignar numeración                         | MENOR         | DISEÑADO — nombre 070 Development Harness confirmado (Sesión 79); pendiente de construir el harness |
| ADJ-08 | README.md del proyecto: incluirlo en `deploy-harness.ps1` para que se copie al cliente                     | MENOR         | PENDIENTE |
| ADJ-12 | Meta-Harness: referencia académica para optimización automática de harnesses                                | MENOR         | PENDIENTE |
| ADJ-24 | 010 Discovery: modelo de entrevista síncrona genera latencia y limita paralelismo — evaluar modelo async con cuestionario + ronda de gaps | SIGNIFICATIVA | PENDIENTE — evaluar antes de construir el 040 |
| ADJ-31 | Comando /forge-changes + 100 Change Harness                                                                 | SIGNIFICATIVA | PENDIENTE |
| ADJ-38 | 080 Harness: diseñar como Regression & Validation Harness, no como simple escritor de PROD_READY            | SIGNIFICATIVA | PENDIENTE |
| ADJ-39 | 010 Discovery: el dialoguer debe preguntar explícitamente sobre observabilidad del sistema en producción     | SIGNIFICATIVA | IMPLEMENTADO |
| ADJ-40 | Agentes deployados no se registran como subagent types — Agent(subagent_type) falla en proyectos cliente    | CRÍTICA       | IMPLEMENTADO |
| ADJ-41 | 030 Design: Demo Statements en design-orchestrator y design-state-schema desactualizados — faltan RS-xx, RE-xx, CAP (analyst) y ADR-002..005, secciones blueprint (architect). `done_criteria` en state-schema tiene 5 de 10 criterios. | SIGNIFICATIVA | IMPLEMENTADO |

---

## Detalle

### IMP-22 — Knowledge cross-project con PostgreSQL + pgvector — DISEÑADO — PENDIENTE IMPL.

**Prioridad:** SIGNIFICATIVA

**Problema:**
El `knowledge/` es local a cada proyecto. Al iniciar un proyecto nuevo, el banco de lecciones
aprendidas y decisiones tomadas arranca vacío.

**Prerequisitos antes de implementar:**
- Al menos 3-5 proyectos completos para tener volumen suficiente
- Decidir schema de tablas y estrategia de embeddings
- Analizar si el schema del 010 es extensible a los 9 harnesses

**Arquitectura objetivo:**

**Fase 1 — Persistencia dual:**
- Governor escribe en `knowledge/*.md` locales Y en PostgreSQL al cerrar cada proyecto.

**Fase 2 — Búsqueda semántica con pgvector:**
- Governor consulta la DB con el brief como query y recupera las N entradas más relevantes.

---

### IMP-28 — Dashboard HTML en tiempo real — PENDIENTE

**Prioridad:** MENOR

**Problema:** No hay visibilidad en tiempo real del progreso del harness.

**Arquitectura:**
- `dashboard.html` en la raíz del proyecto cliente (copiado por `deploy-harness.ps1`)
- JavaScript con `setInterval` cada 3 segundos hace `fetch()` a los archivos de estado
- Requiere servidor HTTP local mínimo (`python -m http.server 8080`)

**Contenido:** Timeline de `claude-progress.txt`, estado actual desde `harness-state.json`, checkpoints CP-01..CP-04 desde `execution-state.json`, artefactos producidos.

---

### ADJ-06 — Harness 060 Isolation: limitar a la vertical slice activa — DISEÑADO

**Prioridad:** MENOR

**Descripción:**
El 060 Isolation se ejecutará exclusivamente en el contexto de la vertical slice activa
definida en el 040 y especificada en el 050. No opera sobre el proyecto completo.

**Decisión documentada (Sesión 79):** condición de activación del 060: `harness-state.json`
debe tener `"050_vertical.slices.VS-xx": "DOCS_READY"`. Pendiente de implementar al
construir el harness 060.

---

### ADJ-07 — Harness 070/080: renombrar y reasignar numeración — DISEÑADO

**Prioridad:** MENOR

**Descripción:**
- `070_execution_harness` pasa a llamarse **`070 Development Harness`** (confirmado en Sesión 79).
- Revisar la numeración de todos los harnesses afectados para mantener coherencia en la secuencia 010–090.
- El 070 es responsable de escribir `"050_vertical.slices.VS-xx": "SLICE_COMPLETE"` en `harness-state.json` al cerrar cada slice (único handshake cross-harness de FORGE).

---

### ADJ-08 — README.md del proyecto: incluir en deploy-harness.ps1 — PENDIENTE

**Prioridad:** MENOR

**Descripción:**
Incluir en `deploy-harness.ps1` la lógica para copiar el README al proyecto cliente. Solo copiar si no existe en el destino (no sobreescribir en re-deployments).

---

### ADJ-12 — Meta-Harness: referencia académica para optimización automática — PENDIENTE

**Prioridad:** MENOR

**Referencia:** "Meta-Harness: End-to-End Optimization of Model Harnesses" (Stanford + MIT, Marzo 2026).

**Aplicación:** Nuestros harnesses ya tienen `eval/verdict.json` (reward signal) y `metrics_summary.json` (trazabilidad). Con OBS-01 (telemetría) tendríamos los traces para implementar un meta-harness que optimice automáticamente prompts, orden de workers y umbrales de gate para harnesses 030–090.

**Nota:** Referencial — no requiere implementación inmediata.

---

### ADJ-24 — 010 Discovery: evaluar modelo async con cuestionario + ronda de gaps — PENDIENTE

**Prioridad:** SIGNIFICATIVA

**Problema:**
El modelo actual de entrevista socrática síncrona (dialoguer pregunta → usuario responde → dialoguer formula siguiente pregunta) genera dos fricciones:
1. **Latencia por ronda**: el dialoguer escribe al transcript (LL-01) y procesa contexto acumulado entre cada pregunta — pausa perceptible para el usuario.
2. **Secuencialidad forzada**: los stakeholders se entrevistan uno a uno. Con 5 stakeholders, el tiempo total de recolección es la suma de todas las entrevistas individuales.

**Modelo alternativo propuesto (emergido en test e2e 010 — Sesión 57):**

1. **Fase 1 — Cuestionario por rol**: el dialoguer lee el brief, identifica stakeholders y roles, y genera un cuestionario de preguntas por rol. Se pausa y espera a que el humano entregue los archivos de respuesta de todos los stakeholders (formato libre o estructurado).
2. **Fase 2 — Análisis de respuestas**: el analyst (o el dialoguer en modo análisis) procesa todos los archivos de respuesta en busca de gaps, contradicciones, ambigüedades e información faltante.
3. **Fase 3 — Ronda de aclaración**: el dialoguer genera únicamente las preguntas de seguimiento necesarias para resolver los items detectados en Fase 2. Ronda más corta y enfocada.

**Lo que se gana:**
- Paralelismo real: todos los stakeholders responden simultáneamente.
- Mejor calidad de respuesta: el stakeholder responde cuando tiene tiempo, puede consultar documentos.
- Segunda ronda corta y enfocada: solo cubre gaps reales, no repite cobertura.
- Menos dependencia de disponibilidad simultánea entre el harness y el stakeholder.

**Lo que se pierde:**
- Sondeo socrático dinámico: el cuestionario es estático; no puede adaptar la siguiente pregunta en función de la respuesta anterior.
- Descubrimiento de stakeholders faltantes: en el modelo actual, S-05 emergió porque S-01 lo mencionó en Ronda 2. Un cuestionario asume que el brief tiene la lista completa.
- Información emergente no anticipada: algunos requisitos técnicos (ej. upload offline con sync en background) emergieron de preguntas de comportamiento ante fallo, no de preguntas directas.

**Opción intermedia:**
Usar el cuestionario async para Fase 1 (cobertura amplia, todos los stakeholders en paralelo) y reservar el sondeo socrático solo para Fase 3 (gaps + contradicciones). Captura la mayoría del beneficio de paralelismo sin sacrificar la capacidad de profundizar donde importa.

**Impacto si se implementa:**
- `discovery-dialoguer.md` — reescribir con 3 modos: QUESTIONNAIRE, ANALYZE, FOLLOWUP.
- `ciclo_010_discovery.md` — expandir Paso C con el flujo de 3 fases y puntos de pausa para entrega de archivos.
- Posible nuevo artefacto: `discovery/questionnaires/` con un archivo por stakeholder.
- `discovery-interview-protocol/SKILL.md` — revisar si el banco de preguntas sirve como base para el cuestionario estático o si requiere adaptación.

---

### ADJ-39 — 010 Discovery: pregunta obligatoria de observabilidad en producción — PENDIENTE

**Prioridad:** SIGNIFICATIVA

**Descripción:**
El dialoguer del 010 no pregunta explícitamente sobre observabilidad del sistema en producción.
Si el cliente no lo menciona por iniciativa propia, el requisito no se captura y el sistema se
entrega sin monitoreo, dashboards ni alertas. La mayoría de clientes no saben que necesitan pedirlo.

Se debe añadir al protocolo del dialoguer una pregunta obligatoria del tipo:
*"Cuando el sistema esté en producción, ¿cómo van a saber que está funcionando bien? ¿Necesitan
ver métricas de rendimiento, recibir alertas si el sistema se pone lento o falla, o tener un
panel de salud del sistema?"*

Si la respuesta es sí: los requisitos de observabilidad entran al 020 como NFRs verificables
(latencia, error rate, uptime, alertas) y se planifican como slices en el 040.
Si la respuesta es no: se documenta explícitamente que el cliente eligió no incluir observabilidad.

**Impacto:**
- `discovery-interview-protocol/SKILL.md` — añadir pregunta de observabilidad al banco de preguntas obligatorias.
- `discovery-dialoguer.md` — asegurar que la pregunta se formula en todas las entrevistas, independientemente del dominio.
- `020 Specification` — los NFRs de observabilidad (SLAs, error budgets, alertas) deben tener formato de AC verificable, igual que cualquier otro NFR.
- `040 Planning` — el roadmap debe incluir slices de observabilidad cuando el cliente las requiera (ej. VS-xx — Módulo de Monitoreo).

**Prerequisitos antes de implementar:**
- Ninguno. Puede implementarse en cualquier momento antes del próximo Test_Harness.

---

### ADJ-40 — Agentes deployados no se registran como subagent types — PENDIENTE

**Prioridad:** CRÍTICA

**Descripción:**
Los agentes copiados a `.claude/agents/` de un proyecto cliente por `deploy-harness.ps1` NO son registrados por Claude Code como subagent types disponibles. Cualquier llamada `Agent(subagent_type: "X-governor")` o `Agent(subagent_type: "X-worker")` falla con "Agent type not found". Reproducido consistentemente en Test_Harness_003 a partir del 020 Specification Harness.

Claude Code solo registra como subagent types los agentes que son nativos del proyecto donde la instancia se originó (Harness_Definition). Los agentes copiados por el deploy script no pasan por ese registro, sin importar que los archivos .md existan y tengan frontmatter correcto.

El 010 Discovery completó porque el governor corrió inline (fallback del modelo) y el dialoguer fue invocado vía `claude --agent discovery-dialoguer --print` como Bash CLI. No hubo invocación real vía Agent tool.

**Impacto:**
- `templates/workflows/ciclo_010_discovery.md` — Paso A invoca discovery-governor via subagent_type → falla en proyectos cliente
- `templates/workflows/ciclo_020_specification.md` — ídem specification-governor
- `templates/workflows/ciclo_030_design.md` — ídem design-governor
- `templates/workflows/ciclo_040_planning.md` — ídem planning-governor
- `templates/workflows/ciclo_050_vertical.md` — ídem vertical-governor
- Todos los governors (.md) — invocan sus workers via subagent_type → también fallan en proyectos cliente

**Fix requerido:**
1. **Ciclos**: cambiar invocación del governor de `Agent(subagent_type)` a ejecución inline (main context lee .md y ejecuta protocolo directamente).
2. **Governors**: cambiar invocación de workers de `Agent(subagent_type)` a `Bash(claude --agent <worker> --print '<prompt>' --dangerously-skip-permissions)`.
3. **Verificar** que la captura del GOVERNOR_RESULT funciona correctamente con ejecución inline.

**Prerequisitos antes de implementar:**
Ninguno. Puede implementarse de inmediato. Bloquea Test_Harness_003 a partir del 020.

---

### ADJ-38 — 080 Harness: Regression & Validation Harness — PENDIENTE

**Prioridad:** SIGNIFICATIVA

**Descripción:**
El 080 Harness está descrito actualmente como el paso que escribe `PROD_READY` en `harness-state.json`.
Sin embargo, ese rol no garantiza que la implementación de una nueva slice no rompa las slices
anteriores. El 080 debe rediseñarse como un **Regression & Validation Harness** que, antes de
escribir `PROD_READY`, ejecute el test suite acumulado de todas las slices implementadas hasta ese
momento y verifique que no hay regresiones.

**Criterio de Done propuesto para el 080:**
1. Test suite acumulado (VS-01 .. VS-n) pasa al 100%.
2. Mutation score de la slice nueva ≥ objetivo definido en su `testing_plan.md`.
3. Sin regresiones en las slices anteriores.
4. Solo entonces escribe `PROD_READY`.

Si hay regresiones: el 080 reporta al desarrollador con el detalle de qué tests fallaron en qué
slice, y no escribe `PROD_READY` hasta que se corrijan.

**Impacto:**
- `Harnesses/080_*_harness.md` — diseño completo pendiente (no existe aún).
- `plans/080_*_harness.md` — blueprint pendiente.
- `templates/workflows/ciclo_080_*.md` — pendiente.
- `avance.md` Tarea 4 — actualizar descripción del 080 cuando se construya.

**Prerequisitos antes de implementar:**
- 060 Isolation Harness construido.
- 070 Development Harness construido.
- Decisión sobre cómo el 070 deja el entorno de tests ejecutable para que el 080 pueda correr el suite completo.

---

### ADJ-31 — Comando /forge-changes + 100 Change Harness — PENDIENTE

**Prioridad:** SIGNIFICATIVA

**Decisión de diseño (Sesión 77):**
`/forge-changes` es el entry point único para cualquier solicitud de cambio del cliente. Al ejecutarlo, activa el **100 Change Harness** — no es un comando standalone. El harness es quien clasifica el cambio, analiza el impacto, escala al humano y ejecuta el camino de re-ejecución correcto.

**Diferencia semántica con `/forge-override`:**
- `/forge-override` = restricción vinculante sobre una decisión de diseño (ej. stack tecnológico). Se registra y propaga a harnesses futuros.
- `/forge-changes` = solicitud de cambio del cliente sobre features o artefactos. Activa un harness completo de gestión de cambios.

**Casos que maneja el 100 Change Harness:**
- **Caso 1 — Scope Addition:** Feature que nunca fue considerada. No existe en ningún artefacto.
- **Caso 2 — CR pre-build:** Feature considerada en el plan, no construida aún. El cliente quiere modificarla.
- **Caso 3 — CR post-build:** Feature ya construida. El cliente quiere modificarla.

**Flujo de activación:**
1. El usuario ejecuta `/forge-changes "Descripción del cambio"` en cualquier momento del proyecto.
2. El comando registra el cambio con ID CH-xxx, timestamp y descripción.
3. El comando activa el **100 Change Harness** pasándole el CH-xxx como input.
4. El harness ejecuta su proceso: clasificación → impact analysis → escalamiento al humano → actualización de artefactos upstream → entrega slice lista al 050.

**Prerequisitos antes de implementar:**
- Construir el 100 Change Harness completo (agentes, skills, workflow, ciclo)
- El comando `/forge-changes` se construye como parte del mismo ADJ-31, no por separado

---

### ADJ-41 — 030 Design: Demo Statements y done_criteria desactualizados — PENDIENTE

**Prioridad:** SIGNIFICATIVA

**Archivos afectados:**
- `.claude/agents/design-orchestrator.md`
- `.claude/skills/design-state-schema/SKILL.md`

**Contexto:**
Los últimos cambios del 030 (commit `3211f51` — ADRs obligatorios + secciones nuevas del blueprint) actualizaron correctamente todos los agentes y skills operativos, pero dejaron desactualizados los Demo Statements que el orchestrator persiste en `execution-state.json` y el `done_criteria` del Sprint Contract en el state schema.

**Gap 1 — Demo Statement de `design-analyst` (en ambos archivos)**

El Demo Statement que se persiste actualmente dice:
> "...contiene: ≥1 componente (CO-xx)...; ≥1 interface requerida (IC-xx)...; ≥1 patrón de diseño (PT-xx)...; ≥1 restricción tecnológica (RT-xx)..."

Falta agregar:
- `≥1 requerimiento de seguridad (RS-xx) derivado de los inputs (actores, datos sensibles, políticas de error)`
- `≥1 restricción de escalabilidad (RE-xx) derivada de la escala esperada del sistema`
- `posicionamiento de consistencia (CP/AP/CA) justificado según los requerimientos transaccionales del dominio`

**Gap 2 — Demo Statement de `design-architect` (en ambos archivos)**

El Demo Statement que se persiste actualmente solo verifica ADR-001. Falta agregar:
- `architecture_decision_records.md incluye ADR-002 (seguridad con ≥3 riesgos OWASP), ADR-003 (escalabilidad con cuellos de botella), ADR-004 (despliegue con CI/CD y rollback), ADR-005 (modelo CAP/consistencia)`
- `technical_blueprint.md incluye sección 'Protocolo de Comunicación' con decisión REST/GraphQL/gRPC justificada`
- `technical_blueprint.md incluye sección 'Principios de Diseño Aplicados' con SRP, OCP y DIP evaluados`

**Gap 3 — `done_criteria` en design-state-schema**

El array `done_criteria` del Sprint Contract tiene solo 5 de 10 criterios. Faltan:
- `ADR-002 documenta seguridad (auth/authz + ≥3 riesgos OWASP con mitigación)`
- `ADR-003 documenta escalabilidad (horizontal/vertical + cuellos de botella)`
- `ADR-004 documenta despliegue (containerización + CI/CD + rollback)`
- `ADR-005 documenta modelo de consistencia/CAP con justificación`
- `technical_blueprint.md incluye sección Protocolo de Comunicación y sección Principios de Diseño Aplicados`

**Impacto operativo:**
Los Demo Statements incompletos no impiden que los workers produzcan artefactos correctos (los agents y protocols están correctamente actualizados), pero el governor verifica el COMPLETED del worker contra el Demo Statement persistido. Si el worker reporta RS-xx, RE-xx y CAP pero el Demo Statement del orchestrator no los exige, la verificación es más débil de lo que debería ser.

**Fix requerido:**
1. En `design-orchestrator.md`: actualizar los dos bloques `"demo_statements"` dentro del JSON que se escribe en `execution-state.json` (Modo PLAN, Paso 4).
2. En `design-state-schema/SKILL.md`: actualizar los mismos Demo Statements en el ejemplo de `execution-state.json` (sección "Archivo 2") Y actualizar el array `"done_criteria"` en el ejemplo de `harness-state.json` (sección "Archivo 1") con los 10 criterios completos.

**Prerequisitos:**
Ninguno. Los agentes operativos (design-analyst, design-architect) ya están correctos — solo hay que actualizar los Demo Statements que el orchestrator persiste y el done_criteria del schema.
