---
name: planning-writer-protocol
description: Protocolo de producción del planning-writer en el 040 Planning Harness. Define las reglas de transformación de planning_analysis_report a los 3 artefactos finales, el orden obligatorio de producción y el self-checklist cruzado. Usar cuando planning-writer produce los artefactos o verifica su consistencia antes de reportar.
user-invocable: false
agent: planning-writer
---

## Regla de no-inferencia (absoluta)

No generar slices, IC-xx, BDD scenarios, dependencias ni riesgos que no estén presentes en
`planning_analysis_report.md`. Si la información es ambigua o falta, registrar con
`[PENDIENTE: descripción]`, no inventar completitud de planificación.

Excepción controlada: si el analysis_report tiene una asignación de IC-xx huérfanos o BDD
scenarios huérfanos, esa asignación es la fuente de verdad — incorporarla en los artefactos
aunque no estuviera en el draft original del 030.

---

## Orden de producción obligatorio

Producir siempre en este orden. No alterar la secuencia.

1. `vertical_slice_plan.md` — primero. Define las slices formalmente; sin este artefacto,
   el roadmap y el risk register no tienen VS-xx sobre qué iterar.
2. `project_roadmap.md` — segundo. Requiere las slices de `vertical_slice_plan.md` para
   secuenciar y calcular dependencias.
3. `risk_register.md` — tercero. Requiere la lista final de VS-xx del `vertical_slice_plan.md`
   para garantizar cobertura completa (≥1 RK-xx por VS-xx).

**El Write de cada artefacto es el primer tool call después de completar su producción.
Sin excepción. No pasar al siguiente artefacto antes de haber escrito el actual en disco. (LL-01)**

---

## Reglas de transformación por artefacto

### vertical_slice_plan.md — Formalizar la lista final de VS-xx con los 6 campos

**Fuente:** Secciones 1, 2, 3 y 4 del `planning_analysis_report.md`.
**Referencia directa:** `030_design/contract_definitions.md` (verificar IC-xx), `020_specification/bdd_features.md`
(verificar SC-xx/SE-xx), `010_discovery/domain_glossary.md` (lenguaje ubicuo).

La "lista final de VS-xx" es la lista del inventario (Sección 1) más las slices nuevas por división
(Sección 2), menos ninguna (no se fusionan ni eliminan slices del draft).

**6 campos obligatorios por slice (LL-24):**

1. **Nombre** — Derivar del nombre del draft del 030 si existe; si la slice es nueva por división,
   construir un nombre descriptivo usando términos del `domain_glossary.md`.

2. **Tipo** — Exactamente uno de: `Tracer Bullet`, `Crecimiento`, `MVP`, `Evolución`, `Robustez`.
   Para slices nuevas por división, el tipo se toma de la Sección 2 del analysis_report.

3. **IC-xx asignados** — Tomar de la Sección 3 del analysis_report (incluyendo los IC-xx huérfanos
   ya asignados). Verificar que cada IC-xx referenciado existe en `contract_definitions.md`.
   Al menos 1 IC-xx por slice — si el analysis_report no asignó ninguno a una slice,
   marcarlo como `[PENDIENTE: IC-xx huérfano no resuelto]` y registrar en el análisis.

4. **BDD Scenarios asignados** — Tomar de la Sección 4 del analysis_report (incluyendo los huérfanos
   ya asignados). Verificar que cada SC-xx/SE-xx referenciado existe en `bdd_features.md`.
   Al menos 1 scenario por slice.

5. **Criterio de Done** — Construir condiciones verificables con referencias explícitas a IC-xx y
   SC-xx/SE-xx. Reglas de redacción:
   - Cada condición de Done menciona ≥1 IC-xx específica con su nombre (ej. IC-03 — IStockRepository).
   - Cada condición de Done menciona ≥1 SC-xx o SE-xx específico que esa condición respalda.
   - No escribir condiciones genéricas como "la funcionalidad está implementada" o "los tests pasan".
   - Incluir condición de test: qué tipo (unitario / integración) y contra qué IC-xx.

6. **Estimación de esfuerzo** — Una de: `XS`, `S`, `M`, `L`, `XL`. Derivar con estos factores:
   - Número de IC-xx nuevas en la slice (de Sección 2 del analysis_report).
   - Complejidad tecnológica del stack (del ADR-001 en `architecture_decision_records.md`).
   - Presencia de dependencias externas o IC-xx de tipo Notifier/API.
   Documentar la justificación en el campo "Justificación del esfuerzo".

**Regla de campo Estado:**
Siempre escribir `Estado: DRAFT`. El governor edita este campo a `APROBADO POR CLIENTE` tras CP-04.
El writer nunca escribe el valor `APROBADO POR CLIENTE` — esto es responsabilidad exclusiva del governor. (LL-17)

---

### project_roadmap.md — Transformar dependencias y secuencia en roadmap formal

**Fuente:** Sección 5 del `planning_analysis_report.md` (dependencias entre slices).
**Referencia directa:** `vertical_slice_plan.md` (slices ya producido), `030_design/dependency_graph.md` (DEP-xx de respaldo).

**Secuencia de implementación:**
- La posición de cada VS-xx en la tabla sigue este orden de tipo obligatorio:
  Tracer Bullet (1) → Crecimiento (0..N, en cualquier orden interno respetando sus deps) →
  MVP (1) → Evolución (0..M, ídem) → Robustez (1).
- Dentro de cada grupo de tipo, respetar las dependencias VS-xx → VS-xx de la Sección 5 del analysis_report.
- Si una dependencia obliga a un orden que viola la estructura de tipos (ej. una slice de Crecimiento
  que depende de una de MVP), documentar el conflicto con `[CONFLICTO DE ORDEN: descripción]` y no
  resolverlo sin instrucción del governor.

**Dependencias entre slices:**
- Cada fila de dependencia VS-xx → VS-xx debe referenciar el DEP-xx de `dependency_graph.md` que la origina.
- Si hay dependencias del analysis_report sin DEP-xx de respaldo: marcar como `[DEP-xx: no identificado en dependency_graph.md]`.
- Incluir la sección de "Verificación de ausencia de ciclos" con resultado explícito.

**Hitos obligatorios:**
- Marcar con ★ exactamente 3 hitos: Tracer Bullet, MVP y Robustez.
- Cada hito documenta: definición de éxito, duración estimada (acumulada), IC-xx completadas y
  BDD Scenarios cubiertos al alcanzar ese hito.
- Los valores acumulados de IC-xx y BDD Scenarios en MVP y Robustez deben ser consistentes con
  las slices anteriores en el roadmap (no inventar IC-xx cubiertas).

**Regla de campo Estado:**
Siempre escribir `Estado: DRAFT`. El governor edita este campo tras CP-04.

---

### risk_register.md — Formalizar los riesgos preliminares del analysis_report

**Fuente:** Sección 6 del `planning_analysis_report.md` (RK-xx provisionales).
**Referencia directa:** `vertical_slice_plan.md` (lista final de VS-xx para garantizar cobertura).

**Formalización de riesgos:**
- Tomar cada RK-xx provisional del analysis_report y completar sus campos:
  - VS-xx afectada (verificar que coincide con una VS-xx del vertical_slice_plan)
  - Categoría (Técnica / Dependencia / Ambigüedad / Arquitectura)
  - Probabilidad (Alta / Media / Baja)
  - Impacto (Alto / Medio / Bajo)
  - Descripción concreta: qué puede salir mal, cuándo y por qué
  - Origen en los inputs: referencia a IC-xx, DEP-xx, ADR-xx o sección de input
  - Mitigación: ≥1 acción concreta (no genérica)
  - Indicador de materialización: señal observable que indica que el riesgo se activa

**Regla de cobertura — CRÍTICA:**
Antes de producir el risk_register, extraer la lista de VS-xx del `vertical_slice_plan.md`.
Verificar que hay ≥1 RK-xx por cada VS-xx. Si el analysis_report no identificó un riesgo para
alguna VS-xx, identificar el riesgo más relevante para esa slice usando los inputs disponibles.
No entregar el risk_register con VS-xx sin cobertura de riesgo.

**Regla de mitigaciones — CRÍTICA:**
Las siguientes frases NO son mitigaciones aceptables: "revisar el código", "hacer más testing",
"monitorear el riesgo", "consultar al equipo", "planificar con tiempo". Toda mitigación debe
citar una acción específica con referencias a IC-xx, slices o artefactos concretos.

Ejemplo aceptable: "Implementar stub de IC-05 (IAlertaRepository) en VS-01 para desacoplar
la integración real del servicio de alertas hasta VS-03."

**Numeración de RK-xx:**
- Conservar los IDs provisionales del analysis_report cuando sea posible.
- Si hay colisión de IDs (ej. dos riesgos con RK-03), reasignar secuencialmente y documentar
  la tabla de correspondencia en el resumen.

**Regla de campo Estado:**
Siempre escribir `Estado: DRAFT`. El governor edita este campo tras CP-04.

---

## Checklist de consistencia cruzada (aplicar antes del self-checklist del Demo Statement)

Esta verificación es previa al self-checklist. Si algún ítem falla, corregir con Edit antes
de pasar al self-checklist del Demo Statement.

### Consistencia analysis_report → artefactos finales

- [ ] Cada VS-xx de la lista final del analysis_report tiene una sección en `vertical_slice_plan.md`
- [ ] Cada IC-xx asignado en Sección 3 del analysis_report aparece en ≥1 slice de `vertical_slice_plan.md`
- [ ] Cada SC-xx/SE-xx asignado en Sección 4 del analysis_report aparece en ≥1 slice de `vertical_slice_plan.md`
- [ ] Cada dependencia de Sección 5 del analysis_report aparece en `project_roadmap.md`
- [ ] Cada RK-xx provisional de Sección 6 del analysis_report está formalizado en `risk_register.md`

### Consistencia entre artefactos finales

- [ ] Cada VS-xx de `vertical_slice_plan.md` aparece en la tabla de secuencia de `project_roadmap.md`
- [ ] Cada VS-xx de `vertical_slice_plan.md` tiene ≥1 RK-xx en `risk_register.md`
- [ ] La secuencia en `project_roadmap.md` respeta Tracer Bullet → MVP → Robustez (con Crecimiento antes del MVP y Evolución entre MVP y Robustez)
- [ ] Los 3 hitos obligatorios (★) están marcados en `project_roadmap.md`
- [ ] No hay dependencias circulares en `project_roadmap.md`
- [ ] Ningún IC-xx en `vertical_slice_plan.md` que no exista en `030_design/contract_definitions.md`
- [ ] Ningún SC-xx/SE-xx en `vertical_slice_plan.md` que no exista en `020_specification/bdd_features.md`
- [ ] Todos los RK-xx de `risk_register.md` referencian VS-xx que existen en `vertical_slice_plan.md`

### Consistencia de lenguaje (domain_glossary)

- [ ] Los nombres de slices, IC-xx y RK-xx usan términos del `010_discovery/domain_glossary.md`
- [ ] Si un término nuevo es necesario, marcarlo con `[GLOSARIO: pendiente — nombre]` donde aparece por primera vez

### Consistencia de Estado (LL-17)

- [ ] Los 3 artefactos tienen `Estado: DRAFT` (no `APROBADO POR CLIENTE`)

---

## Self-checklist del Demo Statement (ejecutar antes de reportar)

El governor pasa el Demo Statement al writer en el prompt de invocación. Antes de reportar
COMPLETED, verificar cada condición del Demo Statement contra los artefactos escritos en disco.

Demo Statement de referencia (del orchestration_plan):
> "Cuando planning-writer termine, podré observar que: `vertical_slice_plan.md` tiene una
> entrada VS-xx por cada slice (incluyendo las nuevas si se dividieron), cada una con los 6
> campos obligatorios (nombre, tipo, IC-xx, BDD scenarios, Criterio de Done, esfuerzo);
> `project_roadmap.md` lista todas las VS-xx en secuencia respetando la estructura
> TB→Crecimiento→MVP→Evolución→Robustez, con dependencias VS-xx → VS-xx explícitas y los
> 3 hitos obligatorios marcados; `risk_register.md` tiene ≥1 RK-xx por VS-xx con
> probabilidad, impacto y mitigación."

Verificación del self-checklist:

- [ ] `040_planning/vertical_slice_plan.md` existe en disco con contenido
- [ ] Todas las VS-xx de la lista final tienen sección con los 6 campos obligatorios
- [ ] Cada IC-xx referenciado existe en `030_design/contract_definitions.md`
- [ ] Cada SC-xx/SE-xx referenciado existe en `020_specification/bdd_features.md`
- [ ] `040_planning/project_roadmap.md` existe en disco con contenido
- [ ] Tabla de secuencia con posición, tipo, dependencias y duración por VS-xx
- [ ] Los 3 hitos obligatorios marcados con ★ (Tracer Bullet, MVP, Robustez)
- [ ] Sección de verificación de ausencia de ciclos con resultado explícito
- [ ] `040_planning/risk_register.md` existe en disco con contenido
- [ ] ≥1 RK-xx por cada VS-xx de `vertical_slice_plan.md`
- [ ] Cada RK-xx tiene probabilidad, impacto y mitigación concreta (no genérica)

Si alguna condición falla: corregir con Edit antes de reportar.
Si alguna condición falla por un gap bloqueante no resuelto: reportar `INCOMPLETO: <razón específica>`
al governor. No inventar una solución para desbloquear la condición.
