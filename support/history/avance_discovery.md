# Bitácora de Avance — Harness Definition

> **INSTRUCCIÓN PARA AGENTES:** Este es el primer archivo que debes leer al iniciar
> cualquier sesión de trabajo en este proyecto. Contiene el estado actual, las
> decisiones tomadas y los próximos pasos. No comiences ninguna tarea sin leerlo.

---

## Estado General del Proyecto

- **Fecha de última actualización:** 2026-05-29
- **Fase actual:** 010 Discovery Harness — COMPLETO Y VALIDADO → Próximo: PASO 3 (020 Specification Harness)
- **Estado:** discovery-dialoguer ✓ · discovery-analyst ✓ · discovery-synthesizer ✓ · discovery-evaluator ✓ · discovery-orchestrator ✓ · discovery-governor ✓ · IMP-01…IMP-31 ✓ (IMP-22, IMP-28 PENDIENTES) → test_discovery_006 COMPLETO (score 0.92) · test_discovery_007 COMPLETO (score 0.98, APPROVED) — IMP-31 e IMP-29 R2 validados

---

## Contexto del Proyecto

Se está construyendo una **metodología universal para la construcción de harnesses**
destinada a una empresa de desarrollo de software. El objetivo es que cualquier
harness futuro pueda construirse siguiendo este estándar, garantizando calidad y
reducción de varianza en los outputs de LLMs.

### Fuentes de Verdad
- `Insumos/principios.md` — Principios P1-P8 y Estándares E1-E12. **No se modifica nunca.**
- `Insumos/metodologia.md` — Metodología universal. **ALINEADA Y CERRADA.** No se modifica.
- `support/ajustes.md` — Registro de todas las brechas y observaciones. **12 brechas + 9 OBS: TODAS IMPLEMENTADAS.**

### Estado de los archivos en `Harnesses/`
Los 9 archivos contienen **definiciones de alto nivel** (Inputs, Proceso, Outputs) ya alineadas
con la metodología. **No son los harnesses completos** — son la base conceptual sobre la que
se construirá cada harness completo en el PASO 3.

```
Harness_Definition/
├── CLAUDE.md                  — Instrucciones para agentes Claude Code
├── support/
│   ├── avance.md              — Este archivo (bitácora de estado)
│   └── ajustes.md             — 12 brechas IMPLEMENTADAS + 9 OBS IMPLEMENTADAS (TODO CERRADO)
├── Insumos/
│   ├── metodologia.md         — Metodología universal (CERRADA — no tocar)
│   └── principios.md          — Principios P1-P8 y Estándares E1-E12 (FUENTE DE VERDAD — no tocar)
└── Harnesses/
    ├── 010_discovery_harness.md     — Definición COMPLETA (OBS-01, OBS-02 aplicadas)
    ├── 020_specification_harness.md — Definición COMPLETA
    ├── 030_design_harness.md        — Definición COMPLETA (OBS-03 aplicada)
    ├── 040_planning_harness.md      — Definición COMPLETA (OBS-04 aplicada)
    ├── 050_iteration_harness.md     — Definición COMPLETA (OBS-05 aplicada)
    ├── 060_isolation_harness.md     — Definición COMPLETA (OBS-06 aplicada)
    ├── 070_execution_harness.md     — Definición COMPLETA (OBS-07 aplicada)
    ├── 080_verification_harness.md  — Definición COMPLETA (OBS-08 aplicada)
    └── 090_deployment_harness.md    — Definición COMPLETA (OBS-09 aplicada)
```

---

## Qué significa "definición" vs "harness completo"

- **Definición** (estado actual de los archivos en `Harnesses/`): Describe a alto nivel
  qué recibe el harness (Inputs), qué hace (Proceso) y qué produce (Outputs). Es el
  contrato conceptual de la fase.
- **Harness completo** (PASO 3 — por construir): Implementa el Patrón Universal de Fase
  de la Sección 3 de `metodologia.md`. Incluye: 3 instancias (A/B/C) con sus roles y
  responsabilidades, Sprint Contract, Workers especializados, Rúbrica de Evaluación
  calibrada (dimensiones + few-shot + anclas), Handoff Artifact, Fase 0 (contrato del
  arnés), Fase 1 (infraestructura agéntica: política de herramientas, escalamiento,
  checkpoints canónicos, fallback, trigger de context reset), y flujo completo del arnés
  (Secciones 12.1 a 12.5 de `metodologia.md`).

---

## Historial de Sesiones

### Sesión 20 — 2026-05-29

**Objetivo de la sesión:**
Ejecutar test_discovery_007 para validar IMP-31 e IMP-29 R2. Escenario: sistema de agenda
de citas para clínica médica pequeña con 5 stakeholders.

**Trabajo realizado:**

- **README.md creado** — documentación para humanos: estructura del repo, uso de
  `deploy-harness.ps1`, arquitectura de agentes, flujo de sesión, artefactos generados,
  re-deployment y convenciones de nombres.

- **test_discovery_007 ejecutada y completada:**
  - Escenario: clínica médica (5 médicos, ~80 pacientes/día), sistema de agendamiento web.
  - Stakeholders entrevistados: Juan Restrepo (dueño/gerente), Andrés Torres (IT externo),
    Carmen López (recepcionista), Dr. Carlos Ramírez (médico), María Gómez (paciente).
  - Flujo completo: E10-A → Sprint Contract → CP-01 → CP-02 → CP-03 → CP-04 → PHASE_COMPLETE.
  - Duración: 13:48 → 15:28 UTC (1h 40min).
  - Score: **0.98 / 1.0 — APPROVED**.

- **IMP-31 validado:** `eval/verdict.json` y `eval/metrics_summary.json` en `eval/` (no en `discovery/`). ✅
- **IMP-29 R2 validado:** **cero eventos RESPUESTA_EXTERNA** en `claude-progress.txt` (vs 10+ en test_006). ✅
- **Flujo completo:** CP-01 a CP-04 alcanzados, status PHASE_COMPLETE. ✅
- **5 stakeholders entrevistados** (superó el mínimo de 4 planificado). ✅

**Resultados por dimensión:**
- D1 Actor Coverage: 1.0
- D2 Intent Clarity: 1.0
- D3 Contradiction Management: 1.0
- D4 Failure Coverage: 0.9 — 7 ítems PENDIENTE sin resolución del cliente (input para el 020)
- D5 Explicit Approval: 1.0

**Decisiones tomadas:**
- El 010 Discovery Harness se declara **COMPLETO Y VALIDADO**. No se construyen más pruebas
  del 010 salvo que emerja un regression en el 020.
- Los 7 ítems PENDIENTE de D4 (SF-P2, SF-R1, SG-01, SG-02, SG-03, SF-I1, SF-G2) son input
  natural para el 020 Specification Harness — no son un defecto del 010.
- El README.md se actualiza solo cuando cambie el estado de un harness en la tabla o cuando
  se agregue infraestructura nueva (nuevo script, nueva convención).

**Archivos creados/modificados:**
```
README.md                  (nuevo — documentación para humanos)
support/avance.md          (estado, sesión 20)
```

---

### Sesión 19 — 2026-05-28

**Objetivo de la sesión:**
Verificar resultado de test_discovery_006 e implementar IMP-31 e IMP-29 (segunda ronda).

**Trabajo realizado:**

- **test_discovery_006 verificada como COMPLETA:** score 0.92/1.0 (APPROVED), todos los checkpoints CP-01 a CP-04 alcanzados, status: PHASE_COMPLETE. Protocolo de rework funcionó (v1 REJECTED → v2 APPROVED). Issues detectados: IMP-31 (paths incorrectos del evaluador) e IMP-29 parcial (10+ RESPUESTA_EXTERNA en los logs, dialoguer sigue saliendo entre rondas).

- **IMP-31 (MENOR) — verdict.json y metrics_summary.json en discovery/ en lugar de eval/:**
  - `discovery-evaluator.md` "Al terminar": nuevo bloque PATHS DE SALIDA al inicio, con distinción explícita entre `discovery/` (artefactos evaluados) y `eval/` (outputs de la evaluación). Paths actualizados sin slash inicial.

- **IMP-29 segunda ronda (SIGNIFICATIVA) — Dialoguer sigue saliendo entre rondas:**
  - `discovery-dialoguer.md` REGLA DE SESION UNICA: restricción negativa ("no emitas texto") reemplazada por instrucción positiva del ciclo correcto (`Write → AskUserQuestion → recibir → Write → ...`).
  - `discovery-dialoguer.md` "Al cerrar cada entrevista de stakeholder" Paso 5: eliminado "Notificar a B" (retorno implícito). El dialoguer continúa directamente con el siguiente stakeholder o verifica condiciones globales.
  - `discovery-governor.md`: nueva subsección "Protocolo RESPUESTA_EXTERNA" — 3 pasos formales: registrar, re-spawear orchestrator con respuesta explícita, no tocar el transcript.
  - `discovery-orchestrator.md`: prompt del dialoguer ampliado con bloque condicional para pasar respuesta pendiente cuando el governor la envía.

**Decisiones tomadas:**
- La causa raíz de IMP-29 es arquitectónica: en la cadena governor → orchestrator → dialoguer, el AskUserQuestion del dialoguer a veces no devuelve la respuesta al dialoguer sino al governor. Esto puede deberse a presión de contexto (el dialoguer sale cuando el transcript crece) o a comportamiento del runtime con cadenas de 3 niveles. El fix combina prevención (instrucción positiva en el dialoguer) y manejo robusto (protocolo formal en el governor).
- No se elimina el mecanismo RESPUESTA_EXTERNA del governor — se formaliza, porque puede seguir ocurriendo y la red de seguridad demostró funcionar en test_discovery_006.

**Archivos modificados:**
```
.claude/agents/
├── discovery-evaluator.md     (IMP-31: PATHS DE SALIDA block)
├── discovery-dialoguer.md     (IMP-29 R2: instrucción positiva + Paso 5 sin Notificar a B)
├── discovery-governor.md      (IMP-29 R2: Protocolo RESPUESTA_EXTERNA formal)
└── discovery-orchestrator.md  (IMP-29 R2: prompt dialoguer con respuesta pendiente)
support/ajustes.md             (IMP-31: registrado; IMP-29 R2: complementario)
support/avance.md              (estado, sesión 19)
```

**Próximo paso:** Re-deploy a test_discovery_007 y ejecutar nueva prueba completa para validar IMP-31 e IMP-29 R2.

---

### Sesión 18 — 2026-05-28

**Objetivo de la sesión:**
Detectar y corregir IMP-30 durante test_discovery_006.

**Trabajo realizado:**

- **IMP-30 (SIGNIFICATIVA) — Dialoguer no verifica condiciones de Done después de cada ronda:**
  - `discovery-dialoguer.md`: nuevo Paso 5 en el ciclo de entrevistas — después de escribir cada ronda, verificar explícitamente las 4 condiciones (C1: stakeholders, C2: sin contradicciones nuevas en 2 rondas, C3: objetivos de valor, C4: comportamiento ante fallos). Si todas se cumplen → ir a Fase 3 de cierre sin más preguntas. Si alguna falta → orientar la siguiente pregunta a cubrirla, priorizando C4.
  - Cambio aplicado tanto en `Harness_Definition` (fuente) como en `Test_Discovery_006` (prueba activa).

**Decisiones tomadas:**
- El mecanismo de verificación post-ronda evita que el dialoguer itere indefinidamente. La priorización de C4 garantiza que el tema de fallos siempre se cubra antes de cerrar.

**Archivos modificados:**
```
.claude/agents/
└── discovery-dialoguer.md    (IMP-30: Paso 5 de verificación post-ronda)
support/ajustes.md            (IMP-30: registrado e implementado)
support/avance.md             (estado, sesión 18)
```

**Próximo paso:** Continuar observando test_discovery_006. El dialoguer está en Ronda 7 — con IMP-30 activo debería cubrir C4 (fallos) y cerrar en las próximas rondas.

---

### Sesión 17 — 2026-05-28

**Objetivo de la sesión:**
Ejecutar test_discovery_006, detectar y corregir IMP-29.

**Trabajo realizado:**

- **test_discovery_006 ejecutada:** Sprint Contract aprobado correctamente (IMP-18 verificado). El dialoguer inició, escribio Ronda 1 (identificacion del stakeholder) y Ronda 2 (confirmacion de stakeholder unico). A partir de la Ronda 3, las respuestas del usuario llegaron al governor en lugar del dialoguer — loop CONTEXT_RESET x3 con `last_checkpoint: null`.

- **IMP-29 (CRITICA) — Dialoguer retorna tras Fase 1 sin completar entrevista:**
  - `discovery-dialoguer.md`: nueva seccion "REGLA DE SESION UNICA" al inicio — el dialoguer NO retorna a B hasta que el transcript diga `Estado global: COMPLETO`. Las Fases 1, 2 y 3 se ejecutan en una sola sesion sin puntos de retorno intermedios. Regla adicional: no emitir texto de respuesta a B hasta tener COMPLETO (texto antes de ese momento puede cortar el flujo).
  - `discovery-orchestrator.md`: verificacion de completitud del transcript ANTES de escribir CP-01 — si el transcript no dice COMPLETO, re-spawnar el dialoguer (hasta 5 intentos) antes de registrar el checkpoint.

**Decisions tomadas:**
- La verificacion de COMPLETO en el orchestrator es la red de seguridad de ultima instancia. La regla en el dialoguer es la prevencion primaria. Ambas capas son necesarias.
- El loop CONTEXT_RESET del governor (IMP-09) funciona correctamente — el problema no era el governor sino el dialoguer retornando temprano.

**Archivos modificados:**
```
.claude/agents/
├── discovery-dialoguer.md    (IMP-29: REGLA DE SESION UNICA)
└── discovery-orchestrator.md (IMP-29: verificacion COMPLETO antes de CP-01)
support/ajustes.md            (IMP-29: registrado e implementado)
support/avance.md             (estado, sesion 17)
```

**Proximo paso:** Re-deploy a Test_Discovery_006 (borrar estado anterior, re-ejecutar deploy-harness.ps1) y relanzar prueba.

---

### Sesión 16 — 2026-05-28

**Objetivo de la sesión:**
Implementar IMP-17 (script de deployment) e IMP-18 (template Sprint Contract).

**Trabajo realizado:**

- **IMP-17 — deploy-harness.ps1:** Creado y ejecutado exitosamente. El usuario verificó que funciona en Test_Discovery_006. Problema de encoding (tildes y guion largo) detectado y corregido — todos los strings ahora usan ASCII puro para compatibilidad con PowerShell 5.1.

- **IMP-18 — Template Sprint Contract:** En `discovery-governor.md` seccion "Reporte al humano y gate del Sprint Contract", la descripcion prosaica de los campos a incluir fue reemplazada por un template de bloque de texto concreto que el governor rellena. El template incluye explicitamente: Objetivo, Inputs, Workers, Artefactos, Checkpoints (CP-01 a CP-04 con descripcion), Criterio de Done (las 4 condiciones exactas del harness), Riesgos.

**Decisiones tomadas:**
- Scripts PowerShell en este proyecto deben usar solo ASCII — no tildes, no guiones largos, no caracteres Unicode. PowerShell 5.1 interpreta el archivo como Windows-1252 y los caracteres UTF-8 multi-byte se corrompen.
- El template del Sprint Contract usa texto plano (sin JSON ni YAML) para que sea legible directamente en el AskUserQuestion al cliente.

**Archivos creados/modificados:**
```
deploy-harness.ps1                (nuevo — encoding fix aplicado)
.claude/agents/
└── discovery-governor.md         (IMP-18: template Sprint Contract con checkpoints y Criterio de Done)
support/ajustes.md                (IMP-17, IMP-18: IMPLEMENTADO)
support/avance.md                 (estado, sesion 16)
```

---

### Sesión 15 — 2026-05-28

**Objetivo de la sesión:**
Implementar IMP-17 — script de deployment `deploy-harness.ps1`.

**Trabajo realizado:**

- **IMP-17 — Script de deployment:**
  - `deploy-harness.ps1` creado en la raíz de `Harness_Definition`.
  - Parámetros: `-Harness` (ej. `010`) y `-Destino` (path del proyecto cliente).
  - Tabla de mapeo número→prefijo cubre los 9 harnesses (010→discovery, 020→specification, …, 090→deployment).
  - Con el prefijo, filtra archivos con `Get-ChildItem "$prefijo-*"` — sin hardcodear nombres individuales.
  - Hot-swap: elimina solo los archivos del harness indicado en destino antes de copiar (no afecta otros harnesses).
  - Crea `.claude/agents/` y `.claude/skills/` en destino si no existen.
  - Templates: `settings.json` y `CLAUDE.md` se copian solo si no existen en destino.
  - Reporte final en consola: limpieza, agentes, skills, templates, siguiente paso.
  - Validaciones: harness desconocido → error con lista de válidos; destino inexistente → error claro.

**Decisiones tomadas:**
- El prefijo (`discovery`, `specification`, etc.) es la clave de identificación — los agentes y skills futuros deben seguir la misma convención de nombre para ser recogidos automáticamente por el script.
- El script NO crea el directorio destino — el usuario debe crearlo antes. Simplifica el script y evita deployments accidentales en rutas incorrectas.

**Archivos creados/modificados:**
```
deploy-harness.ps1    (nuevo — raíz de Harness_Definition)
support/avance.md     (IMP-17: registrado, sesión 15)
```

---

### Sesión 14 — 2026-05-28

**Objetivo de la sesión:**
Analizar resultados de test_discovery_004 e implementar fixes detectados.

**Trabajo realizado:**

- **test_discovery_004 ejecutada y analizada:** Flujo completo hasta APPROVED. IMP-20 e IMP-21 verificados como correctos.
- **IMP-23 (CRÍTICA) — discovery-analyst no escribe analysis_report.md:**
  - `discovery-analyst.md`: nueva sección "Postcondición obligatoria" antes de "Al terminar" — verificar en disco antes de reportar a B; si no existe, escribirlo antes de continuar.
  - `discovery-synthesizer.md`: nuevo Paso 0 en "Al iniciar" — verificar que `discovery/analysis_report.md` existe antes de cualquier otra acción; si no, detener y reportar error a B.
  - `discovery-evaluator.md`: Paso 1 extendido para incluir `analysis_report.md` en la verificación; si no existe, advertencia en `findings` y penalización en D3.
- **IMP-24 (SIGNIFICATIVA) — Orchestrator no actualiza execution-state.json:**
  - `discovery-orchestrator.md`: cada bloque post-Worker reemplazado con protocolo de 5 pasos obligatorio — leer, mergear, escribir, verificar, bloquear si falla. El orchestrator no puede avanzar al siguiente Worker sin confirmar que el checkpoint quedó escrito en disco.
- **IMP-25 (MENOR) — Evaluator aprueba sin analysis_report:** Resuelto por IMP-23 (mismo ajuste en evaluator).

**Decisiones tomadas:**
- Enfoque de doble capa: postcondición en el writer (analyst verifica que escribió) + precondición en el reader (synthesizer verifica antes de leer). Más robusto que corregir solo uno.
- IMP-24 implementado en la misma sesión — protocolo de 5 pasos con verificación y bloqueo duro.

**Archivos creados/modificados:**
```
.claude/
└── agents/
    ├── discovery-analyst.md     (IMP-23: sección Postcondición obligatoria)
    ├── discovery-synthesizer.md (IMP-23: Paso 0 precondición)
    ├── discovery-evaluator.md   (IMP-25: Paso 1 extendido con analysis_report)
    └── discovery-orchestrator.md (IMP-24: protocolo de 5 pasos post-Worker con verificación)
support/ajustes.md  (IMP-23, IMP-24, IMP-25: registrados en tabla y secciones de detalle)
support/avance.md   (estado, sesión 14)
```

---

### Sesión 13 — 2026-05-28

**Objetivo de la sesión:**
Ejecutar pruebas test_discovery_002 y test_discovery_003 y corregir issues detectados en tiempo real.

**Trabajo realizado:**

- **test_discovery_002:** Flujo cortocircuitado — el orchestrator escribió transcript, analysis_report y 4 artefactos directamente sin spawnear ningún worker. Detectado como IMP-19.
- **IMP-19 (CRÍTICA) — Orchestrator cortocircuita workers:**
  - `discovery-orchestrator.md`: nueva sección "REGLAS DE ESCRITURA" al inicio — lista explícita de qué puede escribir (solo `persistence/execution-state.json`) y qué nunca puede escribir directamente (`/discovery/*`). Mensaje de DETENTE explícito. Cada Worker de la sección "Coordinación" reformulado con "Invocar X usando el tool `Agent`" y prompt de ejemplo.
- **test_discovery_003:** Flujo jerárquico completo funcionó — governor → orchestrator → dialoguer (entrevista real) → analyst (Modo Aclaración con 3 preguntas) → synthesizer (4 artefactos) → gates CP-03/CP-04 → cierre. Detectados IMP-20 e IMP-21.
- **IMP-20 (CRÍTICA) — Governor salta auditoría:**
  - `discovery-governor.md` sección "Cierre": nueva PRECONDICIÓN — verificar que existe `/eval/verdict.json` antes de ejecutar cualquier paso del cierre. Si no existe, ejecutar sección "Auditoría" completa primero.
- **IMP-21 (MENOR) — Orchestrator timestamps placeholder:**
  - `discovery-orchestrator.md`: agregada sección "Timestamps reales" al inicio con comando `(Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")`.

**Decisiones tomadas:**
- `knowledge/` (lessons_learned.md, decisions_library.md) es conocimiento local al proyecto cliente. No se copia entre pruebas — en producción hay un solo directorio por proyecto. test_discovery_004 arranca limpio.
- IMP-22 (reutilización de knowledge entre ciclos de un mismo proyecto reiniciado) se evalúa a futuro si emerge la necesidad real.

**Archivos creados/modificados:**
```
.claude/
└── agents/
    ├── discovery-orchestrator.md   (IMP-19: REGLAS DE ESCRITURA + workers via Agent; IMP-21: timestamps)
    └── discovery-governor.md       (IMP-20: PRECONDICIÓN en Cierre)
Test_Discovery_003/
└── CLAUDE.md                       (creado para la prueba — copia de templates/client-project-CLAUDE.md)
support/ajustes.md   (IMP-19, IMP-20, IMP-21: registrados en tabla y secciones de detalle)
support/avance.md    (estado, sesión 13)
```

---

### Sesión 12 — 2026-05-28

**Objetivo de la sesión:**
Implementar IMP-16 — corregir mentalidad del evaluador para eliminar sesgo negativo.

**Trabajo realizado:**

- **IMP-16 (SIGNIFICATIVA) — Mentalidad del evaluador:**
  - `discovery-evaluator.md`: agregada sección "Mentalidad y protocolo de evaluación" con protocolo de dos fases obligatorio (Fase 1: análisis de pros/contras con evidencia → Fase 2: score consistente con la evidencia). Regla de oro: no se otorga beneficio de la duda, pero tampoco se penaliza sin citar el gap. Se prohíbe explícitamente "no puedo evaluar".
  - `discovery-evaluator.md` sección "Evaluación": cada dimensión D1–D5 reformulada con estructura Fase 1 (listar pros y contras) + Fase 2 (asignar score) antes de pasar a la siguiente dimensión.
  - `support/ajustes.md`: IMP-16 registrado en tabla y con sección de detalle.

**Decisiones tomadas:**
- "Tendencia negativa" reemplazada por "rigor sin concesiones": el evaluador no regala puntos ni los retiene sin evidencia. El score refleja lo que hay, no lo que podría faltar en abstracto.
- El protocolo de dos fases es obligatorio y no puede invertirse — no se puede asignar score antes de completar el análisis de pros/contras de esa dimensión.

**Archivos creados/modificados:**
```
.claude/
└── agents/
    └── discovery-evaluator.md   (IMP-16: sección mentalidad + dimensiones reestructuradas)
support/ajustes.md               (IMP-16: registrado en tabla y sección de detalle)
support/avance.md                (estado, sesión 12)
```

---

### Sesión 11 — 2026-05-28

**Objetivo de la sesión:**
Implementar IMP-08, IMP-09 e IMP-10 (últimos ajustes post-prueba pendientes).

**Trabajo realizado:**

- **IMP-08 (MENOR) — Timestamps reales:**
  - `discovery-governor.md`: nueva sección "Timestamps reales" al inicio (antes de E10-A) con comando Bash `(Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")`. Instrucción explícita de sustituir todo placeholder `<timestamp>` o `[timestamp]` con el valor real obtenido.

- **IMP-09 (SIGNIFICATIVA) — Governor no escribe transcript:**
  - `discovery-governor.md`: nueva sección "Regla: nunca escribir el transcript" al inicio. Explica que `/discovery/dialogue_transcript.md` es de escritura exclusiva de discovery-dialoguer; si el governor recibe respuesta fuera de contexto, debe ignorarla y re-spawear discovery-orchestrator. Incluye regla específica para E10-B cuando `last_checkpoint: null` con transcript parcial.

- **IMP-10 (SIGNIFICATIVA) — Settings con permisos pre-autorizados:**
  - Creado `templates/client-project-settings.json` con `allow` para `Write(*)`, `Read(*)`, `Bash(git *)`, `Bash(mkdir *)`, `Bash(Get-Date*)`, `Bash(Remove-Item *)`. Al desplegar el harness en un proyecto cliente, este archivo se copia como `.claude/settings.json` junto con la carpeta `.claude/`.

**Decisiones tomadas:**
- El comando de timestamp usa `Get-Date` (PowerShell/Windows) que es el shell del entorno de despliegue confirmado.
- `Bash(Get-Date*)` se agrega al settings.json del cliente porque el governor necesita este comando para timestamps reales.
- `Bash(Remove-Item *)` se agrega para la prueba de sanidad del E10-A (paso 5: escribir, leer y eliminar `/changes/sanity_check.txt`).

**Archivos creados/modificados:**
```
.claude/
└── agents/
    └── discovery-governor.md        (IMP-08, IMP-09: 2 nuevas secciones al inicio)
templates/
└── client-project-settings.json    (IMP-10: nuevo — permisos pre-autorizados para proyecto cliente)
support/ajustes.md   (IMP-08, IMP-09, IMP-10: IMPLEMENTADO ✓)
support/avance.md    (estado, sesión 11)
```

---

### Sesión 10 — 2026-05-28

**Objetivo de la sesión:**
Implementar IMP-11 e IMP-12 (ajustes post-prueba de impacto significativo).

**Trabajo realizado:**

- **IMP-11 (SIGNIFICATIVA) — Mover persistencia a `persistence/`:**
  - Reemplazados todos los paths en 5 archivos usando replace_all:
    - `discovery-governor.md`: `harness-state.json` → `persistence/harness-state.json`, `execution-state.json` → `persistence/execution-state.json`, `claude-progress.txt` → `persistence/claude-progress.txt`
    - `discovery-orchestrator.md`: `harness-state.json` → `persistence/harness-state.json`, `execution-state.json` → `persistence/execution-state.json`
    - `discovery-evaluator.md`: `execution-state.json` → `persistence/execution-state.json`
    - `discovery-state-schema/SKILL.md`: los 3 archivos + intro actualizada a "carpeta `persistence/`"
    - `discovery-verdict-schema/SKILL.md`: `execution-state.json` → `persistence/execution-state.json`
  - `discovery-governor.md` E10-A Paso 2: `mkdir` ampliado a 5 carpetas (agrega `persistence`)
  - `discovery-governor.md` Cierre Paso 5: `git add` simplificado a `persistence/`
  - Verificado con grep: cero referencias sin prefijo después del cambio.

- **IMP-12 (SIGNIFICATIVA) — Plantilla CLAUDE.md del proyecto cliente:**
  - Creado `templates/client-project-CLAUDE.md` con:
    - Sección "INICIO OBLIGATORIO DE SESIÓN": auto-detecta INICIO vs CONTINUACIÓN por existencia de `persistence/harness-state.json`
    - Invoca `discovery-governor` automáticamente sin esperar instrucción del usuario
    - Tres ramas: no existe → INICIO, existe íntegro → CONTINUACIÓN, corrupto → notificar con error
    - Sección "REGLAS DE OPERACIÓN": prohibición de modificar archivos de persistencia y artefactos manualmente
  - Resuelve IMP-14 (inicio intuitivo) e IMP-15 (reanudación automática sin frase especial)

- **IMP-14 e IMP-15:** Marcados IMPLEMENTADO en tabla y secciones detalladas de `ajustes.md`.

**Decisiones tomadas:**
- La plantilla CLAUDE.md se almacena en `templates/client-project-CLAUDE.md` dentro de Harness_Definition. Al desplegar el harness en un proyecto cliente, este archivo se copia como `CLAUDE.md` en la raíz de ese proyecto junto con la carpeta `.claude/`.
- No se creó CLAUDE.md en este proyecto (Harness_Definition) — solo en `templates/` para deployment.

**Archivos creados/modificados:**
```
.claude/
├── agents/
│   ├── discovery-governor.md        (IMP-11: paths persistence/, mkdir, git add)
│   ├── discovery-orchestrator.md    (IMP-11: paths persistence/)
│   └── discovery-evaluator.md       (IMP-11: paths persistence/)
└── skills/
    ├── discovery-state-schema/SKILL.md   (IMP-11: paths persistence/ + intro)
    └── discovery-verdict-schema/SKILL.md (IMP-11: paths persistence/)
templates/
└── client-project-CLAUDE.md             (IMP-12: nuevo — plantilla CLAUDE.md del proyecto cliente)
support/ajustes.md   (IMP-11, IMP-12, IMP-14, IMP-15: IMPLEMENTADO ✓)
support/avance.md    (estado, sesión 10)
```

---

### Sesión 9 — 2026-05-28

**Objetivo de la sesión:**
Ejecutar la prueba test_discovery con el harness 010 completo y documentar los hallazgos.

**Trabajo realizado:**

- Ejecutada prueba completa en `C:\Users\USUARIO\Documents\Triple S\Test_Discovery\`
- Proyecto de prueba: app de registro de gastos personales (brief de 1 línea, cold-start)
- Flujo ejecutado hasta ronda 5 de la entrevista (interrupción deliberada y por tiempo)
- Verificada reanudación E10-B: governor reconstruyó estado exactamente tras Ctrl+C

**Resultados verificados:**
- ✅ E10-A ritual (carpetas, archivos de estado, git init, sanidad)
- ✅ Gate Sprint Contract con AskUserQuestion
- ✅ `claude-progress.txt` escrito con eventos correctos (INICIO, E10-A COMPLETO, SPRINT_CONTRACT_APROBADO, E10-B REANUDACIÓN)
- ✅ `execution-state.json` con `orchestration_plan` persistido (E12 compliant)
- ✅ E10-B reanudación tras Ctrl+C — identificó ronda 5 abierta y checkpoint null correctamente
- ❌ Timestamps placeholders (IMP-08)
- ❌ Governor escribió transcript directamente, cortocircuitando flujo (IMP-09)
- ❌ Primer spawn falló por permisos, causó re-spawn (IMP-10)

**Consideraciones de diseño identificadas:**
- C1: mover archivos de persistencia a carpeta `persistence/` → registrado como IMP-11
- C2: crear CLAUDE.md del proyecto cliente → registrado como IMP-12 (resuelve IMP-14 e IMP-15)
- C3: enlazar GitHub desde el inicio como requisito → registrado como IMP-13
- C4/C5: frases de inicio y reanudación → resueltas por IMP-12

**Decisiones tomadas:**
- La prueba se detuvo antes de CP-01 por consumo de tokens excesivo debido a re-spawns (IMP-10). El flujo post-CP-01 (analyst, synthesizer, evaluator) no fue verificado.
- IMP-11 (persistence/) es el ajuste más impactante: requiere cambiar paths en todos los agentes. Se implementa en bloque en la próxima sesión.
- IMP-12 (CLAUDE.md del proyecto) resuelve los problemas de UX de inicio/reanudación sin cambios en los agentes.
- IMP-13 (GitHub): decisión pendiente entre Opción A (bloqueo duro), B (asistido con `gh`) o C (warning actual). Recomendación: Opción B.

**Archivos creados/modificados:**
```
support/ajustes.md   (IMP-08 a IMP-15 registrados con detalle)
support/avance.md    (estado, sesión 9)
```

---

### Sesión 8 — 2026-05-28

**Objetivo de la sesión:**
Implementar los 7 ajustes de implementación detectados en auditoría (IMP-01 a IMP-07) que bloqueaban el proyecto de prueba.

**Trabajo realizado:**

- **IMP-01 (CRÍTICA):** Resuelto quien crea `execution-state.json` primero.
  - `discovery-governor.md` E10-A Paso 3: crea el archivo con estructura mínima (`status: PENDING`, todos los campos nulos) — no vacío.
  - `discovery-state-schema/SKILL.md`: agregada sección "Creación inicial de execution-state.json" con la estructura mínima y la regla explícita: governor crea, orchestrator escribe sobre lo existente.
  - `discovery-orchestrator.md` Paso 3: agregado fallback — si el archivo no existe al llegar el orchestrator, lo crea con estructura mínima antes de continuar.
- **IMP-02 (SIGNIFICATIVA):** Implementado Context Reset trigger conductual.
  - `discovery-dialoguer.md`: nueva sección "Detección de Context Reset" con checklist de 4 señales conductuales, protocolo de emisión de `[CONTEXT_RESET_SIGNAL]` en el transcript, y regla de detener la sesión después de persistir.
  - `discovery-governor.md`: nueva sección "Señal de Context Reset" dentro de Ejecución Técnica — define qué hacer al recibir la señal (registrar en progress.txt, ejecutar E10-B desde Paso 3, re-spawear orchestrator).
- **IMP-03 (SIGNIFICATIVA):** Definido schema formal de `claude-progress.txt`.
  - `discovery-state-schema/SKILL.md`: nueva sección "Archivo 3 — claude-progress.txt" con formato de línea, tabla de 13 tipos de evento válidos y regla append-only.
- **IMP-04 (SIGNIFICATIVA):** Creada skill `discovery-knowledge-schema`.
  - Nuevo archivo `.claude/skills/discovery-knowledge-schema/SKILL.md` con schema de `lessons_learned.md` (secciones por ciclo, campos timestamp/tipo/descripción/acción/resultado) y `decisions_library.md` (tabla con ID/decisión/razón/harness/timestamp), reglas append-only, tabla de cuándo escribe governor en cada archivo.
  - `discovery-governor.md` frontmatter: agregado `discovery-knowledge-schema` a la lista de skills.
- **IMP-05 (MENOR):** Documentado Modo Aclaración en el plan.
  - `plans/010_discovery_harness.md` sección 12.2 paso 8: agregada nota sobre el ciclo de hasta 3 iteraciones discovery-analyst → discovery-dialoguer (Modo Aclaración) antes de registrar CP-02.
- **IMP-06 (MENOR):** Eliminado campo `resume_from` redundante.
  - `discovery-state-schema/SKILL.md`: eliminada la sección "Valores de `resume_from`" y el campo del schema JSON.
  - `discovery-orchestrator.md` Paso 4: eliminado `resume_from` del template de `orchestration_plan`.
- **IMP-07 (MENOR):** Especificado versionado de artefactos en rework.
  - `discovery-synthesizer.md` Al iniciar: nueva instrucción para detectar si es re-ejecución (artefactos ya existen), leer `metrics_summary.json` e incrementar `revisions` antes de sobreescribir.
  - `discovery-verdict-schema/SKILL.md`: especificado que `revisions` es incrementado por discovery-synthesizer al inicio de cada re-ejecución; discovery-evaluator lo lee del archivo existente.

**Decisiones tomadas:**
- `execution-state.json` tiene estado `PENDING` en su creación inicial (no `IN_PROGRESS`) — governor crea la estructura, orchestrator la activa al persistir `orchestration_plan`.
- La skill `discovery-knowledge-schema` es exclusiva de discovery-governor (Single Writer Rule extendida a los archivos de conocimiento). discovery-orchestrator solo lee, nunca escribe.
- El Context Reset no anula los checkpoints ya registrados — el transcript ya persistió el progreso. El reset solo reinicia el contexto del agente, no el trabajo.

**Archivos creados/modificados:**
```
.claude/
├── agents/
│   ├── discovery-governor.md        (IMP-01, IMP-02, IMP-04: Paso 3, señal reset, skill)
│   ├── discovery-orchestrator.md    (IMP-01, IMP-06: fallback, eliminado resume_from)
│   ├── discovery-dialoguer.md       (IMP-02: sección Detección de Context Reset)
│   └── discovery-synthesizer.md    (IMP-07: detección re-ejecución + incremento revisions)
└── skills/
    ├── discovery-state-schema/SKILL.md   (IMP-01, IMP-03, IMP-06: creación inicial, schema progress.txt, eliminar resume_from)
    ├── discovery-verdict-schema/SKILL.md (IMP-07: revisions incrementado por synthesizer)
    └── discovery-knowledge-schema/SKILL.md  (IMP-04: nuevo — schema lessons_learned + decisions_library)
plans/010_discovery_harness.md             (IMP-05: Modo Aclaración en paso 8)
support/ajustes.md                         (IMP-01…IMP-07: todos IMPLEMENTADO ✓)
support/avance.md                          (estado, sesión 8)
```

---

### Sesión 7 — 2026-05-28

**Objetivo de la sesión:**
Construir discovery-governor (Instance A del 010 Discovery Harness) y agregar el campo `agents:` al frontmatter de discovery-orchestrator según la documentación de Anthropic.

**Trabajo realizado:**

- Corregido frontmatter de `discovery-orchestrator.md`: agregado campo `agents:` con declaración explícita de discovery-dialoguer, discovery-analyst y discovery-synthesizer (requerimiento de la documentación de Anthropic para agentes orquestadores).
- Creado `.claude/agents/discovery-governor.md` con:
  - Frontmatter: tools `[Read, Write, Bash, Agent, AskUserQuestion]`, skill `discovery-state-schema`, agents `[discovery-orchestrator, discovery-evaluator]`
  - Determinación de modo al iniciar (INICIO vs CONTINUACIÓN por existencia de harness-state.json)
  - Ritual E10-A (Inicio): 6 pasos — directorio, carpetas, archivos de estado, git init, sanidad, registro
  - Ritual E10-B (Continuación): 7 pasos — directorio, git log, claude-progress.txt, harness-state.json, execution-state.json, tabla de siguiente acción por checkpoint, sanidad
  - Reporte al humano + gate de aprobación del Sprint Contract (AskUserQuestion con 3 ramas: aprobado, ajuste, cancelación)
  - Ejecución técnica: spawn discovery-orchestrator; verificar EXECUTION_COMPLETE antes de continuar
  - Gate CP-03 (revisión draft del cliente) con rama de cambios sustanciales
  - Gate CP-04 (aprobación formal explícita del cliente)
  - Auditoría: spawn discovery-evaluator con paths de artifacts (no contenido — E6)
  - Decisión final: APPROVED → cierre, REJECTED → clasificar como técnico o estratégico
  - Protocolo de rechazo técnico (IN_REWORK + re-spawn orchestrator) y estratégico (HOLD + nueva aprobación)
  - Cierre 12.5: PHASE_COMPLETE, lessons_learned, notificación al humano, commit final

**Decisiones tomadas:**
- Tools del governor: `Read`, `Write`, `Bash`, `Agent`, `AskUserQuestion`. Bash es necesario para git init, git log, mkdir, git commit. AskUserQuestion es necesario para los gates humanos (Sprint Contract, CP-03, CP-04).
- Un governor por harness (no genérico): cada harness es autocontenido. Si al construir 2-3 harnesses más emerge un patrón repetitivo suficiente, se evalúa extraer un governor genérico en ese momento.
- El campo `agents:` en el frontmatter es requerido por la documentación de Anthropic para agentes que invocan otros agentes vía el tool Agent.

**Archivos creados/modificados:**
```
.claude/
└── agents/
    ├── discovery-governor.md       (nuevo)
    └── discovery-orchestrator.md  (campo agents: agregado al frontmatter)
support/avance.md                  (estado, próximos pasos, sesión 7)
```

---

### Sesión 6 — 2026-05-28

**Objetivo de la sesión:**
Construir discovery-orchestrator (Instance B del 010 Discovery Harness) y actualizar todas las referencias operativas a "Instance B" al nuevo nombre.

**Trabajo realizado:**

- Creado `.claude/agents/discovery-orchestrator.md` con:
  - Frontmatter: name, description, model `claude-sonnet-4-6`, tools `[Read, Write, Agent]`
  - Paso 1–4 de inicialización: leer Sprint Contract, leer knowledge, verificar último checkpoint, persistir orchestration_plan (E12 — obligatorio antes de cualquier Worker)
  - Coordinación de 3 Workers con lógica condicional por checkpoint (reanudación desde CP-01 o CP-02)
  - Manejo de fallos: registro en `execution-state.json` bajo `worker_errors`, detención limpia, reporte a governor
  - Cierre: reporte a governor con solo paths (E6)
- Actualizadas referencias operativas a "Instance B":
  - `.claude/agents/discovery-dialoguer.md` — campo `description`
  - `.claude/agents/discovery-synthesizer.md` — campo `description`
  - `support/avance.md` — Estado General (línea 13) y Próximos Pasos

**Decisiones tomadas:**
- Nombre adoptado: `discovery-orchestrator` — consistente con la convención `discovery-<rol>`.
- Tools del orquestador: `Read`, `Write`, `Agent`. El tool `Agent` es necesario porque el orquestador spawea Workers; los Workers propios solo usan `Read`/`Write`.
- Skill `discovery-state-schema` creada y asignada al orquestador: define los schemas exactos de `harness-state.json` (escrito por discovery-governor) y `execution-state.json` (escrito por discovery-orchestrator), la Single Writer Rule y las reglas de lectura/escritura por campo. La skill es reutilizable — discovery-governor también la cargará al leer `execution-state.json`.
- La lógica de re-loop con discovery-analyst (bucle aclaración) es responsabilidad del propio discovery-analyst: él re-spawna discovery-dialoguer en Modo Aclaración cuando encuentra issues. discovery-orchestrator solo registra CP-02 cuando discovery-analyst reporta "listo para síntesis".
- Las referencias arquitectónicas a "Instancia B" en avance.md (historial de sesiones 1–5) se preservan como crónica histórica.

**Archivos creados/modificados:**
```
.claude/
├── agents/
│   ├── discovery-orchestrator.md   (nuevo)
│   ├── discovery-dialoguer.md      (description actualizada)
│   └── discovery-synthesizer.md   (description actualizada)
└── skills/
    └── discovery-state-schema/SKILL.md  (nuevo — sesión 6b)
support/avance.md                  (estado, próximos pasos, sesión 6)
```

---

### Sesión 5 — 2026-05-28

**Objetivo de la sesión:**
Renombrar los 4 agentes del 010 Discovery Harness a una convención `discovery-<rol>` y actualizar todas las referencias en el proyecto.

**Trabajo realizado:**

- Renombrados los 4 agentes:
  - `instance-c.md` → `discovery-evaluator.md`
  - `w-dialogue.md` → `discovery-dialoguer.md`
  - `w-analysis.md` → `discovery-analyst.md`
  - `w-synthesis.md` → `discovery-synthesizer.md`
- Eliminados los 4 archivos con nombres viejos de `.claude/agents/`
- Actualizados los 6 archivos de skills: campo `agent:`, campo `description:` y referencias de texto en el cuerpo
- Actualizados todos los archivos de documentación: `Harnesses/010_discovery_harness.md`, `plans/010_discovery_harness.md`, `support/avance.md`, `support/ajustes.md`

**Decisiones tomadas:**
- Convención de nombres adoptada: `discovery-<rol>` para todos los agentes del 010 Discovery Harness. El prefijo `discovery-` los identifica por harness; el sufijo describe su función.
- Los 4 agentes fueron creados/renombrados con contenido interno consistente (campo `name:` en frontmatter y referencias propias en el cuerpo).
- Los registros históricos del Historial de Sesiones (Sesión 4) que mencionan nombres viejos como `w-dialogue.md` se preservan como crónica del momento de construcción; no son referencias operativas.
- Las menciones a "Instance C" como rol arquitectónico (ej. tablas de roles A/B/C) se mantienen en la documentación del harness ya que describen la posición en la jerarquía, no el nombre del agente.

**Archivos creados/modificados:**
```
.claude/
├── agents/
│   ├── discovery-evaluator.md   (renombrado de instance-c.md + contenido actualizado)
│   ├── discovery-dialoguer.md   (renombrado de w-dialogue.md + contenido actualizado)
│   ├── discovery-analyst.md     (renombrado de w-analysis.md + contenido actualizado)
│   └── discovery-synthesizer.md (renombrado de w-synthesis.md + contenido actualizado)
└── skills/
    ├── discovery-interview-protocol/SKILL.md   (agent: + referencias actualizadas)
    ├── discovery-transcript-schema/SKILL.md    (agent: + referencias actualizadas)
    ├── discovery-analysis-schema/SKILL.md      (agent: + referencias actualizadas)
    ├── discovery-synthesis-schema/SKILL.md     (agent: + referencias actualizadas)
    ├── discovery-rubric/SKILL.md               (agent: + referencias actualizadas)
    └── discovery-verdict-schema/SKILL.md       (agent: + referencias actualizadas)
Harnesses/010_discovery_harness.md              (todas las referencias actualizadas)
plans/010_discovery_harness.md                  (todas las referencias actualizadas)
support/avance.md                               (referencias operativas actualizadas)
support/ajustes.md                              (árbol de archivos actualizado)
```

---

### Sesión 4 — 2026-05-26

**Objetivo de la sesión:**
Construir todos los subagentes del 010 Discovery Harness como Tracer Bullet.

**Trabajo realizado:**

- Construido `w-dialogue.md` v1, luego rediseñado para soportar:
  - Arranque en frío (sin inputs): protocolo de 3 preguntas mínimas vía AskUserQuestion
  - Identificación de stakeholders en Fase 1 (lista de pendientes antes de entrar a preguntas)
  - Bancos de preguntas diferenciados por rol: A=negocio, B=técnico, C=usuario
  - Ciclo multi-stakeholder: no para hasta completar o descartar todos de la lista
- Construido `w-analysis.md` — extrae actores del sistema, objetivos, contradicciones y
  escenarios de fallo consolidando aportes de múltiples stakeholders
- Construido `w-synthesis.md` — produce 4 artefactos en orden de dependencia:
  glosario → failure_behavior → scope_boundaries → shared_understanding
- Skills creadas/actualizadas:
  - `discovery-interview-protocol` — rediseñada: 4 fases, 3 bancos por rol, criterio de parada global
  - `discovery-transcript-schema` — actualizada: multi-stakeholder, IDs S-xx, banco aplicado por entrevista
  - `discovery-analysis-schema` — actualizada: distingue stakeholders (S-xx) vs actores del sistema (A-xx)
  - `discovery-synthesis-schema` — nueva: schema de los 4 artefactos finales con reglas y checklist

**Decisiones tomadas:**
- Arranque en frío: cuando no hay inputs, discovery-dialoguer pide contexto mínimo al humano antes de iniciar.
- Stakeholders vs actores del sistema: distinción explícita. S-xx = personas entrevistadas; A-xx = entidades que interactúan con el sistema. Un stakeholder puede ser también un actor del sistema.
- Bancos de preguntas diferenciados por rol: negocio (estrategia, ROI, restricciones), técnico (integraciones, stack, escala), usuario (flujos, usabilidad, recuperación de errores).
- Ciclo multi-stakeholder: el transcript no se cierra como COMPLETO hasta que todos los stakeholders identificados en Fase 1 hayan sido entrevistados o marcados como NO DISPONIBLE.
- discovery-synthesizer produce artefactos en orden de dependencia: glosario primero porque el lenguaje acordado guía la redacción de los demás.
- Persistencia incremental de discovery-dialoguer: el transcript se escribe después de cada ronda (no al final). El transcript es la única memoria entre sesiones. discovery-dialoguer lee el estado al iniciar (Fase -1) y reanuda desde donde quedó.
- CP-01a agregado: checkpoint por cada stakeholder completado dentro del flujo de discovery-dialoguer. Permite reanudar entre sesiones sin perder progreso.
- Bucle de aclaración discovery-analyst → discovery-dialoguer: si discovery-analyst encuentra cualquier issue (contradicción, ambigüedad, vacío), no avanza a discovery-synthesizer. Genera preguntas específicas (PA-xx), B re-spawna discovery-dialoguer en Modo Aclaración, y discovery-analyst re-analiza. Máximo 3 iteraciones antes de escalar al humano.
- discovery-dialoguer opera en dos modos: Discovery (flujo completo) y Aclaración (solo preguntas PA-xx del analysis_report). El modo lo determina el argumento que recibe de B.

**Archivos creados/modificados:**
```
.claude/
├── agents/
│   ├── w-dialogue.md    (rediseñado)
│   ├── w-analysis.md    (nuevo, actualizado)
│   └── w-synthesis.md   (nuevo)
└── skills/
    ├── discovery-interview-protocol/SKILL.md   (rediseñado)
    ├── discovery-transcript-schema/SKILL.md    (actualizado)
    ├── discovery-analysis-schema/SKILL.md      (nuevo, actualizado)
    └── discovery-synthesis-schema/SKILL.md     (nuevo)
```

### Sesión 3 — 2026-05-26

**Trabajo realizado:**
- Creado `plans/010_discovery_harness.md` — blueprint completo para la construcción del harness.
- Construido `Harnesses/010_discovery_harness.md` como harness completo, reemplazando la
  definición de alto nivel. Secciones implementadas:
  - Fase 0: Propósito, Inputs (I-1/I-2/I-3), Proceso (5 pasos), Outputs (4 artefactos con paths),
    Criterio de Done (4 condiciones), ciclo SDD+TDD adaptado para documentos.
  - Fase 1: Instancias A/B/C con roles y jerarquía, 3 Workers secuenciales (discovery-dialoguer →
    discovery-analyst → discovery-synthesizer), Política de Herramientas, Política de Escalamiento, 4
    Checkpoints Canónicos (CP-01 a CP-04), Trigger de Context Reset (conductual > cuantitativo).
  - Sprint Contract: plantilla lista para usar con todos los campos requeridos.
  - Rúbrica de Evaluación: 5 dimensiones (D1–D5), gate ≥0.75, regla de veto en D5, anclas
    few-shot calibradas (0.2 / 0.5 / 0.8 / 1.0), schema de verdict.json.
  - Handoff Artifact: 4 artefactos en `/discovery/` con condición de activación del 020.
  - Flujo 12.1–12.5: Inicialización (E10-A/B), Ejecución Técnica (B + 3 Workers), Auditoría
    y Gate (C + A), Protocolo de Rechazo (técnico y estratégico), Cierre con commit final.

**Decisiones tomadas:**
- Workers son secuenciales (no paralelos) por dependencia estricta de datos entre ellos.
- `failure_behavior.md` se agrega como 4to artefacto de output (alimenta Error & Exception
  Policy del 020), consistente con OBS-02 ya aplicada.
- Los Workers están definidos en Fase 1 (sección 1.2) — no requieren sección separada.

### Sesión 2 — 2026-05-26

**Trabajo realizado:**
- Aplicación de OBS-01 a OBS-09 sobre las definiciones de alto nivel de los 9 harnesses.
- OBS-01 (`010`): Sección "Criterio de Done" agregada con 4 condiciones de completitud para la exploración socrática.
- OBS-02 (`010`): Paso nuevo en Proceso sobre exploración de comportamiento ante fallos, con nota explícita de que alimenta la Error & Exception Policy del 020.
- OBS-03 (`030`): Input "Stack Tecnológico Seleccionado" corregido a "Restricciones Tecnológicas"; primer paso de Proceso "Selección y Documentación del Stack" agregado.
- OBS-04 (`040`): Sección "Frecuencia de Ejecución" agregada — ejecución completa al inicio del proyecto, ejecución parcial (solo Scoping) al inicio de cada iteración subsiguiente.
- OBS-05 (`050`): Sección "Rol en la Jerarquía de Arneses" agregada — el 050 actúa como Instancia B respecto al 060 y 070; los spawea como Workers y recibe solo paths.
- OBS-06 (`060`): Sección "Política de Fallback del Sandbox" agregada — reintento (x2) → fallback a entorno alternativo → escalamiento con `Isolation Report` marcado `FAILED`.
- OBS-07 (`070`): Paso "Validación del Sandbox" agregado como primer paso obligatorio del Proceso — verifica `Isolation Report` y `Filtered Workspace View` antes de iniciar Red-Green-Refactor.
- OBS-08 (`080`): Sección "Ruta de Regreso ante Fallo" agregada — árbol de decisión: fallo técnico → 050, fallo de valor → 040 o 020 con escalamiento humano obligatorio.
- OBS-09 (`090`): Sección "Precondición: Gate de Peer Review" agregada — la Instancia A gestiona el gate entre el 080 y el 090; el 090 no se activa sin aprobación humana explícita.

**Decisiones tomadas:**
- Los archivos en `Harnesses/` son **definiciones de alto nivel**, no harnesses completos. No se modifican más — son la base para el PASO 3.
- `support/ajustes.md` queda completamente cerrado: 12 brechas + 9 OBS, todas IMPLEMENTADAS.
- El PASO 3 construye los harnesses completos en los mismos archivos de `Harnesses/`, reemplazando las definiciones con la implementación del Patrón Universal de Fase.

---

### Sesión 1 — 2026-05-26

**Trabajo realizado:**
- Lectura completa de `Insumos/metodologia.md` e `Insumos/principios.md`.
- Análisis de brechas de alineación: identificadas 12 brechas en dos rondas de revisión.
- Creación de `support/ajustes.md`, `support/avance.md` y actualización de `CLAUDE.md`.
- Aplicación de las 12 brechas sobre `Insumos/metodologia.md`:
  - Brecha 1 (E4): Sección 10 nueva "Evolución del Harness" (10.1, 10.2, 10.3).
  - Brecha 2 (E3): Rúbrica expandida con dimensiones, few-shot calibrados y anclas.
  - Brecha 3 (E2): Trigger de Context Reset con criterio conductual como condición primaria.
  - Brecha 4 (E10): Rituales E10-A (6 pasos) y E10-B (7 pasos) con secuencia concreta.
  - Brecha 5 (E1): GitHub como requisito explícito en E10-A paso 4.
  - Brecha 6 (E12): Regla crítica en Instancia B: persistir `orchestration_plan` antes de activar Workers.
  - Brecha 7: Numeración continua restaurada (9 → 10 → 11 → 12).
  - Brecha A (E9): Subsección "Evaluación Temprana" en Sección 7 con protocolo de ~20 casos.
  - Brecha B (E11): Subsección "Estrategia de Exploración" en Sección 5 con 4 pasos.
  - Brecha C (E5): Política de Fallback de Herramientas en Sección 6 (Reintento → Fallback → Escalamiento).
  - Brecha D (E6): Sección 4.2 "Regla de Referencias Ligeras" — Workers reportan solo paths/IDs.
  - Brecha E: Sección 12 reescrita completa (12.1→12.2→12.3→12.4→12.5), corregida jerarquía de llamadas, Single Writer Rule restaurada, canal C→B eliminado, gate intermedio y decisión final de A agregados. Jerarquía de llamadas documentada en Sección 3.
  - Ajuste adicional en 12.1: 3 vacíos del startup corregidos — (1) criterio explícito para detectar Inicio vs Continuación (existencia de `harness-state.json`); (2) reporte obligatorio de A al humano tras el ritual (estado, Sprint Contract propuesto, próxima acción); (3) gate de aprobación humana del Sprint Contract antes de spawear B, con ciclo de ajuste si el humano rechaza.

**Decisiones tomadas:**
- `principios.md` es la fuente de verdad inmutable. No se modifica nunca.
- `metodologia.md` queda cerrada tras implementar las 12 brechas.
- Los ajustes se documentan primero en `ajustes.md` antes de aplicarse, para trazabilidad.
- La carpeta `support/` es el espacio de trabajo operativo del harness.
- La jerarquía de llamadas es A→B→Workers y A→C. A nunca llama Workers directamente. C nunca llama a nadie.
- C escribe en `/eval/verdict.json`; solo A escribe en `harness-state.json` (Single Writer Rule).

---

## Próximos Pasos (en orden de prioridad)

### ACTIVO — PASO 3: Construir el 020 Specification Harness

El 010 Discovery Harness está completo y validado (dos pruebas APPROVED: 0.92 y 0.98).
El siguiente paso es construir el harness completo del 020 usando el 010 como patrón.

**Inputs disponibles para el 020:**
- `Harnesses/020_specification_harness.md` — definición de alto nivel (base conceptual)
- `Insumos/metodologia.md` — Patrón Universal de Fase (Secciones 3 y 12)
- `Test_Discovery_007/discovery/` — artefactos reales del 010 que el 020 consume como I-1

**Qué construir:**
- Agentes: `specification-governor`, `specification-orchestrator`, workers (`specification-*`)
- Skills: schemas de estado, transcript, análisis, síntesis y rúbrica para el 020
- Templates: actualizar `client-project-CLAUDE.md` para soportar el 020
- `deploy-harness.ps1` ya soporta `020` — solo faltan los archivos fuente

**Decisión pendiente antes de construir:**
- ¿Cuántos workers necesita el 020? El 010 tiene 3 (dialoguer → analyst → synthesizer).
  El 020 probablemente necesita: spec-writer (redacta), spec-reviewer (valida), spec-formatter (estructura final).
  Confirmar arquitectura antes de implementar.

### Pendiente post-Tracer Bullet

- [ ] **IMP-28** — Dashboard HTML en tiempo real (MENOR — pospuesto hasta terminar prueba)
- [ ] **IMP-22** — Knowledge cross-project con PostgreSQL + pgvector (SIGNIFICATIVA — requiere 3-5 proyectos completos primero)
- [ ] **PASO 3 (020–090):** Construir los harnesses completos restantes usando el 010 como patrón.
- [ ] **PASO 4:** Validar coherencia cruzada entre los 9 harnesses.
- [ ] **PASO 5:** Plantilla de Sprint Contract estándar.
- [ ] **PASO 6:** Plantilla de `metrics_summary.json` estándar.

---

## Reglas de Actualización de este Archivo

Al terminar cada sesión de trabajo, el agente activo debe:
1. Mover los "Próximos Pasos" completados al "Historial de Sesiones" de esa sesión.
2. Registrar las decisiones tomadas durante la sesión.
3. Actualizar la fecha de última actualización y la Fase actual.
4. Agregar los nuevos próximos pasos que emerjan.
