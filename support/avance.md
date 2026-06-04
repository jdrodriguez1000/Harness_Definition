# Bitácora de Avance — Harness Definition

> **INSTRUCCIÓN PARA AGENTES:** Este es el primer archivo que debes leer al iniciar
> cualquier sesión de trabajo en este proyecto. Contiene el estado actual, las
> decisiones tomadas y los próximos pasos. No comiences ninguna tarea sin leerlo.

---

## Estado General del Proyecto

- **Fecha de última actualización:** 2026-06-04 (Sesión 88)
- **Fase actual:** Harnesses 010, 020, 030 y 040 COMPLETOS. 050 Vertical Harness COMPLETO (Fases 0, 1, 2 y 3). FORGE CLI operativo. Próximo: ejecutar Test_Harness_003 (Estilo Urbano — peluquería) desde el 010 hasta el 050 VS-01 Tracer Bullet.
- **Estado:** 29 lecciones registradas (LL-01..LL-29). Brief de Test_Harness_003 creado. Decisión: probar el sistema completo 010→050 antes de construir los harnesses 060, 070 y 080.

---

## Contexto del Proyecto

Se está construyendo **FORGE** (*Framework for Orchestrated Requirements and Guided Engineering*) —
una metodología universal para la construcción de harnesses destinada a una empresa de
desarrollo de software. El objetivo es que cualquier harness futuro pueda construirse
siguiendo este estándar, garantizando calidad y reducción de varianza en los outputs de LLMs.

### Fuentes de Verdad
- `Insumos/principios.md` — Principios P1-P8 y Estándares E1-E12. **No se modifica nunca.**
- `Insumos/metodologia.md` — Metodología universal. **ALINEADA Y CERRADA.** No se modifica.
- `support/ajustes.md` — Ajustes pendientes activos: IMP-22, IMP-28, ADJ-04..08, ADJ-12, ADJ-24, ADJ-31.
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
├── install.ps1                    — Instalación en máquina nueva (irm | iex) ✓
├── forge-setup.ps1                — Configura máquina: instala config y slash commands ✓
├── commands/
│   ├── forge-init.md              — Fuente del slash command /forge-init ✓
│   ├── forge-discovery.md         — Fuente del slash command /forge-discovery ✓
│   ├── forge-suspend.md           — Slash command /forge-suspend ✓ (ADJ-26 IMPLEMENTADO)
│   ├── forge-continue.md          — Slash command /forge-continue ✓ (ADJ-27 IMPLEMENTADO)
│   ├── forge-restart.md           — Slash command /forge-restart ✓ (ADJ-28 IMPLEMENTADO)
│   └── forge-override.md          — Slash command /forge-override ✓ (ADJ-29 IMPLEMENTADO)
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
│   ├── 040_planning_harness.md    — Blueprint COMPLETO (Sesión 63) ✓
│   └── 050_vertical_harness.md    — Blueprint COMPLETO (Sesión 79) ✓
├── templates/
│   ├── client-project-CLAUDE.md   — Routing only (~82 líneas) ✓
│   ├── client-project-settings.json — Permisos pre-autorizados ✓
│   ├── default_stacks.md          — Stacks de referencia (Tier PEQUEÑO: Opción A Next.js / Opción B FastAPI; Tier GRANDE: FastAPI-primero, Go si necesario) ✓
│   └── workflows/
│       ├── ciclo_010_discovery.md     — Pasos A–F del 010 ✓
│       ├── ciclo_020_specification.md — Pasos A, B-extra, B–F del 020 ✓
│       ├── ciclo_030_design.md        — Pasos A–F del 030 ✓
│       ├── ciclo_040_planning.md      — Pasos A–F del 040 ✓
│       └── ciclo_050_vertical.md     — Pasos A–F del 050 ✓ (Sesión 85)
├── Harnesses/
│   ├── 010_discovery_harness.md   — COMPLETO e IMPLEMENTADO
│   ├── 020_specification_harness.md — COMPLETO e IMPLEMENTADO
│   ├── 030_design_harness.md      — COMPLETO e IMPLEMENTADO
│   ├── 050_vertical_harness.md    — COMPLETO (Fase 0) — Sesión 80 ✓
│   └── 100_change_harness.md      — DESCRIPCIÓN DE ALTO NIVEL (pendiente construcción completa)
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
            vertical-state-schema/         — 050 Fase 1 ✓
            vertical-analysis-schema/      — 050 Fase 1 ✓
            vertical-synthesis-schema/     — 050 Fase 1 ✓
            vertical-rubric/               — 050 Fase 1 ✓
            vertical-verdict-schema/       — 050 Fase 1 ✓ (Sesión 82)
            vertical-analyst-protocol/     — 050 Fase 1 ✓ (Sesión 82)
            vertical-writer-protocol/      — 050 Fase 1 ✓ (Sesión 82)
            vertical-evaluator-protocol/   — 050 Fase 1 ✓ (Sesión 82)
    └── agents/
        ├── discovery-governor / orchestrator / dialoguer / analyst / synthesizer / evaluator — 010 ✓
        ├── specification-governor / orchestrator / analyst / writer / reviewer / evaluator — 020 ✓
        ├── design-governor / orchestrator / analyst / architect / reviewer / evaluator — 030 ✓
        ├── planning-governor / orchestrator / analyst / writer / reviewer / evaluator — 040 ✓ (Sesión 67)
        └── vertical-analyst / vertical-writer / vertical-reviewer / vertical-evaluator / vertical-orchestrator / vertical-governor — 050 Fase 2 COMPLETA ✓ (Sesiones 83-84)
```

---

## Historial de Sesiones

### Sesión 88 — 2026-06-04

**Objetivo:** Decidir la siguiente tarea de construcción (060/070/080 vs. prueba end-to-end) y preparar el proyecto de prueba Test_Harness_003.

**Trabajo realizado:**
- Análisis de opciones: construir harnesses 060/070/080 vs. ejecutar prueba end-to-end 010→050.
- Decisión: ejecutar Test_Harness_003 primero, cubriendo el flujo completo desde el 010 hasta que el 050 produce y aprueba la VS-01 Tracer Bullet (CP-04 aprobado, `CLOSURE_READY`). El handoff al 060 no se ejecuta porque el harness no existe aún.
- Selección del proyecto de prueba: **Estilo Urbano** — peluquería pequeña con sistema de citas online.
- Creación del brief de Test_Harness_003 — brief completo con descripción del negocio, problema central, 3 stakeholders con nombre y rol, restricciones conocidas y alcance tentativo. (El proyecto de prueba vive fuera de este repositorio.)

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| Prueba antes de construir 060/070/080 | El 050 nunca ha corrido en producción real. Los bugs de prompts ambiguos, rutas incorrectas y governors confundidos con 17 inputs son más baratos de corregir ahora que después de construir 3 harnesses encima. |
| Alcance del test: hasta VS-01 Tracer Bullet | El 050 termina con CLOSURE_READY para el primer slice. Sin el 060, el handoff no se ejecuta — pero los 5 artefactos, Sprint Contract, auditoría y CP-03/CP-04 se validan completamente. |
| Proyecto: Estilo Urbano (peluquería) | Dominio distinto a La Terraza (restaurante), 3 stakeholders con perspectivas genuinamente distintas (dueño, estilista, cliente frecuente), restricciones reales (sin pagos, solo web responsive, horario fijo). |

---

### Sesión 87 — 2026-06-04

**Objetivo:** Implementar ADJ-35 — persistir sprint contracts como archivos .md legibles en la carpeta `contract/`; actualizar ajustes.md cerrando los ajustes ya implementados (ADJ-04, ADJ-05, ADJ-30).

**Trabajo realizado:**
- ADJ-35 implementado en los 5 governors:
  - `.claude/agents/discovery-governor.md` — Paso 1 de EXECUTE escribe `contract/010_discovery.md`
  - `.claude/agents/specification-governor.md` — ídem `contract/020_specification.md`
  - `.claude/agents/design-governor.md` — ídem `contract/030_design.md`
  - `.claude/agents/planning-governor.md` — ídem `contract/040_planning.md`
  - `.claude/agents/vertical-governor.md` — escribe `contract/050_vertical_[VS-xx].md` (uno por slice, nombre con ID real interpolado)
- ADJ-35 documentado en los 5 state schemas (Single Writer Rule): `contract/<NNN>_<nombre>.md` agregado con nota de que no es archivo de estado y que el governor crea la carpeta si no existe.
- `support/ajustes.md` — ADJ-04 y ADJ-05 marcados IMPLEMENTADO; encabezado de sección ADJ-30 corregido a IMPLEMENTADO; ADJ-05 actualizado con estado real del harness y ciclo extendido.
- 2 commits y push a GitHub: `df1bff1` (050 Vertical Harness completo + ADJ-35 para 010-040) y `7e83039` (ADJ-35 para vertical-governor y vertical-state-schema).

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| Carpeta `contract/` en lugar de `sprint_contract/` | Nombre más corto, elegido por el usuario. El governor la crea en runtime si no existe — sin cambios en deploy-harness.ps1. |
| `contract/050_vertical_VS-xx.md` con ID interpolado | El campo `sprint_contract` en harness-state.json rota con cada slice nueva — sin el archivo .md la auditoría de contratos anteriores sería imposible. Cada slice tiene su copia persistente. |
| 050 fuera del scope original de ADJ-35, incluido a pedido | ADJ-35 solo mencionaba 010-040. Al explicar que el 050 sobreescribe el campo por slice, el usuario confirmó que quería cubrirlo también. |

---

### Sesión 86 — 2026-06-04

**Objetivo:** Auditar y corregir el agente `vertical-governor.md`; extender el ciclo por slice de 050→060→070 a 050→060→070→080 con soporte de Deployment Groups y estado PROD_READY.

**Trabajo realizado:**
- Auditoría de `.claude/agents/vertical-governor.md` — identificados 4 gaps estructurales.
- Corrección de los 4 gaps en `vertical-governor.md`:
  - Gap 1: Removido `discovery-knowledge-schema` del frontmatter y del cuerpo; reemplazado por instrucción de leer el archivo existente y seguir su formato.
  - Gap 2: Agregado límite de 3 ciclos al reviewer loop (Paso 6 de EXECUTE); al 4° ciclo escala con EXECUTION_FAILED.
  - Gap 3: CHECK 2 (AUDIT_PENDING en E10-B.5) ahora verifica si `eval/verdict.json` ya tiene la entrada antes de re-spawnar el evaluator.
  - Gap 4: Protocolo de Rechazo Técnico incluye paso de reviewer post-rework (con límite de 2 ciclos) antes de retornar a CP-03.
- Decisión arquitectónica: extender el ciclo por slice de 050→060→070 a **050→060→070→080**.
- Decisión: los Deployment Groups se definen en `project_roadmap.md` (no en un artefacto nuevo).
- Modificación de `.claude/skills/planning-writer-protocol/SKILL.md`:
  - Sección obligatoria `Deployment Groups` en las reglas de `project_roadmap.md` (DG-xx con slices, predecesores de deploy y justificación; regla de deployabilidad requiere PROD_READY en todas las slices del grupo).
  - 2 nuevos checks en el checklist de consistencia y 1 en el self-checklist.
- Modificación de `.claude/skills/vertical-state-schema/SKILL.md`:
  - Estado `PROD_READY` agregado al dict de slices (escrito por el 080 governor).
  - `SLICE_COMPLETE` redefinido como "esperando 080".
  - `PHASE_COMPLETE` ahora requiere PROD_READY en todas las slices.
  - Nota cross-harness actualizada: 070 escribe SLICE_COMPLETE, 080 escribe PROD_READY.
- Modificación de `.claude/agents/vertical-governor.md`:
  - CHECK 3 (E10-B.5) detecta `PROD_READY` en lugar de `SLICE_COMPLETE`.
  - CLOSE TOTAL verifica `PROD_READY` en todas las slices.
  - Tabla de reanudación E10-B.6 actualizada.
- 2 commits y push a GitHub.

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| Ciclo extendido a 050→060→070→080 | Cada slice completa los 4 harnesses antes de estar disponible para el 090. PROD_READY es el único estado que habilita el deploy vía 090. |
| Deployment Groups en project_roadmap.md | No se crea un artefacto nuevo. Los DG-xx se definen como sección dentro del roadmap existente del 040 — un único artefacto para secuencia + dependencias + grupos de deploy. |
| Regla de deployabilidad: PROD_READY + predecesores DEPLOYED | Un grupo no se puede deployar si alguna de sus slices no completó el 080, o si sus grupos predecesores no están en DEPLOYED. La resolución es responsabilidad del 090 governor. |
| Límite de 3 ciclos en reviewer loop | Después de 3 ciclos sin CLEAN, el harness escala con EXECUTION_FAILED. Sin este límite el loop era potencialmente infinito. |
| Rechazo Técnico pasa por reviewer antes de CP-03 | El cliente no debe ver artefactos reworkeados que no pasaron la verificación de consistencia estructural. El reviewer actúa como gate interno también en el protocolo de rechazo. |

---

### Sesión 85 — 2026-06-04

**Objetivo:** Construir la Fase 3 del 050 Vertical Harness — workflow de ciclo y conectores.

**Trabajo realizado:**
- Creación de `templates/workflows/ciclo_050_vertical.md` — ciclo completo de interacción con 6 pasos (A–F):
  - **Paso A:** PRECONDICIÓN (ADJ-34), invoke governor INIT, ramificación completa de 10 GOVERNOR_RESULT posibles: SPRINT_CONTRACT_READY, RESUME_AT_EXECUTE, RESUME_AT_CP03, RESUME_AT_CP04, CLOSURE_READY, PHASE_COMPLETE_READY (nuevo — trigger del Cierre Total), RESUME_AT_060_HANDOFF (nuevo — handoff 060 pendiente con pregunta inline), SUSPEND_DETECTED (con instrucción /forge-continue), RESUME_HOLD, ALREADY_COMPLETE, INIT_FAILED.
  - **Paso B:** Loop de Sprint Contract — mismo patrón que 040 pero con mención de los 17 inputs.
  - **Paso C:** Ejecución técnica con EXECUTION_COMPLETE / EXECUTION_FAILED.
  - **Paso D:** Gate CP-03 con los 5 artefactos de la slice activa. Rework + forge-override incluidos.
  - **Paso E:** Gate CP-04 formal (LL-25). Ramificación de 5 GOVERNOR_RESULT posibles.
  - **Paso F:** Bifurcado en dos sub-secciones:
    - **Cierre de Slice** — presenta resultado de auditoría, pregunta sobre handoff 060, invoca CLOSE con close_type: SLICE. Maneja SLICE_DOCS_READY/DEPLOYED (reiniciar sesión) y PENDING_HANDOFF (diferido).
    - **Cierre Total** — invoca CLOSE con close_type: TOTAL, maneja PHASE_COMPLETE.
- Actualización de `templates/client-project-CLAUDE.md`:
  - Agregado `ciclo_050_vertical.md` al índice de workflows al inicio.
  - Bloque completo de routing del 050 después del bloque 040: PENDING_HANDOFF (ofrecer deploy + verificar `vertical-governor.md`), DEPLOYED (ejecutar ciclo_050 directamente), handoff interrumpido (volver al cierre del 040).
  - Bloque `050_vertical` activo y no PHASE_COMPLETE → ejecutar ciclo_050.
  - "Todos completos" movido al final del bloque del 050.
- Corrección de `deploy-harness.ps1` — línea 14: `'050' = 'iteration'` → `'050' = 'vertical'`.

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| PHASE_COMPLETE_READY en Paso A → Cierre Total inline | El Paso A detecta esta señal (que viene de E10-B CHECK 3) y desvía directamente a la sub-sección Cierre Total del Paso F, sin pasar por B–E. Es el único camino al Cierre Total — limpio y sin ambigüedad. |
| RESUME_AT_060_HANDOFF con pregunta inline en Paso A | En lugar de delegar al ciclo de Cierre de Slice, el Paso A presenta la pregunta directamente e invoca CLOSE si el usuario acepta. Evita tener que duplicar el gate de decisión en el Paso F. |
| SUSPEND_DETECTED instrucción /forge-continue | Patrón consistente con la Sesión 73 — el ciclo informa y detiene; /forge-continue es el mecanismo de reanudación explícita, no el ciclo. |
| Cierre de Slice reutilizable desde Paso A y Paso E | El bloque "Retorno de Cierre de Slice" en Paso F es referenciado desde dos puntos: POST_CP04→CLOSURE_READY (Paso E) y RESUME_AT_060_HANDOFF (Paso A). La nota de llegada en la sub-sección lo deja explícito. |
| deploy-harness.ps1: 1 línea, sin otros cambios | El script ya era completamente genérico — solo el mapa de nombres necesitaba corrección. |

---

### Sesión 84 — 2026-06-04

**Objetivo:** Completar la Fase 2 del 050 Vertical Harness — crear el último agente faltante: `vertical-governor.md`.

**Trabajo realizado:**
- Creación de `.claude/agents/vertical-governor.md` — Instancia A: governor del 050. 6 modos:
  - **INIT**: Paso 0 verifica precondición del 040 (PHASE_COMPLETE). E10-A inicializa `050_vertical` en harness-state.json con el dict `slices` {VS-xx: PENDING} extraído del roadmap, crea `/050_vertical/`, selecciona primera slice activa, inicializa execution-state.json. E10-B con 4 verificaciones previas en orden obligatorio: SUSPENDED → AUDIT_PENDING → SLICE_COMPLETE del 070 (selecciona siguiente PENDING o retorna PHASE_COMPLETE_READY) → PENDING_HANDOFF al 060. Tabla de reanudación con 8 estados. Sprint Contract construcción por slice con los 17 inputs.
  - **EXECUTE**: Registra aprobación, spawea orchestrator (PLAN), spawea vertical-analyst con los 17 inputs y el ID de slice activa, registra CP-01, spawea vertical-writer con 6 inputs de referencia, registra CP-02, spawea vertical-reviewer. Lógica de rework automático si CRITICAL_COUNT > 0.
  - **POST_CP03**: Procesa approved/rework. En rework: spawea vertical-writer con los cambios + referencia a review_report.md.
  - **POST_CP04**: Paso 1 obligatorio — edita `Estado: DRAFT → APROBADO POR CLIENTE` en los 5 artefactos antes de cualquier otro paso (LL-17/LL-23). Registra AUDIT_PENDING (LL-16). Spawea vertical-evaluator. Filtra verdict.json por `"phase": "050_vertical"` Y `"slice_id": "<VS-xx activa>"` — doble filtro obligatorio.
  - **CLOSE**: Dos variantes por `close_type`. SLICE: PRECONDICIÓN ABSOLUTA LL-20 con doble check (phase + slice_id), marca DOCS_READY, actualiza knowledge, commit, handoff al 060 (DEPLOYED o PENDING_HANDOFF). TOTAL: verifica que todas las slices son SLICE_COMPLETE, marca PHASE_COMPLETE, knowledge cross-slice, commit.
  - **SUSPEND**: Tabla de 5 estados, bloque suspension con 6 campos.
- Decisión: en E10-B, el Cierre Total no se ejecuta inline — se retorna PHASE_COMPLETE_READY y el ciclo llama CLOSE con close_type: TOTAL. Patrón consistente con governors anteriores.

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| E10-B CHECK 3: SLICE_COMPLETE en orden antes de la tabla | La detección del handshake 070→050 se hace como verificación previa (igual que SUSPENDED y AUDIT_PENDING) antes de la tabla general, para garantizar que siempre se procesa. |
| PHASE_COMPLETE_READY devuelto por E10-B, ejecutado por CLOSE TOTAL | La consistencia con el patrón de governors (E10-B solo retorna señales, no ejecuta trabajo) es más importante que evitar el round-trip. |
| LL-20 verifica phase Y slice_id | En el CLOSE SLICE, la precondición absoluta verifica ambos campos de eval/verdict.json — `"phase": "050_vertical"` y `"slice_id": "<active_slice>"` — para no confundir auditorías de slices distintas. |
| handoff_060 como campo único (no por slice) | Se sobreescribe en cada cierre de slice. El estado de cada slice individual está en el dict `slices[VS-xx]`. El campo `handoff_060` representa el último handoff iniciado. |
| client_approval reseteado en EXECUTE | Al aprobar el Sprint Contract de una nueva slice, el governor limpia `client_approval` (CP-03 y CP-04 a null) para que la nueva slice comience con aprobaciones limpias. |

---

### Sesión 83 — 2026-06-04

**Objetivo:** Construir la Fase 2 del 050 Vertical Harness — los primeros 5 de los 6 agentes.

**Trabajo realizado:**
- Creación de `.claude/agents/vertical-analyst.md` — Worker 1: lee los 17 inputs en el orden del protocolo (glosario primero → fuente principal I-1 → previas I-17), ejecuta las 6 tareas de extracción filtradas por la slice activa, self-checklist de 12 condiciones, Write de `050_vertical/VS-xx/slice_analysis_report.md` como primer tool call (LL-01). 3 estados de retorno: COMPLETED / INCOMPLETO / ESCALAMIENTO REQUERIDO.
- Creación de `.claude/agents/vertical-writer.md` — Worker 2: lee 7 inputs en orden (glosario → listas canónicas → ADR-001 → test_strategy_map → vertical_slice_plan → slice_analysis_report), produce los 5 artefactos en orden obligatorio con Write inmediato tras cada uno (LL-01), verificación cruzada V1-V6 con Edit, self-checklist de 13 condiciones. La firma técnica del SDD es canónica y heredada por los demás artefactos.
- Creación de `.claude/agents/vertical-reviewer.md` — Control pre-CP-03: mentalidad Abogado del Diablo, 4 verificaciones (V1: cobertura IC-xx; V2: cobertura BDD scenarios; V3: firma técnica canónica entre SDS/SDD/testing_plan/execution_plan; V4: TDD explícito — Red phase nombrada y TA-Red/Green/Refactor por Ticket). Clasificación CRITICAL/MINOR con cita obligatoria. Write de `review_report.md` como primer tool call (LL-01).
- Creación de `.claude/agents/vertical-evaluator.md` — Auditor independiente (Instancia C): PATHS DE SALIDA (LL-03) al inicio, solo escribe en `eval/`. Fase 1 análisis pros + contras por D1-D5 antes de cualquier score (LL-07). D1 (Proposal & SDS Coverage), D2 (SDD Technical Depth), D3 (Testing Plan TDD Traceability), D4 (Execution Plan Actionability), D5 (Consistency). Regla de veto D5=0.0 con 5 ejemplos del dominio La Terraza. verdict.json con `"phase": "050_vertical"` Y `"slice_id": "VS-xx"` obligatorios.
- Creación de `.claude/agents/vertical-orchestrator.md` — Instancia B (sin Agent tool): 4 modos (PLAN/CHECKPOINT-01/CHECKPOINT-02/WORKER_FAILED). Modo PLAN: lee `active_slice` de harness-state.json, determina starting_point comparando slice_activa con la activa actual, resuelve los 17 inputs en disco (LL-09) con I17 como path de slices previas completadas, construye Demo Statements canónicos con el ID real de la slice interpolado, persiste orchestration_plan completo. Modo CHECKPOINT: protocolo 5 pasos (LL-06).

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| vertical-reviewer: lógica inline sin protocol skill | A diferencia de analyst, writer y evaluator (que tienen skills de protocolo), el reviewer opera con lógica inline igual que planning-reviewer. Las 4 verificaciones (V1-V4) están directamente en el agente. |
| V3 del reviewer: firma técnica canónica | La verificación más crítica: SDS, SDD, testing_plan y execution_plan deben usar los mismos nombres de interfaces y métodos. El SDD define los nombres canónicos — cualquier variante (ej. `getById` vs `findById`) es CRITICAL. |
| evaluation_version en evaluator cuenta por phase+slice_id | En un proyecto con N slices, el array de verdict.json acumula N×M entradas. Contar solo las entradas con el mismo `slice_id` evita confundir versiones entre slices distintas. |
| I17 en orchestrator resuelto como directorio de previas | I17 no es un archivo único sino el path de la carpeta de slices previas en SLICE_COMPLETE. Para VS-01 es `null`; para VS-N son los directorios de las slices anteriores completadas. |
| Demo Statements con slice_activa interpolada | Los Demo Statements del orchestrator incluyen el ID real de la slice (ej. `VS-02`) en el texto. El governor puede verificar el artefacto correcto al recibir el resultado del worker. |

---

### Sesión 82 — 2026-06-04

**Objetivo:** Completar la Fase 1 del 050 Vertical Harness — las 4 skills restantes de las 8 base.

**Trabajo realizado:**
- Verificación de `vertical-rubric` — correctamente escrita en Sesión 81 (punto de retoma cumplido).
- Creación de `.claude/skills/vertical-verdict-schema/SKILL.md` — schema de `eval/verdict.json`
  (con campos `"phase": "050_vertical"` y `"slice_id": "VS-xx"` obligatorios) y `eval/metrics_summary.json`
  (entrada por slice con métricas objetivas: IC-xx en slice, BDD scenarios en slice, Red phase explícita,
  IC-xx sin task, tasks sin referencia, etc.). Regla clave: `evaluation_version` cuenta entradas con
  mismo `phase` Y `slice_id` — no el total del array. Nota sobre arrays multi-slice: siempre filtrar
  por `slice_id` al leer la última entrada.
- Creación de `.claude/skills/vertical-analyst-protocol/SKILL.md` — protocolo de extracción
  enfocado en la slice activa. Orden de 17 inputs: domain context primero → 040 planning para scope
  de la slice → 030 técnico → 020 BDD/AC/errores → slices previas (I-17). 6 tareas: definición de
  slice (con precondición de dependencias predecesoras), IC-xx de la slice (de I-5 filtrados por I-1),
  BDD scenarios (con AC de I-11 y políticas de I-12), riesgos (de I-3), dependencias con slices
  previas (de I-2 + I-6 + I-17), restricciones y stack (de I-13..I-16 + I-7). Criterio de done y
  límite de 2 iteraciones antes de escalamiento.
- Creación de `.claude/skills/vertical-writer-protocol/SKILL.md` — protocolo de transformación
  analysis→5 artefactos. Reglas por artefacto (proposal→SDS→SDD→testing_plan→execution_plan),
  orden TDD obligatorio en execution_plan (TA-Red/TA-Green/TA-Refactor por Ticket), regla de firma
  técnica canónica (el SDD define los nombres, todos los demás los heredan), 6 verificaciones cruzadas
  (V1 firma canónica, V2-V3 cobertura IC-xx y BDD, V4 sin IDs inventados, V5 lenguaje ubicuo, V6 TDD
  explícito), self-checklist del Demo Statement.
- Creación de `.claude/skills/vertical-evaluator-protocol/SKILL.md` — protocolo D1-D5 con
  procedimientos de verificación para los 5 artefactos de la slice activa. D1 (proposal + SDS:
  check cruzado IC-xx y BDD scenarios vs. vertical_slice_plan.md), D2 (SDD: firma completa vs.
  contract_definitions.md), D3 (testing_plan: mock/stub vs. test_strategy_map.md + Red phase
  explícita), D4 (execution_plan: IC-xx en ≥1 Task + TDD order + Criterio de Done con IDs), D5
  (consistency: firma canónica entre 5 artefactos + IDs vs. fuentes externas + scope de la slice +
  lenguaje ubicuo). Bloque PATHS DE SALIDA — OBLIGATORIO (LL-03) al final.

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| evaluation_version por (phase + slice_id) | En un proyecto con N slices, el array de verdict.json acumula N×M entradas (N slices × M ciclos de rework cada una). Contar solo las entradas con el mismo slice_id evita confundir versiones entre slices distintas. |
| Orden de inputs del analyst: 040 antes de 030 técnico | I-1 (vertical_slice_plan.md) debe leerse antes que I-5 (contract_definitions.md) para establecer el filtro de scope de la slice. Sin ese filtro, el analyst puede cargar todo el 030 sin saber cuáles IC-xx son relevantes. |
| Firma técnica canónica en writer-protocol | El SDD es quien define los nombres de métodos e interfaces — no la SDS ni el execution_plan. Todos los artefactos posteriores heredan esos nombres del SDD. Esta regla previene el D5=0.0 por variantes de nombres entre artefactos. |
| TA-Red/Green/Refactor en execution_plan | Cada Ticket tiene ≥3 Tasks en orden TDD explícito. TA-Refactor puede decir "Sin refactor en esta iteración" pero siempre debe estar documentado como decision consciente, no como omisión. |
| vertical-evaluator-protocol incluye PATHS DE SALIDA | Sección explícita (LL-03) al final del protocolo — C nunca escribe en /050_vertical/, solo en eval/. Añadido a la luz de la experiencia con el evaluator del 010 que requirió corrección LL-03. |

---

### Sesión 81 — 2026-06-04

**Objetivo:** Construir la Fase 1 del 050 Vertical Harness — 8 skills base.

**Trabajo realizado:**
- Creación de `.claude/skills/vertical-state-schema/SKILL.md` — schema de `harness-state.json` entrada `"050_vertical"` (con `slices` dict PENDING/DOCS_READY/SLICE_COMPLETE, `active_slice`, `sprint_contract` con 17 inputs I-1..I-17, `overrides`, `suspension`, `handoff_060`) + `execution-state.json` con `orchestration_plan` incluyendo `active_slice` en el plan, 5 `artifacts` (proposal, SDS, SDD, testing_plan, execution_plan), Single Writer Rule, nota de escritura cross-harness del 070.
- Creación de `.claude/skills/vertical-analysis-schema/SKILL.md` — schema de `slice_analysis_report.md` con 6 secciones: Definición de la Slice, IC-xx completos (firma + DTOs + mock strategy), BDD Scenarios (AC + política de error), Riesgos RK-xx, Dependencias con slices previas, Restricciones y Stack. Incluye reglas de no-inferencia, verificaciones de cobertura y self-checklist.
- Creación de `.claude/skills/vertical-synthesis-schema/SKILL.md` — schema de los 5 artefactos finales con bloque RUTA DE ESCRITURA OBLIGATORIO (LL-29), orden de producción obligatorio (proposal→SDS→SDD→testing_plan→execution_plan), LL-01 en proposal, estructura detallada de cada artefacto, verificación cruzada entre los 5 y reglas de escritura (firma técnica consistente entre artefactos, LL-17).
- Creación de `.claude/skills/vertical-rubric/SKILL.md` — rúbrica D1-D5 con anclas 0.2/0.5/0.8/1.0 calibradas en dominio La Terraza/VS-02, regla de gate ≥0.75, regla de veto D5=0.0 con 5 ejemplos concretos del dominio La Terraza.

**Pendiente (Fase 1 completa en Sesión 82):**
- `vertical-verdict-schema` — verdict.json con `slice_id` + metrics_summary.json
- `vertical-analyst-protocol` — protocolo de extracción por slice
- `vertical-writer-protocol` — transformación analysis→5 artefactos
- `vertical-evaluator-protocol` — verificación D1-D5 + cross-checks

**NOTA PARA RETOMA:** Al iniciar la próxima sesión, verificar que `vertical-rubric` fue escrita correctamente antes de continuar con `vertical-verdict-schema`.

---

### Sesión 80 — 2026-06-04

**Objetivo:** Construir la Fase 0 del 050 Vertical Harness — el harness canónico con estructura completa.

**Trabajo realizado:**
- Creación de `Harnesses/050_vertical_harness.md` — harness operativo completo con las 7 secciones canónicas: Fase 0 (propósito, precondición, naturaleza iterativa, 17 inputs, 5 pasos, 5+2 outputs, criterios de Done por slice y total, ciclo adaptado), Fase 1 (4 instancias con tabla de roles, 2 workers con Demo Statements y Pending Verification, política de herramientas, escalamiento, 5 checkpoints, trigger de context reset), Sprint Contract (plantilla por slice), Rúbrica D1-D5 (anclas 0.2/0.5/0.8/1.0 calibradas en dominio La Terraza / VS-02), Handoff al 060 (árbol de artefactos, ciclo de vida por slice), Flujo 12.1–12.5 (E10-A/E10-B con tabla por estado de slice, auditoría con verificación LL-20 por slice_id, cierre de slice + cierre total).

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| Patrón idéntico al 040 | Mismas 7 secciones, misma numeración 12.x, mismo estilo de tablas. La única diferencia estructural es el cierre de 12.5 en dos sub-secciones (Cierre de Slice + Cierre Total) debido a la naturaleza iterativa del 050. |
| Reviewer incluido en 1.1 | Instancia D (vertical-reviewer) documentada en la tabla de instancias y en 1.5 (checkpoints), igual que el 040. |
| Tabla de continuación E10-B para el 050 | 6 filas que cubren todos los estados posibles de la slice: SLICE_COMPLETE (llegada del 070), AUDIT_PENDING, CP-02/EXECUTION_COMPLETE, CP-01, ACTIVE sin CP, PENDING_CONTRACT. |
| LL-20 extendida a slice_id | La verificación obligatoria pre-cierre requiere que eval/verdict.json tenga entrada con `"phase": "050_vertical"` Y `"slice_id": "[VS-xx activa]"` — ambos campos necesarios para no confundir auditorías de slices distintas. |

---

### Sesión 79 — 2026-06-04

**Objetivo:** Analizar las dos opciones de diseño del 050 Vertical Harness (batch vs. iterativo) y construir el blueprint completo.

**Trabajo realizado:**
- Confirmación de decisiones de diseño: nombre "050 Vertical Harness", 5 artefactos (proposal, SDS, SDD, testing_plan, execution_plan), 060 Isolation limitado a slice activa, 070 Development Harness.
- Análisis formal Opción A vs. Opción B: Opción B (iterativo slice a slice, 050→060→070→050→...) elegida por ser más resiliente a cambios del 100 Change Harness y alineada con el principio "una slice a la vez" del 040.
- Creación de `plans/050_vertical_harness.md` — blueprint completo con 7 secciones: Fase 0 (17 inputs, 5 pasos, criterio de Done por slice y total), Fase 1 (6 sub-secciones incluyendo Demo Statements y Pending Verification), Sprint Contract (por slice), Rúbrica D1-D5 (con anclas 0.2/0.5/0.8/1.0 en dominio La Terraza), Handoff al 060, Flujo 12.1–12.5 (Cierre de Slice + Cierre Total).
- `support/ajustes.md` — ADJ-05 actualizado a PARCIAL, ADJ-06 y ADJ-07 a DISEÑADO, con detalle de decisiones tomadas.
- `support/avance.md` — actualizado con Sesión 79 y árbol del repositorio.

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| Opción B — iterativo slice a slice | El 100 Change Harness puede modificar slices futuras durante la construcción → producir docs de todas las slices por adelantado (Opción A) genera trabajo que puede quedar obsoleto. La Opción B produce just-in-time. |
| `slices` dict en harness-state.json | `{ "VS-01": "PENDING", "VS-02": "DOCS_READY", ... }` — el governor conoce el estado de cada slice sin leer los artefactos. Estado más explícito que inferir desde archivos. |
| Handshake 070→050 como única escritura cross-harness | El 070 Development Harness escribe `SLICE_COMPLETE` en `"050_vertical.slices.VS-xx"` al cerrar. Es la única escritura cross-harness permitida en FORGE — documentada explícitamente para ser prescrita en el blueprint del 070. |
| Evaluador filtra por `slice_id` | `eval/verdict.json` acumula entradas de N slices; la verificación LL-20 busca `"phase": "050_vertical"` y `"slice_id": "VS-xx"` — ambos campos necesarios para no confundir auditorías de slices distintas. |
| Output path `/050_vertical/VS-xx/` | Subcarpeta por slice evita colisiones de nombres entre artefactos (cada slice tiene su propio `proposal.md`). El governor crea la subcarpeta en E10-A/E10-B antes de spawear workers. |
| IDs locales FT-xx, TK-xx, TA-xx | Nuevos en el 050 — Features, Tickets y Tasks del execution_plan. Locales a cada slice; se prefiján con el ID de slice (VS-02-FT-01) si necesitan referenciarse desde otras slices. |

---

### Sesión 78 — 2026-06-04

**Objetivo:** Registrar e implementar los bugs críticos detectados durante Test_Harness_002: ADJ-37 (nuevo), ADJ-36, ADJ-33, ADJ-34 y ADJ-32.

**Trabajo realizado:**
- `support/ajustes.md` — ADJ-37 registrado: discovery-governor pregunta si pasar al 020 antes de haber escrito eval/ y knowledge/.
- `.claude/agents/discovery-governor.md` — dos cambios:
  - POST_CP04: verificación post-evaluador — si `eval/verdict.json` no existe tras spawear el evaluador, retorna `AUDIT_FAILED` en lugar de continuar silenciosamente.
  - Modo CLOSE: restructurado en dos fases. Fase 1 (sin `handoff_decision`): escribe `knowledge/lessons_learned.md` y `knowledge/decisions_library.md`, hace el commit, retorna `CLOSE_READY` con el verdict completo. Fase 2 (con `handoff_decision`): verifica `PHASE_COMPLETE` y ejecuta el deploy.
- `templates/workflows/ciclo_010_discovery.md` — Paso E: agrega manejo de `AUDIT_FAILED`. Paso F: restructurado en tres fases (Fase 1 invoca CLOSE sin decision → Fase 2 muestra AskUserQuestion con verdict real → Fase 3 invoca CLOSE con decision).
- `templates/client-project-CLAUDE.md` (ADJ-36) — los 3 bloques PENDING_HANDOFF (020/030/040) ahora ejecutan `Test-Path` del governor correspondiente tras el deploy. Solo escriben `DEPLOYED` si la verificación pasa; si falla, notifican el comando manual sin actualizar el estado.
- `commands/forge-restart.md` (ADJ-33) — Prioridad 1 dividida en 1a (DEPLOYED) y 1b (PENDING_HANDOFF nueva): pregunta al usuario, ejecuta deploy, verifica governor, escribe DEPLOYED solo si pasa.
- `commands/forge-restart.md` (ADJ-34) — nuevo Paso 4 de verificación: antes de ejecutar el ciclo, comprueba que `.claude/agents/<governor>.md` existe; si no, detiene con mensaje exacto y comando de deploy.
- `templates/workflows/ciclo_010..040.md` (×4) (ADJ-34) — precondición al inicio del Paso A en cada ciclo: `Test-Path` del governor, detención total si no existe.
- `commands/forge-restart.md` (ADJ-32) — Paso 5 restructurado con bloques **OBLIGATORIO** (secuencia de 3 pasos) y **PROHIBIDO** (4 acciones explícitas que no puede hacer el modelo, incluyendo Agent tool directo y ejecución inline).
- `.claude/agents/discovery-dialoguer.md` + `support/lessons_learned.md` — LL-29 registrada y bloque "RUTA DE ESCRITURA — OBLIGATORIO" agregado al dialoguer (hallazgo de Test_Harness_002: el dialoguer creó `persistence/transcript/transcript_S01.md` en lugar de `010_discovery/dialogue_transcript.md`).
- `support/ajustes.md` — ADJ-32, ADJ-33, ADJ-34, ADJ-36, ADJ-37 marcados como IMPLEMENTADO.
- Commit: `89404b4` — 10 archivos, 387 inserciones.

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| CLOSE en dos fases (ADJ-37) | La pregunta de handoff debe mostrarse después de que knowledge/ y eval/ existen y están commiteados, no antes. La Fase 1 hace todo el trabajo y retorna CLOSE_READY con el verdict; el ciclo muestra la pregunta; la Fase 2 solo ejecuta el deploy. |
| forge-restart Prioridad 1a/1b (ADJ-33) | DEPLOYED y PENDING_HANDOFF son estados distintos que requieren flujos distintos. Separar en 1a y 1b es más claro que anidar condiciones. |
| forge-continue no se modifica (ADJ-32) | forge-continue invoca el governor directamente con el modo conocido — ese comportamiento es correcto por diseño. Solo forge-restart tenía el problema de saltarse el ciclo. |
| OBLIGATORIO + PROHIBIDO en lugar de una línea negativa (ADJ-32) | Cuatro prohibiciones concretas son más difíciles de ignorar que "No spawear el governor directamente". El modelo necesita instrucción afirmativa (qué hacer) y negativa (qué no hacer) separadas. |
| Verificación doble para ADJ-34 | forge-restart Paso 4 detiene antes de leer el ciclo; Paso A del ciclo detiene antes de invocar el governor. Cobertura para cualquier ruta de entrada al ciclo. |

---

### Sesión 77 — 2026-06-03

**Objetivo:** Analizar el mecanismo para gestión de cambios del cliente durante la construcción, diseñar el 100 Change Harness a alto nivel, alinear ADJ-31 con ese diseño y preparar el proyecto de prueba Test_Harness_002.

**Trabajo realizado:**
- Análisis de los 3 casos de cambio durante la etapa de construcción: Caso 1 (SA — feature nunca considerada), Caso 2 (CR pre-build — feature considerada, no construida), Caso 3 (CR post-build — feature considerada y ya construida).
- Decisión: `/forge-changes` es el entry point único del 100 Change Harness — no un comando standalone. El harness clasifica el cambio, hace el impact analysis, escala al humano y ejecuta el camino de re-ejecución correcto.
- Creación de `Harnesses/100_change_harness.md` — descripción de alto nivel con 3 casos de activación, proceso de impact analysis con escalamiento obligatorio al humano, artefactos de salida (CH-xxx, artefactos upstream actualizados, plan maestro actualizado, slice lista para el 050) y ruta de salida hacia el 050.
- Actualización de `support/ajustes.md` — ADJ-31 rediseñado: describe el alineamiento `/forge-changes` = entry point del 100 Change Harness, diferencia semántica con `/forge-override`, los 3 casos y el flujo de activación. Prerequisito actualizado: construir el 100 primero.
- Selección del proyecto de prueba: sistema de reservas para restaurante "La Terraza" (3 stakeholders: Carlos Méndez/dueño, Ana Ríos/recepcionista, Miguel Torres/cliente frecuente).
- Creación de `Tests/Test_Harness_002/inputs/brief.md` — brief completo con descripción del negocio, problema central, 3 stakeholders con intereses y dolores, restricciones conocidas y alcance tentativo.
- Push a GitHub — 72 archivos commiteados (100_change_harness.md, 4 slash commands nuevos, 65 archivos con renombre ADJ-30, ajustes.md).

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| 100 Change Harness separado del 050 | Los cambios durante construcción tienen su propio harness con impact analysis y escalamiento al humano obligatorio. El 050 queda limpio: solo construye slices bien definidas. |
| `/forge-changes` = entry point del 100 | Un comando único para el usuario independientemente del tipo de cambio. La inteligencia de clasificación y routing vive en el harness. |
| ADJ-31 no se implementa como comando standalone | ADJ-31 y el 100 Change Harness van juntos — el comando se construye como parte del harness, no antes. |
| Test_Harness_002: restaurante "La Terraza" | 3 stakeholders con perspectivas genuinamente distintas y conflictivas. Restricciones reales (sin app móvil, personal no técnico, conexión inestable) que generan decisiones interesantes en el 030. |

---

### Sesión 76 — 2026-06-03

**Objetivo:** Registrar ADJ-30 y ADJ-31 como ajustes formales, e implementar ADJ-30 — renombrar las carpetas de output de todos los harnesses con prefijo numérico.

**Trabajo realizado:**
- `support/ajustes.md` — ADJ-30 y ADJ-31 registrados con tabla de estado, sección de detalle completa, impacto y prerequisitos.
- Batch replacement con PowerShell sobre 65 archivos operacionales (excluyendo `support/`):
  - `discovery/` → `010_discovery/` en todos los agentes, skills, harnesses, plans, workflows, commands y README
  - `specification/` → `020_specification/` ídem
  - `design/` → `030_design/` ídem
  - `plan/` → `040_planning/` ídem
- Verificación con regex que no quedaron referencias antiguas en archivos operacionales.
- `forge-setup.ps1` ejecutado para reinstalar los comandos globales actualizados.
- `support/ajustes.md` — ADJ-30 marcado como IMPLEMENTADO.

**Archivos modificados (65 en total):**
- `.claude/agents/` — 24 agentes (todos los de 010, 020, 030, 040)
- `.claude/skills/` — 27 skills (todas las de los 4 harnesses)
- `templates/workflows/ciclo_010..040.md` (×4)
- `templates/client-project-CLAUDE.md`
- `Harnesses/010..040_*.md` (×4)
- `plans/010..040_*.md` (×4)
- `commands/forge-suspend.md`, `commands/forge-continue.md`
- `README.md`

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| Reemplazo via trailing slash | El patrón `discovery/` (con `/`) evita falsos positivos en `discovery-governor`, `design-analyst`, `planning` (texto) y `plans/` (directorio del repo). Seguro para todos los casos. |
| Excluir `support/` del batch | Los archivos de soporte son documentación histórica — las sesiones anteriores referencian las rutas antiguas como evidencia de decisiones. No tiene sentido actualizarlas. |
| `deploy-harness.ps1` sin cambios | El mapa `'010' = 'discovery'` no usa trailing slash — no fue afectado. Las carpetas de output las crean los governors en runtime, no el script de deployment. |
| Reinstalar comandos post-update | `forge-suspend.md` y `forge-continue.md` referenciaban `discovery/dialogue_transcript.md` → actualizado a `010_discovery/dialogue_transcript.md`. Reinstalación vía `forge-setup.ps1` propaga el cambio a `~/.claude/commands/`. |

---

### Sesión 75 — 2026-06-03

**Objetivo:** Implementar ADJ-29 — comando `/forge-override` para que el usuario registre un desacuerdo con una decisión del harness como restricción vinculante.

**Trabajo realizado:**
- Análisis completo del flujo: identificados los dos momentos naturales de override (Sprint Contract Paso B y CP-03 Paso D) y la diferencia semántica con el "rework" normal (override = restricción vinculante registrada + propagada; rework = corrección de calidad sin registro).
- Diseño acordado: texto inline en el comando (A1), doble persistencia harness-state.json + overrides.md (B3), propagación a harnesses futuros vía overrides.md en E10-A (C2).
- Creación de `commands/forge-override.md` — slash command global con 8 pasos: extrae texto, timestamp, verifica harness activo, genera ID (OV-xxx), escribe en harness-state.json, crea/appenda overrides.md, loguea en claude-progress.txt, retorna FORGE_OVERRIDE_RESULT para que el ciclo continúe.
- Modificación de los 4 ciclos (ciclo_010..040.md): agregado caso `/forge-override` en Paso B (Sprint Contract) → re-invoca governor con adjustment_request; y en Paso D (CP-03) → re-invoca governor con cp03_decision: rework + changes = constraint_str.
- Modificación de los 4 governors (discovery, specification, design, planning): agregado E10-A.7/E10-A.8 — lee `persistence/overrides.md` si existe, extrae overrides ACTIVE, los incorpora como constraints duros en el Sprint Contract bajo "Overrides del usuario (vinculantes)".
- Modificación de los 4 state schemas: campo `"overrides": []` documentado en el JSON de ejemplo con schema completo del objeto override.
- Instalación de `forge-override.md` en `~/.claude/commands/`.
- `support/ajustes.md` — ADJ-29 marcado como IMPLEMENTADO con detalle completo.

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| Texto inline (A1) | El usuario escribe `/forge-override "texto"` — más robusto que inferir del contexto de la conversación |
| Doble persistencia (B3) | harness-state.json para que la máquina lo lea; overrides.md como audit trail legible y accesible a futuros harnesses |
| Propagación vía overrides.md en E10-A (C2) | Cada governor lee el archivo en su inicio de fase y aplica los constraints duros en el Sprint Contract — sin "Modo OVERRIDE" separado en los governors |
| No "Modo OVERRIDE" en governors | El override se pasa inline como adjustment_request (INIT) o changes (POST_CP03) con el marker [OVERRIDE VINCULANTE — OV-xxx] — los modos existentes son suficientes |

---

### Sesión 74 — 2026-06-03

**Objetivo:** Implementar ADJ-28 — transición automática entre harnesses sin reinicio manual dentro de la misma sesión. Crear `/forge-restart` como comando post-reinicio universal.

**Trabajo realizado:**
- Análisis completo del mecanismo existente: los governors (010..040) ya tenían el Paso 6 del CLOSE con deploy del siguiente harness + `HANDOFF_READY`. Los ciclos ya instruían al usuario a reiniciar. El `client-project-CLAUDE.md` ya tenía el path `DEPLOYED` que arranca automáticamente al reiniciar.
- Identificación del bug: el path `PENDING_HANDOFF` en `client-project-CLAUDE.md` desplegaba los agentes y luego intentaba arrancar el ciclo siguiente **en la misma sesión** — los agentes recién copiados no están cargados → error "no reconocidos".
- Corrección de los 3 casos `PENDING_HANDOFF` en `templates/client-project-CLAUDE.md` (handoff_020, handoff_030, handoff_040): ahora deploya → actualiza status a `DEPLOYED` → notifica al usuario que reinicie → Fin. En la siguiente sesión el path `DEPLOYED` arranca el ciclo correctamente con agentes cargados.
- Creación de `commands/forge-restart.md` — slash command global `/forge-restart`: lee `harness-state.json`, detecta el harness con `DEPLOYED` o el harness activo en progreso, y arranca el ciclo correspondiente. Sirve como comando universal "¿dónde estaba?" — funciona post-reinicio, post-handoff y en cualquier momento que el usuario quiera retomar el proyecto.
- Actualización de mensajes de reinicio en 4 governors (discovery, specification, design, planning) y 4 ciclos (ciclo_010..040): de "Reiniciar la sesión" a "Reinicia la sesión y ejecuta /forge-restart".
- Actualización de 3 casos `PENDING_HANDOFF` en `client-project-CLAUDE.md` con el mismo mensaje.
- `commands/forge-restart.md` instalado en `~/.claude/commands/` vía PowerShell.
- `support/ajustes.md` — ADJ-28 marcado como IMPLEMENTADO con detalle completo de la solución.

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| Restart como frontera de fase (no como bug) | Un reinicio al cerrar un harness es deseable: limpia el contexto de la fase anterior y carga solo los agentes del nuevo harness. Evita inflar el contexto con agentes de fases no activas. |
| No pre-deployar todos los harnesses en forge-setup.ps1 | Descartado porque aumenta el contexto desde el inicio de cada sesión con agentes que no se usarán. |
| Bug era solo en PENDING_HANDOFF, no en HANDOFF_READY | El path HANDOFF_READY (cierre en sesión activa) ya funcionaba: deploy + mensaje + Fin. Solo PENDING_HANDOFF (handoff diferido, sesión nueva) tenía el defecto de continuar en la misma sesión tras el deploy. |
| /forge-restart como comando universal post-reinicio | El usuario necesita escribir algo al abrir Claude. /forge-restart da un comando claro y memorable en lugar de "escribe cualquier cosa". También sirve para retomar el proyecto en cualquier momento sin recordar el estado exacto. |
| Mapa de comandos de reanudación | `/forge-suspend` + `/forge-continue` = par para interrupciones mid-harness. `/forge-restart` = comando post-reinicio y universal de retoma. |

---

### Sesión 73 — 2026-06-03

**Objetivo:** Verificar ADJ-26 en producción, corregir la brecha de CP-03 en forge-suspend e implementar ADJ-27 como /forge-continue.

**Trabajo realizado:**
- Diagnóstico: `forge-suspend.md` existía en `commands/` del repo pero no había sido copiado a `~/.claude/commands/` — por eso no aparecía como slash command.
- `forge-setup.ps1` — refactorizado para copiar automáticamente todos los `.md` de `commands/` sin array hardcodeado. Ya no requiere modificación al agregar nuevos comandos.
- `commands/forge-suspend.md` — dos correcciones: (1) agregado Paso B de override obligatorio para detectar CP-03 ya aprobado (`client_approval.CP-03_draft_review != null` → fuerza `governor_mode: POST_CP04`); (2) mensaje de confirmación actualizado de `/forge-resume` a `/forge-continue`.
- `commands/forge-continue.md` — nuevo slash command global (renombrado desde /forge-resume por decisión del usuario): verifica suspensión activa, limpia el bloque `suspension`, restaura el `status` según el `governor_mode` (tabla de 5 casos), mapea el harness al governor correspondiente e invoca el governor con el modo correcto.
- Ejecución de `forge-setup.ps1` — instalados los 4 comandos: `/forge-init`, `/forge-discovery`, `/forge-suspend`, `/forge-continue`.
- Test end-to-end: `/forge-init` → `/forge-discovery` → `/forge-suspend` → `/forge-continue` — el ciclo completo funcionó. El governor tomó el control y presentó el Sprint Contract al reanudar.
- `support/ajustes.md` — ADJ-26 y ADJ-27 marcados como IMPLEMENTADO con nombres correctos (`/forge-suspend` y `/forge-continue`).

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| Nombre: `/forge-continue` | El usuario prefirió este nombre sobre `/forge-resume`. Sigue la convención de verbos de acción de FORGE. |
| forge-setup.ps1 genérico | Eliminar el array hardcodeado evita tener que editar el script cada vez que se agrega un comando nuevo — `Get-ChildItem *.md` copia todo automáticamente. |
| Brecha CP-03 corregida con Paso B | La tabla base no podía distinguir "esperando CP-03" de "CP-03 ya aprobado". El Paso B lee `client_approval.CP-03_draft_review` directamente y hace el override a POST_CP04 si ya fue aprobado. |
| Restauración de status por governor_mode | INIT → PENDING_CONTRACT; todos los demás → ACTIVE. Garantiza que E10-B del governor no retorne SUSPEND_DETECTED al encontrar status limpio. |

---

### Sesión 72 — 2026-06-03

**Objetivo:** Implementar ADJ-26 — comando `/forge-suspend` para suspensión ordenada de harnesses activos.

**Trabajo realizado:**
- Creación de `commands/forge-suspend.md` — slash command global `/forge-suspend` con 8 pasos: timestamp real, verificación de harness activo, identificación del harness más reciente sin PHASE_COMPLETE, lectura de execution-state, detección del worker activo (caso especial dialoguer mid-interview con escritura de marcador ⏸ en transcript), construcción del bloque `suspension`, escritura en harness-state.json y registro en claude-progress.txt.
- Actualización de `forge-setup.ps1` — agregado `"forge-suspend.md"` al array `$commands` para instalación automática en `~/.claude/commands/`.
- Actualización de 4 state schemas — campo `"suspension": null` + valor `SUSPENDED` en la lista de status + schema completo del bloque suspension documentado:
  - `.claude/skills/discovery-state-schema/SKILL.md` (también: event `SUSPENSIÓN` en claude-progress.txt)
  - `.claude/skills/specification-state-schema/SKILL.md`
  - `.claude/skills/design-state-schema/SKILL.md`
  - `.claude/skills/planning-state-schema/SKILL.md`
- Actualización de 4 governors (discovery, specification, design, planning) con 3 cambios cada uno:
  1. `[MODO: SUSPEND]` agregado al listado de modos de invocación
  2. `VERIFICACIÓN PREVIA — SUSPENDED` en E10-B antes del check de AUDIT_PENDING — retorna SUSPEND_DETECTED con context_note, resume_instruction y suspended_at
  3. Sección `## Modo SUSPEND` al final del archivo — 6 pasos: timestamp, lectura de estado, tabla de inferencia governor_mode, escritura del bloque suspension, registro en claude-progress.txt, retorno SUSPENDED
- `support/ajustes.md` — ADJ-26 marcado como IMPLEMENTADO (y nombre corregido a /forge-suspend).

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| Nombre: `/forge-suspend` | Sigue la convención de naming FORGE (igual que /forge-init, /forge-discovery). El nombre original /suspend fue descartado. |
| Bloque suspension con 6 campos | {timestamp, harness, governor_mode, last_checkpoint, context_note, resume_instruction} — context_note captura el qué, resume_instruction captura el cómo reanudar |
| Caso dialoguer cubierto | /forge-suspend lee el transcript, escribe marcador ⏸ al final y captura el estado de la entrevista en context_note/resume_instruction. El dialoguer no pierde ninguna respuesta recopilada. |
| VERIFICACIÓN PREVIA SUSPENDED en E10-B | Retorna SUSPEND_DETECTED antes del check de AUDIT_PENDING para que el workflow (CLAUDE.md) gestione la interacción con el usuario |
| /forge-suspend opera sin invocar governors | El comando lee/escribe directamente los archivos de estado. Los governors tienen Modo SUSPEND para cuando son ellos los que deben iniciar la suspensión durante su propia ejecución. |

### Sesión 71 — 2026-06-03

**Objetivo:** Verificar FORGE CLI en producción y registrar 4 nuevos ajustes identificados por el usuario.

**Trabajo realizado:**
- Verificación exitosa de `/forge-init` en carpeta `Test_001` — deploy completo del harness 010 ejecutado desde dentro de Claude con un solo comando.
- Aclaración del flujo: `irm | iex` es instalación de máquina (una vez), `/forge-init` es arranque de proyecto (cada vez).
- `support/ajustes.md` — ADJ-25 marcado como IMPLEMENTADO.
- `support/ajustes.md` — ADJ-26..ADJ-29 registrados con detalle completo.

**Decisiones clave:**
| Decisión | Detalle |
|----------|---------|
| ADJ-26 /suspend | Suspensión ordenada: persiste estado, registra punto de interrupción, deja todo listo para E10-B |
| ADJ-27 /resume | Complemento de /suspend — invoca E10-B explícitamente, requiere ADJ-26 como prerequisito |
| ADJ-28 transición automática | Al cerrar un harness, el governor despliega el siguiente sin pasos manuales del usuario |
| ADJ-29 /override | Registra desacuerdo del usuario como restricción vinculante e inyecta en el harness activo; scope a definir (harness actual vs. propagación a futuros) |

---

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

### Tarea 1 — Ejecutar Test_Harness_003 (Estilo Urbano — peluquería)

**Estado:** Brief creado. Pendiente ejecutar.

Correr el flujo completo 010 → 020 → 030 → 040 → 050 con el proyecto "Estilo Urbano"
hasta que el 050 produce y aprueba la VS-01 Tracer Bullet (CP-04 + evaluator + CLOSURE_READY).

**Proyecto:** Test_Harness_003 — sistema de citas online para peluquería (vive fuera de este repo).
**Stakeholders:** Marco Ríos (dueño), Valentina Cruz (estilista), Diego Fontana (cliente).
**Objetivo del test:** validar el flujo end-to-end, detectar bugs en los 17 inputs del 050,
prompts ambiguos, rutas incorrectas y comportamiento del governor ante la primera slice real.

**Al terminar el test:** registrar bugs encontrados como ADJ-xx, corregirlos y luego
construir el 060 Isolation Harness.

### Tarea 2 — Construir el 060 Isolation Harness

El 060 Isolation Harness recibe una slice `DOCS_READY` del 050 y ejecuta el entorno de aislamiento
para el desarrollo. Su diseño aún no está definido — requiere blueprinting antes de construir.

**Estado:** Sin blueprint. Pendiente diseño y construcción.

**Prerequisito:** El plan maestro del 050 está completo. El 060 se activa slice a slice,
invocado por el governor del 050 cuando el usuario aprueba el handoff.

### Tarea 3 — Diseñar y construir el 080 Harness

El 080 Harness es el último eslabón del ciclo por slice (050→060→070→**080**). Cuando completa,
escribe `PROD_READY` en `"050_vertical.slices.VS-xx"` de `harness-state.json` — habilitando
al 090 para incluir esa slice en un deploy.

**Estado:** Sin blueprint. Pendiente definición de qué hace exactamente el 080 (staging, acceptance testing, pre-prod review, u otro).

**Prerequisito:** 060 y 070 deben estar diseñados primero para entender qué recibe el 080.

### Tarea 4 — Diseñar y construir el 090 Production Harness

El 090 gestiona el deploy a producción. Puede operar por slice individual, por grupo (DG-xx
definidos en `project_roadmap.md`) o con todas las slices. Requiere leer los Deployment Groups
del roadmap y verificar que cada grupo tiene todas sus slices en `PROD_READY` y sus predecesores
en `DEPLOYED`.

**Estado:** Sin blueprint. Pendiente construcción del 060, 070 y 080 primero.

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

### Ajustes implementados relacionados con el 040
- **ADJ-04** — IMPLEMENTADO: 040 Planning Harness construido completo (Sesiones 63-68)
- **ADJ-05** — IMPLEMENTADO: 050 Vertical Harness construido completo (Sesiones 79-85)

---

## Reglas de Actualización de este Archivo

Al terminar cada sesión de trabajo, ejecutar `/progress` o actualizar manualmente:
1. Mover los "Próximos Pasos" completados al historial de `support/history/avance_design.md`.
2. Registrar las decisiones tomadas durante la sesión.
3. Actualizar la fecha de última actualización y la Fase actual.
4. Actualizar el árbol del repositorio para reflejar el estado real.
5. Agregar los nuevos próximos pasos que emerjan.
