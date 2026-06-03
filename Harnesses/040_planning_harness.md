# 040 — Planning Harness (Planificación Estratégica)

---

## Fase 0 — Definición Estructural

### Propósito

Transformar la guía arquitectónica del 030 (y los contratos formales heredados del 020/010)
en un plan maestro de ejecución por Vertical Slices. El Planning Harness no diseña ni
especifica — consolida y formaliza lo que el 030 propuso en borrador. Sus artefactos son la
autoridad sobre qué se construye en qué orden, qué riesgos existen por slice y cuáles son
los hitos del proyecto. Para eso:

1. Valida que las slices del 030 cumplen las reglas de granularidad (regla 3/2/10).
2. Divide slices sobredimensionadas antes de aprobar el plan.
3. Asigna todo IC-xx y todo BDD scenario a alguna slice — sin huérfanos.
4. Genera el roadmap de dependencias entre slices y el registro de riesgos.

### Precondición obligatoria

El 040 no puede iniciarse sin que el 030 esté `PHASE_COMPLETE` en `harness-state.json`
bajo la clave `"030_design"`. Si el 030 no está completo, el planning-governor debe
detener el flujo y notificar al humano: "El 030 Design debe completarse antes de iniciar
el 040 Planning. Estado actual: [valor encontrado]."

### Inputs

| ID | Input | Fuente | Descripción |
|----|-------|--------|-------------|
| I-1 | `test_strategy_map.md` | `/030_design/` | **Principal** — VS draft del 030: nomenclatura, scope por slice, criterios de Done iniciales |
| I-2 | `architecture_decision_records.md` | `/030_design/` | Stack tecnológico (ADR-001) y patrones — contexto que afecta el esfuerzo de cada slice |
| I-3 | `technical_blueprint.md` | `/030_design/` | MOD-xx: módulos por bounded context — base para contar complejidad por slice |
| I-4 | `contract_definitions.md` | `/030_design/` | IC-xx + DTO-xx: interfaces que deben asignarse a slices sin quedar huérfanas |
| I-5 | `dependency_graph.md` | `/030_design/` | DEP-xx: dependencias entre módulos que imponen el orden de implementación |
| I-6 | `bdd_features.md` | `/020_specification/` | BDD scenarios (SC-xx/SE-xx): deben asignarse a slices sin quedar huérfanos |
| I-7 | `data_contracts.md` | `/020_specification/` | Entidades — contexto de datos para evaluar complejidad por slice |
| I-8 | `acceptance_criteria.md` | `/020_specification/` | AC: trazabilidad de criterios de aceptación a slices |
| I-9 | `error_exception_policy.md` | `/020_specification/` | Políticas de error — informa slice de Robustez y manejo de fallos |
| I-10 | `shared_understanding.md` | `/010_discovery/` | Contexto del proyecto: restricciones, expectativas del cliente, alcance acordado |
| I-11 | `scope_boundaries.md` | `/010_discovery/` | Qué NO está en scope — evita incluir trabajo fuera del alcance |
| I-12 | `domain_glossary.md` | `/010_discovery/` | Lenguaje ubicuo — todos los artefactos del 040 deben usar estos términos |

### Proceso (5 pasos)

1. **Inventario y validación del draft VS** — Leer I-1 y extraer la lista completa de
   VS-xx propuestas por el 030. Para cada slice, verificar que cumple la regla de
   granularidad (máx 3 IC-xx nuevas, máx 2 MOD-xx nuevos, máx 10 BDD scenarios nuevos).
   Las slices que excedan el límite se dividen; las que queden por debajo del piso
   mínimo (≤4 IC-xx/≤2 MOD-xx → N=0/M=0; 5–7/3–4 → N≥1/M≥1; ≥8/≥5 → N≥2/M≥1)
   se documentan pero no se fusionan.

2. **Asignación exhaustiva de IC-xx y BDD scenarios** — Leer I-4 para la lista canónica
   de IC-xx y I-6 para la lista canónica de BDD scenarios. Verificar que cada uno
   aparece asignado en al menos una slice. Asignar los huérfanos a la slice más
   coherente semánticamente. Sin IC-xx huérfanos ni BDD scenarios huérfanos al terminar.

3. **Definición formal de cada slice** — Para cada VS-xx, completar los 6 campos
   obligatorios: (a) nombre, (b) tipo (Tracer Bullet / Crecimiento / MVP / Evolución /
   Robustez), (c) lista de IC-xx asignados, (d) lista de BDD scenarios asignados,
   (e) Criterio de Done con referencias explícitas a IC-xx y SC-xx/SE-xx,
   (f) estimación de esfuerzo (XS/S/M/L/XL) basada en IC-xx count + complejidad
   técnica del ADR-001.

4. **Roadmap de dependencias y secuencia** — Usando I-5 (DEP-xx), derivar las
   dependencias entre slices: si la slice B consume una IC-xx que produce la slice A,
   entonces B depende de A. Validar que el orden resultante respeta la estructura
   obligatoria: Tracer Bullet siempre primero → Crecimiento (en cualquier orden entre
   sí, respetando deps) → MVP → Evolución (ídem) → Robustez siempre último. Identificar
   hitos: Tracer Bullet, MVP y Robustez son hitos obligatorios.

5. **Registro de riesgos por slice** — Para cada VS-xx, identificar ≥1 riesgo (RK-xx)
   relevante: complejidad técnica, dependencias externas, ambigüedades no resueltas en
   scope, decisiones de arquitectura que podrían requerir revisión. Asignar probabilidad
   (Alta/Media/Baja) e impacto (Alto/Medio/Bajo) y proponer una mitigación concreta.

### Outputs (Artefactos)

| Artefacto | Path | Descripción |
|-----------|------|-------------|
| Vertical Slice Plan | `/040_planning/vertical_slice_plan.md` | Todas las VS-xx formalmente definidas con 6 campos obligatorios por slice |
| Project Roadmap | `/040_planning/project_roadmap.md` | Secuencia, dependencias entre slices (VS-xx → VS-xx), hitos y estimación de duración relativa |
| Risk Register | `/040_planning/risk_register.md` | RK-xx por slice con probabilidad, impacto y mitigación |

Artefacto intermedio (no entregado al 050, no evaluado por la rúbrica):
- `/040_planning/planning_analysis_report.md` — producido por planning-analyst, consumido por planning-writer
- `/040_planning/review_report.md` — producido por planning-reviewer entre CP-02 y CP-03; verifica consistencia estructural pre-aprobación

### Criterio de Done

La fase se considera completa cuando se cumplen **todas** las siguientes condiciones:

1. Todas las VS-xx del draft del 030 han sido validadas: slices sobredimensionadas divididas, slices dentro del límite conservadas tal cual.
2. Todos los IC-xx de `contract_definitions.md` están asignados a ≥1 slice en `vertical_slice_plan.md`.
3. Todos los BDD scenarios de `bdd_features.md` están asignados a ≥1 slice en `vertical_slice_plan.md`.
4. `project_roadmap.md` respeta la estructura TB→Crecimiento→MVP→Evolución→Robustez sin dependencias circulares.
5. `risk_register.md` tiene ≥1 RK-xx por slice, con probabilidad, impacto y mitigación.
6. El cliente ha aprobado explícitamente el plan en CP-04.

### Tipo de artefacto y ciclo adaptado

Planning produce **artefactos de planificación**, no código ni diseño. El ciclo SDD+TDD se adapta así:

| Ciclo estándar | Adaptación para Planning |
|----------------|--------------------------|
| SPEC | Inventario de VS-xx del draft del 030 + lista de IC-xx y BDD scenarios a asignar |
| HUMAN REVIEW | Cliente aprueba el plan en CP-03: número y tipo de slices, secuencia, hitos |
| RED | Demo Statements: "cuando termine, podré observar que todas las VS-xx tienen 6 campos, sin IC-xx huérfanos" |
| GREEN | Artefactos producidos por Workers |
| REFACTOR | Verificación de lenguaje ubicuo (domain_glossary.md) y consistencia cruzada entre los 3 artefactos |
| EVAL | Auditoría de C con rúbrica D1-D5 |

---

## Fase 1 — Diseño Agéntico

### 1.1 Instancias y Roles

| Instancia | Agente | Rol | Responsabilidades | Escribe en |
|-----------|--------|-----|-------------------|------------|
| A — Governor | `planning-governor` | Director del Proyecto | Verifica precondición del 030; propone Sprint Contract; gestiona CP-03 y CP-04; decide Avanzar/Repetir | `persistence/harness-state.json` |
| B — Orchestrator | `planning-orchestrator` | Capataz Técnico | Lee contrato; escribe Demo Statements en orchestration_plan; persiste plan antes de que A spawee Workers; registra checkpoints; verifica artefactos en disco (Pending Verification) | `persistence/execution-state.json` |
| D — Reviewer | `planning-reviewer` | Control de Calidad Pre-CP-03 | Lee los 3 artefactos tras CP-02 y antes de CP-03. Verifica IC-xx huérfanos, BDD scenarios huérfanos, orden TB→MVP→Robustez, cobertura del risk_register. Issues críticos → rework antes de CP-03. | `040_planning/review_report.md` |
| C — Evaluator | `planning-evaluator` | Auditor Independiente | Lee los 3 artefactos sin contexto de ejecución; aplica rúbrica; emite APPROVED/REJECTED | `eval/verdict.json`, `eval/metrics_summary.json` |

Jerarquía de llamadas (nunca se viola):
- A → B (para planificar y registrar checkpoints), A → Workers (para ejecutar), A → D (para revisar entre CP-02 y CP-03), A → C (para auditar). Nunca simultáneo.
- **A NO llama Workers directamente hasta recibir PLAN_RESULT de B.**
- D NO llama a nadie. Solo lee del filesystem y escribe `040_planning/review_report.md`.
- C NO llama a nadie. Solo lee del filesystem.

**Nota arquitectónica (LL-21):** Los agentes spawneados no pueden a su vez spawear sub-agentes.
Por este motivo, siguiendo el patrón del 030:
- El governor spawea los Workers directamente (planning-analyst, planning-writer).
- El orchestrator opera en modos 040_planning/CHECKPOINT: persiste el estado pero no spawea Workers.
- El governor es quien llama al orchestrator para planificar (PLAN) y para registrar cada checkpoint (CHECKPOINT).

**Todos los agentes son exclusivos del 040.** No comparten ni heredan instrucciones del 030, 020 o del 010.

### 1.2 Workers Especializados

| Worker | Micro-tarea | Inputs que recibe | Output (path) |
|--------|-------------|-------------------|---------------|
| `planning-analyst` | Lee los 12 inputs (I-1..I-12). Valida granularidad del draft VS, detecta IC-xx y BDD scenarios huérfanos, extrae dependencias entre slices e identifica riesgos por slice. Produce planning_analysis_report.md | Paths a I-1..I-12 + Demo Statement del orchestration_plan | `/040_planning/planning_analysis_report.md` |
| `planning-writer` | Lee planning_analysis_report.md + inputs de referencia. Produce los 3 artefactos finales en orden. | Path a planning_analysis_report.md + paths a I-1, I-4, I-6, I-12 + Demo Statement | `/040_planning/vertical_slice_plan.md`, `/040_planning/project_roadmap.md`, `/040_planning/risk_register.md` |

**Secuenciación:** planning-analyst → planning-writer (dependencia estricta, no paralela).

Cada Worker escribe sus artefactos al filesystem y reporta a A **solo el path**, nunca el
contenido (E6 — Regla de Referencias Ligeras).

**Demo Statements (ADJ-13):**

El planning-orchestrator (modo PLAN) escribe un Demo Statement por Worker en el `orchestration_plan`
antes de que el governor spawee ningún Worker.

**Demo Statement para planning-analyst:**
> "Cuando planning-analyst termine, podré observar que `040_planning/planning_analysis_report.md`
> existe y contiene: (a) tabla de validación de granularidad para cada VS-xx del draft
> del 030, indicando si pasa o requiere división; (b) lista de IC-xx huérfanos (puede ser
> vacía); (c) lista de BDD scenarios huérfanos (puede ser vacía); (d) matriz de dependencias
> entre slices derivada de DEP-xx; (e) ≥1 riesgo preliminar por VS-xx."

**Demo Statement para planning-writer:**
> "Cuando planning-writer termine, podré observar que: `vertical_slice_plan.md` tiene
> una entrada VS-xx por cada slice (incluyendo las nuevas si se dividieron), cada una con
> los 6 campos obligatorios (nombre, tipo, IC-xx, BDD scenarios, Criterio de Done, esfuerzo);
> `project_roadmap.md` lista todas las VS-xx en secuencia respetando la estructura
> TB→Crecimiento→MVP→Evolución→Robustez, con dependencias VS-xx → VS-xx explícitas y los
> 3 hitos obligatorios marcados; `risk_register.md` tiene ≥1 RK-xx por VS-xx con
> probabilidad, impacto y mitigación."

Cada Worker, al terminar su producción, ejecuta un self-checklist contra su Demo Statement.
- Si puede verificar todas las condiciones: reporta `COMPLETED`.
- Si no puede: reporta `INCOMPLETO: <razón específica>`. No reporta COMPLETED si alguna condición falla.

**Pending Verification (ADJ-13):**

Después de que un Worker reporta COMPLETED, el orchestrator (en modo CHECKPOINT) verifica en
disco que el artefacto esperado existe y tiene contenido antes de registrar el checkpoint.
- Si el artefacto no existe o está vacío: retornar `CHECKPOINT_FAILED` al governor.
- Solo si el artefacto existe en disco: registrar el checkpoint y retornar `CHECKPOINT_OK`.

El governor, al recibir `CHECKPOINT_FAILED`, no spawea el siguiente Worker. Registra
`WORKER_FAILED` en execution-state.json y escala al humano.

### 1.3 Política de Herramientas (P7)

| Agente | Herramientas permitidas | Restricciones |
|--------|------------------------|---------------|
| planning-governor | Read, Write, Bash, Agent, AskUserQuestion | NUNCA escribe en `/040_planning/` directamente |
| planning-orchestrator | Read, Write | NUNCA escribe en `/040_planning/`; solo en `persistence/execution-state.json` |
| planning-analyst | Read, Write | Solo produce `/040_planning/planning_analysis_report.md` |
| planning-writer | Read, Write, Edit | Produce los 3 artefactos en `/040_planning/`; puede editar para corregir antes del self-checklist |
| planning-reviewer | Read, Write | Lee de `/040_planning/` y `/030_design/`; escribe solo `040_planning/review_report.md` |
| planning-evaluator | Read, Write | Lee de `/040_planning/`, `/030_design/` y `/020_specification/`; escribe solo en `eval/` |

Política de Fallback ante fallo de herramienta (3 niveles — E5):
1. **Reintento** (hasta 2x): reintentar si falla por error transitorio.
2. **Fallback**: si no se puede derivar un dato de los inputs, marcarlo con `[PENDIENTE: razón]`
   en el artefacto y continuar con los demás ítems.
3. **Escalamiento**: registrar en `execution-state.json` bajo `worker_errors`, notificar a A.
   A escala al humano vía `AskUserQuestion`. Sin inventar información de planificación.

### 1.4 Política de Escalamiento (P6, E8)

Escalar al humano (detener flujo) en los siguientes casos:
- El draft del 030 no contiene una sección "Guía de Vertical Slices" o no tiene los 3 hitos
  mínimos (Tracer Bullet, MVP, Robustez) — el 040 requiere este input para operar.
- El planning-analyst detecta IC-xx en `contract_definitions.md` que no existe en ningún
  bounded context de `bdd_features.md` (gap de trazabilidad del 030 no detectado por el 030).
- Las dependencias entre slices crean un ciclo (A depende de B que depende de A) — requiere
  decisión humana sobre cómo romper el ciclo.
- El cliente rechaza la estructura de slices propuesta y desea un paradigma de planificación
  distinto (ej. sprints temporales en lugar de Vertical Slices).

En todos los casos: A registra el bloqueo en `harness-state.json` bajo `escalations` y
notifica al humano con contexto completo (ítem bloqueante, artefacto afectado, próxima acción propuesta).

### 1.5 Checkpoints Canónicos (E5)

| ID | Momento | Qué persiste B |
|----|---------|----------------|
| CP-01 | Tras planning-analyst | Path a `040_planning/planning_analysis_report.md` en execution-state.json |
| CP-02 | Tras planning-writer (draft) | Paths a los 3 artefactos en execution-state.json; marca `EXECUTION_COMPLETE` |
| — | Tras CP-02 (pre-CP-03) | A spawea planning-reviewer. Si issues críticos → rework. Reviewer produce `040_planning/review_report.md` |
| CP-03 | Cliente revisa draft | A presenta los 3 artefactos al cliente (+ issues menores del reviewer si los hay); registra feedback en `harness-state.json` |
| CP-04 | Cliente aprueba formalmente | A registra aprobación en `harness-state.json`; spawea C para auditoría |

### 1.6 Trigger de Context Reset (E2)

Criterios (el que ocurra primero):

- **Conductual (primario):** señales de ansiedad contextual durante la producción de artefactos:
  asignar IC-xx a slices sin verificar que existen en `contract_definitions.md`, omitir slices
  obligatorias (Tracer Bullet, MVP o Robustez), generar RK-xx sin mitigación concreta, declarar
  artefactos como COMPLETED sin ejecutar el self-checklist del Demo Statement.
- **Cuantitativo (secundario):** ≥70% de tokens usados.

Acción ante reset: continuar desde el último checkpoint guardado en `execution-state.json`
usando el Ritual E10-B (Continuación). Nunca reiniciar desde cero.

---

## Sprint Contract — Plantilla

Template que A propone al humano antes de spawear B. Requiere aprobación explícita antes de
continuar. Si el humano solicita ajustes, A incorpora y vuelve a presentar. Si cancela, A
registra en `claude-progress.txt` y detiene el flujo.

```
SPRINT CONTRACT — 040 Planning
=====================================
Objetivo    : Tomar el draft de Vertical Slices del 030 y producir el plan maestro
              completo del proyecto: slices formalizadas, roadmap con dependencias
              y registro de riesgos por slice.
Fase        : 040 — Planning
Modo        : [INICIO | CONTINUACIÓN]
Precondición: 030 Design — PHASE_COMPLETE ✓

VS Draft del 030 (extracto de test_strategy_map.md):
  [lista de VS-xx identificadas en el draft del 030 con su tipo]

Inputs disponibles:
  Desde /030_design/:
  - test_strategy_map.md           : [confirmado / path — VS draft principal]
  - architecture_decision_records.md: [confirmado / path]
  - technical_blueprint.md         : [confirmado / path]
  - contract_definitions.md        : [confirmado / path]
  - dependency_graph.md            : [confirmado / path]
  Desde /020_specification/:
  - bdd_features.md                : [confirmado / path]
  - data_contracts.md              : [confirmado / path]
  - acceptance_criteria.md         : [confirmado / path]
  - error_exception_policy.md      : [confirmado / path]
  Desde /010_discovery/:
  - shared_understanding.md        : [confirmado / path]
  - scope_boundaries.md            : [confirmado / path]
  - domain_glossary.md             : [confirmado / path]

Workers activados:
  - planning-analyst  → /040_planning/planning_analysis_report.md
  - planning-writer   → /040_planning/vertical_slice_plan.md
                        /040_planning/project_roadmap.md
                        /040_planning/risk_register.md

Checkpoints : CP-01, CP-02, CP-03, CP-04
Criterio Done:
  (1) Todas las VS-xx del draft validadas (sobredimensionadas divididas)
  (2) Todos los IC-xx de contract_definitions.md asignados a ≥1 slice
  (3) Todos los BDD scenarios de bdd_features.md asignados a ≥1 slice
  (4) project_roadmap.md respeta TB→Crecimiento→MVP→Evolución→Robustez sin deps circulares
  (5) risk_register.md con ≥1 RK-xx por slice con probabilidad, impacto y mitigación
  (6) Aprobación explícita del cliente en CP-04

Riesgos identificados:
  - [draft del 030 con slices sobredimensionadas que requieran división]
  - [IC-xx o BDD scenarios sin asignación clara a ninguna slice]
  - [dependencias entre slices que creen restricciones de orden no anticipadas]

Próxima acción: spawear planning-orchestrator en modo PLAN para persistir el orchestration_plan
```

---

## Rúbrica de Evaluación (Instancia C)

### Dimensiones

| ID | Dimensión | Descripción | Score |
|----|-----------|-------------|-------|
| D1 | VS Coverage | Todos los IC-xx de `contract_definitions.md` y todos los BDD scenarios de `bdd_features.md` están asignados a ≥1 slice en `vertical_slice_plan.md`. Sin huérfanos | 0.0–1.0 |
| D2 | Slice Definition Quality | Cada slice en `vertical_slice_plan.md` tiene los 6 campos obligatorios: nombre, tipo, IC-xx, BDD scenarios, Criterio de Done con referencias a IDs, estimación de esfuerzo | 0.0–1.0 |
| D3 | Roadmap Coherence | La secuencia en `project_roadmap.md` respeta TB→Crecimiento→MVP→Evolución→Robustez. Sin dependencias circulares. Los 3 hitos obligatorios marcados. Dependencias VS-xx → VS-xx explícitas y derivadas de DEP-xx | 0.0–1.0 |
| D4 | Risk Completeness | `risk_register.md` tiene ≥1 RK-xx por slice. Cada RK-xx tiene probabilidad (Alta/Media/Baja), impacto (Alto/Medio/Bajo) y mitigación concreta (no genérica) | 0.0–1.0 |
| D5 | Consistency | Los IDs (VS-xx, IC-xx, SC-xx/SE-xx, RK-xx) son coherentes entre los 3 artefactos. Sin contradicciones con los inputs del 030 (IC-xx en plan existe en contract_definitions; BDD scenarios en plan existe en bdd_features). Lenguaje ubicuo del glosario usado consistentemente | 0.0–1.0 |

**Gate de paso:** Score promedio ≥ 0.75 en todas las dimensiones.
**Regla de veto:** Si D5 = 0.0, rechazo automático independientemente de otras dimensiones.

### Anclas de calibración (few-shot — E3)

> Dominio de referencia: Sistema de Inventario y Alertas de Stock — Distribuidora Andina Ltda.
> (del test_specification_003). Slices hipotéticas: VS-01 Tracer Bullet (login + GET /stock/{id}),
> VS-02 Crecimiento (CRUD inventario), VS-03 MVP (alertas de umbral + notificaciones),
> VS-04 Evolución (historial de movimientos), VS-05 Robustez (manejo de errores + retry).

**Score 0.2** — `vertical_slice_plan.md` lista las slices sin IC-xx ni BDD scenarios asignados
(solo nombres). `project_roadmap.md` tiene la secuencia correcta pero sin dependencias explícitas
ni hitos marcados. `risk_register.md` con un único riesgo genérico ("complejidad técnica") para
todas las slices, sin probabilidad ni impacto. IC-xx huérfanos en `contract_definitions.md`.

> Ejemplo: VS-03 MVP listada sin IC-xx ni SC-xx asignados. `project_roadmap.md` dice "VS-01,
> VS-02, VS-03, VS-04, VS-05" sin ninguna dependencia VS-xx → VS-xx. `risk_register.md` tiene
> una sola línea: "RK-01 — Riesgo técnico general. Probabilidad: Alta. Impacto: Alto." sin
> mitigación. IC-05 (IAlertaRepository) sin asignar a ninguna slice.

**Score 0.5** — `vertical_slice_plan.md` con IC-xx asignados a las slices principales pero BDD
scenarios parcialmente asignados (≥50% cubiertos). `project_roadmap.md` con hitos marcados pero
dependencias incompletas (faltan 3-4 relaciones VS-xx → VS-xx). `risk_register.md` con ≥1 RK-xx
por slice pero mitigaciones genéricas ("revisar el código", "hacer más testing").

> Ejemplo: VS-03 MVP tiene IC-05, IC-06 asignados pero falta SC-07 (notificación por email)
> sin asignar. `project_roadmap.md` marca VS-01 como hito pero no VS-03 ni VS-05. Dependencia
> VS-03 → VS-01 documentada pero falta VS-04 → VS-02 (historial requiere CRUD previo).
> `risk_register.md`: RK-03 para VS-03 dice "Riesgo de integración. Mitigación: testear bien."

**Score 0.8** — `vertical_slice_plan.md` con todos los IC-xx y ≥90% de BDD scenarios asignados,
criterios de Done con referencias a IDs pero 1-2 slices sin estimación de esfuerzo. `project_roadmap.md`
completo con los 3 hitos y dependencias derivadas de DEP-xx, pero sin estimar duración relativa.
`risk_register.md` con ≥1 RK-xx por slice con probabilidad e impacto, pero 2-3 mitigaciones
todavía genéricas.

> Ejemplo: VS-04 Evolución sin campo de esfuerzo en `vertical_slice_plan.md`. SC-12 asignado
> a VS-04 pero sin referencia en el Criterio de Done de esa slice. `project_roadmap.md` correcto
> en secuencia y dependencias pero sin "Duración estimada: S". RK-04 para VS-04: "Riesgo de
> performance en historial de movimientos. Probabilidad: Media. Impacto: Medio. Mitigación:
> agregar índice en la tabla de movimientos." RK-05 para VS-05: "Riesgo de cobertura de errores.
> Mitigación: hacer revisión de código." (demasiado genérica).

**Score 1.0** — `vertical_slice_plan.md` con 100% de IC-xx y BDD scenarios asignados. Cada slice
con los 6 campos completos: nombre, tipo, IC-xx, BDD scenarios con IDs, Criterio de Done con
referencias a IC-xx y SC-xx específicos, estimación de esfuerzo (XS/S/M/L/XL). `project_roadmap.md`
con secuencia correcta, 3 hitos marcados, todas las dependencias VS-xx → VS-xx explícitas y
derivadas de DEP-xx, estimación de duración relativa por slice. `risk_register.md` con ≥1 RK-xx
por slice, probabilidad + impacto + mitigación concreta. Sin contradicciones entre los 3 artefactos
ni con los inputs. Lenguaje ubicuo consistente.

> Ejemplo: VS-03 MVP — IC-05 (IAlertaRepository), IC-06 (INotificacionService); BDD: SC-07, SC-08,
> SE-03; Criterio de Done: "IC-05 con método `findByUmbral` retorna correctamente en SC-07 y SC-08;
> IC-06 envía notificación en SE-03; tests de integración pasan para ambas interfaces"; Esfuerzo: L.
> `project_roadmap.md`: VS-03 depende de VS-01 (IC-01 del login requerida) y VS-02 (IC-03 de stock
> requerida para evaluar umbrales). Hito MVP marcado en VS-03. Duración estimada: M. `risk_register.md`:
> RK-03 para VS-03 — "Dependencia de servicio SMTP externo para IC-06. Probabilidad: Media. Impacto:
> Alto (bloquea el MVP). Mitigación: usar stub de INotificacionService en el Tracer Bullet; configurar
> SMTP real solo en VS-03; tener proveedor alternativo documentado en ADR-002." Sin ningún ID
> referenciado en el plan que no exista en contract_definitions.md o bdd_features.md.

### Output de C

```json
// eval/verdict.json — append al array existente
{
  "phase": "040_planning",
  "evaluation_version": 1,
  "evaluated_at": "<timestamp>",
  "verdict": "APPROVED | REJECTED",
  "veto_triggered": false,
  "scores": {
    "D1_vs_coverage": 0.0,
    "D2_slice_definition_quality": 0.0,
    "D3_roadmap_coherence": 0.0,
    "D4_risk_completeness": 0.0,
    "D5_consistency": 0.0
  },
  "average": 0.0,
  "gate_threshold": 0.75,
  "gate_passed": false,
  "findings": [],
  "artifacts_evaluated": [
    "040_planning/vertical_slice_plan.md",
    "040_planning/project_roadmap.md",
    "040_planning/risk_register.md"
  ],
  "reference_artifacts_read": [
    "030_design/contract_definitions.md",
    "020_specification/bdd_features.md",
    "010_discovery/domain_glossary.md"
  ]
}
```

---

## Handoff Artifact → 050 Vertical Harness

Planning entrega al 050 los siguientes artefactos. El 050 **no puede iniciarse** sin ellos.

```
/040_planning/
├── vertical_slice_plan.md   → Fuente de verdad: qué contiene cada slice (IC-xx + BDD + Done + esfuerzo)
├── project_roadmap.md       → Qué slice viene después de cuál y cuáles son los hitos
└── risk_register.md         → Riesgos a considerar al planificar cada slice

/030_design/                     → El 050 hereda los 5 artefactos del 030
├── technical_blueprint.md
├── contract_definitions.md
├── dependency_graph.md
├── architecture_decision_records.md
└── test_strategy_map.md

/020_specification/              → El 050 hereda los 4 artefactos del 020
├── bdd_features.md
├── data_contracts.md
├── acceptance_criteria.md
└── error_exception_policy.md

/010_discovery/                  → El 050 hereda los 4 artefactos del 010
├── shared_understanding.md
├── domain_glossary.md
├── scope_boundaries.md
└── failure_behavior.md
```

**Condición de activación del 050:** `harness-state.json` debe tener `"040_planning": {"status": "PHASE_COMPLETE"}`.

**Nota ADJ-05:** El 050 se llama "050 Vertical Harness" y trabaja una slice a la vez.
La slice activa se identifica leyendo `project_roadmap.md` (primera VS-xx sin estado
`DONE` en `harness-state.json`).

---

## Flujo del Arnés

### 12.1 Inicialización (Instancia A — planning-governor)

**Precondición absoluta — antes de cualquier acción:**
Verificar que `persistence/harness-state.json` existe y que la clave `"030_design"`
tiene `"status": "PHASE_COMPLETE"`. Si no existe o el status es distinto: **detener flujo**.
Notificar al humano: "El 030 Design debe completarse antes de iniciar el 040 Planning.
Estado actual: [valor encontrado]."

**Determinación del modo:**

| Condición | Modo | Ritual |
|-----------|------|--------|
| No existe clave `"040_planning"` en `harness-state.json` | Inicio | E10-A |
| Existe clave `"040_planning"` e íntegra | Continuación | E10-B |
| Existe pero corrupta | Recuperación | `git restore persistence/harness-state.json`; si persiste → detener y reportar |

**Ritual E10-A — Inicio:**

1. Verificar directorio y ambiente
2. Crear carpeta `/040_planning/` con verificación post-creación (ADJ-20):
   ```powershell
   if (-not (Test-Path "plan")) { New-Item -ItemType Directory "plan" | Out-Null }
   if (-not (Test-Path "plan")) { # registrar error crítico y detener }
   ```
3. Leer `persistence/harness-state.json` completo. Agregar clave `"040_planning"` con status
   `"PENDING_CONTRACT"` sin modificar ninguna clave existente.
   Fallback si JSON corrupto: `git restore persistence/harness-state.json`; si persiste, detener.
4. Inicializar `persistence/execution-state.json` para el 040 con estructura mínima.
5. Prueba básica de sanidad: escribir y leer archivo de prueba en `/040_planning/`.
6. Registrar arranque en `persistence/claude-progress.txt` con `Add-Content -Encoding utf8`.

**Ritual E10-B — Continuación:**

1. Verificar directorio y ambiente
2. `git log --oneline -10` para orientación
3. Leer `persistence/claude-progress.txt` (estado narrativo)
4. Cargar `persistence/harness-state.json` (Sprint Contract vigente del 040)
5. Leer `persistence/execution-state.json` (último checkpoint alcanzado)
6. Seleccionar siguiente tarea según último CP:

| Estado en harness-state.json / execution-state.json | Siguiente acción |
|------------------------------------------------------|-----------------|
| `040_planning.status == "AUDIT_PENDING"` | Ir directamente a Auditoría (verificar eval/verdict.json) |
| `execution_state.last_checkpoint == "CP-02"` o `status == "EXECUTION_COMPLETE"` | Presentar artefactos al cliente (CP-03) |
| `execution_state.last_checkpoint == "CP-01"` | Continuar con planning-writer (re-spawear) |
| `execution_state.last_checkpoint == null` y `040_planning.status == "ACTIVE"` | Continuar con planning-analyst (re-spawear) |
| `040_planning.status == "PENDING_CONTRACT"` | Proponer Sprint Contract al cliente |

7. Prueba básica de sanidad

**Reporte al humano (obligatorio tras inicialización):**

1. Estado encontrado (modo, integridad del 030, sanidad)
2. Resumen del VS draft del 030 (cuántas slices, tipos, IC-xx totales)
3. Sprint Contract propuesto (Inicio) o vigente (Continuación)
4. Próxima acción concreta

**Gate de aprobación humana:**

- **Aprobado** → A escribe Sprint Contract en clave `"040_planning"` de `harness-state.json` y spawea B en modo PLAN
- **Ajuste requerido** → A incorpora cambios, vuelve a presentar
- **Cancelación** → A registra en `claude-progress.txt`, detiene flujo

### 12.2 Ejecución Técnica (Instancia B — planning-orchestrator + Workers)

1. A spawea planning-orchestrator en `[MODO: PLAN]`. Orchestrator:
   - Lee Sprint Contract desde `"040_planning"` en `harness-state.json`
   - Consulta `knowledge/` si existe
   - Determina starting_point desde execution-state.json (CP-01, o null si inicio)
   - Escribe orchestration_plan completo con Demo Statements para cada Worker
   - Retorna `PLAN_RESULT`

2. A recibe PLAN_RESULT. Según starting_point:
   - `null` → spawear planning-analyst
   - `CP-01` → spawear planning-writer (saltar analyst)
   - `COMPLETE` → ir directamente a CP-03

3. **planning-analyst** (si starting_point == null):
   - Recibe paths a I-1..I-12 y el Demo Statement del orchestration_plan
   - Lee los 12 inputs, produce `/040_planning/planning_analysis_report.md`
   - Ejecuta self-checklist contra Demo Statement
   - Si COMPLETED: reporta path a A
   - Si INCOMPLETO: reporta razón a A; A registra WORKER_FAILED y escala al humano

4. A spawea planning-orchestrator en `[MODO: CHECKPOINT-01]` con path al planning_analysis_report.md.
   Orchestrator verifica en disco (Pending Verification) y retorna CHECKPOINT_OK o CHECKPOINT_FAILED.

5. **planning-writer** (si CP-01 alcanzado):
   - Recibe path a planning_analysis_report.md + paths a I-1, I-4, I-6, I-12 + Demo Statement
   - Produce los 3 artefactos en orden: vertical_slice_plan → project_roadmap → risk_register
   - Ejecuta self-checklist cruzado entre los 3 artefactos + Demo Statement
   - Si COMPLETED: reporta paths a A
   - Si INCOMPLETO: reporta razón a A; A registra WORKER_FAILED

6. A spawea planning-orchestrator en `[MODO: CHECKPOINT-02]` con paths a los 3 artefactos.
   Orchestrator verifica en disco y retorna CHECKPOINT_OK o CHECKPOINT_FAILED.

### 12.2.5 — Revisión pre-CP-03 (planning-reviewer)

Tras recibir `CHECKPOINT_OK` del CP-02, A spawea planning-reviewer pasando paths a los 3
artefactos finales + paths a I-4 (`contract_definitions.md`) y I-6 (`bdd_features.md`).

**4 verificaciones obligatorias del reviewer (mentalidad Abogado del Diablo):**

- **V1 — IC-xx en `vertical_slice_plan` ↔ `contract_definitions.md`:**
  Extraer IC-xx de contract_definitions; extraer IC-xx de vertical_slice_plan.
  IC-xx en contract_definitions sin asignación a ninguna slice → CRITICAL.

- **V2 — BDD scenarios en `vertical_slice_plan` ↔ `bdd_features.md`:**
  Extraer SC-xx/SE-xx de bdd_features; extraer SC-xx/SE-xx de vertical_slice_plan.
  Scenario sin asignación a ninguna slice → CRITICAL.

- **V3 — Secuencia en `project_roadmap` respeta estructura obligatoria:**
  Verificar que Tracer Bullet aparece primero, MVP en posición intermedia, Robustez al final.
  Slices de Crecimiento antes del MVP; slices de Evolución después del MVP.
  Violación del orden → CRITICAL.

- **V4 — `risk_register` cubre todas las VS-xx de `vertical_slice_plan`:**
  Extraer VS-xx de vertical_slice_plan; verificar que aparecen en risk_register.
  VS-xx sin ≥1 RK-xx → CRITICAL.

Reviewer produce `040_planning/review_report.md` como PRIMER tool call (LL-01).
Retorna: `REVIEW_COMPLETE, REVIEW_RESULT: CLEAN | HAS_ISSUES, CRITICAL_COUNT: <n>, MINOR_COUNT: <n>`.

Si `CRITICAL_COUNT > 0`: A no presenta a CP-03. Re-spawea planning-writer con referencia al
review_report.md. Ciclo continúa desde paso 5 de 12.2.

### 12.3 Auditoría y Gate de Aprobación (Instancia C + A)

**Paso 1 — Gate intermedio (A):**

1. A verifica que `execution-state.json` tiene `EXECUTION_COMPLETE` y reviewer retornó `CLEAN`
2. A presenta los 3 artefactos de `/040_planning/` al cliente para revisión (CP-03)
3. **IMPORTANTE (ADJ-23):** Registrar `[CP-03 040]` en `claude-progress.txt` con
   `Add-Content -Encoding utf8` ANTES de presentar los artefactos. Aunque el cliente
   incluya aprobación en la misma respuesta del CP-03, presentar CP-04 como
   `AskUserQuestion` separado e independiente.
4. A incorpora feedback del cliente si hay cambios menores
5. A presenta CP-04: `AskUserQuestion` independiente para aprobación formal

**Paso 2 — Tras aprobación CP-04:**

1. A escribe `"040_planning.status": "AUDIT_PENDING"` en `harness-state.json`
2. A registra `[AUDIT_PENDING 040]` en `claude-progress.txt`
3. A spawea planning-evaluator pasando paths a los 3 artefactos + paths de referencia I-4, I-6, I-12

**Paso 3 — Auditoría (C — planning-evaluator):**

1. C lee los 3 artefactos desde el filesystem (sin contexto de ejecución)
2. C lee `030_design/contract_definitions.md`, `020_specification/bdd_features.md`,
   `010_discovery/domain_glossary.md` como referencia para D1, D3 y D5 (verificación independiente)
3. C evalúa contra rúbrica (Sección anterior), aplica anclas de calibración — dos fases:
   análisis con citas concretas primero, score después (LL-07)
4. C verifica la regla de veto: si D5 = 0.0, emite rechazo automático
5. C escribe (**PATHS DE SALIDA — OBLIGATORIO: solo en `eval/`, nunca en `/040_planning/`** — LL-03):
   - `eval/verdict.json` — append al array existente, entry con `"phase": "040_planning"`
   - `eval/metrics_summary.json` — append al array existente
6. C registra auditoría en `persistence/claude-progress.txt`

**Paso 4 — Decisión final (A — GateKeeper):**

```
## Cierre — ANTES DE CUALQUIER ACCIÓN — VERIFICACIÓN OBLIGATORIA (LL-20):
1. Leer eval/verdict.json.
2. Verificar que existe al menos una entrada con "phase": "040_planning".
3. Si NO existe → DETENER completamente. Ejecutar la sección Auditoría ahora.
   No continuar bajo ninguna circunstancia sin esta verificación.
```

- A lee `eval/verdict.json`, filtra por `"phase": "040_planning"`, toma la última entrada
- **APPROVED** → A marca `"040_planning.status": "PHASE_COMPLETE"` en `harness-state.json`,
  notifica al humano con paths de los 3 artefactos, activa handoff al 050
- **REJECTED** → A activa protocolo 12.4

### 12.4 Protocolo de Rechazo y Reintento

**Rechazo Técnico** (artefacto no cumple rúbrica):

1. C escribe rechazo detallado en `eval/verdict.json` con dimensiones fallidas y recomendaciones
2. A marca `"040_planning.status": "IN_REWORK"` en `harness-state.json`
3. A spawea planning-orchestrator en modo PLAN pasando referencia al rechazo
4. Orchestrator escribe nuevo plan; A spawea solo el Worker que produce el artefacto fallido
5. B lee `knowledge/lessons_learned.md` antes de re-ejecutar
6. El ciclo continúa desde 12.3

**Rechazo Estratégico** (cliente rechaza la estructura de slices o el paradigma):

1. A detiene flujo, marca `"040_planning.status": "HOLD"` en `harness-state.json`
2. A actualiza Sprint Contract con el cambio
3. Sin avance hasta nueva aprobación humana explícita

**Registro de aprendizaje:**

Todo rechazo — técnico o estratégico — es registrado en `knowledge/lessons_learned.md` al
cierre del ciclo, con: dimensión fallida, causa raíz identificada y regla para sesiones futuras.

### 12.5 Cierre

1. A marca `"040_planning.status": "PHASE_COMPLETE"` en `harness-state.json`
2. A actualiza `knowledge/lessons_learned.md` con hallazgos del ciclo (qué funcionó, qué no,
   qué decisiones de granularidad generaron más iteración)
3. A actualiza `knowledge/decisions_library.md` con: estructura de slices aprobada (tipos y
   conteo), decisiones de granularidad tomadas (slices divididas y por qué), riesgos de mayor
   impacto identificados. **NO limitarse a hitos procedimentales** (ADJ-22).
4. A notifica al humano con resumen de cierre:
   - Artefactos producidos y sus paths (los 3 artefactos en `/040_planning/`)
   - Scores finales de la rúbrica
   - VS-xx totales planificadas e hitos del proyecto (Tracer Bullet, MVP, Robustez)
5. A registra cierre en `persistence/claude-progress.txt` con `Add-Content -Encoding utf8`
6. A hace commit final: `docs(040-planning): phase complete — 3 artefactos producidos`

**Handoff al 050:**

A pregunta al humano si desea continuar con el 050 Vertical Harness.
- **Sí** → A registra `"handoff_050": {"status": "DEPLOYED"}` en `harness-state.json`,
  ejecuta deploy via `$env:HARNESS_DEPLOY_SCRIPT 050`, instruye al humano:
  **"Reinicia la sesión. El CLAUDE.md detectará el estado DEPLOYED y arrancará
  planning-governor automáticamente."**
- **No** → A registra `"handoff_050": {"status": "PENDING_HANDOFF"}` en `harness-state.json`

Registrar evento en `claude-progress.txt` en cualquier caso.
