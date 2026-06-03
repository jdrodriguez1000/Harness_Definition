## Ciclo 030 Design

El ciclo completo de interacción para el 030 Design Harness.

### Paso A — Orientación

Invocar `design-governor` como subagente (`subagent_type: "design-governor"`) con:
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
- **`ALREADY_COMPLETE`** → notificar al usuario: "El 030 Design ya está completo." Fin.
- **`INIT_FAILED`** → notificar al usuario con el `error` del resultado. Detener.

### Paso B — Loop de Sprint Contract

Usando el texto de `sprint_contract` del `GOVERNOR_RESULT`, presentar al usuario con `AskUserQuestion`:

```
[SPRINT CONTRACT — 030 Design Harness]

<texto completo del sprint_contract del GOVERNOR_RESULT — incluye restricciones tecnológicas>

¿Apruebas este Sprint Contract para comenzar, necesitas algún ajuste, o deseas cancelar?
```

**Si el usuario aprueba:**
→ Continuar al Paso C.

**Si el usuario solicita ajustes:**
→ Volver al Paso A incluyendo `adjustment_request` con los cambios solicitados.
→ El governor retornará un nuevo `SPRINT_CONTRACT_READY`.
→ Repetir hasta aprobación o cancelación.

**Si el usuario cancela:**
→ Notificar: "El harness 030 Design ha sido cancelado. El estado queda en PENDING_CONTRACT."
→ Detener.

### Paso C — Ejecución técnica

Invocar `design-governor` con:
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
[CP-03 PRE-GATE 030] <timestamp> — Presentando 5 artefactos al cliente para revisión.
```

Preparar el mensaje de presentación. Si el `GOVERNOR_RESULT` incluye `review_status: HAS_MINOR_ISSUES`, agregar el diagnóstico del reviewer:

```
El 030 Design Harness ha producido los siguientes documentos para tu revisión:

- Architecture Decision Records: /design/architecture_decision_records.md
- Technical Blueprint: /design/technical_blueprint.md
- Contract Definitions: /design/contract_definitions.md
- Dependency Graph: /design/dependency_graph.md
- Test Strategy Map: /design/test_strategy_map.md

[Si review_status == HAS_MINOR_ISSUES:]
Nota: el revisor detectó los siguientes issues menores (no bloqueantes):
<minor_issues_summary del GOVERNOR_RESULT>

¿Los apruebas tal como están, o necesitas cambios antes de la aprobación formal?
```

Presentar con `AskUserQuestion`.

**Si el usuario aprueba o pide cambios menores:**
→ Invocar `design-governor` con:
```
[MODO: POST_CP03]
cp03_decision: approved
```
→ Leer `GOVERNOR_RESULT`. Si `CP04_READY` → continuar al Paso E.

**Si el usuario pide cambios sustanciales:**
→ Invocar `design-governor` con:
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

### Paso E — Gate CP-04 (aprobación formal) — SIEMPRE independiente de CP-03 (ADJ-16 / LL-25)

REGLA ESTRUCTURAL: Este gate siempre se presenta como un `AskUserQuestion` separado, incluso si la respuesta al CP-03 ya incluía lenguaje de aprobación total.

Registrar en `persistence/claude-progress.txt`:
```
[CP-04 PRE-GATE 030] <timestamp> — Presentando gate de aprobación formal CP-04.
```

Presentar al usuario con `AskUserQuestion`:

```
¿Apruebas formalmente el plano arquitectónico técnico como la base de diseño para la implementación del sistema?

(Esta es la aprobación formal — diferente a la revisión de draft que acabas de hacer.)
```

**Si el usuario aprueba:**
→ Invocar `design-governor` con:
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
La evaluación del 030 Design Harness está completa.

Resultado: <decision del verdict — APPROVED/REJECTED>
Score: <score> (<dimensiones D1..D5>)

Artefactos producidos:
- design/architecture_decision_records.md
- design/technical_blueprint.md
- design/contract_definitions.md
- design/dependency_graph.md
- design/test_strategy_map.md

¿Deseas iniciar ahora el 040 Planning Harness?
```

Invocar `design-governor` con:
```
[MODO: CLOSE]
handoff_decision: yes | no
```

Leer `GOVERNOR_RESULT`:

- **`HANDOFF_READY`**: Notificar al usuario:
  ```
  Deploy del 040 completado. Para continuar, reinicia la sesión de Claude Code en este directorio.
  El CLAUDE.md detectará automáticamente el estado y lanzará el governor del 040.
  ```
  Fin de la sesión actual.

- **`PHASE_COMPLETE_NO_HANDOFF`**: Notificar:
  ```
  Fase 030 Design completa. La próxima vez que abras Claude Code aquí, te preguntaré si deseas continuar con el 040.
  ```
  Fin.

- **`CLOSE_BLOCKED`**: Notificar al usuario y detener. Requiere intervención manual.
