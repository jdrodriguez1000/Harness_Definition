# Bitácora de Avance — Harness Definition

> **INSTRUCCIÓN PARA AGENTES:** Este es el primer archivo que debes leer al iniciar
> cualquier sesión de trabajo en este proyecto. Contiene el estado actual, las
> decisiones tomadas y los próximos pasos. No comiences ninguna tarea sin leerlo.

---

## Estado General del Proyecto

- **Fecha de última actualización:** 2026-06-03 (Sesión 62)
- **Fase actual:** Test e2e Test_Harness_001 COMPLETO. 010 PHASE_COMPLETE (0.99). 020 PHASE_COMPLETE (0.9175). 030 PHASE_COMPLETE (0.876). Post-mortem completo realizado. ADJ-25..27 implementados. ADJ-28/29 falsos positivos. ADJ-31 y ADJ-32 implementados. ADJ-30 implementado.
- **Estado:** Harness 010, 020 y 030 completamente implementados y validados. 28 lecciones (LL-01..LL-28). Todos los ajustes post-mortem implementados. Próximo paso: construir el 040 Planning Harness.

---

## Contexto del Proyecto

Se está construyendo una **metodología universal para la construcción de harnesses**
destinada a una empresa de desarrollo de software. El objetivo es que cualquier
harness futuro pueda construirse siguiendo este estándar, garantizando calidad y
reducción de varianza en los outputs de LLMs.

### Fuentes de Verdad
- `Insumos/principios.md` — Principios P1-P8 y Estándares E1-E12. **No se modifica nunca.**
- `Insumos/metodologia.md` — Metodología universal. **ALINEADA Y CERRADA.** No se modifica.
- `support/ajustes.md` — Ajustes pendientes activos: IMP-22, IMP-28, ADJ-04..08, ADJ-12, ADJ-24, ADJ-30. (ADJ-13..17, ADJ-20..23, ADJ-25..27, ADJ-31..32 — IMPLEMENTADOS; ADJ-28..29 — FALSOS POSITIVOS; ADJ-30 — pendiente confirmación del equipo)
- `support/lessons_learned.md` — 28 lecciones universales (LL-01 a LL-28).

### Estado actual del repositorio

```
Harness_Definition/
├── deploy-harness.ps1             — Script de deployment (soporta 010-090; CLAUDE.md siempre sobreescrito) ✓
├── README.md                      — Documentación para humanos
├── CLAUDE.md                      — Instrucciones para agentes Claude Code
├── support/
│   ├── avance.md                  — Este archivo (bitácora de estado)
│   └── ajustes.md                 — Ajustes pendientes activos
├── Insumos/
│   ├── metodologia.md             — Metodología universal (CERRADA — no tocar)
│   └── principios.md              — Principios P1-P8 y Estándares E1-E12 (no tocar)
├── plans/
│   ├── 010_discovery_harness.md   — Blueprint COMPLETO (referencia de patrón)
│   ├── 020_specification_harness.md — Blueprint COMPLETO (referencia de patrón del 020)
│   └── 030_design_harness.md      — Blueprint COMPLETO ✓ (Sesión 40)
├── templates/
│   ├── client-project-CLAUDE.md   — Routing only (~82 líneas); ciclos en workflows/ ✓ (ADJ-21 Sesión 53)
│   ├── client-project-settings.json — Permisos pre-autorizados (12 entradas incl. claude spawn) ✓
│   └── workflows/
│       ├── ciclo_010_discovery.md     — Pasos A–F del 010 ✓
│       ├── ciclo_020_specification.md — Pasos A, B-extra, B–F del 020 ✓
│       └── ciclo_030_design.md        — Pasos A–F del 030 ✓
├── Harnesses/
│   ├── 010_discovery_harness.md   — Harness COMPLETO e IMPLEMENTADO
│   ├── 020_specification_harness.md — Harness COMPLETO e IMPLEMENTADO
│   └── 030_design_harness.md      — Harness operativo COMPLETO ✓ (Sesión 41)
└── .claude/
    ├── settings.local.json        — Hooks (Stop/Notification → ccnotify.ps1) + env vars
    │                                (ENABLE_TOOL_SEARCH=true, ENABLE_CLAUDEAI_MCP_SERVERS=false)
    ├── agents/
    │   ├── discovery-governor.md         — 010 ✓
    │   ├── discovery-orchestrator.md     — 010 ✓
    │   ├── discovery-dialoguer.md        — 010 ✓
    │   ├── discovery-analyst.md          — 010 ✓
    │   ├── discovery-synthesizer.md      — 010 ✓
    │   ├── discovery-evaluator.md        — 010 ✓
    │   ├── specification-governor.md     — 020 ✓ (handoff al 030 verificado ✓; ADJ-20 Sesión 48)
    │   ├── specification-orchestrator.md — 020 ✓
    │   ├── specification-analyst.md      — 020 ✓
    │   ├── specification-writer.md       — 020 ✓
    │   ├── specification-reviewer.md     — 020 ✓ (Sesión 48)
    │   ├── specification-evaluator.md    — 020 ✓
    │   ├── design-governor.md            — 030 ✓ (Sesión 43, ADJ-20 Sesión 48)
    │   ├── design-orchestrator.md        — 030 ✓ (Sesión 43)
    │   ├── design-analyst.md             — 030 ✓ (Sesión 43)
    │   ├── design-architect.md           — 030 ✓ (Sesión 43)
    │   ├── design-reviewer.md            — 030 ✓ (Sesión 48)
    │   └── design-evaluator.md           — 030 ✓ (Sesión 43)
    └── skills/
        ├── discovery-*.md (×8)                   — 010 COMPLETAS
        ├── specification-analysis-schema/         — 020 ✓
        ├── specification-analyst-protocol/        — 020 ✓
        ├── specification-synthesis-schema/        — 020 ✓
        ├── specification-writer-protocol/         — 020 ✓
        ├── specification-rubric/                  — 020 ✓
        ├── specification-verdict-schema/          — 020 ✓
        ├── specification-evaluator-protocol/      — 020 ✓
        ├── specification-state-schema/            — 020 ✓
        ├── design-state-schema/                   — 030 ✓ (Sesión 41)
        ├── design-analysis-schema/                — 030 ✓ (Sesión 41)
        ├── design-analyst-protocol/               — 030 ✓ (Sesión 41)
        ├── design-synthesis-schema/               — 030 ✓ (Sesión 41)
        ├── design-architect-protocol/             — 030 ✓ (Sesión 42)
        ├── design-rubric/                         — 030 ✓ (Sesión 42)
        ├── design-verdict-schema/                 — 030 ✓ (Sesión 42)
        └── design-evaluator-protocol/             — 030 ✓ (Sesión 42)
```

---

## Historial de Sesiones

### Sesión 50 — 2026-06-02

**Objetivo:** Implementar ADJ-14 — governors como motores de ejecución pura (Opción 2).

**Trabajo realizado:**

- **`discovery-governor.md` reescrito** — Eliminado `AskUserQuestion` del frontmatter y de toda la lógica. Convertido en máquina de estados con 5 modos: INIT (E10-A/E10-B + construcción del Sprint Contract), EXECUTE (workers), POST_CP03, POST_CP04 (evaluador incluido), CLOSE (cierre + handoff). Retorna `GOVERNOR_RESULT` estructurado al final de cada modo.

- **`templates/client-project-CLAUDE.md` reescrito** — Expandido de "routing puro" a "routing + ciclos de interacción completos" para los 3 harnesses. Cada ciclo incluye: Paso A (orientación/INIT), Paso B (loop Sprint Contract con AskUserQuestion), Paso C (EXECUTE), Paso D (Gate CP-03 con AskUserQuestion), Paso E (Gate CP-04 independiente — ADJ-16/LL-25), Paso F (cierre + handoff).

- **`support/avance.md` actualizado** — Próximos pasos reorganizados.

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| Opción 2 elegida (motor puro) | Más invasiva pero determinística. Elimina la inconsistencia por diseño, no por parche |
| INIT mode unifica E10-A y E10-B | INIT siempre es el primer call; determina internamente si es inicio o reanudación y retorna el status adecuado |
| PENDING_ITEMS_REQUIRED como status especial en 020 | El CLAUDE.md maneja la resolución de ítems PENDIENTE antes de presentar el Sprint Contract |
| GOVERNOR_RESULT como texto estructurado | Formato simple key-value que Claude puede parsear de forma fiable entre versiones |

---

### Sesión 40 — 2026-06-01

**Objetivo:** Crear el blueprint completo del 030 Design Harness.

**Trabajo realizado:**

- **`plans/030_design_harness.md` creado** — Blueprint completo con 7 secciones:
  - Fase 0: precondición (020 PHASE_COMPLETE), 8 inputs, 7 pasos de proceso, 5 outputs en `/design/`, Criterio de Done, ciclo adaptado.
  - Fase 1: instancias/roles, 2 Workers (design-analyst → design-architect), política de herramientas, escalamiento, 4 checkpoints (CP-01..CP-04), trigger de context reset.
  - Sprint Contract: template con restricciones tecnológicas del scope_boundaries.md.
  - Rúbrica: D1 Blueprint Coverage, D2 Contract Completeness, D3 Testability, D4 ADR Completeness, D5 Consistency. Veto en D5. Gate ≥0.75. Anclas 0.2/0.5/0.8/1.0 con few-shot calibrado (dominio de inventario — Distribuidora Andina Ltda.).
  - Handoff → 040: 13 artefactos disponibles. ADJ-04: test_strategy_map.md debe incluir "Guía de Vertical Slices" con ≥3 iteraciones.
  - Flujo 12.1–12.5: E10-A/E10-B, Demo Statements (ADJ-13), Pending Verification (ADJ-13), bloqueo duro en Cierre (LL-20), ADJ-23, ADJ-24.

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| 2 Workers: design-analyst + design-architect | Mismo patrón que el 020 |
| Sin Early Eval entre analyst y architect | Verificación estructural via LL-13 (Pending Verification), no rúbrica completa |
| ADJ-13 integrado desde el inicio | Demo Statements en orchestration_plan; Workers hacen self-checklist |
| ADR-001 como primer artefacto del architect | Stack decidido antes de cualquier otro artefacto |
| Guía de Vertical Slices en test_strategy_map.md | Fronteras de slicing para que el 040 trabaje con coherencia arquitectónica |

**IDs de los artefactos del 030:**
- design_analysis_report: CO-xx, **IC-xx**, PT-xx, RT-xx ← IF-xx cambiado a IC-xx (ADJ-17, Sesión 47)
- technical_blueprint: MOD-xx
- contract_definitions: IC-xx [formalizado], DTO-xx
- dependency_graph: DEP-xx
- architecture_decision_records: ADR-xx
- test_strategy_map: TS-xx

---

### Sesión 41 — 2026-06-01

**Objetivo:** Reescribir el harness operativo del 030 y construir las primeras 4 skills.

**Trabajo realizado:**

- **`Harnesses/030_design_harness.md` reescrito** como harness operativo completo siguiendo
  la estructura de `010_discovery_harness.md` y `020_specification_harness.md`. Contiene las
  7 secciones: Fase 0 (Definición Estructural), Fase 1 (Diseño Agéntico 1.1–1.6), Sprint
  Contract, Rúbrica D1-D5 con anclas, Handoff → 040, Flujo 12.1–12.5.

- **`design-state-schema/SKILL.md` creada** — Schema de `harness-state.json` (entrada
  `"030_design"`) y `execution-state.json` para el 030. Diferencias clave vs. 020:
  clave `"030_design"` con status `PENDING_CONTRACT`, 8 inputs, campo `demo_statements`
  en el orchestration_plan, campo `starting_point`, 5 artefactos en `artifacts`, sin
  `early_eval` ni `pending_resolutions`.

- **`design-analysis-schema/SKILL.md` creada** — Schema del `design_analysis_report.md`
  con IDs CO-xx (componentes), IF-xx (interfaces), PT-xx (patrones), RT-xx (restricciones
  tecnológicas). Incluye self-checklist del Demo Statement integrado (ADJ-13 + LL-01).

- **`design-analyst-protocol/SKILL.md` creada** — Protocolo de 7 categorías de extracción
  con orden de lectura explícito de los 8 inputs. Límite de 2 iteraciones (vs. 3 en el 020).
  Tipología de IF-xx (Repository/Service/Notifier/API) y tipología de patrones a buscar.

- **`design-synthesis-schema/SKILL.md` creada** — Schema de los 5 artefactos finales del
  030. Orden de producción obligatorio (ADR primero). Skeletons de código en lenguaje del
  ADR-001. Guía de Vertical Slices con 3 secciones obligatorias (ADJ-04). Verificación
  cruzada de consistencia entre los 5 artefactos antes del self-checklist.

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| `Harnesses/030_design_harness.md` reescrito antes de las skills | El harness operativo es la fuente de verdad para los agentes; las skills lo complementan |
| Self-checklist del Demo Statement en `design-analysis-schema` | El schema ya incluye el checklist para que el analyst no necesite inferirlo |
| Verificación cruzada en `design-synthesis-schema` | El architect verifica consistencia entre los 5 artefactos antes del Demo Statement |
| LL-17 aplicada en `design-synthesis-schema` | El governor escribe `APROBADO POR CLIENTE`; el architect siempre produce `DRAFT` |

---

### Sesión 42 — 2026-06-01

**Objetivo:** Completar las skills 5-8 del 030 Design Harness.

**Trabajo realizado:**

- **`design-architect-protocol/SKILL.md` creada** — Protocolo de producción para design-architect.
  Define: regla de no-inferencia con excepción controlada para ADR-001; orden de producción
  obligatorio (5 artefactos); reglas de transformación por artefacto (RT-xx/PT-xx → ADRs;
  CO-xx → MOD-xx; IC-xx → IC-xx formalizado+DTO-xx; IC-xx+MOD-xx → DEP-xx; IC-xx → TS-xx + Vertical Slices);
  self-checklist del Demo Statement; checklist de consistencia cruzada entre artefactos y vs 020/010.

- **`design-rubric/SKILL.md` creada** — Rúbrica de evaluación D1-D5 del 030. Anclas de calibración
  0.2/0.5/0.8/1.0 con dominio de referencia Distribuidora Andina Ltda. Regla de veto D5=0.0 con
  4 ejemplos concretos de contradicción silenciosa.

- **`design-verdict-schema/SKILL.md` creada** — Schema de `eval/verdict.json` y `eval/metrics_summary.json`
  para el 030. Claves adaptadas al dominio de diseño: bounded_contexts, modulos, interfaces IC-xx,
  DTOs, ADRs, Vertical Slices. Protocolo de append en 10 pasos con fuentes independientes
  (specification/bdd_features.md + specification/data_contracts.md) para métricas Tipo 1.

- **`design-evaluator-protocol/SKILL.md` creada** — Protocolo de verificación por dimensión.
  D1: verifica bounded contexts del 020 → MOD-xx (fuente independiente: bdd_features.md).
  D2: verifica EN-xx del 020 → IC-xx + DTOs (fuente independiente: data_contracts.md).
  D3: verifica IC-xx → TS-xx + Guía de Vertical Slices con 3 secciones.
  D4: verifica ADR-001 (contexto, opciones, criterios, consecuencias) + ADRs por PT-xx.
  D5: 5 verificaciones concretas (tecnología, IDs cruzados, coherencia con 020, lenguaje, reglas de arquitectura).

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| Excepción controlada en regla de no-inferencia del architect | Si RT-xx existen pero no hay preferencia explícita de stack → seleccionar el stack mínimo consistente y documentar la ausencia de preferencia en ADR-001 |
| 10 pasos de append en verdict-schema (vs 9 en el 020) | El paso 6 adicional lee bdd_features.md y data_contracts.md del 020 para métricas de cobertura independiente |
| D1 verifica desde bdd_features.md directamente (no desde analysis_report) | El evaluador actúa como auditor independiente; el analysis_report puede tener gaps que no deben propagar al veredicto |
| 5 verificaciones de D5 en orden explícito | Tecnología → IDs cruzados → coherencia 020 → lenguaje → reglas de arquitectura |

---

### Sesión 43 — 2026-06-01

**Objetivo:** Construir los 5 agentes del 030 Design Harness.

**Trabajo realizado:**

- **`design-orchestrator.md` creado** — Modos PLAN/CHECKPOINT/WORKER_FAILED. Sin Agent tool (LL-21).
  PLAN: lee 8 inputs (I1-I8 desde specification/ y discovery/), escribe Demo Statements en
  `orchestration_plan`, retorna PLAN_RESULT con starting_point + inputs + demo_statements.
  CHECKPOINT: protocolo 5 pasos para CP-01 (analysis_path) y CP-02 (5 artifacts + EXECUTION_COMPLETE).
  Sin modo EARLY_EVAL (el 030 no tiene Early Eval entre workers).

- **`design-analyst.md` creado** — Worker 1. Lee 8 inputs en orden definido por design-analyst-protocol
  (I7 scope primero, luego I6 glosario, luego I1-I4 del 020, luego I5 e I8 del 010).
  LL-01: Write de `design/design_analysis_report.md` es el primer tool call tras el análisis.
  Self-checklist contra Demo Statement. Límite de 2 iteraciones de análisis.

- **`design-architect.md` creado** — Worker 2. Produce 5 artefactos en orden obligatorio:
  architecture_decision_records (ADR-001 primero) → technical_blueprint → contract_definitions
  → dependency_graph → test_strategy_map. LL-01 por artefacto (Write antes de pasar al siguiente).
  Self-checklist cruzado entre los 5 artefactos + Demo Statement. Excepción controlada para
  RT-xx sin preferencia explícita de stack (seleccionar mínimo coherente y documentar en ADR-001).
  Sección "Guía de Vertical Slices" obligatoria en test_strategy_map.md con ≥3 iteraciones (ADJ-04).

- **`design-evaluator.md` creado** — Auditor independiente. LL-07: dos fases (análisis con
  citas concretas por dimensión, score después). LL-03: PATHS DE SALIDA solo en `eval/`, nunca
  en `/design/`. Lee bdd_features.md y data_contracts.md como fuentes independientes para D1 y D2.
  10 pasos de append en verdict-schema. Registra en claude-progress.txt con Add-Content.

- **`design-governor.md` creado** — Governor completo. Precondición: verifica
  `harness_state["020_specification"]["status"] == "PHASE_COMPLETE"` (no el root del harness-state).
  E10-A: crea `/design/`, inicializa entrada `"030_design"` en harness-state.json, inicializa
  execution-state.json, prueba de sanidad, registra arranque. E10-B: tabla de reanudación por
  estado, con VERIFICACIÓN PREVIA para AUDIT_PENDING. Sin gate de PENDIENTE (el 030 no resuelve
  ítems de failure_behavior.md — eso es exclusivo del 020). Sprint Contract incluye restricciones
  tecnológicas extraídas de scope_boundaries.md. LL-20: verificación de eval/verdict.json como
  PRIMER tool call del Cierre. LL-16: AUDIT_PENDING antes de PHASE_COMPLETE. LL-22: no spawea
  agentes post-deploy; instruye al humano a reiniciar. Handoff al 040 via deploy-harness.ps1.

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| Sin Early Eval entre analyst y architect | Confirmado: el 030 usa Pending Verification (LL-13) en lugar de Early Eval entre workers |
| Design-governor verifica 020_specification.status (no el root) | El root PHASE_COMPLETE es del 010; el 030 debe verificar la clave del 020 específicamente |
| Sin gate de PENDIENTE en design-governor | El 030 no hereda ítems PENDIENTE de failure_behavior.md; fueron resueltos en el 020 |
| Demo Statements escritos por el orchestrator, pasados inline al governor | El governor lee demo_analyst y demo_architect del PLAN_RESULT y los pasa a cada Worker en su prompt |

---

### Sesión 44 — 2026-06-01

**Objetivo:** Actualizar las 3 piezas de infraestructura compartida del 030.

**Trabajo realizado:**

Verificados los 3 archivos de infraestructura:

- **`deploy-harness.ps1`** — Ya tenía `'030' = 'design'` en el `$mapa` desde sesiones anteriores. Sin cambios.
- **`.claude/agents/specification-governor.md`** — La sección "Handoff al 030" ya usaba `-Harness 030`, el patrón LL-22 correcto y la instrucción de reinicio al humano. Sin cambios.
- **`templates/client-project-CLAUDE.md`** — **ACTUALIZADO.** Tenía solo el caso `PENDING_HANDOFF`. Se agregaron los casos faltantes (mismo patrón que el 020):
  - `handoff_030.status == "DEPLOYED"` → invocar `design-governor` directamente
  - `handoff_030` no existe → invocar `specification-governor` para completar cierre
  - `030_design` existe y no es `PHASE_COMPLETE` → invocar `design-governor` (030 en curso)
  - Se nombró explícitamente `design-governor` en lugar de "el governor del 030"

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| Solo 1 cambio de los 3 necesarios | `deploy-harness.ps1` y `specification-governor.md` ya estaban correctos desde sesiones previas |
| Patrón 020 replicado fielmente para 030 | Mismo tratamiento de casos PENDING_HANDOFF / DEPLOYED / handoff-inexistente / 030_design-en-curso |

---

### Sesión 44b — 2026-06-01

**Objetivo:** Ajustes finales de infraestructura y permisos antes del test end-to-end.

**Trabajo realizado:**

- **`templates/client-project-settings.json`** — Agregados 3 permisos nuevos:
  - `Bash(powershell.exe *)` — cubre invocaciones explícitas del ejecutable PowerShell
  - `PowerShell($env:HARNESS_DEPLOY_SCRIPT)` — el handoff no interrumpe para pedir confirmación
  - `Bash(claude --dangerously-skip-permissions -p *)` — pre-autoriza el spawn interno de subagentes

- **`.claude/settings.local.json`** — Agregados hooks y env vars personales:
  - Hooks `Stop` y `Notification` → `ccnotify.ps1` (notificaciones de escritorio)
  - `ENABLE_TOOL_SEARCH=true`, `ENABLE_CLAUDEAI_MCP_SERVERS=false`

- **`templates/client-project-CLAUDE.md`** — Corrección menor: `design/` agregado a la lista de directorios protegidos en REGLAS DE OPERACIÓN.

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| `claude --dangerously-skip-permissions` en template | Sin este permiso el harness pide confirmación en cada spawn de subagente, rompiendo el flujo autónomo |
| Hooks y env vars en `settings.local.json` (no template) | Son preferencias personales con paths hard-codeados a esta máquina |

---

### Sesión 45 — 2026-06-02

**Objetivo:** Test end-to-end del 030 Design Harness + post-mortem.

**Trabajo realizado:**

- **Test ejecutado sobre `Test_Specification_003`** — El 030 corrió completo: E10-A → Sprint Contract → design-analyst (CP-01) → design-architect (CP-02) → CP-03 → rework → CP-04 → auditoría → cierre. Score final: 0.97 (D1=1.0, D2=1.0, D3=1.0, D4=1.0, D5=0.85).

- **Post-mortem realizado** — Revisión de los 5 artefactos + `claude-progress.txt` + `harness-state.json` + `verdict.json`. 3 problemas identificados.

- **LL-24 registrada** — Demo Statement debe citar secciones obligatorias por nombre. La Guía de Vertical Slices fue omitida en el primer pase porque el Demo Statement no la nombraba.
- **LL-25 registrada** — CP-03 y CP-04 deben ser AskUserQuestion estructuralmente separados. Violación confirmada en ambos harnesses (020 y 030): timestamps idénticos.
- **LL-26 registrada** — Nomenclatura IF-xx (analyst) vs IC-xx (architect) debe alinearse. No existe tabla de mapeo entre ambas nomenclaturas.

- **ADJ-15, ADJ-16, ADJ-17 registrados** en `ajustes.md` con archivos a modificar, texto exacto de cambios y decisión pendiente para ADJ-17 (Opción A vs B).

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| 0 worker errors en el 030 | El happy path funciona correctamente |
| Rework en CP-03 funcionó bien | Governor re-spawneó architect para modificación quirúrgica sin tocar secciones existentes |
| D5=0.85 es un fallo menor del architect | IC-09 listado en MOD-05 tabla pero no en el cuerpo descriptivo ni en dependency_graph |
| ADJ-23 violado en 020 y 030 | Requiere solución estructural (ADJ-16), no solo instrucción en lenguaje natural |

---

### Sesión 46 — 2026-06-01

**Objetivo:** Discusión arquitectónica sobre reviewer agent + registro formal.

**Trabajo realizado:**

- **Problema identificado:** El humano llega al CP-03 con artefactos que contienen
  inconsistencias técnicas que no debería tener que encontrar él mismo. El evaluador
  verifica D5 post-CP-04, pero eso es demasiado tarde para evitar que el humano revise
  documentos inconsistentes.

- **Decisión arquitectónica tomada:**
  - Agregar un agente reviewer dedicado entre CP-02 y CP-03 para harnesses 020 y 030.
  - El 010 queda excluido (artefactos cualitativos sin IDs formales, valor bajo).
  - Dos agentes separados: `specification-reviewer` y `design-reviewer` (no uno genérico,
    porque los artefactos y verificaciones son distintos por harness).

- **LL-27 registrada** — CP-03 humano no detecta inconsistencias técnicas; el reviewer
  corre entre CP-02 y CP-03 como control de calidad pre-aprobación.

- **ADJ-20 registrado** — Dos agentes a crear: `specification-reviewer.md` y
  `design-reviewer.md`. Incluye verificaciones concretas por harness, comportamiento ante
  issues críticos vs. menores, y lista de archivos a crear/modificar.

- **Mentalidad del reviewer definida** — Abogado del Diablo: postura por defecto de
  desconfianza, no acepta redacción bonita como evidencia. Busca 5 categorías: gaps,
  ambigüedades, puntos faltantes, contradicciones, riesgos de proyecto. Todo issue debe
  citarse con artefacto + sección + ID o línea. Sin cita concreta, no se reporta.
  Registrado en ADJ-20.

- **Estructura formal de Vertical Slices definida** (ADJ-04 actualizado):
  - Nomenclatura: Tracer Bullet → Crecimiento (0..N) → MVP → Evolución (0..M) → Robustez
  - Tracer Bullet, MVP y Robustez son obligatorios. Crecimiento y Evolución son opcionales (N=0 y M=0 válidos para proyectos pequeños).
  - Toda slice tiene su propio criterio de Done. Done de Crecimiento/Evolución es más liviano que el de los 3 hitos principales.
  - División: 030 propone la distribución (IC-xx + BDD scenarios por slice en `test_strategy_map.md`); 040 refina y el humano aprueba.

- **ADJ-15, ADJ-16, ADJ-17 no implementados** — Diferidos a Sesión 47 (la sesión se
  dedicó a discusión arquitectónica del reviewer y formalización de Vertical Slices).

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| Reviewer no aplica al 010 | Artefactos narrativos/cualitativos, sin IDs formales, valor bajo |
| Dos agentes separados (no uno genérico) | 020 y 030 tienen artefactos distintos — no comparten suficiente lógica |
| Issues críticos → rework antes de CP-03 | El humano no ve documentos inconsistentes; governor re-spawea el Worker |
| Issues menores → presentar en CP-03 | El humano decide con diagnóstico ya hecho, no a ciegas |
| Reviewer es complementario al evaluador | Evaluador puntúa post-aprobación; reviewer verifica estructura pre-aprobación |
| Mentalidad Abogado del Diablo | No asume nada correcto sin evidencia; reporta solo con cita concreta |
| Crecimiento y Evolución son 0..N opcionales | Proyectos pequeños pueden ir directo Tracer → MVP → Robustez |
| 030 propone VS, 040 confirma | El 030 tiene el contexto de diseño; el 040 el de planificación y ejecución |
| 040 corre una sola vez | Produce el plan maestro completo al inicio del proyecto; el 050 lo consume slice por slice |

---

### Sesión 47 — 2026-06-02

**Objetivo:** Aplicar ADJ-15, ADJ-16 y ADJ-17 (post-mortem del test end-to-end del 030).

**Trabajo realizado:**

- **ADJ-16 — CP-04 como gate siempre independiente (LL-25):**
  Agregado bloque `REGLA ESTRUCTURAL (ADJ-16 / LL-25)` al inicio del Gate CP-04 en `specification-governor.md` y `design-governor.md`. El bloque es explícito: no colapsar con CP-03 aunque la respuesta ya incluya aprobación; el timestamp de CP-04 debe ser posterior al de CP-03.

- **ADJ-15 — Demo Statement del architect cita la Guía de Vertical Slices (LL-24):**
  - `design-orchestrator.md`: Demo Statement de design-architect actualizado. Ahora cita explícitamente "sección obligatoria 'Guía de Vertical Slices' con ≥3 iteraciones nombradas: Tracer Bullet, MVP y Robustez como mínimo" y "estrategia Fake/Mock/Real por interface IC-xx".
  - `design-architect.md`: Self-checklist agrega ítem explícito: `test_strategy_map.md incluye sección 'Guía de Vertical Slices' con ≥3 iteraciones nombradas`.

- **ADJ-17 (Opción A) — IF-xx → IC-xx en el analyst (LL-26):**
  El analyst ahora usa IC-xx directamente (mismo prefijo que el architect). El architect "formaliza" las IC-xx del analysis_report (agrega firmas de métodos y DTOs) en lugar de "elevarlas desde IF-xx". Archivos actualizados (10 en total — 0 referencias a IF-xx residuales verificadas):
  - `design-analysis-schema/SKILL.md`, `design-analyst-protocol/SKILL.md`, `design-analyst.md`
  - `design-orchestrator.md`, `design-governor.md`, `design-state-schema/SKILL.md`
  - `design-architect.md`, `design-architect-protocol/SKILL.md`
  - `design-synthesis-schema/SKILL.md`, `design-evaluator-protocol/SKILL.md`

- **`support/ajustes.md` actualizado** — Secciones de detalle de ADJ-15, ADJ-16, ADJ-17 reescritas con los cambios aplicados (de "PENDIENTE" a "IMPLEMENTADO").

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| ADJ-17 Opción A elegida | Fuente única de verdad: el analyst usa IC-xx. El architect formaliza (firmas + DTOs). Verificado con grep: 0 residuos IF-xx. |
| ADJ-16 como bloque estructural en texto | El agente lee el texto del gate y la regla es visible inline — no requiere lógica adicional |

---

### Sesión 48 — 2026-06-02

**Objetivo:** Implementar ADJ-20 — agentes reviewer entre CP-02 y CP-03 para harnesses 020 y 030.

**Trabajo realizado:**

- **`specification-reviewer.md` creado** — Control de calidad pre-CP-03 del 020. 4 verificaciones con mentalidad Abogado del Diablo: V1 (entidades fantasma en BDD), V2 (entidades huérfanas en data_contracts), V3 (criterios sin feature BDD), V4 (errores sin contrato). Escribe `specification/review_report.md` como primer tool call (LL-01). Retorna REVIEW_RESULT: CLEAN | HAS_ISSUES con conteo de issues críticos y menores.

- **`design-reviewer.md` creado** — Control de calidad pre-CP-03 del 030. 6 verificaciones: V1 (IC-xx huérfanos entre contract_definitions y dependency_graph), V2 (MOD-xx huérfanos entre blueprint y dependency_graph), V3 (IC-xx sin TS-xx en test_strategy_map), V4 (Guía de Vertical Slices obligatoria con ≥3 iteraciones), V5 (ADR-001 con 4 secciones obligatorias), V6 (coherencia de stack ADR-001 vs. skeletons). Escribe `design/review_report.md`.

- **`specification-governor.md` actualizado** — Agregado Paso 6 (reviewer) entre EXECUTION_COMPLETE y Gate CP-03. Lógica de decisión: CLEAN → CP-03; CRITICAL > 0 → rework; CRITICAL == 0 → CP-03 con issues menores. E10-B tabla actualizada. Frontmatter `agents:` actualizado.

- **`design-governor.md` actualizado** — Ídem con Paso 5 (reviewer). Mismo patrón de decisión.

- **`Harnesses/020_specification_harness.md` actualizado** — Instancia D (Reviewer) en tabla 1.1. Checkpoint intermedio en tabla 1.5. `specification/review_report.md` como artefacto auxiliar.

- **`Harnesses/030_design_harness.md` actualizado** — Ídem para 030.

- **`support/ajustes.md` actualizado** — ADJ-20 marcado IMPLEMENTADO.

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| review_report.md en carpeta del harness (no en `review/` separada) | Más simple; coherente con el patrón de artefactos intermedios (design_analysis_report.md también vive en `design/`) |
| Sin skills separadas para los reviewers | PI-2: protocolo inline suficiente; 4 y 6 checks son manejables en el agente |
| deploy-harness.ps1 sin cambios | El glob `specification-*` y `design-*` ya cubre los nuevos agentes automáticamente |
| Rework triggered por reviewer → vuelve al Paso de verificación del Worker, no al orchestrator | El governor re-spawea solo el writer/architect; el orchestrator registra un nuevo CP-02 tras el rework |

---

### Sesión 49 — 2026-06-02

**Objetivo:** Implementar ADJ-04 — formalizar la estructura de la Guía de Vertical Slices en el 030.

**Trabajo realizado:**

- **`design-synthesis-schema/SKILL.md` actualizado** — Regla de VS expandida con nomenclatura formal (`VS-Tracer Bullet → VS-Crecimiento-1..N → VS-MVP → VS-Evolución-1..M → VS-Robustez`) y 5 campos obligatorios por slice: nombre, tipo (hito-principal/opcional), IC-xx asignados, BDD scenarios (SC-xx/SE-xx), criterio de Done. Checklist de verificación cruzada actualizado.

- **`design-architect.md` actualizado** — Sección "Guía de Vertical Slices (ADJ-04)" reescrita con la nomenclatura formal y los 5 campos. Self-checklist actualizado para verificar que cada slice tiene los 5 campos.

- **`Harnesses/030_design_harness.md` actualizado** — Paso 7 expandido con nomenclatura y campos. Demo Statement de design-architect actualizado para incluir la Guía de VS como condición observable. Tabla Outputs actualizada.

- **`design-orchestrator.md` actualizado** — Demo Statement de design-architect: "≥3 iteraciones nombradas" reemplazado por los 5 campos explícitos (nombre, tipo, IC-xx asignados, BDD scenarios, criterio de Done). Consistencia con `design-architect.md` y `030_design_harness.md`.

- **`support/ajustes.md` actualizado** — ADJ-04 marcado como PARCIAL (impacto 030 implementado; 040 pendiente).

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| ADJ-04 marcado PARCIAL, no IMPLEMENTADO | El 040 Planning Harness (la parte principal de ADJ-04) aún no está construido |
| 5 campos en lugar de descripción libre | Estandariza lo que el architect produce y lo que el 040 puede consumir programáticamente |
| Crecimiento/Evolución con N=0, M=0 válidos | Proyectos pequeños no fuerzan slices opcionales |

---

### Sesión 51 — 2026-06-02

**Objetivo:** Implementar ADJ-14 para el 020 — reescribir `specification-governor.md` como motor de ejecución pura.

**Trabajo realizado:**

- **`specification-governor.md` reescrito** — Eliminado `AskUserQuestion` del frontmatter y de toda la lógica. Convertido en máquina de estados con 5 modos: INIT (precondición 010 + E10-A/E10-B + gate PENDIENTE + construcción del Sprint Contract), EXECUTE (workers + Early Eval E9 + reviewer), POST_CP03, POST_CP04 (auditoría incluida), CLOSE (cierre + handoff al 030). Retorna `GOVERNOR_RESULT` estructurado al final de cada modo.

**Características únicas del 020 preservadas:**
- Gate de ítems PENDIENTE: retorna `PENDING_ITEMS_REQUIRED` si hay ítems; el CLAUDE.md gestiona la interacción con AskUserQuestion y vuelve a llamar INIT con `pending_resolutions`
- `pending_resolutions` propagadas al specification-analyst en el prompt de EXECUTE
- Early Eval E9 entre CP-01 y CP-02: si score < 0.7 retorna `EXECUTION_BLOCKED`
- specification-reviewer (ADJ-20) en Paso 7 de EXECUTE antes del retorno EXECUTION_COMPLETE
- Precondición: verifica root `status == "PHASE_COMPLETE"` (del 010)
- Clave de estado: `"020_specification"` (no root)
- Handoff al 030 en modo CLOSE

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| PENDING_ITEMS_REQUIRED como status especial | El CLAUDE.md recibe la lista de ítems y gestiona la AskUserQuestion; luego vuelve a llamar INIT con las resoluciones en el prompt |
| EXECUTION_BLOCKED para Early Eval y REQUIERE_ACLARACIÓN | Señal diferenciada de EXECUTION_FAILED para distinguir bloqueos por calidad de los bloqueos por error técnico |
| AskUserQuestion: 0 ocurrencias funcionales | Solo aparece en la frase de prohibición de apertura |

---

---

### Sesión 51 (continuación 2) — 2026-06-02

**Objetivo:** Implementar ADJ-14 para el 030 — reescribir `design-governor.md` como motor de ejecución pura.

**Trabajo realizado:**

- **`design-governor.md` reescrito** — Eliminado `AskUserQuestion` del frontmatter y de toda la lógica. Convertido en máquina de estados con 5 modos: INIT (precondición 020 + E10-A/E10-B + lectura de restricciones tecnológicas de `scope_boundaries.md` + construcción del Sprint Contract), EXECUTE (design-analyst → design-architect → design-reviewer), POST_CP03, POST_CP04 (auditoría incluida), CLOSE (cierre + handoff al 040). Retorna `GOVERNOR_RESULT` estructurado al final de cada modo.

**Características únicas del 030 preservadas:**
- Precondición: verifica `"020_specification".status == "PHASE_COMPLETE"` (no root status)
- Lectura de restricciones tecnológicas de `scope_boundaries.md` en E10-A.3
- Sin gate PENDIENTE ni Early Eval (exclusivos del 020)
- POST_CP03 con selección de Worker según artefactos afectados (analyst o architect)
- Clave de estado: `"030_design"`, handoff al 040

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| ADJ-14 completo para los 3 governors | discovery ✓, specification ✓, design ✓ — ADJ-14 IMPLEMENTADO |
| AskUserQuestion: 0 ocurrencias funcionales en design-governor | Solo aparece en la frase de prohibición de apertura |

---

---

### Sesión 51 (continuación 3) — 2026-06-02

**Objetivo:** Completar los ciclos 020 y 030 en `templates/client-project-CLAUDE.md`.

**Trabajo realizado:**

- **`templates/client-project-CLAUDE.md` reescrito** — Ciclos 020 y 030 expandidos al mismo nivel de detalle que el Ciclo 010. Cada ciclo ahora tiene:
  - Paso A completo con todos los GOVERNOR_RESULT (incluyendo RESUME_HOLD, ALREADY_COMPLETE)
  - Ciclo 020 Paso B-extra: resolución de PENDING_ITEMS_REQUIRED con AskUserQuestion y re-invocación con pending_resolutions
  - Paso C con EXECUTION_BLOCKED (solo 020), EXECUTION_FAILED
  - Paso D con review_status: HAS_MINOR_ISSUES del reviewer, loop de rework, timestamp pre-gate
  - Paso E con todos los GOVERNOR_RESULT (CLOSURE_READY, CP04_DECLINED, ESCALATION_REQUIRED, REWORK_AFTER_REJECTION, STRATEGIC_REJECTION)
  - Paso F con HANDOFF_READY, PHASE_COMPLETE_NO_HANDOFF, CLOSE_BLOCKED

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| EXECUTION_BLOCKED solo en Ciclo 020 | El 030 no tiene Early Eval ni REQUIERE_ACLARACIÓN — no puede bloquearse de esa forma |
| Timestamp pre-gate en cada CP-03 y CP-04 | El CLAUDE.md registra el evento antes de la AskUserQuestion para garantizar orden de timestamps |

---

---

### Sesión 52 — 2026-06-02

**Objetivo:** Identificar y registrar problema de escalabilidad en `client-project-CLAUDE.md`.

**Trabajo realizado:**

- **ADJ-21 registrado** en `support/ajustes.md` — `client-project-CLAUDE.md` crece linealmente con cada harness nuevo. Actualmente 729 líneas con 3 harnesses; proyectado ~2200 líneas con 9 harnesses. Se documentaron 3 opciones de solución (Opción A: governors self-contained con `next_prompt`/`next_options`; Opción B: deploy sobreescribe CLAUDE.md con versión phase-specific; Opción C: aceptar el crecimiento).

- **`support/ajustes.md` actualizado** — ADJ-21 añadido a tabla y sección de detalle.
- **`support/avance.md` actualizado** — Estado y próximos pasos actualizados.

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| ADJ-21 prioridad SIGNIFICATIVA | El problema es bajo hoy pero bloqueante antes del 040: si se construye el 040 con el modelo actual, el problema se instala permanentemente |
| Evaluar antes de construir el 040 | La Opción A requiere reescribir governors — mejor decidir antes de que haya más governors que cambiar |
| Prerequisito: test ADJ-14 primero | El test revelará si GOVERNOR_RESULT ya es suficientemente estructurado para soportar `next_prompt`/`next_options` (Opción A) |

---

---

### Sesión 53 — 2026-06-02

**Objetivo:** Implementar ADJ-21 — carpeta `workflows/` para desacoplar ciclos del CLAUDE.md.

**Trabajo realizado:**

- **`templates/workflows/` creada** con 3 archivos extraídos del CLAUDE.md actual:
  - `ciclo_010_discovery.md` — Pasos A–F del 010 Discovery
  - `ciclo_020_specification.md` — Pasos A, B-extra, B–F del 020 Specification
  - `ciclo_030_design.md` — Pasos A–F del 030 Design

- **`templates/client-project-CLAUDE.md` reescrito** — De 729 → ~82 líneas. Conserva solo el routing (Pasos 1–2 con instrucciones de leer el workflow correspondiente), REGLAS DE OPERACIÓN y PRINCIPIOS DE COMPORTAMIENTO. Cada harness nuevo solo requiere una línea en el routing y un archivo nuevo en `workflows/`.

- **`deploy-harness.ps1` actualizado** — Nueva sección que copia `templates/workflows/*.md` → `.claude/workflows/` en el cliente (siempre sobreescribir, igual que CLAUDE.md). Reportado en el reporte final del script.

- **`support/ajustes.md` actualizado** — ADJ-21 marcado IMPLEMENTADO con descripción de Opción D.

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| Opción D (workflows/) sobre Opciones A/B/C | No requiere reescribir governors (A), no genera N versiones del template (B), resuelve el problema (no C) |
| Copiar TODOS los workflows en cada deploy | El routing los puede necesitar todos; copiar todo es simple y consistente |
| El agente lee el workflow con Read tool en runtime | Un tool call adicional al inicio de sesión — costo mínimo, determinístico |

---

---

### Sesión 54 — 2026-06-02

**Objetivo:** Corrección de estados en `ajustes.md` + confirmación de readiness para test e2e.

**Trabajo realizado:**

- **`ADJ-14` marcado IMPLEMENTADO** en `support/ajustes.md` — El estado decía PENDIENTE pero la implementación estaba completa desde Sesiones 50–51 (governors reescritos como motores puros + CLAUDE.md gestiona AskUserQuestion). Solo faltaba actualizar el estado. Texto de detalle actualizado para reflejar la solución implementada (Opción 2).

- **`ADJ-13` marcado IMPLEMENTADO** en `support/ajustes.md` — El estado decía PENDIENTE pero Demo Statements + Pending Verification ya estaban implementados en el 030 desde Sesiones 41–43 (`design-orchestrator.md`, `design-analyst.md`, `design-architect.md`). ADJ-13 es regla dura solo para harnesses 030+; el 010 y 020 no lo requieren.

- **Confirmación de readiness para test e2e completo** — Verificado que todo está listo para correr 010→020→030 de punta a punta. Los tres cambios recientes sin test son: ADJ-14 (governors puros), ADJ-20 (reviewers), ADJ-21 (workflows/). El test los valida todos de una vez.

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| Test e2e consolida validación de ADJ-14 + ADJ-20 + ADJ-21 | En lugar de 3 tests separados, un solo ciclo 010→030 cubre todo |
| ADJ-21 ya resuelto — no bloquea el 040 | La Prioridad 2 anterior (evaluar ADJ-21) queda cerrada: Opción D implementada en Sesión 53 |

---

### Sesión 55 — 2026-06-02

**Objetivo:** Diseñar mecanismo de versiones actualizadas y stacks de referencia para el design-architect.

**Trabajo realizado:**

- **ADJ-22 registrado** en `support/ajustes.md` — Problema: el design-architect produce el
  ADR-001 con versiones congeladas en el knowledge cutoff del modelo. Solución elegida:
  Context7 como skill global de Claude Code (instalación única por máquina via `npx`, no
  configuración por proyecto). El architect invoca Context7 antes de escribir el ADR-001
  para verificar la versión estable actual de cada tecnología del stack. Si Context7 no
  encuentra la librería, documenta explícitamente la incertidumbre en el ADR-001.
  No requiere cambios en `client-project-settings.json` ni en `deploy-harness.ps1`.

- **ADJ-23 registrado** en `support/ajustes.md` — Problema: sin RT-xx explícitas del cliente,
  el architect inventa un stack ad-hoc sin guía del equipo. Solución: archivo
  `templates/default_stacks.md` con dos tiers (PEQUEÑO y GRANDE). El architect clasifica
  el proyecto evaluando señales del `design_analysis_report.md` (tipos de cliente, equipos,
  volumen, rendimiento) y selecciona el tier correspondiente.

  Stack Tier PEQUEÑO (ref: transcript_2.md): Next.js + shadcn/ui + React Hook Form + Zod
  + Prisma + PostgreSQL + DigitalOcean Spaces + Brevo + Better Auth + Railway.

  Stack Tier GRANDE (ref: transcript_3.md): Go + Gin + GORM + PostgreSQL + Redis + MongoDB
  + React + Vite (o Next.js con SEO) + React Native + Tauri + GitHub Actions + Railway/AWS.

- **Fuentes analizadas:**
  - `transcript_1.md` — Context7 como skill global (funcionamiento, instalación, alcance)
  - `transcript_2.md` — Stack para proyectos pequeños/rápidos (web para clientes)
  - `transcript_3.md` — Stack para proyectos grandes (multi-cliente, multi-equipo)

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| Context7 como skill global, no MCP por proyecto | No requiere tocar settings.json ni deploy-harness.ps1 del cliente |
| ADJ-22 + ADJ-23 se implementan juntos | Un solo bloque nuevo en design-architect.md: tier → stack → versiones → ADR-001 |
| Dos tiers en default_stacks.md | La clasificación se hace desde el design_analysis_report.md sin cambiar el 010 |
| Prerequisito: confirmar stacks con el equipo | Especialmente Tier GRANDE — Go puede no ser el lenguaje del equipo |
| No implementar hasta completar test e2e | ADJ-22 y ADJ-23 son post-test; el test e2e sigue siendo Prioridad 1 |

---

## Próximos Pasos — Sesión 55

### Sesión 56 — 2026-06-02

**Objetivo:** Implementar ADJ-22 — verificación de versiones con Context7 en design-architect.

**Trabajo realizado:**

- **`.claude/agents/design-architect.md` actualizado** — Agregado bloque `#### Verificación de versiones con Context7 (ADJ-22)` dentro del Artefacto 1 (`architecture_decision_records.md`), antes de la instrucción del ADR-001. El bloque define el protocolo de 4 pasos: invocar Context7 por cada RT-xx, registrar `{ tecnología, versión, fuente }` en memoria de trabajo, citar `(verificado via Context7)` o `(sin verificación — knowledge cutoff del modelo)` en el ADR-001, y aplicar igualmente si no hay RT-xx explícitas.

- **`support/ajustes.md` actualizado** — ADJ-22 marcado IMPLEMENTADO.

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| ADJ-22 implementado sin ADJ-23 (primera parte) | ADJ-23 requiere confirmar stacks con el equipo; ADJ-22 no tiene ese prerequisito |
| Un solo archivo modificado para ADJ-22 | Sin cambios en settings.json, deploy-harness.ps1 ni skills — Context7 es skill global |
| Bloque dentro del Artefacto 1, no como Paso separado | El Context7 está directamente acoplado al ADR-001; separarlos crearía distancia semántica innecesaria |
| Caso "sin RT-xx" cubierto explícitamente | Sin instrucción, el architect podría saltarse Context7 cuando no hay restricciones del cliente |

---

### Sesión 56 (continuación) — 2026-06-02

**Objetivo:** Implementar ADJ-23 — stack de referencia por tier en design-architect.

**Trabajo realizado:**

- **`templates/default_stacks.md` creado** — Archivo de referencia con dos tiers: PEQUEÑO (Next.js + shadcn/ui + Prisma + PostgreSQL + Railway + Better Auth + Brevo) y GRANDE (Go + Gin + GORM + PostgreSQL + Redis + MongoDB + React + Vite + Next.js + React Native + Tauri + GitHub Actions). Incluye tabla de criterios de clasificación, reglas de aplicación (RT-xx completas / parciales / ausentes) y requisitos del ADR-001.

- **`deploy-harness.ps1` actualizado** — Nueva sección que copia `templates/default_stacks.md` → raíz del proyecto cliente (siempre sobreescribir, igual que CLAUDE.md). Reportado en reporte final del script.

- **`.claude/agents/design-architect.md` actualizado** — Bloque `#### Clasificación de tier y stack de referencia (ADJ-23)` agregado ANTES del bloque Context7 (ADJ-22). Define 3 pasos: leer `default_stacks.md`, clasificar tier evaluando 5 señales del analysis_report, construir stack con precedencia RT-xx > default parcial > default completo.

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| ADJ-23 implementado inmediatamente después de ADJ-22 | El usuario eligió implementar ambos en la misma sesión |
| `default_stacks.md` en raíz del cliente (no en `.claude/`) | El architect lo lee como cualquier archivo de proyecto; coherente con la ubicación de CLAUDE.md |
| Tabla de clasificación inline en design-architect.md | El architect no necesita leer un documento externo de criterios — los tiene en su propio prompt |
| Precedencia RT-xx > default parcial > default completo | RT-xx del cliente siempre gana; el default es el desempate cuando el cliente no opina |

---

### Sesión 57 — 2026-06-02

**Objetivo:** Diagnosticar y corregir fallo del discovery-dialoguer en test e2e.

**Trabajo realizado:**

- **Problema identificado:** El `discovery-dialoguer`, cuando es spawneado por `discovery-governor` como sub-subagente (`CLAUDE.md → Agent(governor) → Agent(dialoguer)`), fabricó el transcript completo sin hacer preguntas reales al usuario. `AskUserQuestion` no bloquea en el usuario real en contexto anidado — el modelo "completa la tarea" generando contenido plausible.

- **LL-28 registrada** — Workers interactivos (que usan AskUserQuestion) no pueden correr como subagentes del governor. Deben ser invocados directamente desde la sesión principal.

- **`discovery-governor.md` actualizado** — Paso 3 de EXECUTE reescrito: en lugar de spawear el dialoguer, retorna `GOVERNOR_RESULT: status: DIALOGUER_REQUIRED` con los inputs. Si se llama con `dialoguer_complete: true`, salta al paso de verificación del transcript.

- **`ciclo_010_discovery.md` actualizado** — Paso C expandido con Sub-paso C1 (invocar dialoguer directamente) y Sub-paso C2 (re-invocar governor con `dialoguer_complete: true`).

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| Dialoguer invocado desde CLAUDE.md, no desde governor | La cadena correcta es `CLAUDE.md → Agent(dialoguer)`, no `governor → Agent(dialoguer)` |
| Governor retorna DIALOGUER_REQUIRED | Señal limpia para el workflow; el governor no spawea workers interactivos |
| Solo 2 archivos modificados | Sin cambios al dialoguer ni a otros workers |

---

### Sesión 58 — 2026-06-02

**Objetivo:** Continuar test e2e Test_Harness_001 + post-mortem de 010 y 020 + registrar ajustes.

**Trabajo realizado:**

- **Test e2e — 010 Discovery:** PHASE_COMPLETE. Score 0.99/1.00. 5 stakeholders, 14 FBs, 0 rework cycles. El único incidente fue LL-28 (dialoguer como sub-subagente fabricaba respuestas) — corregido en Sesión 57 antes de correr el test. Entrevista S-05 completada con apoyo de esta terminal (respuestas sugeridas basadas en transcript existente).

- **Test e2e — 020 Specification:** PHASE_COMPLETE. Score 0.9175/1.00. 32 contratos, 10 entidades, 14 FBs cubiertos. Reviewer (ADJ-20) funcionó: 3 issues menores no bloqueantes (M-01, M-02, M-03). CP-03 y CP-04 aprobados en primera presentación. Handoff al 030 ejecutado manualmente (HARNESS_DEPLOY_SCRIPT no configurada en la sesión — issue operativo, no del harness).

- **Test e2e — 030 Design:** Sprint Contract aprobado a las 2026-06-02T23:16:23Z. Estado: ACTIVE. Workers pendientes: design-analyst → design-architect → design-reviewer. Sesión suspendida por límite de tokens antes de ejecutar EXECUTE.

- **Post-mortem 010/020:** Análisis detallado de comportamiento de los tres harnesses. Identificados 5 nuevos ajustes:
  - **ADJ-25** — specification-rubric sin pesos por dimensión
  - **ADJ-26** — specification-verdict-schema demasiado complejo (Opción A elegida)
  - **ADJ-27** — evaluador inventa nombres de dimensiones en lugar de usar los canónicos
  - **ADJ-28** — claude-progress.txt ausente en el 020 tras ADJ-14
  - **ADJ-29** — Early Eval E9 score no registrado en ningún artefacto

**Estado del proyecto de test:**

```
Test_Harness_001/
  Ruta: C:\Users\USUARIO\Documents\Triple S\Tests\Test_Harness_001
  010: PHASE_COMPLETE ✓ (score 0.99)
  020: PHASE_COMPLETE ✓ (score 0.9175)
  030: PHASE_COMPLETE ✓ (score 0.876 — v2 tras rework)
  harness-state.json: 030_design.status = "PHASE_COMPLETE", approved_at = "2026-06-03T03:39:30Z"
```

---

### Sesión 59 — 2026-06-03

**Objetivo:** Completar el 030 Design en Test_Harness_001 + post-mortem + registrar ajustes.

**Trabajo realizado:**

- **Test e2e — 030 Design: PHASE_COMPLETE** (score 0.876). El harness corrió el ciclo completo:
  design-analyst (CP-01) → design-architect (CP-02) → design-reviewer → CP-03 → CP-04 →
  design-evaluator v1 (REJECTED, score 0.72) → rework → design-reviewer v2 (CLEAN) →
  design-evaluator v2 (APPROVED, score 0.876).

- **ADJ-28 descartado:** `claude-progress.txt` sí existe en `persistence/claude-progress.txt`
  con 51 entradas cubriendo los 3 harnesses. El ajuste estaba basado en una búsqueda incorrecta
  en la raíz del proyecto. ADJ-28 puede marcarse como falso positivo al implementar.

- **Post-mortem del 030 realizado:**
  - Positivo: ciclo completo funciona, rework automático operativo, reviewer v2 CLEAN,
    CP-03/CP-04 con timestamps distintos (ADJ-16 ✓), criterios Done del Sprint Contract cumplidos.
  - Negativo: evaluador v1 rechazado (0.72) — Guía de Vertical Slices omitida en primera pasada
    (problema recurrente, ya ocurrió en el test anterior a pesar de ADJ-15), ErrorDTOs
    ausentes sistemáticamente (10/10), ADR-001 sin tabla de criterios ni pros en opciones rechazadas.
  - D1=0.80 en ambas versiones: el blueprint coverage no mejoró con el rework.

- **Discusión sobre stack tecnológico:**
  - El architect eligió Django en lugar del Tier PEQUEÑO de `default_stacks.md` (Next.js).
  - La desviación es técnicamente justificada (transacciones ACID, admin panel, LDAP/SAML)
    pero no fue documentada en ADR-001 como exige ADJ-23.
  - Context7 (ADJ-22) fue implementado en el agente pero no ejecutado: el ADR-001 no tiene
    ninguna marca `(verificado via Context7)`.

- **ADJ-30 registrado** — Evaluar FastAPI como alternativa a Django en Tier PEQUEÑO.
  Tradeoff: Django gana cuando BC-04 (admin panel) es requisito; FastAPI gana en ergonomía/async.
  Pendiente confirmar preferencia del equipo antes de tocar `default_stacks.md`.

- **ADJ-31 registrado** — ADJ-22 (Context7) implementado pero no ejecutado en el test.
  Causa probable: el bloque no tiene señal de bloqueo fuerte. Solución: mover el bloque a
  pre-producción con `STOP` explícito + agregar al self-checklist + penalizar en D4 del evaluador.

- **ADJ-32 registrado** — Guía de Vertical Slices sin regla de granularidad. El architect
  eligió N=0, M=0 para un proyecto de 10 interfaces y 6 módulos, produciendo un MVP
  sobredimensionado. Solución: dos reglas complementarias — (1) piso mínimo por tamaño
  de proyecto (tabla IC-xx / MOD-xx → N mínimo / M mínimo), (2) criterio de división por
  slice (máx. 3 IC-xx nuevas, 2 MOD-xx nuevos, 10 BDD scenarios por slice). El número
  final emerge de la evaluación, no de una tabla fija. El 030 propone el draft; el 040
  valida y divide si alguna slice quedó sobredimensionada.

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| ADJ-28 probablemente falso positivo | El archivo existe en `persistence/`, no en raíz. Verificar al implementar antes de hacer cambios |
| Guía de VS sigue siendo el punto débil del architect | 2 tests consecutivos con la misma omisión. ADJ-15 no fue suficiente — requiere señal más fuerte (bloqueo o penalización en evaluador) |
| Django vs FastAPI depende de BC-04 | Si el proyecto tiene panel de administración como requisito, Django gana. Sin ese requisito, FastAPI es preferible |
| Context7 necesita STOP explícito | Sin señal de bloqueo, el architect omite la verificación de versiones optimizando velocidad |

---

### Sesión 60 — 2026-06-03

**Objetivo:** Implementar ADJ-25, ADJ-26 y ADJ-27 — correcciones al evaluador del 020.

**Trabajo realizado:**

- **ADJ-25 — Pesos por dimensión en `specification-rubric/SKILL.md`:**
  Columna "Peso" agregada a la tabla de dimensiones (D1=0.20, D2=0.25, D3=0.20, D4=0.20,
  D5=0.15). Línea de cálculo ponderado agregada debajo del gate. `specification-evaluator.md`
  actualizado: "Calcular promedio" → "Calcular promedio ponderado" con fórmula explícita
  `D1×0.20 + D2×0.25 + D3×0.20 + D4×0.20 + D5×0.15`.

- **ADJ-26 — `specification-verdict-schema/SKILL.md` reescrito:**
  Eliminados `tipo1_metricas_objetivas`, `tipo2_scores_evaluacion`, `artifacts`, `timeline`
  y `revision_counts`. Nuevo formato: `dimensions` (score+weight+notes con pesos de ADJ-25)
  + `cycle_metrics`. Archivo de salida reducido a solo `eval/verdict.json` (eliminado
  `metrics_summary.json`). Orden de escritura reducido de 9 a 4 pasos. `specification-evaluator.md`
  actualizado: PATHS DE SALIDA y orden de escritura actualizados para reflejar el nuevo schema.

- **ADJ-27 — Nombres canónicos hardcodeados en `specification-evaluator.md`:**
  Tabla de 5 filas con claves JSON exactas agregada al inicio de la sección "## Evaluación"
  con instrucción explícita "NO MODIFICAR". Evita que el evaluador infiera nombres del
  contexto y produzca variantes como D3_failure_policy_coverage o D5_client_approval.

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| metrics_summary.json eliminado del 020 | Los datos útiles quedan en cycle_metrics dentro de verdict.json; los tipo1 frágiles se descartan |
| rejection_cycles = evaluation_version - 1 | Regla derivada sin necesidad de leer execution-state.json; mantiene los 4 pasos limpios |
| Tabla canónica como bloque visual prominente | El evaluador la ve antes de cualquier instrucción de evaluación — no puede pasar por alto |

---

### Sesión 61 — 2026-06-03

**Objetivo:** Implementar ADJ-28/29 (verificar falsos positivos) + ADJ-31 + ADJ-32.

**Trabajo realizado:**

- **ADJ-28 — FALSO POSITIVO confirmado:**
  Grep sobre los 3 governors verificó que `discovery-governor.md`, `specification-governor.md`
  y `design-governor.md` tienen instrucciones `Add-Content` completas con cobertura de todos
  los eventos. El archivo `persistence/claude-progress.txt` existe con 51 entradas. El problema
  reportado en Sesión 58 fue una búsqueda en la raíz en lugar de `persistence/`. Sin cambios.

- **ADJ-29 — FALSO POSITIVO confirmado:**
  `specification-orchestrator.md` ya tiene modo `EARLY_EVAL` dedicado que persiste
  `{ evaluated_at, score, passed, notes }` en `execution-state.json`. El governor invoca
  `[MODO: EARLY_EVAL]` tras extraer el resultado del evaluador. El campo está documentado en
  `specification-state-schema/SKILL.md`. Sin cambios.

- **ADJ-31 — IMPLEMENTADO:**
  Problema: el bloque Context7 en `design-architect.md` no tenía señal de bloqueo — el
  architect lo omitía optimizando velocidad. Tres cambios aplicados:
  - `design-architect.md` — bloque Context7: `**STOP — No escribir el ADR-001 hasta completar
    este paso.**` al inicio; scope ampliado de "tecnologías en RT-xx" a "todas las tecnologías
    del stack final elegido".
  - `design-architect.md` — self-checklist: nuevo ítem `[ ] ADR-001 cita fuente de versión
    por cada tecnología del stack (verificado via Context7 o knowledge cutoff explícito)`.
  - `design-evaluator.md` — D4 agrega verificación #4: si el ADR-001 no cita fuente de versión
    por tecnología, se contabiliza como gap en los contras.

- **ADJ-32 — IMPLEMENTADO:**
  Problema: N=0/M=0 siempre válidos producen MVP sobredimensionados (10 interfaces en un paso).
  Dos reglas implementadas en 3 archivos:
  - **Regla 1 — Piso mínimo:** ≤4 IC-xx/≤2 MOD-xx → N=0/M=0; 5–7/3–4 → N≥1/M≥1; ≥8/≥5 → N≥2/M≥1.
  - **Regla 2 — Criterio de división:** máx. 3 IC-xx nuevas, 2 MOD-xx nuevos, 10 BDD scenarios
    nuevos por slice. Si se supera cualquier límite → dividir la slice recursivamente.
  - Archivos actualizados: `design-architect.md`, `design-synthesis-schema/SKILL.md`,
    `Harnesses/030_design_harness.md`.

- **`support/ajustes.md` actualizado** — Tabla y secciones de detalle de ADJ-28/29 (falsos
  positivos), ADJ-31 y ADJ-32 (implementados) actualizadas. ADJ-04 referenciado a ADJ-32.

- **`support/avance.md` actualizado** — Fuentes de Verdad y próximos pasos actualizados.

**Decisiones clave:**

| Decisión | Detalle |
|----------|---------|
| ADJ-28 y ADJ-29 son falsos positivos | La infraestructura de observabilidad ya existía antes de esta sesión |
| STOP explícito en Context7 (ADJ-31) | Sin señal de bloqueo el modelo omite verificaciones de setup; el STOP es la señal más fuerte disponible en texto plano |
| Penalización D4 como red de seguridad (ADJ-31) | Si el STOP falla, el evaluador detecta la omisión en la auditoría post-CP-04 |
| Piso mínimo derivado de IC-xx y MOD-xx (ADJ-32) | Métricas objetivas del artefacto; el architect las tiene disponibles al producir el test_strategy_map |
| Criterio de división 3/2/10 (ADJ-32) | Límites que producen iteraciones de ~1 semana para un equipo de 2–3 personas |
| 040 valida y puede dividir slices del 030 | El 030 propone el draft; el 040 es la segunda línea de defensa si alguna slice quedó sobredimensionada |

---

### Prioridad 1 — Construcción del 040 Planning Harness

ADJ-04 (parte principal). Ver `support/ajustes.md` sección ADJ-04.

---

## Reglas de Actualización de este Archivo

Al terminar cada sesión de trabajo, el agente activo debe:
1. Mover los "Próximos Pasos" completados al "Historial de Sesiones" de esa sesión.
2. Registrar las decisiones tomadas durante la sesión.
3. Actualizar la fecha de última actualización y la Fase actual.
4. Actualizar el árbol del repositorio para reflejar el estado real.
5. Agregar los nuevos próximos pasos que emerjan.
