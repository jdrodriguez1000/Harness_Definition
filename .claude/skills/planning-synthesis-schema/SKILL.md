---
name: planning-synthesis-schema
description: Schema y formato de los 3 artefactos finales del 040 Planning Harness producidos por planning-writer. Usar cuando planning-writer escribe los artefactos o cuando planning-evaluator los lee para auditar.
user-invocable: false
agent: planning-writer
---

Los 3 artefactos deben escribirse en la carpeta `/plan/`. La carpeta ya existe (creada por el governor en E10-A).

**Orden de producción obligatorio:**

1. `vertical_slice_plan.md` — primero. Define las slices formalmente; es la fuente que alimenta roadmap y risk register.
2. `project_roadmap.md` — segundo. Requiere las slices del vertical_slice_plan para secuenciar y calcular dependencias.
3. `risk_register.md` — tercero. Requiere la lista final de VS-xx del vertical_slice_plan para garantizar cobertura completa.

Las IDs que planning-writer recibe desde `planning_analysis_report.md` y debe usar:
- `VS-xx` — slices del draft del 030 más las nuevas por división
- `IC-xx` — interfaces de `design/contract_definitions.md` ya asignadas a slices
- `SC-xx / SE-xx` — BDD scenarios de `specification/bdd_features.md` ya asignados a slices
- `DEP-xx` — dependencias de `design/dependency_graph.md` que imponen orden entre slices
- `RK-xx` — riesgos preliminares del planning_analysis_report (el writer los formaliza)

Las IDs que planning-writer asigna en los artefactos finales:
- `VS-xx` — conserva los del analysis_report; no reasigna ni renumera
- `RK-xx` — formaliza los provisionales del analysis_report; puede ajustar numeración si hay colisión

---

## Artefacto 1 — vertical_slice_plan.md

**Path:** `/plan/vertical_slice_plan.md`
**Producir primero.** Define las VS-xx formalmente con los 6 campos obligatorios cada una.

```markdown
# Vertical Slice Plan — 040 Planning
Fecha: [fecha]
Estado: DRAFT | APROBADO POR CLIENTE
Producido por: planning-writer

---

## Resumen de Slices

| VS-xx | Nombre | Tipo | IC-xx | BDD Scenarios | Esfuerzo |
|-------|--------|------|-------|---------------|----------|
| VS-01 | [nombre] | Tracer Bullet | IC-01, IC-02 | SC-01, SC-02, SE-01 | S |
| VS-xx | ...    | Crecimiento / MVP / Evolución / Robustez | ... | ... | XS/S/M/L/XL |

Total slices: [N] | Tracer Bullet: 1 | Crecimiento: [N] | MVP: 1 | Evolución: [N] | Robustez: 1

---

## Slices Detalladas

### VS-01 — [Nombre]

**Tipo:** Tracer Bullet
**IC-xx asignados:** IC-01, IC-02
**BDD Scenarios asignados:** SC-01, SC-02, SE-01
**Criterio de Done:**
  - IC-01 ([INombreInterface]) implementada con método `[método]` pasando en SC-01 y SC-02
  - IC-02 ([INombreInterface]) con stub mínimo funcional
  - SE-01 manejado: [descripción del comportamiento de error esperado]
  - Tests unitarios con mocks de IC-01 e IC-02 en verde
  - Flujo de extremo a extremo del SC-01 ejecutable sin errores
**Estimación de esfuerzo:** S
**Justificación del esfuerzo:** [N] IC-xx nuevas; stack [nombre del ADR-001]; [razón de la estimación]

---

### VS-xx — [Nombre]

**Tipo:** [Crecimiento | MVP | Evolución | Robustez]
**IC-xx asignados:** [lista IC-xx]
**BDD Scenarios asignados:** [lista SC-xx/SE-xx]
**Criterio de Done:**
  - [condición 1 con referencia a IC-xx o SC-xx específicos]
  - [condición 2]
  - Tests: [tipo] para IC-xx listados
**Estimación de esfuerzo:** [XS | S | M | L | XL]
**Justificación del esfuerzo:** [razón basada en IC-xx count + complejidad técnica del ADR-001]

---

[Repetir sección VS-xx por cada slice de la lista final del analysis_report.]
```

**6 campos obligatorios por slice (LL-24):**
1. **Nombre** — identificador descriptivo en lenguaje ubicuo del domain_glossary.md
2. **Tipo** — uno de: `Tracer Bullet`, `Crecimiento`, `MVP`, `Evolución`, `Robustez`
3. **IC-xx asignados** — lista de IC-xx de `design/contract_definitions.md` asignados a esta slice (al menos uno)
4. **BDD Scenarios asignados** — lista de SC-xx/SE-xx de `specification/bdd_features.md` asignados (al menos uno)
5. **Criterio de Done** — condiciones verificables con referencias explícitas a IC-xx y SC-xx/SE-xx específicos. **La frase exacta del campo debe comenzar con los IC-xx concretos**, no con generalidades.
6. **Estimación de esfuerzo** — una de: `XS`, `S`, `M`, `L`, `XL`, con justificación en términos de IC-xx count y complejidad del stack del ADR-001

**Reglas:**
- Todos los IC-xx del planning_analysis_report (incluyendo los que estaban huérfanos y fueron asignados) deben aparecer en ≥1 slice.
- Todos los BDD scenarios (incluyendo los huérfanos asignados) deben aparecer en ≥1 slice.
- La secuencia de tipos debe respetar: Tracer Bullet → Crecimiento (0..N) → MVP → Evolución (0..M) → Robustez.
- `Estado: DRAFT` hasta aprobación de A en CP-04. **El governor edita el campo Estado a `APROBADO POR CLIENTE` tras CP-04 — el writer siempre escribe `DRAFT`.**

---

## Artefacto 2 — project_roadmap.md

**Path:** `/plan/project_roadmap.md`
**Producir segundo.** Requiere las slices de `vertical_slice_plan.md` para poder secuenciar.

```markdown
# Project Roadmap — 040 Planning
Fecha: [fecha]
Estado: DRAFT | APROBADO POR CLIENTE
Producido por: planning-writer
Fuente de dependencias: design/dependency_graph.md (DEP-xx)

---

## Secuencia de Implementación

| Posición | VS-xx | Nombre | Tipo | Depende de | Duración estimada | Hito |
|----------|-------|--------|------|------------|-------------------|------|
| 1        | VS-01 | [nombre] | Tracer Bullet | — | XS/S/M/L/XL | ★ Tracer Bullet |
| 2        | VS-xx | [nombre] | Crecimiento | VS-01 | XS/S/M/L/XL | — |
| [N]      | VS-xx | [nombre] | MVP | VS-xx, VS-xx | XS/S/M/L/XL | ★ MVP |
| [N+M]    | VS-xx | [nombre] | Robustez | VS-xx | XS/S/M/L/XL | ★ Robustez |

**Hitos obligatorios marcados con ★**

---

## Dependencias entre Slices

(Derivadas de los DEP-xx del dependency_graph.md y del analysis_report.
Cada relación VS-xx → VS-xx tiene su DEP-xx origen documentado.)

| Slice dependiente | Depende de | DEP-xx origen | IC-xx que crea la dependencia | Tipo |
|-------------------|------------|---------------|------------------------------|------|
| VS-02             | VS-01      | DEP-01        | IC-01 — [INombreInterface]   | obligatoria |
| VS-xx             | VS-xx      | DEP-xx        | IC-xx — [INombreInterface]   | obligatoria / recomendada |

### Verificación de ausencia de ciclos

(Confirmar explícitamente que no hay dependencias circulares en la secuencia.)

Resultado: SIN CICLOS | CICLO DETECTADO: [descripción]

---

## Hitos del Proyecto

### ★ Hito 1 — Tracer Bullet (VS-01)

**Definición de éxito:** La arquitectura funciona de extremo a extremo con el flujo más simple. El SC-xx de referencia se ejecuta sin errores.
**Duración estimada:** [XS/S/M/L/XL]
**IC-xx completadas al alcanzar este hito:** [lista]
**BDD Scenarios cubiertos:** [lista SC-xx/SE-xx]

---

### ★ Hito 2 — MVP (VS-xx)

**Definición de éxito:** Funcionalidad mínima que aporta valor real al usuario final. Los escenarios BDD del scope MVP pasan en entorno de test integrado.
**Duración estimada acumulada:** [XS/S/M/L/XL]
**IC-xx completadas al alcanzar este hito:** [lista acumulada desde Tracer Bullet]
**BDD Scenarios cubiertos:** [lista acumulada]

---

### ★ Hito 3 — Robustez (VS-xx)

**Definición de éxito:** Cobertura completa. Todos los SC-xx y SE-xx pasan. Todos los IC-xx implementados y testeados.
**Duración estimada acumulada:** [XS/S/M/L/XL total del proyecto]
**IC-xx completadas:** todas (100%)
**BDD Scenarios cubiertos:** todos (100%)

---

## Resumen de Esfuerzo

| Tipo | Slices | Esfuerzo acumulado |
|------|--------|-------------------|
| Tracer Bullet | 1 | [sum] |
| Crecimiento | [N] | [sum] |
| MVP | 1 | [sum] |
| Evolución | [M] | [sum] |
| Robustez | 1 | [sum] |
| **Total** | **[total]** | **[sum total]** |
```

**Reglas:**
- Tracer Bullet siempre en posición 1. MVP antes que Robustez. Robustez siempre al final.
- Las slices de Crecimiento van entre Tracer Bullet y MVP; las de Evolución entre MVP y Robustez.
- Toda dependencia VS-xx → VS-xx debe tener su DEP-xx de respaldo en dependency_graph.md.
- Los 3 hitos obligatorios (Tracer Bullet, MVP, Robustez) deben estar marcados con ★.
- La duración estimada se expresa en las mismas unidades que el esfuerzo (XS/S/M/L/XL).
- `Estado: DRAFT` hasta aprobación de A en CP-04.

---

## Artefacto 3 — risk_register.md

**Path:** `/plan/risk_register.md`
**Producir tercero.** Requiere la lista final de VS-xx del vertical_slice_plan para garantizar ≥1 RK-xx por slice.

```markdown
# Risk Register — 040 Planning
Fecha: [fecha]
Estado: DRAFT | APROBADO POR CLIENTE
Producido por: planning-writer

---

## Resumen de Riesgos

| RK-xx | VS-xx | Categoría | Probabilidad | Impacto | Score | Mitigación (resumen) |
|-------|-------|-----------|--------------|---------|-------|---------------------|
| RK-01 | VS-01 | Técnica   | Media        | Alto    | M×A   | [resumen en 1 línea] |
| RK-xx | VS-xx | ...       | ...          | ...     | ...   | ... |

**Riesgos de alto impacto:** [N]
**Riesgos de probabilidad alta:** [N]

---

## Riesgos Detallados

### RK-01 — [Nombre del riesgo]

**VS-xx afectada:** VS-01
**Categoría:** Técnica | Dependencia | Ambigüedad | Arquitectura
**Probabilidad:** Alta | Media | Baja
**Impacto:** Alto | Medio | Bajo
**Descripción:** [descripción concreta del riesgo — qué puede salir mal, cuándo y por qué]
**Origen en los inputs:** [referencia a IC-xx, DEP-xx, ADR-xx, o sección de un input que genera este riesgo]
**Mitigación:**
  - [acción concreta 1 — no "hacer más testing" sino "implementar stub de IC-xx antes de VS-xx"]
  - [acción concreta 2 si aplica]
**Indicador de materialización:** [señal concreta que indica que el riesgo se está materializando]

---

[Repetir sección RK-xx por cada riesgo. Mínimo 1 RK-xx por VS-xx de la lista final.]
```

**Reglas:**
- ≥1 RK-xx por cada VS-xx de la lista final. Sin slices sin riesgo documentado.
- Cada RK-xx debe tener: VS-xx afectada, categoría, probabilidad (Alta/Media/Baja), impacto (Alto/Medio/Bajo), descripción concreta y mitigación no genérica.
- Mitigaciones genéricas como "revisar el código" o "hacer más testing" no son aceptables — deben ser acciones específicas con referencias a IC-xx, slices o artefactos concretos.
- `Estado: DRAFT` hasta aprobación de A en CP-04.

---

## Verificación cruzada entre artefactos (planning-writer al terminar)

Antes de ejecutar el self-checklist del Demo Statement, verificar la consistencia entre los 3 artefactos:

- [ ] Cada IC-xx de `design/contract_definitions.md` aparece en ≥1 VS-xx de `vertical_slice_plan.md`
- [ ] Cada SC-xx/SE-xx de `specification/bdd_features.md` aparece en ≥1 VS-xx de `vertical_slice_plan.md`
- [ ] Cada VS-xx de `vertical_slice_plan.md` aparece en `project_roadmap.md`
- [ ] Cada VS-xx de `vertical_slice_plan.md` tiene ≥1 RK-xx en `risk_register.md`
- [ ] La secuencia en `project_roadmap.md` respeta Tracer Bullet → MVP → Robustez (con Crecimiento y Evolución en sus posiciones)
- [ ] No hay dependencias circulares en `project_roadmap.md`
- [ ] Los 3 hitos obligatorios (★) están marcados en `project_roadmap.md`
- [ ] Ningún IC-xx ni SC-xx/SE-xx referenciado en `vertical_slice_plan.md` que no exista en `contract_definitions.md` o `bdd_features.md`
- [ ] Todos los nombres de slices usan términos del `domain_glossary.md`
- [ ] Los 3 archivos existen en `/plan/` con contenido (Write ejecutado para cada uno — LL-01)
