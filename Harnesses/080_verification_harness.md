# Verification Harness (Control de Calidad y Ecosistema)

El objetivo de este arnés es actuar como el control de calidad final del sistema. Su misión es asegurar que el incremento de código producido de forma aislada sea totalmente compatible con el resto del ecosistema de la empresa y esté listo para la inspección y aprobación de los ingenieros humanos.

## Entradas (Inputs)
*   **Verified Code Patch (del Execution Harness):** El código que ya pasó los tests y validaciones dentro del sandbox.
*   **Ecosystem State (Estado Global):** El repositorio principal y sus dependencias actualizadas con los cambios más recientes de otros equipos.
*   **Global Quality Standards:** Las reglas de seguridad, rendimiento, arquitectura y convenciones de codificación de la organización.
*   **Original Specifications:** Escenarios BDD y contratos originales para asegurar que el valor prometido se mantiene tras la integración.

## Proceso (Process)
*   **Ecosystem Integration Testing:** Validar la compatibilidad con componentes y servicios que no estaban presentes durante la fase de aislamiento (APIs reales, bases de datos compartidas, servicios de mensajería).
*   **Regression Suite Execution:** Ejecutar la suite completa de pruebas del proyecto para garantizar que el nuevo código no introduce regresiones en funcionalidades existentes.
*   **Auditoría de Cumplimiento (Compliance):** Verificar que el incremento no introduce secretos, vulnerabilidades de seguridad conocidas o código que degrade el rendimiento global.
*   **Human-Ready Structuring:** Organizar y limpiar el código, los commits y la documentación técnica para asegurar que un ingeniero humano pueda realizar una revisión (Peer Review) eficiente y sin fricciones.
*   **Validación del Contrato de Valor:** Confirmación final de que la solución técnica resuelve el problema de negocio planteado originalmente.

## Ruta de Regreso ante Fallo
Si la "Validación del Contrato de Valor" u otro paso del proceso falla, el flujo sigue este árbol de decisión:
1.  **Fallo técnico** (tests de integración, regresiones, compliance): el flujo regresa al `050_iteration_harness` para re-ejecutar el ciclo con el defecto identificado.
2.  **Fallo de valor** (la solución técnica no resuelve el problema de negocio): el flujo regresa al `040_planning_harness` si el desvío es de alcance o priorización, o al `020_specification_harness` si la especificación original era incorrecta o incompleta. En ambos casos el escalamiento al humano es obligatorio — ningún agente decide solo cuándo retroceder a una fase de gobernanza.
3.  El responsable de ejecutar este árbol de decisión y notificar al humano es la **Instancia A (Gobernanza)**, una vez que recibe el reporte de fallo del 080.

## Salidas (Outputs - Artefactos)
*   **Ready-for-Review Artifact (PR/MR):** Una propuesta de integración (Pull Request / Merge Request) limpia, estructurada y documentada.
*   **Ecosystem Validation Report:** Informe técnico que certifica que la integración es segura y no afecta la estabilidad global.
*   **Reviewer Context Package:** Información curada y simplificada para el revisor humano, destacando decisiones técnicas clave y áreas de impacto.
*   **Quality Certification:** Sello de aprobación técnica que indica que el código cumple con todos los estándares del ecosistema.
