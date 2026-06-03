# Ajustes Pendientes de Implementación

Registro de ajustes identificados que aún no han sido implementados.
Todo lo ya implementado fue eliminado de este archivo.

---

## Tabla de Estado

| ID     | Descripción                                                                                                 | Prioridad     | Estado                     |
| ------ | ----------------------------------------------------------------------------------------------------------- | ------------- | -------------------------- |
| IMP-13 | GitHub no se enlaza desde el inicio (solo advertencia, no bloqueo)                                          | MENOR         | DIFERIDO ⏸                 |
| IMP-22 | No hay mecanismo de knowledge cross-project — aprendizajes no viajan entre proyectos                        | SIGNIFICATIVA | DISEÑADO — PENDIENTE IMPL. |
| IMP-28 | No existe dashboard HTML en tiempo real para observar el progreso del harness                               | MENOR         | PENDIENTE                  |
| ADJ-04 | Harness 040 Planning: rediseñar para trabajar bajo Vertical Slices con iteraciones                          | SIGNIFICATIVA | PENDIENTE                  |
| ADJ-05 | Harness 050 Iteration: renombrar a "050 Vertical Harness" y redefinir su scope                              | SIGNIFICATIVA | PENDIENTE                  |
| ADJ-06 | Harness 060 Isolation: limitar ejecución a la vertical slice / iteración activa                             | MENOR         | PENDIENTE                  |
| ADJ-07 | Harness 070 Execution: renombrar a "080 Development Harness" y reasignar numeración                         | MENOR         | PENDIENTE                  |
| ADJ-08 | README.md del proyecto: incluirlo en `deploy-harness.ps1` para que se copie al cliente                      | MENOR         | PENDIENTE                  |
| ADJ-09 | specification-governor.md: agregar Single Writer Rule explícita (NUNCA escribir en /specification/)         | SIGNIFICATIVA | IMPLEMENTADO ✅             |
| ADJ-10 | harness-state.json compartido: proteger contra corrupción al agregar claves de harness nuevo                | MENOR         | IMPLEMENTADO ✅             |
| ADJ-11 | specification-evaluator.md: verificar nombre de sección antes de extraer actores de shared_understanding.md | MENOR         | IMPLEMENTADO ✅             |
| ADJ-12 | Meta-Harness: referencia académica para optimización automática de harnesses                                | MENOR         | PENDIENTE                  |
| OBS-01 | Telemetría estructurada por agente (logs de ejecución JSON)                                                 | ALTA          | DIFERIDO ⏸                 |
| OBS-02 | Validación determinista de artefactos (scripts de verificación mecánica)                                    | ALTA          | DIFERIDO ⏸                 |
| OBS-03 | Post-mortem al cierre de fase con métricas de ejecución                                                     | MEDIA         | DIFERIDO ⏸                 |
| OBS-04 | Evaluación estructural post-worker (mini-eval automático)                                                   | MEDIA         | DIFERIDO ⏸                 |
| ADJ-13 | Demo Statements + Pending Verification como regla dura para harnesses 030+                                  | SIGNIFICATIVA | PENDIENTE                  |
| ADJ-14 | Governor marca PHASE_COMPLETE sin haber spawneado el evaluador — precondición del Cierre no se cumplió      | SIGNIFICATIVA | IMPLEMENTADO ✅ — bloqueo duro como primer tool call del Cierre (Sesión 35) |
| ADJ-15 | Agentes locales invocados como propósito general — restricciones de tools del frontmatter no se aplican     | SIGNIFICATIVA | RESUELTO POR ARQUITECTURA ✅ — governors spawean workers directamente (Sesión 35) |
| ADJ-16 | Governor escribe prompt del orchestrator a disco (orchestrator-prompt.txt) — comportamiento no diseñado     | MENOR         | IMPLEMENTADO ✅             |
| ADJ-17 | discovery-synthesizer escribe "APROBADO" en lugar de "APROBADO POR CLIENTE" — D5 penalizado a 0.8           | MENOR         | IMPLEMENTADO ✅ — governor edita shared_understanding.md post-CP-04 (Sesión 35) |
| ADJ-18 | Orchestrator reporta "no puede spawnear sub-agentes" — limitación de plataforma confirmada                  | SIGNIFICATIVA | RESUELTO POR ARQUITECTURA ✅ — orchestrators sin Agent tool; governors spawean workers (Sesión 35) |
| ADJ-19 | Agentes copiados por deploy en medio de sesión no son reconocidos — Claude Code requiere reinicio           | SIGNIFICATIVA | IMPLEMENTADO ✅ — Handoff instruye reinicio obligatorio en lugar de spawear (Sesión 35) |
| ADJ-20 | Governor reporta E10-A completo sin verificar que los comandos Bash realmente crearon carpetas y git       | SIGNIFICATIVA | IMPLEMENTADO ✅ — Sesión 39 |
| ADJ-21 | Workers que escriben markdown con `#` reciben prompt de seguridad repetitivo — interrumpe el flujo         | MENOR         | IMPLEMENTADO ✅ — `Write(*)` ya estaba en settings.json |
| ADJ-22 | Governor captura solo hitos formales en decisions_library.md (Sprint Contract, CP-04) pero omite decisiones de dominio sustantivas (resoluciones de contradicciones, exclusiones negociadas) | MENOR         | IMPLEMENTADO ✅ — Sesión 39 — Paso 3 explícito en Cierre de discovery-governor |
| ADJ-23 | CP-03 y CP-04 del 020 se conflaron en el mismo timestamp — governor no presenta CP-04 como gate independiente cuando el cliente incluye aprobación implícita en la respuesta del CP-03 | MENOR         | IMPLEMENTADO ✅ — Sesión 39 — Gate CP-03 registra evento y fuerza CP-04 independiente |
| ADJ-24 | claude-progress.txt tiene encoding corrupto (mojibake) en los eventos del 020 — afecta legibilidad del log de auditoría | MENOR         | IMPLEMENTADO ✅ — Sesión 39 — Add-Content -Encoding utf8 en ambos governors |

---

## Detalle

### IMP-13 — GitHub no se enlaza desde el inicio — DIFERIDO ⏸

**Prioridad:** MENOR
**Archivos afectados:** `discovery-governor.md` (E10-A Paso 4)

**Problema:**
El governor hace `git init` y registra una advertencia si no hay remote, pero no bloquea el
flujo. Según E1 de la metodología, el remote de GitHub es requisito para garantizar
trazabilidad (P8). La advertencia sin bloqueo hace que el riesgo sea invisible en la práctica.

**Opciones:**
- **Opción A (bloqueo duro):** Governor detiene el flujo hasta que el usuario configure el remote manualmente.
- **Opción B (asistido):** Governor intenta crear el repo con `gh repo create` si el CLI `gh` está disponible; si no, bloquea con instrucciones.
- **Opción C (actual):** Mantener advertencia sin bloqueo — acepta el riesgo explícitamente.

**Decisión actual (2026-05-28):** Opción C — mantener advertencia sin bloqueo. Diferido hasta
que el usuario lo solicite explícitamente o emerja un problema real de trazabilidad en producción.

---

### IMP-22 — Knowledge cross-project con PostgreSQL + pgvector — DISEÑADO — PENDIENTE IMPL.

**Prioridad:** SIGNIFICATIVA
**Archivos afectados:** governors de cada harness (cierre), `deploy-harness.ps1`, nuevo esquema PostgreSQL

**Problema:**
El `knowledge/` es local a cada proyecto. Al iniciar un proyecto nuevo, el banco de lecciones
aprendidas y decisiones tomadas arranca vacío — el aprendizaje acumulado de proyectos anteriores
se pierde. A medida que el banco crece, cargarlo completo al contexto se vuelve costoso e
impreciso (degradación por acumulación).

**Prerequisitos antes de implementar:**
- Al menos 3-5 proyectos completos para tener volumen suficiente que justifique la búsqueda
- Decidir schema de tablas y estrategia de embeddings (OpenAI, local, etc.)
- Analizar si el schema del 010 es extensible a los 9 harnesses antes de crear la DB

**Arquitectura objetivo (dos fases):**

**Fase 1 — Persistencia dual (corto plazo):**
- Al cerrar cada proyecto, el governor escribe en dos destinos simultáneamente:
  1. `knowledge/lessons_learned.md` y `knowledge/decisions_library.md` locales (sin cambio)
  2. PostgreSQL local — tablas `lessons_learned` y `decisions_library` con campos estructurados
- El deploy script siembra el `knowledge/` del nuevo proyecto copiando desde un banco global
- Sin búsqueda aún — solo acumulación estructurada

**Fase 2 — Búsqueda semántica con pgvector (mediano plazo):**
- PostgreSQL + extensión `pgvector` para almacenar embeddings de cada entrada
- Al iniciar un proyecto, el governor consulta la DB con el brief como query y recupera las N
  entradas más relevantes (búsqueda semántica, no keyword)
- Solo esas N entradas se cargan al contexto — contexto controlado independientemente del
  volumen total del banco

**Flujo completo (Fase 2):**
```
Proyecto cierra
     ├──► knowledge/*.md (local — lectura rápida del proyecto)
     └──► PostgreSQL local (lessons_learned + decisions_library + embeddings)

Proyecto nuevo inicia
     ├──► deploy script siembra knowledge/*.md desde banco global
     └──► governor consulta PostgreSQL con brief → carga top-N relevantes al contexto
```

**Tradeoff:**
PostgreSQL debe estar corriendo localmente. Para uso interno del equipo es manejable.
Para deployment en cliente requiere evaluación caso a caso.

---

### IMP-28 — Dashboard HTML en tiempo real — PENDIENTE

**Prioridad:** MENOR
**Archivos afectados:** Nuevo `dashboard.html` en `templates/`; `deploy-harness.ps1` para copiarlo

**Problema:**
El humano no tiene visibilidad en tiempo real de lo que cada agente está haciendo durante
la ejecución del harness. Para entender el progreso hay que leer archivos de texto
manualmente o esperar a que el governor haga preguntas.

**Arquitectura:**
- `dashboard.html` en la raíz del proyecto cliente (copiado por `deploy-harness.ps1`)
- JavaScript con `setInterval` cada 3 segundos hace `fetch()` a los archivos de estado
- Requiere servidor HTTP local mínimo:
  ```powershell
  python -m http.server 8080
  # Luego abrir http://localhost:8080/dashboard.html
  ```
- Los agentes no cambian — el dashboard solo lee los archivos que ya existen

**Contenido del dashboard:**
- **Timeline** — eventos de `persistence/claude-progress.txt` como línea de tiempo visual
- **Estado actual** — harness activo, modo (INICIO/CONTINUACIÓN), status desde `persistence/harness-state.json`
- **Checkpoints** — CP-01 a CP-04 con indicador visual (pendiente / alcanzado) desde `persistence/execution-state.json`
- **Agente activo** — inferido del último evento en `claude-progress.txt`
- **Artefactos producidos** — lista de archivos en `discovery/`, `specification/`, etc. con indicador de existencia

**Prerequisitos:**
- Python disponible en la máquina del usuario (para el servidor HTTP)

---

### ADJ-04 — Harness 040 Planning: rediseñar para Vertical Slices — PENDIENTE

**Prioridad:** SIGNIFICATIVA
**Archivos afectados:** `Harnesses/040_planning_harness.md`, agentes del 040 (por construir)

**Descripción:**
El 040 Planning debe planificar el proyecto completo bajo la metodología de Vertical Slices,
donde cada slice es una iteración funcional de extremo a extremo.

**Estructura de iteraciones:**
- **Tracer Bullet (obligatoria):** Primera iteración. Valida la arquitectura de punta a punta
  con la funcionalidad mínima posible. Demuestra que todas las capas se comunican.
- **Iteraciones intermedias (opcionales):** Entre Tracer Bullet y MVP. Agregan features,
  corrigen errores detectados o eliminan deuda técnica de la iteración anterior.
- **MVP (obligatoria):** Iteración que cumple el valor de negocio mínimo prometido al cliente.
- **Iteraciones intermedias (opcionales):** Entre MVP y Robustez. Agregan funcionalidades
  adicionales, corrigen errores o eliminan deuda técnica.
- **Robustez (obligatoria):** Iteración final que lleva el sistema al nivel de calidad,
  rendimiento y cobertura de casos de borde requerido para producción.

El 040 debe producir al menos 3 iteraciones (Tracer Bullet + MVP + Robustez) y el plan de
ejecución completo con los vertical slices definidos.

---

### ADJ-05 — Harness 050 Iteration: renombrar a "050 Vertical Harness" y redefinir scope — PENDIENTE

**Prioridad:** SIGNIFICATIVA
**Archivos afectados:** `Harnesses/050_iteration_harness.md`, agentes del 050 (por construir)

**Descripción:**
El 050 Vertical Harness trabaja exclusivamente en la definición de la iteración activa
(vertical slice) definida en el 040 Planning. También puede trabajar en corrección de
errores o eliminación de deuda técnica dejada por la iteración anterior.

**Artefactos que produce el 050:**

| Artefacto                             | Descripción                                                                                              |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `Proposal`                            | Objetivo de la iteración: qué incluye, qué no incluye, features esperadas. Legible para humano y agente. |
| `SDS` (Software Design Specification) | Arquitectura, interfaces y contratos de clases y funciones.                                              |
| `SDD` (Software Design Document)      | Especificación técnica detallada de lo que se construirá.                                                |
| `testing_plan`                        | Plan de pruebas para asegurar la calidad de la iteración.                                                |
| `execution_plan`                      | Plan de ejecución basado en Feature → Tickets → Tasks, bajo metodología TDD (Red → Green → Refactor).    |

---

### ADJ-06 — Harness 060 Isolation: limitar a la vertical slice activa — PENDIENTE

**Prioridad:** MENOR
**Archivos afectados:** `Harnesses/060_isolation_harness.md`, agentes del 060 (por construir)

**Descripción:**
El 060 Isolation se ejecutará exclusivamente en el contexto de la vertical slice / iteración
activa definida en el 040 y especificada en el 050. No opera sobre el proyecto completo —
solo sobre el scope de la iteración en curso.
---

### ADJ-07 — Harness 070/080: renombrar y reasignar numeración — PENDIENTE

**Prioridad:** MENOR
**Archivos afectados:** `Harnesses/070_execution_harness.md`, `Harnesses/080_verification_harness.md`

**Descripción:**
- El harness actualmente llamado `070_execution_harness` pasa a llamarse **`070 Development Harness`**.
  Su responsabilidad es la implementación de la iteración activa, construyendo el código
  basado en los documentos del 050 Vertical Harness.
- Revisar la numeración de todos los harnesses afectados por este cambio para mantener
  coherencia en la secuencia 010–090.

---

### ADJ-08 — README.md del proyecto: incluir en deploy-harness.ps1 — PENDIENTE

**Prioridad:** MENOR
**Archivos afectados:** `deploy-harness.ps1`, `README.md`

**Descripción:**
El `README.md` del repositorio `Harness_Definition` ya existe y documenta cómo usar el
proyecto. Falta incluir en `deploy-harness.ps1` la lógica para copiar el README al proyecto
cliente durante el deployment, de modo que cualquier persona que abra el proyecto destino
tenga acceso inmediato a las instrucciones de uso.

**Comportamiento esperado:** Solo copiar si no existe en el destino (igual que `CLAUDE.md`
y `settings.json` — no sobreescribir en re-deployments).

---

### ADJ-09 — specification-governor.md: Single Writer Rule explícita — IMPLEMENTADO ✅

**Prioridad:** SIGNIFICATIVA
**Archivos afectados:** `.claude/agents/specification-governor.md`

**Implementado en Sesión 31 (2026-05-31):**
Agregado bloque `## REGLA DE ESCRITURA — Single Writer Rule` en `specification-governor.md`,
entre la sección de skills y "Precondición absoluta". El bloque prohíbe explícitamente
escribir en `/specification/` y prescribe el camino correcto: registrar en
`persistence/claude-progress.txt` y spawear `specification-orchestrator` con referencia
a los cambios. Nunca aplicar cambios directamente.

---

### ADJ-10 — harness-state.json compartido: protección contra corrupción — IMPLEMENTADO ✅

**Prioridad:** MENOR
**Archivos afectados:** `.claude/agents/specification-governor.md` (Ritual E10-A Paso 3)

**Implementado en Sesión 31 (2026-05-31):**
Agregada instrucción de fallback en E10-A Paso 3 de `specification-governor.md`, antes
de escribir `harness-state.json`: si el parse falla → `git restore persistence/harness-state.json`
→ re-leer; si persiste el error → detener y reportar al humano con el error exacto.
No se intenta sobreescribir un archivo corrupto bajo ninguna circunstancia.

---

### ADJ-11 — specification-evaluator.md: verificación de sección antes de extraer actores — IMPLEMENTADO ✅

**Prioridad:** MENOR
**Archivos afectados:** `.claude/agents/specification-evaluator.md`

**Implementado en Sesión 31 (2026-05-31):**
Actualizado paso 1 de D1 en `specification-evaluator.md`: búsqueda flexible de la sección
de actores en `shared_understanding.md` — busca cualquier título que contenga la palabra
"Actor" (no solo "Actores y sus Necesidades"). Si no se encuentra ninguna sección con
"Actor" en el título: registrar advertencia en `findings` y usar la tabla de resumen de
`bdd_features.md` como fallback, sin penalización automática de score.

---

### ADJ-12 — Meta-Harness: referencia académica para optimización automática de harnesses — PENDIENTE

**Prioridad:** MENOR
**URL:** https://arxiv.org/abs/2603.28052

**Referencia:**
"Meta-Harness: End-to-End Optimization of Model Harnesses" (Stanford + MIT, Marzo 2026).
Paper académico que propone un bucle externo donde un coding agent (Claude Code con Opus 4.6)
propone, evalúa y refina harnesses automáticamente usando traces de ejecución completos.

**Resultados clave del paper:**
- TerminalBench-2 (coding): Haiku 4.5 alcanza #1 (37.6%), Opus 4.6 alcanza #2 (76.4%)
- Clasificación de texto: +7.7 puntos sobre ACE usando 4× menos tokens
- Razonamiento matemático: +4.7 puntos en 5 modelos no vistos durante el search
- Factor crítico: acceso a traces de ejecución completos (no solo scores)

**Aplicación a este proyecto:**
Nuestros harnesses ya tienen `eval/verdict.json` (reward signal) y metrics_summary.json
(trazabilidad). Con OBS-01 (telemetría estructurada) tendríamos los traces necesarios para
implementar un meta-harness que optimice automáticamente prompts, orden de workers y
umbrales de gate para los harnesses 030–090.

**Nota:** Esta entrada es referencial — no requiere implementación inmediata. Profundizar
en el diseño de adaptación antes de avanzar con harnesses 030–090.

---

### OBS-01 — Telemetría estructurada por agente (logs de ejecución) — DIFERIDO ⏸

**Prioridad:** ALTA
**Archivos afectados:** Todos los orchestrators, `deploy-harness.ps1`

**Problema:**
No hay visibilidad en tiempo real de lo que cada agente hace durante la ejecución.
Solo se sabe qué pasó cuando el evaluador termina. No hay registro estructurado de:
duración por worker, tokens consumidos, herramientas llamadas, decisiones tomadas.

**Ajuste requerido:**
Cada orchestrator debe escribir un log JSON por evento significativo en
`persistence/telemetry/`:

```json
{
  "event": "checkpoint_registered",
  "agent": "specification-orchestrator",
  "phase": "020_specification",
  "checkpoint": "CP-01",
  "worker": "specification-analyst",
  "result": "COMPLETED",
  "duration_seconds": 347,
  "tool_calls": 18,
  "errors": []
}
```

**Formato:** `persistence/telemetry/YYYY-MM-DDTHH-mm-ssZ_event_name.json`
**Escritor:** El orchestrator al recibir resultado de cada worker y al registrar cada checkpoint.
**Lectores:** Post-mortem, dashboard, análisis cross-project.

---

### OBS-02 — Validación determinista de artefactos (scripts de verificación) — DIFERIDO ⏸

**Prioridad:** ALTA
**Archivos afectados:** Nuevos scripts en `templates/validate/`, skills de verificación

**Problema:**
La evaluación es 100% LLM-as-judge. No hay checks mecánicos que detecten: IDs rotos
entre artefactos, JSON malformado, términos sin glosario.

**Ajuste requerido:**
Crear skills de verificación determinista que el evaluador ejecuta ANTES de su análisis:

| Skill                         | Qué hace                                                      | Lenguaje   |
| ----------------------------- | ------------------------------------------------------------- | ---------- |
| `validate-id-traceability`    | Cruza IDs entre artefactos (SC-xx, ACP-xx, EP-xx, EN-xx)      | PowerShell |
| `validate-schema-conformance` | Verifica que los JSON siguen el schema definido               | PowerShell |
| `validate-glossary-usage`     | Extrae términos técnicos y verifica contra domain_glossary.md | PowerShell |

**Flujo:** Evaluador carga skill → ejecuta script → recibe resultados estructurados →
los usa como evidencia en Fase 1 (pros/contras) → asigna score en Fase 2.

---

### OBS-03 — Post-mortem al cierre de fase — DIFERIDO ⏸

**Prioridad:** MEDIA
**Archivos afectados:** Todos los governors (sección de cierre)

**Problema:**
Al cerrar una fase solo queda `verdict.json` con scores. No hay un informe ejecutivo
que resuma: duración total, distribución por worker, cuello de botella, tendencias vs.
proyectos anteriores.

**Ajuste requerido:**
Al final del cierre, el governor genera `eval/postmortem_<phase>.md` con:
- Resumen de duración por worker (desde telemetría)
- Consumo de tokens estimado
- Preguntas al humano contabilizadas
- Iteraciones de rework
- Comparación con ejecuciones previas del mismo harness (desde metrics_summary.json)

---

### OBS-04 — Evaluación estructural post-worker (mini-eval automático) — DIFERIDO ⏸

**Prioridad:** MEDIA
**Archivos afectados:** Todos los orchestrators (paso posterior a cada worker)

**Problema:**
Actualmente el orchestrator recibe el resultado de un worker y avanza al siguiente sin
verificar mínimamente que el output es válido. El Early Eval del 020 es manual (otro LLM).

**Ajuste requerido:**
Después de cada worker, el orchestrator ejecuta una verificación estructural mínima
usando las skills de validación (OBS-02):
- ¿El archivo de salida existe?
- ¿Contiene las secciones obligatorias según el schema?
- ¿Los IDs siguen el formato esperado?
- Si alguna falla → el resultado del worker se marca como INCOMPLETO y se escala al
  governor sin avanzar al siguiente worker.

Esto NO reemplaza al evaluador (que es evaluación de calidad). Es verificación de
integridad estructural inmediata.

---

### ADJ-17 — discovery-synthesizer escribe "APROBADO" en lugar de "APROBADO POR CLIENTE" — IMPLEMENTADO ✅

**Prioridad:** MENOR
**Archivos afectados:** `.claude/agents/discovery-synthesizer.md`, `.claude/skills/discovery-synthesis-schema/SKILL.md`
**Detectado en:** `test_specification_001` — Sesión 32 (2026-05-31)

**Evidencia:**
El `discovery-evaluator` penalizó D5 a 0.8 por esta razón:
> "el campo Estado dice 'APROBADO' en lugar de la frase exacta requerida 'APROBADO POR CLIENTE'"

La frase exacta que el evaluador verifica según `discovery-rubric` es `"APROBADO POR CLIENTE"`.
El synthesizer escribió solo `"APROBADO"`. Gap de forma, no de fondo — la aprobación estaba
completa e inequívoca en el contenido, pero la frase no coincidió con la que verifica la rúbrica.

**Causa raíz:**
Inconsistencia entre el schema que usa el synthesizer para producir `shared_understanding.md`
y la frase exacta que el evaluador verifica en D5. El `discovery-synthesis-schema` no especifica
la frase exacta que debe aparecer en el campo Estado — deja ambigüedad.

**Fix:**
En `discovery-synthesis-schema/SKILL.md`, en la sección de `shared_understanding.md`, agregar
instrucción explícita: el campo Estado del documento debe ser exactamente `"APROBADO POR CLIENTE"`
(no "APROBADO", no "Aprobado por el cliente", no variantes). Esta frase es la que verifica D5
de la rúbrica.

**Implementado en Sesión 33 (2026-06-01):**
En `discovery-synthesis-schema/SKILL.md`: corregida la plantilla — sección "Aprobación del
Cliente" dice ahora `Estado: [PENDIENTE | APROBADO POR CLIENTE]`. Regla actualizada:
"Instance A actualiza a `APROBADO POR CLIENTE` tras CP-04. Esta frase exacta es la que
verifica D5 de la rúbrica — no usar variantes."

**PARCIALMENTE RESUELTO — Sesión 34 (2026-06-01):**
Revisión de `verdict.json` de `test_specification_002` reveló dos evaluaciones del 010:
- v1 (manual): `D5=0.0` veto — razón: "Falta 'Estado: APROBADO POR CLIENTE'"
- v2 (manual): `D5=1.0` — APPROVED

El synthesizer ahora escribe `PENDIENTE` correctamente (fix funciona). Sin embargo el
`claude-progress.txt` no registra ningún evento entre `[CP-04]` y `[CIERRE]` — el governor
no ejecutó el paso de actualizar `shared_understanding.md` de `PENDIENTE` a `APROBADO POR
CLIENTE` tras la aprobación. El usuario actualizó el archivo manualmente entre v1 y v2.

**Fix adicional requerido:** Verificar que `discovery-governor.md` tiene instrucción explícita
de editar `shared_understanding.md` cambiando `Estado: PENDIENTE` a `Estado: APROBADO POR
CLIENTE` inmediatamente después de recibir aprobación CP-04, antes de la sección Auditoría.

---

### ADJ-16 — Governor escribe prompt del orchestrator a disco — comportamiento no diseñado — IMPLEMENTADO ✅

**Prioridad:** MENOR
**Archivos afectados:** `discovery-governor.md`, `specification-governor.md` (y governors futuros)
**Detectado en:** `test_specification_001` — Sesión 32 (2026-05-31)

**Evidencia:**
Durante la ejecución del 020, el `specification-governor` creó `persistence/orchestrator-prompt.txt`
con el prompt completo (248 líneas) que pasó al `specification-orchestrator` al spawnearlo. Este
archivo no está definido en ningún schema ni instrucción de los agentes.

**Causa:**
El governor construyó un prompt muy largo para el orchestrator (incluyendo los prompts de los
dos workers embebidos). Al escribirlo a disco antes de invocarlo, el modelo externalizó la
construcción del prompt para no perder el contenido en el tool call.

**Por qué es relevante:**
El comportamiento tiene valor accidental como artefacto de debugging — permite leer exactamente
qué instrucciones recibió el orchestrator. Sin embargo, introduce dos riesgos no controlados:

1. **Riesgo de reanudación:** Si el orchestrator se re-spawnea (por interrupción o rechazo),
   podría leer `orchestrator-prompt.txt` como fuente de verdad y ejecutar instrucciones
   desactualizadas en lugar de que el governor regenere el prompt desde el estado actual.

2. **Contaminación del directorio de persistencia:** `persistence/` está definido como
   directorio de estado del harness (harness-state.json, execution-state.json,
   claude-progress.txt). Un archivo de prompt no estructurado rompe la semántica del directorio.

**Opciones a analizar:**

- **Opción A — Prohibir:** Agregar instrucción explícita en los governors: "No escribas el
  prompt del orchestrator a ningún archivo antes de spawnearlo. Construye el prompt inline
  en el tool call Agent."

- **Opción B — Estandarizar:** Si se considera útil para trazabilidad y resumabilidad,
  definir el archivo como artefacto oficial: nombre fijo `persistence/orchestrator-prompt.txt`,
  schema mínimo, y regla de que el governor lo sobreescribe en cada spawn (no lo acumula).
  El orchestrator NUNCA lo lee — solo el humano lo usa para debugging.

**Recomendación preliminar:** Opción A — el valor de trazabilidad ya lo cubre
`claude-progress.txt`. Un archivo de prompt no estructurado en `persistence/` agrega
ruido sin beneficio operacional real.

**Implementado en Sesión 33 (2026-06-01):**
Opción A aplicada. Sección "Ejecución Técnica" de `discovery-governor.md` y
`specification-governor.md` dice ahora: "Construir el prompt del orchestrator inline en el
tool call Agent. No escribir el prompt en ningún archivo previo a la invocación — no crear
`persistence/orchestrator-prompt.txt` ni equivalentes (LL-18)."

---

### ADJ-15 — Agentes locales invocados como propósito general — restricciones de tools no aplicadas — IMPLEMENTADO ✅

**Prioridad:** SIGNIFICATIVA
**Archivos afectados:** Todos los agentes en `.claude/agents/` (010 y 020)
**Detectado en:** `test_specification_001` — Sesión 32 (2026-05-31)

**Evidencia:**
Durante la ejecución del 020, un agente reportó explícitamente: *"Los agentes del 020 están
instalados localmente pero no como subagent_type del sistema. Los invoco como agentes de
propósito general leyendo su definición."*

**Problema:**
Claude Code soporta dos formas de invocar agentes locales desde `.claude/agents/`:

1. **Como `subagent_type` nombrado** — el sistema carga el `.md` completo incluyendo
   frontmatter (`tools:`, `model:`), aplica las restricciones declaradas. Forma correcta.
2. **Como agente de propósito general** — se spawea un agente genérico con el contenido
   del `.md` como prompt. Las restricciones del frontmatter se **ignoran** completamente.

Cuando los governors y orchestrators invocan workers usando la segunda forma, un agente
declarado como `tools: [Read, Write]` tiene en la práctica acceso a todas las herramientas
disponibles (`Bash`, `Agent`, `Edit`, etc.). Las restricciones son decorativas, no aplicadas.

**Impacto real:**
- Los workers bien escritos probablemente no abusan de las herramientas extra — el riesgo
  inmediato es bajo.
- Sin embargo, la Single Writer Rule y otras garantías de aislamiento dependen parcialmente
  de que los workers no puedan invocar `Agent` o `Write` en rutas prohibidas. Si pueden
  usar cualquier herramienta, esas garantías son solo de prompt, no estructurales.
- El evaluador (Instancia C) con acceso irrestricto a herramientas podría en teoría modificar
  artefactos que debería solo leer.

**Causa raíz a investigar:**
- ¿El problema es cómo el governor/orchestrator construye el prompt del Agent tool (no pasa
  `subagent_type` correctamente)?
- ¿O es una limitación de Claude Code donde los agentes locales no se registran como
  `subagent_type` válidos en el entorno donde se ejecutan los governors?

**Opciones de fix a analizar:**
- **Opción A:** Verificar que los governors usen el nombre exacto del agente como
  `subagent_type` en la llamada al Agent tool, no como texto libre en el prompt.
- **Opción B:** Agregar una capa de verificación en el orchestrator que confirme que el
  worker fue invocado como subagent_type nombrado (si hay forma observable de saberlo).
- **Opción C:** Aceptar como limitación de la plataforma y compensar con instrucciones
  explícitas en cada agente: "aunque tengas acceso a otras herramientas, SOLO usa las
  declaradas en tu frontmatter".

**Cuándo investigar:** Antes de construir harnesses 030+ donde los workers producen código
ejecutable y las restricciones de herramientas tienen mayor importancia de seguridad.

**Implementado en Sesión 33 (2026-06-01):**
Investigación confirmó Opción A. Causa raíz: las instrucciones de los orchestrators/governors
decían "invocar via Agent" con un prompt en texto, sin especificar `subagent_type`. Fix aplicado
en 4 archivos — cada invocación ahora incluye el nombre del agente como `subagent_type`:
- `discovery-orchestrator.md`: Workers 1/2/3 (discovery-dialoguer, discovery-analyst, discovery-synthesizer)
- `specification-orchestrator.md`: specification-analyst, specification-evaluator (Early Eval), specification-writer
- `discovery-governor.md`: discovery-orchestrator, discovery-evaluator, specification-governor (handoff)
- `specification-governor.md`: specification-orchestrator, specification-evaluator

**LIMITACIÓN DE PLATAFORMA CONFIRMADA — Sesión 34 (2026-06-01):**
`test_specification_002` confirmó que el fix de Sesión 33 no resuelve el problema raíz.
El `discovery-orchestrator` reportó: "no puede spawnear sub-agentes directamente". Causa:
Claude Code no permite que agentes spawneados via `Agent` tool usen a su vez el tool `Agent`
para crear más sub-agentes. Pasar `subagent_type` en las instrucciones de texto no es suficiente
si la plataforma bloquea el acceso al tool.

**Impacto real:** Los workers fueron ejecutados por el orchestrator leyendo sus definiciones
directamente (sin `subagent_type`), lo que significa que las restricciones de `tools:` del
frontmatter no se aplicaron. Los artefactos se produjeron correctamente porque los workers
siguieron sus instrucciones de prompt, pero el aislamiento estructural no existe.

**Rediseño arquitectónico requerido (ver ADJ-18, LL-21):**
La cadena governor → orchestrator → workers no puede funcionar si el orchestrator es spawneado.
Opciones: (1) governor spawea workers directamente eliminando el orchestrator como intermediario
de spawning, (2) orchestrator invocado directamente por el usuario como agente raíz.

---

### ADJ-14 — Governor marca PHASE_COMPLETE sin haber spawneado el evaluador — IMPLEMENTADO ✅

**Prioridad:** SIGNIFICATIVA
**Archivos afectados:** `discovery-governor.md`, `specification-governor.md` (y governors futuros)
**Detectado en:** `test_specification_001` — Sesión 32 (2026-05-31)

**Evidencia:**
En `test_specification_001`, el `discovery-governor` marcó `status: PHASE_COMPLETE` en
`harness-state.json` y activó el handoff al 020, pero la carpeta `eval/` quedó vacía —
`verdict.json` y `metrics_summary.json` nunca se crearon. El evaluador no fue spawneado.

El diseño del governor es correcto: existe la sección "Auditoría" con la instrucción de
spawear `discovery-evaluator`, y existe la precondición en Cierre que debe verificar
`eval/verdict.json` antes de continuar. Sin embargo, ambas salvaguardas fallaron en la práctica.

**Causa raíz probable:**
El governor perdió hilo de ejecución tras recibir la aprobación CP-04 (posiblemente por
longitud del contexto de la sesión) y saltó directamente al cierre omitiendo la sección
"Auditoría". La precondición del Cierre, que debería haber bloqueado este salto, no fue
respetada — el modelo no la verificó antes de escribir PHASE_COMPLETE.

**Opciones de fix a analizar:**

- **Opción A — Refuerzo de prompt:** Agregar en el governor, inmediatamente después del gate
  CP-04, una instrucción explícita tipo "ALTO — ANTES DE CONTINUAR: verificar que
  `eval/verdict.json` existe. Si no existe, ejecutar Auditoría ahora." El problema es que
  este tipo de checks inline ya falló una vez.

- **Opción B — Escritura de estado intermedio:** Antes de iniciar el Cierre, el governor
  escribe en `harness-state.json` un estado `AUDIT_PENDING`. Solo después de que el evaluador
  escribe `verdict.json` se avanza a `PHASE_COMPLETE`. Si el governor se interrumpe, el estado
  `AUDIT_PENDING` en E10-B lo redirige a Auditoría antes de cualquier otra acción.

- **Opción C — Evaluador como precondición dura de E10-B:** La tabla de selección de E10-B
  agrega una fila explícita: si `status == EXECUTION_COMPLETE` y `eval/verdict.json` no existe
  → ir a Auditoría directamente, sin pasar por ningún gate.

**Recomendación preliminar:** Opción B + C combinadas. B introduce un estado observable que
persiste entre interrupciones; C garantiza que la reanudación también cubra el caso.

**Cuándo implementar:** Antes de ejecutar `test_specification_001` con el 020 — el
`specification-governor` tiene el mismo patrón y podría fallar igual.

**Implementado en Sesión 33 (2026-06-01):**
Opción B + C combinadas aplicadas en `discovery-governor.md` y `specification-governor.md`:
- **Opción B:** Sección "Auditoría" escribe `status: "AUDIT_PENDING"` en `harness-state.json`
  (raíz para el 010 / `"020_specification".status` para el 020) antes de spawear el evaluador.
  Registra `[AUDIT_PENDING]` en `claude-progress.txt`.
- **Opción C (VERIFICACIÓN PREVIA):** E10-B Paso 6 incluye bloque antes de la tabla: si
  `status == "AUDIT_PENDING"` → ir directamente a Auditoría, sin consultar la tabla.

**REINCIDENTE en test_specification_002 — Sesión 34 (2026-06-01):**
El `discovery-governor` volvió a completar el cierre sin spawear el evaluador — `eval/` quedó
vacía nuevamente. El fix de Sesión 33 (AUDIT_PENDING + VERIFICACIÓN PREVIA en E10-B) no tuvo
efecto en la práctica.

**Hipótesis sobre por qué el fix no funcionó:**
- El fix asume que el governor escribe `AUDIT_PENDING` *antes* de saltar al Cierre. Pero si
  el governor salta directamente al Cierre sin pasar por la sección "Auditoría" (el mismo bug
  original), nunca escribe `AUDIT_PENDING` y la VERIFICACIÓN PREVIA de E10-B nunca se activa.
  El fix es correcto para *reanudar* una sesión interrumpida, pero no previene el salto inicial.
- Posible relación con ADJ-18: si el governor no puede spawear el evaluador (limitación de
  plataforma para spawear sub-agentes desde un agente), la sección "Auditoría" falla
  silenciosamente y el governor avanza al Cierre sin registrar el error.

**Acción requerida (analizar al finalizar el test):**
1. Verificar en `harness-state.json` si `status` llegó a ser `AUDIT_PENDING` en algún momento,
   o si el governor saltó directamente a `PHASE_COMPLETE`.
2. Si nunca fue `AUDIT_PENDING`: el problema no es la reanudación sino la ejecución inicial —
   el governor no ejecuta la sección "Auditoría" en ningún caso.
3. Considerar rediseño: mover la precondición de auditoría al *inicio* del Cierre como bloqueo
   duro ("si `eval/verdict.json` no existe → DETENER, no continuar bajo ninguna circunstancia"),
   en lugar de confiar en que el governor ejecute la sección "Auditoría" de forma secuencial.

---

### ADJ-18 — Orchestrator reporta "no puede spawnear sub-agentes" durante test_spec_002 — PENDIENTE

**Prioridad:** SIGNIFICATIVA
**Archivos afectados:** `.claude/agents/discovery-orchestrator.md` (potencialmente todos los orchestrators)
**Detectado en:** `test_specification_002` — Sesión 34 (2026-06-01)

**Evidencia:**
Durante la ejecución del 010 en test_spec_002, el `discovery-orchestrator` emitió el mensaje:
> "El orchestrator no puede spawnear sub-agentes directamente, así que coordinaré la cadena desde aquí. Invoco discovery-dialoguer para las entrevistas."

**Problema:**
ADJ-15 (Sesión 33) aplicó el fix de agregar `subagent_type` en las instrucciones de invocación
de los orchestrators/governors. Sin embargo, el mensaje indica que el orchestrator aún no está
usando el `Agent` tool con `subagent_type` para spawear workers — o no puede hacerlo desde
su contexto de ejecución.

**Posibles causas (a determinar al finalizar el test):**

1. **Fix incompleto:** Las instrucciones actualizadas en `discovery-orchestrator.md` no fueron
   suficientes para que el modelo use el tool `Agent` con `subagent_type`. El orchestrator
   leyó el fix pero aún no lo ejecuta correctamente.

2. **Limitación de plataforma:** Los agentes spawneados via `Agent` tool (como el orchestrator,
   que es invocado por el governor) no pueden a su vez usar el `Agent` tool para crear
   sub-agentes. Si esto es una limitación estructural de Claude Code, ADJ-15 no puede
   resolverse con instrucciones de prompt.

3. **Herramienta `Agent` ausente en tools del orchestrator:** Verificar que `discovery-orchestrator.md`
   declara `Agent` en su frontmatter `tools:`. Si no está listada, el orchestrator no tiene acceso
   a ella independientemente de las instrucciones.

**Qué observar durante el resto del test:**
- ¿El dialoguer condujo las entrevistas correctamente a pesar de no ser spawneado como subagent_type?
- ¿El orchestrator "coordina desde aquí" significa que ejecutó el dialoguer de otra forma (leyendo
  su definición e imitando su comportamiento), o simplemente hizo él mismo las entrevistas?
- ¿Se aplicaron las restricciones de `tools:` del dialoguer?

**Acción al finalizar el test:**
1. Leer el frontmatter de `discovery-orchestrator.md` — verificar si `Agent` está en `tools:`
2. Determinar causa raíz entre las 3 opciones de arriba
3. Decidir si ADJ-15 requiere un fix adicional o si es una limitación de plataforma que
   exige rediseño arquitectónico (orchestrator sin capacidad de spawear → governor debe
   spawear workers directamente)

---

### ADJ-19 — Agentes copiados por deploy en medio de sesión no son reconocidos — PENDIENTE

**Prioridad:** SIGNIFICATIVA
**Archivos afectados:** `deploy-harness.ps1`, `templates/client-project-CLAUDE.md`, governors (sección Handoff)
**Detectado en:** `test_specification_002` — Sesión 34 (2026-06-01)

**Evidencia:**
Tras el handoff automático 010 → 020, el discovery-governor ejecutó `deploy-harness.ps1` para
el 020 en la misma sesión. Al intentar invocar `specification-governor` inmediatamente después,
el sistema reportó:
> "Agent type 'specification-governor' not found."

Los archivos `.claude/agents/specification-*.md` y `.claude/skills/specification-*/` fueron
copiados correctamente al proyecto cliente, pero Claude Code no los reconoció como agentes
disponibles porque la lista de agentes se carga al **iniciar la sesión**, no dinámicamente.

**Problema:**
El handoff automático diseñado en Sesión 29 asume que el governor puede deployar y spawear
el siguiente governor en la misma sesión activa. La plataforma no soporta este flujo — los
agentes nuevos solo están disponibles después de reiniciar Claude Code.

**Impacto:**
- El handoff automático diseñado nunca puede funcionar como está concebido si el deploy
  ocurre en la misma sesión que el spawn.
- El governor lo resuelve degradando: lee el `.md` directamente e intenta ejecutar el agente
  como general-purpose, perdiendo las restricciones de `tools:` del frontmatter (mismo
  problema que ADJ-15/ADJ-18).

**Opciones a analizar:**

1. **Reinicio obligatorio explícito:** El handoff no intenta spawear el siguiente governor.
   En su lugar, instrucción al humano: "Deploy completado. Reinicia la sesión — el CLAUDE.md
   detectará el estado DEPLOYED y arrancará specification-governor automáticamente."
   Pros: simple, confiable. Contras: rompe el flujo "automático" diseñado en Sesión 29.

2. **Pre-deploy de todos los harnesses al inicio:** El script despliega 010 + 020 (y los que
   apliquen) en el setup inicial del proyecto, antes de arrancar cualquier governor. Todos los
   agentes están disponibles desde el arranque de la primera sesión.
   Pros: elimina el problema de raíz. Contras: despliega agentes que aún no son necesarios;
   requiere saber de antemano qué harnesses usará el proyecto.

3. **Deploy selectivo con reinicio guiado:** El governor pregunta al humano si quiere continuar
   con el 020, ejecuta el deploy, y luego muestra instrucciones claras de reinicio con el
   estado guardado en `harness-state.json` para que CLAUDE.md lo retome.

**Recomendación preliminar:** Opción 1 a corto plazo (mínimo cambio), Opción 2 a mediano
plazo si los proyectos siempre usan la misma secuencia de harnesses.

**Relación con otros ajustes:** ADJ-18 y ADJ-15 — los tres apuntan a la misma limitación
raíz: los agentes locales no se comportan como agentes de sistema registrados en tiempo
de ejecución.

---

### ADJ-20 — Governor reporta E10-A completo sin verificar que los Bash crearon carpetas y git — IMPLEMENTADO ✅

**Prioridad:** SIGNIFICATIVA
**Archivos afectados:** `discovery-governor.md`, `specification-governor.md` (y governors futuros)
**Detectado en:** `test_specification_003` — Sesión 36 (2026-06-01)

**Evidencia:**
En `test_specification_003`, el `claude-progress.txt` registró:
> `[E10-A COMPLETO] 2026-06-01T00:00:30Z — Ritual de inicio completado; carpetas, archivos y git listos`

Sin embargo, la inspección del directorio del test reveló que solo existen `discovery/` y `persistence/` — las carpetas `eval/`, `knowledge/` y `changes/` no fueron creadas, y `.git/` no existe. El governor escribió el mensaje de éxito sin verificar que los comandos Bash realmente se ejecutaron.

**Causa raíz:**
El E10-A Paso 2 del governor instruye ejecutar `mkdir -p discovery eval changes knowledge persistence` y el Paso 4 instruye `git init`. El governor aparentemente no ejecutó esos comandos Bash (o los ejecutó y fallaron silenciosamente) y procedió a escribir los archivos de estado directamente. La herramienta `Write` creó `discovery/` y `persistence/` como efecto secundario al escribir los archivos en esas rutas. `eval/`, `knowledge/` y `changes/` nunca recibieron una escritura, por lo que nunca se crearon.

**Impacto en el test:**
- `eval/` — **bloqueante**: el evaluador intentará escribir `eval/verdict.json` y `eval/metrics_summary.json`. Si el directorio no existe, la escritura puede fallar.
- `knowledge/` — **bloqueante en cierre**: el governor escribe `knowledge/lessons_learned.md` al cerrar la fase.
- `changes/` — no bloqueante en el flujo principal.
- `.git` — el commit final fallará: `git add` y `git commit` no funcionan sin repositorio inicializado.

**Fix requerido:**
Dos cambios en E10-A de ambos governors:

1. **Verificar existencia de carpetas después de crearlas:** Tras el `mkdir`, verificar con `Test-Path` (PowerShell) o `ls` que las 5 carpetas existen. Si alguna falta, crearla individualmente y registrar la advertencia en `claude-progress.txt`.

2. **Verificar git init:** Tras el `git init`, verificar que `.git/` existe con `Test-Path .git`. Si no existe, registrar error crítico y detener el flujo — el commit final fallará sin repositorio.

**Alternativa más robusta:**
Reemplazar el `mkdir -p` único por creaciones individuales explícitas con verificación:
```powershell
foreach ($dir in @('discovery','eval','changes','knowledge','persistence')) {
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory $dir | Out-Null }
}
```
Esto elimina la dependencia de que `mkdir -p` funcione correctamente en el entorno (PowerShell vs Bash).

---

### ADJ-21 — Workers que escriben markdown con `#` reciben prompt de seguridad repetitivo — IMPLEMENTADO ✅

**Prioridad:** MENOR
**Archivos afectados:** `templates/client-project-settings.json`
**Detectado en:** `test_specification_003` — Sesión 36 (2026-06-01)

**Problema:**
El hook de validación de path de Claude Code activa un prompt de confirmación cada vez que un agente pasa un argumento que contiene una newline seguida de `#`. En la práctica, esto ocurre en cada sección de un artefacto markdown (encabezados `## Sección`, `### Subsección`, etc.). El usuario recibe el mensaje:

> "Newline followed by # inside a quoted argument can hide arguments from path validation. Do you want to proceed?"

Esto interrumpe el flujo en cada Write de sección, requiriendo que el usuario responda "Yes" manualmente decenas de veces durante la ejecución de discovery-analyst, discovery-synthesizer, specification-writer y cualquier worker que produzca documentos markdown con estructura de encabezados.

**Causa:**
El aviso es una medida de seguridad legítima del shell contra inyección de argumentos. En el contexto del harness es un falso positivo — los workers solo escriben markdown, nunca argumentos de shell.

**Fix:**
Agregar una regla de permiso en `templates/client-project-settings.json` que autorice este patrón para las herramientas de escritura del harness. La regla debe ser específica al contexto de escritura de archivos markdown, no un bypass global de seguridad.

```json
{
  "permissions": {
    "allow": [
      "Write(*)"
    ]
  }
}
```

Alternativamente, revisar si existe una configuración más granular en Claude Code que permita silenciar este aviso específico solo para la herramienta `Write` sin afectar la validación de `Bash`.

---

### ADJ-22 — Governor captura solo hitos formales en decisions_library.md — IMPLEMENTADO ✅

**Implementado en Sesión 39 (2026-06-01):**
Agregado Paso 3 explícito en la sección Cierre de `discovery-governor.md`. El nuevo paso instruye capturar 4 categorías obligatorias: resoluciones de contradicciones C-xx, exclusiones negociadas, restricciones aceptadas para v1, y decisiones de scope con impacto en harnesses posteriores. Instrucción explícita: "NO limitarse a hitos procedimentales".

---

### ADJ-23 — CP-03 y CP-04 del 020 conflados — IMPLEMENTADO ✅

**Implementado en Sesión 39 (2026-06-01):**
En `specification-governor.md`, Gate CP-03: añadido registro explícito `[CP-03 020]` en `claude-progress.txt` y bloque IMPORTANTE que fuerza presentar CP-04 como `AskUserQuestion` separado, aunque la respuesta del CP-03 incluya aprobación total.

---

### ADJ-24 — Encoding corrupto en claude-progress.txt — IMPLEMENTADO ✅

**Implementado en Sesión 39 (2026-06-01):**
Agregada sección "Escritura en claude-progress.txt — Encoding UTF-8 (ADJ-24)" en `discovery-governor.md` y `specification-governor.md`. Regla: usar `Add-Content -Encoding utf8` para todas las escrituras en ese archivo, nunca el tool `Write`. Añadidos `"Bash(New-Item *)"`, `"Bash(Test-Path *)"` y `"Bash(Add-Content *)"` a `templates/client-project-settings.json`.

---

### ADJ-13 — Demo Statements + Pending Verification como regla dura para harnesses 030+ — PENDIENTE

**Prioridad:** SIGNIFICATIVA
**Archivos afectados:** Orchestrators y Workers de harnesses 030+ (Design, Vertical, Development)
**Origen:** Video "Build AI Agents That Actually Verify Their Own Work" (GeeksforGeeks, 2026-05-30)

**Problema:**
Los Workers actuales arrancan a producir sin definir primero "¿cómo se ve esto funcionando?"
en lenguaje natural observable. El video muestra que este es el mayor factor de calidad:
sin un **demo statement** explícito, los agentes optimizan para "escribí código" en vez de
"el sistema funciona".

Además, no hay un estado **Pending Verification** que bloquee al orchestrator de spawneur
el siguiente worker si el anterior no ha sido verificado. Los checkpoints existentes son
procedimentales, no invariantes duros.

**Relevancia:**
Para el 010 (Discovery) y 020 (Specification) el riesgo es bajo porque los artefactos son
documentación revisable por humano. Pero para los harnesses 030+ que producirán código
ejecutable (Design → Vertical → Development), la brecha de verificación es crítica.

**Ajuste requerido:**

1. **Demo Statements obligatorios** en orchestration_plan:
   - Antes de spawneur un Worker, el orchestrator debe escribir un demo statement:
     "Cuando este worker termine, podré observar que..."
   - El Worker debe poder demostrar el demo statement antes de reportar COMPLETED.
   - Si no puede demostrarlo, reporta INCOMPLETO con la razón.

2. **Pending Verification como estado de bloqueo**:
   - Después de que un Worker reporta COMPLETED, el orchestrator NO spawnea el siguiente
     Worker hasta que el evaluador emite veredicto (APROBADO/RECHAZO).
   - Si el evaluador RECHAZA, el Worker no puede ser re-spawneado sin intervención del governor.
   - Esto NO reemplaza el flujo actual de checkpoints (CP-01..CP-04) — lo refuerza.

**Forma concreta de implementar:**
```
Worker recibe tarea
  ├── Lee demo statement del orchestration_plan
  ├── Produce artefacto
  ├── Intenta demostrar el demo statement
  │     ├── ✅ Puede demostrar → reporta COMPLETED
  │     └── ❌ No puede → reporta INCOMPLETO + razón
  └── Resultado → orchestrator

Orchestrator recibe COMPLETED
  ├── Registra checkpoint
  ├── Spawea evaluador (Early Eval o Eval completo)
  ├── NO avanza al siguiente worker
  └── Espera veredicto para continuar
```

**Cuándo implementar:**
Incluir en el diseño de los harnesses 030+ desde el inicio. No modificar 010/020 existentes
(PI-3 — cambios quirúrgicos, ya están completos y funcionales).

---

