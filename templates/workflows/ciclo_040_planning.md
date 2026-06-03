## Ciclo 040 Planning

El ciclo completo de interacción para el 040 Planning Harness.

### Paso A — Orientación

Invocar `planning-governor` como subagente (`subagent_type: "planning-governor"`) con:
```
[MODO: INIT]
Directorio de trabajo: <path absoluto>
```

Si hay ajuste de Sprint Contract solicitado por el usuario, incluir en el prompt:
```
adjustment_request: <descripción de los ajustes solicitados>
```

Leer el `GOVERNOR_RESULT` y ramificar:

- **`SPRINT_CONTRACT_READY`** → ejecutar el **Loop de Sprint Contract** (Paso B)
- **`RESUME_AT_EXECUTE`** → invocar governor en EXECUTE directamente (Paso C), sin presentar Sprint Contract
- **`RESUME_AT_CP03`** → presentar CP-03 directamente (Paso D), sin ejecutar workers
- **`RESUME_AT_CP04`** → presentar CP-04 directamente (Paso E), sin pasar por CP-03
- **`CLOSURE_READY`** → retomada tras auditoría interrumpida → ejecutar Paso F (Cierre)
- **`RESUME_HOLD`** → notificar al usuario: "El harness está en HOLD. Requiere intervención manual antes de continuar." Detener.
- **`ALREADY_COMPLETE`** → notificar al usuario: "El 040 Planning ya está completo." Fin.
- **`INIT_FAILED`** → notificar al usuario con el `error` del resultado. Detener.

### Paso B — Loop de Sprint Contract

Usando el texto de `sprint_contract` del `GOVERNOR_RESULT`, presentar al usuario con `AskUserQuestion`:

```
[SPRINT CONTRACT — 040 Planning Harness]

<texto completo del sprint_contract del GOVERNOR_RESULT — incluye VS draft del 030 y disponibilidad de inputs>

¿Apruebas este Sprint Contract para comenzar, necesitas algún ajuste, o deseas cancelar?
```

**Si el usuario aprueba:**
→ Continuar al Paso C.

**Si el usuario solicita ajustes:**
→ Volver al Paso A incluyendo `adjustment_request` con los cambios solicitados.
→ El governor retornará un nuevo `SPRINT_CONTRACT_READY`.
→ Repetir hasta aprobación o cancelación.

**Si el usuario usa `/forge-override "texto"`:**
→ El comando habrá registrado el override y retornado `FORGE_OVERRIDE_RESULT`.
→ Volver al Paso A incluyendo en el prompt:
  `adjustment_request: <constraint_str del FORGE_OVERRIDE_RESULT>`
→ El governor incorpora la restricción como constraint duro en el nuevo Sprint Contract.
→ Repetir el loop hasta aprobación.

**Si el usuario cancela:**
→ Notificar: "El harness 040 Planning ha sido cancelado. El estado queda en PENDING_CONTRACT."
→ Detener.

### Paso C — Ejecución técnica

Invocar `planning-governor` con:
```
[MODO: EXECUTE]
Directorio de trabajo: <path absoluto>
sprint_contract_approved: true
```

Mientras el governor ejecuta los workers el usuario puede ver el progreso en `persistence/claude-progress.txt`.

Leer el `GOVERNOR_RESULT`:

- **`EXECUTION_COMPLETE`** → continuar al Paso D.
- **`EXECUTION_FAILED`** → notificar al usuario:
  ```
  La ejecución de los workers falló.
  Error: <error del GOVERNOR_RESULT>
  Revisa persistence/claude-progress.txt para el detalle.
  ```
  Detener.

### Paso D — Gate CP-03 (revisión de draft)

Registrar en `persistence/claude-progress.txt`:
```
[CP-03 PRE-GATE 040] <timestamp> — Presentando 3 artefactos al cliente para revisión.
```

Preparar el mensaje de presentación. Si el `GOVERNOR_RESULT` incluye `review_status: HAS_MINOR_ISSUES`, agregar el diagnóstico del reviewer:

```
El 040 Planning Harness ha producido los siguientes documentos para tu revisión:

- Vertical Slice Plan: /040_planning/vertical_slice_plan.md
- Project Roadmap:     /040_planning/project_roadmap.md
- Risk Register:       /040_planning/risk_register.md

[Si review_status == HAS_MINOR_ISSUES:]
Nota: el revisor detectó los siguientes issues menores (no bloqueantes):
<minor_issues_summary del GOVERNOR_RESULT>

¿Los apruebas tal como están, o necesitas cambios antes de la aprobación formal?
```

Presentar con `AskUserQuestion`.

**Si el usuario aprueba o pide cambios menores:**
→ Invocar `planning-governor` con:
```
[MODO: POST_CP03]
cp03_decision: approved
```
→ Leer `GOVERNOR_RESULT`. Si `CP04_READY` → continuar al Paso E.

**Si el usuario pide cambios sustanciales:**
→ Invocar `planning-governor` con:
```
[MODO: POST_CP03]
cp03_decision: rework
changes: <descripción exacta de los cambios solicitados y artefacto(s) afectado(s)>
```
→ Leer `GOVERNOR_RESULT`. Si `REWORK_COMPLETE` → volver a presentar CP-03:
```
Los artefactos fueron actualizados con los cambios solicitados. Por favor revisa nuevamente:
[misma lista de artefactos]
¿Los apruebas ahora?
```
→ Repetir Paso D hasta aprobación.

**Si el usuario usa `/forge-override "texto"`:**
→ El comando habrá registrado el override y retornado `FORGE_OVERRIDE_RESULT`.
→ Invocar `planning-governor` con:
```
[MODO: POST_CP03]
cp03_decision: rework
changes: <constraint_str del FORGE_OVERRIDE_RESULT>
```
→ El governor re-ejecuta el worker afectado con la restricción como constraint duro (no negociable).
→ Si `REWORK_COMPLETE` → volver a presentar CP-03.

### Paso E — Gate CP-04 (aprobación formal) — SIEMPRE independiente de CP-03 (LL-25)

REGLA ESTRUCTURAL: Este gate siempre se presenta como un `AskUserQuestion` separado, incluso si la respuesta al CP-03 ya incluía lenguaje de aprobación total.

Registrar en `persistence/claude-progress.txt`:
```
[CP-04 PRE-GATE 040] <timestamp> — Presentando gate de aprobación formal CP-04.
```

Presentar al usuario con `AskUserQuestion`:

```
¿Apruebas formalmente el plan maestro del proyecto (Vertical Slice Plan, Project Roadmap y Risk Register) como la base de ejecución para el desarrollo del sistema?

(Esta es la aprobación formal — diferente a la revisión de draft que acabas de hacer.)
```

**Si el usuario aprueba:**
→ Invocar `planning-governor` con:
```
[MODO: POST_CP04]
cp04_approved: true
cp04_citation: <cita textual de la respuesta de aprobación del usuario>
```
→ Leer `GOVERNOR_RESULT`:
  - `CLOSURE_READY` → continuar al Paso F.
  - `CP04_DECLINED` → presentar de nuevo (sin contar como rechazo).
  - `ESCALATION_REQUIRED` → notificar: "La fase queda en HOLD. Se requiere intervención manual." Detener.
  - `REWORK_AFTER_REJECTION` → volver al Paso D (el evaluador rechazó, rework ejecutado).
  - `STRATEGIC_REJECTION` → volver al Paso B (Sprint Contract requiere revisión estratégica).

**Si el usuario declina:**
→ Invocar governor con `cp04_approved: false`.
→ Si `CP04_DECLINED`: volver a presentar CP-04 (máximo 3 veces antes de ESCALATION).

### Paso F — Cierre y Handoff

Presentar al usuario con `AskUserQuestion`:

```
La evaluación del 040 Planning Harness está completa.

Resultado: <decision del verdict — APPROVED/REJECTED>
Score: <score> (<dimensiones D1..D5>)

Artefactos producidos:
- 040_planning/vertical_slice_plan.md
- 040_planning/project_roadmap.md
- 040_planning/risk_register.md

¿Deseas iniciar ahora el 050 Vertical Harness?
```

Invocar `planning-governor` con:
```
[MODO: CLOSE]
handoff_decision: yes | no
```

Leer `GOVERNOR_RESULT`:

- **`HANDOFF_READY`**: Notificar al usuario:
  ```
  Deploy del 050 completado. Reinicia la sesión de Claude Code en este directorio y ejecuta /forge-restart para continuar.
  ```
  Fin de la sesión actual.

- **`PHASE_COMPLETE_NO_HANDOFF`**: Notificar:
  ```
  Fase 040 Planning completa. La próxima vez que abras Claude Code aquí, te preguntaré si deseas continuar con el 050.
  ```
  Fin.

- **`CLOSE_BLOCKED`**: Notificar al usuario y detener. Requiere intervención manual.
