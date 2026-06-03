# Ajustes Pendientes de Implementación

Registro de ajustes identificados que aún no han sido implementados.

> **Historial completo:** ver `support/history/ajustes_design.md` (ADJ-13..ADJ-32 del 030 Design Harness).

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
| ADJ-24 | 010 Discovery: modelo de entrevista síncrona genera latencia y limita paralelismo — evaluar modelo async con cuestionario + ronda de gaps | SIGNIFICATIVA | PENDIENTE — evaluar antes de construir el 040 |
| ADJ-25 | FORGE CLI: automatizar arranque de proyecto con forge-setup.ps1, forge.config.json y slash commands /forge-init + /forge-discovery | SIGNIFICATIVA | PENDIENTE |

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

**Impacto en el 030 — IMPLEMENTADO (Sesión 49 + ADJ-32 Sesión 61):**
El `test_strategy_map.md` incluye la "Guía de Vertical Slices" con nomenclatura formal, 5 campos
obligatorios por slice (nombre, tipo, IC-xx, BDD scenarios, criterio de Done) y reglas de
granularidad (piso mínimo por IC-xx/MOD-xx + criterio de división 3/2/10). El 040 hereda este
draft y lo consolida.

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
