# Plan de Construcción — 010 Discovery Harness

## Meta

Construir el harness completo para la fase Discovery implementando el Patrón Universal de Fase
de `Insumos/metodologia.md`. La base conceptual ya existe en `Harnesses/010_discovery_harness.md`
(definición de alto nivel aprobada). Este plan es el blueprint que guía la reescritura de ese
archivo como harness completo.

### Checklist de completitud

El harness completo debe contener estas 7 secciones:
- [ ] Fase 0 — Definición Estructural
- [ ] Fase 1 — Diseño Agéntico (6 sub-secciones)
- [ ] Sprint Contract (plantilla)
- [ ] Workers Especializados
- [ ] Rúbrica de Evaluación (con few-shot y anclas)
- [ ] Handoff Artifact → 020
- [ ] Flujo del Arnés (12.1–12.5)

---

## Sección 1 — Fase 0: Definición Estructural

### Propósito

Capturar la intención pura del cliente y eliminar toda ambigüedad antes de proceder a cualquier
definición técnica. El Discovery no produce código — produce comprensión compartida documentada
y aprobada explícitamente por el cliente.

### Inputs

| # | Input | Descripción |
|---|-------|-------------|
| I-1 | Brief Inicial | Conversaciones, notas sueltas o descripción general de lo que el cliente quiere construir |
| I-2 | Contexto del Negocio | Dominio, usuarios objetivo, problema que se resuelve |
| I-3 | Restricciones Conocidas | Presupuesto, tiempo, tecnologías impuestas, limitaciones legales o técnicas |

### Proceso (5 pasos)

1. **Cuestionamiento Socrático** — El agente hace preguntas críticas para descubrir "lo que el
   cliente no sabe que no sabe". No acepta el primer relato como completo.
2. **Identificación de Actores** — Definir quiénes interactúan con el sistema, directa o
   indirectamente.
3. **Definición de Objetivos de Valor** — Distinguir entre "lo que el sistema hace" y "el
   beneficio concreto que aporta" para cada actor.
4. **Resolución de Conflictos** — Detectar y resolver peticiones contradictorias del cliente.
5. **Exploración de Comportamiento ante Fallos** — Preguntar cómo espera el cliente que el
   sistema reaccione ante errores: mensajes, reintentos, bloqueos. Esta información alimenta
   directamente la Error & Exception Policy del `020_specification_harness`.

### Outputs (artefactos)

| Artefacto | Path | Descripción |
|-----------|------|-------------|
| Shared Understanding Document | `/discovery/shared_understanding.md` | Resumen estructurado en lenguaje natural; el cliente aprueba diciendo "Sí, esto es exactamente lo que quiero" |
| Scope Boundaries | `/discovery/scope_boundaries.md` | Lista explícita de qué NO hará la aplicación en esta etapa |
| Glosario de Dominio | `/discovery/domain_glossary.md` | Términos clave con definición acordada (Ubiquitous Language) |
| Failure Behavior | `/discovery/failure_behavior.md` | Comportamiento esperado ante fallos por escenario |

### Criterio de Done

La fase se considera completa cuando se cumplen **todas** las siguientes condiciones:
1. El cliente ha aprobado explícitamente el Shared Understanding Document.
2. No emergen contradicciones nuevas en 2 rondas consecutivas de preguntas.
3. Todos los actores identificados tienen al menos un objetivo de valor definido.
4. Existe al menos una respuesta registrada sobre comportamiento ante fallos.

### Tipo de artefacto y ciclo adaptado

Discovery produce **documentos**, no código. El ciclo SDD+TDD se adapta así:

| Ciclo estándar | Adaptación para Discovery |
|----------------|--------------------------|
| SPEC | Índice de temas a explorar con el cliente |
| HUMAN REVIEW | Cliente aprueba las áreas de exploración |
| RED | Checklist de aserciones: qué debe ser verdad en el documento final |
| GREEN | Contenido generado por Workers |
| REFACTOR | Mejora de lenguaje y estructura |
| EVAL | Auditoría de C con rúbrica |

---

## Sección 2 — Fase 1: Diseño Agéntico

### 2.1 Instancias y Roles

| Instancia | Rol | Responsabilidades | Escribe en |
|-----------|-----|-------------------|------------|
| A — Governor | Director del Proyecto | Define Sprint Contract; gestiona gates; decide Avanzar/Repetir; reporta al humano | `harness-state.json` |
| B — Phase Orchestrator | Capataz Técnico | Lee contrato; coordina Workers; persiste `orchestration_plan` antes de spawear; actualiza checkpoints | `execution-state.json` |
| C — Phase Evaluator | Auditor Independiente | Lee artefactos sin contexto de ejecución; aplica rúbrica; emite APPROVED/REJECTED | `/eval/verdict.json`, `/eval/metrics_summary.json` |

Jerarquía de llamadas (nunca se viola):
- A → B (para ejecutar), A → C (para auditar). Nunca simultáneo.
- A NO llama Workers directamente.
- C NO llama a nadie. Solo lee del filesystem.

### 2.2 Workers Especializados

| Worker | Micro-tarea | Inputs que recibe | Output (path) |
|--------|-------------|-------------------|---------------|
| discovery-dialoguer | Ejecuta rondas de cuestionamiento socrático con el cliente | I-1, I-2, I-3 | `/discovery/dialogue_transcript.md` |
| discovery-analyst | Analiza el transcript: extrae actores, objetivos de valor, contradicciones, escenarios de fallo | Path a `dialogue_transcript.md` | `/discovery/analysis_report.md` |
| discovery-synthesizer | Produce los 4 artefactos finales a partir del analysis report | Path a `analysis_report.md` | `/discovery/shared_understanding.md`, `/discovery/scope_boundaries.md`, `/discovery/domain_glossary.md`, `/discovery/failure_behavior.md` |

**Secuenciación:** discovery-dialoguer → discovery-analyst → discovery-synthesizer (dependencia estricta, no paralela).

Cada Worker escribe su artefacto al filesystem y reporta a B **solo el path**, nunca el contenido
(E6 — Regla de Referencias Ligeras).

### 2.3 Política de Herramientas (P7)

Herramientas permitidas para Workers de Discovery:
- `Write`, `Read`, `Edit` — para producir y revisar artefactos de documento
- Sin acceso a ejecución de código, herramientas externas ni web search en esta fase

Política de Fallback ante fallo de herramienta (3 niveles — E5):
1. **Reintento** (hasta 2x): reintentar la misma operación si falla por error transitorio
2. **Fallback**: reformular la pregunta al cliente con distinto ángulo si no responde claramente
3. **Escalamiento**: marcar la pregunta como `UNRESOLVED` en el transcript, registrar en
   `execution-state.json` y continuar sin bloquear el flujo. Escalar al humano al cierre.

### 2.4 Política de Escalamiento (P6, E8)

Escalar al humano (detener flujo) en los siguientes casos:
- El cliente produce contradicciones irresolubles después de 3 rondas de preguntas.
- El cliente declina explícitamente responder sobre comportamiento ante fallos.
- El cliente rechaza aprobar el Shared Understanding Document sin dar razón articulable.

En todos los casos: A registra el bloqueo en `harness-state.json` bajo `escalations` y
notifica al humano con contexto completo (ronda en curso, contradicción específica, próxima
acción propuesta).

### 2.5 Checkpoints Canónicos (E5)

| ID | Momento | Qué persiste B |
|----|---------|----------------|
| CP-01 | Tras discovery-dialoguer | Path a `dialogue_transcript.md` en `execution-state.json` |
| CP-02 | Tras discovery-analyst | Path a `analysis_report.md` en `execution-state.json` |
| CP-03 | Tras discovery-synthesizer (draft) | Paths a los 4 artefactos; A presenta draft al cliente para aprobación |
| CP-04 | Cliente aprueba | A registra aprobación en `harness-state.json`; spawea C para auditoría |

### 2.6 Trigger de Context Reset (E2)

Criterios (el que ocurra primero):

- **Conductual (primario):** señales de ansiedad contextual durante el diálogo socrático:
  saltarse preguntas del guión, cerrar rondas sin cumplir el Criterio de Done, respuestas
  superficiales del agente, declarar "terminado" sin verificar las 4 condiciones de Done.
- **Cuantitativo (secundario):** ≥70% de tokens usados.

Acción ante reset: continuar desde el último checkpoint guardado en `execution-state.json`
usando el Ritual E10-B (Continuación). Nunca reiniciar desde cero.

---

## Sección 3 — Sprint Contract (Plantilla)

Template que A propone al humano antes de spawear B. Requiere aprobación explícita.

```
SPRINT CONTRACT — 010 Discovery
================================
Objetivo    : Capturar intención pura del cliente y producir los 4 artefactos de Discovery
Fase        : 010 — Discovery
Modo        : [INICIO | CONTINUACIÓN]

Inputs disponibles:
  - Brief Inicial       : [descripción o path]
  - Contexto de Negocio : [descripción o path]
  - Restricciones       : [lista]

Workers activados:
  - discovery-dialoguer   → /discovery/dialogue_transcript.md
  - discovery-analyst   → /discovery/analysis_report.md
  - discovery-synthesizer  → /discovery/shared_understanding.md
                   /discovery/scope_boundaries.md
                   /discovery/domain_glossary.md
                   /discovery/failure_behavior.md

Checkpoints  : CP-01, CP-02, CP-03, CP-04
Criterio Done: (1) aprobación explícita del cliente, (2) sin contradicciones nuevas en 2 rondas
               consecutivas, (3) todos los actores con ≥1 objetivo de valor, (4) ≥1 respuesta
               sobre comportamiento ante fallos

Riesgos identificados:
  - [contradicciones conocidas en el brief]
  - [restricciones del cliente que pueden limitar el alcance]

Próxima acción: spawear discovery-dialoguer con contexto completo
```

---

## Sección 4 — Rúbrica de Evaluación (Instancia C)

### Dimensiones de evaluación

| ID | Dimensión | Descripción | Score |
|----|-----------|-------------|-------|
| D1 | Cobertura de Actores | Todos los actores identificados tienen ≥1 objetivo de valor definido | 0.0–1.0 |
| D2 | Claridad de Intención | La intención del cliente está capturada sin ambigüedad en el Shared Understanding Document | 0.0–1.0 |
| D3 | Gestión de Contradicciones | Ninguna contradicción permanece sin resolver al cierre de la fase | 0.0–1.0 |
| D4 | Cobertura de Fallos | ≥1 escenario de fallo documentado por cada actor principal | 0.0–1.0 |
| D5 | Aprobación Explícita | El cliente aprobó explícitamente el Shared Understanding Document | 0.0–1.0 |

**Gate de paso:** Score promedio ≥ 0.75 en todas las dimensiones.
**Regla de veto:** Si D5 = 0.0, rechazo automático independientemente de otras dimensiones.

### Anclas de calibración (few-shot — E3)

**Score 0.2** — Solo 1 actor identificado. Sin objetivos de valor. Sin escenarios de fallo.
Sin aprobación del cliente. El Shared Understanding Document no existe o es un borrador vago.

> Ejemplo: "El sistema debe ser una app de gestión. Los usuarios son los administradores."
> Sin más detalle, sin objetivos, sin fallos, sin glosario.

**Score 0.5** — Actores principales identificados pero faltan actores secundarios. Algunos
objetivos de valor definidos (al menos el 50%). Sin escenarios de fallo documentados. El
Shared Understanding Document existe pero el cliente no lo aprobó formalmente.

> Ejemplo: Se identificaron "Admin" y "Usuario" pero no "Cliente externo". 3 de 6 objetivos
> de valor definidos. No se preguntó sobre fallos. El documento se entregó pero no hubo
> confirmación explícita.

**Score 0.8** — Todos los actores identificados con ≥1 objetivo de valor cada uno. Al menos
1 contradicción detectada y resuelta. 1 escenario de fallo por actor principal documentado.
Shared Understanding Document completo, cliente dio señales positivas pero no hay registro
explícito de aprobación.

> Ejemplo: 4 actores, todos con objetivos. 2 contradicciones resueltas. Failure behavior
> documentado para los 2 actores principales. El cliente dijo "sí, está bien" verbalmente
> pero no se registró en el artefacto.

**Score 1.0** — Todos los actores con ≥1 objetivo. Todas las contradicciones resueltas.
≥1 escenario de fallo por actor principal y ≥1 por actor secundario. Shared Understanding
Document aprobado con registro explícito ("Sí, esto es exactamente lo que quiero" o
equivalente). Glosario sin términos ambiguos. Scope Boundaries cubre al menos 3 exclusiones
explícitas.

> Ejemplo: 4 actores con todos sus objetivos. Glosario con 8 términos definidos. 6 escenarios
> de fallo documentados. El cliente firmó digitalmente el Shared Understanding Document en
> CP-03. Scope Boundaries lista 5 exclusiones concretas.

### Output de C

```json
// /eval/verdict.json
{
  "phase": "010_discovery",
  "verdict": "APPROVED | REJECTED",
  "scores": {
    "D1_actor_coverage": 0.0,
    "D2_intent_clarity": 0.0,
    "D3_contradiction_management": 0.0,
    "D4_failure_coverage": 0.0,
    "D5_explicit_approval": 0.0
  },
  "average": 0.0,
  "veto_triggered": false,
  "rejection_reasons": [],
  "recommendations": []
}
```

---

## Sección 5 — Handoff Artifact → 020 Specification

Discovery entrega al 020 los siguientes artefactos. El 020 no puede iniciarse sin ellos.

```
/discovery/
├── shared_understanding.md  → Base para construir requerimientos funcionales en el 020
├── scope_boundaries.md      → Restricciones de alcance que el 020 debe respetar
├── domain_glossary.md       → Lenguaje ubicuo que todos los harnesses subsiguientes deben usar
└── failure_behavior.md      → Input directo para la Error & Exception Policy del 020
```

**Condición de activación del 020:** `harness-state.json` debe tener `"status": "PHASE_COMPLETE"`
en la entrada correspondiente al 010. Sin este estado, el 020 no se activa.

---

## Sección 6 — Flujo del Arnés (12.1–12.5)

### 12.1 Inicialización (Instancia A)

**Determinación del modo:**
- No existe `harness-state.json` → **Inicio** (Ritual E10-A)
- Existe e íntegro → **Continuación** (Ritual E10-B)
- Existe pero corrupto → `git restore harness-state.json`; si persiste, detener y reportar al humano

**Ritual E10-A — Inicio:**
1. Verificar directorio y ambiente
2. Crear jerarquía de carpetas: `/discovery/`, `/eval/`, `/changes/`, `/knowledge/`
3. Inicializar `harness-state.json`, `execution-state.json`, `claude-progress.txt`
4. Ejecutar `git init` y enlazar a remote GitHub (requisito E1 — sin esto, trazabilidad en riesgo)
5. Prueba básica de sanidad (escribir y leer un archivo de prueba)
6. Registrar arranque en `claude-progress.txt`

**Ritual E10-B — Continuación:**
1. Verificar directorio y ambiente
2. `git log --oneline -10` para orientación
3. Leer `claude-progress.txt` (estado narrativo)
4. Cargar `harness-state.json` (Sprint Contract vigente)
5. Leer `execution-state.json` (último checkpoint alcanzado)
6. Seleccionar siguiente tarea según último CP registrado
7. Prueba básica de sanidad

**Reporte al humano (obligatorio tras inicialización):**
1. Estado encontrado (modo, integridad, sanidad)
2. Sprint Contract propuesto (Inicio) o vigente (Continuación)
3. Próxima acción concreta

**Gate de aprobación humana:**
- Aprobado → A escribe Sprint Contract en `harness-state.json` y spawea B
- Ajuste requerido → A incorpora cambios, vuelve a presentar
- Cancelación → A registra en `claude-progress.txt`, detiene flujo

### 12.2 Ejecución Técnica (Instancia B + Workers)

1. B lee Sprint Contract desde `harness-state.json` (referencia al archivo, nunca contenido inline)
2. B consulta `decisions_library.md` y `lessons_learned.md` si existen
3. B persiste `orchestration_plan` completo en `execution-state.json` **antes de spawear ningún Worker** (E12)
4. B spawea discovery-dialoguer con contexto completo (inputs I-1, I-2, I-3)
5. discovery-dialoguer ejecuta cuestionamiento socrático, escribe `/discovery/dialogue_transcript.md`, reporta path a B
6. B registra CP-01 en `execution-state.json`
7. B spawea discovery-analyst con path al transcript
8. discovery-analyst produce `/discovery/analysis_report.md`, reporta path a B
   - Si discovery-analyst encuentra issues (contradicción, ambigüedad, vacío), re-spawna discovery-dialoguer en Modo Aclaración (solo preguntas PA-xx del analysis_report). Este ciclo puede repetirse hasta 3 veces antes de escalar al humano. B espera que discovery-analyst retorne "listo para síntesis" antes de registrar CP-02.
9. B registra CP-02 en `execution-state.json`
10. B spawea discovery-synthesizer con path al analysis report
11. discovery-synthesizer produce los 4 artefactos finales, reporta paths a B
12. B registra CP-03, marca `EXECUTION_COMPLETE` en `execution-state.json`
13. B notifica a A (vía filesystem) que la ejecución terminó

### 12.3 Auditoría y Gate de Aprobación (Instancia C + A)

**Paso 1 — Gate intermedio (A):**
- A verifica que `execution-state.json` tiene `EXECUTION_COMPLETE`
- A presenta draft de artefactos al cliente para aprobación (CP-03)
- Cliente aprueba → A registra aprobación en `harness-state.json` (CP-04)
- A spawea C pasando paths a los 4 artefactos (nunca contenido inline)

**Paso 2 — Auditoría (C):**
- C lee los 4 artefactos desde el filesystem
- C evalúa contra rúbrica (Sección 4), aplica anclas de calibración
- C escribe:
  - `/eval/metrics_summary.json` (métricas Tipo 1 y Tipo 2)
  - `/eval/verdict.json` (APPROVED/REJECTED con scores por dimensión)
- C registra auditoría en `claude-progress.txt`

**Paso 3 — Decisión final (A — GateKeeper):**
- A lee `/eval/verdict.json`
- **APPROVED** → A marca `"status": "PHASE_COMPLETE"` en `harness-state.json`, notifica al humano con paths de todos los artefactos, activa handoff al 020
- **REJECTED** → A activa protocolo 12.4

### 12.4 Protocolo de Rechazo y Reintento

**Rechazo Técnico** (artefacto no cumple rúbrica):
- C escribe rechazo detallado en `/eval/verdict.json`
- A marca `IN_REWORK` en `harness-state.json`
- A spawea B nuevamente pasando referencia al rechazo (nunca el contenido)
- B re-ejecuta solo los Workers que producen los artefactos fallidos (nunca todo desde cero)
- Ciclo continúa desde 12.3

**Rechazo Estratégico** (cliente cambió intención o rechaza el Shared Understanding Document):
- A detiene flujo, marca `HOLD` en `harness-state.json`
- A actualiza Sprint Contract con el cambio
- A requiere nueva aprobación humana antes de continuar
- Sin avance hasta aprobación nueva

**Registro de aprendizaje:**
- Todo rechazo (técnico o estratégico) registrado por C en `lessons_learned.md` al cierre

### 12.5 Cierre

1. A marca `"status": "PHASE_COMPLETE"` en `harness-state.json`
2. C actualiza `lessons_learned.md` con hallazgos del ciclo (qué funcionó, qué no)
3. A notifica al humano: lista de artefactos producidos, paths, estado listo para 020
4. A registra cierre en `claude-progress.txt` con timestamp y resumen de sesión
5. A hace commit final: `docs(010-discovery): phase complete — 4 artefactos producidos`
