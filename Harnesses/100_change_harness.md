# Change Harness (Gestión de Cambios)

El objetivo de este arnés es canalizar cualquier solicitud de cambio que llegue durante la etapa de construcción de software, garantizando que el impacto sea analizado antes de actuar y que los artefactos upstream queden consistentes antes de re-ingresar al ciclo de construcción.

## Casos de activación

*   **Caso 1 — Scope Addition (SA):** El cliente solicita una feature que nunca fue considerada. No existe en ningún artefacto del proyecto (sin IC-xx, sin VS-xx, sin BDD scenarios).
*   **Caso 2 — Change Request pre-build (CR):** El cliente quiere modificar una feature considerada en el plan pero aún no construida. Existen artefactos que la describen pero no hay código asociado.
*   **Caso 3 — Change Request post-build (CR):** El cliente quiere modificar una feature ya construida. Existen artefactos y código en producción.

## Entradas (Inputs)

*   **Change Description:** Descripción del cambio solicitado por el cliente, con suficiente detalle para clasificarlo y analizarlo.
*   **Plan Maestro del 040 (vertical_slice_plan.md, project_roadmap.md, risk_register.md):** Estado actual del plan de construcción.
*   **Artefactos upstream relevantes:** Subconjunto de artefactos del 030, 020 y 010 que potencialmente se ven afectados por el cambio.
*   **Estado del 050:** Lista de slices con su estado actual (TO DO / IN PROGRESS / DONE) para determinar si hay código que revisar.

## Proceso (Process)

*   **Clasificación del cambio:** Determinar a cuál de los 3 casos pertenece la solicitud. Esta clasificación define el blast radius potencial y el camino de re-ejecución.
*   **Impact Analysis:** Identificar qué artefactos específicos (IC-xx, BDD scenarios, ADR, slices VS-xx) se ven afectados. En el Caso 3, identificar también qué slices ya construidas dependen de la feature a modificar (riesgo de regresión).
*   **Escalamiento obligatorio al humano:** Presentar el análisis de impacto con claridad antes de ejecutar cualquier cambio. Ningún agente decide solo cuándo retroceder a una fase de gobernanza. El humano aprueba el camino de re-ejecución.
*   **Actualización de artefactos upstream:** Según el camino aprobado, re-correr parcialmente los harnesses afectados (020, 030 y/o 040) para producir artefactos consistentes con el cambio.
*   **Actualización del plan maestro:** Incorporar la slice nueva o modificada al 040 (vertical_slice_plan, roadmap, risk_register) con los campos obligatorios completos.

## Salidas (Outputs - Artefactos)

*   **Change Record (CH-xxx):** Registro formal del cambio con ID único, clasificación (SA o CR), descripción, impacto identificado y decisión del humano.
*   **Artefactos upstream actualizados:** IC-xx, BDD scenarios, ADR y/o slices VS-xx modificados de forma consistente.
*   **Plan maestro actualizado:** `vertical_slice_plan.md`, `project_roadmap.md` y `risk_register.md` del 040 reflejando el cambio aprobado.
*   **Slice lista para construcción:** La feature nueva o modificada expresada como una slice VS-xx completa y válida, lista para ingresar al 050.

## Ruta de salida

Una vez que los artefactos upstream están actualizados y el plan maestro refleja el cambio, el flujo retorna al **050 Iteration Harness** con la slice correspondiente como input. En el Caso 3, el 050 trata la slice como una re-construcción y el **080 Verification Harness** ejecuta la suite de regresión completa para detectar impacto en slices ya construidas.
