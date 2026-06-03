## Ciclo 010 Discovery

El ciclo completo de interacción para el 010 Discovery Harness. Gestiona las invocaciones al governor y todas las interacciones con el usuario.

### Paso A — Orientación (siempre al inicio del ciclo)

Invocar `discovery-governor` como subagente (`subagent_type: "discovery-governor"`) con el prompt:
```
[MODO: INIT]
Directorio de trabajo: <path absoluto del proyecto>
```

Si hay ajuste solicitado por el usuario (ver "Loop de ajuste" más abajo), incluir en el prompt:
```
adjustment_request: <descripción de los ajustes solicitados por el cliente>
```

Leer el `GOVERNOR_RESULT` retornado y ramificar:

- **`SPRINT_CONTRACT_READY`** → ejecutar el **Loop de Sprint Contract** (Paso B)
- **`RESUME_AT_EXECUTE`** → invocar governor en EXECUTE directamente (Paso C), sin presentar Sprint Contract
- **`RESUME_AT_CP03`** → presentar CP-03 directamente (Paso D), sin ejecutar workers
- **`RESUME_AT_CP04`** → presentar CP-04 directamente (Paso E), sin pasar por CP-03
- **`CLOSURE_READY`** → retomada tras auditoría interrumpida → ejecutar Paso F (Cierre)
- **`RESUME_HOLD`** → notificar al usuario: "El harness está en HOLD. Requiere intervención manual antes de continuar." Detener.
- **`ALREADY_COMPLETE`** → notificar al usuario: "El 010 Discovery ya está completo." Fin.
- **`INIT_FAILED`** → notificar al usuario con el `error` del resultado. Detener.

### Paso B — Loop de Sprint Contract

Usando el texto de `sprint_contract` del `GOVERNOR_RESULT`, presentar al usuario con `AskUserQuestion`:

```
[SPRINT CONTRACT — 010 Discovery Harness]

<texto completo del sprint_contract del GOVERNOR_RESULT>

¿Apruebas este Sprint Contract para comenzar, necesitas algún ajuste, o deseas cancelar?
```

**Si el usuario aprueba:**
→ Continuar al Paso C.

**Si el usuario solicita ajustes:**
→ Volver al Paso A incluyendo en el prompt `adjustment_request` con los cambios solicitados.
→ El governor retornará un nuevo `SPRINT_CONTRACT_READY` con el contrato actualizado.
→ Repetir este loop hasta aprobación o cancelación.

**Si el usuario cancela:**
→ Notificar: "El harness 010 Discovery ha sido cancelado. El estado queda en PENDING_CONTRACT."
→ Detener.

### Paso C — Ejecución técnica

Invocar `discovery-governor` como subagente con el prompt:
```
[MODO: EXECUTE]
Directorio de trabajo: <path absoluto>
sprint_contract_approved: true
```

Leer el `GOVERNOR_RESULT`:

- **`DIALOGUER_REQUIRED`** → El dialoguer debe correr en la sesión principal (LL-28). Ejecutar el **Sub-paso C1** a continuación.
- **`EXECUTION_COMPLETE`** → continuar al Paso D.
- **`EXECUTION_FAILED`** → notificar al usuario:
  ```
  La ejecución de los workers falló.
  Error: <error del GOVERNOR_RESULT>
  Revisa persistence/claude-progress.txt para el detalle. Cuando estés listo para reintentar, reinicia la sesión.
  ```
  Detener.

#### Sub-paso C1 — Invocar discovery-dialoguer directamente (sesión principal)

Invocar `discovery-dialoguer` como subagente (`subagent_type: "discovery-dialoguer"`) con el prompt:
```
Eres discovery-dialoguer. Directorio de trabajo: <path absoluto>.
Brief del proyecto: <inputs del GOVERNOR_RESULT.inputs>
Contexto: <context del GOVERNOR_RESULT.context>
Conduce la entrevista socrática completa con el cliente y produce /discovery/dialogue_transcript.md.
```

El dialoguer conduce las rondas de preguntas con el usuario usando AskUserQuestion. Esperar a que complete y retorne su reporte.

Al terminar el dialoguer, continuar con el **Sub-paso C2**.

#### Sub-paso C2 — Continuar ejecución técnica tras el dialoguer

Invocar `discovery-governor` como subagente con el prompt:
```
[MODO: EXECUTE]
Directorio de trabajo: <path absoluto>
dialoguer_complete: true
```

Leer el `GOVERNOR_RESULT`:

- **`EXECUTION_COMPLETE`** → continuar al Paso D.
- **`EXECUTION_FAILED`** → notificar al usuario con el error. Detener.

### Paso D — Gate CP-03 (revisión de draft)

Registrar en `persistence/claude-progress.txt` (usando Add-Content -Encoding utf8):
```
[CP-03 PRE-GATE] <timestamp> — Presentando 4 artefactos al cliente para revisión.
```

Presentar al usuario con `AskUserQuestion`:

```
El 010 Discovery Harness ha producido los siguientes documentos para tu revisión:

- Shared Understanding: /discovery/shared_understanding.md
- Scope Boundaries: /discovery/scope_boundaries.md
- Domain Glossary: /discovery/domain_glossary.md
- Failure Behavior: /discovery/failure_behavior.md

¿Los apruebas tal como están, o necesitas cambios antes de la aprobación formal?
```

**Si el usuario aprueba o pide cambios menores:**
→ Invocar `discovery-governor` con:
```
[MODO: POST_CP03]
cp03_decision: approved
```
→ Leer `GOVERNOR_RESULT`. Si `CP04_READY` → continuar al Paso E.

**Si el usuario pide cambios sustanciales:**
→ Invocar `discovery-governor` con:
```
[MODO: POST_CP03]
cp03_decision: rework
changes: <descripción exacta de los cambios solicitados>
```
→ Leer `GOVERNOR_RESULT`. Si `REWORK_COMPLETE` → volver a presentar CP-03 con nota:
```
Los artefactos fueron actualizados con los cambios solicitados. Por favor revisa nuevamente:
[misma lista de artefactos]
¿Los apruebas ahora?
```
→ Repetir Paso D hasta aprobación.

### Paso E — Gate CP-04 (aprobación formal) — SIEMPRE independiente de CP-03 (ADJ-16 / LL-25)

REGLA ESTRUCTURAL: Este gate siempre se presenta como un `AskUserQuestion` separado, incluso si la respuesta al CP-03 ya incluía lenguaje de aprobación total. CP-03 y CP-04 son gates distintos con sus propios timestamps.

Registrar en `persistence/claude-progress.txt`:
```
[CP-04 PRE-GATE] <timestamp> — Presentando gate de aprobación formal CP-04.
```

Presentar al usuario con `AskUserQuestion`:

```
¿Apruebas formalmente el Shared Understanding Document como representación exacta de lo que quieres construir?

(Esta es la aprobación formal — diferente a la revisión de draft que acabas de hacer.)
```

**Si el usuario aprueba:**
→ Invocar `discovery-governor` con:
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
La evaluación del 010 Discovery Harness está completa.

Resultado: <decision del verdict — APPROVED/REJECTED>
Score: <score> (<dimensiones D1..D5>)

Artefactos producidos:
- discovery/shared_understanding.md
- discovery/scope_boundaries.md
- discovery/domain_glossary.md
- discovery/failure_behavior.md

¿Deseas iniciar ahora el 020 Specification Harness?
```

Invocar `discovery-governor` con:
```
[MODO: CLOSE]
handoff_decision: yes | no
```

Leer `GOVERNOR_RESULT`:

- **`HANDOFF_READY`**: Notificar al usuario:
  ```
  Deploy del 020 completado. Para continuar, reinicia la sesión de Claude Code en este directorio.
  El CLAUDE.md detectará automáticamente el estado y lanzará specification-governor.
  ```
  Fin de la sesión actual.

- **`PHASE_COMPLETE_NO_HANDOFF`**: Notificar:
  ```
  Fase 010 Discovery completa. La próxima vez que abras Claude Code aquí, te preguntaré si deseas continuar con el 020.
  ```
  Fin.

- **`CLOSE_BLOCKED`**: Notificar al usuario y detener. Requiere intervención manual.
