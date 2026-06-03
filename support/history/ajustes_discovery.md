# Ajustes: Alineación Metodología ↔ Principios y Estándares

Documento generado el 2026-05-26. Todas las brechas fueron aplicadas en la
misma sesión de trabajo sobre `Insumos/metodologia.md`.

---

## Estado Global

| Brecha | Descripción                                                         | Prioridad     | Estado                         |
| ------ | ------------------------------------------------------------------- | ------------- | ------------------------------ |
| 1      | E4 — Protocolo de Evolución del Harness (Sección 10 nueva)          | CRÍTICA       | IMPLEMENTADA                   |
| 2      | E3 — Few-shot en rúbrica del Evaluador (Sección 3)                  | CRÍTICA       | IMPLEMENTADA                   |
| 3      | E2 — Criterio conductual de context reset (Sección 6)               | SIGNIFICATIVA | IMPLEMENTADA                   |
| 4      | E10 — Pasos concretos del startup ritual (Sección 12.1)             | SIGNIFICATIVA | IMPLEMENTADA                   |
| 5      | E1 — GitHub como requisito explícito                                | MENOR         | IMPLEMENTADA (dentro de E10-A) |
| 6      | E12 — Plan del orquestador antes de crear Workers (Sección 3)       | MENOR         | IMPLEMENTADA                   |
| 7      | Numeración — Sección 10 faltante                                    | COSMÉTICA     | IMPLEMENTADA                   |
| A      | E9 — Evaluación Temprana no operacionalizada                        | SIGNIFICATIVA | IMPLEMENTADA                   |
| B      | E11 — Búsqueda de Amplio a Estrecho no operacionalizada             | SIGNIFICATIVA | IMPLEMENTADA                   |
| C      | E5 — Fallback ante fallo de herramienta ausente                     | MENOR         | IMPLEMENTADA                   |
| D      | E6 — Orquestador debe recibir solo paths/IDs, no contenido completo | MENOR         | IMPLEMENTADA                   |
| E      | Sección 12.2 faltante (salto 12.1 → 12.3)                           | COSMÉTICA     | IMPLEMENTADA                   |

---

## Detalle por Brecha

### BRECHA 1 — E4: Mínima Complejidad — IMPLEMENTADA
**Sección afectada:** Nueva Sección 10 "Evolución del Harness"
**Cambio aplicado:** Se creó la Sección 10 con tres subsecciones:
- 10.1 Principio de Construcción Mínima: cada componente documenta la suposición
  que cubre; no se agrega sin evidencia de que su ausencia degrada la calidad.
- 10.2 Ciclo de Re-evaluación Periódica: inventario → prueba de remoción →
  decisión (MANTENIDO/ELIMINADO) → exploración de nuevas capacidades del modelo.
- 10.3 Responsabilidades: Instancia A es dueña; artefacto de salida en
  `decisions_library.md`; frecuencia mínima: una vez por proyecto completado.

---

### BRECHA 2 — E3: Calibración del Evaluador con Few-Shot — IMPLEMENTADA
**Sección afectada:** Sección 3, ítem "Rúbrica de Evaluación"
**Cambio aplicado:** El ítem ahora exige tres elementos obligatorios:
- a) Dimensiones definidas con nombre, descripción y peso (4 estándar: Precisión
  Factual, Completitud, Calidad de Fuentes, Eficiencia de Herramientas).
- b) Mínimo 2 ejemplos few-shot calibrados (uno aprobado ≥ 0.7, uno rechazado < 0.5).
- c) Anclas de calibración por nivel (1.0 / 0.5 / 0.0) para cada dimensión.

---

### BRECHA 3 — E2: Criterio de Activación Conductual — IMPLEMENTADA
**Sección afectada:** Sección 6, ítem "Trigger de Context Reset (E2)"
**Cambio aplicado:** Se agregó el criterio conductual como condición primaria:
- Cuantitativo: ≥ 70% de tokens (condición original, se mantiene).
- Conductual: cierre prematuro de tareas, omisión de pasos SDD+TDD, respuestas
  superficiales, o falso "terminado" sin verificar criterios de aceptación.
Se establece que el criterio conductual es el indicador más temprano y que ante
duda siempre se prioriza el reset sobre la compactación.

---

### BRECHA 4 — E10: Startup Ritual con Pasos Concretos — IMPLEMENTADA
**Sección afectada:** Sección 12.1, rituales E10-A y E10-B
**Cambio aplicado:**
- E10-A (Inicio nuevo): 6 pasos ordenados — verificar ambiente → crear carpetas
  → inicializar archivos de estado → git init + remote GitHub → prueba de sanidad
  → registrar arranque en progress.
- E10-B (Continuación): 7 pasos ordenados — verificar ambiente → git log → leer
  progress → cargar harness-state + Sprint Contract → leer execution-state →
  seleccionar siguiente tarea → prueba de sanidad.

---

### BRECHA 5 — E1: GitHub como Requisito Explícito — IMPLEMENTADA
**Sección afectada:** Sección 12.1, E10-A paso 4
**Cambio aplicado:** Cubierta dentro del paso 4 de E10-A: "Ejecutar `git init`
y enlazar inmediatamente el repositorio a un remote en GitHub (`git remote add
origin <url>`). Sin este enlace, la trazabilidad (P8) queda en riesgo ante
fallos locales."

---

### BRECHA 6 — E12: Plan del Orquestador antes de Crear Workers — IMPLEMENTADA
**Sección afectada:** Sección 3, descripción de Instancia B
**Cambio aplicado:** Regla crítica agregada: antes de activar cualquier Worker,
la Instancia B debe persistir su `orchestration_plan` en `execution-state.json`.
Un Worker nunca debe ser activado sin que este plan esté guardado.

---

### BRECHA 7 — Numeración: Sección 10 faltante — IMPLEMENTADA
**Cambio aplicado:** La Sección 10 fue creada para alojar el Protocolo de
Evolución del Harness (E4). La numeración del documento quedó continua:
9 → 10 → 11 → 12.

---

## Segunda Revisión — Brechas Pendientes (detectadas el 2026-05-26)

### BRECHA A — E9: Evaluación Temprana no operacionalizada — IMPLEMENTADA

**Problema:** E9 aparece únicamente como línea en el listado de estándares de la
Sección 1. `principios.md` define un protocolo activo: *"No esperar a tener el
harness completo para evaluar: empezar con ~20 queries/casos representativos.
Los cambios tempranos tienen efectos dramáticos (diferencias de 30% a 80% en
calidad)."* Un agente que lea la metodología no sabe cuándo ni cómo aplicar
evaluación temprana.

**Ajuste requerido:** Agregar una subsección en la Sección 9 (Estándares de
Ingeniería) o como punto dentro de la Sección 7 (Construcción Iterativa) con:

```
### Evaluación Temprana (E9)
- No esperar a tener el harness completo para iniciar la evaluación.
- Al finalizar el primer componente funcional, ejecutar una muestra de
  ~20 casos representativos del dominio.
- Los cambios aplicados en esta etapa tienen un impacto de 30%–80% en
  la calidad final; su costo es mínimo comparado con corregir tarde.
- Responsable: Instancia C, coordinada por Instancia B, antes de pasar
  al segundo componente del ciclo SDD+TDD.
- El resultado de esta evaluación temprana se registra en
  `execution-state.json` y puede activar un ajuste del Sprint Contract
  sin necesidad de completar la fase completa.
```

---

### BRECHA B — E11: Búsqueda de Amplio a Estrecho no operacionalizada — IMPLEMENTADA

**Problema:** E11 aparece únicamente como línea en el listado de estándares de
la Sección 1. `principios.md` define: *"Comenzar con queries cortas y amplias
para evaluar disponibilidad de información, luego profundizar en áreas con mayor
densidad. Evitar comprometer el plan a una fuente antes de explorar la amplitud."*
Especialmente crítico en las fases de Gobernanza (`010_discovery`, `020_specification`).

**Ajuste requerido:** Agregar como punto dentro de la Sección 5 (Fase 0: Definición
Estructural) o en la descripción de la Instancia B en Sección 3:

```
### Estrategia de Exploración (E11)
Aplicar en cualquier fase donde se deba recopilar o analizar información
de dominio (especialmente en 010_discovery y 020_specification):
1. Comenzar con queries o búsquedas amplias y cortas para mapear el
   espacio de información disponible.
2. Identificar las áreas con mayor densidad de información relevante.
3. Solo entonces profundizar con queries específicas sobre esas áreas.
4. No comprometer el plan ni la arquitectura a una sola fuente o enfoque
   antes de haber explorado la amplitud del espacio.
Este patrón aplica tanto a búsquedas de información externa como al
análisis interno de requerimientos con el cliente.
```

---

### BRECHA C — E5: Fallback ante Fallo de Herramienta — IMPLEMENTADA

**Problema:** `metodologia.md` cubre los checkpoints canónicos y el `git restore`
ante corrupción de archivos de estado, pero no define qué hace un agente cuando
una **herramienta específica** falla durante la ejecución. `principios.md` dice:
*"Los agentes deben poder adaptar su comportamiento cuando una herramienta falla
(fallback, reintento, escalamiento)."* Sin esta política, el agente se bloquea
o improvisa de forma no controlada.

**Ajuste requerido:** En la Sección 6 (Fase 1: Diseño Agéntico), agregar junto
a los Checkpoints Canónicos (E5):

```
**Política de Fallback de Herramientas (E5):** Para cada herramienta crítica
definida en la Política de Herramientas (P7), el harness debe especificar:
  1. Reintento: número de intentos antes de escalar (recomendado: 2).
  2. Fallback: herramienta o método alternativo si el reintento falla.
  3. Escalamiento: si el fallback también falla, detener la tarea y
     registrar el bloqueo en `claude-progress.txt` solicitando
     intervención humana. No improvisar ni continuar con datos parciales.
```

---

### BRECHA D — E6: Orquestador Recibe Solo Referencias (Paths/IDs) — IMPLEMENTADA

**Problema:** `metodologia.md` establece el Single Writer Rule y que los agentes
escriben al filesystem, pero no declara que el orquestador **no debe recibir el
contenido completo** de los Workers. `principios.md` E6: *"El orquestador recibe
solo referencias ligeras (paths, IDs), no el contenido completo. Esto mejora
fidelidad, reduce overhead de tokens y evita cuellos de botella ('teléfono
descompuesto')."* Esta distinción es la esencia de E6.

**Ajuste requerido:** En la Sección 4.1 (Single Writer Rule), agregar tras la
definición de `execution-state.json`:

```
**Regla de Referencias Ligeras (E6):** Cuando un Worker completa su tarea,
reporta al Orquestador (Instancia B) únicamente la referencia al artefacto
producido (path del archivo, ID del recurso), nunca el contenido completo.
El Orquestador actualiza `execution-state.json` con la referencia y
continúa la coordinación. Pasar contenido completo entre agentes degrada
la fidelidad de la información ("teléfono descompuesto") y consume tokens
innecesariamente.
```

---

### BRECHA E — Sección 12.2 faltante — IMPLEMENTADA

**Cambio aplicado:** Resuelta al reescribir la Sección 12 completa. La numeración
quedó continua y cada instancia tiene su propia subsección:
- 12.1 Inicialización (Instancia A)
- 12.2 Ejecución Técnica (Instancia B + Workers)
- 12.3 Auditoría y Gate de Aprobación (Instancia C + A)
- 12.4 Protocolo de Rechazo y Reintento
- 12.5 Protocolo de Gestión de Cambios (CR)

---

## Tercera Revisión — Observaciones sobre Harnesses (detectadas el 2026-05-26)

### OBS-01 — 010_discovery: Falta criterio de "done" para la exploración — IMPLEMENTADA

**Harness afectado:** `010_discovery_harness.md`
**Problema:** El harness no define cuándo termina la fase de preguntas socrática.
Sin un criterio explícito de "terminado", el harness puede iterar indefinidamente
o cerrarse prematuramente antes de capturar el entendimiento real del cliente.
**Ajuste requerido:** Agregar criterios de completitud: señales concretas que
indican que el entendimiento es suficiente para pasar al 020 (ej: cliente aprueba
el Shared Understanding Document, no emergen nuevas contradicciones en 2 rondas
consecutivas, todos los actores identificados tienen objetivos definidos).

---

### OBS-02 — 020_specification: Error Policy sin input del cliente — IMPLEMENTADA (en 010)

**Harness afectado:** `020_specification_harness.md`
**Problema:** La `Error & Exception Policy` se construye en el 020 sin que el
010 haya preguntado al cliente cómo espera que el sistema falle. El cliente tiene
expectativas sobre el comportamiento ante errores (mensajes, reintentos, bloqueos)
que no se capturan en la fase de alineación.
**Ajuste requerido:** Agregar en el 010 una pregunta de exploración sobre
comportamiento esperado ante fallos, y pasar esa información como input al 020.

---

### OBS-03 — 030_design: Stack tecnológico sin harness que lo defina — IMPLEMENTADA

**Harness afectado:** `030_design_harness.md`
**Problema:** El 030 recibe el "Stack Tecnológico Seleccionado" como input, pero
ningún harness anterior lo define formalmente. El 010 captura restricciones
tecnológicas mencionadas por el cliente, pero no hay una decisión explícita de
selección de stack entre el 010 y el 030.
**Ajuste requerido:** Agregar en el 020 o como paso inicial del 030 un proceso
formal de selección y documentación del stack, con criterios basados en los
constraints del 010 y los requerimientos del 020.

---

### OBS-04 — 040_planning: Ambigüedad sobre frecuencia de ejecución — IMPLEMENTADA

**Harness afectado:** `040_planning_harness.md`
**Problema:** El harness acepta "Aprendizaje de Iteraciones Previas" como input,
lo que implica re-ejecuciones. Pero su nombre y propósito sugieren ejecución única.
No está definido si es un harness de una sola vez o uno que se activa al inicio
de cada iteración para re-planificar.
**Ajuste requerido:** Declarar explícitamente la frecuencia de ejecución: una vez
al inicio del proyecto (roadmap completo) y opcionalmente al inicio de cada
iteración solo para confirmar o ajustar el Iteration Scope.

---

### OBS-05 — 050_iteration: Relación jerárquica con 060 y 070 no definida — IMPLEMENTADA

**Harness afectado:** `050_iteration_harness.md`
**Problema:** El 050 orquesta el TDD loop, pero no define si el 060 (Isolation)
y el 070 (Execution) son Workers subordinados que él spawea, o harnesses
independientes que se activan secuencialmente. Esta ambigüedad viola P1
(Separación de Roles) y la jerarquía de llamadas definida en la metodología.
**Ajuste requerido:** Declarar explícitamente que el 050 actúa como Instancia B
respecto al 060 y 070: los spawea como Workers especializados para cada micro-tarea,
recibe sus outputs como referencias (paths), y reporta a su orquestador superior.

---

### OBS-06 — 060_isolation: Falta política de fallback del sandbox — IMPLEMENTADA

**Harness afectado:** `060_isolation_harness.md`
**Problema:** El harness no define qué ocurre si el entorno sandbox no puede
crearse (conflicto de ramas, dependencias rotas, permisos insuficientes). Sin
política de fallback, el fallo bloquea silenciosamente al 070 y al 050.
**Ajuste requerido:** Agregar política de fallback específica: reintento (x2),
fallback a entorno alternativo si está disponible, y escalamiento explícito al
050 con `Isolation Report` marcado como `FAILED` si no puede resolverse.

---

### OBS-07 — 070_execution: Dependencia ciega del 060 — IMPLEMENTADA

**Harness afectado:** `070_execution_harness.md`
**Problema:** El 070 depende completamente del sandbox entregado por el 060, pero
no tiene mecanismo para detectar si ese sandbox es inválido o está degradado.
Si el 060 falla silenciosamente, el 070 ejecuta código en un entorno no aislado
sin saberlo.
**Ajuste requerido:** Agregar una validación inicial en el 070: antes de ejecutar
el ciclo Red-Green-Refactor, verificar la integridad del sandbox recibido
(checksum del Isolation Report, verificación de que los archivos filtrados son
los esperados). Si la validación falla, detener y reportar al 050.

---

### OBS-08 — 080_verification: Ruta de regreso ante fallo no definida — IMPLEMENTADA

**Harness afectado:** `080_verification_harness.md`
**Problema:** La "Validación del Contrato de Valor" al final del 080 puede fallar,
pero no está definido a qué harness regresa el flujo: ¿050 (re-iteración), 040
(re-planificación) o 020 (especificación incorrecta)? Sin esta ruta, el rechazo
queda sin dueño y el proyecto se bloquea.
**Ajuste requerido:** Definir árbol de decisión ante fallo en el 080:
- Fallo técnico (tests, integración) → regresa al 050.
- Fallo de valor (no resuelve el problema de negocio) → regresa al 040 o 020
  según el alcance del desvío, con escalamiento al humano obligatorio.

---

### OBS-09 — 090_deployment: Peer review humano sin harness asignado — IMPLEMENTADA

**Harness afectado:** `090_deployment_harness.md`
**Problema:** El 090 recibe el `Ready-for-Review Artifact` ya aprobado por
humanos como input, pero ningún harness gestiona ese proceso de peer review.
El 080 entrega el PR listo; la aprobación humana cae en el vacío entre 080 y 090.
**Ajuste requerido:** Definir explícitamente que el gate de peer review es
responsabilidad de la **Instancia A** (GateKeeper) entre el 080 y el 090.
A presenta el PR al humano, recibe la aprobación, y solo entonces activa el 090.
Este gate debe quedar documentado en el flujo del 080 como paso de cierre.


# Ajustes Arquitectónicos de Infraestructura: Banco de Assets e Inyección Dinámica

Este documento establece las especificaciones técnicas para desacoplar las instrucciones operativas de los agentes de las carpetas efímeras de ejecución, implementando un modelo de carga bajo demanda controlado por una matriz de intersección de variables de estado.

---

### Ajuste 1001 — Especificación del Banco Central de Agentes y Habilidades

#### 1. Ficha del Componente
* **Nombre de archivo sugerido:** `harness_assets_bank.md`
* **Ubicación propuesta en el repositorio maestro:** `/standards/harness_assets_bank.md`
* **Propósito:** Actuar como la "Fuente Única de la Verdad" (*Source of Truth*) global y agnóstica para almacenar todas las definiciones de comportamiento (Agentes) y de capacidades técnicas o de negocio (Skills). Evita la acumulación de texto muerto en la carpeta operativa de la CLI, previniendo la contaminación cruzada de contexto.

#### 2. Estructura Jerárquica del Directorio Central
El repositorio del banco debe organizarse de manera estricta bajo el siguiente árbol de directorios:

```text
/harness-assets-bank/
├── agents/                       # Plantillas de configuración de Agentes (Markdown)
│   ├── discovery-dialoguer.md
│   ├── discovery-analyst.md
│   ├── discovery-synthesizer.md
│   ├── discovery-evaluator.md
│   └── w-coder.md
└── skills/                       # Bloques modulares de instrucciones operativas
    ├── core/                     # Skills metodológicas universales (Obligatorias por rol)
    │   ├── sdd-compliance.md
    │   └── tdd-loop-discipline.md
    ├── tech-stacks/              # Habilidades tecnológicas (Inyectadas por diseño)
    │   ├── frontend-react.md
    │   ├── backend-go-clean-arch.md
    │   └── mobile-swiftui.md
    └── business-domains/         # Lógica y restricciones de negocio (Inyectadas por dominio)
        ├── financial-precision-math.md
        └── high-throughput-booking.md
```

#### 3. Esquema de Metadatos Obligatorios (YAML Front Matter)
Para que el Orquestador físico pueda indexar y filtrar los componentes dinámicamente, cada archivo dentro del banco debe iniciar con un bloque de metadatos estructurado.

Ejemplo para un Agente (/agents/w-coder.md):
---
asset_type: agent
id: AG-070-CODER
name: w-coder
allowed_harnesses: 
  - 070_execution_harness
required_core_skills:
  - tdd-loop-discipline
---

Ejemplo para una Skill Técnica (/skills/tech-stacks/backend-go-clean-arch.md):
---
asset_type: skill
category: tech-stack
id: SK-TECH-GO-CLEAN
matching_key: backend-go-clean-arch
description: Reglas estrictas de empaquetado, dependencias y arquitectura limpia para Go.
---


---

# Ajustes de Implementación — 010 Discovery Harness

Detectados el 2026-05-28 mediante auditoría sistemática del plan `plans/010_discovery_harness.md`
contra los 6 agentes y 7 skills construidos. Estado inicial: todos PENDIENTES.

| ID     | Descripción                                                                                    | Prioridad     | Estado                      |
| ------ | ---------------------------------------------------------------------------------------------- | ------------- | --------------------------- |
| IMP-01 | execution-state.json: ambigüedad sobre quién lo crea primero                                   | CRÍTICA       | IMPLEMENTADO ✓              |
| IMP-02 | Context Reset trigger conductual sin implementación en agentes                                 | SIGNIFICATIVA | IMPLEMENTADO ✓              |
| IMP-03 | claude-progress.txt sin schema formal                                                          | SIGNIFICATIVA | IMPLEMENTADO ✓              |
| IMP-04 | lessons_learned.md y decisions_library.md sin schema                                           | SIGNIFICATIVA | IMPLEMENTADO ✓              |
| IMP-05 | Modo Aclaración de discovery-dialoguer ausente en el plan                                      | MENOR         | IMPLEMENTADO ✓              |
| IMP-06 | resume_from y last_checkpoint son redundantes en execution-state                               | MENOR         | IMPLEMENTADO ✓              |
| IMP-07 | Versionado de artefactos en rework no especificado                                             | MENOR         | IMPLEMENTADO ✓              |
| IMP-08 | Timestamps placeholders en lugar de timestamps reales del sistema                              | MENOR         | IMPLEMENTADO ✓              |
| IMP-09 | Governor escribe transcript directamente, cortocircuitando flujo                               | SIGNIFICATIVA | IMPLEMENTADO ✓              |
| IMP-10 | Primer spawn falla por permisos, causa re-spawn innecesario                                    | SIGNIFICATIVA | IMPLEMENTADO ✓              |
| IMP-11 | Archivos de persistencia en raíz del proyecto (mover a persistence/)                           | SIGNIFICATIVA | IMPLEMENTADO ✓              |
| IMP-12 | Proyecto no tiene CLAUDE.md propio que instruya seguir el harness                              | SIGNIFICATIVA | IMPLEMENTADO ✓              |
| IMP-13 | GitHub no se enlaza desde el inicio (solo advertencia, no bloqueo)                             | MENOR         | DIFERIDO ⏸                  |
| IMP-14 | Frase de inicio del harness es técnica y no intuitiva                                          | MENOR         | IMPLEMENTADO ✓ (por IMP-12) |
| IMP-15 | Frase de reanudación idéntica a la de inicio — no hay distinción                               | MENOR         | IMPLEMENTADO ✓ (por IMP-12) |
| IMP-16 | Mentalidad del evaluador: sesgo negativo produce rechazos falsos                               | SIGNIFICATIVA | IMPLEMENTADO ✓              |
| IMP-17 | No existe script de deployment para copiar harness a proyecto cliente                          | SIGNIFICATIVA | IMPLEMENTADO ✓              |
| IMP-18 | Sprint Contract no incluye checkpoints canónicos ni Criterio de Done                           | MENOR         | IMPLEMENTADO ✓              |
| IMP-19 | Orchestrator escribe en /discovery/ directamente en lugar de spawnear Workers                  | CRÍTICA       | IMPLEMENTADO ✓              |
| IMP-20 | Governor salta Auditoría (evaluador) y cierra fase directamente tras CP-04                     | CRÍTICA       | IMPLEMENTADO ✓              |
| IMP-21 | Orchestrator escribe timestamps placeholder en claude-progress.txt                             | MENOR         | IMPLEMENTADO ✓              |
| IMP-22 | No hay mecanismo de knowledge cross-project — aprendizajes no viajan entre proyectos           | SIGNIFICATIVA | DISEÑADO — PENDIENTE IMPL.  |
| IMP-23 | discovery-analyst no escribe analysis_report.md — reporta a B sin persistir el archivo         | CRÍTICA       | IMPLEMENTADO ✓              |
| IMP-24 | Orchestrator no actualiza execution-state.json con checkpoints CP-01/CP-02/CP-03               | SIGNIFICATIVA | IMPLEMENTADO ✓              |
| IMP-25 | Evaluator aprueba con score 1.0 sin analysis_report.md — no detecta ausencia del paso          | MENOR         | IMPLEMENTADO ✓              |
| IMP-26 | Orchestrator persiste I1/I2/I3 como null en lugar de los paths reales de inputs                | MENOR         | IMPLEMENTADO ✓              |
| IMP-27 | discovery-analyst completa análisis mentalmente y retorna sin ejecutar Write del reporte       | CRÍTICA       | IMPLEMENTADO ✓              |
| IMP-28 | No existe dashboard HTML en tiempo real para que el humano observe el progreso del harness     | MENOR         | PENDIENTE                   |
| IMP-29 | Dialoguer retorna a B tras identificar stakeholders sin completar la entrevista                | CRITICA       | IMPLEMENTADO ✓ (2 rondas)   |
| IMP-30 | Dialoguer no verifica condiciones de Done después de cada ronda — puede iterar indefinidamente | SIGNIFICATIVA | IMPLEMENTADO ✓              |
| IMP-31 | verdict.json y metrics_summary.json se escriben en discovery/ en lugar de eval/               | MENOR         | IMPLEMENTADO ✓              |

---

### IMP-01 — execution-state.json: ambigüedad de creación — IMPLEMENTADO ✓

**Prioridad:** CRÍTICA
**Archivos afectados:** `discovery-governor.md` (E10-A Paso 3), `discovery-orchestrator.md` (Paso 4), `discovery-state-schema/SKILL.md`

**Problema:**
El plan dice que el governor crea `execution-state.json` en E10-A paso 3 ("vacío con `last_checkpoint: null`"). Pero la implementación actual del governor no crea este archivo explícitamente — solo menciona "crear `execution-state.json` vacío" sin el JSON concreto. El orchestrator lo sobreescribe en Paso 4 con el `orchestration_plan` completo. Si el archivo no existe cuando el orchestrator intenta leerlo en Paso 3 (verificar último checkpoint), el flujo falla silenciosamente.

**Ajuste requerido:**
1. En `discovery-governor.md` E10-A Paso 3: agregar la creación explícita de `execution-state.json` con la estructura inicial mínima del schema (solo `last_checkpoint: null`, `status: null`, sin `orchestration_plan`).
2. En `discovery-state-schema/SKILL.md`: agregar regla explícita — "governor crea el archivo en E10-A con estructura mínima; orchestrator escribe `orchestration_plan` y checkpoints sobre ese archivo ya existente."
3. En `discovery-orchestrator.md` Paso 3: agregar manejo explícito para cuando `execution-state.json` no existe (crear con estructura mínima como fallback, no fallar).

---

### IMP-02 — Context Reset trigger conductual sin implementación — IMPLEMENTADO ✓

**Prioridad:** SIGNIFICATIVA
**Archivos afectados:** `discovery-dialoguer.md`, `discovery-governor.md`

**Problema:**
El plan (Sección 2.6) define señales de ansiedad contextual que deben activar un Context Reset: saltarse preguntas del guión, cerrar rondas sin cumplir el Criterio de Done, respuestas superficiales, declarar "terminado" sin verificar las 4 condiciones. Ningún agente tiene instrucción explícita de qué hacer al detectar estas señales. El criterio cuantitativo (≥70% tokens) es responsabilidad del runtime, pero el conductual requiere acción activa del agente.

**Ajuste requerido:**
1. En `discovery-dialoguer.md`: agregar sección "Detección de Context Reset" con checklist de señales a auto-monitorear al final de cada ronda. Si detecta señal conductual → registrar en transcript como `[CONTEXT_RESET_SIGNAL]` y notificar a governor.
2. En `discovery-governor.md`: agregar instrucción de qué hacer al recibir señal de reset desde dialoguer — continuar desde último checkpoint vía E10-B sin reiniciar desde cero.

---

### IMP-03 — claude-progress.txt sin schema formal — IMPLEMENTADO ✓

**Prioridad:** SIGNIFICATIVA
**Archivos afectados:** `discovery-governor.md` (referenciado en 6+ secciones), `discovery-state-schema/SKILL.md`

**Problema:**
`claude-progress.txt` es un archivo de log narrativo que el governor crea y actualiza en E10-A, E10-B, gates, rechazos y cierre. Cada sección del governor define su propia cadena de texto para escribir, pero no hay schema formal de formato. Esto puede causar inconsistencia en los registros y dificultar la lectura del estado por un agente en E10-B.

**Ajuste requerido:**
Agregar en `discovery-state-schema/SKILL.md` un schema para `claude-progress.txt`:
- Formato de entrada: `[TIPO_EVENTO] [timestamp ISO 8601] — descripción`
- Tipos de evento válidos: `INICIO`, `E10-A COMPLETO`, `E10-B REANUDACIÓN`, `SPRINT_CONTRACT_APROBADO`, `CP-01`, `CP-02`, `CP-03`, `CP-04`, `RECHAZO TÉCNICO`, `RECHAZO ESTRATÉGICO`, `CANCELADO`, `CIERRE`
- Regla: una línea por evento; nunca modificar entradas anteriores; solo agregar al final.

---

### IMP-04 — lessons_learned.md y decisions_library.md sin schema — IMPLEMENTADO ✓

**Prioridad:** SIGNIFICATIVA
**Archivos afectados:** `discovery-governor.md` (escribe en ambos), `discovery-orchestrator.md` (lee decisions_library)

**Problema:**
Ambos archivos son referenciados por múltiples agentes pero no tienen schema definido en ninguna skill:
- `lessons_learned.md`: governor escribe en él durante el protocolo de rechazo y en el cierre, pero el formato de cada entrada no está especificado.
- `decisions_library.md`: el orchestrator lo consulta al iniciar (Paso 2) pero el archivo nunca se crea ni se define quién lo escribe por primera vez.

**Ajuste requerido:**
Crear skill `discovery-knowledge-schema` con:
- Schema de `lessons_learned.md`: sección por ciclo, campos `timestamp`, `tipo` (técnico/estratégico/aprendizaje), `descripción`, `acción tomada`, `resultado`.
- Schema de `decisions_library.md`: tabla de decisiones con `ID`, `decisión`, `razón`, `harness`, `timestamp`. Escritor: governor en cierre o durante gates. Nunca orchestrator ni workers.

---

### IMP-05 — Modo Aclaración de discovery-dialoguer ausente en el plan — IMPLEMENTADO ✓

**Prioridad:** MENOR
**Archivos afectados:** `plans/010_discovery_harness.md` (Sección 2.2 y 6.2)

**Problema:**
La implementación de `discovery-dialoguer.md` incluye dos modos de operación (Discovery y Aclaración), pero el plan solo documenta el flujo principal. El Modo Aclaración — activado cuando discovery-analyst encuentra issues y re-spawna discovery-dialoguer — es una decisión de diseño importante que debería estar en el plan para que harnesses futuros puedan replicar el patrón.

**Ajuste requerido:**
En `plans/010_discovery_harness.md` Sección 6.2, agregar nota tras el paso 7: "Si discovery-analyst encuentra issues en la primera ejecución, re-spawna discovery-dialoguer en Modo Aclaración (solo preguntas PA-xx del analysis_report). Este ciclo puede repetirse hasta 3 veces antes de escalar al humano."

---

### IMP-06 — resume_from y last_checkpoint redundantes — IMPLEMENTADO ✓

**Prioridad:** MENOR
**Archivos afectados:** `discovery-state-schema/SKILL.md`, `discovery-orchestrator.md`

**Problema:**
`execution-state.json` tiene dos campos que sirven el mismo propósito: `last_checkpoint` (CP completado) y `resume_from` dentro de `orchestration_plan` (desde dónde reanudar). El orchestrator usa `last_checkpoint` para decidir la reanudación (Paso 3) y escribe `resume_from` en el plan (Paso 4), pero nunca lo lee de vuelta. La redundancia puede causar inconsistencia si uno se actualiza y el otro no.

**Ajuste requerido:**
Eliminar `resume_from` del schema de `orchestration_plan` en `discovery-state-schema/SKILL.md`. La reanudación se determina exclusivamente por `last_checkpoint`. Actualizar `discovery-orchestrator.md` Paso 4 para que no persista `resume_from`.

---

### IMP-07 — Versionado de artefactos en rework no especificado — IMPLEMENTADO ✓

**Prioridad:** MENOR
**Archivos afectados:** `discovery-synthesizer.md`, `discovery-verdict-schema/SKILL.md`

**Problema:**
`metrics_summary.json` registra `"final_version"` y `"revisions"` para los artefactos, pero no hay instrucción en `discovery-synthesizer.md` sobre cómo incrementar estos valores cuando el harness entra en rework (rechazo técnico → re-ejecución del orchestrator). Si el synthesizer re-escribe los mismos archivos en una segunda ejecución, el contador de versiones no se actualiza automáticamente.

**Ajuste requerido:**
En `discovery-synthesizer.md`: agregar instrucción al inicio para leer `execution-state.json` y verificar si ya existen artefactos previos. Si existen, incrementar el campo `revision` en `metrics_summary.json` antes de sobreescribir. En `discovery-verdict-schema/SKILL.md`: especificar que `revisions` se incrementa en cada re-ejecución del synthesizer.

---

### IMP-08 — Timestamps placeholders en lugar de timestamps reales — IMPLEMENTADO ✓

**Prioridad:** MENOR
**Detectado en:** Prueba test_discovery — Sesión 9 (2026-05-28)
**Archivos afectados:** `discovery-governor.md` (todas las escrituras a `claude-progress.txt`, `harness-state.json`, `execution-state.json`)

**Problema:**
Los timestamps escritos por el governor son valores placeholder fijos (`00:00:00`, `03:00:00`, `04:00:00`) en lugar de timestamps reales del sistema. El schema define ISO 8601, pero el agente no genera el valor dinámicamente.

**Ajuste requerido:**
En `discovery-governor.md`, agregar instrucción explícita antes de cualquier escritura con timestamp: usar Bash para obtener el timestamp real:
```bash
# PowerShell (Windows)
(Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
```
El governor debe ejecutar este comando y sustituir el valor en cada escritura que requiera timestamp.

---

### IMP-09 — Governor cortocircuita el flujo escribiendo transcript directamente — IMPLEMENTADO ✓

**Prioridad:** SIGNIFICATIVA
**Detectado en:** Prueba test_discovery — Sesión 9 (2026-05-28)
**Archivos afectados:** `discovery-governor.md`

**Problema:**
Cuando el usuario responde una pregunta directamente al governor (fuera del flujo normal de AskUserQuestion del dialoguer), el governor intenta registrar la respuesta en el transcript por su cuenta en lugar de delegar a orchestrator → dialoguer. Esto viola la Single Writer Rule del transcript y la jerarquía A→B→Workers. El governor no debe nunca escribir en `/discovery/dialogue_transcript.md`.

**Causa raíz:**
El flujo normal es: dialoguer pregunta vía AskUserQuestion → usuario responde → dialoguer registra en transcript. Cuando hay una interrupción (Ctrl+C) y el usuario responde al re-invocar el governor, el governor recibe la respuesta fuera de contexto y la maneja él mismo.

**Ajuste requerido:**
1. En `discovery-governor.md`: agregar regla explícita — "El governor nunca escribe en `/discovery/dialogue_transcript.md`. Si recibe una respuesta del usuario que corresponde a una pregunta del dialoguer, debe re-spawear el orchestrator con contexto completo para que el dialoguer retome la sesión."
2. En `discovery-governor.md` Ritual E10-B: cuando `last_checkpoint: null` y hay transcript parcial, siempre re-spawear orchestrator sin intentar procesar respuestas directamente.

---

### IMP-10 — Primer spawn falla por permisos, causa re-spawn innecesario — IMPLEMENTADO ✓

**Prioridad:** SIGNIFICATIVA
**Detectado en:** Prueba test_discovery — Sesión 9 (2026-05-28)
**Archivos afectados:** `.claude/settings.json` del proyecto de prueba (archivo de deployment)

**Problema:**
El primer spawn del governor falló porque Claude Code no tenía permisos pre-autorizados para escribir archivos y ejecutar comandos en el directorio del proyecto. Esto causó que el governor principal re-spawnara al governor con un prompt diferente, duplicando tokens y creando un flujo anómalo.

**Ajuste requerido:**
Al desplegar el harness en un nuevo proyecto (copiar `.claude/`), incluir un `settings.json` con permisos pre-autorizados para las operaciones que los agentes necesitan:
```json
{
  "permissions": {
    "allow": [
      "Write(*)",
      "Read(*)",
      "Bash(git *)",
      "Bash(mkdir *)"
    ]
  }
}
```
Esto evita el ciclo de aprobación interactiva que interrumpe el flujo agéntico.

---

### IMP-11 — Archivos de persistencia en raíz del proyecto — IMPLEMENTADO ✓

**Prioridad:** SIGNIFICATIVA
**Detectado en:** Prueba test_discovery — Consideración C1 (2026-05-28)
**Archivos afectados:** Todos los agentes que referencian `harness-state.json`, `execution-state.json`, `claude-progress.txt` (6 agentes + 1 skill)

**Problema:**
Los tres archivos de persistencia (`harness-state.json`, `execution-state.json`, `claude-progress.txt`) viven en la raíz del proyecto junto con los archivos del proyecto real. Esto ensucia el directorio raíz y puede causar confusión al cliente. La carpeta `persistence/` los agruparía semánticamente.

**Ajuste requerido:**
1. Cambiar todos los paths en los 6 agentes: `harness-state.json` → `persistence/harness-state.json`, `execution-state.json` → `persistence/execution-state.json`, `claude-progress.txt` → `persistence/claude-progress.txt`.
2. En `discovery-governor.md` E10-A Paso 2: agregar `mkdir -p persistence` a la creación de carpetas.
3. En `discovery-state-schema/SKILL.md`: actualizar paths en todos los schemas.
4. En el commit final del governor: actualizar `git add` para incluir `persistence/`.

**Nota:** Es un cambio mecánico (search & replace de paths) pero afecta muchos archivos. Hacer en una sola sesión para no dejar inconsistencias.

---

### IMP-12 — Proyecto no tiene CLAUDE.md propio — IMPLEMENTADO ✓

**Prioridad:** SIGNIFICATIVA
**Detectado en:** Prueba test_discovery — Consideración C2 (2026-05-28)
**Archivos afectados:** Nuevo archivo a crear: `test_discovery/CLAUDE.md` (plantilla reutilizable)

**Problema:**
Cuando se despliega el harness en un nuevo proyecto, no hay CLAUDE.md que instruya a Claude Code cómo operar. El usuario debe saber qué frase escribir para iniciar o continuar el harness, lo cual es conocimiento implícito que no está documentado en el proyecto. También resuelve IMP-14 e IMP-15.

**Ajuste requerido:**
Crear plantilla `CLAUDE.md` del proyecto cliente con las siguientes instrucciones:
```markdown
## INICIO OBLIGATORIO DE SESIÓN

Al iniciar, verificar si existe `persistence/harness-state.json`:
- **No existe** → Este proyecto aún no tiene harness activo. Invocar `discovery-governor` para iniciar el 010 Discovery Harness.
- **Existe** → Hay un harness en progreso. Invocar `discovery-governor` para continuar desde el último checkpoint.

No esperar instrucción del usuario para hacer esta verificación. Hacerla automáticamente al arrancar.
```
Esta plantilla se copia como parte del deployment de `.claude/` a cada nuevo proyecto.

---

### IMP-13 — GitHub no se enlaza desde el inicio — PENDIENTE

**Prioridad:** MENOR
**Detectado en:** Prueba test_discovery — Consideración C3 (2026-05-28)
**Archivos afectados:** `discovery-governor.md` (E10-A Paso 4)

**Problema:**
El governor hace `git init` y registra una advertencia si no hay remote, pero no bloquea el flujo. Según E1 de la metodología, el remote de GitHub es requisito para garantizar trazabilidad (P8). La advertencia sin bloqueo hace que el riesgo sea invisible en la práctica.

**Decisión pendiente antes de implementar:**
- Opción A (bloqueo duro): Governor detiene el flujo hasta que el usuario configure el remote manualmente.
- Opción B (asistido): Governor intenta crear el repo con `gh repo create` si el CLI `gh` está disponible; si no, bloquea con instrucciones.
- Opción C (actual + warning): Mantener advertencia sin bloqueo (acepta el riesgo explícitamente).

**Decisión tomada (2026-05-28):** Opción C — mantener advertencia sin bloqueo. El ajuste se diferiere hasta que el usuario lo solicite explícitamente.

---

### IMP-14 — Frase de inicio del harness no es intuitiva — IMPLEMENTADO ✓ (por IMP-12)

**Prioridad:** MENOR
**Detectado en:** Prueba test_discovery — Consideración C4 (2026-05-28)
**Archivos afectados:** `CLAUDE.md` del proyecto cliente (IMP-12)

**Problema:**
El usuario debe escribir "Inicia el 010 Discovery Harness" para arrancar — es una frase técnica que asume conocimiento del sistema de harnesses. En un proyecto real, el cliente no debería necesitar saber que existe un "010 Discovery Harness".

**Ajuste requerido:**
Resuelto por IMP-12: el CLAUDE.md del proyecto cliente instruye a Claude Code a detectar y arrancar el harness automáticamente al iniciar sesión, sin que el usuario deba escribir nada especial.

---

### IMP-15 — Frase de reanudación idéntica a la de inicio — IMPLEMENTADO ✓ (por IMP-12)

**Prioridad:** MENOR
**Detectado en:** Prueba test_discovery — Consideración C5 (2026-05-28)
**Archivos afectados:** `CLAUDE.md` del proyecto cliente (IMP-12)

**Problema:**
Después de un corte abrupto, el usuario reanudó escribiendo el mismo mensaje que usó para iniciar. No es intuitivo. Un usuario real escribiría "continúa" o simplemente abriría el proyecto esperando que retome solo.

**Ajuste requerido:**
Resuelto por IMP-12: el CLAUDE.md del proyecto cliente instruye a Claude Code a verificar `persistence/harness-state.json` al arrancar y a entrar automáticamente en modo CONTINUACIÓN si ya existe. El usuario no necesita escribir nada para reanudar.

---

### IMP-16 — Mentalidad del evaluador: sesgo negativo produce rechazos falsos — IMPLEMENTADO ✓

**Prioridad:** SIGNIFICATIVA
**Detectado en:** Revisión pre-segunda-prueba — Sesión 12 (2026-05-28)
**Archivos afectados:** `discovery-evaluator.md`

**Problema:**
La descripción original del evaluador no define explícitamente cómo debe razonar antes de asignar un score. Esto produce dos fallos opuestos: (a) evaluador laxo que aprueba sin cuestionar, o (b) evaluador sesgado negativamente que rechaza trabajo válido. Un evaluador con "tendencia negativa" genera rechazos falsos, dispara rework innecesario y consume tokens del ciclo de protocolo de rechazo sin justificación en la evidencia.

**Ajuste requerido:**
Reemplazar la mentalidad implícita con un protocolo de dos fases obligatorio:
1. **Fase de Análisis (primero):** Para cada dimensión, listar pros (evidencia de cumplimiento en el artefacto) y contras/gaps (evidencia de incumplimiento o ausencia). Cada ítem debe citar el artefacto y la sección concreta. No se puede declarar "hay un gap" sin citarlo, ni "está bien" sin evidencia.
2. **Fase de Score (después):** Solo tras completar el análisis, asignar score usando las anclas de calibración. El score debe ser *consistente* con la evidencia listada — ni más alto (laxo) ni más bajo (sesgado).

**Regla de oro:** El evaluador no otorga beneficio de la duda, pero tampoco penaliza sin evidencia. El score refleja lo que *hay* en los artefactos, no lo que *podría faltar*.

---

### Ajuste 1002 — Protocolo de Hot-Swapping por Matriz de Estado

#### 1. Ficha del Componente
* **Componente ejecutor:** Orquestador Base Físico (Script en Python/Go) aplicando las políticas lógicas del 060_isolation_harness.md.
* **Propósito:** Automatizar la limpieza radical del entorno activo de Claude Code (.claude/) e inyectar quirúrgicamente solo los componentes necesarios para la fase actual, calculando el stack técnico y el dominio si se está en fase de ejecución.

#### 2. Mecanismo de Control de Estado (harness-state.json)
El archivo de persistencia en la raíz del proyecto en desarrollo proveerá las variables necesarias para calcular la matriz de inyección en tiempo de ejecución:
{
  "project_name": "sistema-valores-bancarios",
  "current_harness": "070_execution",
  "status": "IN_PROGRESS",
  "meta_attributes": {
    "business_domain": "financial-precision-math",
    "tech_stack": "backend-go-clean-arch"
  }
}

#### 3. Protocolo Operativo Secuencial (Startup & Transition Ritual)
Cada vez que el usuario invoque los comandos interactivos en la CLI ("Iniciamos el proyecto", "Continuamos con el proyecto") o cuando ocurra una transición automática entre arneses, el Orquestador detendrá temporalmente el acceso a la IA y ejecutará en milisegundos las siguientes tres fases:

##### Paso 3.1: Purga del Entorno Activo (The Wipe)
Para garantizar la política de Contexto Estricto (Strict Context), el script borra de manera recursiva todo el almacenamiento temporal del proyecto:

* **Acción técnica:** Ejecutar un borrado total sobre las rutas locales: .claude/agents/* y .claude/skills/*. El espacio de configuración operativa queda en cero.

##### Paso 3.2: Resolución de la Matriz de Intersección
El orquestador lee los valores del harness-state.json del proyecto y realiza una búsqueda de coincidencia (match) de tres ejes sobre el Banco Central de Assets:

* **Eje de Fase (Agente):** Clona el o los archivos de agentes indicados para el current_harness actual (ej. w-coder.md).

* **Eje Core (Metodología):** Lee las required_core_skills definidas en el YAML del agente y clona esas habilidades base (ej. tdd-loop-discipline.md).

* **Eje de Construcción Dinámica (Stack & Negocio):** Si y solo si el current_harness pertenece a una fase de construcción (como 070_execution_harness), el orquestador extrae los tokens de meta_attributes.tech_stack y meta_attributes.business_domain para copiar únicamente las habilidades técnicas y de negocio asociadas a esas llaves específicas.

##### Paso 3.3: Hot-Swapping (Inyección Física)
El orquestador copia físicamente los archivos Markdown resueltos en el paso anterior hacia los directorios locales efímeros del workspace: .claude/agents/ y .claude/skills/.

#### 4. Inicialización de la CLI Segura
Una vez concluido el proceso de inyección en caliente, el Orquestador levanta la CLI de Claude Code. Para asegurar el aislamiento total, restringe el espacio visible de trabajo (Filtered Workspace View) exponiendo únicamente las carpetas de artefactos de entrada o de lectura correspondientes a la tarea (ej: la carpeta /specification o /design), bloqueando de forma física cualquier posibilidad de sobrecosto por tokens o alucinaciones cruzadas.

---

### IMP-20 — Governor salta Auditoría y cierra fase directamente tras CP-04 — IMPLEMENTADO ✓

**Prioridad:** CRÍTICA
**Detectado en:** Tercera prueba test_discovery_003 — Sesión 12 (2026-05-28)
**Archivos afectados:** `discovery-governor.md` (sección "Cierre")

**Problema:**
Tras recibir la aprobación CP-04, el governor fue re-spawneado con el prompt "Close Discovery Harness". Al entrar directamente a la sección "Cierre", saltó la sección "Auditoría" — nunca spawneó `discovery-evaluator`. La carpeta `eval/` quedó vacía: sin `verdict.json` ni `metrics_summary.json`. La fase se marcó `PHASE_COMPLETE` sin haber pasado por el gate de calidad.

**Ajuste requerido:**
En `discovery-governor.md` sección "Cierre": agregar PRECONDICIÓN al inicio — verificar que existe `/eval/verdict.json`. Si no existe, ejecutar la sección "Auditoría" completa antes de continuar. Esta verificación actúa como red de seguridad ante cualquier path de entrada al cierre que haya omitido la auditoría.

---

### IMP-21 — Orchestrator escribe timestamps placeholder — IMPLEMENTADO ✓

**Prioridad:** MENOR
**Detectado en:** Tercera prueba test_discovery_003 — Sesión 12 (2026-05-28)
**Archivos afectados:** `discovery-orchestrator.md`

**Problema:**
Los timestamps de CP-01 (`21:00:00Z`), CP-02 (`22:00:00Z`) y CP-03 (`23:00:00Z`) registrados en `claude-progress.txt` son valores placeholder con horas redondas. IMP-08 corrigió el governor pero no el orchestrator, que también escribe en `claude-progress.txt` al registrar checkpoints.

**Ajuste requerido:**
En `discovery-orchestrator.md`: agregar sección "Timestamps reales" al inicio (igual que IMP-08 en governor) con el comando `(Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")` y la instrucción de sustituir todo placeholder con el valor real.

---

### IMP-19 — Orchestrator escribe en /discovery/ directamente en lugar de spawnear Workers — IMPLEMENTADO ✓

**Prioridad:** CRÍTICA
**Detectado en:** Segunda prueba test_discovery_002 — Sesión 12 (2026-05-28)
**Archivos afectados:** `discovery-orchestrator.md`

**Problema:**
El orchestrator tiene el tool `Write` disponible. Al procesar sus instrucciones ("Spawear discovery-dialoguer"), el modelo tomó el camino corto y escribió `dialogue_transcript.md`, `analysis_report.md` y los 4 artefactos finales directamente, sin invocar ningún Worker via `Agent`. El resultado: ningún worker se ejecutó, no hubo interacción con el usuario, y los artefactos fueron generados sin entrevista socrática real.

**Causa raíz:**
Las instrucciones decían "Spawear discovery-dialoguer" pero no prohibían explícitamente escribir en `/discovery/` directamente. El modelo tiene acceso al tool `Write` y lo usó.

**Ajuste requerido:**
1. Agregar sección "REGLAS DE ESCRITURA" al inicio del agente: lista explícita de qué puede escribir (solo `persistence/execution-state.json`) y qué NUNCA puede escribir directamente (todo en `/discovery/`). Mensaje de DETENTE si tiene la tentación.
2. En cada Worker de la sección "Coordinación de Workers": cambiar "Spawear X" por "Invocar X usando el tool `Agent`", con prompt mínimo de ejemplo y aclaración de que el worker escribe sus propios archivos.

---

### IMP-17 — No existe script de deployment para copiar harness a proyecto cliente — IMPLEMENTADO ✓

**Prioridad:** SIGNIFICATIVA
**Detectado en:** Segunda prueba test_discovery_002 — Sesión 12 (2026-05-28)
**Archivos afectados:** Nuevo archivo a crear: `deploy-harness.ps1` (script PowerShell)

**Problema:**
No existe mecanismo para copiar el harness a un nuevo proyecto cliente. El deployment se hace manualmente, lo que es propenso a errores (olvidar `settings.json`, olvidar `CLAUDE.md`, copiar versiones desactualizadas). Sin `CLAUDE.md` en el proyecto destino, la detección automática de modo INICIO/CONTINUACIÓN no funciona en sesiones subsecuentes.

**Decisión:** Opción B — script de deployment explícito. El governor no gestiona el deployment; un script PowerShell lo hace una vez antes de arrancar el harness.

**Decisión adicional (Sesión 14, 2026-05-28) — Hot-swap entre harnesses:**
Al transicionar de un harness al siguiente (ej. 010 → 020), los agentes y skills del harness anterior deben ser **reemplazados**, no acumulados. Cada harness carga solo sus propios agentes/skills en `.claude/`. Los artefactos producidos (ej. `discovery/`) permanecen en el proyecto como inputs del siguiente harness, pero los agentes que los produjeron ya no son necesarios y solo inflan el contexto. Si se requiere volver a un harness anterior (rechazo estratégico), se re-ejecuta el script de deployment.

**Ajuste requerido:**
Crear `deploy-harness.ps1` en la raíz de `Harness_Definition` que:
1. Reciba como parámetros: `-Harness` (ej. `010`, `020`) y `-Destino` (path del proyecto cliente).
2. **Limpie** `.claude/agents/` y `.claude/skills/` en el destino antes de copiar (hot-swap, no acumulación).
3. Cree las carpetas `.claude/agents/` y `.claude/skills/` si no existen.
4. Copie solo los agentes del harness indicado (ej. `010` → 6 agentes de discovery).
5. Copie solo las skills del harness indicado (ej. `010` → 7 skills de discovery).
6. Copie `templates/client-project-settings.json` como `.claude/settings.json` (solo en primer deployment — no sobreescribir si ya existe).
7. Copie `templates/client-project-CLAUDE.md` como `CLAUDE.md` (solo en primer deployment).
8. Confirme al usuario qué se copió, qué se limpió y cuál es el siguiente paso.

---

### IMP-22 — Knowledge cross-project con PostgreSQL + pgvector — DISEÑADO — PENDIENTE IMPL.

**Prioridad:** SIGNIFICATIVA
**Detectado en:** Sesión 14 (2026-05-28)
**Archivos afectados:** `discovery-governor.md` (cierre), `deploy-harness.ps1` (IMP-17), nuevo esquema PostgreSQL

**Problema:**
El `knowledge/` es local a cada proyecto. Al iniciar un proyecto nuevo, el banco de lecciones aprendidas y decisiones tomadas arranca vacío — el aprendizaje acumulado de proyectos anteriores se pierde. A medida que el banco crece, cargarlo completo al contexto se vuelve costoso e impreciso (degradación por acumulación).

**Arquitectura objetivo (dos fases):**

**Fase 1 — Persistencia dual (corto plazo):**
- Al cerrar cada proyecto, el governor escribe en dos destinos simultáneamente:
  1. `knowledge/lessons_learned.md` y `knowledge/decisions_library.md` locales (operativo actual — sin cambio)
  2. PostgreSQL local — tablas `lessons_learned` y `decisions_library` con campos estructurados
- El deploy script (IMP-17) siembra el `knowledge/` del nuevo proyecto copiando el banco global de `Harness_Definition/knowledge/`
- Sin búsqueda aún — solo acumulación estructurada

**Fase 2 — Búsqueda semántica con pgvector (mediano plazo):**
- PostgreSQL + extensión `pgvector` para almacenar embeddings de cada entrada
- Al iniciar un proyecto, el governor consulta la DB con el brief como query y recupera las N entradas más relevantes (búsqueda semántica, no keyword)
- Solo esas N entradas se cargan al contexto — contexto controlado y preciso independientemente del volumen total del banco

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
PostgreSQL debe estar corriendo localmente. Para uso interno del equipo es manejable. Para deployment en cliente requiere evaluación caso a caso.

**Prerequisitos antes de implementar:**
- IMP-17 (deploy script) implementado
- Al menos 3-5 proyectos completados para tener volumen suficiente que justifique la búsqueda
- Decidir schema de tablas y estrategia de embeddings (OpenAI, local, etc.)

---

### IMP-23 — discovery-analyst no escribe analysis_report.md — IMPLEMENTADO ✓

**Prioridad:** CRÍTICA
**Detectado en:** Cuarta prueba test_discovery_004 — Sesión 14 (2026-05-28)
**Archivos afectados:** `discovery-analyst.md`, `discovery-synthesizer.md`, `discovery-evaluator.md`

**Problema:**
El discovery-analyst corrió (evidenciado por preguntas PA-xx y ronda de aclaración en el transcript), pero `discovery/analysis_report.md` nunca fue creado. Las instrucciones del agente dicen escribirlo en ambas ramas (issues encontrados y análisis limpio), pero el agente reportó a B sin ejecutar el Write. El discovery-synthesizer produjo los 4 artefactos de todas formas, probablemente leyendo el transcript directamente.

**Ajuste requerido:**
1. `discovery-analyst.md`: agregar sección "Postcondición obligatoria" antes de "Al terminar" — verificar que `discovery/analysis_report.md` existe en disco antes de reportar a B. Si no existe, escribirlo antes de continuar.
2. `discovery-synthesizer.md`: agregar Paso 0 al inicio de "Al iniciar" — verificar que `discovery/analysis_report.md` existe. Si no existe, detener y reportar a B con error explícito.
3. `discovery-evaluator.md`: extender Paso 1 para incluir `analysis_report.md` en la verificación. Si no existe, registrar advertencia en `findings` de `verdict.json` y penalizar D3.

---

### IMP-24 — Orchestrator no actualiza execution-state.json con checkpoints — IMPLEMENTADO ✓

**Prioridad:** SIGNIFICATIVA
**Detectado en:** Cuarta prueba test_discovery_004 — Sesión 14 (2026-05-28)
**Archivos afectados:** `discovery-orchestrator.md`

**Problema:**
Al finalizar la prueba, `execution-state.json` quedó con `last_checkpoint: null` y `status: IN_PROGRESS` — el estado inicial. Los 3 workers corrieron exitosamente (transcript completo, ronda de aclaración, 4 artefactos), pero el orchestrator nunca escribió CP-01, CP-02 ni CP-03 entre spawns. Sin estos checkpoints, la reanudación E10-B no puede determinar desde qué worker continuar.

**Causa raíz:**
Las instrucciones mostraban JSON parcial para "registrar" el checkpoint sin explicitar que se debe leer el archivo existente, mergear los campos nuevos y reescribir el archivo completo. No había verificación posterior ni bloqueo explícito para continuar sin confirmar la escritura.

**Ajuste requerido (implementado):**
En `discovery-orchestrator.md`, cada bloque post-Worker reemplazado con protocolo de 5 pasos: (1) leer execution-state.json, (2) actualizar campos manteniendo los existentes, (3) escribir archivo completo, (4) leer de nuevo para verificar, (5) bloqueo duro — no continuar al siguiente Worker si la verificación falla.

---

### IMP-25 — Evaluator aprueba con score 1.0 sin analysis_report.md — IMPLEMENTADO ✓

**Prioridad:** MENOR
**Detectado en:** Cuarta prueba test_discovery_004 — Sesión 14 (2026-05-28)
**Archivos afectados:** `discovery-evaluator.md`

**Problema:**
El evaluator otorgó 1.0 en las 5 dimensiones (incluyendo D3 — resolución de contradicciones) sin tener `analysis_report.md` disponible. No detectó la ausencia del paso de análisis ni lo reflejó como un indicador de riesgo en el veredicto.

**Ajuste requerido:**
En IMP-23 (ya implementado): extender Paso 1 del evaluator para incluir `analysis_report.md` en la verificación. Si no existe, registrar en `findings` como advertencia y penalizar D3 con un contra explícito.

---

### IMP-27 — discovery-analyst retorna sin escribir analysis_report.md — IMPLEMENTADO ✓

**Prioridad:** CRÍTICA
**Detectado en:** Quinta prueba test_discovery_005 — Sesión 14 (2026-05-28)
**Archivos afectados:** `discovery-analyst.md`, `discovery-orchestrator.md`

**Problema:**
El analyst completa el análisis en su contexto y retorna "listo para síntesis" al orchestrator sin ejecutar el tool Write. La postcondición de IMP-23 tampoco se ejecuta porque el agente toma el camino "análisis completo → retornar" sin pasar por la verificación al final. El orchestrator registra CP-02 aceptando el reporte verbal sin verificar que el archivo existe en disco.

**Causa raíz:**
Escribir el archivo era un paso condicional al final del flujo. El agente omite todo lo que aparece después de tomar la decisión "listo para síntesis / issues encontrados".

**Ajuste requerido (implementado):**
1. `discovery-analyst.md`: Reestructurado el flujo — la escritura de `discovery/analysis_report.md` es ahora el **Paso 3 obligatorio**, ejecutado inmediatamente después del análisis y **antes** de evaluar issues. El Write es el primer tool call tras el análisis, sin excepción. La evaluación de issues (Paso 4) opera sobre el archivo ya escrito.
2. `discovery-orchestrator.md`: Verificación previa antes de registrar CP-02 — leer `discovery/analysis_report.md`. Si no existe, tratar como fallo del Worker y no avanzar al synthesizer.

---

### IMP-26 — Orchestrator persiste inputs como null en orchestration_plan — IMPLEMENTADO ✓

**Prioridad:** MENOR
**Detectado en:** Quinta prueba test_discovery_005 — Sesión 14 (2026-05-28)
**Archivos afectados:** `discovery-orchestrator.md` (Paso 4)

**Problema:**
El Paso 4 del orchestrator usa placeholders literales (`"<path o descripción del brief inicial>"`) en el template del `orchestration_plan`. En la práctica, el agente escribe `null` para todos los inputs porque no tiene instrucción de verificar cuáles archivos existen. Esto deja el estado de persistencia incompleto — si hubiera una reanudación desde CP-01, el orchestrator no sabría dónde está el brief, y el prompt al dialoguer recibiría `null` en lugar del path real.

**Ajuste requerido (implementado):**
En `discovery-orchestrator.md` Paso 4: antes de escribir el `orchestration_plan`, intentar leer cada archivo de input (`inputs/brief.md`, `inputs/business_context.md`, `inputs/constraints.md`). Si existe → I1/I2/I3 = path real; si no existe → null. Persistir los valores reales resueltos.

---

### IMP-28 — Dashboard HTML en tiempo real para observar el progreso del harness — PENDIENTE

**Prioridad:** MENOR
**Detectado en:** Sesión 14 (2026-05-28)
**Archivos afectados:** Nuevo archivo `dashboard.html` en `templates/`; instrucción en `deploy-harness.ps1` (IMP-17) para copiarlo al proyecto cliente

**Problema:**
El humano no tiene visibilidad en tiempo real de lo que cada agente está haciendo durante la ejecución del harness. Para entender el progreso hay que leer archivos de texto manualmente o esperar a que el governor haga preguntas.

**Solución:**
Un `dashboard.html` que el usuario abre una vez en el navegador y se actualiza automáticamente sin necesidad de F5.

**Arquitectura:**
- `dashboard.html` en la raíz del proyecto cliente (copiado por `deploy-harness.ps1`)
- JavaScript con `setInterval` cada 3 segundos hace `fetch()` a los archivos de estado
- Requiere servidor HTTP local mínimo — un solo comando al inicio:
  ```powershell
  python -m http.server 8080
  # Luego abrir http://localhost:8080/dashboard.html
  ```
- Los agentes no cambian — el dashboard lee los archivos que ya existen

**Contenido del dashboard:**
- **Timeline** — eventos de `persistence/claude-progress.txt` como línea de tiempo visual
- **Estado actual** — harness activo, modo (INICIO/CONTINUACIÓN), status desde `persistence/harness-state.json`
- **Checkpoints** — CP-01 a CP-04 con indicador visual (pendiente / alcanzado) desde `persistence/execution-state.json`
- **Agente activo** — inferido del último evento en `claude-progress.txt`
- **Artefactos producidos** — lista de archivos en `discovery/` y `eval/` con indicador de existencia

**Prerequisitos:**
- IMP-17 (deploy script) implementado — el dashboard se copia junto con `.claude/`
- Python disponible en la máquina del usuario (para el servidor HTTP)

---

### IMP-18 — Sprint Contract no incluye checkpoints canónicos ni Criterio de Done — IMPLEMENTADO ✓

**Prioridad:** MENOR
**Detectado en:** Segunda prueba test_discovery_002 — Sesión 12 (2026-05-28)
**Archivos afectados:** `discovery-governor.md` (sección "Reporte al humano y gate del Sprint Contract")

**Problema:**
El Sprint Contract propuesto por el governor en la prueba no incluyó los checkpoints canónicos ni el Criterio de Done. Sin estos elementos, el cliente aprueba un contrato incompleto.

**Ajuste implementado (Sesion 15, 2026-05-28):**
En `discovery-governor.md` seccion "Reporte al humano y gate del Sprint Contract": la descripcion prosaica de los elementos a incluir fue reemplazada por un template concreto que el governor rellena con los datos reales. El template incluye obligatoriamente:
- Seccion "Checkpoints": CP-01 a CP-04 con descripcion de condicion de registro
- Seccion "Criterio de Done": las 4 condiciones exactas del `010_discovery_harness.md`

---

### IMP-29 — Dialoguer retorna a B tras identificar stakeholders sin completar la entrevista — IMPLEMENTADO ✓

**Prioridad:** CRITICA
**Detectado en:** Prueba test_discovery_006 — Sesion 17 (2026-05-28)
**Archivos afectados:** `discovery-dialoguer.md`, `discovery-orchestrator.md`

**Problema:**
El dialoguer conduce Ronda 1 (quien eres) y Ronda 2 (hay otros stakeholders), escribe ambas en el transcript, y luego retorna a B sin haber hecho ninguna pregunta de contenido sobre el proyecto. Las preguntas de fondo (registro de gastos, categorias, criterio de exito) se siguen haciendo pero las respuestas llegan al governor en lugar del dialoguer — el governor las recibe "fuera del flujo normal", dispara CONTEXT_RESET, re-spawna el orchestrator, que re-spawna el dialoguer, que vuelve a empezar desde Ronda 3... loop infinito con `last_checkpoint: null`.

**Causa raiz:**
Dos fallas independientes que se combinan:
1. El dialoguer no tenia regla explicita que le impidiera retornar antes de tener `Estado global: COMPLETO` en el transcript. Las Fases 1 (identificacion de stakeholders) y 2 (entrevista) se ejecutan en la misma sesion segun las instrucciones, pero el modelo puede interpretar el fin de Fase 1 como un punto de retorno valido.
2. El orchestrator no verificaba el estado del transcript tras el retorno del dialoguer — aceptaba cualquier retorno con path como exitoso, sin comprobar si la entrevista estaba realmente completa. Si el transcript no dice COMPLETO, debe re-spawnar al dialoguer en modo continuacion.

**Ajuste implementado:**

`discovery-dialoguer.md`:
- Nueva seccion "REGLA DE SESION UNICA" al inicio: el dialoguer NO retorna a B hasta que el transcript diga `Estado global: COMPLETO`. Las Fases 1, 2 y 3 del protocolo se ejecutan sin interrupcion en una sola sesion. No hay puntos de retorno intermedios.
- Regla adicional: no emitir texto de respuesta a B hasta tener COMPLETO — cualquier salida de texto antes de ese momento puede causar que el orchestrator interprete la sesion como terminada.

`discovery-orchestrator.md`:
- Tras el retorno del dialoguer, verificacion obligatoria: leer el transcript y buscar `Estado global: COMPLETO`. Si no esta COMPLETO, re-spawnar al dialoguer (el transcript existente le sirve de contexto para continuar). Maximo 5 re-intentos antes de declarar WORKER_FAILED.
- Solo si el transcript esta COMPLETO se procede a escribir CP-01.

---

### IMP-31 — verdict.json y metrics_summary.json en path incorrecto — IMPLEMENTADO ✓

**Prioridad:** MENOR
**Detectado en:** Revisión post-prueba test_discovery_006 — Sesión 19 (2026-05-28)
**Archivos afectados:** `discovery-evaluator.md`

**Problema:**
Los archivos `verdict.json` y `metrics_summary.json` terminaron en `discovery/` en lugar de `eval/`. El directorio `eval/` quedó vacío. El governor tiene en su PRECONDICIÓN de Cierre la verificación de `/eval/verdict.json` — si el evaluador hubiera colocado el archivo en el lugar correcto y el governor hubiera verificado correctamente, la prueba habría fallado en ese punto. En la práctica, el governor y la evaluación se completaron porque el LLM localizó el archivo dondequiera que estuviera, pero viola el contrato de paths del harness.

**Causa raíz:**
La instrucción decía `/eval/verdict.json` pero no hacía explícita la distinción respecto a `discovery/`. El evaluador acaba de leer todos los artefactos desde `discovery/` y el modelo infirió que el output va al mismo lugar.

**Ajuste implementado:**
`discovery-evaluator.md` — sección "Al terminar":
- Nuevo bloque **PATHS DE SALIDA — OBLIGATORIO** al inicio de la sección, antes de las instrucciones de escritura.
- Indica explícitamente: `eval/verdict.json` (NO `discovery/verdict.json`) y `eval/metrics_summary.json` (NO `discovery/metrics_summary.json`).
- Nota de contexto: los artefactos evaluados están en `discovery/`, los outputs de la evaluación van a `eval/` — son directorios distintos con propósitos distintos.
- Todas las referencias a paths de output en la sección actualizadas de `/eval/...` a `eval/...` (sin slash inicial para evitar interpretación de ruta absoluta).

---

### IMP-29 — Segunda ronda de fixes (Sesión 19) — COMPLEMENTARIO

**Detectado en:** Análisis de claude-progress.txt de test_discovery_006
**Archivos afectados:** `discovery-dialoguer.md`, `discovery-governor.md`, `discovery-orchestrator.md`

**Problema adicional (post IMP-29 inicial):**
La primera ronda de fixes (Sesión 17) añadió la REGLA DE SESION UNICA con restricción negativa ("no emitas texto"). El test_discovery_006 mostró que el dialoguer sigue saliendo entre rondas (10+ eventos RESPUESTA_EXTERNA en el log). Análisis de causa: (1) la restricción negativa no guía al modelo sobre qué hacer en lugar de emitir texto; (2) el paso "Notificar a B" en el cierre de cada stakeholder crea un retorno implícito; (3) el governor no tiene protocolo formal para RESPUESTA_EXTERNA — lo maneja ad-hoc.

**Ajustes adicionales implementados:**

`discovery-dialoguer.md`:
- REGLA DE SESION UNICA: restricción negativa reemplazada por instrucción positiva — el ciclo correcto es `Write(transcript) → AskUserQuestion(N+1) → recibir respuesta → Write(transcript) → ...`. Generar texto entre rondas termina la sesión. El único momento de generar texto es cuando el transcript dice `Estado global: COMPLETO`.
- "Al cerrar cada entrevista de stakeholder" Paso 5: eliminado "Notificar a B" (punto de retorno implícito). Reemplazado por: si quedan stakeholders, continuar directamente con el siguiente sin retornar; si era el último, verificar las 4 condiciones globales y decidir si ir a Fase 3 o continuar preguntas.

`discovery-governor.md`:
- Nueva subsección "Protocolo RESPUESTA_EXTERNA" dentro de "Ejecución Técnica": protocolo de 3 pasos — registrar en progress.txt, re-spawear orchestrator con la respuesta explícita entre triple comillas y la instrucción de que hay una respuesta pendiente, nunca escribir en el transcript directamente.

`discovery-orchestrator.md`:
- Prompt del Agent para el dialoguer: añadido bloque condicional para cuando el governor pase una RESPUESTA_EXTERNA — incluir la respuesta completa entre triple comillas e instrucción de registrarla como última ronda antes de continuar.

---

### IMP-30 — Dialoguer no verifica condiciones de Done después de cada ronda — IMPLEMENTADO ✓

**Prioridad:** SIGNIFICATIVA
**Detectado en:** Sesión 18 (2026-05-28) — análisis durante test_discovery_006
**Archivos afectados:** `discovery-dialoguer.md`

**Problema:**
El criterio de parada global (4 condiciones en el protocolo) solo se verificaba "al terminar todos los stakeholders", pero no había un mecanismo explícito de verificación post-ronda. El dialoguer podía continuar formulando preguntas de los bancos (A1-A4, C1-C3) más allá de lo necesario porque no tenía señal activa de "ya es suficiente". Riesgo concreto: nunca preguntar sobre comportamiento ante fallos (C4) si el banco no lo fuerza secuencialmente.

**Ajuste implementado:**

`discovery-dialoguer.md` — Ciclo de entrevistas, Paso 5 (nuevo):
- Después de escribir cada ronda, verificar explícitamente las 4 condiciones (C1-C4).
- Si todas se cumplen → ir directamente a Fase 3 (cierre) sin formular más preguntas.
- Si alguna no se cumple → identificar cuál falta y orientar la próxima pregunta a cubrirla. Priorizar C4 (comportamiento ante fallos) si está pendiente.
- Solo si las condiciones no se cumplen, formular la siguiente pregunta (Paso 6).


## CONSIDERACIONES PRUEBA TEST_DISCOVERY.
1. Los timestamps son placeholders (00:00:00,03:00:00) en lugar de timestamps reales del sistema. El governor los está escribiendo como valores fijos.
2. Prepare un script PowerShell que haga el deployment automático (crear carpeta + copiar todos los archivos correctos)
3. Preguntas de negocio, tecnicas o de usuario final se realizan, se identifican los diferentes stakeholders y se pregunta a ellos.
4. Ajustar el arness 040 planning para que trabaje bajo vertical slices. Se deberan planear minimo tres vertical slices que se llamaran iteraciones. La primera iteracion sera la tracer bullet, Otra iteracion sera la del MVP y otra iteracion sera la de robustez. Entre la iteracion de tracer bullet y la iteracion del mvp podrian existir una o varias iteraciones intermedias que agregaran mas caracteristicas, solucionaran errores encontrados o eliminan deuda tecnica si existe. Entre la iteracion del MVP y la de robustez, pueden existir una o varias iteraciones intermedias que agreguen mas funcionalidades, solucionaran errores encontrados o eliminan deuda tecnica si existe hasta llegar a la iteracion de robustez. 
5. Ajustar el arness 050 iteration. Este harness se llamara 050 Vertical Harness. Este solo realizará trabajo en la definicion de la iteracion o vertical slice que se encuentra definida en el arness 040 planning. El trabajo en este arness tambien podria trabajar en solucionar errores encontrados o en la eliminacion de deuda tecnica dejada por la iteracion anterior. Este arnes construye los documentos: Proposal el cual contiene el objetivo de este vertical/Iteracion, con la informacion suficiente para qu un humano y un agente de IA comprenda lo incluido, lo no incluido, las features que se espera construir, el documento de diseño de software SDS que especifica la arquitectura, las interfaces y los contratos de las clases y funciones, el documento SDD con la especificacion tecnica de lo que se espera construir, el documento testing_plan con el plan de pruebas que se debe realizar para asegurar la calidad de la aplicacion y el plan de ejecucion de la iteracion basada en feature - Tickets - Tasks.  Es importante que el plan de ejecucion este construido bajo metodologia TDD (red, green, refactor).  
6. El harness 070 isolation se ejecutará exclusivamente basado en la vertical slice / Iteracion activa.
7. El harnesss 080 execution harness se llamara 080 development harness y se encargara de la implementacion de la iteracion activa, construyendo el codigo basado en 050 verical harness. 
8. Construir el archivo README.md del proyecto, incluirlo en el script 001, este es un archivo que dice como se debe ejecutar lso diferentes harnesses para obtener los resultdos del proyecto.