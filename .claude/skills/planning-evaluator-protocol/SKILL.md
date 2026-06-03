---
name: planning-evaluator-protocol
description: Protocolo de verificación por dimensión del planning-evaluator en el 040 Planning Harness. Define los procedimientos de verificación para D1 (VS Coverage), D2 (Slice Definition Quality), D3 (Roadmap Coherence), D4 (Risk Completeness) y D5 (Consistency), con los checks cruzados de IDs entre los 3 artefactos. Usar cuando planning-evaluator ejecuta la evaluación de los 3 artefactos finales del 040.
user-invocable: false
agent: planning-evaluator
---

Procedimientos de verificación para las dimensiones D1–D5. Para cada dimensión, aplicar siempre
el protocolo de dos fases obligatorio (LL-07): Fase 1 (análisis: pros + contras con evidencia
citada del artefacto y sección) → Fase 2 (score con anclas de `planning-rubric`).

No asignar un score sin haber construido la lista de pros y contras con evidencia concreta.

**Artefactos evaluados (leer directamente del filesystem — sin contexto de ejecución):**
- `040_planning/vertical_slice_plan.md`
- `040_planning/project_roadmap.md`
- `040_planning/risk_register.md`

**Artefactos de referencia (fuentes de verdad independientes):**
- `030_design/contract_definitions.md` — lista canónica de IC-xx (para D1 y D5)
- `020_specification/bdd_features.md` — lista canónica de SC-xx/SE-xx (para D1 y D5)
- `010_discovery/domain_glossary.md` — lenguaje ubicuo (para D5)

---

## D1 — VS Coverage

**Pregunta:** ¿Todos los IC-xx de `contract_definitions.md` y todos los BDD scenarios de
`bdd_features.md` están asignados a ≥1 slice en `vertical_slice_plan.md`? ¿Sin huérfanos?

**Fuente de verificación independiente:** leer `030_design/contract_definitions.md` directamente
para extraer la lista canónica de IC-xx. Leer `020_specification/bdd_features.md` para extraer
la lista canónica de SC-xx y SE-xx. No depender del `planning_analysis_report.md` — es un
artefacto intermedio, no la fuente de verdad.

**Fase 1 — qué buscar:**

Pros (registrar con referencia de sección del artefacto):
- Cada IC-xx de `contract_definitions.md` aparece en el campo "IC-xx asignados" de ≥1 slice en `vertical_slice_plan.md`.
- Cada SC-xx y SE-xx de `bdd_features.md` aparece en el campo "BDD Scenarios asignados" de ≥1 slice.
- La tabla de resumen de `vertical_slice_plan.md` es coherente con las secciones de detalle.
- El total de IC-xx y BDD scenarios en el resumen coincide con los totales extraídos de los artefactos de referencia.

Contras (registrar con cita concreta — artefacto + campo + ID específico):
- IC-xx presente en `contract_definitions.md` pero ausente en todas las slices de `vertical_slice_plan.md` → IC-xx huérfano.
- SC-xx o SE-xx presente en `bdd_features.md` pero ausente en todas las slices → scenario huérfano.
- IC-xx referenciado en `vertical_slice_plan.md` que no existe en `contract_definitions.md` → ID inventado.
- SC-xx/SE-xx referenciado en `vertical_slice_plan.md` que no existe en `bdd_features.md` → ID inventado.

**Check cruzado obligatorio:**
1. Extraer todos los IC-xx de `030_design/contract_definitions.md` (lista A).
2. Extraer todos los IC-xx que aparecen en alguna slice de `vertical_slice_plan.md` (lista B).
3. IC-xx en A no presentes en B → huérfanos → contra por cada uno.
4. Extraer todos los SC-xx/SE-xx de `020_specification/bdd_features.md` (lista C).
5. Extraer todos los SC-xx/SE-xx en slices de `vertical_slice_plan.md` (lista D).
6. SC-xx/SE-xx en C no presentes en D → huérfanos → contra por cada uno.

**Fase 2:** asignar score según anclas de `planning-rubric`.

---

## D2 — Slice Definition Quality

**Pregunta:** ¿Cada slice en `vertical_slice_plan.md` tiene los 6 campos obligatorios completos?
¿El Criterio de Done es verificable con referencias a IDs específicos?

**Fase 1 — qué buscar:**

Pros (registrar con referencia de sección):
- Cada slice tiene campo "Nombre" con identificador descriptivo en lenguaje del dominio.
- Cada slice tiene campo "Tipo" con uno de los valores válidos: Tracer Bullet, Crecimiento, MVP, Evolución, Robustez.
- Cada slice tiene campo "IC-xx asignados" con ≥1 IC-xx y los IDs son concretos (no genéricos).
- Cada slice tiene campo "BDD Scenarios asignados" con ≥1 SC-xx/SE-xx con IDs concretos.
- Cada slice tiene campo "Criterio de Done" con condiciones que referencian IC-xx y SC-xx/SE-xx específicos.
- Cada slice tiene campo "Estimación de esfuerzo" con uno de XS/S/M/L/XL y justificación.
- Tabla de resumen coherente con las secciones de detalle.

Contras (registrar con cita concreta):
- Slice sin alguno de los 6 campos → falta de campo → contra directo.
- Campo "Tipo" con valor no reconocido (ej. "Funcionalidad básica") → contra.
- Campo "IC-xx asignados" vacío o con "N/A" → contra.
- Campo "BDD Scenarios asignados" vacío → contra.
- Criterio de Done genérico sin referencias a IC-xx o SC-xx específicos (ej. "la funcionalidad está implementada") → contra.
- Estimación de esfuerzo sin justificación → contra menor.
- Justificación de esfuerzo que no menciona IC-xx count ni complejidad técnica → contra menor.

**Fase 2:** asignar score.

---

## D3 — Roadmap Coherence

**Pregunta:** ¿La secuencia en `project_roadmap.md` respeta la estructura obligatoria
TB→Crecimiento→MVP→Evolución→Robustez? ¿Sin dependencias circulares? ¿Los 3 hitos obligatorios
marcados? ¿Dependencias VS-xx → VS-xx explícitas y derivadas de DEP-xx?

**Fase 1 — qué buscar:**

Pros (registrar con referencia de sección):
- Tracer Bullet aparece en la primera posición de la tabla de secuencia.
- MVP aparece después de todas las slices de Crecimiento y antes de las de Evolución.
- Robustez aparece en la última posición.
- Las slices de Crecimiento están entre Tracer Bullet y MVP; las de Evolución entre MVP y Robustez.
- Los 3 hitos obligatorios marcados con ★ (Tracer Bullet, MVP, Robustez).
- Cada hito tiene: definición de éxito, duración estimada, IC-xx completadas y BDD Scenarios cubiertos.
- La tabla de dependencias lista VS-xx → VS-xx con DEP-xx de respaldo.
- La sección de "Verificación de ausencia de ciclos" tiene resultado explícito (no ausente).
- Las dependencias son consistentes con la secuencia de posiciones (la slice dependiente aparece después de la que depende).

Contras (registrar con cita concreta):
- Tracer Bullet no está en posición 1 de la secuencia.
- MVP aparece antes de alguna slice de Crecimiento → violación de orden obligatorio.
- Robustez no es la última slice de la secuencia.
- Slice de Crecimiento después del MVP → violación de orden.
- Slice de Evolución antes del MVP → violación de orden.
- Alguno de los 3 hitos obligatorios sin marca ★.
- Hito sin definición de éxito o sin IC-xx cubiertos.
- Dependencia VS-xx → VS-xx sin DEP-xx de respaldo.
- Dependencia que implica que la slice dependiente está ubicada antes de la que depende (violación de secuencia).
- Sección de ciclos ausente o sin resultado explícito.
- Ciclo detectado no resuelto.

**Check cruzado obligatorio:**
1. Extraer la lista de VS-xx de `vertical_slice_plan.md`.
2. Verificar que cada VS-xx aparece en la tabla de secuencia de `project_roadmap.md`.
3. VS-xx en vertical_slice_plan sin entrada en project_roadmap → contra por cada una.
4. VS-xx en project_roadmap que no existe en vertical_slice_plan → ID inconsistente → contra.

**Fase 2:** asignar score.

---

## D4 — Risk Completeness

**Pregunta:** ¿`risk_register.md` tiene ≥1 RK-xx por cada VS-xx de `vertical_slice_plan.md`?
¿Cada RK-xx tiene probabilidad, impacto y mitigación concreta?

**Fuente de verificación independiente:** extraer la lista de VS-xx de `vertical_slice_plan.md`.
Verificar cobertura contra `risk_register.md`. No asumir que el analysis_report tiene la lista
completa — el evaluador verifica contra el artefacto final producido.

**Fase 1 — qué buscar:**

Pros (registrar con referencia de sección):
- Cada VS-xx de `vertical_slice_plan.md` tiene ≥1 RK-xx en `risk_register.md`.
- Cada RK-xx tiene campo "Probabilidad" con valor Alta, Media o Baja.
- Cada RK-xx tiene campo "Impacto" con valor Alto, Medio o Bajo.
- Cada RK-xx tiene campo "Mitigación" con ≥1 acción concreta que referencia IC-xx, slices o artefactos.
- Cada RK-xx tiene campo "Descripción" que explica qué puede salir mal, cuándo y por qué.
- Tabla de resumen coherente con las secciones de detalle.
- Campo "Indicador de materialización" presente (señal observable del riesgo).

Contras (registrar con cita concreta):
- VS-xx sin ningún RK-xx en `risk_register.md` → contra directo por cada VS-xx sin cobertura.
- RK-xx sin campo "Probabilidad" o con valor no reconocido.
- RK-xx sin campo "Impacto" o con valor no reconocido.
- Mitigación genérica: "revisar el código", "hacer más testing", "monitorear el riesgo" → contra por cada mitigación genérica.
- Mitigación que no referencia ningún IC-xx, slice, artefacto o acción concreta → contra.
- RK-xx sin "Descripción" o con descripción de una línea que no explica el riesgo → contra menor.
- RK-xx referenciando una VS-xx que no existe en `vertical_slice_plan.md` → ID inconsistente → contra.

**Check cruzado obligatorio:**
1. Extraer lista de VS-xx de `vertical_slice_plan.md` (lista A).
2. Extraer lista de VS-xx referenciadas en `risk_register.md` (lista B).
3. VS-xx en A no presentes en B → sin cobertura de riesgo → contra directo por cada una.

**Fase 2:** asignar score.

---

## D5 — Consistency

**Pregunta:** ¿Los IDs (VS-xx, IC-xx, SC-xx/SE-xx, RK-xx) son coherentes entre los 3 artefactos?
¿Sin contradicciones con los inputs del 030 (IC-xx en plan existe en contract_definitions; BDD
scenarios en plan existen en bdd_features)? ¿Lenguaje ubicuo del glosario usado consistentemente?

**Fase 1 — verificaciones concretas a ejecutar (en orden):**

**Verificación 1 — IDs cruzados entre los 3 artefactos:**
- Extraer todos los VS-xx de `vertical_slice_plan.md` (lista canónica).
- Verificar que cada VS-xx de la lista canónica aparece en `project_roadmap.md` (tabla de secuencia).
- Verificar que cada VS-xx de la lista canónica tiene ≥1 RK-xx en `risk_register.md`.
- Extraer todos los VS-xx referenciados en `project_roadmap.md`: verificar que cada uno existe en `vertical_slice_plan.md`.
- Extraer todos los VS-xx referenciados en `risk_register.md`: verificar que cada uno existe en `vertical_slice_plan.md`.
- Cualquier ID referenciado en un artefacto que no existe en el artefacto que lo define → contra directo.

**Verificación 2 — IDs contra fuentes de verdad externas:**
- Leer `030_design/contract_definitions.md`: extraer todos los IC-xx.
- Verificar que cada IC-xx mencionado en `vertical_slice_plan.md` existe en `contract_definitions.md`.
- Leer `020_specification/bdd_features.md`: extraer todos los SC-xx y SE-xx.
- Verificar que cada SC-xx/SE-xx mencionado en `vertical_slice_plan.md` existe en `bdd_features.md`.
- IC-xx o SC-xx/SE-xx en `vertical_slice_plan.md` sin correspondencia en los artefactos de referencia → ID inventado → contra directo.

**Verificación 3 — Consistencia de secuencia y dependencias:**
- La secuencia de tipos en `project_roadmap.md` es coherente con los tipos declarados en `vertical_slice_plan.md` (mismo tipo para el mismo VS-xx en ambos artefactos).
- Las dependencias VS-xx → VS-xx en `project_roadmap.md` son consistentes con la secuencia de posiciones (la dependiente siempre después de su prerrequisito).
- Un VS-xx con tipo "Crecimiento" en `vertical_slice_plan.md` pero posicionado después del MVP en `project_roadmap.md` → inconsistencia de tipo/posición → contra.

**Verificación 4 — Lenguaje ubicuo:**
- Leer `010_discovery/domain_glossary.md`.
- Verificar que los nombres de slices, IC-xx (nombres completos) y categorías de riesgo usan términos del glosario cuando existe un término equivalente.
- Un término de negocio usado con definición diferente a la del glosario → contra.
- Un término nuevo sin `[GLOSARIO: pendiente — nombre]` → contra menor.

**Verificación 5 — Campo Estado:**
- Los 3 artefactos deben tener `Estado: DRAFT`.
- Si `vertical_slice_plan.md`, `project_roadmap.md` o `risk_register.md` tienen `Estado: APROBADO POR CLIENTE` al momento de la evaluación post-CP-04: verificar que el governor realizó la edición (es correcto en ese momento). Si el evaluador los encontró en DRAFT → normal (el governor los edita antes del cierre, no el writer).

**Regla de veto — definición operacional:**
- **Activa el veto (D5 = 0.0):** contradicción directa y silenciosa entre artefactos. Ejemplos:
  - `project_roadmap.md` lista VS-03 como tipo "Robustez" pero `vertical_slice_plan.md` la define como "MVP".
  - `risk_register.md` tiene RK-05 para VS-07 pero VS-07 no existe en `vertical_slice_plan.md`.
  - `vertical_slice_plan.md` asigna IC-09 a VS-04 pero IC-09 no existe en `030_design/contract_definitions.md`.
  - `project_roadmap.md` posiciona VS-03 antes de VS-01 (Tracer Bullet) cuando VS-03 tiene tipo "Crecimiento" y depende explícitamente de VS-01.
- **No activa el veto:** inconsistencia documentada con marcador `[PENDIENTE]` o nota explícita.
  Es una advertencia, no una contradicción silenciosa.

**Fase 2:** asignar score. Si existe cualquier contradicción directa y silenciosa → D5 = 0.0.
