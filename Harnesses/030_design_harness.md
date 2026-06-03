# 030 — Design Harness (Diseño - El CÓMO Técnico)

---

## Fase 0 — Definición Estructural

### Propósito

Transformar los contratos formales de comportamiento y datos del 020 en un plano
arquitectónico técnico que describa CÓMO debe estar construido el sistema. El Design
Harness no produce código — produce la estructura, las interfaces, las dependencias y las
decisiones técnicas que guían la implementación. Sus artefactos son agnósticos al equipo
de desarrollo pero suficientemente precisos para:

1. Guiar el 040 Planning bajo el paradigma de Vertical Slices.
2. Habilitar el TDD desde el primer día de implementación.
3. Documentar las decisiones técnicas clave con su razonamiento.

### Precondición obligatoria

El 030 no puede iniciarse sin que el 020 esté `PHASE_COMPLETE` en `harness-state.json`
bajo la clave `"020_specification"`. Si el 020 no está completo, el design-governor debe
detener el flujo y notificar al humano: "El 020 Specification debe completarse antes de
iniciar el 030 Design. Estado actual: [valor encontrado]."

### Inputs

| ID | Input | Fuente | Descripción |
|----|-------|--------|-------------|
| I-1 | `bdd_features.md` | `/020_specification/` | Escenarios BDD — define qué debe soportar la arquitectura |
| I-2 | `data_contracts.md` | `/020_specification/` | Entidades y contratos de datos que el diseño técnico debe implementar |
| I-3 | `acceptance_criteria.md` | `/020_specification/` | Criterios de aceptación que el diseño debe garantizar desde la arquitectura |
| I-4 | `error_exception_policy.md` | `/020_specification/` | Políticas de error que el diseño técnico debe implementar a nivel arquitectónico |
| I-5 | `shared_understanding.md` | `/010_discovery/` | Contexto de dominio, restricciones tecnológicas y de calidad capturadas en el 010 |
| I-6 | `domain_glossary.md` | `/010_discovery/` | Lenguaje ubicuo — todos los artefactos del 030 deben usar estos términos |
| I-7 | `scope_boundaries.md` | `/010_discovery/` | Restricciones de plataforma, infraestructura y presupuesto que acotan la selección de stack |
| I-8 | `failure_behavior.md` | `/010_discovery/` | Comportamientos de fallo ya resueltos — informan el diseño de manejo de errores |

### Proceso (7 pasos)

1. **Selección y Documentación del Stack (ADR-001)** — Antes de cualquier decisión
   arquitectónica, definir el stack tecnológico usando las restricciones de I-5, I-7 y
   los requerimientos funcionales de I-1..I-4. El resultado (lenguajes, frameworks, librerías,
   infraestructura) se documenta como el primer ADR y queda disponible para todos los pasos
   siguientes. Sin ADR-001, ningún otro artefacto puede referirse a tecnologías concretas.

2. **Modelado Arquitectónico (Decoupled Design)** — Definición de las capas del sistema
   (ej. Dominio, Aplicación, Infraestructura). Priorizar el desacoplamiento: la lógica de
   negocio no debe depender de la tecnología elegida en el paso anterior.

3. **Diseño de Interfaces y Contratos (Interface-First)** — Definición de los "Puertos"
   (interfaces) que conectan la lógica de negocio con el mundo exterior (APIs, Bases de
   Datos, UI). Cada entidad de I-2 debe tener al menos una interface correspondiente.

4. **Selección de Patrones de Diseño** — Identificación de patrones que resuelvan los
   problemas técnicos detectados (ej. Repository para persistencia, Strategy para reglas
   variables del dominio, Factory para creación de entidades complejas). Documentar cada
   patrón seleccionado con su justificación.

5. **Estrategia de Testabilidad (TDD Enablement)** — Diseñar explícitamente cómo se
   inyectarán las dependencias y cómo se crearán los mocks o stubs para que el proceso TDD
   sea posible. Cada interface definida en el paso 3 debe tener una estrategia de mock/stub
   documentada en el test_strategy_map.md.

6. **Mapeo de Flujo de Datos Técnico** — Definir cómo se transforman los datos desde que
   entran por un controlador/handler hasta que llegan a la persistencia. Trazable a los
   escenarios BDD de I-1.

7. **Guía de Vertical Slices (ADJ-04 + ADJ-32)** — Identificar cómo el sistema puede ser sliceado
   en iteraciones verticales funcionales de extremo a extremo. No es el planning (eso es el
   040) — es identificar las fronteras naturales de slicing para que el 040 pueda planificar
   iteraciones coherentes con la arquitectura propuesta. Nomenclatura obligatoria:
   `VS-Tracer Bullet → VS-Crecimiento-1..N (opcional) → VS-MVP → VS-Evolución-1..M (opcional) → VS-Robustez`.
   Tracer Bullet, MVP y Robustez son obligatorios. N y M tienen piso mínimo por tamaño del
   proyecto (≤4 IC-xx → N=0/M=0; 5–7 → N≥1/M≥1; ≥8 → N≥2/M≥1). Criterio de división por
   slice: máx. 3 IC-xx nuevas, 2 MOD-xx nuevos, 10 BDD scenarios nuevos — si se supera
   cualquier límite, dividir la slice. Por cada slice: nombre, tipo (hito-principal/opcional),
   IC-xx asignados, BDD scenarios (SC-xx/SE-xx) y criterio de Done preliminar.

### Outputs (Artefactos)

| Artefacto | Path | Descripción |
|-----------|------|-------------|
| Technical Blueprint | `/030_design/technical_blueprint.md` | Estructura de carpetas, definición de capas/módulos y skeleton de clases/interfaces principales |
| Contract Definitions | `/030_design/contract_definitions.md` | Interfaces técnicas (IRepository, IService, etc.), DTOs con firmas de métodos por bounded context |
| Dependency Graph | `/030_design/dependency_graph.md` | Cómo se relacionan los componentes; estrategia de inyección de dependencias; diagrama o descripción textual de la topología |
| Architecture Decision Records | `/030_design/architecture_decision_records.md` | ADR-001: stack; ADR-N: patrones seleccionados, decisiones de desacoplamiento, trade-offs aceptados |
| Test Strategy Map | `/030_design/test_strategy_map.md` | Qué se probará con unitarios/integración/contrato por interface; puntos de mock/stub; Guía de Vertical Slices (TB → Crecimiento 0..N → MVP → Evolución 0..M → Robustez) con 5 campos por slice |

Artefactos intermedios (no entregados al 040, no evaluados por la rúbrica):
- `/030_design/design_analysis_report.md` — producido por design-analyst, consumido por design-architect
- `/030_design/review_report.md` — producido por design-reviewer entre CP-02 y CP-03; verifica consistencia estructural pre-aprobación

### Criterio de Done

La fase se considera completa cuando se cumplen **todas** las siguientes condiciones:

1. El stack tecnológico está documentado como ADR-001 con contexto, opciones evaluadas y justificación de la elección.
2. Todos los bounded contexts identificados en `bdd_features.md` tienen ≥1 módulo/componente en `technical_blueprint.md`.
3. Todas las entidades de `data_contracts.md` tienen interfaz técnica y DTOs en `contract_definitions.md`.
4. Cada interface en `contract_definitions.md` tiene estrategia de mock/stub en `test_strategy_map.md`.
5. El cliente ha aprobado explícitamente los artefactos en CP-04.

### Tipo de artefacto y ciclo adaptado

Design produce **artefactos técnicos de diseño**, no código. El ciclo SDD+TDD se adapta así:

| Ciclo estándar | Adaptación para Design |
|----------------|----------------------|
| SPEC | Índice de componentes y decisiones técnicas a diseñar, derivado del análisis de los 8 inputs |
| HUMAN REVIEW | Cliente/equipo técnico aprueba el stack (ADR-001) y las decisiones arquitectónicas mayores en CP-03 |
| RED | Demo Statements (ADJ-13): "cuando termine, podré observar que..." — criterio observable antes de reportar COMPLETED |
| GREEN | Artefactos producidos por Workers |
| REFACTOR | Verificación de lenguaje ubicuo (domain_glossary.md) y consistencia cruzada entre los 5 artefactos |
| EVAL | Auditoría de C con rúbrica D1-D5 |

---

## Fase 1 — Diseño Agéntico

### 1.1 Instancias y Roles

| Instancia | Agente | Rol | Responsabilidades | Escribe en |
|-----------|--------|-----|-------------------|------------|
| A — Governor | `design-governor` | Director del Proyecto | Verifica precondición del 020; propone Sprint Contract; gestiona CP-03 y CP-04; decide Avanzar/Repetir | `persistence/harness-state.json` |
| B — Orchestrator | `design-orchestrator` | Capataz Técnico | Lee contrato; escribe Demo Statements en orchestration_plan; persiste plan antes de que A spawee Workers; registra checkpoints; verifica artefactos en disco (Pending Verification) | `persistence/execution-state.json` |
| D — Reviewer | `design-reviewer` | Control de Calidad Pre-CP-03 | Lee los 5 artefactos tras CP-02 y antes de CP-03. Verifica consistencia estructural (IDs cruzados, ADR-001 completo, Guía de Vertical Slices, coherencia de stack). Issues críticos → rework antes de CP-03. Issues menores → presentar al cliente con diagnóstico. | `030_design/review_report.md` |
| C — Evaluator | `design-evaluator` | Auditor Independiente | Lee los 5 artefactos sin contexto de ejecución; aplica rúbrica; emite APPROVED/REJECTED | `eval/verdict.json`, `eval/metrics_summary.json` |

Jerarquía de llamadas (nunca se viola):
- A → B (para planificar y registrar checkpoints), A → Workers (para ejecutar), A → D (para revisar entre CP-02 y CP-03), A → C (para auditar). Nunca simultáneo.
- **A NO llama Workers directamente hasta recibir PLAN_RESULT de B.**
- D NO llama a nadie. Solo lee del filesystem y escribe `030_design/review_report.md`.
- C NO llama a nadie. Solo lee del filesystem.

**Nota arquitectónica (LL-21):** Los agentes spawneados no pueden a su vez spawear sub-agentes.
Por este motivo, siguiendo el patrón del 020:
- El governor spawea los Workers directamente (design-analyst, design-architect).
- El orchestrator opera en modos 040_planning/CHECKPOINT: persiste el estado pero no spawea Workers.
- El governor es quien llama al orchestrator para planificar (PLAN) y para registrar cada checkpoint (CHECKPOINT).

**Todos los agentes son exclusivos del 030.** No comparten ni heredan instrucciones del 020 o del 010.

### 1.2 Workers Especializados

| Worker | Micro-tarea | Inputs que recibe | Output (path) |
|--------|-------------|-------------------|---------------|
| `design-analyst` | Lee los 8 inputs (I-1..I-8). Identifica bounded contexts, interfaces requeridas, patrones aplicables, restricciones tecnológicas. Produce design_analysis_report.md. | Paths a I-1..I-8 + Demo Statement del orchestration_plan | `/030_design/design_analysis_report.md` |
| `design-architect` | Lee design_analysis_report.md + domain_glossary.md + scope_boundaries.md. Selecciona stack, produce los 5 artefactos finales en orden. | Path a design_analysis_report.md + paths a I-2, I-6, I-7 + Demo Statement | `/030_design/technical_blueprint.md`, `/030_design/contract_definitions.md`, `/030_design/dependency_graph.md`, `/030_design/architecture_decision_records.md`, `/030_design/test_strategy_map.md` |

**Secuenciación:** design-analyst → design-architect (dependencia estricta, no paralela).

Cada Worker escribe sus artefactos al filesystem y reporta a A **solo el path**, nunca el
contenido (E6 — Regla de Referencias Ligeras).

**Demo Statements (ADJ-13):**

El design-orchestrator (modo PLAN) escribe un Demo Statement por Worker en el `orchestration_plan`
antes de que el governor spawee ningún Worker.

**Demo Statement para design-analyst:**
> "Cuando design-analyst termine, podré observar que `030_design/design_analysis_report.md`
> existe y contiene: ≥1 componente (CO-xx) por bounded context identificado en
> `bdd_features.md`; ≥1 interface requerida (IF-xx) por entidad en `data_contracts.md`;
> ≥1 patrón de diseño (PT-xx) con justificación; ≥1 restricción tecnológica (RT-xx)
> derivada de `scope_boundaries.md`."

**Demo Statement para design-architect:**
> "Cuando design-architect termine, podré observar que: `technical_blueprint.md` define
> la estructura de capas y ≥1 módulo (MOD-xx) por bounded context; `contract_definitions.md`
> tiene ≥1 interface (IC-xx) por entidad de data_contracts.md; `dependency_graph.md` describe
> la estrategia de inyección de dependencias; `architecture_decision_records.md` incluye
> ADR-001 (stack) con opciones evaluadas y justificación; `test_strategy_map.md` cubre
> cada IC-xx con su estrategia de mock/stub y contiene la sección 'Guía de Vertical Slices'
> con Tracer Bullet, MVP y Robustez, cada una con sus 5 campos (nombre, tipo, IC-xx asignados,
> BDD scenarios, criterio de Done)."

Cada Worker, al terminar su producción, ejecuta un self-checklist contra su Demo Statement.
- Si puede verificar todas las condiciones: reporta `COMPLETED`.
- Si no puede: reporta `INCOMPLETO: <razón específica>`. No reporta COMPLETED si alguna condición falla.

**Pending Verification (ADJ-13):**

Después de que un Worker reporta COMPLETED, el orchestrator (en modo CHECKPOINT) verifica en
disco que el artefacto esperado existe y tiene contenido antes de registrar el checkpoint.
- Si el artefacto no existe o está vacío: retornar `CHECKPOINT_FAILED` al governor.
- Solo si el artefacto existe en disco: registrar el checkpoint y retornar `CHECKPOINT_OK`.

El governor, al recibir `CHECKPOINT_FAILED`, no spawea el siguiente Worker. Registra
`WORKER_FAILED` en execution-state.json y escala al humano.

### 1.3 Política de Herramientas (P7)

| Agente | Herramientas permitidas | Restricciones |
|--------|------------------------|---------------|
| design-governor | Read, Write, Bash, Agent, AskUserQuestion | NUNCA escribe en `/030_design/` directamente |
| design-orchestrator | Read, Write | NUNCA escribe en `/030_design/`; solo en `persistence/execution-state.json` |
| design-analyst | Read, Write | Solo produce `/030_design/design_analysis_report.md` |
| design-architect | Read, Write, Edit | Produce los 5 artefactos en `/030_design/`; puede editar para corregir antes del self-checklist |
| design-evaluator | Read, Write | Lee de `/030_design/` y `/010_discovery/`; escribe solo en `eval/` |

Política de Fallback ante fallo de herramienta (3 niveles — E5):
1. **Reintento** (hasta 2x): reintentar si falla por error transitorio.
2. **Fallback**: si no se puede derivar un dato de los inputs, marcarlo con `[PENDIENTE: razón]`
   en el artefacto y continuar con los demás ítems.
3. **Escalamiento**: registrar en `execution-state.json` bajo `worker_errors`, notificar a A.
   A escala al humano vía `AskUserQuestion`. Sin inventar información técnica.

### 1.4 Política de Escalamiento (P6, E8)

Escalar al humano (detener flujo) en los siguientes casos:
- Las restricciones tecnológicas del `scope_boundaries.md` son contradictorias o insuficientes
  para seleccionar un stack sin riesgo de reversión.
- El design-analyst identifica un bounded context en `bdd_features.md` sin entidades
  correspondientes en `data_contracts.md` (gap de especificación).
- El design-architect no puede producir interfaces coherentes debido a ambigüedad en I-2.
- El cliente rechaza el stack propuesto (ADR-001) en CP-03 con una preferencia explícita.

En todos los casos: A registra el bloqueo en `harness-state.json` bajo `escalations` y
notifica al humano con contexto completo (ítem bloqueante, artefacto afectado, próxima acción propuesta).

### 1.5 Checkpoints Canónicos (E5)

| ID | Momento | Qué persiste B |
|----|---------|----------------|
| CP-01 | Tras design-analyst | Path a `030_design/design_analysis_report.md` en execution-state.json |
| CP-02 | Tras design-architect (draft) | Paths a los 5 artefactos en execution-state.json; marca `EXECUTION_COMPLETE` |
| — | Tras CP-02 (pre-CP-03) | A spawea design-reviewer. Si issues críticos → rework. Reviewer produce `030_design/review_report.md` |
| CP-03 | Cliente revisa draft | A presenta los 5 artefactos al cliente (+ issues menores del reviewer si los hay); registra feedback en `harness-state.json` |
| CP-04 | Cliente aprueba formalmente | A registra aprobación en `harness-state.json`; spawea C para auditoría |

### 1.6 Trigger de Context Reset (E2)

Criterios (el que ocurra primero):

- **Conductual (primario):** señales de ansiedad contextual durante la producción de artefactos:
  producir interfaces sin relación con los bounded contexts del 020, omitir el ADR-001
  de selección de stack, no usar el lenguaje ubicuo del glosario, declarar artefactos
  como COMPLETED sin ejecutar el self-checklist del Demo Statement.
- **Cuantitativo (secundario):** ≥70% de tokens usados.

Acción ante reset: continuar desde el último checkpoint guardado en `execution-state.json`
usando el Ritual E10-B (Continuación). Nunca reiniciar desde cero.

---

## Sprint Contract — Plantilla

Template que A propone al humano antes de spawear B. Requiere aprobación explícita antes de
continuar. Si el humano solicita ajustes, A incorpora y vuelve a presentar. Si cancela, A
registra en `claude-progress.txt` y detiene el flujo.

```
SPRINT CONTRACT — 030 Design
=====================================
Objetivo    : Transformar los contratos formales del 020 en un plano arquitectónico
              técnico (CÓMO está construido el sistema). Seleccionar el stack tecnológico
              y documentar todas las decisiones de arquitectura con su razonamiento.
Fase        : 030 — Design
Modo        : [INICIO | CONTINUACIÓN]
Precondición: 020 Specification — PHASE_COMPLETE ✓

Inputs disponibles:
  Desde /020_specification/:
  - bdd_features.md          : [confirmado / path]
  - data_contracts.md        : [confirmado / path]
  - acceptance_criteria.md   : [confirmado / path]
  - error_exception_policy.md: [confirmado / path]
  Desde /010_discovery/:
  - shared_understanding.md  : [confirmado / path — restricciones tecnológicas]
  - domain_glossary.md       : [confirmado / path — lenguaje ubicuo obligatorio]
  - scope_boundaries.md      : [confirmado / path — restricciones de stack]
  - failure_behavior.md      : [confirmado / path]

  Restricciones tecnológicas identificadas en scope_boundaries.md:
    [lista de restricciones relevantes extraídas — lenguaje, plataforma, infraestructura]

Workers activados:
  - design-analyst  → /030_design/design_analysis_report.md
  - design-architect → /030_design/technical_blueprint.md
                       /030_design/contract_definitions.md
                       /030_design/dependency_graph.md
                       /030_design/architecture_decision_records.md
                       /030_design/test_strategy_map.md

Checkpoints : CP-01, CP-02, CP-03, CP-04
Criterio Done:
  (1) ADR-001 documenta el stack con contexto, opciones evaluadas y justificación
  (2) Todos los bounded contexts del 020 tienen ≥1 módulo en technical_blueprint.md
  (3) Todas las entidades del 020 tienen interface + DTOs en contract_definitions.md
  (4) Cada interface tiene estrategia de mock/stub en test_strategy_map.md
  (5) Aprobación explícita del cliente en CP-04

Riesgos identificados:
  - [restricciones de stack contradictorias o insuficientes]
  - [bounded contexts con interfaces de alta complejidad que requieran múltiples patrones]
  - [decisiones de arquitectura que afecten el scope del 040 Planning]

Próxima acción: spawear design-orchestrator en modo PLAN para persistir el orchestration_plan
```

---

## Rúbrica de Evaluación (Instancia C)

### Dimensiones

| ID | Dimensión | Descripción | Score |
|----|-----------|-------------|-------|
| D1 | Blueprint Coverage | Todos los actores + bounded contexts de `bdd_features.md` tienen ≥1 módulo/componente en `technical_blueprint.md`. La estructura de capas es coherente con los escenarios BDD | 0.0–1.0 |
| D2 | Contract Completeness | Todas las entidades de `data_contracts.md` tienen interface técnica (IC-xx) y DTOs en `contract_definitions.md`. Sin entidades huérfanas ni interfaces sin entidad correspondiente | 0.0–1.0 |
| D3 | Testability | Cada interface (IC-xx) tiene punto de mock/stub documentado en `test_strategy_map.md`. La estrategia de DI en `dependency_graph.md` es coherente con la testabilidad requerida | 0.0–1.0 |
| D4 | ADR Completeness | ADR-001 (stack) incluye: contexto, ≥2 opciones evaluadas con pros/contras, decisión final con justificación técnica. Cada patrón de diseño mayor tiene su ADR | 0.0–1.0 |
| D5 | Consistency | Sin contradicciones entre los 5 artefactos. Sin contradicciones con los inputs del 020/010. Lenguaje ubicuo del glosario usado consistentemente | 0.0–1.0 |

**Gate de paso:** Score promedio ≥ 0.75 en todas las dimensiones.
**Regla de veto:** Si D5 = 0.0, rechazo automático independientemente de otras dimensiones.

### Anclas de calibración (few-shot — E3)

> Dominio de referencia: Sistema de Inventario y Alertas de Stock — Distribuidora Andina Ltda.
> Almacenista, jefa de compras, gerente como actores.

**Score 0.2** — Technical Blueprint solo lista carpetas genéricas sin módulos por bounded
context. Contract Definitions tiene interfaces sin métodos definidos. Dependency Graph
ausente o genérico. ADR-001 lista el stack sin evaluar alternativas. Test Strategy Map
vacío o menciona "escribir tests" sin estrategia de mock.

> Ejemplo: Blueprint con `src/`, `tests/`, `lib/` sin módulos de dominio (Inventario, Alertas,
> Compras). Contract Definitions tiene `IRepositorio` sin métodos. ADR-001 dice "usaremos
> Python + FastAPI porque es popular". Sin mención de cómo mockear la base de datos.

**Score 0.5** — Technical Blueprint con capas definidas pero módulos incompletos (faltan
bounded contexts secundarios). Contract Definitions define interfaces para entidades
principales pero sin DTOs. Dependency Graph describe la DI pero sin estrategia clara.
ADR-001 evalúa 2 opciones superficialmente. Test Strategy Map menciona mocks para ≥50%
de interfaces.

> Ejemplo: Blueprint define Inventario y Compras como módulos pero omite el módulo de
> Alertas. Contract Definitions tiene IInventarioRepository con sus métodos pero sin
> DTOs para los requests/responses. ADR-001 compara Python vs Node.js con 1 argumento
> por opción. Test Strategy Map documenta mock de DB pero no del servicio de alertas.

**Score 0.8** — Todos los bounded contexts con módulos. Contract Definitions completo
para entidades principales pero con 1-2 DTOs faltantes. Dependency Graph coherente con
DI documentada. ADR-001 con ≥2 opciones bien evaluadas pero faltando criterios de
decisión explícitos. Test Strategy Map cubre ≥80% de interfaces con estrategia de mock.
Guía de Vertical Slices presente pero incompleta.

> Ejemplo: Blueprint define Inventario, Alertas y Compras con submódulos correctos.
> Contract Definitions completo excepto falta el DTO de respuesta del endpoint de
> alertas. ADR-001 evalúa Python/FastAPI vs Node.js/Express con pros/contras pero
> no menciona el criterio de rendimiento bajo carga. Test Strategy Map completo para
> repositorios pero sin estrategia de mock para el servicio de notificaciones.
> 1 inconsistencia menor: dependency_graph menciona un servicio no definido en contract_definitions.

**Score 1.0** — Todos los bounded contexts con módulos y submódulos. Contract Definitions
100% completo: interfaces + DTOs para todas las entidades, incluyendo DTOs de error.
Dependency Graph con topología completa y estrategia de DI explícita. ADR-001 y ADRs
de patrones con contexto, opciones, criterios de decisión y consecuencias aceptadas.
Test Strategy Map cubre 100% de interfaces con mock/stub y niveles de test (unitario,
integración, contrato). Guía de Vertical Slices identifica al menos 3 slices (Tracer
Bullet, MVP, Robustez). Lenguaje ubicuo usado consistentemente. Sin contradicciones.

> Ejemplo: Blueprint define Inventario (Producto, Movimiento, Stock), Alertas (Umbral,
> Notificación), Compras (Orden, Proveedor) y capas de Dominio/Aplicación/Infraestructura.
> Contract Definitions tiene IProductoRepository con 5 métodos + ProductoDTO + ProductoErrorDTO.
> ADR-001: contexto = inventario con concurrencia baja (25 usuarios), opciones = Python/FastAPI
> vs FastAPI+SQLAlchemy vs Node.js/Express, criterios = simplicidad + soporte de ORM + curva
> del equipo, decisión = Python/FastAPI+SQLAlchemy con justificación para cada criterio.
> Test Strategy Map: IProductoRepository → mock con pytest-mock; IAlertaService → stub
> con respuesta configurable; tests unitarios por método de dominio, integración por endpoint.
> test_strategy_map sección "Vertical Slices": Tracer Bullet = endpoint GET /stock/{id},
> MVP = CRUD inventario + alertas básicas, Robustez = historial + informes. Sin ninguna
> contradicción entre los 5 artefactos.

### Output de C

```json
// eval/verdict.json — append al array existente
{
  "phase": "030_design",
  "evaluation_version": 1,
  "evaluated_at": "<timestamp>",
  "verdict": "APPROVED | REJECTED",
  "veto_triggered": false,
  "scores": {
    "D1_blueprint_coverage": 0.0,
    "D2_contract_completeness": 0.0,
    "D3_testability": 0.0,
    "D4_adr_completeness": 0.0,
    "D5_consistency": 0.0
  },
  "average": 0.0,
  "gate_threshold": 0.75,
  "gate_passed": false,
  "findings": [],
  "artifacts_evaluated": [
    "030_design/technical_blueprint.md",
    "030_design/contract_definitions.md",
    "030_design/dependency_graph.md",
    "030_design/architecture_decision_records.md",
    "030_design/test_strategy_map.md"
  ],
  "reference_artifacts_read": [
    "020_specification/bdd_features.md",
    "020_specification/data_contracts.md",
    "010_discovery/domain_glossary.md"
  ]
}
```

---

## Handoff Artifact → 040 Planning

Design entrega al 040 los siguientes artefactos. El 040 **no puede iniciarse** sin ellos.

```
/030_design/
├── technical_blueprint.md       → Base para el planning: qué módulos slicear en iteraciones
├── contract_definitions.md      → Interfaces que el planning debe asumir como contratos fijos
├── dependency_graph.md          → Dependencias que afectan el orden de implementación
├── architecture_decision_records.md → Decisiones ya tomadas; el 040 no las re-evalúa
└── test_strategy_map.md         → Estrategia de test y Guía de Vertical Slices → input directo para el 040

/020_specification/                  → El 040 hereda los 4 artefactos del 020
├── bdd_features.md
├── data_contracts.md
├── acceptance_criteria.md
└── error_exception_policy.md

/010_discovery/                      → El 040 hereda los 4 artefactos del 010
├── shared_understanding.md
├── domain_glossary.md
├── scope_boundaries.md
└── failure_behavior.md
```

**Condición de activación del 040:** `harness-state.json` debe tener `"030_design": {"status": "PHASE_COMPLETE"}`.

**Nota ADJ-04:** El `test_strategy_map.md` debe incluir una sección "Guía de Vertical Slices"
con al menos 3 iteraciones identificadas (Tracer Bullet, MVP, Robustez) para que el 040
Planning pueda trabajar bajo el paradigma de Vertical Slices desde el primer día.

---

## Flujo del Arnés

### 12.1 Inicialización (Instancia A — design-governor)

**Precondición absoluta — antes de cualquier acción:**
Verificar que `persistence/harness-state.json` existe y que la clave `"020_specification"`
tiene `"status": "PHASE_COMPLETE"`. Si no existe o el status es distinto: **detener flujo**.
Notificar al humano: "El 020 Specification debe completarse antes de iniciar el 030 Design.
Estado actual: [valor encontrado]."

**Determinación del modo:**

| Condición | Modo | Ritual |
|-----------|------|--------|
| No existe clave `"030_design"` en `harness-state.json` | Inicio | E10-A |
| Existe clave `"030_design"` e íntegra | Continuación | E10-B |
| Existe pero corrupta | Recuperación | `git restore persistence/harness-state.json`; si persiste → detener y reportar |

**Ritual E10-A — Inicio:**

1. Verificar directorio y ambiente
2. Crear carpeta `/030_design/` con verificación post-creación (ADJ-20):
   ```powershell
   if (-not (Test-Path "design")) { New-Item -ItemType Directory "design" | Out-Null }
   if (-not (Test-Path "design")) { # registrar error crítico y detener }
   ```
3. Leer `persistence/harness-state.json` completo. Agregar clave `"030_design"` con status
   `"PENDING_CONTRACT"` sin modificar ninguna clave existente.
   Fallback si JSON corrupto: `git restore persistence/harness-state.json`; si persiste, detener.
4. Inicializar `persistence/execution-state.json` para el 030 con estructura mínima.
5. Prueba básica de sanidad: escribir y leer archivo de prueba en `/030_design/`.
6. Registrar arranque en `persistence/claude-progress.txt` con `Add-Content -Encoding utf8`.

**Ritual E10-B — Continuación:**

1. Verificar directorio y ambiente
2. `git log --oneline -10` para orientación
3. Leer `persistence/claude-progress.txt` (estado narrativo)
4. Cargar `persistence/harness-state.json` (Sprint Contract vigente del 030)
5. Leer `persistence/execution-state.json` (último checkpoint alcanzado)
6. Seleccionar siguiente tarea según último CP:

| Estado en harness-state.json / execution-state.json | Siguiente acción |
|------------------------------------------------------|-----------------|
| `030_design.status == "AUDIT_PENDING"` | Ir directamente a Auditoría (verificar eval/verdict.json) |
| `execution_state.last_checkpoint == "CP-02"` o `status == "EXECUTION_COMPLETE"` | Presentar artefactos al cliente (CP-03) |
| `execution_state.last_checkpoint == "CP-01"` | Continuar con design-architect (re-spawear) |
| `execution_state.last_checkpoint == null` y `030_design.status == "ACTIVE"` | Continuar con design-analyst (re-spawear) |
| `030_design.status == "PENDING_CONTRACT"` | Proponer Sprint Contract al cliente |

7. Prueba básica de sanidad

**Reporte al humano (obligatorio tras inicialización):**

1. Estado encontrado (modo, integridad del 020, sanidad)
2. Restricciones tecnológicas identificadas en `scope_boundaries.md` (para contexto del Sprint Contract)
3. Sprint Contract propuesto (Inicio) o vigente (Continuación)
4. Próxima acción concreta

**Gate de aprobación humana:**

- **Aprobado** → A escribe Sprint Contract en clave `"030_design"` de `harness-state.json` y spawea B en modo PLAN
- **Ajuste requerido** → A incorpora cambios, vuelve a presentar
- **Cancelación** → A registra en `claude-progress.txt`, detiene flujo

### 12.2 Ejecución Técnica (Instancia B — design-orchestrator + Workers)

1. A spawea design-orchestrator en `[MODO: PLAN]`. Orchestrator:
   - Lee Sprint Contract desde `"030_design"` en `harness-state.json`
   - Consulta `knowledge/` si existe
   - Determina starting_point desde execution-state.json (CP-01, o null si inicio)
   - Escribe orchestration_plan completo con Demo Statements para cada Worker
   - Retorna `PLAN_RESULT`

2. A recibe PLAN_RESULT. Según starting_point:
   - `null` → spawear design-analyst
   - `CP-01` → spawear design-architect (saltar analyst)
   - `COMPLETE` → ir directamente a CP-03

3. **design-analyst** (si starting_point == null):
   - Recibe paths a I-1..I-8 y el Demo Statement del orchestration_plan
   - Lee los 8 inputs, produce `/030_design/design_analysis_report.md`
   - Ejecuta self-checklist contra Demo Statement
   - Si COMPLETED: reporta path a A
   - Si INCOMPLETO: reporta razón a A; A registra WORKER_FAILED y escala al humano

4. A spawea design-orchestrator en `[MODO: CHECKPOINT-01]` con path al design_analysis_report.md.
   Orchestrator verifica en disco (Pending Verification) y retorna CHECKPOINT_OK o CHECKPOINT_FAILED.

5. **design-architect** (si CP-01 alcanzado):
   - Recibe path a design_analysis_report.md + paths a I-2, I-6, I-7 + Demo Statement
   - Produce los 5 artefactos en orden: architecture_decision_records (ADR-001 primero) →
     technical_blueprint → contract_definitions → dependency_graph → test_strategy_map
   - Ejecuta self-checklist cruzado entre los 5 artefactos + Demo Statement
   - Si COMPLETED: reporta paths a A
   - Si INCOMPLETO: reporta razón a A; A registra WORKER_FAILED

6. A spawea design-orchestrator en `[MODO: CHECKPOINT-02]` con paths a los 5 artefactos.
   Orchestrator verifica en disco y retorna CHECKPOINT_OK o CHECKPOINT_FAILED.

### 12.3 Auditoría y Gate de Aprobación (Instancia C + A)

**Paso 1 — Gate intermedio (A):**

1. A verifica que `execution-state.json` tiene `EXECUTION_COMPLETE`
2. A presenta los 5 artefactos de `/030_design/` al cliente para revisión (CP-03)
3. **IMPORTANTE (ADJ-23):** Registrar `[CP-03 030]` en `claude-progress.txt` con
   `Add-Content -Encoding utf8` ANTES de presentar los artefactos. Aunque el cliente
   incluya aprobación en la misma respuesta del CP-03, presentar CP-04 como
   `AskUserQuestion` separado e independiente.
4. A incorpora feedback del cliente si hay cambios menores
5. A presenta CP-04: `AskUserQuestion` independiente para aprobación formal

**Paso 2 — Tras aprobación CP-04:**

1. A escribe `"030_design.status": "AUDIT_PENDING"` en `harness-state.json`
2. A registra `[AUDIT_PENDING 030]` en `claude-progress.txt`
3. A spawea design-evaluator pasando paths a los 5 artefactos + paths de referencia I-1, I-2, I-6

**Paso 3 — Auditoría (C — design-evaluator):**

1. C lee los 5 artefactos desde el filesystem (sin contexto de ejecución)
2. C lee `020_specification/bdd_features.md`, `020_specification/data_contracts.md`,
   `010_discovery/domain_glossary.md` como referencia para D1, D2 y D5 (verificación independiente)
3. C evalúa contra rúbrica (Sección anterior), aplica anclas de calibración — dos fases:
   análisis con citas concretas primero, score después (LL-07)
4. C verifica la regla de veto: si D5 = 0.0, emite rechazo automático
5. C escribe (**PATHS DE SALIDA — OBLIGATORIO: solo en `eval/`, nunca en `/030_design/`** — LL-03):
   - `eval/verdict.json` — append al array existente, entry con `"phase": "030_design"`
   - `eval/metrics_summary.json` — append al array existente
6. C registra auditoría en `persistence/claude-progress.txt`

**Paso 4 — Decisión final (A — GateKeeper):**

```
## Cierre — ANTES DE CUALQUIER ACCIÓN — VERIFICACIÓN OBLIGATORIA (LL-20):
1. Leer eval/verdict.json.
2. Verificar que existe al menos una entrada con "phase": "030_design".
3. Si NO existe → DETENER completamente. Ejecutar la sección Auditoría ahora.
   No continuar bajo ninguna circunstancia sin esta verificación.
```

- A lee `eval/verdict.json`, filtra por `"phase": "030_design"`, toma la última entrada
- **APPROVED** → A marca `"030_design.status": "PHASE_COMPLETE"` en `harness-state.json`,
  notifica al humano con paths de los 5 artefactos, activa handoff al 040
- **REJECTED** → A activa protocolo 12.4

### 12.4 Protocolo de Rechazo y Reintento

**Rechazo Técnico** (artefacto no cumple rúbrica):

1. C escribe rechazo detallado en `eval/verdict.json` con dimensiones fallidas y recomendaciones
2. A marca `"030_design.status": "IN_REWORK"` en `harness-state.json`
3. A spawea design-orchestrator en modo PLAN pasando referencia al rechazo
4. Orchestrator escribe nuevo plan; A spawea solo el Worker que produce el artefacto fallido
5. B lee `knowledge/lessons_learned.md` antes de re-ejecutar
6. El ciclo continúa desde 12.3

**Rechazo Estratégico** (cliente cambia el stack o rechaza la arquitectura):

1. A detiene flujo, marca `"030_design.status": "HOLD"` en `harness-state.json`
2. A actualiza Sprint Contract con el cambio
3. Sin avance hasta nueva aprobación humana explícita

**Registro de aprendizaje:**

Todo rechazo — técnico o estratégico — es registrado en `knowledge/lessons_learned.md` al
cierre del ciclo, con: dimensión fallida, causa raíz identificada y regla para sesiones futuras.

### 12.5 Cierre

1. A marca `"030_design.status": "PHASE_COMPLETE"` en `harness-state.json`
2. A actualiza `knowledge/lessons_learned.md` con hallazgos del ciclo (qué funcionó, qué no,
   qué decisiones de arquitectura generaron más iteración)
3. A actualiza `knowledge/decisions_library.md` con: stack seleccionado (ADR-001 resumido),
   patrones de diseño validados, decisiones de arquitectura reutilizables. **NO limitarse
   a hitos procedimentales** (ADJ-22) — incluir decisiones sustantivas de dominio técnico.
4. A notifica al humano con resumen de cierre:
   - Artefactos producidos y sus paths (los 5 artefactos en `/030_design/`)
   - Scores finales de la rúbrica
   - Estado listo para activar el 040
5. A registra cierre en `persistence/claude-progress.txt` con `Add-Content -Encoding utf8`
6. A hace commit final: `docs(030-design): phase complete — 5 artefactos producidos`

**Handoff al 040:**

A pregunta al humano si desea continuar con el 040 Planning.
- **Sí** → A registra `"handoff_040": {"status": "DEPLOYED"}` en `harness-state.json`,
  ejecuta deploy via `$env:HARNESS_DEPLOY_SCRIPT 040`, instruye al humano:
  **"Reinicia la sesión. El CLAUDE.md detectará el estado DEPLOYED y arrancará
  design-governor automáticamente."**
- **No** → A registra `"handoff_040": {"status": "PENDING_HANDOFF"}` en `harness-state.json`

Registrar evento en `claude-progress.txt` en cualquier caso.
