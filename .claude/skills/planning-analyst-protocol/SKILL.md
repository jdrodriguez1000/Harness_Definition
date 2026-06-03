---
name: planning-analyst-protocol
description: Protocolo analítico del planning-analyst en el 040 Planning Harness. Define el orden de lectura de los 12 inputs, las 6 tareas de extracción (inventario VS, granularidad, asignación IC-xx, asignación BDD, dependencias, riesgos), la regla de no-inferencia, el criterio de done y el límite de iteraciones. Usar cuando planning-analyst ejecuta su análisis sobre los 12 inputs del 040.
user-invocable: false
agent: planning-analyst
---

## Regla de no-inferencia (absoluta)

No inventar slices, IC-xx, BDD scenarios ni dependencias que no estén presentes en los 12 inputs.
Si algo es ambiguo o está ausente, registrarlo como gap en la tabla de "Gaps e Ítems de Escalamiento".
Nunca completar con suposiciones sobre el dominio o el sistema — toda afirmación debe ser trazable
a uno de los 12 inputs listados.

## Orden de lectura de inputs

Leer en este orden para construir el contexto progresivamente antes de ejecutar las tareas:

1. `010_discovery/domain_glossary.md` — fijar el vocabulario obligatorio antes de leer nada más
2. `010_discovery/scope_boundaries.md` — identificar qué está fuera de alcance (no asignar a slices)
3. `010_discovery/shared_understanding.md` — restricciones generales del proyecto y expectativas del cliente
4. `020_specification/bdd_features.md` — lista canónica de SC-xx/SE-xx a asignar a slices
5. `020_specification/data_contracts.md` — entidades del dominio (contexto de complejidad por slice)
6. `020_specification/acceptance_criteria.md` — criterios de aceptación que impactan el scope de slices
7. `020_specification/error_exception_policy.md` — políticas de error (informa slices de Robustez)
8. `030_design/contract_definitions.md` — lista canónica de IC-xx a asignar a slices
9. `030_design/dependency_graph.md` — DEP-xx que imponen orden entre slices
10. `030_design/technical_blueprint.md` — MOD-xx para contar complejidad técnica por slice
11. `030_design/architecture_decision_records.md` — stack tecnológico (informa estimación de esfuerzo)
12. `030_design/test_strategy_map.md` — **fuente principal**: VS draft del 030 con la sección "Guía de Vertical Slices"

**Precondición crítica:** Si `test_strategy_map.md` no contiene la sección "Guía de Vertical Slices"
o no tiene los 3 hitos mínimos (Tracer Bullet, MVP, Robustez), registrar gap y emitir
`ESCALAMIENTO REQUERIDO` inmediatamente. No continuar sin ese input.

## Tareas de extracción

### Tarea 1 — Inventario del Draft VS (Sección 1 del reporte)

Fuente: `030_design/test_strategy_map.md`, sección "Guía de Vertical Slices".

Extraer la lista completa de slices propuestas por el 030. Para cada VS-xx:
- Nombre descriptivo
- Tipo (Tracer Bullet / Crecimiento / MVP / Evolución / Robustez)
- IC-xx mencionados en el draft (pueden estar incompletos — se verifican en Tarea 3)
- BDD scenarios mencionados en el draft (ídem)

Reglas:
- Si el draft no asigna IDs explícitos a las slices, asignarlos secuencialmente VS-01, VS-02, ... y documentar que se asignaron.
- Si hay menos de 3 slices o faltan los tipos Tracer Bullet, MVP o Robustez → gap bloqueante, escalamiento inmediato.
- No inventar slices adicionales: solo las que el draft del 030 propone explícitamente.

### Tarea 2 — Validación de Granularidad (Sección 2 del reporte)

Fuente: `030_design/test_strategy_map.md` (VS draft), `030_design/contract_definitions.md` (IC-xx totales), `020_specification/bdd_features.md` (BDD scenarios totales).

Para cada VS-xx de la lista del inventario, verificar los 3 límites máximos:
- **Máx. 3 IC-xx nuevas** por slice (IC-xx que aparecen por primera vez en esa slice, no heredadas)
- **Máx. 2 MOD-xx nuevos** por slice (MOD-xx de `technical_blueprint.md` que esa slice introduce)
- **Máx. 10 BDD scenarios nuevos** por slice

Reglas de división:
- Si cualquier límite se excede → proponer división de la slice en 2 partes.
- Decidir y documentar la convención de nomenclatura para slices nuevas: VS-xxA/VS-xxB (sufijo) o
  numeración secuencial desde el último VS-xx existente. Registrar la convención elegida con su
  razón en Sección 2. Una vez elegida la convención, aplicarla consistentemente en todo el reporte.
- Las slices divididas heredan el tipo de la original; si el tipo debe cambiar (ej. una parte queda
  en MVP y otra en Robustez), documentar el nuevo tipo de cada sub-slice.
- Las slices que no exceden ningún límite → "PASA" sin modificación.
- No fusionar slices que queden por debajo del piso mínimo (el piso aplica a la estructura,
  no a eliminar slices existentes del draft).

### Tarea 3 — Asignación de IC-xx (Sección 3 del reporte)

Fuente: `030_design/contract_definitions.md` (lista canónica de IC-xx).

Objetivo: que cada IC-xx de `contract_definitions.md` esté asignado a ≥1 slice al terminar.

Pasos:
1. Extraer la lista canónica completa de IC-xx de `contract_definitions.md`.
2. Para cada IC-xx, verificar si aparece en ≥1 slice del draft (Tarea 1) o en las slices nuevas por división (Tarea 2).
3. Los IC-xx sin asignación → marcar como HUÉRFANO.
4. Para cada IC-xx huérfano, identificar la slice más coherente semánticamente: la slice cuyo dominio
   (nombre, tipo, BDD scenarios asignados) es más afín a la responsabilidad de esa IC-xx.
5. Documentar la asignación propuesta con su justificación semántica.
6. El total de IC-xx huérfanos tras la asignación propuesta debe ser 0.

Regla: No crear IC-xx nuevas. Solo los IC-xx de `contract_definitions.md` son válidos.

### Tarea 4 — Asignación de BDD Scenarios (Sección 4 del reporte)

Fuente: `020_specification/bdd_features.md` (lista canónica de SC-xx/SE-xx).

Objetivo: que cada SC-xx/SE-xx de `bdd_features.md` esté asignado a ≥1 slice al terminar.

Pasos:
1. Extraer la lista canónica completa de SC-xx y SE-xx de `bdd_features.md`.
2. Para cada SC-xx/SE-xx, verificar si aparece en ≥1 slice del draft o en las slices nuevas.
3. Los scenarios sin asignación → marcar como HUÉRFANO.
4. Para cada scenario huérfano, asignarlo a la slice más coherente semánticamente: la slice
   cuyo tipo y dominio es más afín al feature y scenario correspondiente.
   - SC-xx de flujos principales → preferir slices de tipo MVP o Crecimiento.
   - SE-xx de manejo de errores → preferir slices de tipo Robustez o MVP (si el error es crítico).
5. Documentar la asignación propuesta con justificación semántica.
6. El total de BDD scenarios huérfanos tras la asignación propuesta debe ser 0.

Regla: No crear SC-xx ni SE-xx nuevos. Solo los que existen en `bdd_features.md` son válidos.

### Tarea 5 — Matriz de Dependencias entre Slices (Sección 5 del reporte)

Fuente: `030_design/dependency_graph.md` (DEP-xx), lista final de slices (Tareas 1+2).

Derivar dependencias entre slices a partir de los DEP-xx:
- Si la slice B necesita una IC-xx que la slice A implementa, entonces B depende de A.
- La IC-xx que crea la dependencia y el DEP-xx origen deben quedar documentados en la tabla.
- Una dependencia es "obligatoria" si B no puede ejecutarse sin que A esté completa.
- Una dependencia es "recomendada" si el orden es conveniente pero no bloqueante.

Verificación de ciclos:
- Detectar si existe alguna cadena circular de dependencias (VS-A → VS-B → VS-A, o cadenas más largas).
- Si hay ciclo irresoluble: registrar en Gaps, marcar como escalamiento bloqueante. No proponer una
  resolución sin instrucción del governor.
- Si no hay ciclos: documentar explícitamente "Ningún ciclo detectado".

Validación de la estructura obligatoria:
- Verificar que la secuencia de tipos (Tracer Bullet → Crecimiento → MVP → Evolución → Robustez)
  es consistente con las dependencias derivadas. Si hay conflicto (ej. una slice de Crecimiento
  depende de una de MVP), registrar como gap.

### Tarea 6 — Riesgos Preliminares por Slice (Sección 6 del reporte)

Fuente: todos los inputs leídos, con énfasis en I-5 (DEP-xx), I-2 (ADR-001), I-11 (scope_boundaries).

Para cada VS-xx de la lista final (incluyendo slices nuevas por división), identificar ≥1 riesgo:

Categorías de riesgo a buscar activamente:
- **Técnica** — complejidad de implementación o tecnología incierta:
  slices con IC-xx de tipo Repository complejo, múltiples MOD-xx nuevos, o stack no familiar según ADR-001.
- **Dependencia** — servicio externo, API de tercero o recurso no controlado:
  IC-xx de tipo Notifier o API externa; DEP-xx que referencian sistemas externos.
- **Ambigüedad** — requisito no resuelto en los inputs del 030/020/010:
  IC-xx con operaciones marcadas `[PENDIENTE]` en `contract_definitions.md`; gaps del 030 no resueltos.
- **Arquitectura** — decisión del 030 que podría requerir revisión al implementar:
  ADRs con consecuencias aceptadas que generan complejidad; patrones de diseño cuya aplicación
  en la slice específica puede ser no obvia.

Para cada riesgo, asignar:
- ID provisional RK-xx (el planning-writer los formalizará)
- Categoría (Técnica / Dependencia / Ambigüedad / Arquitectura)
- Probabilidad tentativa (Alta / Media / Baja)
- Impacto tentativo (Alto / Medio / Bajo)

Regla: No escribir riesgos genéricos ("complejidad técnica") sin una referencia concreta a un
IC-xx, DEP-xx, ADR-xx o sección de input específica que lo fundamenta.

## Criterio de done del análisis

Verificar después de completar las 6 tareas. Si alguna condición falla, actualizar el reporte
antes de reportar COMPLETED.

- [ ] `040_planning/planning_analysis_report.md` escrito en disco (Write es el PRIMER tool call — LL-01)
- [ ] Sección 1: tabla de inventario VS completa con todos los VS-xx del draft del 030
- [ ] Sección 2: tabla de granularidad completa con resultado PASA o DIVIDE para cada VS-xx
- [ ] Sección 2: convención de nomenclatura documentada (si hay divisiones)
- [ ] Sección 3: tabla de IC-xx completa; total huérfanos tras asignación = 0
- [ ] Sección 4: tabla de BDD scenarios completa; total huérfanos tras asignación = 0
- [ ] Sección 5: matriz de dependencias completa con verificación de ciclos
- [ ] Sección 6: ≥1 riesgo preliminar (RK-xx provisional) por cada VS-xx de la lista final
- [ ] Tabla de Gaps completa (o "Ninguno" explícito)
- [ ] Estado del análisis: `LISTO PARA WRITER` o `ESCALAMIENTO REQUERIDO — [N] gaps bloqueantes`

Si todas las condiciones se verifican: reportar `COMPLETED` con path al archivo.
Si alguna condición falla: reportar `INCOMPLETO: <razón específica>`. No reportar COMPLETED.

## Límite de iteraciones

Si planning-analyst ha sido ejecutado 2 veces o más sobre los mismos inputs y persisten gaps
bloqueantes sin resolución del governor, agregar en el reporte:

`ALERTA: 2 iteraciones completadas sin resolver gaps bloqueantes. Escalar al humano.`

Reportar `ESCALAMIENTO REQUERIDO` al governor. No ejecutar una tercera iteración sin
instrucción explícita del governor.
