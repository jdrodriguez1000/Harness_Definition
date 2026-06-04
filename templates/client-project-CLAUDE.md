## INICIO OBLIGATORIO DE SESIÓN

Al iniciar cualquier sesión, **antes de responder al usuario**, determinar qué harness ejecutar y gestionar su ciclo de interacción completo.

**Los pasos detallados de cada ciclo están en `.claude/workflows/`. Leer el archivo correspondiente antes de ejecutar cualquier ciclo:**
- Ciclo 010 → `.claude/workflows/ciclo_010_discovery.md`
- Ciclo 020 → `.claude/workflows/ciclo_020_specification.md`
- Ciclo 030 → `.claude/workflows/ciclo_030_design.md`
- Ciclo 040 → `.claude/workflows/ciclo_040_planning.md`

**Paso 1 — Verificar si existe `persistence/harness-state.json`:**

- **No existe** → leer `.claude/workflows/ciclo_010_discovery.md` y ejecutar el **Ciclo 010 Discovery** (el 010 aún no ha comenzado).
- **Existe e íntegro** → continuar al Paso 2.
- **Existe pero corrupto** → notificar al usuario con el error exacto. No continuar.

**Paso 2 — Identificar la primera fase sin `PHASE_COMPLETE`:**

```
Si  harness-state["status"] != "PHASE_COMPLETE"
    → Leer `.claude/workflows/ciclo_010_discovery.md` y ejecutar Ciclo 010 Discovery

Si  harness-state["status"] == "PHASE_COMPLETE"
    Y harness-state["020_specification"] no existe:

    Si  harness-state["handoff_020"]["status"] == "PENDING_HANDOFF":
        → Preguntar al humano: "El 010 Discovery está completo.
          ¿Deseas continuar ahora con el 020 Specification Harness?"
        Si sí:
          Ejecutar: & "$env:HARNESS_DEPLOY_SCRIPT" -Harness 020 -Destino (Get-Location).Path
          Verificar que el deploy tuvo éxito: Test-Path ".claude/agents/specification-governor.md"
          Si la verificación pasa:
            Actualizar harness-state["handoff_020"]["status"] = "DEPLOYED" en persistence/harness-state.json
            Notificar: "Deploy del 020 completado. Reinicia la sesión de Claude Code en este directorio y ejecuta /forge-restart para continuar."
          Si la verificación falla:
            Notificar: "El script de deploy no copió los agentes del 020 correctamente (.claude/agents/specification-governor.md no existe). El estado NO fue actualizado. Ejecuta manualmente: & '$env:HARNESS_DEPLOY_SCRIPT' -Harness 020 -Destino '<ruta del proyecto>' y luego reinicia."
          Fin.
        Si no:
          Notificar: "Cuando quieras continuar, abre Claude Code aquí y te lo preguntaré."
          Fin.

    Si  harness-state["handoff_020"]["status"] == "DEPLOYED":
        → El deploy ya se ejecutó. Leer `.claude/workflows/ciclo_020_specification.md` y ejecutar Ciclo 020 Specification directamente.

    Si  harness-state["handoff_020"] no existe:
        → El 010 cerró pero el handoff fue interrumpido. Leer `.claude/workflows/ciclo_010_discovery.md` y ejecutar Ciclo 010 Discovery
          con INIT para que complete el cierre y ofrezca el handoff.

Si  harness-state["020_specification"] existe
    Y harness-state["020_specification"]["status"] != "PHASE_COMPLETE"
    → Leer `.claude/workflows/ciclo_020_specification.md` y ejecutar Ciclo 020 Specification

Si  harness-state["020_specification"]["status"] == "PHASE_COMPLETE"
    Y harness-state["030_design"] no existe:

    Si  harness-state["handoff_030"]["status"] == "PENDING_HANDOFF":
        → Preguntar al humano: "El 020 Specification está completo.
          ¿Deseas continuar ahora con el 030 Design Harness?"
        Si sí:
          Ejecutar: & "$env:HARNESS_DEPLOY_SCRIPT" -Harness 030 -Destino (Get-Location).Path
          Verificar que el deploy tuvo éxito: Test-Path ".claude/agents/design-governor.md"
          Si la verificación pasa:
            Actualizar harness-state["handoff_030"]["status"] = "DEPLOYED" en persistence/harness-state.json
            Notificar: "Deploy del 030 completado. Reinicia la sesión de Claude Code en este directorio y ejecuta /forge-restart para continuar."
          Si la verificación falla:
            Notificar: "El script de deploy no copió los agentes del 030 correctamente (.claude/agents/design-governor.md no existe). El estado NO fue actualizado. Ejecuta manualmente: & '$env:HARNESS_DEPLOY_SCRIPT' -Harness 030 -Destino '<ruta del proyecto>' y luego reinicia."
          Fin.
        Si no:
          Notificar: "Cuando quieras continuar, abre Claude Code aquí y te lo preguntaré."
          Fin.

    Si  harness-state["handoff_030"]["status"] == "DEPLOYED":
        → El deploy ya se ejecutó. Leer `.claude/workflows/ciclo_030_design.md` y ejecutar Ciclo 030 Design directamente.

    Si  harness-state["handoff_030"] no existe:
        → El 020 cerró pero el handoff fue interrumpido. Leer `.claude/workflows/ciclo_020_specification.md` y ejecutar Ciclo 020 Specification
          para que complete el cierre y ofrezca el handoff.

Si  harness-state["030_design"] existe
    Y harness-state["030_design"]["status"] != "PHASE_COMPLETE"
    → Leer `.claude/workflows/ciclo_030_design.md` y ejecutar Ciclo 030 Design

Si  harness-state["030_design"]["status"] == "PHASE_COMPLETE"
    Y harness-state["040_planning"] no existe:

    Si  harness-state["handoff_040"]["status"] == "PENDING_HANDOFF":
        → Preguntar al humano: "El 030 Design está completo.
          ¿Deseas continuar ahora con el 040 Planning Harness?"
        Si sí:
          Ejecutar: & "$env:HARNESS_DEPLOY_SCRIPT" -Harness 040 -Destino (Get-Location).Path
          Verificar que el deploy tuvo éxito: Test-Path ".claude/agents/planning-governor.md"
          Si la verificación pasa:
            Actualizar harness-state["handoff_040"]["status"] = "DEPLOYED" en persistence/harness-state.json
            Notificar: "Deploy del 040 completado. Reinicia la sesión de Claude Code en este directorio y ejecuta /forge-restart para continuar."
          Si la verificación falla:
            Notificar: "El script de deploy no copió los agentes del 040 correctamente (.claude/agents/planning-governor.md no existe). El estado NO fue actualizado. Ejecuta manualmente: & '$env:HARNESS_DEPLOY_SCRIPT' -Harness 040 -Destino '<ruta del proyecto>' y luego reinicia."
          Fin.
        Si no:
          Notificar: "Cuando quieras continuar, abre Claude Code aquí y te lo preguntaré."
          Fin.

    Si  harness-state["handoff_040"]["status"] == "DEPLOYED":
        → El deploy ya se ejecutó. Leer `.claude/workflows/ciclo_040_planning.md` y ejecutar Ciclo 040 Planning directamente.

    Si  harness-state["handoff_040"] no existe:
        → El 030 cerró pero el handoff fue interrumpido. Leer `.claude/workflows/ciclo_030_design.md` y ejecutar Ciclo 030 Design
          con INIT para que complete el cierre y ofrezca el handoff.

Si  harness-state["040_planning"] existe
    Y harness-state["040_planning"]["status"] != "PHASE_COMPLETE"
    → Leer `.claude/workflows/ciclo_040_planning.md` y ejecutar Ciclo 040 Planning

Si  todos los harnesses activos están en PHASE_COMPLETE
    → Notificar al usuario: "Todos los harnesses activos están completos."
```

Esta verificación es automática en cada sesión. No preguntar al usuario qué hacer.
No esperar ninguna frase especial del usuario para arrancar.

---

## REGLAS DE OPERACIÓN

- Todo el trabajo de cada fase se realiza a través de los governors. No ejecutar tareas técnicas directamente.
- Los archivos en `persistence/` son propiedad del harness. No modificarlos manualmente.
- Los artefactos en `010_discovery/`, `020_specification/` y `030_design/` son los outputs oficiales de sus fases. No editarlos fuera del flujo del harness.

## PRINCIPIOS DE COMPORTAMIENTO DE TODO AGENTE

**PI-1. Razona antes de actuar.** Exponer pros, contras y suposiciones. Ante ambigüedad, detener y consultar.
**PI-2. Simplicidad primero.** Código mínimo con interfaces simples. Sin abstracciones no solicitadas.
**PI-3. Cambios quirúrgicos.** Solo tocar lo necesario. No refactorizar lo que funciona.
**PI-4. Slices verticales.** Una funcionalidad completa a la vez. Validar integración con Tracer Bullet.
**PI-5. Orientado a comportamiento.** Toda tarea tiene un test que la respalda.
