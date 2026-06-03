# Bitácora de Avance — Harness Definition

> **INSTRUCCIÓN PARA AGENTES:** Este es el primer archivo que debes leer al iniciar
> cualquier sesión de trabajo en este proyecto. Contiene el estado actual, las
> decisiones tomadas y los próximos pasos. No comiences ninguna tarea sin leerlo.

---

## Estado General del Proyecto

- **Fecha de última actualización:** 2026-06-01 (Sesión 40)
- **Fase actual:** Blueprint del 030 Design Harness CREADO (`plans/030_design_harness.md`). Próximo paso: construir los componentes del 030 (skills → agentes → infraestructura).
- **Estado:** `plans/030_design_harness.md` completo con 7 secciones, rúbrica D1-D5, Demo Statements (ADJ-13), LL-01..LL-23 aplicadas. Ningún agente ni skill del 030 construido aún.

---

## Contexto del Proyecto

Se está construyendo una **metodología universal para la construcción de harnesses**
destinada a una empresa de desarrollo de software. El objetivo es que cualquier
harness futuro pueda construirse siguiendo este estándar, garantizando calidad y
reducción de varianza en los outputs de LLMs.

### Fuentes de Verdad
- `Insumos/principios.md` — Principios P1-P8 y Estándares E1-E12. **No se modifica nunca.**
- `Insumos/metodologia.md` — Metodología universal. **ALINEADA Y CERRADA.** No se modifica.
- `support/ajustes.md` — Activos: IMP-22, IMP-28, ADJ-04..08, ADJ-12, ADJ-13. ADJ-14/15/17/18/19 → IMPLEMENTADO ✅ (Sesión 35). ADJ-20/21/22/23/24 → IMPLEMENTADO ✅ (Sesión 39).
- `support/lessons_learned.md` — 23 lecciones universales (LL-01 a LL-23). LL-20..23 agregadas en Sesión 34.

### Estado actual del repositorio

```
Harness_Definition/
├── deploy-harness.ps1             — Script de deployment (soporta 010-090; CLAUDE.md siempre sobreescrito)
├── README.md                      — Documentación para humanos
├── CLAUDE.md                      — Instrucciones para agentes Claude Code
├── support/
│   ├── avance.md                  — Este archivo (bitácora de estado)
│   └── ajustes.md                 — 9 activos (IMP-22, IMP-28, ADJ-04..08, ADJ-12, ADJ-13) + diferidos (IMP-13, OBS-01..04)
├── Insumos/
│   ├── metodologia.md             — Metodología universal (CERRADA — no tocar)
│   └── principios.md              — Principios P1-P8 y Estándares E1-E12 (no tocar)
├── plans/
│   ├── 010_discovery_harness.md   — Blueprint COMPLETO (referencia de patrón)
│   ├── 020_specification_harness.md — Blueprint COMPLETO (referencia de patrón del 020)
│   └── 030_design_harness.md      — Blueprint COMPLETO ✓ (Sesión 40) — referencia para construir agentes y skills
├── templates/
│   ├── client-project-CLAUDE.md   — Opción B: detección automática de governor por fase activa
│   └── client-project-settings.json — Permisos pre-autorizados para proyectos cliente
├── Harnesses/
│   ├── 010_discovery_harness.md   — Harness COMPLETO e IMPLEMENTADO
│   ├── 020_specification_harness.md — Harness COMPLETO e IMPLEMENTADO
│   └── 030..090_*.md              — Definiciones de alto nivel
└── .claude/
    ├── agents/
    │   ├── discovery-*.md (×6)           — 010 COMPLETOS (orchestrator: modos PLAN/CHECKPOINT — sin Agent tool; governor: spawea workers directamente)
    │   ├── specification-analyst.md      — 020 Worker 1 ✓ (78 líneas, 2 skills)
    │   ├── specification-writer.md       — 020 Worker 2 ✓ (63 líneas, 3 skills)
    │   ├── specification-evaluator.md    — 020 Instancia C ✓ (D1 independiente vs 010)
    │   ├── specification-orchestrator.md — 020 Instancia B ✓ (modos PLAN/CHECKPOINT/EARLY_EVAL — sin Agent tool)
    │   └── specification-governor.md     — 020 Instancia A ✓ (spawea workers directamente, bloqueo duro Cierre)
    └── skills/
        ├── discovery-*.md (×8)                   — 010 COMPLETAS
        ├── specification-analysis-schema/         — 020 ✓ schema de spec_analysis_report.md
        ├── specification-analyst-protocol/        — 020 ✓ 7 categorías de extracción
        ├── specification-synthesis-schema/        — 020 ✓ schema de los 4 artefactos finales
        ├── specification-writer-protocol/         — 020 ✓ transformación CF→BDD + consistencia cruzada
        ├── specification-rubric/                  — 020 ✓ rúbrica D1-D5 con anclas y veto
        ├── specification-verdict-schema/          — 020 ✓ schema verdict + metrics (array acumulativo)
        ├── specification-evaluator-protocol/      — 020 ✓ verificación D2-D5 + checks cruzados de IDs
        └── specification-state-schema/            — 020 ✓ schema harness-state + execution-state
```

### Qué significa "definición" vs "harness completo"

- **Definición** (`Harnesses/020_specification_harness.md`): Describe a alto nivel qué
  recibe el harness (Inputs), qué hace (Proceso) y qué produce (Outputs). Es el contrato
  conceptual de la fase. **No es el harness operativo.**
- **Harness completo** (lo que hay que construir): Implementa el Patrón Universal de Fase.
  Incluye agentes (governor, orchestrator, workers, evaluator), skills de soporte, rúbrica
  calibrada con anclas y few-shot, y flujo completo 12.1–12.5. El blueprint está en
  `plans/020_specification_harness.md`.

---

## Historial de Sesiones

### Sesión 40 — 2026-06-01

**Objetivo de la sesión:**
Iniciar la construcción del 030 Design Harness creando el blueprint completo (`plans/030_design_harness.md`).

**Trabajo realizado:**

- **`plans/030_design_harness.md` creado** — Blueprint completo del 030 con las 7 secciones obligatorias:
  - **Fase 0** — Precondición (020 PHASE_COMPLETE), 8 inputs (4 de /specification/ + 4 de /discovery/),
    7 pasos de proceso, 5 outputs en `/design/`, Criterio de Done (5 condiciones), ciclo adaptado.
  - **Fase 1** — Instancias/roles, 2 Workers (design-analyst → design-architect), política de
    herramientas, escalamiento, 4 checkpoints canónicos (CP-01..CP-04), trigger de context reset.
  - **Sprint Contract** — Template con restricciones tecnológicas del scope_boundaries.md.
  - **Rúbrica** — 5 dimensiones (D1 Blueprint Coverage, D2 Contract Completeness, D3 Testability,
    D4 ADR Completeness, D5 Consistency), veto en D5, gate ≥0.75, anclas 0.2/0.5/0.8/1.0
    con few-shot calibrado en el dominio de inventario (Distribuidora Andina Ltda.).
  - **Handoff → 040** — 13 artefactos disponibles (5 de /design/ + 4 de /specification/ + 4 de /discovery/).
    Nota ADJ-04: test_strategy_map.md debe incluir "Guía de Vertical Slices" con ≥3 iteraciones.
  - **Flujo 12.1–12.5** — Completo con E10-A/E10-B, tabla de selección E10-B para el 030,
    Demo Statements (ADJ-13), Pending Verification (ADJ-13), bloqueo duro en Cierre (LL-20),
    ADJ-23 (CP-03 y CP-04 independientes), ADJ-24 (Add-Content utf8).

- **Decisiones de diseño tomadas:**

  | Decisión | Detalle |
  |----------|---------|
  | 2 Workers: design-analyst + design-architect | Mismo patrón que el 020 (analyst → architect análogo a analyst → writer) |
  | Sin Early Eval entre analyst y architect | El design_analysis_report.md se verifica estructuralmente via LL-13 (Pending Verification), no con rúbrica completa |
  | ADJ-13 integrado desde el inicio | Demo Statements escritos en orchestration_plan antes de spawear; Workers hacen self-checklist contra el demo statement |
  | ADR-001 como primer artefacto del architect | El stack debe estar decidido antes de producir cualquier otro artefacto de diseño |
  | Sin "gate de stack" pre-Sprint Contract | Las restricciones tecnológicas son inputs ya capturados (scope_boundaries.md); la selección de stack ocurre dentro de la ejecución |
  | Guía de Vertical Slices en test_strategy_map.md | El 030 identifica las fronteras naturales de slicing para que el 040 Planning trabaje con coherencia arquitectónica |

- **IDs definidos para los artefactos del 030:**
  - design_analysis_report: CO-xx, IF-xx, PT-xx, RT-xx
  - technical_blueprint: MOD-xx
  - contract_definitions: IC-xx, DTO-xx
  - dependency_graph: DEP-xx
  - architecture_decision_records: ADR-xx
  - test_strategy_map: TS-xx

**Archivos creados:**
```
plans/030_design_harness.md   (nuevo — blueprint completo del 030)
support/avance.md             (este archivo)
```

---

### Sesión 39 — 2026-06-01

**Objetivo de la sesión:**
Implementar los 5 ADJs pendientes identificados en test_specification_003 (ADJ-20/21/22/23/24) antes de construir el 030 Design Harness.

**Trabajo realizado:**

- **ADJ-20 — IMPLEMENTADO:** En `discovery-governor.md` E10-A Paso 2: reemplazado `mkdir -p` con loop PowerShell que usa `Test-Path`/`New-Item` individualmente, más verificación post-creación. En E10-A Paso 4: verificación de `.git/` post `git init` con bloqueo duro si `.git/` no existe. En `specification-governor.md` E10-A Paso 2: mismo patrón para `specification/`. Añadidos `"Bash(New-Item *)"` y `"Bash(Test-Path *)"` a `templates/client-project-settings.json`.

- **ADJ-21 — IMPLEMENTADO:** Verificado que `templates/client-project-settings.json` ya contenía `"Write(*)"` en el allow list. El fix estaba presente desde antes; marcado como implementado.

- **ADJ-22 — IMPLEMENTADO:** Agregado Paso 3 explícito en la sección Cierre de `discovery-governor.md` con instrucción de capturar 4 categorías en `decisions_library.md`: resoluciones de contradicciones C-xx, exclusiones negociadas, restricciones de v1, y decisiones de scope con impacto en harnesses posteriores. Instrucción explícita: "NO limitarse a hitos procedimentales".

- **ADJ-23 — IMPLEMENTADO:** En `specification-governor.md` Gate CP-03: añadido registro `[CP-03 020]` en `claude-progress.txt` y bloque IMPORTANTE que fuerza presentar CP-04 como `AskUserQuestion` independiente aunque el CP-03 haya sido aprobado implícitamente.

- **ADJ-24 — IMPLEMENTADO:** Agregada sección "Escritura en claude-progress.txt — Encoding UTF-8 (ADJ-24)" en ambos governors. Regla: usar `Add-Content -Encoding utf8` via Bash para todas las escrituras en `claude-progress.txt`. Añadido `"Bash(Add-Content *)"` a `templates/client-project-settings.json`.

**Archivos modificados:**
```
.claude/agents/discovery-governor.md      (ADJ-20 E10-A Paso 2+4, ADJ-22 Cierre Paso 3, ADJ-24 encoding)
.claude/agents/specification-governor.md  (ADJ-20 E10-A Paso 2, ADJ-23 Gate CP-03, ADJ-24 encoding)
templates/client-project-settings.json   (New-Item, Test-Path, Add-Content añadidos)
support/ajustes.md                        (ADJ-20/21/22/23/24 → IMPLEMENTADO ✅)
support/avance.md                         (este archivo)
```

---

### Sesión 38 — 2026-06-01

**Objetivo de la sesión:**
Completar `test_specification_003` end-to-end: ejecutar el 020 Specification Harness completo
(Sprint Contract → analyst → Early Eval → writer → CP-03 → CP-04 → evaluador → cierre),
revisar el comportamiento del harness y registrar ajustes.

**Trabajo realizado:**

- **020 Specification ejecutado en 2 sesiones:**
  - Primera sesión: Sprint Contract aprobado → specification-analyst (CP-01) → Early Eval E9
    (score 0.95, passed). Sesión interrumpida con writer a medio ejecutar.
  - Segunda sesión: governor detectó archivos parciales, eligió reescribir los 4 artefactos
    completos (Opción A) para garantizar consistencia. specification-writer completó CP-02.

- **Revisión CP-03:** Detectados 3 hallazgos antes de aprobar:
  1. Tabla resumen de `error_exception_policy.md` con IDs desplazados desde EE-08 — corregida.
  2. Acción "cancelar orden" referenciada pero sin AC/EE — declarada explícitamente fuera de scope v1.
  3. `[GLOSARIO: pendiente — Categoría]` en `data_contracts.md` — definido inline.

- **Evaluación 020:** Score **1.0/1.0 APPROVED** — todas las dimensiones en 1.0. Primera evaluación,
  sin re-ejecución. verdict.json actualizado como array acumulativo con 2 entradas (010 + 020).

- **Análisis post-test del 020:**
  - ✅ E10-B desde DEPLOYED detectado correctamente
  - ✅ Gate PENDIENTE distinguió DDs de ítems formales
  - ✅ Early Eval (E9) validado por primera vez en test real
  - ✅ Reanudación post-interrupción mid-writer manejada correctamente (Opción A)
  - ✅ ADJ-14 (AUDIT_PENDING) funcionó en el 020
  - ✅ decisions_library.md mejorado: 6 entradas con resoluciones de DD-01/DD-02/DD-03
  - ⚠️ ADJ-23: CP-03 y CP-04 conflados — mismo timestamp, governor no presentó CP-04 como gate independiente
  - ⚠️ ADJ-24: Encoding corrupto en claude-progress.txt líneas 20-23 (mojibake en eventos del 020)
  - ⚠️ ADJ-22: aplica solo a discovery-governor — 020 governor sí captura decisiones de dominio

- **Recomendaciones del evaluador 020 para el 030:**
  1. Definir cálculo de "stock objetivo" como parámetro configurable
  2. Lógica de estado SIN MOVIMIENTOS (stock_actual=0, stock_minimo=0) en capa de datos
  3. Indexación para vista "Historial de Excepciones" cross-producto

- **ADJ-22, ADJ-23, ADJ-24 registrados** en `support/ajustes.md`.

**Validación final de todos los fixes de Sesión 35:**

| Fix | Resultado final |
|-----|----------------|
| ADJ-14 bloqueo duro — AUDIT_PENDING antes de evaluador | ✅ VALIDADO en 010 y 020 |
| ADJ-15/ADJ-18 — governor spawea workers directamente | ✅ VALIDADO en 010 y 020 |
| ADJ-17 — "APROBADO POR CLIENTE" en shared_understanding.md | ✅ VALIDADO en 010 |
| ADJ-19 — Handoff instruye reinicio en lugar de spawear | ✅ VALIDADO — mensaje correcto, reinicio requerido funcionó |

**test_specification_003 — resultado final:**

| Harness | Score | Evaluaciones | Observaciones |
|---------|-------|-------------|---------------|
| 010 Discovery | 1.0/1.0 APPROVED | 1 (sin re-ejecución) | Primer test limpio end-to-end |
| 020 Specification | 1.0/1.0 APPROVED | 1 (sin re-ejecución) | Early Eval 0.95; reanudación mid-writer exitosa |

**ADJs identificados en esta sesión:**

| ID | Descripción | Estado |
|----|-------------|--------|
| ADJ-22 | discovery-governor omite decisiones de dominio sustantivas en decisions_library.md | PENDIENTE |
| ADJ-23 | CP-03 y CP-04 del 020 conflados — governor no presenta CP-04 como gate independiente | PENDIENTE |
| ADJ-24 | claude-progress.txt con encoding corrupto en eventos del 020 (mojibake) | PENDIENTE |

**Archivos modificados:**
```
support/ajustes.md   (ADJ-22, ADJ-23, ADJ-24 agregados)
support/avance.md    (este archivo)
```

---

### Sesión 37 — 2026-06-01

**Objetivo de la sesión:**
Continuar `test_specification_003` desde CP-01 (010 Discovery). Completar el ciclo del 010
y arrancar el 020 Specification Harness. Esta terminal actuó como terminal de apoyo.

**Trabajo realizado:**

- **010 Discovery completado:** E10-B reanudó desde CP-01. discovery-analyst (CP-02) →
  discovery-synthesizer (CP-03) → revisión de 4 artefactos → CP-04 aprobado → evaluador
  → Score **1.0/1.0 APPROVED**. `[CP-04-UPDATE]` confirmó "APROBADO POR CLIENTE".

- **Revisión CP-03 del 010:** Aprobados con 2 ítems para la especificación (DD-02 criterio
  "datos no conciliados", y acción cancelar orden en B-07). Ninguno bloqueante.

- **Handoff 010 → 020:** Governor preguntó "¿Continuar con 020?". Usuario respondió Sí.
  Deploy ejecutado. Governor instruyó reinicio. **ADJ-19 VALIDADO.**

- **Reinicio de sesión:** Usuario salió con `exit` y relanzó `claude` en el directorio del test.
  CLAUDE.md detectó `handoff_020.status == "DEPLOYED"` y arrancó `specification-governor`.

- **ADJ-22 identificado:** decisions_library.md del 010 tiene solo 2 entradas (hitos formales).
  Las resoluciones de C-01, C-02, C-03 (decisiones de dominio) no fueron capturadas.

**Archivos modificados:**
```
support/ajustes.md   (ADJ-22 agregado)
support/avance.md    (este archivo)
```

---

### Sesión 36 — 2026-06-01

**Objetivo de la sesión:**
Ejecutar `test_specification_003` end-to-end para validar los 4 ajustes arquitectónicos de la
Sesión 35 (ADJ-14/ADJ-15/ADJ-17/ADJ-18/ADJ-19). Esta terminal actuó como terminal de apoyo
(observación y respuesta de preguntas); la ejecución del harness ocurrió en una terminal separada
sobre el directorio `C:\Users\USUARIO\Documents\Triple S\Tests\Test_Specification_003\`.

**Trabajo realizado:**

- **Sprint Contract aprobado:** Sistema de Inventario y Alertas de Stock — Distribuidora Andina
  Ltda. 3 stakeholders: Andrés Mora (almacenista, banco C), Diana Vargas (jefa de compras, banco A),
  Luis Pedraza (gerente general, banco A).

- **ADJ-15/ADJ-18 validado parcialmente:** El governor spawneó `discovery-dialoguer` directamente
  con `subagent_type` correcto. Sin errores de "no puede spawnear sub-agentes". Primer indicador
  positivo del rediseño arquitectónico.

- **Entrevistas completadas:** 3 stakeholders entrevistados con 5-8 rondas cada uno. Las respuestas
  las proporcionó el usuario desde esta terminal de apoyo. Transcript escrito en
  `discovery/dialogue_transcript.md`. Calidad del transcript evaluada como sólida — 3 contradicciones
  detectadas y resueltas (C-01 web responsive, C-02 excepción de despacho autorizado, C-03 valor
  del inventario retirado por Luis). 1 ítem UNRESOLVED de bajo impacto (control de acceso por rol).

- **CP-01 alcanzado y registrado:** `execution-state.json` tiene `last_checkpoint = "CP-01"`,
  `status = "IN_PROGRESS"`. Estado correcto para reanudación.

- **Test pausado en CP-01:** El usuario eligió pausar aquí. La próxima sesión reanudará desde
  discovery-analyst automáticamente (E10-B detectará CP-01 y spawneará el analyst).

- **Problema identificado — ADJ-20:** El governor reportó E10-A completo pero no creó `eval/`,
  `knowledge/`, `changes/` ni inicializó git. El `mkdir -p` no se ejecutó (o falló silenciosamente).
  Las carpetas `discovery/` y `persistence/` existen solo porque `Write` las creó como efecto
  secundario. El usuario creó las carpetas faltantes y ejecutó `git init` manualmente.

- **ADJ-20 registrado** en `support/ajustes.md`: governor debe verificar existencia de carpetas
  post-creación y verificar `.git/` post-init.

- **ADJ-21 registrado** en `support/ajustes.md`: hook de seguridad de Claude Code dispara prompt
  "Newline followed by # inside a quoted argument" en cada Write de sección markdown — interrumpe
  el flujo del analyst y otros workers. Fix: regla de permiso en `client-project-settings.json`.

**Estado del directorio del test:**
```
C:\Users\USUARIO\Documents\Triple S\Tests\Test_Specification_003\
├── .claude/                    — agentes y skills del 010 (deployados)
├── discovery/
│   └── dialogue_transcript.md  — CP-01 ✅ (3 stakeholders, COMPLETO)
├── eval/                       — creada manualmente
├── knowledge/                  — creada manualmente
├── changes/                    — creada manualmente
├── persistence/
│   ├── harness-state.json      — status: ACTIVE, sprint contract aprobado
│   ├── execution-state.json    — last_checkpoint: CP-01, status: IN_PROGRESS
│   └── claude-progress.txt     — 4 eventos registrados hasta CP-01
├── inputs/
│   └── brief.md
├── CLAUDE.md
└── .git/                       — inicializado manualmente
```

**ADJs identificados en esta sesión:**

| ID | Descripción | Estado |
|----|-------------|--------|
| ADJ-20 | Governor no verifica que Bash creó carpetas y git | PENDIENTE |
| ADJ-21 | Prompt de seguridad por `#` en markdown interrumpe workers | PENDIENTE |

**Validación de los fixes de Sesión 35 (estado parcial):**

| Fix | Resultado hasta CP-01 |
|-----|----------------------|
| ADJ-15/ADJ-18 — Governor spawea workers directamente | ✅ VALIDADO — dialoguer spawneado correctamente |
| ADJ-14 — Bloqueo duro en Cierre | ⏳ Pendiente — se validará al llegar al Cierre |
| ADJ-17 — Governor actualiza shared_understanding.md post-CP-04 | ⏳ Pendiente — se validará en CP-04 |
| ADJ-19 — Handoff instruye reinicio | ⏳ Pendiente — se validará en el Handoff al 020 |

**Archivos modificados:**
```
support/ajustes.md   (ADJ-20, ADJ-21 agregados)
support/avance.md    (este archivo)
```

---

### Sesión 35 — 2026-06-01

**Objetivo de la sesión:**
Resolver la limitación de plataforma confirmada en la Sesión 34: sub-agentes no pueden
spawear más sub-agentes (`Agent` tool bloqueado). Implementar los 4 fixes arquitectónicos
pendientes: ADJ-14, ADJ-17, ADJ-18/ADJ-15, ADJ-19.

**Análisis previo a la implementación:**
Lectura de la documentación oficial de Claude Code (`https://code.claude.com/docs/en/sub-agents`)
confirmó que la limitación es de diseño de la plataforma, no configurable. El link que falla
es `orchestrator → workers` (governor → orchestrator funciona correctamente).

**Trabajo realizado:**

- **discovery-orchestrator.md — reescrito completo:**
  Eliminado `Agent` tool. Eliminado `agents:` section. Nuevo modelo de dos modos:
  - `[MODO: PLAN]`: lee Sprint Contract, escribe orchestration_plan, retorna PLAN_RESULT al governor
  - `[MODO: CHECKPOINT-{01|02|03}]`: recibe paths del governor, escribe checkpoint en execution-state.json, retorna CHECKPOINT_OK/FAILED
  - `[MODO: WORKER_FAILED]`: registra fallo en execution-state.json

- **specification-orchestrator.md — reescrito completo:**
  Igual que discovery-orchestrator más modo `[MODO: EARLY_EVAL]` para persistir el resultado
  del Early Eval que el governor obtiene directamente del specification-evaluator.

- **discovery-governor.md — secciones modificadas:**
  - Frontmatter: agregado `Edit` tool; agregados todos los workers en `agents:`
  - `Regla: nunca escribir el transcript`: actualizado para re-spawear dialoguer directamente
  - `Ejecución Técnica`: reescrita completamente. Governor obtiene plan del orchestrator (PLAN),
    luego spawea cada worker directamente, luego llama orchestrator (CHECKPOINT) tras cada worker
  - `Gate CP-04`: agregado paso de editar `shared_understanding.md` (ADJ-17)
  - `Cierre PRECONDICIÓN`: reemplazada por bloqueo duro como primer tool call (ADJ-14)
  - `Handoff`: reemplazado spawn directo por instrucción de reinicio (ADJ-19)

- **specification-governor.md — secciones modificadas:**
  - Frontmatter: agregados todos los workers en `agents:`
  - `Ejecución Técnica`: reescrita. Governor obtiene plan, spawea analyst directamente,
    obtiene Early Eval del evaluador, llama orchestrator (EARLY_EVAL), spawea writer, registra CP-02
  - `Cierre PRECONDICIÓN`: bloqueo duro (ADJ-14)
  - `Handoff`: reinicio obligatorio (ADJ-19)

**Decisiones tomadas:**

| Decisión | Detalle |
|----------|---------|
| Orchestrator multi-spawn | El orchestrator se spawea múltiples veces: una para PLAN y una por cada checkpoint. Mantiene Single Writer Rule sobre execution-state.json |
| Early Eval se maneja en el governor | El governor spawea el evaluador directamente en modo Early Eval y luego llama al orchestrator en modo EARLY_EVAL para persistir el resultado |
| Edit agregado al governor | Necesario para que discovery-governor pueda editar shared_understanding.md post-CP-04 |

**Archivos modificados:**
```
.claude/agents/discovery-orchestrator.md      (reescrito — sin Agent, modos PLAN/CHECKPOINT)
.claude/agents/specification-orchestrator.md  (reescrito — sin Agent, modos PLAN/CHECKPOINT/EARLY_EVAL)
.claude/agents/discovery-governor.md          (Ejecución Técnica + ADJ-14 + ADJ-17 + ADJ-19)
.claude/agents/specification-governor.md      (Ejecución Técnica + ADJ-14 + ADJ-19)
support/ajustes.md                            (ADJ-14/15/17/18/19 → IMPLEMENTADO)
support/avance.md                             (este archivo)
```

---

### Sesión 34 — 2026-06-01

**Objetivo de la sesión:**
Ejecutar `test_specification_002` end-to-end (010 Discovery + handoff + 020 Specification)
para validar los 4 fixes de la Sesión 33 (ADJ-14, ADJ-15, ADJ-16, ADJ-17).

**Trabajo realizado:**

- **010 Discovery ejecutado:** 3 stakeholders entrevistados (Ana coordinadora, Carlos empleado,
  Laura gerente). Sistema de reservas de salas de reunión (25 personas, 3 salas).
  5 issues de aclaración resueltos (PA-01 a PA-05). 4 artefactos producidos en `discovery/`.

- **Evaluación 010:** `eval/` vacía al finalizar — governor no spawneó el evaluador.
  Evaluación invocada manualmente. Score no reportado en esta sesión.

- **Handoff 010 → 020:** Deploy ejecutado automáticamente. Al intentar spawear
  `specification-governor` inmediatamente, error: agente no reconocido. Reinicio de sesión
  requerido para que Claude Code cargara los nuevos agentes.

- **020 Specification ejecutado:** specification-analyst → specification-writer completados.
  3 ítems PENDIENTE del Discovery resueltos antes del Sprint Contract.
  4 artefactos producidos: 19 escenarios BDD, 7 entidades, 23 AC, 9 políticas de error.

- **Evaluación 020:** Score **1.0 / APPROVED** — todas las dimensiones en 1.0.
  Commit: `2c3ca58 — docs(020-specification): phase complete`.

**Resultados de validación de los 4 fixes:**

| Fix | Resultado |
|-----|-----------|
| ADJ-17 — "APROBADO POR CLIENTE" | ✅ VALIDADO — D5 = 1.0, sin penalización |
| ADJ-16 — No crear orchestrator-prompt.txt | ✅ VALIDADO — no mencionado durante el test |
| ADJ-14 — Governor spawea evaluador antes de cierre | ❌ REINCIDENTE — eval/ vacía nuevamente |
| ADJ-15 — Agentes invocados con subagent_type | ❌ NO RESUELTO — orchestrator reportó "no puede spawnear sub-agentes" |

**Nuevos ajustes identificados:**

- **ADJ-18:** Orchestrator reporta "no puede spawnear sub-agentes directamente" — limitación
  de plataforma probable: agentes spawneados no pueden a su vez spawear más agentes via
  `Agent` tool. Requiere investigación y posible rediseño arquitectónico.

- **ADJ-19:** Agentes copiados por deploy en medio de sesión no son reconocidos por Claude Code
  — la lista de agentes se carga al iniciar sesión, no dinámicamente. El handoff automático
  diseñado en Sesión 29 requiere reinicio de sesión para funcionar.

**Decisiones tomadas:**

| Decisión | Detalle |
|----------|---------|
| No continuar con 030 aún | ADJ-14, ADJ-18 y ADJ-19 son problemas arquitectónicos que afectarán todos los harnesses futuros. Deben resolverse antes de construir 030 |
| ADJ-14 requiere rediseño | El fix de "AUDIT_PENDING" protege la reanudación pero no previene el salto inicial. La precondición debe ser un bloqueo duro al inicio del Cierre |
| ADJ-18/ADJ-19 podrían ser la misma causa raíz | Si los agentes spawneados no pueden spawear sub-agentes, tanto el orchestrator (ADJ-18) como el governor post-deploy (ADJ-19) fallan por la misma razón estructural |

**Análisis post-test (mismo día):**

Revisión completa de todos los artefactos generados en `Test_Specification_002/`. Hallazgos:
- `claude-progress.txt` confirmó que nunca se escribió `[AUDIT_PENDING]` para el 010 —
  el governor saltó directamente de `[CP-04]` a `[CIERRE]`.
- `verdict.json` con 3 entradas: 010 v1 REJECTED (D5=0.0, evaluador corrió antes de que
  governor actualizara shared_understanding.md), 010 v2 APPROVED (0.96), 020 v1 APPROVED (1.0).
- ADJ-15 reclasificado: limitación de plataforma confirmada (no error de configuración).
- 4 lecciones nuevas agregadas a `lessons_learned.md`: LL-20 (bloqueo duro Cierre),
  LL-21 (sub-agentes no pueden spawear), LL-22 (reinicio requerido post-deploy),
  LL-23 (governor actualiza shared_understanding.md post-CP-04).

**Archivos modificados:**
```
support/ajustes.md         (ADJ-14 → REINCIDENTE; ADJ-15 → LIMITACIÓN PLATAFORMA;
                            ADJ-17 → PARCIAL; ADJ-18, ADJ-19 agregados)
support/lessons_learned.md (LL-20, LL-21, LL-22, LL-23 agregadas)
support/avance.md          (este archivo)
```

---

### Sesión 33 — 2026-06-01

**Objetivo de la sesión:**
Implementar los 4 ajustes identificados en `test_specification_001` (ADJ-14, ADJ-15, ADJ-16, ADJ-17).

**Trabajo realizado:**

- **ADJ-17 — IMPLEMENTADO:** En `discovery-synthesis-schema/SKILL.md`, corregido el template de `shared_understanding.md`: la sección "Aprobación del Cliente" ahora muestra `Estado: [PENDIENTE | APROBADO POR CLIENTE]` (antes decía `APROBADO`). Regla actualizada: "Instance A actualiza a `APROBADO POR CLIENTE`... Esta frase exacta es la que verifica D5 de la rúbrica — no usar variantes."

- **ADJ-14 — IMPLEMENTADO:** En ambos governors (`discovery-governor.md`, `specification-governor.md`):
  - Sección "Auditoría": escribe `status: "AUDIT_PENDING"` en `harness-state.json` ANTES de spawear el evaluador. Registra en `claude-progress.txt` con el evento `[AUDIT_PENDING]`.
  - E10-B Paso 6: nueva VERIFICACIÓN PREVIA antes de la tabla — si `status == "AUDIT_PENDING"` → ir directamente a Auditoría, sin consultar la tabla.

- **ADJ-16 — IMPLEMENTADO:** En ambos governors, sección "Ejecución Técnica": instrucción explícita de construir el prompt inline en el tool call Agent, nunca escribir `persistence/orchestrator-prompt.txt` ni equivalentes (referencia a LL-18).

- **ADJ-15 — IMPLEMENTADO:** Investigación confirmó causa raíz: los orchestrators/governors usaban el nombre del agente solo como texto en el prompt, sin pasar `subagent_type` en el tool call Agent. Fix aplicado en 4 archivos:
  - `discovery-orchestrator.md`: Workers 1, 2, 3 ahora dicen "con `subagent_type: '<nombre>'"
  - `specification-orchestrator.md`: specification-analyst, specification-evaluator (Early Eval), specification-writer
  - `discovery-governor.md`: discovery-orchestrator, discovery-evaluator, specification-governor (handoff)
  - `specification-governor.md`: specification-orchestrator, specification-evaluator

**Decisiones tomadas:**

| Decisión | Detalle |
|----------|---------|
| ADJ-15 fix por Opción A | Causa raíz confirmada: faltaba `subagent_type` en las instrucciones de invocación. Fix quirúrgico en cada "Invocar X" / "Spawear X" de los 4 archivos |
| AUDIT_PENDING solo en harness-state.json | El estado persiste entre sesiones y es la única señal observable que E10-B puede detectar sin depender de la memoria del governor |
| specification-governor no necesita fix de handoff al 030 | La invocación de design-governor no tiene `subagent_type` aún — el 030 no existe todavía; se corregirá cuando se construya |

**Archivos modificados:**
```
.claude/skills/discovery-synthesis-schema/SKILL.md   (ADJ-17: frase exacta "APROBADO POR CLIENTE")
.claude/agents/discovery-governor.md                 (ADJ-14 + ADJ-16 + ADJ-15)
.claude/agents/specification-governor.md             (ADJ-14 + ADJ-16 + ADJ-15)
.claude/agents/discovery-orchestrator.md             (ADJ-15: subagent_type en 3 Workers)
.claude/agents/specification-orchestrator.md         (ADJ-15: subagent_type en 3 invocaciones)
support/ajustes.md                                   (ADJ-14/15/16/17 → IMPLEMENTADO ✅)
support/avance.md                                    (este archivo)
```

---

### Sesión 32 — 2026-05-31

**Objetivo de la sesión:**
Ejecutar `test_specification_001` end-to-end (010 Discovery + handoff + 020 Specification),
observar el comportamiento de los agentes, e identificar ajustes para la siguiente sesión.

**Trabajo realizado:**

- **010 Discovery ejecutado y aprobado:**
  - discovery-governor, orchestrator, dialoguer, analyst, synthesizer corrieron correctamente.
  - 4 artefactos producidos en `discovery/`.
  - Score evaluador: **0.96 / APPROVED** (D5 = 0.8 por "APROBADO" vs "APROBADO POR CLIENTE").
  - Bug confirmado: el governor marcó PHASE_COMPLETE sin spawear el evaluador (ADJ-14). El
    evaluador fue invocado manualmente por el usuario.

- **Handoff 010 → 020 automático:**
  - deploy del 020 ejecutado automáticamente.
  - specification-governor arrancó en la misma sesión.
  - Ítem V-03 (offline) identificado como PENDIENTE y resuelto antes del Sprint Contract.

- **020 Specification ejecutado y aprobado:**
  - specification-analyst produjo `spec_analysis_report.md` (19,765 bytes).
  - Early Eval E9: score 0.88, passed.
  - specification-writer produjo los 4 artefactos con 3 marcadores `[PENDIENTE]`.
  - Governor resolvió 2 ítems con el cliente en CP-03 (SE-09: total=meta → saldo 0; EN-07:
    zona horaria local del dispositivo).
  - specification-evaluator spawneado correctamente (a diferencia del 010).
  - Score evaluador: **1.0 / APPROVED** — perfecto, sin findings.

- **Archivos de estado verificados:**
  - `eval/verdict.json`: array acumulativo con 2 entradas (010 + 020) ✅
  - `knowledge/lessons_learned.md`: 2 ciclos documentados ✅
  - `knowledge/decisions_library.md`: 7 decisiones (D-001 a D-007) ✅

- **4 ajustes nuevos registrados en `ajustes.md`:**
  - **ADJ-14:** Governor del 010 saltó el evaluador — precondición del Cierre no se cumplió.
  - **ADJ-15:** Agentes invocados como propósito general — restricciones de tools no aplicadas.
  - **ADJ-16:** Governor escribió `persistence/orchestrator-prompt.txt` — comportamiento no diseñado.
  - **ADJ-17:** discovery-synthesizer escribe "APROBADO" en lugar de "APROBADO POR CLIENTE" — D5 penalizado.

**Decisiones tomadas:**

| Decisión | Detalle |
|----------|---------|
| ADJ-14 es la prioridad más alta de la próxima sesión | Es el único bug que requirió intervención manual del usuario. El 020 governor no tuvo este problema — investigar diferencia |
| ADJ-17 fix es quirúrgico | Una línea en discovery-synthesis-schema. Alta prioridad porque afecta D5 en todos los proyectos futuros |
| ADJ-15 requiere investigación antes de fix | Necesita entender si es limitación de plataforma o error de invocación en los governors |
| ADJ-16 se recomienda prohibir | El valor de trazabilidad ya lo cubre claude-progress.txt |

**Archivos creados/modificados:**
```
support/ajustes.md    (ADJ-14, ADJ-15, ADJ-16, ADJ-17 agregados)
support/avance.md     (este archivo)
```

---

### Sesión 31 — 2026-05-31

**Objetivo de la sesión:**
Corregir brechas pendientes, analizar y diferir ítems OBS, y preparar todo para ejecutar `test_specification_001`.

**Trabajo realizado:**

- **ADJ-09 (Significativa) — CORREGIDO:** Agregado bloque `## REGLA DE ESCRITURA — Single Writer Rule` en `specification-governor.md`, entre la sección de skills y "Precondición absoluta". El governor NUNCA escribe en `/specification/`.

- **ADJ-10 (Menor) — CORREGIDO:** Agregada instrucción de fallback en E10-A Paso 3 de `specification-governor.md`: si el parse de `harness-state.json` falla → `git restore` → re-leer → si persiste, detener y reportar.

- **ADJ-11 (Menor) — CORREGIDO:** Actualizado paso 1 de D1 en `specification-evaluator.md`: búsqueda flexible de sección con "Actor" en el título. Si no se encuentra, advertencia en `findings` y fallback a tabla de resumen de `bdd_features.md`.

- **OBS-01 a OBS-04 — DIFERIDOS:** Análisis confirmó que los mecanismos actuales (`claude-progress.txt`, `verdict.json`, `metrics_summary.json`, Early Eval, auto-verificación de workers) ya cubren los pilares de observabilidad y verificación. No hay evidencia de gap real hasta correr tests. Marcados `DIFERIDO ⏸` en `ajustes.md`.

- **Directorio de test creado:** `C:\Users\USUARIO\Documents\Triple S\Tests\Test_Specification_001\`

- **`inputs/brief.md` creado** para el test. Stakeholder: **Sofía Martínez** (usuaria única, 29 años, control de alimentación diaria). Dominio: contador de calorías web. El brief cubre las 4 condiciones del Criterio de Done del dialoguer desde el arranque, minimizando rondas de preguntas. Contenido:
  - Plataforma: aplicación web
  - Vista principal: pantalla única (meta / consumido / restante / lista de comidas / formulario)
  - 4 funcionalidades: registrar comida, ver total, configurar meta, ver restante/exceso
  - 10 exclusiones explícitas: sin auth/login, sin historial, sin informes, sin edición de comidas, sin ejercicio, sin multi-usuario, sin notificaciones, sin desglose nutricional, sin DB de alimentos, sin sincronización
  - 6 comportamientos ante fallos: sin meta configurada, valor negativo/cero, sin comidas, reseteo medianoche, cierre/reapertura, borrado de comida

**Decisiones tomadas:**

| Decisión | Detalle |
|----------|---------|
| OBS-01/02/03/04 diferidos | Sin evidencia de gap real en mecanismos actuales. Reactivar si los tests revelan problemas concretos de observabilidad o verificación |
| brief.md maximiza cobertura del Criterio de Done | El dialoguer leerá los inputs y adaptará preguntas; con el brief completo las rondas serán de validación, no de descubrimiento |
| Stakeholder: Sofía Martínez | Dominio trivial (1 stakeholder, 4 features, sin auth) para prueba end-to-end limpia |

**Archivos creados/modificados:**
```
.claude/agents/specification-governor.md              (ADJ-09 + ADJ-10)
.claude/agents/specification-evaluator.md             (ADJ-11)
support/ajustes.md                                    (ADJ-09/10/11 → IMPLEMENTADO; OBS-01/02/03/04 → DIFERIDO)
Tests/Test_Specification_001/inputs/brief.md          (nuevo — brief completo de Sofía Martínez)
support/avance.md                                     (este archivo)
```

---

### Sesión 30 — 2026-05-29

**Objetivo de la sesión:**
Analizar el archivo `support/history/ajustes_discovery.md` para extraer los aprendizajes
universales que dejaron las pruebas del 010, verificar cuáles se aplicaron correctamente
en el 020, identificar brechas restantes, y documentar todo para que harnesses futuros no
repitan los mismos errores.

**Trabajo realizado:**

- **Análisis sistemático de `support/history/ajustes_discovery.md`** — Revisión de los
  31 ítems IMP-xx del 010. Se identificaron 15 patrones de fallo con su causa raíz, el
  fix aplicado en el 010 y su estado en el 020.

- **Contraste con los 5 agentes del 020** — Lectura directa de
  `specification-governor.md`, `specification-orchestrator.md`, `specification-evaluator.md`,
  `specification-analyst.md` y `specification-writer.md`. Resultado: 10 de 11 patrones
  del 010 fueron correctamente aplicados al construir el 020. 1 parcialmente aplicado.

- **`support/lessons_learned.md` creado** — 15 lecciones universales (LL-01 a LL-15)
  documentadas con: regla prescriptiva, causa raíz del error original, cómo implementar,
  y origen (número de IMP). Estas lecciones aplican a la construcción de cualquier harness,
  no solo el 010 o el 020.

- **3 brechas nuevas identificadas y registradas en `support/ajustes.md`:**
  - **ADJ-09 (Gap K — Significativa):** `specification-governor.md` no tiene regla explícita
    "NUNCA escribir en `/specification/`". El orchestrator sí la tiene (sección REGLAS DE
    ESCRITURA). El governor necesita el mismo bloqueo.
  - **ADJ-10 (Gap N2 — Menor):** Si `harness-state.json` está malformado cuando el governor
    del 020 intenta leerlo, el parse falla y podría sobreescribir el estado del 010. No hay
    instrucción de fallback ni de backup antes de modificar.
  - **ADJ-11 (Gap N3 — Menor):** El evaluador del 020 asume que `shared_understanding.md`
    tiene una sección "Actores y sus Necesidades". Si el 010 la nombró diferente, el evaluador
    no encuentra los actores y penaliza D1 sin evidencia real.

**Patrones 010 confirmados como correctamente aplicados en el 020:**

| Patrón | Descripción | Estado |
|--------|-------------|--------|
| A | Write obligatorio antes de reportar (Workers) | ✅ |
| B | REGLAS DE ESCRITURA en orchestrator | ✅ |
| C | PATHS DE SALIDA en evaluador | ✅ |
| D | Precondición de auditoría en Cierre del governor | ✅ |
| E | Timestamps reales en governor y orchestrator | ✅ |
| F | Protocolo de 5 pasos para checkpoints | ✅ |
| G | Ambigüedad de creación de execution-state.json | ✅ |
| H | Inputs persistidos como null en orchestration_plan | ✅ |
| I | Evaluador con sesgo negativo / protocolo dos fases | ✅ |
| J | Worker retornando prematuramente sin completar tarea | ✅ |
| K | Single Writer Rule en governor | ⚠️ Parcial (ADJ-09) |

**Decisiones tomadas:**

| Decisión | Detalle |
|----------|---------|
| Crear lessons_learned.md en support/ | Documento persistente de lecciones universales. No es un artefacto de proyecto cliente — es conocimiento de construcción del sistema de harnesses |
| ADJ-09 es Significativa, no Menor | El governor tiene Write y AskUserQuestion; el riesgo de escribir en /specification/ durante CP-03 es real, no teórico |
| ADJ-10 y ADJ-11 son Menores | Son casos de borde poco probables en condiciones normales de ejecución |

**Archivos creados/modificados:**
```
support/lessons_learned.md    (nuevo — 15 lecciones universales LL-01 a LL-15)
support/ajustes.md             (3 ítems nuevos: ADJ-09, ADJ-10, ADJ-11)
support/avance.md              (este archivo)
```

---

### Sesión 29 — 2026-05-29

**Objetivo de la sesión:**
Automatizar el handoff entre harnesses: cuando un governor termina, pregunta al humano si
desea continuar con el siguiente harness, y si dice sí, ejecuta el deploy y spawea el siguiente
governor sin intervención humana adicional.

**Trabajo realizado:**

- **`deploy-harness.ps1` actualizado** — Inyecta su propio path (`$PSCommandPath`) en la clave
  `env.HARNESS_DEPLOY_SCRIPT` del `settings.json` del proyecto cliente en cada deploy. Si la
  clave `env` no existe en settings.json, la crea. Esto permite a los governors encontrar el
  script en tiempo de ejecución sin hardcodear rutas.

- **`templates/client-project-CLAUDE.md` actualizado** — Lógica extendida con estado
  `PENDING_HANDOFF` y `DEPLOYED`. Ahora maneja 3 casos cuando 010 está PHASE_COMPLETE y
  020 no existe: (1) PENDING_HANDOFF → pregunta al humano y ejecuta deploy+spawn si acepta,
  (2) DEPLOYED → specification-governor fue interrumpido después del deploy, spawearlo directamente,
  (3) sin handoff_020 → discovery-governor fue interrumpido antes del cierre, reinvocarlo.
  Mismo patrón añadido para el handoff 020 → 030.

- **`discovery-governor.md` actualizado** — Sección "Handoff al 020" agregada después del
  commit de cierre. Si humano dice SÍ: registra status DEPLOYED, ejecuta deploy vía Bash con
  `$env:HARNESS_DEPLOY_SCRIPT`, spawea specification-governor. Si humano dice NO: registra
  status PENDING_HANDOFF. En ambos casos escribe en claude-progress.txt.

- **`specification-governor.md` actualizado** — Mismo patrón para handoff al 030. Si humano
  dice SÍ: deploy + spawn design-governor. Si no: PENDING_HANDOFF.

**Flujo resultante (camino feliz):**
```
deploy 010 → Claude Code → discovery-governor → ... → PHASE_COMPLETE
→ "¿Continuar con 020?" → Sí
→ deploy 020 (automático) → specification-governor → ... → PHASE_COMPLETE
→ "¿Continuar con 030?" → Sí
→ deploy 030 (automático) → design-governor → ...
```

**Flujo diferido (humano dice NO):**
```
→ PENDING_HANDOFF registrado en harness-state.json
→ Próxima sesión: CLAUDE.md detecta PENDING_HANDOFF → pregunta → continúa
```

**Decisiones tomadas:**

| Decisión | Detalle |
|----------|---------|
| HARNESS_DEPLOY_SCRIPT se inyecta en cada deploy | No solo en el primero; así si el directorio de Harness_Definition cambia, re-deployar actualiza la ruta |
| Dos estados: PENDING_HANDOFF y DEPLOYED | PENDING_HANDOFF = humano dijo no. DEPLOYED = deploy ejecutado, governor en camino. CLAUDE.md los trata distinto para manejar interrupciones |
| El governor spawea el siguiente directamente | Evita que el humano tenga que abrir nueva sesión. Claude Code carga agentes dinámicamente, no solo al inicio |

**Archivos modificados:**
```
deploy-harness.ps1                           (inyecta HARNESS_DEPLOY_SCRIPT en settings.json)
templates/client-project-CLAUDE.md           (lógica PENDING_HANDOFF + DEPLOYED)
.claude/agents/discovery-governor.md         (sección Handoff al 020)
.claude/agents/specification-governor.md     (sección Handoff al 030)
support/avance.md                            (este archivo)
```

---

### Sesión 28 — 2026-05-29

**Objetivo de la sesión:**
Corregir el gap de diseño en `eval/verdict.json` y `eval/metrics_summary.json`: en lugar de
sobreescribir el archivo al pasar de un harness al siguiente, ambos archivos son ahora arrays
acumulativos — cada evaluación agrega una entrada nueva al final sin borrar las anteriores.

**Trabajo realizado:**

- **`discovery-verdict-schema` actualizado** — verdict.json pasa de objeto a array JSON. Cada
  entrada tiene campo `"phase": "010_discovery"` para identificar el harness. `evaluation_version`
  se calcula contando entradas existentes con el mismo phase. "Orden de escritura" actualizado a
  patrón Read→append→Write para ambos archivos.

- **`specification-verdict-schema` actualizado** — Mismo cambio. Cada entrada del 020 tiene
  `"phase": "020_specification"`. Orden de escritura actualizado a Read→append→Write.

- **`discovery-evaluator.md` actualizado** — Sección "Al terminar" reemplaza el Write directo por
  el patrón de append: leer array existente (o `[]` si no existe), contar entradas del phase para
  determinar evaluation_version, agregar nueva entrada, escribir array completo.

- **`specification-evaluator.md` actualizado** — Mismo cambio para el 020.

- **`discovery-governor.md` actualizado** — Sección "Decisión Final": ahora lee el array y filtra
  por `"phase": "010_discovery"` tomando la última entrada. Sección "Cierre — Precondición":
  verifica que existe al menos una entrada con `"phase": "010_discovery"`.

- **`specification-governor.md` actualizado** — Mismo cambio para `"phase": "020_specification"`.

**Decisión tomada:**

| Decisión | Detalle |
|----------|---------|
| Array acumulativo en vez de rutas separadas | Un solo archivo por tipo (verdict.json, metrics_summary.json) con toda la historia. El governor filtra por phase para leer su propio veredicto. Más simple que subdirectorios por harness. |

**Archivos modificados:**
```
.claude/skills/discovery-verdict-schema/SKILL.md      (array acumulativo + orden de escritura)
.claude/skills/specification-verdict-schema/SKILL.md   (array acumulativo + orden de escritura)
.claude/agents/discovery-evaluator.md                  (Al terminar: Read→append→Write)
.claude/agents/specification-evaluator.md              (Al terminar: Read→append→Write)
.claude/agents/discovery-governor.md                   (Decisión Final: filtrar por phase)
.claude/agents/specification-governor.md               (Decisión Final: filtrar por phase)
support/avance.md                                      (este archivo)
```

---

### Sesión 27 — 2026-05-29

**Objetivo de la sesión:**
Auditar el `specification-orchestrator.md`, crear `specification-governor.md` (Instancia A del 020)
y actualizar la infraestructura compartida (`client-project-CLAUDE.md` Opción B y `deploy-harness.ps1`).

**Trabajo realizado:**

- **Auditoría de `specification-orchestrator.md`** — Comparado con discovery-orchestrator (288 vs 212
  líneas). Diferencia justificada: Early Eval inline (42 líneas de lógica procedural, no reutilizable)
  + patrones CP más verbosos ya cubiertos por specification-state-schema. **Conclusión: no requiere
  extracción de skills.** Ninguna sección cumple el criterio "protocolo puro + satura el agente".

- **`.claude/agents/specification-governor.md` creado** — Instancia A del 020 (354 líneas).
  Estructura análoga a discovery-governor con las siguientes adaptaciones:
  - Precondición absoluta: verifica `harness-state.json["status"] == "PHASE_COMPLETE"` (010 completo)
    antes de cualquier otra acción.
  - Modo detection: busca clave `"020_specification"` en harness-state.json (no el archivo completo).
  - E10-A: crea solo `/specification/`; agrega clave `"020_specification"` al JSON existente sin
    modificar campos raíz del 010; inicializa execution-state.json para el 020.
  - E10-B: tabla de selección basada en `020_specification.status` + `last_checkpoint` de
    execution-state.json.
  - Gate de ítems PENDIENTE: lee `discovery/failure_behavior.md`, extrae todos los `[PENDIENTE]`,
    pregunta al cliente via AskUserQuestion, registra resoluciones en harness-state.json antes de
    proponer el Sprint Contract.
  - Sprint Contract template para 020 (2 workers, 4 artefactos en /specification/).
  - Cierre: actualiza tanto `lessons_learned.md` como `decisions_library.md`.
  - Skills declaradas: `specification-state-schema` + `discovery-knowledge-schema`.

- **`templates/client-project-CLAUDE.md` actualizado a Opción B** — Lógica multi-harness:
  detecta automáticamente qué governor invocar según la primera fase sin `PHASE_COMPLETE` en
  harness-state.json. Patrón en cascada: discovery-governor → specification-governor → notificar.

- **`deploy-harness.ps1` actualizado** — CLAUDE.md ahora se sobreescribe siempre (no "solo si
  no existe"). settings.json mantiene el comportamiento anterior (skip si ya existe). Razón: el
  template de CLAUDE.md evoluciona con cada harness desplegado (Opción A → Opción B).

**Decisiones tomadas:**

| Decisión | Detalle |
|----------|---------|
| specification-orchestrator no requiere skills | 288 líneas justificadas — Early Eval es lógica procedural de orquestación, no protocolo puro reutilizable |
| Governor inicializa con status PENDING_CONTRACT | Necesario para que E10-B pueda distinguir "Sprint Contract no aprobado aún" de "ejecutando" |
| deploy-harness.ps1 sobreescribe CLAUDE.md siempre | El template evoluciona; el cliente no personaliza este archivo (es infraestructura pura) |
| Opción B detecta governor por primera fase sin PHASE_COMPLETE | Patrón en cascada: cualquier harness futuro solo requiere agregar una condición a la lógica |

**Archivos creados/modificados:**
```
.claude/agents/specification-governor.md     (nuevo — Instancia A del 020)
templates/client-project-CLAUDE.md           (actualizado — Opción B multi-harness)
deploy-harness.ps1                           (actualizado — CLAUDE.md siempre sobreescrito)
support/avance.md                            (este archivo)
```

---

### Sesión 26 — 2026-05-29

**Objetivo de la sesión:**
Crear `specification-orchestrator.md` (Instancia B del 020) y la skill `specification-state-schema`.

**Trabajo realizado:**

- **`.claude/skills/specification-state-schema/SKILL.md` creada** — Schema de los dos archivos de
  estado del 020. Define la extensión multi-harness de `harness-state.json`: el governor del 020
  agrega/actualiza la clave `"020_specification"` sin tocar los campos raíz del 010. Define el
  `execution-state.json` del 020 con 2 checkpoints (CP-01 tras analyst, CP-02 tras writer), campo
  `early_eval` (escrito por B después de recibir resultado de C inline), y `artifacts` con los 4
  paths de `/specification/`. Single Writer Rule: governor escribe harness-state, orchestrator
  escribe execution-state, ningún Worker escribe ninguno.

- **`.claude/agents/specification-orchestrator.md` creado** — Instancia B del 020. Coordina 2
  Workers en lugar de 3 (no hay dialoguer). Flujo: Paso 1 lee Sprint Contract (clave
  `"020_specification"` en harness-state), Paso 2 contexto de aprendizaje, Paso 3 checkpoint
  reanudación, Paso 4 persiste orchestration_plan (E12 obligatorio). Coordina:
  specification-analyst → Early Eval (E9) → specification-writer. Comportamiento especial:
  si analyst retorna REQUIERE_ACLARACIÓN → escala a A inmediatamente sin continuar. Early Eval:
  spawea C con instrucción de retornar score inline (sin escribir archivos), B escribe el resultado
  en `early_eval` de execution-state.json. Mantiene Single Writer Rule sobre execution-state.json.

**Decisiones tomadas:**

| Decisión | Detalle |
|----------|---------|
| harness-state.json usa clave "020_specification" | Extensión backward-compatible: campos raíz del 010 intactos, governor del 020 agrega su propia clave de primer nivel |
| Early Eval: C retorna inline, B escribe | Mantiene la Single Writer Rule sobre execution-state.json. C no necesita Write para Early Eval |
| REQUIERE_ACLARACIÓN bloquea antes de CP-01 | Si analyst encuentra PENDIENTE sin resolver, no se registra CP-01 — el estado queda limpio para una re-ejecución tras resolución del governor |

**Archivos creados/modificados:**
```
.claude/skills/specification-state-schema/SKILL.md  (nueva — schema harness-state + execution-state del 020)
.claude/agents/specification-orchestrator.md        (nuevo — Instancia B del 020)
support/avance.md                                   (este archivo)
```

---

### Sesión 25 — 2026-05-29

**Objetivo de la sesión:**
Corregir dos gaps de diseño detectados en el writer: (1) ausencia de protocolo de transformación
y consistencia cruzada, (2) evaluador sin verificación independiente de actores del 010.

**Trabajo realizado:**

- **`.claude/skills/specification-writer-protocol/SKILL.md` creada** — Protocolo de producción
  del specification-writer. Contiene: reglas de transformación por artefacto (CF-xx → SC-xx,
  CB-xx → SE-xx, EN-xx → data contract, EE-xx → EP-xx) y checklist de consistencia cruzada
  de 5 categorías (bdd↔ac, bdd↔data_contracts, error_policy↔analysis_report, AC interno,
  lenguaje↔glosario). Corrección del gap 1.

- **`.claude/agents/specification-writer.md` actualizado** — Agrega `specification-writer-protocol`
  como tercera skill declarada. El agente ahora carga las reglas de transformación explícitamente
  y ejecuta dos checklists secuenciales al terminar: cobertura (synthesis-schema) + consistencia
  cruzada (writer-protocol).

- **`.claude/skills/specification-rubric/SKILL.md` creada** — Rúbrica del 020 con 5 dimensiones,
  anclas calibradas 0.2/0.5/0.8/1.0 con ejemplos del dominio clínica médica, regla de gate ≥0.75
  y regla de veto D5=0.0 (consistencia) con definición explícita de qué activa el veto vs. qué no.

- **`.claude/skills/specification-verdict-schema/SKILL.md` creada** — Schema de verdict.json y
  metrics_summary.json del 020. Agrega campo `reference_artifacts_read` en verdict.json para
  registrar que C leyó shared_understanding.md del 010. Métricas Tipo 1 incluyen conteo
  de actores del 010 vs. actores cubiertos en BDD y conteo de marcadores [PENDIENTE]/[GLOSARIO].

- **`.claude/agents/specification-evaluator.md` creado** — Instancia C del 020. Corrección del
  gap 2: el evaluador lee explícitamente `discovery/shared_understanding.md` para verificar D1
  de forma independiente (extrae actores del 010 y los cruza con bdd_features.md, sin confiar
  en la tabla de resumen self-reported del writer). También verifica D3 y D5 con validaciones
  cruzadas de IDs entre artefactos.

**Decisiones tomadas:**

| Decisión | Detalle |
|----------|---------|
| Protocolo del writer sí justifica skill separada | La transformación CF→BDD y la checklist cruzada son lógica de 5 categorías distintas — análogo al analyst-protocol. El writer sin estas reglas produce artefactos válidos en formato pero con referencias rotas |
| Evaluador lee discovery/shared_understanding.md | D1 requiere verificación independiente. Si C solo lee bdd_features.md auto-reportado por el writer, D1 no es auditoría. C ahora extrae actores directamente del 010 |
| Veto en D5 = contradicción silenciosa | Una inconsistencia documentada (marcada con [PENDIENTE] o nota) no activa veto. Solo la contradicción que el writer dejó pasar sin registrarla |
| verdict.json agrega campo reference_artifacts_read | Registro de qué leyó C fuera de /specification/ — trazabilidad de la auditoría |

**Archivos creados/modificados:**
```
.claude/skills/specification-writer-protocol/SKILL.md  (nueva — transformación + consistencia cruzada)
.claude/agents/specification-writer.md                 (actualizado — +1 skill, 2 checklists secuenciales)
.claude/skills/specification-rubric/SKILL.md           (nueva — rúbrica D1-D5 con anclas y veto)
.claude/skills/specification-verdict-schema/SKILL.md   (nueva — schema verdict + metrics del 020)
.claude/agents/specification-evaluator.md              (nuevo — Instancia C con D1 independiente)
support/avance.md                                      (este archivo)
```

---

### Sesión 24 — 2026-05-29

**Objetivo de la sesión:**
Crear `specification-writer.md` (Worker 2 del 020) y `specification-synthesis-schema` (skill de soporte).

**Trabajo realizado:**

- **`.claude/skills/specification-synthesis-schema/SKILL.md` creada** — Schema de los 4 artefactos
  finales del 020. Define formato exacto de `bdd_features.md` (SC-xx, SE-xx), `data_contracts.md`
  (RN-xx, relaciones RE-xx), `acceptance_criteria.md` (ACP-xx + tabla de trazabilidad inversa) y
  `error_exception_policy.md` (EP-xx). Incluye checklist de cobertura de 10 condiciones para que
  specification-writer verifique antes de reportar. Análogo a `discovery-synthesis-schema` del 010.

- **`.claude/agents/specification-writer.md` creado** — Worker 2 del 020 (59 líneas). Lee
  `spec_analysis_report.md` + `domain_glossary.md` + `scope_boundaries.md`. Produce los 4
  artefactos en orden estricto: bdd_features → data_contracts → acceptance_criteria →
  error_exception_policy. Regla de lenguaje: usar solo términos del glosario o marcar con
  `[GLOSARIO: pendiente]`. Declara 2 skills: `specification-analysis-schema` y
  `specification-synthesis-schema`. Herramientas: `Read`, `Write`, `Edit`.

**Decisiones tomadas:**

| Decisión | Detalle |
|----------|---------|
| No extraer skill de protocolo para el writer | El protocolo del writer es más simple que el del analyst (no hay 7 categorías de extracción). El orden de producción y las reglas caben en el agente sin saturarlo |
| Orden de producción: BDD → Data → AC → Policy | bdd_features primero porque genera los IDs SC-xx/SE-xx que los demás artefactos referencian para trazabilidad |
| Marcador [GLOSARIO: pendiente] | Si un término necesario no está en domain_glossary.md, el writer lo marca en lugar de inventar sinónimos; visible para el governor en revisión CP-03 |
| Marcador [PENDIENTE] para información faltante | Si el analysis_report no provee suficiente información para un campo, el writer lo marca en lugar de inventar completitud |

**Archivos creados/modificados:**
```
.claude/skills/specification-synthesis-schema/SKILL.md  (nueva — schema de los 4 artefactos finales)
.claude/agents/specification-writer.md                  (nuevo — Worker 2 del 020)
support/avance.md                                       (este archivo)
```

---

### Sesión 23 — 2026-05-29

**Objetivo de la sesión:**
Refactorizar `specification-analyst.md` extrayendo el protocolo analítico a una skill dedicada.

**Trabajo realizado:**

- **`.claude/skills/specification-analyst-protocol/SKILL.md` creada** — Protocolo analítico
  del specification-analyst. Contiene las 7 categorías de extracción con sus reglas y fuentes,
  la regla de no-inferencia absoluta, el criterio de done (checklist de 6 condiciones) y el
  límite de 3 iteraciones. Análogo a `discovery-interview-protocol` del 010.

- **`.claude/agents/specification-analyst.md` refactorizado** — Reducido de 128 a 78 líneas.
  Ahora declara 2 skills en el frontmatter: `specification-analysis-schema` (formato de salida)
  y `specification-analyst-protocol` (protocolo de análisis). El agente retiene solo: startup
  procedimental, comportamiento especial de PENDIENTE (riesgo alto — no extraer), obligación
  de escribir antes de reportar, y plantillas de reporte a B.

**Decisiones tomadas:**

| Decisión | Detalle |
|----------|---------|
| Comportamiento especial PENDIENTE se queda en el agente | Es el punto de mayor riesgo operacional; debe tener máxima visibilidad en el cuerpo del agente |
| Protocolo analítico va a skill | Las 7 categorías son protocolo puro, reutilizable si el orchestrator necesita entender qué hace el analyst |
| Edit agregado a las herramientas del agente | Necesario para actualizar el reporte si la verificación de done detecta condiciones fallidas (Paso 4) |

**Archivos creados/modificados:**
```
.claude/skills/specification-analyst-protocol/SKILL.md  (nueva — protocolo de 7 categorías)
.claude/agents/specification-analyst.md                  (refactorizado — 128→78 líneas)
support/avance.md                                        (este archivo)
```

---

### Sesión 22 — 2026-05-29

**Objetivo de la sesión:**
Crear `specification-analyst.md` (Worker 1 del 020) y `specification-analysis-schema` (skill de soporte).

**Trabajo realizado:**

- **`.claude/agents/specification-analyst.md` creado** — Worker 1 del 020. Lee los 4
  artefactos del 010, extrae actores/objetivos/comportamientos/casos de borde/entidades.
  Comportamiento especial: ítem PENDIENTE sin resolución del governor → reporta
  `REQUIERE_ACLARACIÓN` a B sin inventar resolución. Herramientas: `Read` y `Write` únicamente.
  Sigue patrón de `discovery-analyst.md`.

- **`.claude/skills/specification-analysis-schema/SKILL.md` creada** — Schema de
  `spec_analysis_report.md`. Define 8 secciones: inputs analizados, actores y objetivos,
  comportamientos a especificar (camino feliz + casos de borde), entidades y relaciones
  conceptuales, Error & Exception Mapping, exclusiones de scope, ítems REQUIERE_ACLARACIÓN
  y verificación de criterio de done. IDs: AC-xx, OV-xx, CF-xx, CB-xx, EN-xx, RE-xx, EE-xx, EX-xx, RA-xx.

**Decisiones tomadas:**

| Decisión | Detalle |
|----------|---------|
| Herramientas del analyst: solo Read+Write | No necesita Edit; produce un único archivo nuevo |
| Fuente de casos de borde explícita | Cada CB-xx indica si viene del failure_behavior.md o fue derivado por el analyst |
| Ítems PENDIENTE bloqueantes | Analyst no inventa resolución; bloquea y escala antes de escribir el reporte |

**Archivos creados/modificados:**
```
.claude/agents/specification-analyst.md        (nuevo — Worker 1 del 020)
.claude/skills/specification-analysis-schema/SKILL.md  (nueva — schema del reporte de análisis)
support/avance.md                              (este archivo)
```

---

### Sesión 21 — 2026-05-29

**Objetivo de la sesión:**
Auditar la alineación del plan del 020 con principios.md y metodologia.md, corregir gaps, y
reescribir `Harnesses/020_specification_harness.md` como harness operativo completo.

**Trabajo realizado:**

- **Auditoría de `plans/020_specification_harness.md`** — Análisis completo contra
  `Insumos/principios.md` y `Insumos/metodologia.md`, usando `Harnesses/010_discovery_harness.md`
  como referencia de patrón. Se encontraron 4 gaps.

- **4 gaps corregidos en `plans/020_specification_harness.md`:**
  - **G1 (E9 Early Eval):** Agregado bloque de Evaluación Temprana en 12.2 entre CP-01 y el
    spawn del writer. C evalúa `spec_analysis_report.md` contra D1+D2; score < 0.7 escala a A.
  - **G2 (quién escribe lessons_learned en 12.4):** Especificado "A registra..." en lugar de
    sujeto omitido.
  - **G3 (decisions_library en 12.5):** Agregado paso explícito: A actualiza
    `decisions_library.md` con decisiones de arquitectura validadas durante el 020.
  - **G4 (B consulta lessons_learned en re-ejecución):** Agregada línea antes del re-spawn
    del worker en Rechazo Técnico: "B lee `lessons_learned.md` antes de re-ejecutar".

- **`Harnesses/020_specification_harness.md` reescrito completamente** — De definición de
  alto nivel (3 secciones básicas) a harness operativo completo siguiendo la estructura exacta
  del 010. Incluye:
  - Fase 0 con Precondición obligatoria, Inputs (I-1..I-4), Proceso (5 pasos), Outputs (4
    artefactos), Criterio de Done y ciclo SDD+TDD adaptado.
  - Fase 1 con subsecciones 1.1–1.6 (Roles, Workers, Herramientas, Escalamiento,
    Checkpoints, Context Reset).
  - Sprint Contract con gate de PENDIENTE integrado.
  - Rúbrica con 5 dimensiones, anclas 0.2/0.5/0.8/1.0 y ejemplos few-shot calibrados.
  - Handoff → 030 (4 artefactos `/specification/` + 4 heredados de `/discovery/`).
  - Flujo 12.1–12.5 completo con gate de PENDIENTE en 12.1 y Early Eval en 12.2.

**Decisiones tomadas:**

| Decisión | Detalle |
|----------|---------|
| E9 Early Eval incluido en 020 | C evalúa spec_analysis_report antes de spawear el writer; score < 0.7 bloquea y escala a A |
| A es responsable de knowledge base | A escribe lessons_learned.md y decisions_library.md al cierre (alineado con metodologia.md sección 4.3) |
| Harness operativo ≠ plan | `Harnesses/020_specification_harness.md` es el harness final; `plans/020_specification_harness.md` es la guía de construcción con notas internas |

**Archivos modificados:**
```
plans/020_specification_harness.md     (4 gaps corregidos)
Harnesses/020_specification_harness.md (reescrito completo — era definición de alto nivel)
support/avance.md                      (este archivo)
```

---

### Sesión 20 — 2026-05-29

**Objetivo de la sesión:**
Cerrar el 010, analizar el 020 y crear el plan de construcción del 020 Specification Harness.

**Trabajo realizado:**

- **README.md creado** — documentación para humanos: estructura del repo, uso de
  `deploy-harness.ps1`, arquitectura de agentes, flujo de sesión, artefactos generados,
  re-deployment y convenciones de nombres. Criterio de actualización: solo cuando cambie
  el estado de un harness en la tabla o se agregue infraestructura nueva.

- **test_discovery_007 COMPLETA — 010 declarado COMPLETO Y VALIDADO:**
  - Escenario: clínica médica (5 médicos), sistema de agendamiento web, 5 stakeholders.
  - Score: **0.98 / 1.0 — APPROVED**. Cero eventos RESPUESTA_EXTERNA (vs 10+ en test_006).
  - IMP-31 (paths eval/) e IMP-29 R2 (dialoguer sin salidas) validados correctamente.

- **Análisis del 020 Specification Harness:**
  - El 020 transforma artefactos del 010 en contratos formales — no genera conocimiento
    nuevo vía entrevistas. Arquitectura de workers distinta al 010.
  - Decisión: **2 workers** (`specification-analyst` → `specification-writer`).
  - Decisión: **5 agentes totalmente independientes** del 010 — sin herencia de instrucciones.
  - Decisión: **CLAUDE.md Opción B** — detección automática de fase activa por harness.
  - Gate exclusivo del 020: governor resuelve ítems PENDIENTE del `failure_behavior.md` del
    010 con el cliente **antes** de aprobar el Sprint Contract.
  - Rúbrica: 5 dimensiones (D1 BDD Coverage, D2 Data Contracts, D3 AC Traceability,
    D4 Error Policy, D5 Consistency). Veto en D5. Gate ≥ 0.75.

- **`plans/020_specification_harness.md` creado** — blueprint completo con:
  - Fase 0: propósito, precondición (010 PHASE_COMPLETE), 4 inputs desde `/discovery/`,
    5 pasos de proceso, 4 outputs en `/specification/`, 4 condiciones de Done.
  - Fase 1: tabla de instancias y roles, tabla de workers con inputs/outputs, política de
    herramientas, escalamiento, 4 checkpoints canónicos (CP-01..CP-04), trigger context reset.
  - Sprint Contract: template con sección de resolución de PENDIENTES integrada.
  - Rúbrica completa con anclas 0.2 / 0.5 / 0.8 / 1.0 y ejemplos few-shot calibrados.
  - Schema de verdict.json para el 020.
  - Handoff → 030: artefactos de `/specification/` + `/discovery/` heredados.
  - Flujo 12.1–12.5: gate de PENDIENTES en 12.1, verificación EXECUTION_COMPLETE en 12.3.
  - Sección "Notas de construcción": lista de agentes, skills y cambios en infraestructura
    compartida requeridos.

- **`support/ajustes.md` limpiado** — eliminado todo lo implementado; quedan solo los
  8 ítems pendientes (IMP-13, IMP-22, IMP-28, ADJ-04, ADJ-05, ADJ-06, ADJ-07, ADJ-08).

**Decisiones tomadas:**

| Decisión | Detalle |
|----------|---------|
| Agentes independientes por harness | Cada harness tiene sus propios agentes sin herencia del anterior |
| CLAUDE.md Opción B | Detecta automáticamente qué governor invocar según fase activa en harness-state.json |
| 2 workers para el 020 | specification-analyst → specification-writer (sin worker de validación separado — el evaluador C cubre eso) |
| Gate de PENDIENTES | Governor resuelve ítems PENDIENTE del failure_behavior.md del 010 antes de spawear el orchestrator |
| IMP-22 pospuesto | Revisar diseño de IMP-22 (knowledge cross-project) después de analizar el 020 para asegurar extensibilidad a todos los harnesses |

**Archivos creados/modificados:**
```
README.md                            (nuevo — documentación para humanos)
plans/020_specification_harness.md   (nuevo — blueprint completo del 020)
support/ajustes.md                   (limpiado — solo 8 ítems pendientes)
support/avance.md                    (este archivo)
```

---

## Próximos Pasos (en orden de prioridad)

### ACCIÓN INMEDIATA — Sesión 41: Construir los componentes del 030 Design Harness

El blueprint `plans/030_design_harness.md` está COMPLETO. El siguiente paso es construir
todos los componentes en este orden:

**Paso 1 — Skills (8 total, crear en `.claude/skills/`)**

Usar `plans/030_design_harness.md` Sección "Notas de construcción" como referencia.
Usar las skills análogas del 020 como modelo de estructura.

| # | Skill | Análoga del 020 |
|---|-------|----------------|
| 1 | `design-state-schema/` | `specification-state-schema/` |
| 2 | `design-analysis-schema/` | `specification-analysis-schema/` |
| 3 | `design-analyst-protocol/` | `specification-analyst-protocol/` |
| 4 | `design-synthesis-schema/` | `specification-synthesis-schema/` |
| 5 | `design-architect-protocol/` | `specification-writer-protocol/` |
| 6 | `design-rubric/` | `specification-rubric/` |
| 7 | `design-verdict-schema/` | `specification-verdict-schema/` |
| 8 | `design-evaluator-protocol/` | `specification-evaluator-protocol/` |

**Paso 2 — Agentes (5 total, crear en `.claude/agents/`)**

| # | Agente | Análogo del 020 |
|---|--------|----------------|
| 1 | `design-orchestrator.md` | `specification-orchestrator.md` (modos PLAN/CHECKPOINT — sin Agent tool; agregar Demo Statements y Pending Verification ADJ-13) |
| 2 | `design-analyst.md` | `specification-analyst.md` (self-checklist vs Demo Statement antes de reportar COMPLETED) |
| 3 | `design-architect.md` | `specification-writer.md` (produce 5 artefactos, ADR-001 primero; self-checklist cruzado entre 5 artefactos) |
| 4 | `design-evaluator.md` | `specification-evaluator.md` (D1-D5; lee bdd_features.md y data_contracts.md como referencia) |
| 5 | `design-governor.md` | `specification-governor.md` (precondición 020 PHASE_COMPLETE; handoff al 040) |

**Paso 3 — Infraestructura compartida (3 archivos)**

| Archivo | Cambio |
|---------|--------|
| `templates/client-project-CLAUDE.md` | Agregar condición: si 020 PHASE_COMPLETE y `030_design` no existe o no PHASE_COMPLETE → invocar `design-governor` |
| `deploy-harness.ps1` | Agregar soporte para harness `030` en la lógica de selección |
| `.claude/agents/specification-governor.md` | Verificar/corregir handoff al 030: la instrucción debe usar `subagent_type: 'design-governor'` |

**Paso 4 — Reescribir harness operativo**
- Reescribir `Harnesses/030_design_harness.md` como harness completo (actualmente es definición de 26 líneas)

**Referencia principal durante la construcción:**
- `plans/030_design_harness.md` — blueprint completo del 030 ← **LEER ESTO PRIMERO**
- `plans/020_specification_harness.md` — referencia de patrón del 020
- `.claude/agents/specification-*.md` — modelos de agentes análogos
- `.claude/skills/specification-*/` — modelos de skills análogas
- `support/lessons_learned.md` — 23 lecciones aplicables íntegramente

---

### Pendiente (no bloquea el 030)

- [ ] **IMP-22** — Knowledge cross-project PostgreSQL + pgvector (diseñado, pendiente impl.)
- [ ] **IMP-28** — Dashboard HTML en tiempo real
- [ ] **ADJ-04..ADJ-08** — Rediseños de harnesses 040-080 y README en deploy script
- [ ] **ADJ-12** — Meta-Harness: referencia académica para optimización automática (referencial)
- [ ] **OBS-01..OBS-04** — Observabilidad y verificación (diferidos hasta evidencia de gap real)

---

## Reglas de Actualización de este Archivo

Al terminar cada sesión de trabajo, el agente activo debe:
1. Mover los "Próximos Pasos" completados al "Historial de Sesiones" de esa sesión.
2. Registrar las decisiones tomadas durante la sesión.
3. Actualizar la fecha de última actualización y la Fase actual.
4. Agregar los nuevos próximos pasos que emerjan.
