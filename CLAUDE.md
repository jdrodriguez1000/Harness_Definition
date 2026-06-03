## INICIO OBLIGATORIO DE SESIÓN

**Antes de cualquier otra acción, leer:** `support/avance.md`

Este archivo contiene el estado actual del proyecto, las decisiones tomadas y
los próximos pasos. Ninguna tarea puede comenzar sin haberlo leído.

**Si la tarea involucra crear o modificar archivos en `.claude/agents/` o `.claude/skills/`,
leer también `support/lessons_learned.md` antes de escribir cualquier línea.**

---

## PRINCIPIOS DE INGENIERÍA

Es obligatorio seguir estos principios:

**PI-1. Razona antes de actuar.** Debes exponer pros, contras y suposiciones. Ante ambigüedad, detente y consulta; nunca elijas en silencio.

**PI-2. Simplicidad primero.** Código mínimo con interfaces simples. Sin abstracciones, parámetros ni configurabilidad no solicitados.

**PI-3. Cambios quirúrgicos.** Solo toca lo necesario para la tarea. No refactorices lo que funciona. No borres código muerto preexistente sin autorización.

**PI-4. Slices verticales.** Una funcionalidad completa (datos→interfaz) a la vez. Valida integración con un "Tracer Bullet" antes de ampliar.

**PI-5. Orientado a comportamiento.** Toda tarea tiene un test que la respalda. Definición de Terminado = test en verde. Sin excepción.

---

## CONSTRUCCIÓN DE HARNESSES

Al crear o modificar agentes y skills, verificar contra `support/lessons_learned.md`.
Los invariantes críticos (detalle completo en ese archivo):

- **LL-01** Workers: el Write del artefacto es el **primer tool call** tras completar el trabajo. Sin excepción.
- **LL-02** Orchestrators: sección "REGLAS DE ESCRITURA" con DETENTE explícito para carpetas de Workers.
- **LL-03** Evaluadores: bloque "PATHS DE SALIDA — OBLIGATORIO" al inicio de "Al terminar".
- **LL-04** Governors (Cierre): precondición que verifica `eval/verdict.json` con entrada del harness antes de cualquier paso del cierre.
- **LL-05** Timestamps: sección al inicio del agente con el comando PowerShell real. Nunca valores fijos.
- **LL-06** Checkpoints: protocolo de 5 pasos — leer → actualizar → escribir → verificar → bloquear si falla.
- **LL-07** Evaluadores: dos fases obligatorias — análisis con citas concretas primero, score después.
- **LL-10** Governors: Single Writer Rule — nunca escribir en las carpetas de artefactos de los Workers.