---
name: specification-evaluator-protocol
description: Protocolo de verificación por dimensión del specification-evaluator en el 020 Specification Harness. Define los procedimientos de verificación para D2 (Data Contracts), D3 (AC Traceability), D4 (Error Policy) y D5 (Consistency), con los checks cruzados de IDs entre artefactos. Usar cuando specification-evaluator ejecuta la evaluación de los 4 artefactos finales del 020.
user-invocable: false
agent: specification-evaluator
---

Procedimientos de verificación para las dimensiones D2–D5. Para cada dimensión, aplicar siempre
el protocolo de dos fases del agente: Fase 1 (análisis: pros + contras con evidencia citada)
→ Fase 2 (score con anclas de `specification-rubric`).

---

## D2 — Completitud de Data Contracts

**Pregunta:** ¿Todos los campos, formatos y validaciones están definidos sin ambigüedad y trazados a un escenario BDD?

**Fase 1 — qué buscar:**

Pros (registrar con referencia de sección):
- Entidades con nombre, descripción, tipo y al menos un campo definido.
- Campos con tipo de dato, formato y restricción de negocio especificados.
- Relaciones entre entidades documentadas (RE-xx) con cardinalidad y regla de negocio.
- Campo "Escenario BDD relacionado" con ID SC-xx o SE-xx verificable.

Contras (registrar con cita concreta):
- Campos sin formato definido (ej: "tipo: texto" sin longitud máxima ni patrón).
- Campos sin validación de negocio o con validación vaga (ej: "campo requerido" sin criterio).
- Campo "Escenario BDD relacionado" vacío o con `[sin escenario — revisar]`.
- Relaciones entre entidades ausentes cuando la lógica de negocio las requiere.
- Entidades referenciadas en `bdd_features.md` que no tienen entrada en `data_contracts.md`.

**Fase 2:** asignar score según anclas de `specification-rubric`.

---

## D3 — Trazabilidad de Acceptance Criteria

**Pregunta:** ¿Cada criterio referencia un BDD concreto? ¿Ningún escenario BDD queda sin criterio?

**Fase 1 — qué buscar:**

Pros:
- Cada ACP-xx tiene campo "Escenario BDD" con un ID SC-xx o SE-xx real.
- La tabla de trazabilidad inversa cubre todos los SC-xx y SE-xx de `bdd_features.md`.
- Los criterios verificables son concretos (ej: "el sistema muestra mensaje X") no vagos (ej: "funciona correctamente").

Contras:
- ACP-xx con campo "Escenario BDD" vacío o con ID que no existe en `bdd_features.md`.
- SC-xx o SE-xx presentes en `bdd_features.md` sin ACP-xx en la tabla de trazabilidad inversa.
- Criterios de aceptación con lenguaje no verificable o ambiguo.

**Check cruzado obligatorio:**
Para cada referencia SC-xx o SE-xx en `acceptance_criteria.md`, verificar que ese ID existe en
`bdd_features.md`. Cualquier referencia a un ID inexistente es un contra concreto.

**Fase 2:** asignar score.

---

## D4 — Completitud de Error & Exception Policy

**Pregunta:** ¿Todos los ítems del `failure_behavior.md` tienen política con acción concreta?

**Fase 1 — qué buscar:**

Pros:
- EP-xx con mensaje de error concreto (no genérico).
- EP-xx con política de reintento explícita (sí/no, máximo de reintentos si aplica).
- EP-xx con acción alternativa definida (qué hace el sistema si el reintento falla).
- Sección "Resoluciones de ítems PENDIENTE del 010" presente y con entradas.

Contras:
- EP-xx con `[PENDIENTE]` en cualquier campo (mensaje, reintento o acción).
- EP-xx con acción alternativa vacía o con "N/A" sin justificación.
- EE-xx del `spec_analysis_report.md` sin EP-xx correspondiente en la policy.
- Ítems que estaban PENDIENTE en el `failure_behavior.md` del 010 y el governor resolvió,
  pero no aparecen en la sección "Resoluciones de ítems PENDIENTE del 010" — su ausencia
  es un contra directo.

**Fase 2:** asignar score.

---

## D5 — Consistencia

**Pregunta:** ¿Ninguna regla, escenario, contrato ni criterio contradice a otro?

**Fase 1 — verificaciones concretas a ejecutar:**

1. **BDD → Data Contracts:** cada entidad o campo referenciado en un escenario SC-xx o SE-xx
   existe en `data_contracts.md`. Si un escenario menciona "campo email del Paciente" y
   `data_contracts.md` no tiene ese campo, es una contradicción.

2. **Data Contracts → BDD:** cada referencia SC-xx/SE-xx en `data_contracts.md` apunta a un
   ID que existe en `bdd_features.md`.

3. **Acceptance Criteria → BDD:** ya verificado en D3. Si se encontraron IDs inexistentes en
   D3, registrarlos también como contras en D5.

4. **Error Policy → BDD:** las políticas de `error_exception_policy.md` son consistentes con
   el resultado esperado (campo "Then") de los SE-xx relacionados. Si SE-xx dice "Then: el
   sistema muestra error 404" y EP-xx dice "acción: reintento automático sin notificación",
   hay contradicción.

5. **Lenguaje:** los términos usados en todos los artefactos corresponden al `domain_glossary.md`.
   Un término de negocio usado con definición diferente a la del glosario es una inconsistencia.

Pros: verificaciones sin contradicción encontrada, con evidencia de que se revisó.
Contras: contradicciones concretas citadas con artefacto + sección + texto exacto.

**Regla de veto — definición operacional:**
- **Activa el veto (D5 = 0.0):** contradicción directa y silenciosa — dos reglas o escenarios
  incompatibles que el writer dejó pasar sin registrarlos. Ej: SC-xx dice "el sistema acepta
  pagos sin cuenta" y data_contracts.md dice "campo cuenta_id es obligatorio para todo pago".
- **No activa el veto:** inconsistencia documentada con marcador `[PENDIENTE]` o nota explícita.
  Eso es una advertencia, no una contradicción silenciosa.

**Fase 2:** asignar score. Si existe cualquier contradicción directa y silenciosa → D5 = 0.0.
