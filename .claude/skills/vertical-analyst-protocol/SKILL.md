---
name: vertical-analyst-protocol
description: Protocolo analítico del vertical-analyst en el 050 Vertical Harness. Define el orden de lectura de los 17 inputs, las 6 tareas de extracción (definición de slice, IC-xx de la slice, BDD scenarios de la slice, riesgos, dependencias con slices previas, restricciones y stack), la regla de no-inferencia, el criterio de done y el límite de iteraciones. Usar cuando vertical-analyst ejecuta su análisis sobre los inputs del 050 para la slice activa.
user-invocable: false
agent: vertical-analyst
---

## Regla de no-inferencia (absoluta)

No inventar IC-xx, métodos, DTOs, BDD scenarios, riesgos ni dependencias que no estén presentes
en los 17 inputs. Si algo es ambiguo o está ausente, registrarlo como gap en la tabla de
"Gaps e Ítems de Escalamiento" y marcar con `[PENDIENTE: razón]`.

**Filtro de slice activa:** todo dato extraído debe pertenecer a la slice activa (VS-xx) según
`vertical_slice_plan.md` (I-1). No extraer IC-xx ni BDD scenarios de otras slices — aunque
aparezcan en los mismos archivos de input.

## Orden de lectura de inputs

Leer en este orden para construir el contexto progresivamente antes de ejecutar las tareas.
La slice activa se conoce desde el Sprint Contract en `harness-state.json` antes de comenzar.

1. `010_discovery/domain_glossary.md` — fijar el vocabulario obligatorio antes de leer nada más
2. `010_discovery/scope_boundaries.md` — identificar restricciones de scope que acotan la slice
3. `010_discovery/shared_understanding.md` — contexto del proyecto y del cliente
4. `010_discovery/failure_behavior.md` — comportamientos de fallo que la slice puede necesitar manejar
5. `040_planning/vertical_slice_plan.md` — **FUENTE PRINCIPAL**: lista canónica de IC-xx y BDD scenarios asignados a la slice activa; criterio de Done y esfuerzo
6. `040_planning/project_roadmap.md` — secuencia de slices y dependencias entre ellas
7. `040_planning/risk_register.md` — riesgos específicos de la slice activa (RK-xx)
8. `030_design/architecture_decision_records.md` — stack tecnológico (lenguaje, framework, ORM, testing framework)
9. `030_design/technical_blueprint.md` — MOD-xx relevantes para los IC-xx de la slice activa
10. `020_specification/data_contracts.md` — entidades del dominio que la slice manipula
11. `030_design/contract_definitions.md` — definiciones completas (firma, DTOs) de los IC-xx de la slice activa
12. `020_specification/bdd_features.md` — BDD scenarios (SC-xx/SE-xx) asignados a la slice activa
13. `020_specification/acceptance_criteria.md` — AC verificables de los BDD scenarios de la slice
14. `020_specification/error_exception_policy.md` — políticas de error para los SC-xx/SE-xx de la slice
15. `030_design/dependency_graph.md` — DEP-xx que involucran los IC-xx de la slice activa
16. `030_design/test_strategy_map.md` — estrategia mock/stub para los IC-xx de la slice activa (de I-8)
17. `050_vertical/VS-xx/*.md` (previas) — artefactos de slices anteriores completadas (contexto de implementación acumulado)

**Precondición crítica:** Si la sección de la slice activa no existe en `vertical_slice_plan.md`,
o si la slice activa no tiene ningún IC-xx asignado, emitir `ESCALAMIENTO REQUERIDO` inmediatamente.
No continuar sin una definición válida de la slice.

## Tareas de extracción

### Tarea 1 — Definición de la Slice Activa (Sección 1 del reporte)

Fuente: `040_planning/vertical_slice_plan.md` (I-1), `040_planning/project_roadmap.md` (I-2),
`040_planning/risk_register.md` (I-3).

Extraer de I-1 la sección correspondiente a la slice activa:
- Nombre descriptivo de la slice
- Tipo (Tracer Bullet / Crecimiento / MVP / Evolución / Robustez)
- Lista completa de IC-xx asignados a esta slice
- Lista completa de BDD scenarios (SC-xx/SE-xx) asignados a esta slice
- Criterio de Done
- Estimación de esfuerzo (XS/S/M/L/XL)

De I-2: extraer la lista de slices predecesoras (slices de las que depende esta slice) y su
estado actual según `harness-state.json["050_vertical"]["slices"]`.

De I-3: extraer los RK-xx específicos de esta slice (los que tienen esta slice como campo "Slice").

Reglas:
- Si I-1 no tiene sección explícita para la slice activa → gap bloqueante, escalamiento inmediato.
- Si la slice activa tiene dependencias con slices predecesoras que no están en estado `SLICE_COMPLETE`,
  registrar como gap bloqueante y escalar. El 050 no debe producir artefactos para una slice bloqueada.
- No incluir IC-xx ni BDD scenarios de otras slices aunque aparezcan en el mismo artefacto.

### Tarea 2 — IC-xx de la Slice Activa (Sección 2 del reporte)

Fuente: `030_design/contract_definitions.md` (I-5), `030_design/technical_blueprint.md` (I-4),
`030_design/dependency_graph.md` (I-6), `030_design/test_strategy_map.md` (I-8).

Para cada IC-xx asignado a la slice activa según I-1:
1. Localizar la definición completa en I-5.
2. Extraer:
   - Nombre de la interfaz (I[Nombre])
   - Módulo asignado (MOD-xx) de I-4
   - Firma de todos los métodos con tipos de parámetros y retorno
   - DTOs de request (si aplica)
   - DTOs de response (si aplica)
   - DTOs de error (código HTTP + nombre del DTO)
   - Estrategia mock/stub de I-8 (Fake / Mock / Real + descripción)
   - DEP-xx de I-6 que involucran esta IC-xx

Reglas:
- Si un IC-xx de I-1 no aparece en I-5 → gap bloqueante por IC-xx. Escalar al governor.
- Si la firma de un método está incompleta en I-5 → marcar como `[PENDIENTE: firma incompleta]`.
  No inventar firmas.
- Si la estrategia mock/stub no está en I-8 para este IC-xx → marcar `[PENDIENTE: no en test_strategy_map]`.
- Solo incluir IC-xx de la slice activa. Nunca incluir IC-xx de otras slices aunque aparezcan en I-5.

**Verificación de cobertura:** al terminar esta tarea, verificar que todos los IC-xx de I-1
para la slice activa tienen entrada en la Sección 2. Gap por cada IC-xx faltante.

### Tarea 3 — BDD Scenarios de la Slice Activa (Sección 3 del reporte)

Fuente: `020_specification/bdd_features.md` (I-9), `020_specification/acceptance_criteria.md` (I-11),
`020_specification/error_exception_policy.md` (I-12).

Para cada SC-xx/SE-xx asignado a la slice activa según I-1:
1. Localizar el scenario en I-9.
2. Extraer:
   - Nombre del scenario
   - Feature de origen en bdd_features.md
   - Pasos Given / When / Then completos
   - IC-xx que este scenario ejercita (relación con Tarea 2)
   - Criterio de aceptación verificable de I-11
   - Código HTTP de error esperado y nombre del DTO de error, de I-12 (o "N/A" si happy path sin restricciones)
   - Política de error aplicable de I-12 (o "N/A")

Reglas:
- Si un SC-xx/SE-xx de I-1 no aparece en I-9 → gap bloqueante. Escalar al governor.
- Si un SC-xx de I-1 no tiene AC en I-11 → gap bloqueante. El writer no puede producir la SDS sin AC.
- Si un SE-xx no tiene política de error en I-12 → marcar como `[PENDIENTE: no en error_exception_policy]`.
  Continuar con los demás scenarios.
- Solo incluir BDD scenarios de la slice activa según I-1. No incluir scenarios de otras slices.

**Verificación de cobertura:** al terminar, verificar que todos los SC-xx/SE-xx de I-1 para
la slice activa tienen entrada en la Sección 3.

### Tarea 4 — Riesgos Específicos de la Slice (Sección 4 del reporte)

Fuente: `040_planning/risk_register.md` (I-3).

Extraer todos los RK-xx de I-3 cuyo campo "Slice" sea la slice activa. Para cada RK-xx:
- Descripción del riesgo
- Categoría (Técnica / Dependencia / Ambigüedad / Arquitectura)
- Probabilidad (Alta / Media / Baja)
- Impacto (Alto / Medio / Bajo)
- Mitigación concreta documentada en I-3

Reglas:
- Si no hay RK-xx para la slice activa en I-3, registrar explícitamente "Ninguno registrado en
  risk_register.md para [VS-xx]". No inventar riesgos.
- No crear nuevos RK-xx. Solo los que están en I-3 son válidos.

### Tarea 5 — Dependencias con Slices Previas (Sección 5 del reporte)

Fuente: `040_planning/project_roadmap.md` (I-2), `030_design/dependency_graph.md` (I-6),
`050_vertical/VS-xx/*.md` previas (I-17).

De I-2: identificar las slices predecesoras de la slice activa (slices de las que depende).
Para cada predecesora:
- Estado en `harness-state.json["050_vertical"]["slices"]`
- IC-xx que aporta a la slice activa
- DEP-xx de respaldo de I-6

De I-17: revisar los artefactos de slices previas ya completadas en `/050_vertical/`.
Extraer decisiones de implementación relevantes para la slice activa:
- Decisiones de DI (inyección de dependencias) que la slice activa debe respetar
- Patrones aplicados en slices anteriores que deben replicarse o evitarse
- Módulos (MOD-xx) ya inicializados en slices previas que la activa reutilizará

Reglas:
- Si una predecesora no está en estado `SLICE_COMPLETE` → gap bloqueante, escalar al governor.
- Si no hay predecesoras: escribir "Ninguna — slice independiente" en la sección.
- Si I-17 no tiene artefactos disponibles (primera slice): escribir "No hay slices previas completadas".

### Tarea 6 — Restricciones y Contexto de Dominio (Sección 6 del reporte)

Fuente: `010_discovery/shared_understanding.md` (I-13), `010_discovery/domain_glossary.md` (I-14),
`010_discovery/scope_boundaries.md` (I-15), `010_discovery/failure_behavior.md` (I-16),
`030_design/architecture_decision_records.md` (I-7).

Extraer restricciones que acotan la implementación de esta slice específica:

**De I-15 (scope_boundaries):** restricciones explícitas que prohíben o limitan implementaciones
en el dominio de la slice activa. Solo las relevantes para los IC-xx o BDD scenarios de esta slice.

**De I-14 (domain_glossary):** términos de negocio que aparecerán en los artefactos de la slice.
Listar los términos del glosario que los artefactos deben usar consistentemente.

**De I-16 (failure_behavior):** comportamientos de fallo del dominio que la slice activa debe manejar.
Solo los que aplican a los IC-xx o BDD scenarios de esta slice.

**De I-7 (ADR-001):** resumen del stack tecnológico completo (lenguaje, framework, ORM, testing
framework, patrones arquitectónicos). El SDD debe respetar todas estas decisiones.

Reglas:
- Solo restricciones que afectan directamente los IC-xx o BDD scenarios de la slice activa.
- No incluir restricciones de slices futuras aunque aparezcan en los inputs.

## Criterio de done del análisis

Verificar después de completar las 6 tareas. Si alguna condición falla, actualizar el reporte
antes de reportar COMPLETED.

- [ ] `050_vertical/[VS-xx]/slice_analysis_report.md` escrito en disco (Write es el PRIMER tool call — LL-01)
- [ ] Sección 1: nombre, tipo, IC-xx, BDD scenarios, Done y esfuerzo de la slice activa extraídos de I-1
- [ ] Sección 1: tabla de predecesoras con estado actual
- [ ] Sección 2: tabla completa para cada IC-xx de la slice activa; firma, DTOs, mock/stub de I-5 y I-8
- [ ] Sección 2: tabla de verificación de cobertura de IC-xx (todos presentes o gap registrado)
- [ ] Sección 3: tabla completa para cada SC-xx/SE-xx de la slice; AC de I-11, política de error de I-12
- [ ] Sección 3: tabla de verificación de cobertura de BDD scenarios
- [ ] Sección 4: riesgos RK-xx de I-3 para la slice activa (o "Ninguno" explícito)
- [ ] Sección 5: dependencias con slices previas y contexto de I-17
- [ ] Sección 6: restricciones de scope, glosario local y stack del ADR-001
- [ ] Tabla de Gaps completa (o "Ninguno" explícito)
- [ ] Bloque de Cobertura al final del reporte con conteos exactos
- [ ] Estado del análisis: `LISTO PARA WRITER` o `ESCALAMIENTO REQUERIDO — [N] gaps bloqueantes`

Si todas las condiciones se verifican: reportar `COMPLETED` con path al archivo.
Si alguna condición falla: reportar `INCOMPLETO: <razón específica>`. No reportar COMPLETED.

## Límite de iteraciones

Si vertical-analyst ha sido ejecutado 2 veces o más sobre los mismos inputs y persisten gaps
bloqueantes sin resolución del governor, agregar en el reporte:

`ALERTA: 2 iteraciones completadas sin resolver gaps bloqueantes. Escalar al humano.`

Reportar `ESCALAMIENTO REQUERIDO` al governor. No ejecutar una tercera iteración sin instrucción
explícita del governor.
