## Ciclo 050 Vertical

El ciclo completo de interacción para el 050 Vertical Harness.

### Paso A — Orientación

**PRECONDICIÓN — verificar governor disponible (ADJ-34):**
Verificar que `.claude/agents/vertical-governor.md` existe en el directorio de trabajo:
```powershell
Test-Path ".claude/agents/vertical-governor.md"
```
Si no existe: detener con este mensaje exacto y no continuar bajo ninguna circunstancia:
```
El agente vertical-governor.md no está disponible en .claude/agents/. El harness 050 puede no estar correctamente desplegado en este directorio. Ejecuta: & "$env:HARNESS_DEPLOY_SCRIPT" -Harness 050 -Destino "<ruta del proyecto>" y luego reinicia la sesión.
```

Invocar `vertical-governor` como subagente (`subagent_type: "vertical-governor"`) con:
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
- **`CLOSURE_READY`** → retomada tras auditoría interrumpida → ejecutar Paso F (Cierre de Slice)
- **`PHASE_COMPLETE_READY`** → todas las slices completaron el ciclo 050→060→070 → ejecutar Paso F (Cierre Total)
- **`RESUME_AT_060_HANDOFF`** → hay un handoff al 060 pendiente. Presentar al usuario con `AskUserQuestion`:
  ```
  La slice <slice del GOVERNOR_RESULT> está DOCS_READY. El handoff al 060 Isolation Harness está pendiente.
  ¿Deseas iniciarlo ahora?
  ```
  Si sí: invocar governor con `[MODO: CLOSE]` / `close_type: SLICE` / `handoff_decision: yes` → ir al bloque "Retorno de Cierre de Slice" en Paso F.
  Si no: notificar "Cuando quieras continuar, abre Claude Code aquí y te lo preguntaré." Fin.
- **`SUSPEND_DETECTED`** → notificar al usuario:
  ```
  El harness 050 Vertical estaba suspendido.
  Contexto: <context_note del GOVERNOR_RESULT>
  Para reanudar: <resume_instruction del GOVERNOR_RESULT>
  Suspendido el: <suspended_at del GOVERNOR_RESULT>

  Ejecuta /forge-continue para reanudar desde el punto de interrupción.
  ```
  Fin.
- **`RESUME_HOLD`** → notificar al usuario: "El harness está en HOLD para la slice activa. Requiere intervención manual antes de continuar." Detener.
- **`ALREADY_COMPLETE`** → notificar al usuario: "El 050 Vertical ya está completo. Todas las slices completaron el ciclo 050→060→070." Fin.
- **`INIT_FAILED`** → notificar al usuario con el `error` del resultado. Detener.

### Paso B — Loop de Sprint Contract

Usando el texto de `sprint_contract` del `GOVERNOR_RESULT`, presentar al usuario con `AskUserQuestion`:

```
[SPRINT CONTRACT — 050 Vertical Harness]

<texto completo del sprint_contract del GOVERNOR_RESULT — incluye scope de la slice activa, IC-xx, BDD scenarios y disponibilidad de los 17 inputs>

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
→ Notificar: "El harness 050 Vertical ha sido cancelado para la slice actual. El estado queda en PENDING_CONTRACT."
→ Detener.

### Paso C — Ejecución técnica

Invocar `vertical-governor` con:
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
  La ejecución de los workers falló para la slice activa.
  Error: <error del GOVERNOR_RESULT>
  Revisa persistence/claude-progress.txt para el detalle.
  ```
  Detener.

### Paso D — Gate CP-03 (revisión de draft)

Registrar en `persistence/claude-progress.txt`:
```
[CP-03 PRE-GATE 050] <timestamp> — Presentando 5 artefactos de <slice_activa> al cliente para revisión.
```

Preparar el mensaje de presentación. Si el `GOVERNOR_RESULT` incluye `review_status: HAS_MINOR_ISSUES`, agregar el diagnóstico del reviewer:

```
El 050 Vertical Harness ha producido los siguientes documentos para la slice <slice_activa>:

- Proposal:                      /050_vertical/<slice_activa>/proposal.md
- Software Design Specification: /050_vertical/<slice_activa>/software_design_specification.md
- Software Design Document:      /050_vertical/<slice_activa>/software_design_document.md
- Testing Plan:                  /050_vertical/<slice_activa>/testing_plan.md
- Execution Plan:                /050_vertical/<slice_activa>/execution_plan.md

[Si review_status == HAS_MINOR_ISSUES:]
Nota: el revisor detectó los siguientes issues menores (no bloqueantes):
<minor_issues_summary del GOVERNOR_RESULT>

¿Los apruebas tal como están, o necesitas cambios antes de la aprobación formal?
```

Presentar con `AskUserQuestion`.

**Si el usuario aprueba o pide cambios menores:**
→ Invocar `vertical-governor` con:
```
[MODO: POST_CP03]
cp03_decision: approved
```
→ Leer `GOVERNOR_RESULT`. Si `CP04_READY` → continuar al Paso E.

**Si el usuario pide cambios sustanciales:**
→ Invocar `vertical-governor` con:
```
[MODO: POST_CP03]
cp03_decision: rework
changes: <descripción exacta de los cambios solicitados y artefacto(s) afectado(s)>
```
→ Leer `GOVERNOR_RESULT`. Si `REWORK_COMPLETE` → volver a presentar CP-03:
```
Los artefactos de la slice <slice_activa> fueron actualizados con los cambios solicitados. Por favor revisa nuevamente:
[misma lista de artefactos]
¿Los apruebas ahora?
```
→ Repetir Paso D hasta aprobación.

**Si el usuario usa `/forge-override "texto"`:**
→ El comando habrá registrado el override y retornado `FORGE_OVERRIDE_RESULT`.
→ Invocar `vertical-governor` con:
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
[CP-04 PRE-GATE 050] <timestamp> — Presentando gate de aprobación formal CP-04 para <slice_activa>.
```

Presentar al usuario con `AskUserQuestion`:

```
¿Apruebas formalmente los 5 artefactos de implementación de la slice <slice_activa>
(Proposal, SDS, SDD, Testing Plan y Execution Plan) como la base de construcción para esta slice?

(Esta es la aprobación formal — diferente a la revisión de draft que acabas de hacer.)
```

**Si el usuario aprueba:**
→ Invocar `vertical-governor` con:
```
[MODO: POST_CP04]
cp04_approved: true
cp04_citation: <cita textual de la respuesta de aprobación del usuario>
```
→ Leer `GOVERNOR_RESULT`:
  - `CLOSURE_READY` → continuar al Paso F (Cierre de Slice).
  - `CP04_DECLINED` → presentar de nuevo (sin contar como rechazo).
  - `ESCALATION_REQUIRED` → notificar: "La fase queda en HOLD. Se requiere intervención manual." Detener.
  - `REWORK_AFTER_REJECTION` → volver al Paso D (el evaluador rechazó, rework ejecutado).
  - `STRATEGIC_REJECTION` → volver al Paso B (Sprint Contract requiere revisión estratégica).

**Si el usuario declina:**
→ Invocar governor con `cp04_approved: false`.
→ Si `CP04_DECLINED`: volver a presentar CP-04 (máximo 3 veces antes de ESCALATION).

### Paso F — Cierre

#### Cierre de Slice

*(Se llega aquí desde: `CLOSURE_READY` en Paso E, o desde `RESUME_AT_060_HANDOFF` en Paso A cuando el usuario elige iniciar el handoff.)*

Presentar al usuario con `AskUserQuestion`:

```
La evaluación de la slice <slice_activa> del 050 Vertical Harness está completa.

Resultado: <decision del verdict — APPROVED/REJECTED>
Score: <score> (<dimensiones D1..D5>)

Artefactos producidos:
- 050_vertical/<slice_activa>/proposal.md
- 050_vertical/<slice_activa>/software_design_specification.md
- 050_vertical/<slice_activa>/software_design_document.md
- 050_vertical/<slice_activa>/testing_plan.md
- 050_vertical/<slice_activa>/execution_plan.md

¿Deseas iniciar ahora el 060 Isolation Harness para esta slice?
```

Invocar `vertical-governor` con:
```
[MODO: CLOSE]
close_type: SLICE
handoff_decision: yes | no
```

Leer `GOVERNOR_RESULT` (bloque "Retorno de Cierre de Slice"):

- **`SLICE_DOCS_READY` con `handoff_status: DEPLOYED`**: Notificar al usuario:
  ```
  Deploy del 060 completado para la slice <slice_activa>. Reinicia la sesión de Claude Code en este directorio y ejecuta /forge-restart para continuar.
  ```
  Fin de la sesión actual.

- **`SLICE_DOCS_READY` con `handoff_status: PENDING_HANDOFF`**: Notificar:
  ```
  Slice <slice_activa> DOCS_READY. El 060 se iniciará cuando lo decidas.
  La próxima vez que abras Claude Code aquí, te preguntaré si deseas continuar.
  ```
  Fin.

- **`CLOSE_BLOCKED`**: Notificar al usuario y detener. Requiere intervención manual.

#### Cierre Total

*(Se llega aquí desde `PHASE_COMPLETE_READY` en Paso A — el 070 marcó la última slice como SLICE_COMPLETE.)*

Invocar `vertical-governor` con:
```
[MODO: CLOSE]
close_type: TOTAL
```

Leer `GOVERNOR_RESULT`:

- **`PHASE_COMPLETE`**: Notificar al usuario:
  ```
  El 050 Vertical Harness está completo. Todas las slices completaron el ciclo 050→060→070.
  Los artefactos de todas las slices están en /050_vertical/.
  ```
  Fin.

- **`CLOSE_BLOCKED`**: Notificar al usuario y detener. Requiere intervención manual.
