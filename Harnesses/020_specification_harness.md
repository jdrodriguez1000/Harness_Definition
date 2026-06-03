# 020 — Specification Harness (Especificación - El QUÉ)

---

## Fase 0 — Definición Estructural

### Propósito

Transformar los artefactos de comprensión del 010 en contratos formales de comportamiento y
datos que describan QUÉ debe hacer el sistema. La Specification no produce código ni diseño
técnico — produce reglas de negocio, escenarios de comportamiento y contratos de datos agnósticos
a tecnología, aprobados explícitamente por el cliente.

### Precondición obligatoria

El 020 no puede iniciarse sin que el 010 esté `PHASE_COMPLETE` en `harness-state.json`.
Si el 010 no está completo, el specification-governor debe detener el flujo y notificar al
humano: "El 010 Discovery debe completarse antes de iniciar el 020."

### Inputs

| ID | Input | Fuente | Descripción |
|----|-------|--------|-------------|
| I-1 | `shared_understanding.md` | `/010_discovery/` | Entendimiento compartido del dominio aprobado por el cliente |
| I-2 | `domain_glossary.md` | `/010_discovery/` | Lenguaje ubicuo acordado — todos los artefactos del 020 deben usarlo |
| I-3 | `scope_boundaries.md` | `/010_discovery/` | Exclusiones explícitas que los contratos del 020 deben respetar |
| I-4 | `failure_behavior.md` | `/010_discovery/` | Comportamiento ante fallos — input directo para la Error & Exception Policy. Puede contener ítems PENDIENTE que el governor debe resolver con el cliente antes de ejecutar |

### Proceso

1. **Mapeo de Comportamiento (Behavior Mapping)** — Traducir los objetivos de valor del
   `shared_understanding.md` en escenarios de "Acción-Reacción" usando lenguaje natural
   estructurado (Given/When/Then). Cada actor identificado en el 010 debe tener al menos
   un escenario de camino feliz.
2. **Análisis de Casos de Borde (Edge Cases)** — Identificar sistemáticamente condiciones
   límite, datos inválidos y estados excepcionales. Usar el `failure_behavior.md` como base;
   extender con casos no cubiertos por el 010.
3. **Definición de Contratos de Producto** — Especificar qué información recibe y entrega
   el sistema por cada escenario: campos, formatos, restricciones y reglas de validación,
   centradas en la necesidad del negocio (no en implementación técnica).
4. **Modelado Conceptual de Datos** — Definir entidades y sus relaciones lógicas (ej:
   "Un Pedido siempre debe tener al menos un Producto"). No es un schema de base de datos —
   es el modelo mental del dominio acordado con el cliente.
5. **Validación de Consistencia** — Verificar que ninguna regla de negocio, escenario de
   comportamiento o contrato de datos contradiga a otro. Los ítems PENDIENTE del
   `failure_behavior.md` deben quedar resueltos antes de cerrar esta fase.

### Outputs (Artefactos)

| Artefacto | Path | Descripción |
|-----------|------|-------------|
| BDD Feature Files | `/020_specification/bdd_features.md` | Escenarios Given/When/Then: camino feliz + todos los casos de borde identificados por actor |
| Data Contracts | `/020_specification/data_contracts.md` | Campos, formatos, validaciones y reglas de negocio por entidad. Agnóstico a tecnología |
| Product Acceptance Criteria | `/020_specification/acceptance_criteria.md` | Checklist que determina si cada funcionalidad cumple lo esperado por el negocio. Trazable a un escenario BDD |
| Error & Exception Policy | `/020_specification/error_exception_policy.md` | Qué hace el sistema ante cada caso de borde: mensaje al usuario, reintento, bloqueo o acción alternativa. Resuelve todos los ítems de `failure_behavior.md` |

Artefacto auxiliar (no entregado al 030, no evaluado por la rúbrica):
- `/020_specification/review_report.md` — producido por specification-reviewer entre CP-02 y CP-03; verifica consistencia estructural pre-aprobación

### Criterio de Done

La fase se considera completa cuando se cumplen **todas** las siguientes condiciones:

1. Todos los actores del 010 tienen ≥1 escenario BDD de camino feliz.
2. Todos los ítems PENDIENTE del `failure_behavior.md` tienen política definida en la Error & Exception Policy.
3. Ninguna regla de negocio o contrato de datos contradice a otro (validación de consistencia limpia).
4. El cliente ha aprobado explícitamente el conjunto de artefactos.

### Tipo de artefacto y ciclo adaptado

Specification produce **documentos de contrato**, no código. El ciclo SDD+TDD se adapta así:

| Ciclo estándar | Adaptación para Specification |
|----------------|-------------------------------|
| SPEC | Índice de comportamientos a especificar, derivado de los actores y objetivos del 010 |
| HUMAN REVIEW | Cliente aprueba los ítems PENDIENTE resueltos antes de ejecutar los workers |
| RED | Checklist de aserciones: qué debe ser verdad en cada artefacto (ej: "Todo actor debe tener ≥1 escenario BDD") |
| GREEN | Contenido generado por Workers |
| REFACTOR | Mejora de lenguaje usando el `domain_glossary.md`; eliminación de redundancias |
| EVAL | Auditoría de C con rúbrica |

---

## Fase 1 — Diseño Agéntico

### 1.1 Instancias y Roles

| Instancia | Agente | Rol | Responsabilidades | Escribe en |
|-----------|--------|-----|-------------------|------------|
| A — Governor | `specification-governor` | Director del Proyecto | Verifica precondición del 010; gestiona gate de ítems PENDIENTE; propone Sprint Contract; gestiona CP-03 y CP-04; decide Avanzar/Repetir | `persistence/harness-state.json` |
| B — Orchestrator | `specification-orchestrator` | Capataz Técnico | Lee contrato; coordina Workers; persiste `orchestration_plan` antes de spawear; registra checkpoints | `persistence/execution-state.json` |
| D — Reviewer | `specification-reviewer` | Control de Calidad Pre-CP-03 | Lee los 4 artefactos tras CP-02 y antes de CP-03. Verifica consistencia estructural (IDs cruzados, entidades huérfanas, secciones faltantes). Issues críticos → rework antes de CP-03. Issues menores → presentar al cliente con diagnóstico. | `020_specification/review_report.md` |
| C — Evaluator | `specification-evaluator` | Auditor Independiente | Lee los 4 artefactos sin contexto de ejecución; aplica rúbrica; emite APPROVED/REJECTED | `eval/verdict.json`, `eval/metrics_summary.json` |

Jerarquía de llamadas (nunca se viola):
- A → B (para ejecutar), A → D (para revisar entre CP-02 y CP-03), A → C (para auditar). Nunca simultáneo.
- A NO llama Workers directamente.
- D NO llama a nadie. Solo lee del filesystem y escribe `020_specification/review_report.md`.
- C NO llama a nadie. Solo lee del filesystem.

**Todos los agentes son exclusivos del 020.** No comparten ni heredan instrucciones del 010.

### 1.2 Workers Especializados

| Worker | Micro-tarea | Inputs que recibe | Output (path) |
|--------|-------------|-------------------|---------------|
| `specification-analyst` | Lee los 4 artefactos del 010 + respuestas del governor a ítems PENDIENTE. Identifica todos los comportamientos a especificar, casos de borde, entidades y relaciones. Produce reporte de análisis estructurado listo para el writer. | Paths a I-1, I-2, I-3, I-4 + respuestas PENDIENTE del governor | `/020_specification/spec_analysis_report.md` |
| `specification-writer` | Produce los 4 artefactos finales a partir del spec_analysis_report y los artefactos del 010. Usa el `domain_glossary.md` como lenguaje obligatorio. | Path a `spec_analysis_report.md` + paths a I-1..I-4 | `/020_specification/bdd_features.md`, `/020_specification/data_contracts.md`, `/020_specification/acceptance_criteria.md`, `/020_specification/error_exception_policy.md` |

**Secuenciación:** specification-analyst → specification-writer (dependencia estricta, no paralela).

Cada Worker escribe su artefacto al filesystem y reporta a B **solo el path**, nunca el contenido
(E6 — Regla de Referencias Ligeras).

### 1.3 Política de Herramientas (P7)

Herramientas permitidas para Workers de Specification:
- `Write`, `Read`, `Edit` — para producir y revisar artefactos de documento
- Sin acceso a ejecución de código, herramientas externas ni web search en esta fase

Política de Fallback ante fallo de herramienta (3 niveles — E5):
1. **Reintento** (hasta 2x): reintentar la misma operación si falla por error transitorio
2. **Fallback**: si no se puede derivar un comportamiento de los artefactos del 010, marcar
   como `REQUIERE_ACLARACIÓN` en el spec_analysis_report y continuar con los demás
3. **Escalamiento**: registrar el bloqueo en `execution-state.json` bajo `worker_errors`,
   notificar a A. A escala al cliente vía `AskUserQuestion`. Sin workarounds ni datos inventados.

### 1.4 Política de Escalamiento (P6, E8)

Escalar al humano (detener flujo) en los siguientes casos:
- El specification-analyst encuentra un ítem PENDIENTE que el governor no resolvió.
- Una regla de negocio derivada del 010 genera una contradicción irresoluble entre artefactos.
- El cliente rechaza los artefactos en CP-03 sin dar razón articulable.

En todos los casos: A registra el bloqueo en `harness-state.json` bajo `escalations` y
notifica al humano con contexto completo (ítem bloqueante, artefacto afectado, próxima acción propuesta).

### 1.5 Checkpoints Canónicos (E5)

| ID | Momento | Qué persiste B |
|----|---------|----------------|
| CP-01 | Tras specification-analyst | Path a `spec_analysis_report.md` en `execution-state.json` |
| CP-02 | Tras specification-writer (draft) | Paths a los 4 artefactos en `execution-state.json`; marca `EXECUTION_COMPLETE` |
| — | Tras CP-02 (pre-CP-03) | A spawea specification-reviewer. Si issues críticos → rework. Reviewer produce `020_specification/review_report.md` |
| CP-03 | Cliente revisa draft | A presenta artefactos al cliente (+ issues menores del reviewer si los hay); registra feedback en `harness-state.json` |
| CP-04 | Cliente aprueba formalmente | A registra aprobación explícita en `harness-state.json`; spawea C para auditoría |

### 1.6 Trigger de Context Reset (E2)

Criterios (el que ocurra primero):

- **Conductual (primario):** señales de ansiedad contextual durante la producción de artefactos:
  saltar pasos del proceso, omitir actores del 010, no usar el glosario de dominio, declarar
  artefactos como completos sin cubrir todos los escenarios de camino feliz, ignorar ítems
  PENDIENTE del `failure_behavior.md`.
- **Cuantitativo (secundario):** ≥70% de tokens usados.

Acción ante reset: continuar desde el último checkpoint guardado en `execution-state.json`
usando el Ritual E10-B (Continuación). Nunca reiniciar desde cero.

---

## Sprint Contract — Plantilla

Template que A propone al humano antes de spawear B. Requiere aprobación explícita antes de
continuar. A debe listar los ítems PENDIENTE del `failure_behavior.md` para resolución del
cliente ANTES de que el humano apruebe el Sprint Contract. Si el humano solicita ajustes,
A incorpora y vuelve a presentar. Si cancela, A registra en `claude-progress.txt` y detiene el flujo.

```
SPRINT CONTRACT — 020 Specification
=====================================
Objetivo    : Transformar los artefactos del Discovery en contratos formales de
              comportamiento y datos (QUÉ hace el sistema, sin tecnología)
Fase        : 020 — Specification
Modo        : [INICIO | CONTINUACIÓN]
Precondición: 010 Discovery — PHASE_COMPLETE ✓

Inputs disponibles (desde /010_discovery/):
  - shared_understanding.md : [confirmado / path]
  - domain_glossary.md      : [confirmado / path]
  - scope_boundaries.md     : [confirmado / path]
  - failure_behavior.md     : [confirmado / path]
    Ítems PENDIENTE detectados: [lista de ítems sin resolución del 010]
    Resolución obtenida del cliente: [respuestas registradas antes de aprobar]

Workers activados:
  - specification-analyst → /020_specification/spec_analysis_report.md
  - specification-writer  → /020_specification/bdd_features.md
                            /020_specification/data_contracts.md
                            /020_specification/acceptance_criteria.md
                            /020_specification/error_exception_policy.md

Checkpoints : CP-01, CP-02, CP-03, CP-04

Criterio Done:
  (1) Todos los actores del 010 tienen ≥1 escenario BDD de camino feliz
  (2) Todos los ítems PENDIENTE del failure_behavior.md tienen política definida
  (3) Sin contradicciones entre artefactos
  (4) Aprobación explícita del cliente en CP-04

Riesgos identificados:
  - [ítems PENDIENTE que pueden requerir aclaración adicional del cliente]
  - [actores del 010 con objetivos poco detallados]
  - [restricciones de scope_boundaries que pueden limitar escenarios BDD]

Próxima acción: spawear specification-orchestrator con contexto completo
```

---

## Rúbrica de Evaluación (Instancia C)

### Dimensiones

| ID | Dimensión | Descripción | Score |
|----|-----------|-------------|-------|
| D1 | Cobertura BDD | Todos los actores del 010 tienen ≥1 escenario Given/When/Then de camino feliz y ≥1 escenario de caso de borde | 0.0–1.0 |
| D2 | Completitud de Data Contracts | Todos los campos, formatos y validaciones están definidos sin ambigüedad y son trazables a un escenario BDD | 0.0–1.0 |
| D3 | Trazabilidad de Acceptance Criteria | Cada criterio de aceptación referencia un escenario BDD concreto. Sin criterios huérfanos ni escenarios sin criterio | 0.0–1.0 |
| D4 | Completitud de Error & Exception Policy | Todos los ítems del `failure_behavior.md` (incluyendo los que estaban PENDIENTE) tienen política definida con acción concreta | 0.0–1.0 |
| D5 | Consistencia | Ninguna regla de negocio, escenario BDD, contrato de datos ni criterio de aceptación contradice a otro | 0.0–1.0 |

**Gate de paso:** Score promedio ≥ 0.75 en todas las dimensiones.
**Regla de veto:** Si D5 = 0.0, rechazo automático independientemente de las otras dimensiones.

### Anclas de calibración (few-shot — E3)

**Score 0.2** — Escenarios BDD solo para 1 actor. Data Contracts sin validaciones. Sin Acceptance
Criteria. Error & Exception Policy vacía o copia literal del `failure_behavior.md` sin resolución.

> Ejemplo: Solo el actor principal tiene un escenario BDD incompleto (sin casos de borde).
> Data Contracts lista campos sin formatos ni restricciones. Los ítems PENDIENTE del 010
> siguen marcados como PENDIENTE en la Error & Exception Policy.

**Score 0.5** — Escenarios BDD para actores principales pero no secundarios. Data Contracts
con campos definidos pero sin validaciones de negocio. Acceptance Criteria existe pero no es
trazable a BDD. Al menos el 50% de ítems PENDIENTE resueltos en Error & Exception Policy.

> Ejemplo: 3 de 5 actores tienen escenarios BDD. Data Contracts define tipos de datos pero
> no restricciones (ej: "campo email" sin regla de formato). 4 de 7 ítems PENDIENTE resueltos.
> Sin contradicciones detectadas.

**Score 0.8** — Todos los actores con ≥1 escenario BDD de camino feliz. Al menos 1 caso de
borde por actor principal. Data Contracts con campos y validaciones pero sin relaciones entre
entidades. Acceptance Criteria trazable al 80%. Todos los ítems PENDIENTE resueltos. 1 pequeña
inconsistencia detectada y registrada.

> Ejemplo: 5 actores con camino feliz y casos de borde en los 3 principales. Data Contracts
> completos excepto relaciones entre Paciente y Médico no documentadas. Todos los PENDIENTE
> resueltos. Una inconsistencia menor: un criterio de aceptación referencia un campo no
> definido en Data Contracts.

**Score 1.0** — Todos los actores con ≥1 escenario de camino feliz y ≥1 caso de borde.
Data Contracts con campos, formatos, validaciones y relaciones entre entidades. Acceptance
Criteria 100% trazable a BDD. Todos los ítems PENDIENTE resueltos con acción concreta.
Sin contradicciones. Glosario de dominio usado consistentemente en todos los artefactos.

> Ejemplo: 5 actores con camino feliz, casos de borde y escenarios de error. Data Contracts
> define 12 entidades con relaciones explícitas y validaciones de negocio. Acceptance Criteria
> referencia el ID de escenario BDD en cada ítem. Error & Exception Policy resuelve los 7
> PENDIENTE del 010 con mensajes de error, reintentos y acciones alternativas concretas.
> Sin ninguna contradicción entre los 4 artefactos.

### Output de C

```json
// eval/verdict.json
{
  "phase": "020_specification",
  "evaluation_version": 1,
  "evaluated_at": "<timestamp>",
  "verdict": "APPROVED | REJECTED",
  "veto_triggered": false,
  "scores": {
    "D1_bdd_coverage": 0.0,
    "D2_data_contract_completeness": 0.0,
    "D3_acceptance_criteria_traceability": 0.0,
    "D4_error_policy_completeness": 0.0,
    "D5_consistency": 0.0
  },
  "average": 0.0,
  "gate_threshold": 0.75,
  "gate_passed": false,
  "findings": [],
  "artifacts_evaluated": [
    "020_specification/bdd_features.md",
    "020_specification/data_contracts.md",
    "020_specification/acceptance_criteria.md",
    "020_specification/error_exception_policy.md"
  ]
}
```

---

## Handoff Artifact → 030 Design

Specification entrega al 030 los siguientes artefactos. El 030 **no puede iniciarse** sin ellos.

```
/020_specification/
├── bdd_features.md           → Base para arquitectura: qué debe soportar el sistema
├── data_contracts.md         → Entidades y relaciones que el diseño técnico debe implementar
├── acceptance_criteria.md    → Criterios que el 030 debe garantizar desde el diseño
└── error_exception_policy.md → Políticas que el diseño técnico debe implementar a nivel de arquitectura

/010_discovery/                   → El 030 también hereda los 4 artefactos del 010
├── shared_understanding.md
├── domain_glossary.md        → Lenguaje ubicuo que todos los harnesses subsiguientes deben respetar
├── scope_boundaries.md
└── failure_behavior.md
```

**Condición de activación del 030:** `harness-state.json` debe registrar `"status": "PHASE_COMPLETE"`
para la fase 020. Sin este estado, el 030 no se activa.

---

## Flujo del Arnés

### 12.1 Inicialización (Instancia A — specification-governor)

**Precondición antes de cualquier acción:**
Verificar que `harness-state.json` tiene status `PHASE_COMPLETE` para la fase 010.
Si no, detener y notificar al humano.

**Determinación del modo:**

| Condición | Modo | Ritual |
|-----------|------|--------|
| No existe entrada 020 en `harness-state.json` | Inicio | E10-A |
| Existe entrada 020 e íntegra | Continuación | E10-B |
| Existe pero corrupta | Recuperación | `git restore persistence/harness-state.json`; si persiste → detener y reportar al humano |

**Ritual E10-A — Inicio:**

1. Verificar directorio y ambiente
2. Crear carpeta `/020_specification/` (las demás ya existen del 010)
3. Inicializar entrada 020 en `harness-state.json` con status `PENDING`
4. Inicializar `persistence/execution-state.json` con estructura mínima para el 020
5. Prueba básica de sanidad (escribir y leer un archivo de prueba en `/020_specification/`)
6. Registrar arranque en `persistence/claude-progress.txt`

**Ritual E10-B — Continuación:**

1. Verificar directorio y ambiente
2. `git log --oneline -10` para orientación
3. Leer `persistence/claude-progress.txt` (estado narrativo de la sesión anterior)
4. Cargar `persistence/harness-state.json` (Sprint Contract vigente del 020)
5. Leer `persistence/execution-state.json` (último checkpoint alcanzado)
6. Seleccionar siguiente tarea según último CP registrado
7. Prueba básica de sanidad

**Gate de ítems PENDIENTE (exclusivo del 020 — antes de aprobar Sprint Contract):**

Antes de proponer el Sprint Contract al humano, el governor debe:
1. Leer `010_discovery/failure_behavior.md` y extraer todos los ítems marcados como PENDIENTE.
2. Si existen ítems PENDIENTE: presentarlos al cliente via `AskUserQuestion` y registrar las
   respuestas en `harness-state.json` bajo `pending_resolutions`.
3. Solo cuando todos los PENDIENTE están resueltos (o el cliente confirma que no aplican),
   proceder a proponer el Sprint Contract.

**Reporte al humano (obligatorio tras completar el ritual):**

1. Estado encontrado: modo detectado, integridad del 010, resultado de sanidad
2. Ítems PENDIENTE del `failure_behavior.md` y sus resoluciones obtenidas
3. Sprint Contract propuesto (modo Inicio) o vigente (modo Continuación)
4. Próxima acción concreta

**Gate de aprobación humana:**

- **Aprobado** → A escribe Sprint Contract en `harness-state.json` y spawea B
- **Ajuste requerido** → A incorpora cambios y vuelve a presentar
- **Cancelación** → A registra motivo en `claude-progress.txt` y detiene el flujo

**Nota sobre CLAUDE.md (Opción B — multi-harness):**

El `CLAUDE.md` del proyecto cliente detecta automáticamente qué governor invocar leyendo
`harness-state.json` y encontrando la primera fase sin `PHASE_COMPLETE`:
- 010 no `PHASE_COMPLETE` → invocar `discovery-governor`
- 010 `PHASE_COMPLETE` y 020 no `PHASE_COMPLETE` → invocar `specification-governor`
- 020 `PHASE_COMPLETE` → invocar el governor del siguiente harness activo

### 12.2 Ejecución Técnica (Instancia B — specification-orchestrator + Workers)

1. B lee Sprint Contract desde `persistence/harness-state.json` (referencia, nunca contenido inline)
2. B consulta `knowledge/decisions_library.md` y `knowledge/lessons_learned.md` si existen
3. B persiste `orchestration_plan` completo en `persistence/execution-state.json` **antes de spawear ningún Worker** (E12)
4. B spawea **specification-analyst** con paths a los 4 artefactos del 010 + resoluciones de PENDIENTE
   - specification-analyst lee los artefactos del 010, extrae comportamientos, casos de borde,
     entidades y relaciones
   - specification-analyst produce `/020_specification/spec_analysis_report.md` y reporta path a B
   - Si detecta un ítem PENDIENTE sin resolución del governor, reporta `REQUIERE_ACLARACIÓN` a B,
     quien escala a A para obtener respuesta del cliente antes de continuar
5. B registra **CP-01** en `persistence/execution-state.json`
6. **Evaluación Temprana (E9):** B spawea C pasando solo el path a `spec_analysis_report.md`.
   C evalúa el reporte contra las dimensiones D1 (cobertura de actores) y D2 (completitud de
   contratos) de la rúbrica y produce un mini-veredicto en `execution-state.json` bajo `early_eval`.
   - Si score ≥ 0.7: B continúa al paso siguiente sin cambios.
   - Si score < 0.7: B escala a A. A revisa el reporte, corrige el specification-analyst
     (re-spawneándolo con feedback específico) antes de continuar con el writer.
   Esta evaluación no genera `eval/verdict.json` — es solo una señal de calidad interna.
7. B spawea **specification-writer** con path al spec_analysis_report + paths a I-1..I-4
   - specification-writer produce los 4 artefactos finales usando el `domain_glossary.md`
     como lenguaje obligatorio
   - specification-writer reporta a B los 4 paths
8. B registra **CP-02**, marca `EXECUTION_COMPLETE` en `persistence/execution-state.json`
9. B notifica a A vía filesystem que la ejecución terminó

### 12.3 Auditoría y Gate de Aprobación (Instancia C + A)

**Paso 1 — Gate intermedio (A):**

1. A verifica que `execution-state.json` marca `EXECUTION_COMPLETE`
2. A presenta el draft de los 4 artefactos al cliente para revisión (CP-03)
3. Cliente aprueba → A registra aprobación explícita en `harness-state.json` (CP-04)
4. A spawea C pasando los 4 paths (nunca contenido inline)

**Paso 2 — Auditoría (C — specification-evaluator):**

1. C lee los 4 artefactos desde el filesystem (sin contexto de ejecución)
2. C evalúa cada dimensión de la rúbrica aplicando las anclas de calibración
3. C verifica la regla de veto: si D5 = 0.0, emite rechazo automático
4. C escribe:
   - `eval/metrics_summary.json` — métricas Tipo 1 y Tipo 2 de la fase 020
   - `eval/verdict.json` — APPROVED/REJECTED con scores por dimensión
5. C registra la auditoría en `persistence/claude-progress.txt`

**Paso 3 — Decisión final (A — GateKeeper):**

1. A lee `eval/verdict.json`
2. **APPROVED** → A marca `"status": "PHASE_COMPLETE"` para el 020 en `harness-state.json`,
   notifica al humano con la lista de artefactos producidos y sus paths, activa handoff al 030
3. **REJECTED** → A activa protocolo 12.4

### 12.4 Protocolo de Rechazo y Reintento

**Rechazo Técnico** (artefacto no cumple la rúbrica):

1. C escribe rechazo detallado en `eval/verdict.json` con dimensiones fallidas y recomendaciones
2. A marca `"status": "IN_REWORK"` en `harness-state.json`
3. A spawea B nuevamente pasando referencia al rechazo (nunca el contenido)
4. B lee `knowledge/lessons_learned.md` antes de re-ejecutar para no repetir errores previos
5. B re-ejecuta **solo el Worker** que produce el artefacto fallido, nunca el flujo completo
6. El ciclo continúa desde 12.3

**Rechazo Estratégico** (cliente cambia el alcance o rechaza los artefactos):

1. A detiene el flujo, marca `"status": "HOLD"` en `harness-state.json`
2. A actualiza el Sprint Contract con el cambio y revisa si afecta también los artefactos del 010
3. A requiere nueva aprobación humana del Sprint Contract antes de continuar
4. Sin avance hasta nueva aprobación

**Registro de aprendizaje:**

A registra todo rechazo — técnico o estratégico — en `knowledge/lessons_learned.md` al cierre
del ciclo, con: dimensión fallida, causa raíz identificada y regla para sesiones futuras.

### 12.5 Cierre

1. A marca `"status": "PHASE_COMPLETE"` para el 020 en `harness-state.json`
2. A actualiza `knowledge/lessons_learned.md` con hallazgos del ciclo (qué funcionó, qué no,
   qué ítems PENDIENTE del 010 generaron más trabajo en el 020)
3. A actualiza `knowledge/decisions_library.md` con las decisiones de arquitectura validadas
   durante el 020 (ej: resoluciones de ítems PENDIENTE que resultaron en políticas reutilizables)
4. A notifica al humano con resumen de cierre:
   - Artefactos producidos y sus paths
   - Scores finales de la rúbrica
   - Estado listo para activar el 030
5. A registra cierre en `persistence/claude-progress.txt` con timestamp y resumen de la sesión
6. A hace commit final: `docs(020-specification): phase complete — 4 artefactos producidos`
