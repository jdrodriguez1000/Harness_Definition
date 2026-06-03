# Ajustes Pendientes de Implementación

Registro de ajustes identificados que aún no han sido implementados.

---

## Tabla de Estado

| ID     | Descripción                                                                                                 | Prioridad     | Estado    |
| ------ | ----------------------------------------------------------------------------------------------------------- | ------------- | --------- |
| IMP-22 | No hay mecanismo de knowledge cross-project — aprendizajes no viajan entre proyectos                        | SIGNIFICATIVA | DISEÑADO — PENDIENTE IMPL. |
| IMP-28 | No existe dashboard HTML en tiempo real para observar el progreso del harness                               | MENOR         | PENDIENTE |
| ADJ-04 | Harness 040 Planning: rediseñar para trabajar bajo Vertical Slices con iteraciones                          | SIGNIFICATIVA | PARCIAL — impacto en 030 implementado (Sesión 49 + ADJ-32 Sesión 61); 040 pendiente de construir |
| ADJ-05 | Harness 050 Iteration: renombrar a "050 Vertical Harness" y redefinir su scope                              | SIGNIFICATIVA | PENDIENTE |
| ADJ-06 | Harness 060 Isolation: limitar ejecución a la vertical slice / iteración activa                             | MENOR         | PENDIENTE |
| ADJ-07 | Harness 070 Execution: renombrar a "080 Development Harness" y reasignar numeración                         | MENOR         | PENDIENTE |
| ADJ-08 | README.md del proyecto: incluirlo en `deploy-harness.ps1` para que se copie al cliente                     | MENOR         | PENDIENTE |
| ADJ-12 | Meta-Harness: referencia académica para optimización automática de harnesses                                | MENOR         | PENDIENTE |
| ADJ-13 | Demo Statements + Pending Verification como regla dura para harnesses 030+                                  | SIGNIFICATIVA | IMPLEMENTADO — Sesiones 41–43 (design-orchestrator, design-analyst, design-architect) |
| ADJ-14 | Sprint Contract y gates CP-03/CP-04 no se muestran directamente al usuario cuando el governor corre como subagente | SIGNIFICATIVA | IMPLEMENTADO — Sesiones 50–51 (governors como motores puros + CLAUDE.md gestiona AskUserQuestion); test e2e pendiente |
| ADJ-15 | design-orchestrator: Demo Statement de design-architect debe citar explícitamente "Guía de Vertical Slices con ≥3 iteraciones" | SIGNIFICATIVA | IMPLEMENTADO — Sesión 47 |
| ADJ-16 | design-governor y specification-governor: CP-04 debe presentarse siempre como AskUserQuestion independiente de CP-03 (LL-25) | SIGNIFICATIVA | IMPLEMENTADO — Sesión 47 |
| ADJ-17 | design-analyst-protocol y design-analysis-schema: cambiar IF-xx a IC-xx para alinear nomenclatura con design-architect (LL-26) — Opción A elegida | MENOR | IMPLEMENTADO — Sesión 47 |
| ADJ-20 | Agente reviewer entre CP-02 y CP-03 para harnesses 020 y 030: specification-reviewer y design-reviewer (LL-27) | SIGNIFICATIVA | IMPLEMENTADO — Sesión 48 |
| ADJ-21 | client-project-CLAUDE.md crece linealmente con cada harness nuevo — refactorizar para que no cargue ciclos de fases inactivas | SIGNIFICATIVA | IMPLEMENTADO — Sesión 53 (Opción D: workflows/) |
| ADJ-22 | design-architect no tiene mecanismo para conocer la versión actual de los frameworks/librerías del stack tecnológico | SIGNIFICATIVA | IMPLEMENTADO — Sesión 56 (bloque Context7 en design-architect.md antes del ADR-001) |
| ADJ-23 | design-architect no tiene stack de referencia por defecto — si no hay RT-xx explícitas, el architect inventa un stack sin guía del equipo | SIGNIFICATIVA | IMPLEMENTADO — Sesión 56 (templates/default_stacks.md + bloque de clasificación en design-architect.md + copia en deploy-harness.ps1) |
| ADJ-24 | 010 Discovery: modelo de entrevista síncrona genera latencia y limita paralelismo — evaluar modelo async con cuestionario + ronda de gaps | SIGNIFICATIVA | PENDIENTE — evaluar antes de construir el 040 |
| ADJ-25 | specification-rubric sin pesos por dimensión — el evaluador no puede poblar el campo `weight` y el array metrics_summary.json queda inconsistente con el 010 | SIGNIFICATIVA | IMPLEMENTADO — Sesión 60 |
| ADJ-26 | specification-verdict-schema demasiado complejo — el evaluador lo ignora y produce formato propio; simplificar al patrón `dimensions` + `cycle_metrics` del 010 (Opción A) | SIGNIFICATIVA | IMPLEMENTADO — Sesión 60 |
| ADJ-27 | specification-evaluator inventa nombres de dimensiones en lugar de usar los canónicos de la rúbrica — D3 y D5 nunca fueron evaluadas correctamente | SIGNIFICATIVA | IMPLEMENTADO — Sesión 60 |
| ADJ-28 | claude-progress.txt ausente en el 020 tras ADJ-14 — governors reescritos perdieron la instrucción de escribir el log de progreso | SIGNIFICATIVA | FALSO POSITIVO — Sesión 61 (los 3 governors tienen instrucciones Add-Content completas; el archivo sí existe en persistence/) |
| ADJ-29 | Early Eval E9 score no registrado en ningún artefacto — si el 020 se bloquea no hay forma de saber si el origen fue el analyst o el writer | MENOR | FALSO POSITIVO — Sesión 61 (specification-orchestrator ya tiene modo EARLY_EVAL que persiste score/passed/notes; specification-state-schema documenta el campo) |
| ADJ-30 | default_stacks.md Tier PEQUEÑO usa Next.js/Prisma pero el architect eligió Django sin citar el default — evaluar reemplazar Django por FastAPI y actualizar el stack de referencia | SIGNIFICATIVA | IMPLEMENTADO — Sesión 62 (FastAPI como Opción B del Tier PEQUEÑO; Tier GRANDE con evaluación FastAPI-primero antes de escalar a Go) |
| ADJ-31 | ADJ-22 (Context7) implementado en design-architect.md pero no ejecutado en el test — el ADR-001 cita versiones sin marca de verificación; reforzar la instrucción para que sea ineludible | SIGNIFICATIVA | IMPLEMENTADO — Sesión 61 (STOP explícito + scope ampliado a stack completo + ítem en self-checklist + verificación D4 en design-evaluator) |
| ADJ-32 | Guía de Vertical Slices sin regla de granularidad — N=0 válido produce saltos de scope demasiado grandes; definir piso mínimo por tamaño de proyecto y criterio de división por slice | SIGNIFICATIVA | IMPLEMENTADO — Sesión 61 (piso mínimo por IC-xx/MOD-xx + criterio de división 3/2/10 en design-architect, design-synthesis-schema y 030_design_harness) |

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

### ADJ-04 — Harness 040 Planning: rediseñar para Vertical Slices — PARCIAL (impacto 030 implementado)

**Prioridad:** SIGNIFICATIVA

**Estructura formal de Vertical Slices:**

```
VS-Tracer Bullet
  VS-Crecimiento-1  ← opcional
  VS-Crecimiento-2  ← opcional
  ...               ← 0..N slices de Crecimiento
VS-MVP
  VS-Evolución-1    ← opcional
  VS-Evolución-2    ← opcional
  ...               ← 0..M slices de Evolución
VS-Robustez
```

**Reglas:**
- **Tracer Bullet, MVP y Robustez** son obligatorios en todo proyecto. Son el mínimo estructural.
- **Crecimiento** (0..N): slices entre Tracer Bullet y MVP. Agregan features progresivamente hasta alcanzar el MVP. En proyectos pequeños N=0 es válido.
- **Evolución** (0..M): slices entre MVP y Robustez. Agregan funcionalidades de hardening y calidad hasta alcanzar producción. En proyectos pequeños M=0 es válido.
- **Toda vertical slice tiene su propio criterio de Done.** El Done del Tracer Bullet y MVP/Robustez es más riguroso; el de Crecimiento y Evolución es más liviano ("feature X integrada y pasando tests").

**División de responsabilidades entre harnesses:**
- **030 (Design):** propone la distribución inicial — qué IC-xx y qué BDD scenarios van en cada slice. Lo registra en la sección "Guía de Vertical Slices" de `test_strategy_map.md`.
- **040 (Planning):** corre **una sola vez** al inicio del proyecto. Toma el draft del 030, lo refina y produce el **plan maestro completo** — todas las slices definidas formalmente con scope, Done, esfuerzo y dependencias. El humano aprueba el plan en el CP-03 del 040.
- **050 (Vertical):** trabaja **una slice a la vez**, tomando el plan maestro del 040 como fuente de verdad. Produce SDS, SDD, testing_plan y execution_plan para la slice activa.

**Artefactos que produce el 040 (borrador — a confirmar al construirlo):**
- `plan/vertical_slice_plan.md` — todas las slices con scope (IC-xx + BDD scenarios), Done y esfuerzo estimado
- `plan/project_roadmap.md` — secuencia, dependencias entre slices y fechas/hitos
- `plan/risk_register.md` — riesgos identificados por slice

**Impacto en el 030 — IMPLEMENTADO (Sesión 49):**
El `test_strategy_map.md` debe extender la "Guía de Vertical Slices" para incluir, por cada slice propuesta: nombre, tipo (Tracer Bullet / Crecimiento / MVP / Evolución / Robustez), IC-xx y BDD scenarios asignados, y criterio de Done preliminar. El 040 hereda este draft y lo consolida.

Archivos actualizados (Sesión 49):
- `.claude/skills/design-synthesis-schema/SKILL.md` — nomenclatura formal + 5 campos obligatorios por slice + checklist actualizado
- `.claude/agents/design-architect.md` — sección VS con nomenclatura y 5 campos + self-checklist actualizado
- `Harnesses/030_design_harness.md` — Paso 7, Demo Statement de architect y tabla Outputs actualizados

---

### ADJ-05 — Harness 050: renombrar a "050 Vertical Harness" — PENDIENTE

**Prioridad:** SIGNIFICATIVA

**Descripción:**
El 050 Vertical Harness trabaja exclusivamente en la iteración activa definida en el 040.

**Artefactos que produce:**
- `Proposal` — objetivo de la iteración
- `SDS` (Software Design Specification) — arquitectura, interfaces y contratos
- `SDD` (Software Design Document) — especificación técnica detallada
- `testing_plan` — plan de pruebas
- `execution_plan` — Feature → Tickets → Tasks bajo TDD

---

### ADJ-06 — Harness 060 Isolation: limitar a la vertical slice activa — PENDIENTE

**Prioridad:** MENOR

**Descripción:**
El 060 Isolation se ejecutará exclusivamente en el contexto de la vertical slice activa definida en el 040 y especificada en el 050. No opera sobre el proyecto completo.

---

### ADJ-07 — Harness 070/080: renombrar y reasignar numeración — PENDIENTE

**Prioridad:** MENOR

**Descripción:**
- `070_execution_harness` pasa a llamarse **`070 Development Harness`**.
- Revisar la numeración de todos los harnesses afectados para mantener coherencia en la secuencia 010–090.

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

### ADJ-14 — Sprint Contract y gates CP-03/CP-04 no visibles cuando el governor corre como subagente — IMPLEMENTADO (Sesiones 50–51)

**Prioridad:** SIGNIFICATIVA

**Problema observado (Sesión 45 — test end-to-end del 030):**
Cuando el CLAUDE.md invoca un governor via el `Agent` tool, las llamadas `AskUserQuestion` del governor quedan encapsuladas en el resultado del subagente y no se renderizan de forma interactiva para el usuario. El Sprint Contract, las propuestas de CP-03 y la solicitud de aprobación de CP-04 llegan como texto dentro del resultado del tool call — el agente padre debe extraerlos y re-presentarlos manualmente.

**Raíz del problema:**
Claude Code siempre ejecuta las instrucciones del CLAUDE.md como un `Agent` tool call cuando delega a un subagente. Dentro de ese contexto, `AskUserQuestion` no produce una interacción directa con el usuario — produce output que el agente padre debe surfacear.

**Impacto:**
- El usuario no ve el Sprint Contract hasta que el agente padre lo extrae y lo muestra.
- Si el agente padre no extrae correctamente el output del governor, la interacción se pierde.
- La experiencia de usuario es inconsistente: a veces el contrato aparece, a veces no.

**Solución implementada (Opción 2 — governors como motores de ejecución pura):**

Los 3 governors (`discovery-governor`, `specification-governor`, `design-governor`) fueron reescritos en Sesiones 50–51 eliminando todo uso de `AskUserQuestion`. Ahora retornan `GOVERNOR_RESULT` como texto estructurado (key-value). El `client-project-CLAUDE.md` fue expandido con los ciclos completos (Pasos A–F por harness) que gestionan todas las interacciones con el usuario via `AskUserQuestion` propio.

**Pendiente:** Test end-to-end para verificar que Sprint Contract, CP-03, CP-04 y handoff aparecen como `AskUserQuestion` interactivos correctamente desde el CLAUDE.md.

---

### ADJ-15 — Demo Statement de design-architect debe citar la Guía de Vertical Slices explícitamente — IMPLEMENTADO (Sesión 47)

**Prioridad:** SIGNIFICATIVA

**Problema observado (test end-to-end 030):**
design-architect omitió la sección "Guía de Vertical Slices" en su primer pase. El Demo
Statement escrito por design-orchestrator decía "produce test_strategy_map.md (estrategia
mock/stub por interface)" — suficiente para que el architect entregara las secciones 1-4
sin la Guía, sin violar su contrato. Ver LL-24.

**Cambios aplicados:**
1. `design-orchestrator.md` — Demo Statement de design-architect actualizado:
   Ahora cita: `"test_strategy_map.md cubre cada IC-xx con su estrategia Fake/Mock/Real y contiene la sección obligatoria 'Guía de Vertical Slices' con ≥3 iteraciones nombradas: Tracer Bullet, MVP y Robustez como mínimo."`

2. `design-architect.md` — self-checklist: ítem explícito agregado:
   `"[ ] test_strategy_map.md incluye sección 'Guía de Vertical Slices' con ≥3 iteraciones nombradas (Tracer Bullet, MVP y Robustez como mínimo)"`

**Regla general aplicada:** Antes de publicar el Demo Statement de cualquier Worker, revisar
el schema del artefacto y listar las secciones marcadas como obligatorias textualmente.

---

### ADJ-16 — CP-04 debe presentarse siempre como AskUserQuestion independiente de CP-03 — IMPLEMENTADO (Sesión 47)

**Prioridad:** SIGNIFICATIVA

**Problema observado (tests 020 y 030):**
En ambos harnesses, CP-03 y CP-04 se colapsaron en una sola interacción: el timestamp y el
texto de aprobación del CP-04 son idénticos a los del CP-03. Esto viola ADJ-23. El modelo
optimiza eficiencia cuando el cliente usa lenguaje de doble aprobación ("aprobado, continúa
con CP-04"). Ver LL-25.

**Cambios aplicados:**
1. `specification-governor.md` — bloque estructural agregado al inicio de "Gate CP-04".
2. `design-governor.md` — ídem.

**Bloque agregado en ambos governors:**
```
REGLA ESTRUCTURAL (ADJ-16 / LL-25): Este gate siempre se presenta como un AskUserQuestion
separado, incluso si la respuesta al CP-03 ya incluía lenguaje de aprobación. No colapsar
ambos gates. El timestamp de CP-04 debe ser posterior al de CP-03.
```

**Nota para governors futuros:** Incluir este bloque desde el momento de diseño del governor.

---

### ADJ-17 — Alinear nomenclatura IF-xx → IC-xx entre design-analyst y design-architect — IMPLEMENTADO (Sesión 47)

**Prioridad:** MENOR

**Problema observado (test end-to-end 030):**
El analyst produce `IF-01..IF-06` y el architect produce `IC-01..IC-09`. No hay tabla de
mapeo en ningún artefacto. En proyectos complejos, la discontinuidad de IDs entre el
analysis report y los contract definitions puede causar interfaces huérfanas o trazabilidad
perdida. Ver LL-26.

**Decisión tomada:** Opción A — el analyst pasa a usar IC-xx directamente.

**Cambios aplicados (Opción A):**
- `design-analysis-schema/SKILL.md` — prefijo `IF-xx` → `IC-xx` en schema y todos los ejemplos (IF-01, IF-02, IF-03).
- `design-analyst-protocol/SKILL.md` — sección "2. Interfaces Requeridas" y criterios de done: `IF-xx` → `IC-xx`.
- `design-analyst.md` — todas las referencias `IF-xx` → `IC-xx`.
- `design-orchestrator.md` — Demo Statement del analyst: `IF-xx` → `IC-xx`.
- `design-governor.md` — descripción del agente design-analyst: `IF-xx` → `IC-xx`.
- `design-architect.md` — referencias al analysis_report actualizadas: "CO-xx, IC-xx, PT-xx, RT-xx"; "Por cada IC-xx del analysis_report (identificado por design-analyst)"; "IC-xx del análisis → contrato completo (firmas + DTO-xx)".
- `design-synthesis-schema/SKILL.md` — semántica de Artefacto 3: de "eleva IF-xx a IC-xx" a "formaliza IC-xx del analysis_report con firmas y DTOs".
- `design-architect-protocol/SKILL.md` — sección contract_definitions: de "Transformar IF-xx en IC-xx" a "Formalizar IC-xx del analysis_report".
- `design-evaluator-protocol/SKILL.md` — check cruzado D2: actualizado para verificar IC-xx origen en analysis_report.
- `design-state-schema/SKILL.md` — Demo Statement de ejemplo: `IF-xx` → `IC-xx`.

**Verificación:** grep `IF-xx|IF-0[0-9]` en `.claude/` → 0 matches tras los cambios.

---

### ADJ-20 — Agente reviewer entre CP-02 y CP-03 para harnesses 020 y 030 — IMPLEMENTADO — Sesión 48

**Prioridad:** SIGNIFICATIVA

**Problema:**
El humano llega al CP-03 con artefactos que pueden contener inconsistencias técnicas:
referencias huérfanas, secciones obligatorias faltantes, IDs sin destino cruzado entre
artefactos. El evaluador verifica D5 (consistencia) pero corre post-CP-04 — demasiado
tarde. La carga de detectar estos gaps recae en el humano, que no debería ser quien los
encuentre. Ver LL-27.

**Solución:**
Agregar un agente reviewer por harness, que corra entre CP-02 y CP-03:

- **`specification-reviewer`** (020) — verifica:
  - Todos los scenarios de `bdd_features.md` referencian entidades definidas en `data_contracts.md`
  - Todas las entidades EN-xx de `data_contracts.md` tienen al menos un scenario BDD
  - Todos los criterios de `acceptance_criteria.md` tienen un feature BDD correspondiente
  - Todos los códigos de error de `error_exception_policy.md` tienen contrato en `data_contracts.md`

- **`design-reviewer`** (030) — verifica:
  - IC-xx en `contract_definitions.md` ↔ IC-xx en `dependency_graph.md` (sin huérfanos)
  - MOD-xx en `technical_blueprint.md` ↔ MOD-xx en `dependency_graph.md`
  - TS-xx en `test_strategy_map.md` ↔ IC-xx en `contract_definitions.md`
  - Sección "Guía de Vertical Slices" presente en `test_strategy_map.md` con ≥3 iteraciones
  - ADR-001 tiene las 4 secciones obligatorias (contexto, opciones, criterios, consecuencias)
  - Coherencia de stack entre ADR-001 y los skeletons de `technical_blueprint.md`

**Mentalidad del reviewer — Abogado del Diablo:**
El reviewer nunca asume que los artefactos están bien. No acepta redacción bonita como evidencia de corrección. Su postura por defecto es la desconfianza: cada afirmación en un artefacto debe estar respaldada por evidencia concreta en ese mismo artefacto o en los inputs del harness anterior. Busca activamente:
- **Gaps:** algo que debería estar y no está (interface sin contrato, entidad sin scenario BDD, slice sin Done).
- **Ambigüedades:** afirmaciones que pueden interpretarse de más de una manera.
- **Puntos faltantes:** secciones obligatorias ausentes, campos sin completar, referencias a artefactos que no existen.
- **Contradicciones:** dos afirmaciones en el mismo artefacto o entre artefactos que son incompatibles entre sí.
- **Riesgos de proyecto:** cualquier decisión de diseño que, si resulta incorrecta, bloquearía el avance del 040 en adelante.

El reviewer reporta con citas exactas (artefacto + sección + línea o ID), sin suavizar el lenguaje. Un issue sin cita concreta no se reporta.

**Comportamiento ante issues:**
- Issues críticos → governor re-spawea el Worker afectado para rework. CP-03 no se presenta hasta que los issues estén resueltos.
- Issues menores → governor los presenta junto a los artefactos en CP-03 con diagnóstico ya hecho.

**Harnesses excluidos:**
- 010: artefactos cualitativos sin IDs formales, valor bajo. Revisitar si emergen problemas reales.

**Prerequisitos antes de implementar:**
- ADJ-15, ADJ-16 y ADJ-17 completados primero.
- Definir si el reviewer produce un artefacto formal (`review/reviewer_report.md`) o retorna un reporte inline al governor (sin archivo en disco). Decisión pendiente.

**Archivos a crear:**
1. `.claude/agents/specification-reviewer.md`
2. `.claude/agents/design-reviewer.md`
3. (Opcional) Skills: `specification-reviewer-protocol/`, `design-reviewer-protocol/`

**Archivos a modificar:**
1. `specification-governor.md` — agregar paso de reviewer entre CP-02 y CP-03
2. `design-governor.md` — ídem
3. `deploy-harness.ps1` — incluir los 2 nuevos agentes en el mapa de deployment (020 y 030)
4. `Harnesses/020_specification_harness.md` — documentar el reviewer en Fase 0 y Fase 1
5. `Harnesses/030_design_harness.md` — ídem

---

### ADJ-13 — Demo Statements + Pending Verification para harnesses 030+ — IMPLEMENTADO (Sesiones 41–43)

**Prioridad:** SIGNIFICATIVA

**Descripción:**

1. **Demo Statements obligatorios** en `orchestration_plan`: antes de spawear un Worker, el orchestrator escribe "Cuando este worker termine, podré observar que...". El Worker ejecuta self-checklist contra ese statement antes de reportar COMPLETED.

2. **Pending Verification**: después de que un Worker reporta COMPLETED, el orchestrator verifica en disco que el artefacto existe y tiene contenido antes de registrar el checkpoint. Si no existe o está vacío → CHECKPOINT_FAILED.

**Implementación en el 030:**
- design-orchestrator (modo PLAN) escribe Demo Statements en orchestration_plan.
- design-orchestrator (modo CHECKPOINT) verifica artefacto en disco antes de registrar CP-xx.
- design-analyst y design-architect ejecutan self-checklist contra su Demo Statement.

---

### ADJ-21 — Refactorizar client-project-CLAUDE.md para no cargar ciclos de fases inactivas — IMPLEMENTADO (Sesión 53)

**Prioridad:** SIGNIFICATIVA

**Solución implementada (Opción D — carpeta `workflows/`):**

Cada ciclo extraído a su propio archivo en `templates/workflows/`:
- `ciclo_010_discovery.md`
- `ciclo_020_specification.md`
- `ciclo_030_design.md`

`client-project-CLAUDE.md` reducido de 729 → ~82 líneas: solo contiene el routing (Pasos 1–2) + instrucciones de lectura de workflows + REGLAS DE OPERACIÓN + PRINCIPIOS.

El agent lee el workflow file correspondiente al ciclo activo en runtime (Read tool). `deploy-harness.ps1` copia `templates/workflows/*.md` → `.claude/workflows/` en el cliente (siempre sobreescribir).

**Impacto por harness nuevo:** una línea en CLAUDE.md + un archivo en `workflows/`. CLAUDE.md nunca crece más allá de ~90 líneas.

---

### ADJ-22 — Verificación de versiones con Context7 en design-architect — IMPLEMENTADO (Sesión 56, reforzado Sesión 61)

**Prioridad:** SIGNIFICATIVA

**Cambios aplicados:**

- `.claude/agents/design-architect.md` — bloque `#### Verificación de versiones con Context7 (ADJ-22)` dentro del Artefacto 1, con `**STOP — No escribir el ADR-001 hasta completar este paso.**` al inicio (ADJ-31, Sesión 61). Scope: todas las tecnologías del stack final elegido (no solo RT-xx). El architect cita `(verificado via Context7)` o `(sin verificación — knowledge cutoff del modelo)` por cada tecnología. Self-checklist incluye ítem de verificación de fuente de versión.

- `.claude/agents/design-evaluator.md` — D4 agrega verificación: si el ADR-001 no cita fuente de versión por tecnología, se contabiliza como gap (red de seguridad, ADJ-31).

**Notas de implementación:**
- Context7 es un skill global de Claude Code (`npx @context7/mcp` — wizard: elegir CLI + skills). Se instala una vez por máquina, sin cambios en `settings.json` ni `deploy-harness.ps1`.
- Si Context7 no encuentra una librería, el architect documenta explícitamente la ausencia de verificación en el ADR-001.

---

### ADJ-23 — Stack de referencia por tier en design-architect — IMPLEMENTADO (Sesión 56, actualizado Sesión 62)

**Prioridad:** SIGNIFICATIVA

**Cambios aplicados:**

- `templates/default_stacks.md` — creado en Sesión 56. Actualizado en Sesión 62 (ADJ-30):
  - Tier PEQUEÑO: Opción A (Next.js full-stack, equipo JS/TS) y Opción B (FastAPI + SQLAlchemy + Alembic + sqladmin + React + Vite, equipo Python).
  - Tier GRANDE: tabla de evaluación "FastAPI es suficiente vs escalar a Go" con criterios explícitos antes de comprometerse con Go.

- `deploy-harness.ps1` — copia `default_stacks.md` a la raíz del proyecto cliente en cada deploy (sobreescribir siempre).

- `.claude/agents/design-architect.md` — bloque `#### Clasificación de tier y stack de referencia (ADJ-23)` con:
  - Paso 2: tabla de señales para elegir Tier PEQUEÑO vs GRANDE.
  - Paso 2b: tabla para elegir Opción A vs B dentro del Tier PEQUEÑO (equipo Python, admin panel, API separada).
  - Paso 2c: evaluación FastAPI-primero para Tier GRANDE; Go solo si concurrencia/CPU/equipo lo exige, con justificación obligatoria en ADR-001 e informe al humano en CP-03.
  - Paso 3: precedencia RT-xx > default parcial > default completo.

**Relación con ADJ-22:** el architect ejecuta ADJ-23 primero (clasificar tier → elegir stack) y luego ADJ-22 (verificar versiones con Context7) antes de escribir el ADR-001.

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

**Prerequisitos antes de evaluar:**
- Completar el test e2e 010→020→030 con el modelo actual.
- Post-mortem del test para confirmar si la latencia entre rondas es un problema real de UX o solo perceptible en pruebas.
- Evaluar si el brief típico de los clientes tiene suficiente detalle para generar un cuestionario de calidad sin entrevista previa.

**Impacto si se implementa:**
- `discovery-dialoguer.md` — reescribir con 3 modos: QUESTIONNAIRE, ANALYZE, FOLLOWUP.
- `ciclo_010_discovery.md` — expandir Paso C con el flujo de 3 fases y puntos de pausa para entrega de archivos.
- Posible nuevo artefacto: `discovery/questionnaires/` con un archivo por stakeholder.
- `discovery-interview-protocol/SKILL.md` — revisar si el banco de preguntas sirve como base para el cuestionario estático o si requiere adaptación.

---

### ADJ-25 — specification-rubric sin pesos por dimensión — IMPLEMENTADO (Sesión 60)

**Prioridad:** SIGNIFICATIVA

**Cambios aplicados:**
- `.claude/skills/specification-rubric/SKILL.md` — columna "Peso" agregada a la tabla de dimensiones (D1=0.20, D2=0.25, D3=0.20, D4=0.20, D5=0.15) + línea de cálculo ponderado bajo la regla de gate.
- `.claude/agents/specification-evaluator.md` — "Calcular promedio" reemplazado por "Calcular promedio ponderado" con la fórmula explícita `D1×0.20 + D2×0.25 + D3×0.20 + D4×0.20 + D5×0.15`.

---

### ADJ-26 — specification-verdict-schema demasiado complejo — IMPLEMENTADO (Sesión 60)

**Prioridad:** SIGNIFICATIVA

**Cambios aplicados:**
- `.claude/skills/specification-verdict-schema/SKILL.md` — reescrito completo. Eliminados
  `tipo1_metricas_objetivas`, `tipo2_scores_evaluacion`, `artifacts`, `timeline` y
  `revision_counts`. Reemplazados por `dimensions` (score+weight+notes con pesos de ADJ-25)
  + `cycle_metrics`. Archivo de salida reducido a solo `eval/verdict.json`.
- `.claude/agents/specification-evaluator.md` — sección "Al terminar" actualizada: PATHS DE
  SALIDA reducido a `eval/verdict.json` (eliminado `metrics_summary.json`); orden de escritura
  reducido de 9 a 4 pasos.

---

### ADJ-27 — specification-evaluator inventa nombres de dimensiones — IMPLEMENTADO (Sesión 60)

**Prioridad:** SIGNIFICATIVA

**Cambios aplicados:**
- `.claude/agents/specification-evaluator.md` — tabla de nombres canónicos hardcodeada al
  inicio de la sección "## Evaluación". Las 5 claves JSON están fijadas con instrucción
  explícita "NO MODIFICAR".

---

### ADJ-28 — claude-progress.txt ausente en el 020 tras ADJ-14 — FALSO POSITIVO

**Prioridad:** SIGNIFICATIVA

**Diagnóstico (Sesión 61):**
Falso positivo. Verificado con grep sobre los 3 governors:
- `discovery-governor.md` — tiene sección "Escritura en claude-progress.txt" + instrucciones Add-Content en todos los eventos.
- `specification-governor.md` — ídem (>20 ocurrencias).
- `design-governor.md` — ídem (>20 ocurrencias).
El archivo `persistence/claude-progress.txt` sí existe en el proyecto de test con 51 entradas.
El problema reportado en Sesión 58 fue una búsqueda incorrecta en la raíz en lugar de `persistence/`.

**No requiere implementación.**

---

### ADJ-29 — Early Eval E9 score no registrado en ningún artefacto — FALSO POSITIVO

**Prioridad:** MENOR

**Diagnóstico (Sesión 61):**
Falso positivo. La implementación ya existe y es correcta:
- `specification-orchestrator.md` tiene un modo `EARLY_EVAL` dedicado que persiste
  `{ evaluated_at, score, passed, notes }` en `execution-state.json`.
- `specification-governor.md` invoca al orchestrator en `[MODO: EARLY_EVAL]` inmediatamente
  tras extraer `EARLY_EVAL_SCORE/PASSED/NOTES` de la respuesta del evaluador.
- `specification-state-schema/SKILL.md` documenta el campo `early_eval` con su estructura
  completa (línea "Estructura de `early_eval`").

**No requiere implementación.**

---

### ADJ-30 — FastAPI como stack Python en Tier PEQUEÑO y GRANDE — IMPLEMENTADO (Sesión 62)

**Prioridad:** SIGNIFICATIVA

**Decisión tomada:**
- El equipo usa Python y el panel de administración es frecuente, pero de naturaleza básica
  (CRUD operativo: usuarios, catálogos, configuración). Django es desproporcionado para este caso.
- FastAPI con `sqladmin` cubre el caso de admin panel básico sin el overhead de Django.
- Para Tier GRANDE: FastAPI se evalúa primero; Go solo cuando la carga o el equipo lo exige.

**Cambios implementados:**

- `templates/default_stacks.md` — Tier PEQUEÑO ahora tiene dos opciones:
  - Opción A: Next.js full-stack (equipo JS/TS, sin backend separado)
  - Opción B: FastAPI + SQLAlchemy + Alembic + sqladmin + React + Vite (equipo Python)
  Tier GRANDE: tabla de evaluación "FastAPI es suficiente vs escalar a Go" con criterios explícitos.

- `.claude/agents/design-architect.md` — Paso 2b (elegir Opción A vs B en Tier PEQUEÑO)
  y Paso 2c (evaluar FastAPI antes de Go en Tier GRANDE). El architect informa al humano
  en CP-03 si escala a Go y por qué.

---

### ADJ-31 — ADJ-22 (Context7) implementado pero no ejecutado en el test — IMPLEMENTADO (Sesión 61)

**Prioridad:** SIGNIFICATIVA

**Problema (identificado en test e2e Test_Harness_001):**
El bloque `#### Verificación de versiones con Context7 (ADJ-22)` fue agregado a
`design-architect.md` en Sesión 56, pero el architect no lo ejecutó durante el test.
El ADR-001 cita versiones (`PostgreSQL 16`, `React`, `Django`, `Workbox`) sin ninguna
marca de verificación — ni `(verificado via Context7)` ni `(sin verificación — knowledge
cutoff del modelo)`. La instrucción existe pero no es suficientemente prominente o vinculante.

**Evidencia:** Grep de `Context7|verificado via|knowledge cutoff` en
`design/architecture_decision_records.md` del test → 0 matches.

**Causa raíz probable:**
El bloque de Context7 está dentro del Artefacto 1 pero puede ser percibido como opcional
por el modelo si no hay una señal de bloqueo explícita. El architect priorizó producir el
ADR-001 sin detenerse a verificar versiones.

**Opciones de solución:**

| Opción | Descripción | Tradeoff |
|--------|-------------|----------|
| A | Mover el bloque Context7 a ANTES de "Artefactos" como paso obligatorio de pre-producción con `STOP — no escribir ADR-001 hasta completar este paso` | Más prominente; puede ralentizar si Context7 no está instalado |
| B | Agregar al self-checklist del architect: `[ ] ADR-001 cita fuente de versión por cada tecnología del stack (verificado via Context7 o knowledge cutoff explícito)` | Más liviano; el evaluador puede penalizar si no está marcado |
| C | Agregar al design-evaluator: penalizar D4 si el ADR-001 no cita fuente de versión por cada tecnología | El evaluador fuerza cumplimiento en auditoría |

**Solución recomendada:** Opciones A + B combinadas. La Opción C como red de seguridad.

**Prerequisito antes de implementar:**
- Confirmar que Context7 está instalado en las máquinas del equipo (`/skills` → buscar "context7").
  Si no está instalado, el bloque STOP bloqueará al architect sin salida viable.

**Archivos a modificar:**
- `.claude/agents/design-architect.md` — mover/reforzar el bloque Context7 con señal de bloqueo explícita y agregar ítem al self-checklist.
- `.claude/agents/design-evaluator.md` — agregar verificación de fuente de versión en D4 (Opción C).

---

### ADJ-32 — Guía de Vertical Slices sin regla de granularidad — IMPLEMENTADO (Sesión 61)

**Prioridad:** SIGNIFICATIVA

**Problema (identificado en análisis post-test Test_Harness_001):**
El patrón actual de Vertical Slices (ADJ-04) permite N=0 y M=0 como valores válidos para
proyectos pequeños. En la práctica, el architect eligió N=0 y M=0 para un proyecto de
10 interfaces y 6 módulos, produciendo un MVP que absorbió 5 módulos y 10 interfaces en
un solo paso — un salto de scope demasiado grande para un equipo de 2-3 personas.

El problema tiene dos dimensiones:
1. **Sin piso mínimo:** N=0 y M=0 son siempre válidos sin importar el tamaño del proyecto.
2. **Sin criterio de división:** no hay regla que evalúe si el scope de cada slice individual
   es razonable, por lo que el número de slices no garantiza granularidad real.

**Solución: dos reglas complementarias**

**Regla 1 — Piso mínimo por tamaño de proyecto:**

| Interfaces (IC-xx) | Módulos (MOD-xx) | Crecimiento mínimo (N) | Evolución mínimo (M) |
|--------------------|-----------------|----------------------|---------------------|
| ≤ 4                | ≤ 2             | 0                    | 0                   |
| 5 — 7              | 3 — 4           | 1                    | 1                   |
| ≥ 8                | ≥ 5             | 2                    | 1                   |

El piso es un **mínimo garantizado**, no un techo. El número final de slices puede ser mayor.

**Regla 2 — Criterio de división por slice:**

Después de aplicar el piso, el architect evalúa cada slice individualmente:

| Métrica | Máximo por slice |
|---------|-----------------|
| Interfaces (IC-xx) nuevas en esta slice | 3 |
| Módulos (MOD-xx) nuevos en esta slice | 2 |
| BDD scenarios nuevos en esta slice | 10 |

Si una slice supera cualquiera de los tres límites → dividirla en dos. Aplicar
recursivamente hasta que todas las slices cumplan los límites.

**El número final de slices emerge de la evaluación, no de una tabla fija.**

**Ejemplo aplicado a este proyecto (10 IC-xx, 6 MOD-xx, 33 scenarios):**

Piso: Crecimiento ≥ 2, Evolución ≥ 1. Luego se evalúa cada slice contra los límites:

```
VS-Tracer Bullet   → IC-02, IC-04 (2 interfaces, 1 módulo)         ✓
VS-Crecimiento-1   → IC-01, IC-05, MOD-02 (aprobación)             ✓
VS-Crecimiento-2   → IC-03, IC-06, MOD-03 (contabilidad básica)    ✓
VS-MVP             → IC-07, IC-08, MOD-04, MOD-06 (admin + auditoría) ✓
VS-Evolución-1     → IC-09, MOD-05 (escalación Celery)             ✓
VS-Robustez        → IC-10 + modo degradado + FB-01..FB-14         ✓
```

Resultado: 2 Crecimiento + 1 Evolución para este proyecto. Si Crecimiento-2 hubiera
superado los límites, se dividiría en Crecimiento-2 y Crecimiento-3 automáticamente.

**Dónde aplica esta regla:**
- El **030 Design Harness** propone el draft inicial de slices en `test_strategy_map.md`.
- El **040 Planning Harness** refina y valida que cada slice cumpla los límites antes
  de producir el plan maestro. Si detecta slices sobredimensionadas, las divide.

**Archivos a modificar:**
- `.claude/skills/design-synthesis-schema/SKILL.md` — agregar las dos reglas en la
  sección "Guía de Vertical Slices": tabla de piso mínimo + tabla de criterio de división.
- `.claude/agents/design-architect.md` — agregar las reglas en la sección VS con
  instrucción explícita de evaluar cada slice contra los límites antes del self-checklist.
- `Harnesses/030_design_harness.md` — documentar las reglas en el Paso 7 (Guía de VS).
- `support/ajustes.md` — sección ADJ-04: actualizar con referencia a ADJ-32 como
  extensión de la regla de granularidad.
- (Cuando se construya el 040): el 040 Planning Harness debe incluir verificación
  explícita de los límites por slice al refinar el plan del 030.
