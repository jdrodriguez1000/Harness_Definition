# Comando /flag — Registrar ajuste pendiente

Registra un nuevo ajuste en `support/ajustes.md` a partir del problema o desviación
que el usuario ya describió en la conversación activa.

## Pasos obligatorios

1. **Leer `support/ajustes.md`** para:
   - Identificar el último ID ADJ-XX usado en la Tabla de Estado.
   - Determinar el siguiente número disponible (ADJ-XX + 1).

2. **Inferir desde el contexto de la conversación:**
   - **Título breve** — una línea que nombra el problema o desviación encontrada.
   - **Descripción** — qué ocurrió, qué patrón se violó o qué comportamiento fue incorrecto.
   - **Impacto** — qué agentes, skills, artefactos o workflows se ven afectados.
   - **Prerequisitos** — qué debe existir o completarse antes de poder implementar el ajuste. Si no aplica, escribir "Ninguno".

3. **Determinar la prioridad** — si el contexto no la hace evidente, preguntar al usuario:
   - `CRÍTICA` — bloquea el funcionamiento correcto del harness
   - `SIGNIFICATIVA` — afecta calidad o comportamiento esperado pero no bloquea
   - `MENOR` — mejora deseable, no urgente

4. **Escribir en `support/ajustes.md`** en dos lugares:

   a. **Tabla de Estado** — agregar fila al final de la tabla:
   ```
   | ADJ-XX | <Título breve> | <PRIORIDAD> | PENDIENTE |
   ```

   b. **Sección Detalle** — agregar entrada al final del archivo:
   ```
   ### ADJ-XX — <Título breve> — PENDIENTE

   **Prioridad:** <PRIORIDAD>

   **Descripción:**
   <Qué problema resuelve o qué comportamiento cambia>

   **Impacto:**
   <Qué artefactos o agentes se ven afectados>

   **Prerequisitos antes de implementar:**
   <Si aplica — qué debe existir o completarse primero>
   ```

5. **Confirmar** al usuario el ID asignado: `ADJ-XX registrado en support/ajustes.md`.

## Reglas

- Inferir el contenido desde el contexto de la conversación activa, no inventar.
- Si la conversación no tiene suficiente contexto para un campo, usar un placeholder
  descriptivo entre corchetes: `[completar — describir el impacto concreto]`.
- No modificar entradas existentes — solo agregar al final de la tabla y al final del Detalle.
- El campo Estado en la tabla siempre es `PENDIENTE` al crear una entrada nueva.
- Mantener el tono y formato exacto de las entradas previas del archivo.
