# Isolation Harness (Aislamiento y Contexto Estricto)

El objetivo de este arnés es actuar como el especialista en seguridad y foco. Su misión es preparar un entorno de trabajo efímero, seguro y restringido, asegurando que la IA solo tenga acceso a la información estrictamente necesaria para su tarea y que cualquier error quede contenido sin afectar el proyecto principal.

## Entradas (Inputs)
*   **Atomic Task (del Iteration Harness):** La micro-tarea específica a ejecutar.
*   **Context Definition (del Design Harness):** El listado de archivos, interfaces y contratos que son necesarios para resolver la tarea.
*   **Base de Código Principal (Source of Truth):** El estado actual y verificado del repositorio.
*   **Políticas de Seguridad:** Reglas sobre qué comandos y qué tipo de acceso tiene permitido la IA.

## Proceso (Process)
*   **Creación del Sandbox (Aislamiento Total):** Generación de un entorno efímero (una rama feature limpia, un contenedor o un volumen aislado) que sea una copia fiel pero independiente del proyecto.
*   **Aplicación de Contexto Estricto (Strict Context):** Filtrado del sistema de archivos para que la IA solo pueda "ver" y modificar los archivos definidos en el input de contexto. Se oculta el resto del software para eliminar distracciones y prevenir alucinaciones.
*   **Inyección de Dependencias de Tarea:** Proveer al sandbox únicamente de los mocks, stubs o librerías necesarias para que la tarea sea ejecutable en aislamiento.
*   **Monitoreo de Recursos:** Supervisión del entorno para detectar bucles infinitos, consumo excesivo de memoria o intentos de acceso a zonas restringidas del sistema.

## Política de Fallback del Sandbox
Si el entorno sandbox no puede crearse, el arnés sigue este protocolo en orden:
1.  **Reintento (x2):** Reintentar la creación del sandbox hasta 2 veces. Cubre fallos transitorios como conflictos de ramas o dependencias temporalmente no disponibles.
2.  **Fallback:** Si el reintento falla, intentar crear el sandbox en un entorno alternativo previamente definido (ej: rama temporal distinta, volumen de respaldo, contenedor secundario).
3.  **Escalamiento:** Si el fallback también falla, detener la tarea y emitir el `Isolation Report` con estado `FAILED`, detallando la causa. El 050 (Iteration Harness) recibe esta referencia y es responsable de escalar al humano. No se transfiere un sandbox degradado al 070.

## Salidas (Outputs - Artefactos)
*   **Enclosed Sandbox Environment:** El espacio de trabajo seguro y listo para la construcción.
*   **Filtered Workspace View:** La vista restringida de archivos que garantiza el foco total de la IA.
*   **Isolation Report:** Confirmación técnica de que el entorno es seguro y el contexto ha sido aplicado correctamente.
