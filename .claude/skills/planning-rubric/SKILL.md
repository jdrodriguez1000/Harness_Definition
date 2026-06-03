---
name: planning-rubric
description: Rúbrica de evaluación del 040 Planning Harness. Define las 5 dimensiones de evaluación, las anclas de calibración (0.2/0.5/0.8/1.0), la regla de gate (≥0.75) y la regla de veto (D5=0.0). Usar cuando planning-evaluator evalúa los 3 artefactos finales del Planning.
user-invocable: false
agent: planning-evaluator
---

## Dimensiones de evaluación

| ID | Dimensión | Pregunta central |
|----|-----------|-----------------|
| D1 | VS Coverage | ¿Todos los IC-xx de `030_design/contract_definitions.md` y todos los SC-xx/SE-xx de `020_specification/bdd_features.md` están asignados a ≥1 slice en `vertical_slice_plan.md`? ¿Sin huérfanos? |
| D2 | Slice Definition Quality | ¿Cada slice en `vertical_slice_plan.md` tiene los 6 campos obligatorios: nombre, tipo, IC-xx, BDD scenarios, Criterio de Done con referencias a IDs concretos, y estimación de esfuerzo? |
| D3 | Roadmap Coherence | ¿La secuencia en `project_roadmap.md` respeta TB→Crecimiento→MVP→Evolución→Robustez? ¿Sin dependencias circulares? ¿Los 3 hitos obligatorios marcados? ¿Dependencias VS-xx → VS-xx explícitas y derivadas de DEP-xx? |
| D4 | Risk Completeness | ¿`risk_register.md` tiene ≥1 RK-xx por slice? ¿Cada RK-xx tiene probabilidad (Alta/Media/Baja), impacto (Alto/Medio/Bajo) y mitigación concreta (no genérica)? |
| D5 | Consistency | ¿Los IDs (VS-xx, IC-xx, SC-xx/SE-xx, RK-xx) son coherentes entre los 3 artefactos? ¿Sin contradicciones con los inputs del 030/020/010? ¿Lenguaje ubicuo del glosario usado consistentemente? |

**Gate de paso:** promedio ≥ 0.75 en todas las dimensiones.
**Regla de veto:** si D5 = 0.0, veredicto REJECTED inmediato sin calcular promedio.

---

## Anclas de calibración

> Dominio de referencia: Sistema de Inventario y Alertas de Stock — Distribuidora Andina Ltda.
> Slices hipotéticas: VS-01 Tracer Bullet (login + GET /stock/{id}), VS-02 Crecimiento (CRUD inventario),
> VS-03 MVP (alertas de umbral + notificaciones), VS-04 Evolución (historial de movimientos),
> VS-05 Robustez (manejo de errores + retry).

### Score 0.2 — Cobertura mínima, gaps críticos

**D1:** `vertical_slice_plan.md` lista las slices sin IC-xx ni BDD scenarios asignados (solo nombres).
IC-xx huérfanos en `contract_definitions.md` sin asignar.
**D2:** Slices con nombre y tipo pero sin Criterio de Done ni estimación de esfuerzo. Los campos IC-xx y BDD scenarios vacíos o ausentes.
**D3:** `project_roadmap.md` con la secuencia correcta de nombres pero sin dependencias explícitas ni hitos marcados.
**D4:** `risk_register.md` con un único riesgo genérico ("complejidad técnica") para todas las slices, sin probabilidad, impacto ni mitigación.
**D5:** Contradicciones directas y no documentadas entre artefactos.

> Ejemplo: VS-03 MVP listada sin IC-xx ni SC-xx asignados. `project_roadmap.md` dice
> "VS-01, VS-02, VS-03, VS-04, VS-05" sin ninguna dependencia VS-xx → VS-xx. `risk_register.md`
> tiene una sola línea: "RK-01 — Riesgo técnico general. Probabilidad: Alta. Impacto: Alto." sin
> mitigación. IC-05 (IAlertaRepository) sin asignar a ninguna slice. `vertical_slice_plan.md`
> menciona VS-03 con el campo IC-xx vacío aunque IC-05 existe en `contract_definitions.md`.

### Score 0.5 — Cobertura parcial, gaps importantes

**D1:** `vertical_slice_plan.md` con IC-xx asignados a las slices principales pero BDD scenarios
parcialmente asignados (≥50% cubiertos). ≥1 IC-xx huérfano sin asignar.
**D2:** Slices con IC-xx y BDD scenarios pero Criterios de Done genéricos sin referencias a IDs
concretos ("la funcionalidad está implementada"). ≥2 slices sin estimación de esfuerzo.
**D3:** `project_roadmap.md` con hitos marcados pero dependencias incompletas (faltan 3-4 relaciones
VS-xx → VS-xx). Slices de Crecimiento o Evolución en posición incorrecta (ej. Evolución antes del MVP).
**D4:** `risk_register.md` con ≥1 RK-xx por slice pero mitigaciones genéricas ("revisar el código",
"hacer más testing") sin acciones concretas ni referencias a IC-xx o slices específicas.
**D5:** 1–2 inconsistencias detectadas; pueden ser silenciosas o documentadas parcialmente.

> Ejemplo: VS-03 MVP tiene IC-05, IC-06 asignados pero falta SC-07 (notificación por email) sin
> asignar. `project_roadmap.md` marca VS-01 como hito pero no VS-03 ni VS-05. Dependencia
> VS-03 → VS-01 documentada pero falta VS-04 → VS-02 (historial requiere CRUD previo).
> VS-03 Criterio de Done: "Alertas y notificaciones implementadas" (sin referencias a IC-05, IC-06
> ni SC-07, SC-08). `risk_register.md`: RK-03 para VS-03 dice "Riesgo de integración. Mitigación: testear bien."

### Score 0.8 — Cobertura completa, gaps menores

**D1:** Todos los IC-xx de `contract_definitions.md` asignados. ≥90% de BDD scenarios asignados
(falta 1-2 escenarios secundarios). Sin IC-xx huérfanos.
**D2:** Todos los 6 campos presentes en cada slice. Criterios de Done con referencias a IDs en las
slices principales pero 1-2 slices secundarias con Criterio de Done liviano. 1-2 slices sin estimación
de esfuerzo.
**D3:** Secuencia correcta, 3 hitos marcados, dependencias derivadas de DEP-xx. 1-2 dependencias
opcionales no documentadas. Sin ciclos.
**D4:** ≥1 RK-xx por slice con probabilidad e impacto. 2-3 mitigaciones todavía genéricas en slices
de bajo riesgo.
**D5:** 1 inconsistencia menor detectada (un ID referenciado en un artefacto que tiene ortografía
diferente en otro, o un IC-xx listado en el roadmap que no aparece en vertical_slice_plan).

> Ejemplo: VS-04 Evolución sin campo de esfuerzo en `vertical_slice_plan.md`. SC-12 asignado a
> VS-04 pero sin referencia en el Criterio de Done de esa slice. `project_roadmap.md` correcto en
> secuencia y dependencias pero sin "Duración estimada: S" para VS-04. RK-04 para VS-04: "Riesgo de
> performance en historial de movimientos. Probabilidad: Media. Impacto: Medio. Mitigación: agregar
> índice en la tabla de movimientos." RK-05 para VS-05: "Riesgo de cobertura de errores. Mitigación:
> hacer revisión de código." (demasiado genérica). `project_roadmap.md` dice "IC-05" en la columna
> de dependencias pero `vertical_slice_plan.md` lo llama "IC-5" (inconsistencia menor de formato).

### Score 1.0 — Cobertura completa, sin gaps

**D1:** 100% de IC-xx de `contract_definitions.md` asignados a ≥1 slice. 100% de SC-xx/SE-xx de
`bdd_features.md` asignados a ≥1 slice. Tabla de resumen en `vertical_slice_plan.md` confirma cobertura total.
**D2:** Cada slice con los 6 campos completos: nombre (lenguaje ubicuo), tipo correcto, IC-xx con lista
explícita, BDD scenarios con IDs, Criterio de Done con referencias a IC-xx y SC-xx/SE-xx específicos y
condiciones verificables, estimación de esfuerzo (XS/S/M/L/XL) con justificación.
**D3:** Secuencia correcta sin excepciones. 3 hitos obligatorios marcados. Todas las dependencias VS-xx →
VS-xx documentadas con DEP-xx de respaldo. Duración estimada por slice. Sin ciclos.
**D4:** ≥1 RK-xx por slice. Cada RK-xx con probabilidad + impacto + mitigación concreta con referencias
a IC-xx, slices o artefactos específicos. Indicador de materialización documentado.
**D5:** Sin contradicciones entre los 3 artefactos. Ningún ID en un artefacto que no exista en otro.
Lenguaje ubicuo de `domain_glossary.md` usado consistentemente. Ningún IC-xx ni SC-xx/SE-xx en el plan
que no exista en `contract_definitions.md` o `bdd_features.md`.

> Ejemplo: VS-03 MVP — IC-05 (IAlertaRepository), IC-06 (INotificacionService); BDD: SC-07, SC-08,
> SE-03; Criterio de Done: "IC-05 con método `findByUmbral` retorna correctamente en SC-07 y SC-08;
> IC-06 envía notificación en SE-03; tests de integración pasan para ambas interfaces"; Esfuerzo: L.
> `project_roadmap.md`: VS-03 depende de VS-01 (DEP-01 — IC-01 del login requerida) y VS-02 (DEP-03 —
> IC-03 de stock requerida para evaluar umbrales). Hito MVP marcado con ★ en VS-03. Duración estimada: L.
> `risk_register.md`: RK-03 para VS-03 — "Dependencia de servicio SMTP externo para IC-06. Probabilidad:
> Media. Impacto: Alto (bloquea el MVP). Mitigación: usar stub de INotificacionService en VS-01 y VS-02;
> configurar SMTP real solo en VS-03; tener proveedor alternativo documentado en ADR-002. Indicador:
> timeout en test de integración de IC-06." Sin ningún ID referenciado en el plan que no exista en
> `contract_definitions.md` o `bdd_features.md`.

---

## Aplicación de la regla de veto (D5 = 0.0)

D5 = 0.0 se asigna cuando existe una contradicción directa y no documentada entre artefactos.
Ejemplos:

- `vertical_slice_plan.md` asigna IC-07 a VS-03, pero IC-07 no existe en `030_design/contract_definitions.md` y no hay nota explicando la adición.
- `project_roadmap.md` coloca VS-04 (Evolución) antes de VS-03 (MVP) sin documentar la excepción a la estructura obligatoria.
- `risk_register.md` documenta RK-05 para VS-06, pero VS-06 no existe en `vertical_slice_plan.md`.
- `vertical_slice_plan.md` lista SC-15 en VS-04, pero SC-15 no existe en `020_specification/bdd_features.md` y no hay nota de adición.
- Un tipo de slice declarado como "Crecimiento" en `vertical_slice_plan.md` pero sin posición de Crecimiento en `project_roadmap.md` (aparece después del MVP sin justificación).

Una inconsistencia documentada (marcada con `[PENDIENTE]` o en nota explícita) no activa el veto —
es una inconsistencia conocida que puede resolverse. Solo la contradicción silenciosa activa el veto.
