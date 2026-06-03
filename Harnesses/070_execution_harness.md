# Execution Harness (Construcción TDD)

El objetivo de este arnés es la ejecución física de la micro-tarea. Es el especialista en "picar código" que opera exclusivamente dentro del entorno seguro y enfocado que le entrega el *Isolation Harness*, siguiendo el ciclo riguroso de Red-Green-Refactor.

## Entradas (Inputs)
*   **Enclosed Sandbox Environment (del Isolation Harness):** El espacio de trabajo aislado y seguro.
*   **Filtered Workspace View (del Isolation Harness):** El conjunto restringido de archivos (interfaces, modelos, tests) que definen el foco de la tarea.
*   **Atomic Task Definition:** Los detalles técnicos y de comportamiento (BDD) que debe cumplir la pieza de software.
*   **TDD Standards & Linters:** Las reglas de calidad, estilo y tipos que el código debe superar.

## Proceso (Process)
*   **Validación del Sandbox (paso previo obligatorio):** Antes de iniciar el ciclo Red-Green-Refactor, verificar la integridad del entorno recibido del 060:
    1.  Confirmar que el `Isolation Report` existe y tiene estado `SUCCESS` (no `FAILED` ni ausente).
    2.  Verificar que los archivos listados en el `Filtered Workspace View` están presentes y corresponden a los esperados por la `Atomic Task Definition`.
    3.  Si cualquiera de estas verificaciones falla, detener la ejecución y reportar al 050 (Iteration Harness) con el detalle del fallo. No ejecutar código en un sandbox cuya integridad no ha sido confirmada.
*   **Fase RED (Escritura del Test):** Escribir el test automatizado que falle, basado estrictamente en el comportamiento esperado y los contratos de la tarea.
*   **Fase GREEN (Implementación Mínima):** Escribir la cantidad mínima de código necesaria para que el test pase, respetando el contexto estricto y los patrones de diseño definidos.
*   **Fase REFACTOR (Optimización):** Limpiar y estructurar el código sin alterar su comportamiento, asegurando que siga los estándares de calidad del proyecto.
*   **Validación Local en Sandbox:** Ejecutar la suite de pruebas dentro del entorno aislado para confirmar el éxito de la tarea.

## Salidas (Outputs - Artefactos)
*   **Verified Code Patch:** El código de producción limpio y funcional.
*   **Passed Test Suite:** El archivo de test que valida la nueva funcionalidad.
*   **Execution Evidence:** Reporte de los tests ejecutados y los resultados de los linters dentro del sandbox.
*   **Task Completion Signal:** Notificación de que la micro-tarea ha sido resuelta exitosamente y está lista para ser integrada por el sistema superior.
