# Lecciones Aprendidas — Construcción de Harnesses

Registro de lecciones derivadas de las pruebas del 010 Discovery Harness y del
`test_specification_001` (010 + 020 end-to-end).
Cada lección aplica universalmente a cualquier harness que se construya.

**Fuente original:** `support/history/ajustes_discovery.md` — IMP-01 a IMP-31.
**Análisis aplicado:** Sesión 30 (2026-05-29) — contraste sistemático 010 vs 020.
**Actualización:** Sesión 32 (2026-05-31) — `test_specification_001` end-to-end (ADJ-14 a ADJ-17).

---

## LL-01 — Write obligatorio antes de reportar (Workers)

**Regla:** El Write del artefacto de salida es el **primer tool call** después de completar
el análisis o la producción. Sin excepción. El Worker nunca reporta a B antes de haber
escrito el archivo en disco.

**Por qué:** El modelo puede completar el análisis en su contexto y tomar el camino
"listo → reportar" sin pasar por el Write. El archivo no existe en disco pero el
orchestrator registra el checkpoint aceptando el reporte verbal.

**Cómo implementar:** En la sección del Worker que describe cuándo escribir, agregar
una línea en negrita:

> "El Write de `<path>` es el primer tool call después de completar `<tarea>`.
> Sin excepción. No reportar a B antes de haber escrito este archivo."

**Origen:** IMP-23, IMP-27 — discovery-analyst.

---

## LL-02 — REGLAS DE ESCRITURA en el Orchestrator

**Regla:** Todo orchestrator debe tener una sección "REGLAS DE ESCRITURA — LEER ANTES
DE CUALQUIER ACCIÓN" que liste explícitamente:
- Qué **puede** escribir directamente (solo `persistence/execution-state.json`).
- Qué **nunca** puede escribir directamente (las carpetas de output de los Workers).
- Mensaje de DETENTE si tiene la tentación de escribir en carpetas de Workers.

**Por qué:** El orchestrator tiene acceso al tool Write. Sin prohibición explícita, el
modelo toma el camino corto y produce los artefactos directamente sin invocar Workers.
Ningún agente se ejecuta; los artefactos se generan sin el proceso real.

**Cómo implementar:** Bloque al inicio del cuerpo del agente, antes de "Al iniciar":

```
## REGLAS DE ESCRITURA — LEER ANTES DE CUALQUIER ACCIÓN

Puedes escribir directamente: `persistence/execution-state.json`
NUNCA puedes escribir directamente: [carpeta de artefactos del harness]

Si tienes la tentación de escribir en [carpeta] directamente: DETENTE.
La única forma de producir artefactos es invocar el Worker con el tool `Agent`.
```

**Origen:** IMP-19 — discovery-orchestrator.

---

## LL-03 — PATHS DE SALIDA explícitos en el Evaluador

**Regla:** La sección "Al terminar" del evaluador debe comenzar con un bloque
"PATHS DE SALIDA — OBLIGATORIO" que indique explícitamente dónde escribir los archivos
de evaluación y dónde **no** escribirlos.

**Por qué:** El evaluador acaba de leer todos los artefactos desde la carpeta del harness
(ej. `specification/`). El modelo infiere que el output va al mismo lugar. El governor
tiene precondición sobre `eval/verdict.json` — si el evaluador lo escribe en `specification/`,
la precondición falla y el flujo se bloquea.

**Cómo implementar:**

```
## Al terminar

PATHS DE SALIDA — OBLIGATORIO. Escribir SOLO en `eval/`, NUNCA en `[carpeta del harness]/`:
- `eval/verdict.json`
- `eval/metrics_summary.json`
```

**Origen:** IMP-31 — discovery-evaluator.

---

## LL-04 — Precondición de auditoría en el Cierre del Governor

**Regla:** La sección "Cierre" del governor debe comenzar con una precondición que
verifique que el evaluador corrió antes de ejecutar ningún paso del cierre.
La verificación es: `eval/verdict.json` existe **y** contiene al menos una entrada
con `"phase": "<id_del_harness>"`.

**Por qué:** El governor puede ser re-spawnado con un prompt que lo lleve directamente
al cierre, saltando la sección de auditoría. La fase queda marcada PHASE_COMPLETE sin
haber pasado por el gate de calidad.

**Cómo implementar:**

```
## Cierre

**PRECONDICIÓN — Verificar auditoría completada:**
Verificar que `eval/verdict.json` existe y tiene al menos una entrada con
`"phase": "<id>"`. Si no: ejecutar la sección "Auditoría" completa primero.
No saltar este paso bajo ninguna circunstancia.
```

**Origen:** IMP-20 — discovery-governor.

---

## LL-05 — Timestamps reales al inicio de cada agente que escribe estado

**Regla:** Todo agente que escriba timestamps en archivos de estado debe tener al
inicio de su cuerpo (antes de "Al iniciar") una sección "Timestamps reales" con el
comando para obtener el valor real del sistema. Nunca usar horas redondas ni valores fijos.

**Por qué:** Sin instrucción explícita, el modelo usa valores placeholder (`00:00:00`,
`21:00:00`) que dejan el historial de estado sin valor temporal real. Afecta la
trazabilidad y la legibilidad de `claude-progress.txt`.

**Cómo implementar:**


## Timestamps reales

Antes de cualquier escritura que requiera un timestamp ISO 8601, ejecutar:
```bash
(Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
```
Sustituir el placeholder con el valor real. Nunca usar horas redondas ni valores fijos.


Aplica a: governor y orchestrator de cada harness.

**Origen:** IMP-08, IMP-21 — discovery-governor, discovery-orchestrator.

---

## LL-06 — Protocolo de 5 pasos para registrar checkpoints

**Regla:** Registrar un checkpoint nunca es "escribir un campo en el JSON". Es un
protocolo de 5 pasos que incluye verificación y bloqueo duro:

1. Leer `persistence/execution-state.json` (estado actual completo).
2. Actualizar los campos del checkpoint manteniendo todos los campos existentes.
3. Escribir el archivo completo actualizado.
4. Leer el archivo de nuevo para verificar que el valor cambió.
5. **Si la verificación falla: NO continuar al siguiente Worker. Registrar error y
   reportar a governor.**

**Por qué:** Sin verificación, el orchestrator registra "CP-01 completado" en su
contexto aunque la escritura haya fallado silenciosamente. Tras una interrupción,
el estado de reanudación es incorrecto.

**Origen:** IMP-24 — discovery-orchestrator.

---

## LL-07 — Protocolo de dos fases para evaluación (análisis → score)

**Regla:** Todo evaluador opera en dos fases obligatorias en ese orden. No se puede
saltear ni invertir:

- **Fase 1 — Análisis:** Para cada dimensión, construir lista de pros (evidencia de
  cumplimiento, con cita de artefacto y sección) y lista de contras (evidencia de
  incumplimiento o ausencia, con cita). No se puede declarar un gap sin citarlo.
  No se puede declarar que algo está bien sin evidencia concreta.

- **Fase 2 — Score:** Solo tras el análisis, asignar score consistente con la evidencia.
  Score no puede ser mayor que lo que los pros justifican, ni menor que lo que los
  contras demuestran.

**Regla de oro:** No otorga beneficio de la duda, pero tampoco penaliza sin citar el
gap específico.

**Por qué:** Sin protocolo, el evaluador improvisa con sesgo negativo (rechazos falsos)
o laxo (aprobaciones sin evidencia). Ambos generan trabajo innecesario o riesgo real.

**Origen:** IMP-16 — discovery-evaluator.

---

## LL-08 — Propiedad clara de execution-state.json entre governor y orchestrator

**Regla:**
- **Governor (E10-A):** crea `persistence/execution-state.json` con estructura mínima
  (todos los campos en `null` o valores iniciales). Esta creación ocurre antes de
  spawear el orchestrator.
- **Orchestrator (Paso 4):** escribe el `orchestration_plan` completo sobre el archivo
  ya existente. Si no existe (caso de fallo del governor), lo crea como fallback.
- **Workers:** nunca tocan `execution-state.json`. Single Writer Rule.

**Por qué:** Sin esta definición, hay ambigüedad sobre quién crea el archivo primero.
Si el orchestrator intenta leerlo antes de que exista, el flujo falla silenciosamente.

**Origen:** IMP-01 — discovery-governor, discovery-orchestrator.

---

## LL-09 — Resolver inputs reales antes de persistir el orchestration_plan

**Regla:** El orchestrator, antes de escribir su `orchestration_plan` en
`execution-state.json`, debe intentar leer cada archivo de input y registrar el path
real si existe, o `null` explícito si no existe. Nunca persistir placeholders.

**Por qué:** Sin esta verificación, los inputs quedan como `null` en el plan. Si hay
una reanudación desde un checkpoint intermedio, el orchestrator no sabe dónde están
los inputs y pasa `null` a los Workers en lugar de los paths reales.

**Origen:** IMP-26 — discovery-orchestrator.

---

## LL-10 — Single Writer Rule: Governor no escribe en carpetas de artefactos

**Regla:** El governor nunca escribe en las carpetas de artefactos del harness (ej.
`/discovery/`, `/specification/`). Si recibe respuestas del cliente que parecen
datos que deberían ir en esas carpetas, debe re-spawear el orchestrator con contexto
completo, nunca escribir directamente.

**Por qué:** El governor tiene acceso al tool Write. Si recibe una respuesta del
usuario "fuera de flujo" durante CP-03/CP-04 y toma el camino corto, puede escribir
en la carpeta de artefactos violando la Single Writer Rule.

**Cómo implementar:** Agregar en la sección del governor que gestiona respuestas del
cliente una regla explícita:

> "El governor nunca escribe en `[carpeta de artefactos]/`. Toda producción de
> artefactos pasa exclusivamente por el orchestrator → Workers."

**Origen:** IMP-09 — discovery-governor. Gap K identificado en specification-governor.

---

## LL-11 — Agentes multi-modo: instrucción explícita por modo

**Regla:** Todo agente que opere en más de un modo (ej. evaluador en modo Early Eval
vs auditoría formal) debe tener instrucción explícita de qué está permitido y prohibido
en cada modo. El modo se comunica vía el prompt del orchestrator y debe ser reconocido
por el agente antes de actuar.

**Caso concreto — Evaluador en Early Eval:**
- Modo Early Eval: evaluar un artefacto parcial, retornar score inline, **NO escribir
  ningún archivo**.
- Modo auditoría formal: evaluar los 4 artefactos finales, escribir `eval/verdict.json`
  y `eval/metrics_summary.json`.

**Por qué:** Sin distinción explícita, el evaluador puede escribir `eval/verdict.json`
durante Early Eval, produciendo un veredicto prematuro que confunde al governor.

**Origen:** Riesgo N1 identificado en análisis del 020 (Sesión 30).

---

## LL-12 — Protección de archivos de estado compartidos entre harnesses

**Regla:** Cuando un harness modifica un archivo de estado que fue creado por un
harness anterior (ej. `harness-state.json` compartido entre 010 y 020), el agente
debe:
1. Leer el archivo completo.
2. Modificar solo los campos de su harness (agregar clave nueva, no tocar campos raíz).
3. Escribir el archivo completo con todos los campos anteriores intactos.

**Riesgo adicional:** Si el JSON está malformado antes de la lectura, el parse falla.
El agente debe detectar este caso y no sobreescribir con datos parciales.

**Por qué:** Una escritura parcial o un parse fallido puede corrupcionar el estado de
un harness anterior (ej. borrar campos del 010 al agregar campos del 020).

**Origen:** Riesgo N2 identificado en análisis del 020 (Sesión 30).

---

## LL-13 — Verificación de artefacto en disco antes de registrar checkpoint

**Regla:** El orchestrator nunca registra un checkpoint basándose solo en el reporte
verbal del Worker. Antes de escribir CP-XX, debe leer el artefacto esperado y verificar
que existe y tiene contenido. Si el archivo no existe o está vacío → WORKER_FAILED,
no registrar checkpoint.

**Por qué:** El Worker puede retornar "listo" sin haber escrito el archivo. Sin
verificación en disco, el orchestrator registra el checkpoint y el siguiente Worker
falla al intentar leer el artefacto que no existe.

**Relación con LL-01:** LL-01 previene el problema en el Worker; LL-13 es la red de
seguridad en el orchestrator si LL-01 falla.

**Origen:** IMP-23, IMP-27, IMP-29 — discovery-orchestrator.

---

## LL-14 — Permisos pre-autorizados en settings.json del proyecto cliente

**Regla:** El script de deployment debe copiar un `settings.json` con permisos
pre-autorizados para las operaciones que los agentes necesitan: Read, Write, Bash (git),
Bash (mkdir), Agent. Sin estos permisos, el primer spawn falla y el governor re-spawna
innecesariamente.

**Por qué:** El flujo agéntico se rompe cuando Claude Code pausa para solicitar
aprobación interactiva durante un spawn. Esto crea loops de re-spawn o estados
inconsistentes en `execution-state.json`.

**Origen:** IMP-10 — prueba test_discovery — settings.json faltante en proyecto cliente.

---

## LL-15 — Evaluador debe verificar formato de fuente de verdad antes de extraer

**Regla:** Cuando el evaluador extrae datos de un artefacto producido por un harness
anterior (ej. lista de actores desde `shared_understanding.md` del 010 para verificar
D1 en el 020), debe verificar que la sección esperada existe antes de extraer. Si la
sección tiene un nombre diferente, registrar advertencia y degradar la dimensión
afectada en lugar de fallar silenciosamente.

**Por qué:** El evaluador del 020 asume que `shared_understanding.md` tiene una sección
"Actores y sus Necesidades". Si el 010 produjo esa sección con un nombre diferente, el
evaluador no encuentra los actores y penaliza D1 sin evidencia real de incumplimiento.

**Origen:** Riesgo N3 identificado en análisis del 020 (Sesión 30).

---

## LL-16 — Estado intermedio AUDIT_PENDING antes de PHASE_COMPLETE

**Regla:** El governor nunca escribe `status: PHASE_COMPLETE` directamente después de
recibir la aprobación CP-04. El flujo obligatorio es:

1. Escribir `status: "AUDIT_PENDING"` en `harness-state.json`.
2. Spawear el evaluador.
3. Confirmar que `eval/verdict.json` contiene una entrada con el phase correcto.
4. Solo entonces escribir `status: "PHASE_COMPLETE"`.

Además, en la tabla E10-B de reanudación, agregar fila explícita:
si `status == EXECUTION_COMPLETE` y `eval/verdict.json` no tiene entrada de este phase
→ ir directamente a Auditoría sin pasar por ningún gate.

**Por qué:** En `test_specification_001`, el 010 governor marcó PHASE_COMPLETE sin haber
spawneado el evaluador. La precondición del Cierre (LL-04) existe pero no se cumplió —
el modelo saltó la sección de Auditoría al perder hilo tras CP-04 en una sesión larga.
El estado intermedio AUDIT_PENDING hace imposible este salto: si el governor se interrumpe
después de escribirlo, E10-B lo redirige a Auditoría en la siguiente reanudación.

**Complementa:** LL-04 — LL-04 es la red de seguridad reactiva (precondición que verifica
antes del cierre); LL-16 es la prevención activa (estado en disco que impide llegar al
cierre sin haber auditado).

**Origen:** ADJ-14 — `test_specification_001` (Sesión 32, 2026-05-31).

---

## LL-17 — Schema de producción y rúbrica deben compartir frases exactas

**Regla:** Toda frase que el evaluador verifique textualmente en un artefacto (ej. el
valor del campo "Estado" en `shared_understanding.md`) debe estar especificada con esa
misma frase exacta en el schema que el Worker usa para producir ese artefacto. No pueden
ser variantes semánticamente equivalentes — deben ser cadenas idénticas.

**Cómo implementar:** En el schema de producción (ej. `discovery-synthesis-schema`),
para cualquier campo de estado o aprobación, agregar:
> "El valor de este campo debe ser exactamente `'<frase>'` — esta es la cadena que
> verifica D5 de la rúbrica. No usar variantes."

**Por qué:** En `test_specification_001`, el `discovery-synthesizer` escribió `"APROBADO"`
en el campo Estado de `shared_understanding.md`. El evaluador verifica la frase
`"APROBADO POR CLIENTE"`. La aprobación era completa e inequívoca en el contenido, pero
la cadena no coincidió — D5 se penalizó a 0.8. El gap es evitable con una instrucción
de una línea en el schema.

**Aplica a:** Cualquier campo en cualquier artefacto que la rúbrica verifique
textualmente. Revisar sistemáticamente cada harness nuevo al definir la rúbrica.

**Origen:** ADJ-17 — `test_specification_001` (Sesión 32, 2026-05-31).

---

## LL-18 — Governor no escribe el prompt del orchestrator a disco

**Regla:** El governor nunca escribe el prompt que va a pasar al orchestrator en un
archivo antes de spawnearlo. El prompt se construye inline en el tool call `Agent`.
No crear archivos como `persistence/orchestrator-prompt.txt` ni equivalentes.

**Por qué:** En `test_specification_001`, el `specification-governor` creó
`persistence/orchestrator-prompt.txt` antes de spawear el orchestrator. Riesgos:
(1) Si el orchestrator se re-spawnea en una reanudación, podría leer ese archivo como
fuente de verdad y ejecutar instrucciones desactualizadas. (2) Contamina `persistence/`
con un archivo no estructurado que rompe la semántica del directorio (que es exclusivo
para estado del harness, no para prompts de construcción).

**Cómo implementar:** Agregar en la sección del governor que spawnea el orchestrator:
> "Construir el prompt del orchestrator inline en el tool call Agent. No escribir el
> prompt en ningún archivo previo a la invocación."

**Origen:** ADJ-16 — `test_specification_001` (Sesión 32, 2026-05-31).

---

## LL-19 — Verificar que subagent_type se pasa correctamente al invocar Workers

**Regla:** Cuando un governor u orchestrator spawnea un Worker, el nombre del agente
debe pasarse como `subagent_type` en el tool call `Agent` — no embebido como texto
en el prompt. Sin `subagent_type` correcto, el sistema invoca un agente de propósito
general que lee el `.md` del Worker como contexto pero no aplica las restricciones de
`tools:` declaradas en el frontmatter.

**Impacto:** Un Worker declarado como `tools: [Read, Write]` puede en la práctica usar
`Bash`, `Agent`, `Edit` u otras herramientas. La Single Writer Rule y otras garantías
de aislamiento quedan como promesas de prompt, no controles estructurales.

**Cómo verificar:** Antes de implementar un harness nuevo, revisar que las invocaciones
de Workers en el orchestrator usen el nombre del agente como `subagent_type`, no como
campo en el body del prompt.

**Estado:** Confirmado como limitación de plataforma en `test_specification_002`: el
orchestrator (spawneado por el governor) reportó explícitamente que no podía usar el
tool `Agent` para spawear sub-agentes. Pasar `subagent_type` en las instrucciones no es
suficiente si la plataforma no permite spawning anidado. Ver LL-21.

**Origen:** ADJ-15 — `test_specification_001` (Sesión 32, 2026-05-31).

---

## LL-20 — Precondición de Cierre como bloqueo duro, no como verificación secuencial

**Regla:** La sección "Cierre" del governor debe comenzar con un bloqueo absoluto e
incondicional como el **primer tool call** de esa sección:

```
## Cierre

ANTES DE CUALQUIER ACCIÓN — VERIFICACIÓN OBLIGATORIA:
1. Leer `eval/verdict.json`.
2. Verificar que existe al menos una entrada con `"phase": "<id>"`.
3. Si NO existe → DETENER completamente. No escribir PHASE_COMPLETE.
   No continuar bajo ninguna circunstancia. Ejecutar la sección Auditoría ahora.
```

Este bloqueo debe ser el primer paso, no una "precondición" que el modelo puede saltarse
si pierde el hilo entre secciones.

**Por qué:** En dos tests consecutivos (`test_specification_001` y `test_specification_002`),
el `discovery-governor` marcó `PHASE_COMPLETE` sin haber spawneado el evaluador. El fix de
LL-16 (estado AUDIT_PENDING + VERIFICACIÓN PREVIA en E10-B) no fue suficiente porque el
governor saltó la sección "Auditoría" sin escribir nunca ese estado. El modelo no ejecuta
secciones en orden lineal garantizado — si el contexto es largo o el hilo se interrumpe,
puede pasar directamente al Cierre. El único control confiable es un bloqueo al inicio del
Cierre que verifique el disco antes de ejecutar cualquier otra cosa.

**Diferencia con LL-04 y LL-16:**
- LL-04: precondición declarada en texto (falló dos veces)
- LL-16: estado intermedio AUDIT_PENDING (falló porque nunca se escribe si se salta la sección)
- LL-20: verificación de disco como primer tool call del Cierre (confiable independientemente
  del orden de ejecución del modelo)

**Origen:** ADJ-14 reincidente — `test_specification_002` (Sesión 34, 2026-06-01).

---

## LL-21 — Agentes spawneados no pueden spawear sub-agentes (limitación de plataforma)

**Regla:** Al diseñar la arquitectura de un harness, asumir que **los agentes spawneados
via `Agent` tool no pueden a su vez usar el `Agent` tool para crear más sub-agentes**.
Esta es una limitación estructural de Claude Code, no un error de configuración.

**Implicaciones de diseño:**
- El orchestrator no puede spawear workers directamente si él mismo fue spawneado por el governor.
- La cadena `governor → orchestrator → workers` no funciona si el orchestrator necesita
  usar el tool `Agent`.
- El orchestrator degrada gracefully: lee la definición del worker e imita su comportamiento,
  pero sin las restricciones de `tools:` del frontmatter.

**Alternativas arquitectónicas a evaluar:**
1. **Governor spawea workers directamente:** Elimina el orchestrator como intermediario de
   spawning. El governor coordina la cadena completa. El orchestrator se convierte en un
   "gestor de estado" (solo escribe execution-state.json) sin spawning propio.
2. **Orchestrator como agente raíz:** El usuario invoca el orchestrator directamente (no
   spawneado por el governor), así puede usar el tool `Agent`. El governor solo prepara el
   estado y presenta al humano, sin spawear el orchestrator.
3. **Pre-deploy y restart:** Todos los harnesses se despliegan al inicio del proyecto antes
   de arrancar cualquier governor. El governor del siguiente harness se invoca desde una
   nueva sesión donde todos los agentes están disponibles.

**Origen:** ADJ-18 — `test_specification_002` (Sesión 34, 2026-06-01).

---

## LL-22 — Agentes deployados en sesión activa no son reconocidos sin reinicio

**Regla:** Claude Code carga la lista de agentes disponibles al iniciar la sesión. Los
archivos copiados a `.claude/agents/` durante una sesión activa **no están disponibles**
hasta que se reinicia Claude Code. Nunca diseñar un flujo que asuma que un agente recién
deployado puede ser invocado inmediatamente en la misma sesión.

**Implicaciones para el handoff:**
- El handoff automático `governor → deploy → spawn siguiente governor` no puede funcionar
  en una sola sesión si el siguiente harness no estaba pre-deployado.
- Si el governor intenta invocarlo, el sistema lo ejecuta como agente de propósito general
  leyendo el `.md` directamente — sin frontmatter, sin restricciones de tools.

**Cómo implementar correctamente:**
- **Opción A (corto plazo):** El governor, tras ejecutar el deploy, instruye al humano
  explícitamente: "Reinicia la sesión. El CLAUDE.md detectará el estado DEPLOYED y arrancará
  el siguiente governor automáticamente." No intenta spawear el agente en la sesión actual.
- **Opción B (mediano plazo):** `deploy-harness.ps1` despliega todos los harnesses de la
  secuencia (010 + 020 + 030...) en el setup inicial del proyecto. Todos los agentes están
  disponibles desde el arranque de la primera sesión.

**Origen:** ADJ-19 — `test_specification_002` (Sesión 34, 2026-06-01).

---

## LL-23 — Governor debe actualizar shared_understanding.md post-CP-04 explícitamente

**Regla:** El governor debe tener una instrucción explícita de editar `shared_understanding.md`
para cambiar `Estado: PENDIENTE` a `Estado: APROBADO POR CLIENTE` inmediatamente después de
recibir la aprobación CP-04, como paso numerado antes de la sección Auditoría. No asumir que
el synthesizer ya lo escribió en el valor final — el synthesizer escribe `PENDIENTE` por diseño.

**Por qué:** El synthesizer produce `shared_understanding.md` con `Estado: PENDIENTE` (correcto
por LL-17). Es responsabilidad del governor actualizarlo a `APROBADO POR CLIENTE` tras CP-04.
Sin instrucción explícita, el governor puede omitir este paso. En `test_specification_002`, el
evaluador encontró `PENDIENTE` en la primera ejecución (D5=0.0 veto) porque el governor no
ejecutó la actualización antes del cierre.

**Cómo implementar:**
```
## Tras recibir aprobación CP-04

Paso 1 — Actualizar shared_understanding.md:
Editar `discovery/shared_understanding.md`, campo Estado de la sección "Aprobación del Cliente":
  Cambiar: `Estado: PENDIENTE`
  A:       `Estado: APROBADO POR CLIENTE`
Esta edición es obligatoria antes de cualquier otro paso del cierre.
```

**Relación con LL-17:** LL-17 garantiza que el synthesizer usa la frase correcta en el schema.
LL-23 garantiza que el governor ejecuta la transición de estado. Ambas son necesarias.

**Origen:** ADJ-17 parcial — `test_specification_002` (Sesión 34, 2026-06-01).

---

## LL-24 — Demo Statement del orchestrator debe citar explícitamente cada sección obligatoria del artefacto

**Regla:** Cuando un artefacto tiene secciones obligatorias con nombre propio (como la "Guía
de Vertical Slices" en `test_strategy_map.md`), el Demo Statement que el orchestrator escribe
para ese Worker **debe nombrarlas textualmente**. No es suficiente mencionar el artefacto en
general.

**Por qué:** En el test end-to-end del 030, design-architect omitió la Guía de Vertical Slices
en su primer pase. El Demo Statement decía "produce test_strategy_map.md (estrategia mock/stub
por interface)" — exactamente lo que el architect entregó. La guía no fue detectada hasta la
revisión manual en CP-03. El self-checklist del architect tampoco la atrapó porque el Demo
Statement era su fuente de verdad y no la mencionaba.

**Cómo implementar:** En design-orchestrator (modo PLAN), el Demo Statement de design-architect
debe incluir:

> "...y test_strategy_map.md (estrategia Fake/Mock/Real por interface IC-xx **y sección
> obligatoria 'Guía de Vertical Slices' con ≥3 iteraciones: Tracer Bullet, MVP y Robustez
> como mínimo**)"

**Regla general:** Antes de escribir un Demo Statement para cualquier Worker, revisar el schema
del artefacto (design-synthesis-schema, specification-synthesis-schema, etc.) y listar todas
las secciones marcadas como obligatorias. Si el Demo Statement no las nombra, el Worker puede
omitirlas sin violar su contrato.

**Origen:** Test end-to-end 030 (Sesión 45, 2026-06-02).

---

## LL-25 — CP-03 y CP-04 deben implementarse como AskUserQuestion estructuralmente independientes

**Regla:** La presentación de CP-04 debe ser un `AskUserQuestion` separado que el governor
ejecuta **incondicionalmente** después de registrar CP-03, sin importar el contenido de la
respuesta del cliente en CP-03. Si la respuesta del CP-03 ya contiene lenguaje de aprobación
("aprobado, continúa"), el governor de igual forma presenta el CP-04 como interacción separada.

**Por qué:** En el test del 030 y del 020, ambos governors colapsaron CP-03 y CP-04 en una
sola interacción: el timestamp y el texto de aprobación de CP-04 son idénticos a los de CP-03.
Esto viola ADJ-23. El problema ocurre porque el modelo evalúa la eficiencia ("el cliente ya
dijo que aprueba") y omite la segunda interacción. La separación de gates existe por razones
de trazabilidad y responsabilidad, no de comodidad.

**Cómo implementar:** En el governor, la sección del Gate CP-04 debe comenzar con:

```
## Gate CP-04 — Aprobación formal (siempre separado de CP-03)

IMPORTANTE: Este gate siempre se presenta como una interacción nueva con AskUserQuestion,
independientemente de lo que el cliente haya respondido en CP-03. Si la respuesta de CP-03
ya incluía "aprobado" o "continúa con CP-04", igual se presenta este gate con su propio
timestamp. La aprobación de CP-03 (revisión de draft) y CP-04 (aprobación formal) son
eventos distintos con semántica distinta.
```

**Aplica a:** discovery-governor, specification-governor, design-governor, y todos los
governors futuros con gates CP-03/CP-04.

**Origen:** Test end-to-end 030 y 020 (Sesiones 34 y 45, 2026-06-02). Violación confirmada
en ambos harnesses con timestamps idénticos.

---

## LL-26 — La nomenclatura de interfaces debe ser consistente entre design-analyst y design-architect

**Regla:** El design-analyst debe usar la nomenclatura `IC-xx` (no `IF-xx`) para identificar
las interfaces requeridas en el `design_analysis_report.md`, de forma que los IDs sean
directamente trazables a los `IC-xx` que produce design-architect en `contract_definitions.md`.

**Por qué:** En el test del 030, el analyst usó `IF-01..IF-06` y el architect produjo
`IC-01..IC-09`. La numeración es parcialmente coincidente (IF-01 ≈ IC-01) pero el architect
agregó 3 interfaces nuevas (IC-07, IC-08, IC-09) sin referencia en el analysis report. No
existe tabla de mapeo IF-xx → IC-xx en ningún artefacto. Un implementador que lea ambos
documentos debe inferir la correspondencia, y en proyectos más complejos ese gap puede
generar confusión o interfaces huérfanas.

**Cómo implementar (dos opciones — elegir una):**

- **Opción A (recomendada):** Cambiar el design-analyst-protocol y design-analysis-schema
  para que use `IC-xx` desde el inicio. El analyst identifica `IC-01..IC-N` y el architect
  los completa, extiende con servicios de dominio, y los formaliza con métodos y DTOs.

- **Opción B:** Mantener `IF-xx` en el analysis report y requerir que `contract_definitions.md`
  incluya una tabla de mapeo explícito `IF-xx → IC-xx` al inicio del documento.

**Aplica a:** design-analyst-protocol, design-analysis-schema, y el prompt del analyst en
design-governor.

**Origen:** Test end-to-end 030 (Sesión 45, 2026-06-02).

---

## LL-27 — CP-03 humano no es suficiente para detectar inconsistencias técnicas entre artefactos

**Regla:** Para harnesses con artefactos estructurados e IDs cruzados (020 y 030), debe
existir un agente reviewer dedicado que corra entre CP-02 (Workers terminan) y CP-03
(revisión humana). La carga de detectar gaps técnicos — referencias huérfanas, secciones
obligatorias faltantes, IDs sin destino — no debe recaer en el humano.

**Por qué:** En testing del 030, el humano encontró durante CP-03 inconsistencias técnicas
que requirieron rework. El evaluador ya verifica D5 (consistencia) pero corre post-CP-04:
demasiado tarde para evitar que el humano revise documentos inconsistentes o para dar
rework sin interrumpir el gate formal de aprobación.

**Cómo implementar:**
1. Agregar un agente reviewer por harness: `specification-reviewer` (020) y `design-reviewer` (030).
2. El reviewer corre después de CP-02 y antes de CP-03.
3. Si hay issues críticos → governor re-spawea el Worker afectado para rework. El humano
   no ve los artefactos hasta que estén limpios.
4. Si hay issues menores → governor los presenta junto a los artefactos en CP-03 con
   diagnóstico ya hecho. El humano decide con información completa.
5. El harness 010 queda excluido: artefactos cualitativos sin IDs formales, valor bajo.

**Diferencia con el evaluador (D5):** El evaluador es auditor independiente post-aprobación
que puntúa contra la rúbrica. El reviewer es control de calidad pre-aprobación que verifica
consistencia estructural. Ambos son necesarios y complementarios.

**Aplica a:** specification-governor, design-governor, y todos los governors futuros con
artefactos estructurados e IDs cruzados.

**Origen:** Observación post test_specification_003 (Sesión 46, 2026-06-01).

---

## LL-28 — Workers interactivos no pueden correr como subagentes del governor

**Regla:** Todo worker que use `AskUserQuestion` para interactuar con el usuario real
debe ser invocado directamente desde la sesión principal (CLAUDE.md / workflow), nunca
spawneado por el governor. El governor debe retornar una señal `DIALOGUER_REQUIRED`
(o equivalente) para que el CLAUDE.md lo invoque en la cadena correcta.

**Por qué:** Cuando el governor corre como subagente del CLAUDE.md y a su vez intenta
spawear un worker interactivo, se forma la cadena `CLAUDE.md → Agent(governor) →
Agent(dialoguer)`. En este contexto anidado, `AskUserQuestion` no bloquea en el usuario
real — el modelo "completa la tarea" fabricando preguntas y respuestas inventadas. El
transcript resultante parece válido estructuralmente pero contiene información que el
usuario nunca proveyó.

**Cómo implementar:**
1. En el governor (modo EXECUTE): si el transcript no existe, registrar en
   `claude-progress.txt` y retornar `GOVERNOR_RESULT: status: DIALOGUER_REQUIRED`
   con los inputs necesarios.
2. En el workflow (ciclo_010_discovery.md, Paso C): al recibir `DIALOGUER_REQUIRED`,
   invocar el dialoguer directamente (`subagent_type: "discovery-dialoguer"`) desde
   el CLAUDE.md. Al terminar, re-invocar el governor con `dialoguer_complete: true`.
3. En el governor (modo EXECUTE): si el prompt incluye `dialoguer_complete: true`,
   saltar el paso de spawning y verificar directamente que el transcript existe y
   tiene `Estado global: COMPLETO`.

**Regla general:** Antes de que un governor spawee un worker, verificar si ese worker
usa `AskUserQuestion`. Si sí → el governor no puede spawearlo; debe delegar al workflow.

**Workers interactivos actuales:** discovery-dialoguer.
**Workers no interactivos (pueden ser spawneados por governor):** todos los demás
(analyst, synthesizer, architect, evaluator, reviewer).

**Origen:** Test e2e 010→020→030, Sesión 57 (2026-06-02). discovery-dialoguer fabricó
el transcript completo sin preguntar al usuario.

---

## LL-29 — Ruta de escritura explícita al inicio del agente (Workers con archivo único acumulativo)

**Regla:** Todo worker que produce un único archivo acumulativo a lo largo de toda la sesión
(como `dialogue_transcript.md`) debe tener al inicio de su cuerpo un bloque
"RUTA DE ESCRITURA — OBLIGATORIO" que declare:
- La ruta exacta del archivo.
- La carpeta esperada y la instrucción de crearla si no existe.
- Una prohibición explícita de estructuras alternativas (carpetas por stakeholder, archivos por sesión, etc.).

**Cómo implementar:**

```
## RUTA DE ESCRITURA — OBLIGATORIO

Un único archivo. Una única ruta. Sin excepciones:

`/010_discovery/dialogue_transcript.md`

NO crear carpetas `transcript/`, `persistence/transcript/` ni archivos por stakeholder (ej. `transcript_S01.md`).
Toda la sesión — todos los stakeholders, todas las rondas — vive en ese único archivo.
Crear la carpeta `/010_discovery/` si no existe antes de escribir.
```

**Por qué:** En Test_Harness_002, el `discovery-dialoguer` ignoró tanto la referencia de ruta
en la "Regla fundamental de persistencia" del agente como la ruta en la skill
`discovery-transcript-schema`, y creó `persistence/transcript/transcript_S01.md` — una
estructura plausible (un archivo por stakeholder dentro de persistence) pero incorrecta.
El LLM construye rutas alternativas plausibles cuando la instrucción de ruta no es
suficientemente prominente. Una referencia enterrada en texto narrativo no es suficiente.

**Diferencia con LL-03:** LL-03 aplica a evaluadores (múltiples archivos de output en carpeta
específica). LL-29 aplica a workers con un único archivo acumulativo donde el riesgo es
inventar una estructura de carpetas, no escribir en la carpeta equivocada.

**Workers donde aplica actualmente:** `discovery-dialoguer` (transcript acumulativo por sesión).
**Workers donde NO aplica:** analyst, synthesizer, architect, reviewer, evaluator — estos
producen un archivo por ejecución y LL-01 es suficiente.

**Origen:** Test_Harness_002 (2026-06-03). discovery-dialoguer creó `persistence/transcript/transcript_S01.md`
en lugar de `/010_discovery/dialogue_transcript.md`.
