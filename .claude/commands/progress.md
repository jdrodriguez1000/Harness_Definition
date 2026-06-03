# Comando /progress — Actualizar bitácora de sesión

Actualiza `support/avance.md` para registrar el trabajo de la sesión actual y dejar
el archivo listo para que un nuevo agente en una sesión futura arranque con contexto completo.

## Pasos obligatorios

1. **Leer `support/avance.md`** para conocer el número de la última sesión registrada
   y el estado actual del proyecto.

2. **Determinar el número de sesión actual** — es el número de la última sesión + 1.

3. **Actualizar el bloque "Estado General"** al inicio del archivo:
   - `Fecha de última actualización` → fecha de hoy + número de sesión actual
   - `Fase actual` → descripción actualizada del estado real tras esta sesión
   - `Estado` → texto actualizado que refleje lo que está completo y lo que sigue

4. **Agregar una entrada nueva en "Historial de Sesiones"** con esta estructura:

   ```
   ### Sesión N — YYYY-MM-DD

   **Objetivo:** [qué se buscaba lograr en esta sesión]

   **Trabajo realizado:**
   [lista de cambios, decisiones y archivos modificados]

   **Decisiones clave:**
   | Decisión | Detalle |
   |----------|---------|
   | ...      | ...     |
   ```

5. **Actualizar la sección "Próximos Pasos"** — reemplazar los pasos ya completados
   en esta sesión con los nuevos pasos que emergen. Si no hay nuevos pasos pendientes,
   indicarlo explícitamente.

6. **Actualizar el árbol del repositorio** si se crearon o eliminaron archivos en esta sesión.

## Reglas

- Inferir el contenido de la sesión desde el contexto de la conversación activa.
- Si hay ambigüedad sobre qué incluir, priorizar decisiones de diseño y cambios a archivos
  de infraestructura (agents, skills, templates, harnesses). Los cambios menores de texto
  pueden agruparse en una sola línea.
- No borrar entradas del historial existente — solo agregar al final del historial.
- Mantener el tono y formato exacto de las entradas previas del historial.
