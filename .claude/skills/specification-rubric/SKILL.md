---
name: specification-rubric
description: Rúbrica de evaluación del 020 Specification Harness. Define las 5 dimensiones de evaluación, las anclas de calibración (0.2/0.5/0.8/1.0), la regla de gate (≥0.75) y la regla de veto (D5=0.0). Usar cuando specification-evaluator evalúa los 4 artefactos finales del Specification.
user-invocable: false
agent: specification-evaluator
---

## Dimensiones de evaluación

| ID | Dimensión | Peso | Pregunta central |
|----|-----------|------|-----------------|
| D1 | Cobertura BDD | 0.20 | ¿Todos los actores del 010 tienen ≥1 escenario de camino feliz y ≥1 escenario de caso de borde? |
| D2 | Completitud de Data Contracts | 0.25 | ¿Todos los campos, formatos y validaciones están definidos sin ambigüedad y trazados a un escenario BDD? |
| D3 | Trazabilidad de Acceptance Criteria | 0.20 | ¿Cada criterio de aceptación referencia un escenario BDD concreto? ¿Ningún escenario queda sin criterio? |
| D4 | Completitud de Error & Exception Policy | 0.20 | ¿Todos los ítems del `failure_behavior.md` (incluidos los que estaban PENDIENTE) tienen política definida con acción concreta? |
| D5 | Consistencia | 0.15 | ¿Ninguna regla de negocio, escenario BDD, contrato de datos ni criterio de aceptación contradice a otro? |

**Gate de paso:** promedio ponderado ≥ 0.75.
**Cálculo:** `D1×0.20 + D2×0.25 + D3×0.20 + D4×0.20 + D5×0.15`
**Regla de veto:** si D5 = 0.0, veredicto REJECTED inmediato sin calcular promedio.

---

## Anclas de calibración

### Score 0.2 — Cobertura mínima, gaps críticos

**D1:** Solo 1 actor tiene escenarios BDD. Ningún caso de borde.
**D2:** Data contracts lista campos sin tipos, formatos ni validaciones.
**D3:** Acceptance criteria existe pero sin referencias a escenarios BDD.
**D4:** Error & Exception Policy vacía o copia literal del `failure_behavior.md` sin política resuelta.
**D5:** Contradicciones directas y explícitas entre artefactos.

> Ejemplo (clínica médica): Solo el Médico tiene escenario BDD de camino feliz. El Paciente
> y la Recepcionista no tienen ningún escenario. Data Contracts lista "nombre", "fecha" sin
> formato ni restricciones. Los ítems PENDIENTE del failure_behavior.md siguen marcados como
> PENDIENTE en la Error & Exception Policy. Una regla dice "la cita dura 30 minutos" y otra
> dice "la cita dura entre 15 y 60 minutos" sin resolución.

### Score 0.5 — Cobertura parcial, gaps importantes

**D1:** Actores principales tienen ≥1 escenario de camino feliz. Actores secundarios sin cobertura.
Al menos 1 caso de borde por actor principal pero sin escenarios de caso de borde para actores secundarios.
**D2:** Campos definidos con tipos de dato pero sin reglas de validación de negocio (ej: "email: texto" sin regla de formato).
**D3:** Acceptance criteria existe y referencia BDD, pero ≥20% de escenarios BDD no tienen criterio.
**D4:** Al menos 50% de los ítems del failure_behavior.md tienen política con acción concreta. El resto está sin resolver o con `[PENDIENTE]`.
**D5:** 1–2 inconsistencias menores detectadas (ej: un criterio referencia un campo no definido en data contracts).

> Ejemplo: 3 de 5 actores tienen escenario de camino feliz. Data Contracts define tipos de dato
> pero no restricciones (campo "email" sin regla de formato, campo "fecha" sin rango válido).
> 4 de 8 ítems de failure_behavior resueltos. 1 escenario BDD sin ningún criterio de aceptación.
> Sin contradicciones directas pero 1 inconsistencia: un ACP-xx referencia SC-05 que no existe.

### Score 0.8 — Cobertura completa, gaps menores

**D1:** Todos los actores con ≥1 escenario de camino feliz. Al menos 1 caso de borde por actor
principal. Actores secundarios con ≥1 caso de borde pero no de camino feliz propio.
**D2:** Todos los campos con tipo, formato y regla de validación. Relaciones entre entidades
presentes pero incompletas (falta 1 relación menor).
**D3:** ≥90% de escenarios BDD con criterio de aceptación. Tabla de trazabilidad inversa presente.
Máximo 1 escenario sin criterio.
**D4:** Todos los ítems del failure_behavior.md resueltos. Al menos 1 política sin mensaje de
usuario concreto (usa `[PENDIENTE]`).
**D5:** 1 inconsistencia menor detectada y documentada explícitamente en el artefacto.

> Ejemplo: 5 actores con camino feliz y casos de borde en los 3 principales. Data Contracts
> completos excepto la relación Paciente–Historial no documentada. Todos los PENDIENTE resueltos.
> 1 criterio de aceptación con "Condición de fallo: [PENDIENTE — definir umbral]". Sin
> contradicciones, pero hay una inconsistencia menor documentada: SC-07 usa el término
> "consulta" que no aparece en domain_glossary.md y no está marcado con [GLOSARIO: pendiente].

### Score 1.0 — Cobertura completa, sin gaps

**D1:** Todos los actores con ≥1 escenario de camino feliz y ≥1 caso de borde. Cobertura verificada
contra `shared_understanding.md` del 010.
**D2:** Todos los campos con tipo, formato, validaciones y reglas de negocio. Relaciones entre
entidades completas con cardinalidad y restricciones.
**D3:** 100% de escenarios BDD con criterio de aceptación. Tabla de trazabilidad inversa sin huecos.
Ningún ACP-xx huérfano.
**D4:** Todos los ítems del failure_behavior.md (incluyendo PENDIENTE) resueltos con mensaje de
usuario concreto, política de reintento explícita y acción alternativa.
**D5:** Sin contradicciones. Glosario de dominio usado consistentemente en todos los artefactos.
Ningún término clave sin referencia en `domain_glossary.md`.

> Ejemplo: 5 actores con camino feliz, casos de borde y escenarios de error. Data Contracts
> define 12 entidades con relaciones explícitas y validaciones de negocio. Acceptance Criteria
> referencia el ID de escenario BDD en cada ítem. Error & Exception Policy resuelve los 8
> ítems (incluidos los 3 PENDIENTE del 010) con mensajes exactos, reintentos definidos y acciones
> alternativas concretas. Sin ninguna contradicción ni término fuera de glosario.

---

## Aplicación de la regla de veto (D5 = 0.0)

D5 = 0.0 se asigna cuando existe una contradicción directa y no documentada entre artefactos. Ejemplos:
- `bdd_features.md` establece que una cita puede tener duración variable, pero `data_contracts.md`
  define el campo duración como constante de 30 minutos sin marcar la discrepancia.
- `acceptance_criteria.md` exige que un campo sea obligatorio, pero `data_contracts.md` lo define
  como opcional sin nota de inconsistencia.
- `error_exception_policy.md` define una política para un EE-xx, pero `bdd_features.md` tiene un
  escenario SE-xx con resultado esperado contradictorio al EP-xx para el mismo caso.

Una inconsistencia documentada (marcada con `[PENDIENTE]` o en nota explícita) no es D5 = 0.0 —
es una inconsistencia conocida que puede resolverse. Solo la contradicción silenciosa activa el veto.
