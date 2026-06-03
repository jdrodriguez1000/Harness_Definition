# Iteration Harness (Gestión de Micro-Ciclos)

El objetivo de este arnés es operar el bucle de trabajo táctico. Toma el alcance estratégico de la iteración actual y lo descompone en unidades de trabajo atómicas, gestionando su ejecución mediante una disciplina estricta de TDD.

## Rol en la Jerarquía de Arneses
Este arnés actúa como **Instancia B (Orquestador)** respecto al `060_isolation_harness` y al `070_execution_harness`. No son arneses independientes que se activan secuencialmente desde afuera: el 050 los spawea como Workers especializados para cada micro-tarea, recibe sus outputs como referencias (paths a artefactos), y reporta el avance a su orquestador superior (Instancia A del ciclo de gobernanza). El 060 y el 070 nunca se activan directamente sin pasar por el 050.

## Entradas (Inputs)
*   **Iteration Scope (del Planning Harness):** El contrato que define qué escenarios y componentes deben construirse en este ciclo.
*   **Artefactos de Diseño y Especificación Relacionados:** Los detalles técnicos y de producto específicos para el alcance de la iteración.
*   **Estado Actual del Código (Baseline):** La base de código verificada resultante de la iteración anterior.
*   **Entorno de Verificación:** Suite de tests, linters y herramientas de automatización listas.

## Proceso (Process)
*   **Desglose Atómico (Destrucción de Complejidad):** Dividir el alcance de la iteración en micro-tareas independientes (ej. "Crear test para X", "Implementar interfaz Y", "Refactorizar Z").
*   **Gestión del Micro-Ciclo (TDD Loop):** Orquestar el flujo *Red-Green-Refactor* para cada micro-tarea, asegurando que ninguna tarea se dé por terminada sin su validación.
*   **Ajuste Táctico Dinámico:** Capacidad de re-planificar las micro-tareas dentro de la iteración si se descubre un impedimento técnico o una oportunidad de mejora, sin alterar el Roadmap estratégico.
*   **Validación Continua de Integración:** Asegurar que cada nueva pieza de código no rompa la funcionalidad construida en micro-tareas o iteraciones previas.

## Salidas (Outputs - Artefactos)
*   **Atomic Task List (Backlog Táctico):** Listado vivo de micro-tareas para la ejecución inmediata.
*   **Verified Source Code:** Código de producción que cumple con los contratos de la iteración y los estándares de calidad.
*   **Local Test Report:** Resultado de la ejecución de pruebas que valida que la micro-tarea actual es exitosa.
*   **Iteration Validation Record:** Documento o reporte que confirma que todos los criterios de aceptación del *Iteration Scope* han sido cumplidos.