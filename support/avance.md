# Bitácora de Avance — Harness Definition

> **INSTRUCCIÓN PARA AGENTES:** Este es el primer archivo que debes leer al iniciar
> cualquier sesión de trabajo en este proyecto. Contiene el estado actual, las
> decisiones tomadas y los próximos pasos. No comiences ninguna tarea sin leerlo.

---

## Estado General del Proyecto

- **Fecha de última actualización:** 2026-06-03 (Sesión 70)
- **Fase actual:** Harnesses 010, 020, 030 y 040 COMPLETOS. Framework nombrado FORGE. Repo en GitHub. Próximo: 050 Vertical Harness + ADJ-25 FORGE CLI.
- **Estado:** 28 lecciones registradas (LL-01..LL-28). 040 Planning Harness 100% operativo. Repo público en GitHub (https://github.com/jdrodriguez1000/Harness_Definition.git). ADJ-25 registrado (FORGE CLI: forge-setup.ps1 + slash commands /forge-init + /forge-discovery).

---

## Contexto del Proyecto

Se está construyendo **FORGE** (*Framework for Orchestrated Requirements and Guided Engineering*) —
una metodología universal para la construcción de harnesses destinada a una empresa de
desarrollo de software. El objetivo es que cualquier harness futuro pueda construirse
siguiendo este estándar, garantizando calidad y reducción de varianza en los outputs de LLMs.

### Fuentes de Verdad
- `Insumos/principios.md` — Principios P1-P8 y Estándares E1-E12. **No se modifica nunca.**
- `Insumos/metodologia.md` — Metodología universal. **ALINEADA Y CERRADA.** No se modifica.
- `support/ajustes.md` — Ajustes pendientes activos: IMP-22, IMP-28, ADJ-04..08, ADJ-12, ADJ-24.
- `support/lessons_learned.md` — 28 lecciones universales (LL-01 a LL-28).
- `support/history/` — Historial completo de sesiones anteriores (avance y ajustes de 010, 020, 030).

### Patrones establecidos (replicar en el 040)
- **Governors como motores puros** — Sin `AskUserQuestion`. Retornan `GOVERNOR_RESULT` estructurado. El `client-project-CLAUDE.md` gestiona toda interacción con el usuario.
- **Workflows separados** — Cada ciclo vive en `templates/workflows/ciclo_0XX_name.md`. El CLAUDE.md solo hace routing.
- **Reviewer entre CP-02 y CP-03** — Verifica consistencia estructural antes de presentar al humano (020 y 030). El 040 debe evaluar si aplica.
- **Demo Statements obligatorios** — El orchestrator los escribe en el plan; los workers hacen self-checklist (harnesses 030+).
- **LL-01..LL-28** — Leer `support/lessons_learned.md` antes de escribir cualquier agente o skill.

---

## Estado actual del repositorio

```
Harness_Definition/
├── deploy-harness.ps1             — Script de deployment (soporta 010-090) ✓
├── forge-setup.ps1                — [ADJ-25 PENDIENTE] Script de instalación por máquina
├── forge.config.json              — [ADJ-25 PENDIENTE] Template de config global
├── commands/
│   ├── forge-init.md              — [ADJ-25 PENDIENTE] Fuente del slash command /forge-init
│   └── forge-discovery.md        — [ADJ-25 PENDIENTE] Fuente del slash command /forge-discovery
├── .gitignore                     — Excluye settings.local.json ✓
├── README.md                      — Documentación para humanos
├── CLAUDE.md                      — Instrucciones para agentes Claude Code
├── default_stacks.md              — [NO — este archivo vive en templates/]
├── support/
│   ├── avance.md                  — Este archivo
│   ├── ajustes.md                 — Ajustes pendientes (IMP-22, IMP-28, ADJ-04..08, ADJ-12, ADJ-24)
│   ├── lessons_learned.md         — 28 lecciones LL-01..LL-28
│   └── history/
│       ├── avance_discovery.md    — Historial sesiones 010
│       ├── avance_specification.md — Historial sesiones 020
│       ├── avance_design.md       — Historial sesiones 030 (Sesiones 40–62)
│       ├── ajustes_discovery.md   — Ajustes históricos 010
│       ├── ajustes_specification.md — Ajustes históricos 020
│       └── ajustes_design.md      — Ajustes históricos 030 (ADJ-13..ADJ-32)
├── Insumos/
│   ├── metodologia.md             — Metodología universal (CERRADA — no tocar)
│   └── principios.md              — Principios P1-P8 y Estándares E1-E12 (no tocar)
├── plans/
│   ├── 010_discovery_harness.md   — Blueprint COMPLETO
│   ├── 020_specification_harness.md — Blueprint COMPLETO
│   ├── 030_design_harness.md      — Blueprint COMPLETO
│   └── 040_planning_harness.md    — Blueprint COMPLETO (Sesión 63) ✓
├── templates/
│   ├── client-project-CLAUDE.md   — Routing only (~82 líneas) ✓
│   ├── client-project-settings.json — Permisos pre-autorizados ✓
│   ├── default_stacks.md          — Stacks de referencia (Tier PEQUEÑO: Opción A Next.js / Opción B FastAPI; Tier GRANDE: FastAPI-primero, Go si necesario) ✓
│   └── workflows/
│       ├── ciclo_010_discovery.md     — Pasos A–F del 010 ✓
│       ├── ciclo_020_specification.md — Pasos A, B-extra, B–F del 020 ✓
│       ├── ciclo_030_design.md        — Pasos A–F del 030 ✓
│       └── ciclo_040_planning.md      — Pasos A–F del 040 ✓
├── Harnesses/
│   ├── 010_discovery_harness.md   — COMPLETO e IMPLEMENTADO
│   ├── 020_specification_harness.md — COMPLETO e IMPLEMENTADO
│   └── 030_design_harness.md      — COMPLETO e IMPLEMENTADO
└── .claude/
    ├── settings.local.json        — Hooks + env vars
    ├── commands/
    │   ├── progress.md            — Comando /progress para actualizar esta bitácora ✓
    │   └── flag.md                — Comando /flag para registrar ajustes pendientes ✓
    ├── agents/
    │   ├── discovery-governor.md / orchestrator / dialoguer / analyst / synthesizer / evaluator — 010 ✓
    │   ├── specification-governor / orchestrator / analyst / writer / reviewer / evaluator — 020 ✓
    │   └── design-governor / orchestrator / analyst / architect / reviewer / evaluator — 030 ✓
    └── skills/
        ├── discovery-*.md (×8)           — 010 ✓
        ├── specification-* (×8)           — 020 ✓
        ├── design-* (×8)                  — 030 ✓
        └── planning-state-schema/         — 040 Fase 1 ✓
            planning-analysis-schema/      — 040 Fase 1 ✓
            planning-synthesis-schema/     — 040 Fase 1 ✓
            planning-rubric/               — 040 Fase 1 ✓
            planning-verdict-schema/       — 040 Fase 1 ✓
            planning-analyst-protocol/     — 040 Fase 2 ✓
            planning-writer-protocol/      — 040 Fase 2 ✓
            planning-evaluator-protocol/   — 040 Fase 2 ✓
    └── agents/
        ├── discovery-governor / orchestrator / dialoguer / analyst / synthesizer / evaluator — 010 ✓
        ├── specification-governor / orchestrator / analyst / writer / reviewer / evaluator — 020 ✓
        ├── design-governor / orchestrator / analyst / architect / reviewer / evaluator — 030 ✓
        └── planning-governor / orchestrator / analyst / writer / reviewer / evaluator — 040 ✓ (Sesión 67)
```

---

## Historial de Sesiones

### Sesión 70 — 2026-06-03

**Objetivo:** Nombrar el framework, subir el repo a GitHub y diseñar la automatización del arranque de proyecto (FORGE CLI).

**Trabajo realizado:**
- Nombre oficial del framework decidido: **FORGE** (*Framework for Orchestrated Requirements and Guided Engineering*).
- Actualización de `support/avance.md` — sección "Contexto del Proyecto" ahora incluye el nombre FORGE con acrónimo completo.
- Memoria guardada en `memory/project_forge_name.md` + `memory/MEMORY.md` creado para futuras sesiones.
- Creación de `.gitignore` — excluye `.claude/settings.local.json` (rutas locales y hooks de máquina).
- Inicialización de git y push inicial a GitHub: `https://github.com/jdrodriguez1000/Harness_Definition.git` — 97 archivos, 27,358 líneas.
- Análisis completo del FORGE CLI: diseño de dos slash commands globales (`/forge-init` y `/forge-discovery`) más script de instalación por máquina (`forge-setup.ps1`) y template de config (`forge.config.json`).
- Registro de **ADJ-25** en `support/ajustes.md` — FORGE CLI: automatización del arranque de proyecto.

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| Nombre: FORGE | Framework for Orchestrated Requirements and Guided Engineering. Elegido por su semántica (fragua = transformar materia bruta en algo sólido) y escalabilidad ("FORGE Discovery Harness", etc.) |
| GitHub repo público | `https://github.com/jdrodriguez1000/Harness_Definition.git` — respaldo completo, recuperable con `git clone` en máquina nueva |
| `.gitignore` excluye `settings.local.json` | Contiene rutas absolutas de la máquina actual y referencias a hooks locales — no debe versionarse |
| FORGE CLI: todo dentro de Claude | Los slash commands `/forge-init` y `/forge-discovery` se ejecutan desde dentro de Claude, eliminando la necesidad de un script shell externo |
| Archivos fuente en repo, instalados por `forge-setup.ps1` | Los slash commands viven en `commands/` del repo; `forge-setup.ps1` los copia a `~/.claude/commands/` en cada máquina nueva. Portabilidad total. |
| `forge.config.json` en `~/.forge/` | Config global con `forge_home`. Se genera al correr `forge-setup.ps1`. No se duplica por proyecto. |

---

### Sesión 69 — 2026-06-03

**Objetivo:** Tooling de sesión — renombrar `/avance` a `/progress` y crear el comando `/flag`.

**Trabajo realizado:**
- Creación de `.claude/commands/progress.md` — contenido idéntico a `avance.md`, título y referencia interna actualizados a `/progress`.
- Eliminación de `.claude/commands/avance.md`.
- Actualización de `support/avance.md`: referencia en árbol del repositorio y en sección "Reglas de Actualización" (`/avance` → `/progress`).
- Creación de `.claude/commands/flag.md` — comando `/flag` que infiere título, descripción, impacto y prerequisitos desde el contexto de la conversación, pregunta la prioridad si no es obvia, y escribe la fila en la Tabla de Estado + la entrada en la sección Detalle de `support/ajustes.md`.
- Actualización del árbol del repositorio en `support/avance.md` con los dos nuevos comandos.

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| `/flag` infiere desde contexto (no usa formulario) | El usuario describe el problema en la conversación y luego ejecuta `/flag` — el comando infiere los campos igual que `/progress`. Solo pregunta la prioridad si no es evidente del contexto. |
| Prioridad como único campo interactivo en `/flag` | Título, descripción, impacto y prerequisitos se infieren. La prioridad es una decisión del usuario (CRÍTICA/SIGNIFICATIVA/MENOR) y no siempre es deducible del contexto. |

---

### Sesión 68 — 2026-06-03

**Objetivo:** Construir la Fase 4 del 040 Planning Harness: workflow de ciclo y conectores.

**Trabajo realizado:**
- Lectura de `support/lessons_learned.md`, `templates/workflows/ciclo_030_design.md`, `templates/client-project-CLAUDE.md`, `deploy-harness.ps1`, `.claude/agents/planning-governor.md` y `Harnesses/040_planning_harness.md` como referencias directas.
- Creación de `templates/workflows/ciclo_040_planning.md` — ciclo completo de interacción con 6 pasos (A–F): orientación con ramificación de GOVERNOR_RESULT, loop de Sprint Contract, ejecución técnica, gate CP-03 con 3 artefactos, gate CP-04 independiente (LL-25), y cierre con handoff al 050.
- Actualización de `templates/client-project-CLAUDE.md` — agregado el ciclo 040 al índice de workflows y el bloque completo de routing (PENDING_HANDOFF / DEPLOYED / handoff interrumpido / 040 activo no completo).
- `deploy-harness.ps1` — sin cambios: ya tenía `'040' = 'planning'` en su mapa de harnesses desde la versión anterior.

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| deploy-harness.ps1 no requiere modificación | El script ya soportaba el 040 con la entrada `'040' = 'planning'` en el mapa. El script es completamente genérico: copia agentes por prefijo, skills por prefijo, workflows y templates. No requiere código específico por harness. |
| ciclo_040_planning.md sigue el patrón exacto del 030 | Mismos 6 pasos (A–F), misma estructura de ramificación de GOVERNOR_RESULT, mismo tratamiento de CP-03/CP-04 independientes (LL-25). La única diferencia es el contenido (3 artefactos en `/plan/` en lugar de 5 en `/design/`, handoff al 050 en lugar del 040). |
| Routing 040 en client-project-CLAUDE.md sigue el patrón 010→020→030 | Mismo esquema tripartito: PENDING_HANDOFF (preguntar + deploy), DEPLOYED (ejecutar directamente), handoff inexistente (volver al governor del 030 para completar el cierre). |

---

### Sesión 67 — 2026-06-03

**Objetivo:** Construir los 6 agentes del 040 Planning Harness (Fase 3), uno a la vez.

**Trabajo realizado:**
- Lectura de `support/lessons_learned.md`, `Harnesses/040_planning_harness.md`, los 6 agentes equivalentes del 030 y las skills del 040 como referencias directas.
- Creación de `.claude/agents/planning-analyst.md` — Worker 1: lee 12 inputs en orden definido por `planning-analyst-protocol`, valida granularidad, asigna IC-xx y BDD scenarios, extrae dependencias y riesgos. Reporta en 3 estados: COMPLETED, INCOMPLETO, ESCALAMIENTO REQUERIDO.
- Creación de `.claude/agents/planning-writer.md` — Worker 2: produce los 3 artefactos en orden obligatorio (vertical_slice_plan → project_roadmap → risk_register), regla de mitigaciones no genéricas, campo Estado siempre DRAFT (el governor lo edita), checklist de consistencia cruzada en 4 categorías.
- Creación de `.claude/agents/planning-reviewer.md` — Control pre-CP-03: 4 verificaciones (V1 IC-xx↔slices, V2 BDD↔slices, V3 orden roadmap, V4 cobertura risk_register) con referencias a `contract_definitions.md` y `bdd_features.md` como fuentes externas.
- Creación de `.claude/agents/planning-evaluator.md` — Auditor independiente: Fase 1 análisis (pros+contras con citas) → Fase 2 score, rúbrica D1-D5, paths de salida SOLO en `eval/` nunca en `/plan/`, verificación 5 (campo Estado) calibrada para pre y post-CP-04.
- Creación de `.claude/agents/planning-orchestrator.md` — Gestión de estado en 4 modos (PLAN, CHECKPOINT-01, CHECKPOINT-02, WORKER_FAILED): resuelve 12 inputs reales en disco, guarda Demo Statements canónicos, protocolo de 5 pasos para checkpoints (LL-06), PLAN_ERROR si I1 es null.
- Creación de `.claude/agents/planning-governor.md` — Director en 5 modos (INIT, EXECUTE, POST_CP03, POST_CP04, CLOSE): precondición del 030, E10-A/E10-B completos, tabla de reanudación E10-B, Paso 1 en POST_CP04 edita `Estado: DRAFT → APROBADO POR CLIENTE` en los 3 artefactos (LL-17/LL-23), PRECONDICIÓN ABSOLUTA en CLOSE (LL-20), handoff al 050.

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| planning-analyst: 3 estados de retorno | COMPLETED / INCOMPLETO / ESCALAMIENTO REQUERIDO — el tercer estado es necesario porque el 040 puede bloquearse por gaps del 030 (sección "Guía de Vertical Slices" ausente, ciclos de dependencias) que requieren intervención humana antes de continuar |
| planning-governor POST_CP04 Paso 1: editar Estado antes de la auditoría | El governor edita `Estado: DRAFT → APROBADO POR CLIENTE` en los 3 artefactos como primer paso de POST_CP04, antes de spawear el evaluador. El evaluador encontrará `APROBADO POR CLIENTE` — esto es correcto y la Verificación 5 del planning-evaluator-protocol no lo penaliza |
| planning-orchestrator: PLAN_ERROR si I1 es null | Si `design/test_strategy_map.md` no existe, el orchestrator retorna PLAN_ERROR inmediatamente sin escribir el orchestration_plan. El 040 no puede operar sin el draft VS del 030 |
| planning-governor E10-A: validar sección "Guía de Vertical Slices" en INIT | El governor verifica que `test_strategy_map.md` contiene la sección antes de inicializar el harness. Fallo en este paso es INIT_FAILED, no ESCALAMIENTO — no tiene sentido crear el estado del harness si el input principal está incompleto |
| planning-reviewer: fuentes de referencia externas | A diferencia del design-reviewer (que cruza los 5 artefactos entre sí), el planning-reviewer usa `contract_definitions.md` y `bdd_features.md` del 030/020 como fuentes de verdad externas para V1 y V2 |

---

### Sesión 66 — 2026-06-03

**Objetivo:** Construir las 3 skills de protocolos de workers del 040 Planning Harness (Fase 2).

**Trabajo realizado:**
- Lectura de `support/lessons_learned.md`, `plans/040_planning_harness.md`, los 3 protocolos equivalentes del 030 (`design-analyst-protocol`, `design-architect-protocol`, `design-evaluator-protocol`) y los schemas del 040 ya creados (`planning-analysis-schema`, `planning-synthesis-schema`) como referencias directas.
- Creación de `.claude/skills/planning-analyst-protocol/SKILL.md` — protocolo de 6 tareas de extracción (inventario VS, granularidad, asignación IC-xx, asignación BDD, matriz de dependencias, riesgos preliminares) con regla de no-inferencia, orden de lectura de 12 inputs, criterio de done y límite de iteraciones.
- Creación de `.claude/skills/planning-writer-protocol/SKILL.md` — protocolo con reglas de transformación por artefacto (vertical_slice_plan → project_roadmap → risk_register), orden de producción obligatorio, reglas de mitigaciones concretas (no genéricas), checklist de consistencia cruzada y self-checklist del Demo Statement.
- Creación de `.claude/skills/planning-evaluator-protocol/SKILL.md` — protocolo con verificaciones D1-D5 en formato dos fases (análisis con citas → score), checks cruzados de IDs entre los 3 artefactos y las fuentes de verdad externas, y definición operacional de la regla de veto D5=0.0 con ejemplos concretos.

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| planning-analyst-protocol: orden de inputs invertido respecto al 030 | Se lee `test_strategy_map.md` al final (no al principio) porque es el input principal y debe leerse con todo el contexto de vocabulario, scope y BDD ya cargado |
| Precondición de escalamiento en Tarea 1 del analyst | Si `test_strategy_map.md` no contiene "Guía de Vertical Slices" o falta algún hito → escalamiento inmediato, sin continuar con el resto del análisis |
| planning-writer-protocol: regla de mitigaciones explícita con ejemplos negativos | Las frases "revisar el código", "hacer más testing", "monitorear el riesgo" están listadas explícitamente como NO aceptables; la mitigación debe citar IC-xx, slices o artefactos concretos |
| planning-evaluator-protocol: Verificación 5 (campo Estado) calibrada para post-CP-04 | Si el evaluador corre después de que el governor editó Estado → encontrar `APROBADO POR CLIENTE` es correcto. Si corre antes → `DRAFT` es correcto. El protocolo no penaliza ninguno de los dos estados |
| Regla de veto D5: 4 ejemplos concretos del dominio 040 | Los ejemplos usan VS-xx, IC-xx y tipo de slice — no son genéricos, están calibrados al dominio de planificación del 040 |

---

### Sesión 64 — 2026-06-03

**Objetivo:** Reescribir `Harnesses/040_planning_harness.md` con la estructura canónica
completa del patrón establecido por los harnesses 010/020/030.

**Trabajo realizado:**
- Lectura de `Harnesses/030_design_harness.md` y `Harnesses/050_iteration_harness.md` para identificar el patrón estructural exacto
- Reescritura completa de `Harnesses/040_planning_harness.md` reemplazando el borrador original de metodología (28 líneas) con el harness operativo completo (~380 líneas)

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| Estructura idéntica al 030 | Mismo esquema de secciones: Fase 0, Fase 1 (1.1–1.6), Sprint Contract, Rúbrica, Handoff, Flujo (12.1–12.5 + 12.2.5) |
| Reviewer incluido en Fase 1 tabla de instancias | Instancia D (planning-reviewer) documentada en 1.1, 1.5 y 12.2.5, igual que el 030 |
| Artefactos intermedios listados en Outputs | `planning_analysis_report.md` y `review_report.md` anotados como "no entregados al 050, no evaluados por rúbrica" |
| Tabla de Ritual E10-B adaptada al 040 | Estados y acciones de continuación mapean `040_planning.status` y `execution_state.last_checkpoint` |

---

### Sesión 65 — 2026-06-03

**Objetivo:** Construir las 5 skills base del 040 Planning Harness (Fase 1).

**Trabajo realizado:**
- Lectura de `support/lessons_learned.md`, `plans/040_planning_harness.md` y las 5 skills equivalentes del 030 (`design-state-schema`, `design-synthesis-schema`, `design-analysis-schema`, `design-rubric`, `design-verdict-schema`) como referencia directa
- Creación de `.claude/skills/planning-state-schema/SKILL.md` — schema de `harness-state.json` (entrada "040_planning") y `execution-state.json` con I-1..I-12, Single Writer Rule y reglas de escritura del orchestrator
- Creación de `.claude/skills/planning-analysis-schema/SKILL.md` — schema de `planning_analysis_report.md` con 6 secciones: VS draft, validación de granularidad, asignación IC-xx, asignación BDD scenarios, matriz de dependencias y riesgos preliminares
- Creación de `.claude/skills/planning-synthesis-schema/SKILL.md` — schema de los 3 artefactos finales: `vertical_slice_plan.md` (6 campos obligatorios por slice), `project_roadmap.md` (secuencia + hitos + dependencias), `risk_register.md` (RK-xx por slice) con orden de producción obligatorio y checklist de verificación cruzada
- Creación de `.claude/skills/planning-rubric/SKILL.md` — rúbrica D1-D5 con anclas 0.2/0.5/0.8/1.0 calibradas en el dominio Distribuidora Andina, gate ≥0.75, regla de veto D5=0.0 con ejemplos concretos
- Creación de `.claude/skills/planning-verdict-schema/SKILL.md` — `verdict.json` y `metrics_summary.json` con fase "040_planning", métricas objetivas de cobertura IC-xx y BDD scenarios, y orden de escritura append

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| planning-analysis-schema con 6 secciones estructuradas | VS-draft, granularidad, IC-xx, BDD, dependencias, riesgos — cada sección con su tabla y reglas de escritura independientes |
| Sección de convención de nomenclatura en la validación de granularidad | El analyst decide y documenta la convención de IDs (VS-xxA/VS-xxB o secuencial) para slices divididas — queda registrada en el reporte para que el writer la aplique coherentemente |
| planning-synthesis-schema: orden de producción vertical_slice_plan → project_roadmap → risk_register | El roadmap depende de las slices; el risk register depende de la lista final VS-xx — el orden garantiza consistencia desde el primer pase |
| planning-rubric: mismo dominio de referencia (Distribuidora Andina) que el 030 | Continuidad narrativa entre harnesses facilita la calibración comparativa durante revisiones del sistema |
| planning-verdict-schema: métricas de cobertura independientes | `ic_asignados_en_vertical_slice_plan` y `bdd_scenarios_asignados_en_vertical_slice_plan` se obtienen leyendo los artefactos finales, no el analysis_report — verificación verdaderamente independiente |

---

### Sesión 63 — 2026-06-03

**Objetivo:** Iniciar la construcción del 040 Planning Harness — comenzando por el blueprint.

**Trabajo realizado:**
- Exploración del patrón existente (010/020/030 plans, agentes y skills del 030, metodología y lecciones LL-01..LL-28)
- Diseño del plan de construcción completo del 040 en modo Plan (aprobado por el usuario)
- Creación de `plans/040_planning_harness.md` — blueprint canónico del 040 con las 7 secciones obligatorias

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| Patrón idéntico al 030 | governor + orchestrator (sin Agent tool) + 2 workers + reviewer + evaluator |
| 12 inputs (I-1..I-12) | I-1 `test_strategy_map.md` es el principal; heredan todos los artefactos del 030, 020 y 010 |
| 3 artefactos finales | `vertical_slice_plan.md`, `project_roadmap.md`, `risk_register.md` en `/plan/` |
| Rúbrica D1-D5 | D1 VS Coverage, D2 Slice Definition Quality, D3 Roadmap Coherence, D4 Risk Completeness, D5 Consistency (veto) |
| 6 campos obligatorios por slice | nombre, tipo, IC-xx, BDD scenarios, Criterio de Done con IDs, estimación de esfuerzo (XS/S/M/L/XL) |
| planning-reviewer entre CP-02 y CP-03 | 4 verificaciones: IC-xx huérfanos, BDD scenarios huérfanos, orden TB→MVP→Robustez, risk_register cubre todas las VS-xx |
| IDs de slices nuevas | Si se divide una slice sobredimensionada, el analyst decide la convención (VS-03a/VS-03b o numeración secuencial) |

---

## Próximos Pasos

### Tarea 1 — Implementar ADJ-25: FORGE CLI

Crear los 4 archivos en el repo:
- `forge-setup.ps1` — instala config y slash commands en la máquina local
- `forge.config.json` — template con `forge_home`
- `commands/forge-init.md` — slash command: ejecuta deploy + mensaje de siguiente paso
- `commands/forge-discovery.md` — slash command: invoca `discovery-governor` en modo INIT

Después de implementar: correr `forge-setup.ps1` para verificar que funciona end-to-end.

### Tarea 2 — Construir el 050 Vertical Harness

El siguiente harness en la secuencia. Trabaja una slice a la vez tomando el plan maestro del 040 como fuente de verdad. Produce: Proposal, SDS, SDD, testing_plan y execution_plan para la slice activa.

Antes de iniciar, revisar `support/ajustes.md` — los ajustes ADJ-05, ADJ-06 y ADJ-07 impactan directamente la definición y numeración de los harnesses 050–070.

---

### Estado de construcción del 040 — COMPLETADO

El blueprint `plans/040_planning_harness.md` está completo y aprobado.
Lo que falta construir (en el orden del plan):

**Fase 0 — Harness canónico:** ✓ COMPLETADO en Sesión 64
- `Harnesses/040_planning_harness.md` reescrito con estructura completa del patrón 030

**Fase 1 — Skills base:** ✓ COMPLETADO en Sesión 65
- `planning-state-schema.md` ✓
- `planning-synthesis-schema.md` ✓
- `planning-analysis-schema.md` ✓
- `planning-rubric.md` ✓
- `planning-verdict-schema.md` ✓

**Fase 2 — Protocolos de workers:** ✓ COMPLETADO en Sesión 66
- `planning-analyst-protocol.md` ✓
- `planning-writer-protocol.md` ✓
- `planning-evaluator-protocol.md` ✓

**Fase 3 — Agentes:** ✓ COMPLETADO en Sesión 67
- `planning-analyst.md` ✓
- `planning-writer.md` ✓
- `planning-reviewer.md` ✓
- `planning-evaluator.md` ✓
- `planning-orchestrator.md` ✓
- `planning-governor.md` ✓

**Fase 4 — Workflow y conectores:** ✓ COMPLETADO en Sesión 68
- `templates/workflows/ciclo_040_planning.md` ✓
- `templates/client-project-CLAUDE.md` actualizado ✓
- `deploy-harness.ps1` — sin cambios requeridos (ya soportaba 040) ✓

### Contexto para el 040

El 040 Planning Harness corre **una sola vez** al inicio de cada proyecto, después del 030.
Su función es tomar el draft de Vertical Slices producido por el 030 (`test_strategy_map.md`)
y producir el **plan maestro completo** del proyecto.

**Inputs disponibles del 030** (13 artefactos en `design/` y `specification/`):
- `design/architecture_decision_records.md` — ADR-001 (stack) + ADRs por patrón
- `design/technical_blueprint.md` — MOD-xx con skeletons de código
- `design/contract_definitions.md` — IC-xx formalizadas + DTO-xx
- `design/dependency_graph.md` — DEP-xx
- `design/test_strategy_map.md` — TS-xx + **Guía de Vertical Slices** (draft del 030)
- `specification/bdd_features.md`, `data_contracts.md`, `acceptance_criteria.md`, `error_exception_policy.md`
- `discovery/shared_understanding.md`, `scope_boundaries.md`, `domain_glossary.md`, `failure_behavior.md`

**Outputs esperados del 040** (borrador a confirmar al construirlo):
- `plan/vertical_slice_plan.md` — todas las slices con scope (IC-xx + BDD scenarios), Done y esfuerzo
- `plan/project_roadmap.md` — secuencia, dependencias entre slices y fechas/hitos
- `plan/risk_register.md` — riesgos identificados por slice

**Reglas de granularidad de slices heredadas del 030** (ADJ-32):
- Piso mínimo: ≤4 IC-xx/≤2 MOD-xx → N=0/M=0; 5–7/3–4 → N≥1/M≥1; ≥8/≥5 → N≥2/M≥1
- Criterio de división por slice: máx. 3 IC-xx nuevas, 2 MOD-xx nuevos, 10 BDD scenarios nuevos
- El 040 valida y divide slices sobredimensionadas del 030 antes de aprobar el plan maestro

**Handoff del 040 → 050:** el plan maestro aprobado es la fuente de verdad para el 050 Vertical Harness, que trabaja una slice a la vez.

### Ajustes pendientes que impactan el 040
- **ADJ-04** — Ver `support/ajustes.md` para la estructura formal de VS y responsabilidades del 040
- **ADJ-05** — El 050 se llamará "050 Vertical Harness" (a confirmar al construir el 040)

---

## Reglas de Actualización de este Archivo

Al terminar cada sesión de trabajo, ejecutar `/progress` o actualizar manualmente:
1. Mover los "Próximos Pasos" completados al historial de `support/history/avance_design.md`.
2. Registrar las decisiones tomadas durante la sesión.
3. Actualizar la fecha de última actualización y la Fase actual.
4. Actualizar el árbol del repositorio para reflejar el estado real.
5. Agregar los nuevos próximos pasos que emerjan.
