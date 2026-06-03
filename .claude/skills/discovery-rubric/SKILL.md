---
name: discovery-rubric
description: Rúbrica de evaluación del 010 Discovery Harness. Define las 5 dimensiones de evaluación, las anclas de calibración (0.2/0.5/0.8/1.0), la regla de gate (≥0.75) y la regla de veto (D5=0.0). Usar cuando discovery-evaluator evalúa los 4 artefactos finales del Discovery.
user-invocable: false
agent: discovery-evaluator
---

## Principio de evaluación

discovery-evaluator evalúa los 4 artefactos **sin contexto de ejecución** — no sabe cuántas rondas tomó,
qué stakeholders participaron, ni cuántas iteraciones hubo. Solo lee lo que está en los archivos
y lo contrasta con esta rúbrica. La evaluación es ciega al proceso.

---

## Dimensiones de evaluación

### D1 — Cobertura de Actores
**Qué mide:** Todos los actores del sistema identificados tienen al menos un objetivo de valor definido en `shared_understanding.md` y en `domain_glossary.md`.

**Cómo evaluar:**
- Listar todos los actores mencionados en `shared_understanding.md`.
- Verificar que cada uno tiene ≥1 objetivo de valor explícito.
- Verificar que cada uno aparece en `domain_glossary.md` o está descrito con suficiente claridad en `shared_understanding.md`.

### D2 — Claridad de Intención
**Qué mide:** La intención del cliente está capturada sin ambigüedad en `shared_understanding.md`. Un lector externo puede entender qué hace el sistema y para quién sin necesitar preguntar.

**Cómo evaluar:**
- ¿El propósito del sistema está descrito en lenguaje no técnico?
- ¿Cada capacidad listada es verificable ("el sistema permite X" o "el sistema notifica a Y cuando Z")?
- ¿`scope_boundaries.md` tiene ≥3 exclusiones explícitas que delimitan el alcance?

### D3 — Gestión de Contradicciones
**Qué mide:** Ninguna contradicción identificada permanece sin resolver al cierre de la fase.

**Cómo evaluar:**
- Revisar la sección "Contradicciones Resueltas" en `shared_understanding.md`.
- Si hay contradicciones listadas: cada una debe tener resolución acordada explícita.
- Si no hay contradicciones listadas: es aceptable solo si el scope es simple y los actores no tienen conflictos de prioridad evidentes.

### D4 — Cobertura de Fallos
**Qué mide:** Al menos un escenario de fallo documentado por cada actor principal en `failure_behavior.md`.

**Cómo evaluar:**
- Listar actores principales de `shared_understanding.md`.
- Verificar que cada uno tiene ≥1 escenario en `failure_behavior.md`.
- Verificar que los comportamientos esperados son concretos (no "mostrar error genérico").

### D5 — Aprobación Explícita
**Qué mide:** El cliente aprobó explícitamente el `shared_understanding.md`. Existe registro de esa aprobación en el artefacto.

**Cómo evaluar:**
- Buscar en `shared_understanding.md` el campo `Estado: APROBADO POR CLIENTE`.
- Verificar que `Fecha de aprobación` tiene una fecha real (no "—").
- Verificar que `Registro` contiene una cita textual o descripción de la aprobación (no "—").

**Regla de veto:** Si D5 = 0.0, el veredicto es REJECTED automáticamente sin importar los otros scores.

---

## Anclas de calibración

### Score 0.2
Solo 1 actor identificado. Sin objetivos de valor. Sin escenarios de fallo. Sin aprobación del cliente. `shared_understanding.md` no existe o es un borrador vago de 2–3 líneas.

> Ejemplo: "El sistema debe ser una app de gestión. Los usuarios son los administradores." Sin más detalle, sin objetivos, sin fallos, sin glosario.

### Score 0.5
Actores principales identificados pero faltan actores secundarios. Algunos objetivos de valor definidos (al menos el 50%). Sin escenarios de fallo documentados. `shared_understanding.md` existe pero el cliente no lo aprobó formalmente. `scope_boundaries.md` tiene menos de 3 exclusiones.

> Ejemplo: Se identificaron "Admin" y "Usuario" pero no "Cliente externo". 3 de 6 objetivos de valor definidos. No se preguntó sobre fallos. El documento se entregó pero no hubo confirmación explícita.

### Score 0.8
Todos los actores identificados con ≥1 objetivo de valor cada uno. Al menos 1 contradicción detectada y resuelta. 1 escenario de fallo por actor principal documentado. `shared_understanding.md` completo, pero la aprobación del cliente no tiene registro explícito (solo señales positivas verbales sin cita).

> Ejemplo: 4 actores, todos con objetivos. 2 contradicciones resueltas. Failure behavior documentado para los 2 actores principales. El cliente dijo "sí, está bien" verbalmente pero no se registró en el artefacto con fecha y cita.

### Score 1.0
Todos los actores con ≥1 objetivo de valor. Todas las contradicciones resueltas con resolución acordada. ≥1 escenario de fallo por actor principal y ≥1 por actor secundario. `shared_understanding.md` aprobado con registro explícito, fecha y cita textual. `domain_glossary.md` con ≥5 términos sin ambigüedad. `scope_boundaries.md` con ≥3 exclusiones concretas.

> Ejemplo: 4 actores con todos sus objetivos. Glosario con 8 términos definidos. 6 escenarios de fallo documentados. El cliente aprobó con cita registrada. Scope Boundaries lista 5 exclusiones concretas.

---

## Reglas de puntuación

1. Asignar un score entre 0.0 y 1.0 a cada dimensión. Los valores típicos son 0.0, 0.2, 0.5, 0.8, 1.0 — usar valores intermedios solo cuando hay evidencia parcial clara.
2. Calcular el promedio de D1 a D5.
3. **Gate de paso:** promedio ≥ 0.75 → APPROVED. Promedio < 0.75 → REJECTED.
4. **Regla de veto:** D5 = 0.0 → REJECTED automático, sin calcular promedio.
5. Por cada dimensión con score < 0.75, documentar la razón específica y una recomendación accionable.
6. El score debe reflejar lo que está en los artefactos, no lo que C supone que ocurrió.
