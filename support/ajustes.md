# Ajustes Pendientes de Implementación

Registro de ajustes identificados que aún no han sido implementados.

> **Historial completo:** ver `support/history/ajustes_design.md` (ADJ-13..ADJ-32 del 030 Design Harness).

---

## Tabla de Estado

| ID     | Descripción                                                                                                 | Prioridad     | Estado    |
| ------ | ----------------------------------------------------------------------------------------------------------- | ------------- | --------- |
| IMP-22 | No hay mecanismo de knowledge cross-project — aprendizajes no viajan entre proyectos                        | SIGNIFICATIVA | DISEÑADO — PENDIENTE IMPL. |
| IMP-28 | No existe dashboard HTML en tiempo real para observar el progreso del harness                               | MENOR         | PENDIENTE |
| ADJ-04 | Harness 040 Planning: rediseñar para trabajar bajo Vertical Slices con iteraciones                          | SIGNIFICATIVA | IMPLEMENTADO — 040 completo (Sesiones 63-68): 6 agentes, 8 skills, ciclo y conectores |
| ADJ-05 | Harness 050 Iteration: renombrar a "050 Vertical Harness" y redefinir su scope                              | SIGNIFICATIVA | IMPLEMENTADO — 050 completo (Sesiones 79-85): Fases 0-3, 6 agentes, 8 skills, ciclo y conectores |
| ADJ-06 | Harness 060 Isolation: limitar ejecución a la vertical slice / iteración activa                             | MENOR         | DISEÑADO — documentado en blueprint del 050 (Sesión 79); pendiente de implementar en el 060 |
| ADJ-07 | Harness 070 Execution: renombrar a "070 Development Harness" y reasignar numeración                         | MENOR         | DISEÑADO — nombre 070 Development Harness confirmado (Sesión 79); pendiente de construir el harness |
| ADJ-08 | README.md del proyecto: incluirlo en `deploy-harness.ps1` para que se copie al cliente                     | MENOR         | PENDIENTE |
| ADJ-12 | Meta-Harness: referencia académica para optimización automática de harnesses                                | MENOR         | PENDIENTE |
| ADJ-24 | 010 Discovery: modelo de entrevista síncrona genera latencia y limita paralelismo — evaluar modelo async con cuestionario + ronda de gaps | SIGNIFICATIVA | PENDIENTE — evaluar antes de construir el 040 |
| ADJ-25 | FORGE CLI: automatizar arranque de proyecto con forge-setup.ps1, forge.config.json y slash commands /forge-init + /forge-discovery | SIGNIFICATIVA | IMPLEMENTADO |
| ADJ-26 | Comando /forge-suspend: suspender tarea activa, persistir estado y dejar todo listo para reanudar | SIGNIFICATIVA | IMPLEMENTADO |
| ADJ-27 | Comando /forge-continue: reanudar tarea suspendida desde el último estado persistido | SIGNIFICATIVA | IMPLEMENTADO |
| ADJ-28 | Transición automática entre harnesses: al cerrar un harness, desplegar el siguiente sin pasos manuales | SIGNIFICATIVA | IMPLEMENTADO |
| ADJ-29 | Comando /forge-override: registrar desacuerdo del usuario con una decisión del harness (ej. stack tecnológico) e inyectarla como restricción vinculante | SIGNIFICATIVA | IMPLEMENTADO |
| ADJ-30 | Renombrar carpetas de output de harnesses: discovery/ → 010_discovery/, specification/ → 020_specification/, design/ → 030_design/, plan/ → 040_planning/ | SIGNIFICATIVA | IMPLEMENTADO |
| ADJ-31 | Comando /forge-changes: permite al humano solicitar cambios sobre artefactos ya producidos en cualquier punto del harness activo | SIGNIFICATIVA | PENDIENTE |
| ADJ-32 | /forge-restart invoca governors via Agent tool con subagent_type nombrado en lugar de ejecutar el ciclo paso a paso | SIGNIFICATIVA | IMPLEMENTADO |
| ADJ-33 | /forge-restart no maneja el estado PENDING_HANDOFF — modelo puede asumir DEPLOYED incorrectamente y fallar en runtime | CRÍTICA | IMPLEMENTADO |
| ADJ-34 | Fallback inseguro cuando el governor no está disponible: el modelo ejecuta el protocolo inline en lugar de detenerse con error | CRÍTICA | IMPLEMENTADO |
| ADJ-35 | Sprint contracts deben persistirse como archivos .md en carpeta contract/ (ej. contract/010_discovery.md) | MENOR | IMPLEMENTADO |
| ADJ-36 | CLAUDE.md escribe handoff status DEPLOYED sin verificar que deploy-harness.ps1 tuvo éxito — estado inconsistente si el deploy falla | CRÍTICA | IMPLEMENTADO |
| ADJ-37 | Discovery-governor pregunta si pasar al 020 antes de haber escrito los artefactos de eval/ y knowledge/ | CRÍTICA | IMPLEMENTADO |

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

### ADJ-04 — Harness 040 Planning: rediseñar para Vertical Slices — IMPLEMENTADO

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

**Impacto en el 030 — IMPLEMENTADO (Sesión 49 + ADJ-32 Sesión 61):**
El `test_strategy_map.md` incluye la "Guía de Vertical Slices" con nomenclatura formal, 5 campos
obligatorios por slice (nombre, tipo, IC-xx, BDD scenarios, criterio de Done) y reglas de
granularidad (piso mínimo por IC-xx/MOD-xx + criterio de división 3/2/10). El 040 hereda este
draft y lo consolida.

---

### ADJ-05 — Harness 050: renombrar a "050 Vertical Harness" — IMPLEMENTADO

**Prioridad:** SIGNIFICATIVA

**Descripción:**
El 050 Vertical Harness trabaja una slice a la vez tomando el plan maestro del 040 como fuente de verdad. Corre N veces — una por cada VS-xx del `vertical_slice_plan.md`.

**Artefactos que produce (confirmados en Sesión 79):**
- `proposal.md` — valor de negocio, scope (IC-xx + BDD scenarios), dependencias y riesgos de la slice
- `software_design_specification.md` (SDS) — QUÉ hace la slice: flujos BDD, AC verificables, comportamiento de errores
- `software_design_document.md` (SDD) — CÓMO se implementa: módulos, IC-xx con firmas, DTOs, DI, orden
- `testing_plan.md` — estrategia TDD: mock/stub por IC-xx, pirámide de tests, Red phase explícita
- `execution_plan.md` — Features → Tickets → Tasks en orden TDD (Red→Green→Refactor)

**Decisiones de diseño tomadas (Sesión 79):**
- Opción B confirmada: iterativo slice a slice (050→060→070→080→050→...), no batch
- Output path: `/050_vertical/VS-xx/` — subcarpeta por slice
- Estado por slice: PENDING → DOCS_READY → SLICE_COMPLETE → PROD_READY
- El 070 escribe `SLICE_COMPLETE` y el 080 escribe `PROD_READY` (handshakes cross-harness)
- Blueprint creado: `plans/050_vertical_harness.md`

**Implementado (Sesiones 79-86):** 6 agentes (vertical-analyst, vertical-writer, vertical-reviewer, vertical-evaluator, vertical-orchestrator, vertical-governor), 8 skills, ciclo `ciclo_050_vertical.md`, routing en `client-project-CLAUDE.md`, ciclo extendido 050→060→070→080 con estado PROD_READY.

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

### ADJ-25 — FORGE CLI: automatización del arranque de proyecto — PENDIENTE

**Prioridad:** SIGNIFICATIVA

**Descripción:**
Automatizar el flujo actual de inicio de proyecto (deploy manual + abrir Claude + escribir "iniciemos el proyecto") con dos slash commands globales que operan desde dentro de Claude.

**Diseño acordado:**
- `forge-setup.ps1` — script de instalación, corre una vez por máquina tras `git clone`. Crea `~/.forge/forge.config.json` y copia los slash commands a `~/.claude/commands/`.
- `forge.config.json` (template en repo) — contiene `forge_home` con la ruta a `Harness_Definition`. El setup lo instala en `~/.forge/`.
- `commands/forge-init.md` (fuente en repo) — slash command `/forge-init`: lee el config, ejecuta `deploy-harness.ps1 -harness 010 -dest .` en la carpeta actual, imprime mensaje de siguiente paso.
- `commands/forge-discovery.md` (fuente en repo) — slash command `/forge-discovery`: invoca el `discovery-governor` en modo INIT.

**Flujo resultante:**
1. `git clone` + `.\forge-setup.ps1` — una vez por máquina
2. Abrir Claude en carpeta del proyecto → `/forge-init` → `/forge-discovery`

**Impacto:**
- `deploy-harness.ps1` — sin cambios
- Archivos nuevos en raíz del repo: `forge-setup.ps1`, `forge.config.json`, `commands/forge-init.md`, `commands/forge-discovery.md`

**Prerequisitos antes de implementar:**
- Ninguno — puede implementarse de forma independiente

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

### ADJ-26 — Comando /forge-suspend: suspender tarea activa — IMPLEMENTADO

**Prioridad:** SIGNIFICATIVA

**Descripción:**
Cuando el usuario necesita interrumpir el trabajo en curso, escribe `/suspend` y el agente activo termina de forma ordenada: persiste el estado actual en los archivos de persistencia, registra el punto exacto de interrupción y confirma que todo está listo para reanudar. Equivale a un "checkpoint manual" iniciado por el usuario, no por el harness.

**Impacto:**
- `commands/suspend.md` — slash command global nuevo
- Cada governor debe tener una sección "Modo SUSPEND" que describa qué escribir en `harness-state.json` y `execution-state.json` antes de detenerse
- El ritual E10-B (reanudación) ya existe — `/suspend` es el complemento que garantiza que el estado quede limpio para ese ritual

**Prerequisitos antes de implementar:**
- Definir qué campos adicionales (si alguno) necesita `harness-state.json` para registrar el punto de suspensión
- Revisar si el ritual E10-B cubre todos los casos de reanudación post-suspend o requiere ajuste

---

### ADJ-27 — Comando /forge-continue: reanudar tarea suspendida — IMPLEMENTADO

**Prioridad:** SIGNIFICATIVA

**Descripción:**
Complemento de ADJ-26. Cuando el usuario regresa a un proyecto suspendido, escribe `/resume` y el governor lee el estado persistido y retoma desde el punto exacto de interrupción. Internamente equivale al ritual E10-B, pero iniciado explícitamente por el usuario con un comando en lugar de arrancar Claude y esperar que el governor detecte el estado.

**Impacto:**
- `commands/resume.md` — slash command global nuevo
- Internamente invoca el governor del harness activo en modo CONTINUE (o equivale al E10-B existente)

**Prerequisitos antes de implementar:**
- ADJ-26 implementado primero (el estado debe quedar limpio para que /resume funcione)

---

### ADJ-28 — Transición automática entre harnesses — IMPLEMENTADO

**Prioridad:** SIGNIFICATIVA

**Solución implementada (Sesión 74):**
- Los governors (010..040) ya tenían el Paso 6 del CLOSE con deploy del siguiente harness vía `$env:HARNESS_DEPLOY_SCRIPT` y retorno `HANDOFF_READY`. La brecha era el path `PENDING_HANDOFF` en `client-project-CLAUDE.md`, que desplegaba agentes e intentaba usarlos en la misma sesión — Claude no los reconocía porque se cargaron mid-session.
- Corrección: los 3 casos `PENDING_HANDOFF` ahora despliegan → escriben `DEPLOYED` → notifican al usuario que reinicie → Fin. En la siguiente sesión el path `DEPLOYED` arranca el ciclo directamente con agentes cargados.
- Creado `commands/forge-restart.md` — slash command `/forge-restart`: post-reinicio, lee `harness-state.json`, detecta el harness con `DEPLOYED` o el harness activo, y arranca el ciclo correspondiente. También sirve como comando universal "¿dónde estaba?" en cualquier momento.
- Mensajes de reinicio actualizados en los 4 governors y 4 ciclos para instruir al usuario a ejecutar `/forge-restart`.

**Archivos modificados:**
- `templates/client-project-CLAUDE.md` — 3 casos PENDING_HANDOFF corregidos
- `.claude/agents/discovery-governor.md`, `specification-governor.md`, `design-governor.md`, `planning-governor.md` — mensaje de reinicio actualizado
- `templates/workflows/ciclo_010..040.md` — mensaje HANDOFF_READY actualizado
- `commands/forge-restart.md` — nuevo slash command global

---

### ADJ-29 — Comando /forge-override: registrar desacuerdo del usuario con una decisión del harness — IMPLEMENTADO

**Prioridad:** SIGNIFICATIVA

**Solución implementada (Sesión 75):**

**Diseño:**
- Activación en los dos momentos de revisión: Sprint Contract (Paso B) y CP-03 (Paso D).
- Texto del override pasado inline con el comando: `/forge-override "FastAPI, no Django. Razón: expertise del equipo."` (Opción A1).
- Doble persistencia: campo `"overrides": []` en `harness-state.json` (para la máquina) + `persistence/overrides.md` (audit trail legible por humanos y por harnesses futuros).
- Propagación a harnesses futuros: cada governor lee `persistence/overrides.md` en E10-A antes de construir el Sprint Contract e incorpora los overrides ACTIVE como constraints duros.

**Archivos creados:**
- `commands/forge-override.md` — slash command global `/forge-override`

**Archivos modificados:**
- `templates/workflows/ciclo_010..040.md` (×4) — caso `/forge-override` en Paso B y Paso D
- `.claude/agents/discovery-governor.md` — E10-A.7 (leer overrides.md)
- `.claude/agents/specification-governor.md` — E10-A.7 (leer overrides.md)
- `.claude/agents/design-governor.md` — E10-A.8 (leer overrides.md)
- `.claude/agents/planning-governor.md` — E10-A.8 (leer overrides.md)
- `.claude/skills/discovery-state-schema/SKILL.md` — campo `"overrides"` documentado
- `.claude/skills/specification-state-schema/SKILL.md` — campo `"overrides"` documentado
- `.claude/skills/design-state-schema/SKILL.md` — campo `"overrides"` documentado
- `.claude/skills/planning-state-schema/SKILL.md` — campo `"overrides"` documentado

---

### ADJ-30 — Renombrar carpetas de output de harnesses — IMPLEMENTADO

**Prioridad:** SIGNIFICATIVA

**Problema:**
Las carpetas de output actuales (`discovery/`, `specification/`, `design/`, `plan/`) no incluyen el número del harness, lo que dificulta la navegación y la trazabilidad cuando hay múltiples harnesses activos en el mismo proyecto.

**Cambio requerido:**

| Carpeta actual | Carpeta nueva |
|----------------|---------------|
| `discovery/`   | `010_discovery/` |
| `specification/` | `020_specification/` |
| `design/`      | `030_design/` |
| `plan/`        | `040_planning/` |
| `eval/`        | Sin cambio (carpeta compartida entre harnesses) |
| `persistence/` | Sin cambio |

**Impacto — archivos a modificar:**
- `.claude/agents/` — todos los agentes que referencian rutas de carpetas de output (6 por harness × 4 harnesses = hasta 24 agentes)
- `.claude/skills/` — todos los schemas de síntesis, análisis, estado y rúbrica que citan rutas
- `templates/workflows/ciclo_010..040.md` (×4) — referencias a carpetas de output
- `templates/client-project-CLAUDE.md` — referencias a carpetas de output
- `Harnesses/010..040_*.md` (×4) — documentación de rutas
- `plans/010..040_*.md` (×4) — blueprints con rutas
- `deploy-harness.ps1` — si crea carpetas explícitamente

**Prerequisitos antes de implementar:**
- Ninguno — puede implementarse de forma independiente

---

### ADJ-32 — /forge-restart invoca governors via Agent tool en lugar de ejecutar el ciclo — IMPLEMENTADO

**Prioridad:** SIGNIFICATIVA

**Descripción:**
Al ejecutar `/forge-restart`, el comando detecta correctamente el harness a reanudar pero luego intenta invocar el governor como `Agent(subagent_type: 'specification-governor')`. Los agentes locales definidos en `.claude/agents/` no son subagent_types válidos del Agent tool — solo lo son los tipos del sistema (`claude`, `general-purpose`, `Explore`, etc.). El sistema se auto-recupera leyendo el archivo del governor e invocando `general-purpose` con su contenido completo, lo que produce el resultado funcional correcto, pero no es el flujo diseñado.

**Causa raíz:**
`forge-restart.md` instruye a leer el ciclo correspondiente y ejecutarlo desde el Paso A. Sin embargo, en la práctica Claude intenta spawear el governor directamente como sub-agente antes de seguir el ciclo. El ciclo es el punto de entrada correcto — si se ejecuta paso a paso, la invocación del governor ocurre naturalmente como parte de las instrucciones del ciclo.

**Impacto:**
- `commands/forge-restart.md` — las instrucciones deben dejar explícito que NO se debe usar el Agent tool para invocar governors; el ciclo se ejecuta inline, no como sub-agente
- Potencialmente afecta también `commands/forge-continue.md` si sigue el mismo patrón de invocación

**Prerequisitos antes de implementar:**
- Verificar si `forge-continue.md` tiene el mismo problema
- Revisar si el ciclo_020..040.md tiene instrucciones ambiguas que llevan a Claude a intentar spawear el governor en lugar de leerlo inline

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

### ADJ-33 — /forge-restart no maneja el estado PENDING_HANDOFF — IMPLEMENTADO

**Prioridad:** CRÍTICA

**Descripción:**
Cuando el usuario ejecuta `/forge-restart` con `handoff_0XX.status == "PENDING_HANDOFF"` (el siguiente harness aún no fue desplegado), el comando no tiene rama para ese estado. Su Prioridad 1 solo contempla `DEPLOYED` y su Prioridad 2 busca harnesses en progreso. Al no encontrar ningún caso aplicable, el modelo puede halucinar que el estado es `DEPLOYED` y avanzar hacia el ciclo del siguiente harness cuando en realidad los agentes no están disponibles. Detectado durante Test_Harness_002 al ejecutar `/forge-restart` tras el cierre del 020: el modelo reportó incorrectamente que `handoff_030.status == "DEPLOYED"` cuando el JSON contenía `PENDING_HANDOFF`.

El flujo correcto requiere que el usuario pase primero por el CLAUDE.md auto-routing, que sí maneja `PENDING_HANDOFF` (pregunta, deploy, escribe `DEPLOYED`, pide reinicio). Pero el usuario puede llegar a `/forge-restart` directamente sin que ese routing haya ocurrido.

**Impacto:**
- `commands/forge-restart.md` — agregar rama en Prioridad 1 para `PENDING_HANDOFF`: ejecutar el mismo flujo de deploy del CLAUDE.md (preguntar al usuario, correr `deploy-harness.ps1`, actualizar estado a `DEPLOYED`, notificar reinicio) en lugar de ignorar el estado o derivar en comportamiento inesperado.

**Prerequisitos antes de implementar:**
- Ninguno — puede implementarse de forma independiente en `commands/forge-restart.md`

---

### ADJ-34 — Fallback inseguro cuando el governor no está disponible — IMPLEMENTADO

**Prioridad:** CRÍTICA

**Descripción:**
Cuando el ciclo del harness intenta invocar un governor como subagente y el Agent tool retorna "not found" (porque los agentes del harness no fueron desplegados), el modelo no se detiene con un error claro. En su lugar, lee el archivo `.md` del governor e intenta ejecutar su protocolo inline como parte del agente principal. Detectado durante Test_Harness_002: tras el fallo de `Agent(subagent_type: 'design-governor')`, el modelo dijo "El tipo design-governor no existe como subagente. Necesito leer los protocolos disponibles para ejecutar el governor localmente" y procedió a hacerlo.

Este comportamiento es peligroso porque: (a) el contexto del governor no está aislado, (b) las skills y sub-agentes del governor tampoco están disponibles, (c) el resultado puede ser estructuralmente incorrecto sin que el usuario lo sepa.

**Impacto:**
- `commands/forge-restart.md` — agregar verificación explícita: antes de leer el ciclo, comprobar que el archivo `.claude/agents/<governor>.md` existe en el directorio de trabajo. Si no existe, detenerse con mensaje: `"El agente <governor> no está disponible. El deploy del harness <N> no se completó. Ejecuta: & "$env:HARNESS_DEPLOY_SCRIPT" -Harness <N> -Destino <path> y luego reinicia."` No continuar bajo ninguna circunstancia.
- `templates/workflows/ciclo_0XX_*.md` (×4) — agregar al Paso A una precondición idéntica: verificar que el archivo del governor existe antes de intentar invocarlo.

**Prerequisitos antes de implementar:**
- ADJ-33 implementado primero (el flujo de PENDING_HANDOFF debe resolverse antes para que el usuario llegue a /forge-restart con los agentes ya desplegados)

---

### ADJ-35 — Sprint contracts persistidos como archivos .md en carpeta contract/ — IMPLEMENTADO

**Prioridad:** MENOR

**Descripción:**
Actualmente los sprint contracts se guardan únicamente como campos de texto dentro de `persistence/harness-state.json` (`sprint_contract` y `sprint_contract_draft`). Esto los hace difíciles de leer, revisar y comparar directamente. Cada governor, al aprobar el Sprint Contract (transición a `ACTIVE`), escribe también el texto completo en un archivo `.md` independiente bajo la carpeta `contract/` en el directorio del proyecto cliente.

Convención de nombres:
| Harness | Archivo |
|---------|---------|
| 010 Discovery | `contract/010_discovery.md` |
| 020 Specification | `contract/020_specification.md` |
| 030 Design | `contract/030_design.md` |
| 040 Planning | `contract/040_planning.md` |

El campo `sprint_contract` en `harness-state.json` se mantiene para compatibilidad con los rituals E10-A/E10-B que lo leen programáticamente. El archivo `.md` es una copia legible adicional, no el reemplazo. La carpeta `contract/` la crea el governor en runtime si no existe.

**Archivos modificados:**
- `.claude/agents/discovery-governor.md` — Paso 1 de EXECUTE: escribe `contract/010_discovery.md` tras actualizar `harness-state.json`
- `.claude/agents/specification-governor.md` — ídem para `contract/020_specification.md`
- `.claude/agents/design-governor.md` — ídem para `contract/030_design.md`
- `.claude/agents/planning-governor.md` — ídem para `contract/040_planning.md`
- `.claude/skills/discovery-state-schema/SKILL.md` — `contract/010_discovery.md` documentado en Single Writer Rule
- `.claude/skills/specification-state-schema/SKILL.md` — ídem para `contract/020_specification.md`
- `.claude/skills/design-state-schema/SKILL.md` — ídem para `contract/030_design.md`
- `.claude/skills/planning-state-schema/SKILL.md` — ídem para `contract/040_planning.md`

---

### ADJ-37 — Discovery-governor pregunta si pasar al 020 antes de escribir eval/ y knowledge/ — IMPLEMENTADO

**Prioridad:** CRÍTICA

**Descripción:**
Al cerrar el 010 Discovery Harness, el governor presenta la pregunta de transición al 020 sin haber escrito primero los artefactos de `eval/` (verdict.json, metrics_summary.json) ni los de `knowledge/` (lessons_learned.md, decisions_library.md). Viola LL-04: la precondición del cierre debe verificar que `eval/verdict.json` contiene la entrada del harness antes de cualquier paso del cierre. También viola el orden obligatorio del Paso CLOSE: los artefactos de conocimiento deben existir antes de que el governor escale al humano.

**Impacto:**
- `.claude/agents/discovery-governor.md` — el modo CLOSE debe verificar que `eval/verdict.json` y `knowledge/lessons_learned.md` existen y están completos antes de presentar la pregunta de handoff al usuario. Si no existen, el governor debe ejecutar primero los pasos de escritura correspondientes (o retornar error) en lugar de avanzar al handoff.

**Prerequisitos antes de implementar:**
- Ninguno — puede implementarse de forma independiente en `discovery-governor.md`

---

### ADJ-36 — CLAUDE.md escribe DEPLOYED sin verificar éxito del deploy — IMPLEMENTADO

**Prioridad:** CRÍTICA

**Descripción:**
En el flujo de transición entre harnesses, `client-project-CLAUDE.md` ejecuta dos pasos secuenciales al responder "sí" a la pregunta de continuar con el siguiente harness:
1. `& "$env:HARNESS_DEPLOY_SCRIPT" -Harness 0XX -Destino ...`
2. Actualizar `handoff_0XX.status = "DEPLOYED"` en `persistence/harness-state.json`

El paso 2 se ejecuta incondicionalmente, sin verificar si el paso 1 tuvo éxito. Si el script falla silenciosamente (error de ruta, permisos, PowerShell bloqueado), el JSON queda con `DEPLOYED` pero los archivos de agentes **no existen** en `.claude/agents/`. Detectado durante Test_Harness_002: `handoff_040.status == "DEPLOYED"` pero ningún agente `planning-*.md` presente en el proyecto.

Esta inconsistencia bloquea la ejecución del ciclo siguiente (ADJ-34) y hace que `forge-restart` crea que el harness está listo cuando en realidad no lo está.

**Impacto:**
- `templates/client-project-CLAUDE.md` — los 3 bloques de transición (`handoff_020`, `handoff_030`, `handoff_040`) deben verificar el resultado del deploy antes de escribir `DEPLOYED`. Patrón correcto:
  1. Ejecutar `deploy-harness.ps1`
  2. Verificar que existe al menos un agente esperado (ej. `Test-Path ".claude/agents/<governor>.md"`)
  3. Solo si la verificación pasa → escribir `DEPLOYED`
  4. Si falla → notificar al usuario con el error, no actualizar el estado, sugerir correr el script manualmente

**Prerequisitos antes de implementar:**
- Ninguno — puede implementarse de forma independiente en `templates/client-project-CLAUDE.md`
