---
name: specification-writer-protocol
description: Protocolo de producción del specification-writer en el 020 Specification Harness. Define las reglas de transformación de spec_analysis_report a los 4 artefactos finales y la checklist de consistencia cruzada entre artefactos. Usar cuando specification-writer produce los artefactos o verifica su consistencia antes de reportar.
user-invocable: false
agent: specification-writer
---

## Regla de no-inferencia (absoluta)

No generar comportamientos, entidades, políticas ni criterios que no estén en el
`spec_analysis_report.md`. Si la información es ambigua o falta, registrar con
`[PENDIENTE: descripción]`, no inventar completitud.

---

## Reglas de transformación por artefacto

### bdd_features.md — Transformar CF-xx y CB-xx en escenarios Given/When/Then

**CF-xx → SC-xx (camino feliz):**

Cada CF-xx tiene tres campos: "Situación inicial", "Acción del actor" y "Resultado esperado".
Transformar así:

```
Dado que [Situación inicial — en tiempo presente, desde la perspectiva del sistema]
Cuando [Acción del actor — verbo de acción concreto del actor]
Entonces [Resultado esperado — comportamiento observable y verificable]
  Y [resultado adicional si el CF-xx tiene más de un resultado]
```

Reglas adicionales:
- El "Dado que" describe el estado del sistema antes de la acción, no el historial del usuario.
- El "Cuando" usa siempre el nombre exacto del actor (AC-xx) del analysis_report.
- El "Entonces" es un resultado que el cliente puede observar y verificar, no un estado interno del sistema.
- Si el CF-xx tiene la columna "Restricciones de scope" con referencia a EX-xx, no generar el escenario — esa restricción lo excluye.

**CB-xx → SE-xx (caso de borde):**

```
Dado que [condición límite o estado excepcional del CB-xx]
Cuando [acción del actor o evento que dispara el caso de borde]
Entonces [resultado esperado ante el caso de borde — puede ser un mensaje de error, bloqueo, redirección]
```

Reglas adicionales:
- Si el CB-xx tiene `Fuente: failure_behavior.md`, el resultado esperado debe ser consistente con
  la política que el EE-xx correspondiente tendrá en `error_exception_policy.md`.
- Si el CB-xx tiene `Fuente: derivado`, el resultado esperado puede ser inferido del contexto del
  camino feliz, pero marcarlo con `[derivado — pendiente confirmación]` si hay duda.
- Todo CB-xx genera exactamente un SE-xx. No combinar múltiples CB-xx en un solo escenario.

---

### data_contracts.md — Transformar EN-xx y RE-xx en contratos de datos

**EN-xx → sección de entidad:**

Para cada entidad EN-xx del analysis_report, crear una sección con:
1. Descripción de negocio (no técnica): derivar de la definición en `domain_glossary.md`.
2. Tabla de campos: inferir los campos mínimos necesarios a partir de los CF-xx y CB-xx
   que involucran esta entidad. Cada campo debe tener al menos un escenario BDD que lo use.
3. Reglas de negocio (RN-xx): restricciones que aplican a la entidad completa o a la
   combinación de campos. Derivar de las restricciones mencionadas en CF-xx y de las
   relaciones RE-xx.

Si un campo es necesario para un escenario BDD pero no aparece explícitamente en el
analysis_report, registrarlo con `[PENDIENTE: origen no verificado en analysis_report]`.

**RE-xx → tabla de relaciones:**

Trasladar cada RE-xx directamente. No inferir relaciones adicionales. Si una relación parece
implícita en los escenarios BDD pero no está en RE-xx, no agregarla — registrar la ausencia
con una nota al final: `[Relación implícita detectada en SC-xx: [descripción] — no incluida
sin respaldo en RE-xx]`.

---

### acceptance_criteria.md — Transformar SC-xx y SE-xx en criterios verificables

**SC-xx / SE-xx → ACP-xx:**

Para cada escenario (tanto SC como SE), crear al menos un ACP-xx. El criterio de aceptación
no repite el escenario — lo convierte en una condición binaria verificable:

```
| ACP-xx | [Descripción del criterio, 1 oración] | SC-xx / SE-xx | [qué debe ser verdad] | [qué indica fallo] |
```

Diferencia clave:
- El escenario BDD describe el comportamiento. Ejemplo: "Cuando el médico confirma la cita, Entonces el sistema envía notificación al paciente."
- El criterio de aceptación describe la condición de verificación. Ejemplo: "El paciente recibe notificación dentro de los 5 minutos siguientes a la confirmación de la cita."

Si el escenario no contiene suficiente información para definir una condición de fallo concreta,
usar `[PENDIENTE: definir umbral con el cliente]` en la columna "Condición de fallo".

**Tabla de trazabilidad inversa:**

Al terminar de generar todos los ACP-xx, construir la tabla de trazabilidad inversa:
- Listar cada SC-xx y SE-xx de `bdd_features.md`.
- Confirmar que cada uno tiene al menos un ACP-xx asociado.
- Si algún SC-xx o SE-xx no tiene ACP-xx: crear el ACP-xx mínimo antes de continuar.

---

### error_exception_policy.md — Transformar EE-xx en políticas EP-xx

**EE-xx → EP-xx:**

Para cada ítem EE-xx del analysis_report, crear un EP-xx con:

1. **Mensaje al usuario**: texto concreto en lenguaje del dominio. No usar "Error genérico" ni
   "Intente más tarde". Si el EE-xx no provee suficiente información para redactar el mensaje,
   usar `[PENDIENTE: redactar con el cliente]`.

2. **Reintento**: ¿el sistema intenta la operación nuevamente de forma automática? Responder
   sí/no con número de intentos si aplica. Si el EE-xx no lo especifica, escribir "no" por
   defecto y marcar con `[pendiente confirmación]`.

3. **Bloqueo**: ¿el sistema detiene el flujo del actor hasta que se resuelva el error? Sí/no.

4. **Acción alternativa**: qué hace el sistema además de mostrar el mensaje. Puede ser
   "ninguna", "redirigir a [pantalla]", "notificar a [actor]", etc.

Si el EE-xx tiene `Resolución del governor: [texto]`, incorporarla como la base de la política.
Si el EE-xx tiene `Estado original: PENDIENTE` sin resolución, escribir `[PENDIENTE — governor
no proveyó resolución]` y no inventar la política.

---

## Checklist de consistencia cruzada (aplicar antes de reportar)

Esta verificación es obligatoria. Ejecutar en orden. Si algún ítem falla, corregir con `Edit`
antes de pasar al siguiente.

### Consistencia bdd_features ↔ acceptance_criteria

- [ ] Abrir `specification/bdd_features.md` y extraer todos los IDs: `SC-01`, `SC-02`, ..., `SE-01`, `SE-02`, ...
- [ ] Abrir `specification/acceptance_criteria.md` y verificar que cada ID listado en la
  tabla de trazabilidad inversa existe efectivamente en `bdd_features.md`.
- [ ] Verificar que ningún SC-xx o SE-xx de `bdd_features.md` está ausente en la tabla de trazabilidad inversa.

### Consistencia bdd_features ↔ data_contracts

- [ ] Para cada campo en `data_contracts.md` con "Escenario BDD relacionado: SC-xx / SE-xx",
  verificar que ese ID existe en `bdd_features.md`.
- [ ] Si algún campo tiene un ID que no existe, corregir la referencia o marcar como `[sin escenario — revisar]`.

### Consistencia error_exception_policy ↔ spec_analysis_report

- [ ] Extraer todos los IDs EE-xx del analysis_report (sección Error & Exception Mapping).
- [ ] Verificar que cada EE-xx tiene un EP-xx en `error_exception_policy.md`.
- [ ] Verificar que ningún EP-xx referencia un EE-xx que no existe en el analysis_report (no IDs inventados).

### Consistencia interna de acceptance_criteria

- [ ] Verificar que ningún ACP-xx tiene la columna "Escenario BDD" vacía o con valor `—`.
- [ ] Verificar que no existen dos ACP-xx idénticos (duplicados).

### Consistencia de lenguaje (domain_glossary)

- [ ] Para cada término clave en los 4 artefactos, verificar que aparece en `domain_glossary.md`
  O está marcado con `[GLOSARIO: pendiente — nombre]`. No deben existir términos sin una de las dos condiciones.
