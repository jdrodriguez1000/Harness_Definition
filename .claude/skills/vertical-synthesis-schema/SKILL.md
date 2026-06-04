---
name: vertical-synthesis-schema
description: Schema y formato de los 5 artefactos finales del 050 Vertical Harness producidos por vertical-writer para la slice activa. Usar cuando vertical-writer escribe los artefactos o cuando vertical-evaluator los lee para auditar.
user-invocable: false
agent: vertical-writer
---

Los 5 artefactos se escriben en la carpeta `/050_vertical/VS-xx/`. La carpeta ya existe (creada por el governor).
Sustituir `VS-xx` por el ID real de la slice activa en todos los paths.

## RUTA DE ESCRITURA — OBLIGATORIO (LL-29)

Todos los artefactos de esta slice viven bajo una única ruta:

`/050_vertical/[VS-xx]/`

NO crear artefactos en `/050_vertical/` directamente ni en subcarpetas diferentes.
El ID `[VS-xx]` viene del Sprint Contract en `harness-state.json["050_vertical"]["active_slice"]`.

**Orden de producción obligatorio:**

1. `proposal.md` — **PRIMER tool call** (LL-01). Define el valor de negocio y scope de la slice.
2. `software_design_specification.md` — segundo. Requiere el scope del proposal para estructurar flujos BDD.
3. `software_design_document.md` — tercero. Requiere la SDS para conocer los flujos y contratos de datos.
4. `testing_plan.md` — cuarto. Requiere el SDD para conocer la estrategia mock/stub por IC-xx.
5. `execution_plan.md` — quinto. Requiere el SDD y testing plan para descomponer en Tasks TDD.

---

## Artefacto 1 — proposal.md

**Path:** `/050_vertical/VS-xx/proposal.md`
**Escribir primero — PRIMER tool call (LL-01).** Define el scope de la slice; todos los artefactos siguientes dependen de él.

```markdown
# Proposal — [VS-xx]: [nombre de la slice]
Fecha: [fecha]
Harness: 050 Vertical
Producido por: vertical-writer

---

## Resumen ejecutivo

[2-3 frases describiendo el valor de negocio que aporta esta slice para el usuario final.
Usar lenguaje del domain_glossary.md. No jerga técnica.]

## Scope de la slice

**IC-xx implementados en esta slice:**

| IC-xx | Nombre de interfaz | Descripción funcional |
|-------|-------------------|----------------------|
| IC-xx | I[Nombre]         | [qué hace esta interfaz en términos de negocio] |

**BDD Scenarios cubiertos:**

| SC/SE-xx | Nombre | Tipo | Descripción |
|----------|--------|------|-------------|
| SC-xx    | [nombre] | Happy path | [qué logra el usuario] |
| SE-xx    | [nombre] | Error path | [qué pasa cuando falla] |

## Dependencias

| Slice predecesora | Estado requerido | IC-xx que aporta | Impacto en esta slice |
|-------------------|-----------------|-----------------|----------------------|
| VS-xx             | SLICE_COMPLETE  | IC-xx           | [qué necesita de la predecesora] |

(Si no hay dependencias: "Ninguna — esta slice no depende de otras.")

## Riesgos

| RK-xx | Descripción | Probabilidad | Impacto | Mitigación |
|-------|-------------|--------------|---------|------------|
| RK-xx | [descripción] | Alta/Media/Baja | Alto/Medio/Bajo | [acción concreta] |

## Criterio de Done

[Criterio de Done extraído de vertical_slice_plan.md para esta slice — citar textualmente con
referencias a IC-xx y SC-xx/SE-xx específicos.]

## Valor de negocio para el cliente

[Párrafo describiendo qué puede hacer el cliente/usuario final cuando esta slice esté completa
que no podía hacer antes. Lenguaje de negocio, no técnico.]
```

---

## Artefacto 2 — software_design_specification.md

**Path:** `/050_vertical/VS-xx/software_design_specification.md`

```markdown
# Software Design Specification — [VS-xx]: [nombre de la slice]
Fecha: [fecha]
Harness: 050 Vertical
Producido por: vertical-writer

---

## Resumen de la slice

**Slice activa:** [VS-xx] — [nombre]
**IC-xx en scope:** [lista]
**BDD Scenarios en scope:** [lista SC-xx/SE-xx]

---

## Flujos funcionales por BDD Scenario

### SC-xx — [nombre del scenario]

**Given / When / Then:**
```gherkin
Given [precondición]
When  [acción del usuario]
Then  [resultado esperado]
```

**Flujo paso a paso:**
1. [paso 1 — qué hace el sistema]
2. [paso 2]
3. [resultado final]

**Contrato de datos:**
- Request: `[NombreDTO]` — campos: [campo1: tipo, campo2: tipo]
- Response: `[NombreDTO]` — campos: [campo1: tipo, campo2: tipo]
- HTTP method: [GET/POST/PUT/DELETE]
- Endpoint: [path del endpoint si aplica]

**Criterio de aceptación verificable:**
[AC de acceptance_criteria.md — citar textualmente.]

---

### SE-xx — [nombre del scenario de error]

**Given / When / Then:**
```gherkin
Given [precondición]
When  [condición de error]
Then  [comportamiento de error esperado]
```

**Flujo de error:**
1. [paso 1]
2. [detección de error]
3. [respuesta del sistema]

**Contrato de datos de error:**
- Error response: `[NombreErrorDTO]` — campos: [campo1: tipo]
- Código HTTP: [código]
- Política de error: [referencia a error_exception_policy.md]

**Criterio de aceptación verificable:**
[AC de acceptance_criteria.md para este scenario de error.]

---

[Repetir sección por cada SC-xx/SE-xx asignado a la slice activa.]

## Restricciones de implementación

[Restricciones de scope_boundaries.md (I-15) que aplican a esta slice.]
[Comportamientos de fallo de failure_behavior.md (I-16) relevantes para esta slice.]

## Glosario local (de domain_glossary.md)

| Término | Definición |
|---------|-----------|
| [término usado en la SDS] | [definición del glosario] |
```

---

## Artefacto 3 — software_design_document.md

**Path:** `/050_vertical/VS-xx/software_design_document.md`

```markdown
# Software Design Document — [VS-xx]: [nombre de la slice]
Fecha: [fecha]
Harness: 050 Vertical
Stack: [tecnología principal del ADR-001]
Producido por: vertical-writer

---

## Resumen técnico

**Slice activa:** [VS-xx] — [nombre]
**Stack (ADR-001):** [lenguaje + framework + ORM + testing framework]
**Módulos afectados:** [MOD-xx, ...]
**IC-xx a implementar:** [lista]

---

## Interfaces a implementar (IC-xx)

### IC-xx — I[NombreInterface]

**Módulo:** MOD-xx — [nombre del módulo] (de technical_blueprint.md)
**Responsabilidad:** [qué abstrae esta interfaz en términos de dominio]

**Firma completa:**
```[lenguaje del stack]
interface I[Nombre] {
  [método1](params: [Tipo]): [ReturnType];
  [método2](params: [Tipo]): [ReturnType];
}
```

**DTOs:**
```[lenguaje]
// Request
type [NombreRequestDTO] = {
  [campo]: [Tipo];
}

// Response
type [NombreResponseDTO] = {
  [campo]: [Tipo];
}

// Error
type [NombreErrorDTO] = {
  [campo]: [Tipo];
  httpCode: [número];
}
```

**Estrategia de Dependency Injection:**
[Qué clase implementa esta interfaz. Cómo se inyecta (constructor/factory). Quién la consume.]

**Orden de implementación:** [posición en la secuencia TDD de esta slice]

---

[Repetir sección por cada IC-xx de la slice activa.]

## Dependencias entre IC-xx de esta slice

| IC-xx | Depende de | Razón |
|-------|-----------|-------|
| IC-xx | IC-xx     | [por qué necesita esta interfaz] |

(Si no hay dependencias entre IC-xx de la slice: "Las IC-xx de esta slice son independientes entre sí".)

## Módulos tocados (MOD-xx)

| MOD-xx | Nombre | Capa | Cambios en esta slice |
|--------|--------|------|----------------------|
| MOD-xx | [nombre] | [capa: Controller/Service/Repository/...] | [qué se agrega o modifica] |

## Orden de implementación de componentes

(Secuencia en la que los componentes deben implementarse para respetar TDD. Primero lo más simple.)

1. [componente 1 — ej. DTO + test de schema]
2. [componente 2 — ej. interfaz + implementación stub]
3. [...]
4. [componente N — ej. integración completa]

## Consistencia con ADR-001

[Confirmación de que todas las decisiones del SDD son consistentes con el stack y los patrones
definidos en architecture_decision_records.md. Indicar ADR-xx relevantes.]
```

---

## Artefacto 4 — testing_plan.md

**Path:** `/050_vertical/VS-xx/testing_plan.md`

```markdown
# Testing Plan — [VS-xx]: [nombre de la slice]
Fecha: [fecha]
Harness: 050 Vertical
Framework de tests: [nombre del framework del ADR-001]
Producido por: vertical-writer

---

## Resumen de cobertura

**IC-xx de la slice:** [lista]
**BDD Scenarios de la slice:** [lista SC-xx/SE-xx]
**Total tests unitarios previstos:** [N]
**Total tests de integración previstos:** [N]
**Total tests de contrato previstos:** [N]

---

## Estrategia por IC-xx

### IC-xx — I[NombreInterface]

**Estrategia mock/stub (de test_strategy_map.md):** [Fake / Mock / Real]
**Descripción de la estrategia:** [cómo se usa en el testing — qué se mockea, qué no]

**Red phase — tests a escribir primero (antes de implementar):**

| Test ID | Descripción | BDD Scenario | Tipo | Falla esperada |
|---------|-------------|--------------|------|----------------|
| T-01    | [descripción] | SC-xx | Unitario | [por qué debe fallar inicialmente] |
| T-02    | [descripción] | SE-xx | Integración | [comportamiento de error a testear] |

**Mock/stub configurable:**
```[lenguaje del framework de tests]
// Configuración del mock para los tests de esta IC-xx
const mock[Nombre] = jest.fn() | pytest-mock | [equivalente en el stack]
mock[Nombre].[método].mockReturnValue([valor de retorno por defecto])
// Stub para error:
mock[Nombre].[método].mockRejectedValue(new [ErrorClass]())
```

---

[Repetir sección por cada IC-xx de la slice activa.]

## Pirámide de tests de la slice

| Nivel | Cantidad | Descripción |
|-------|----------|-------------|
| Unitario | [N] | [qué se prueba con tests unitarios] |
| Integración | [N] | [qué se prueba con tests de integración] |
| Contrato | [N] | [qué se prueba con tests de contrato — si aplica] |

## Orden Red → Green por BDD Scenario

### SC-xx — [nombre]

1. **Red:** escribir `[nombre del test]` — falla porque [IC-xx] no está implementada
2. **Green:** implementar `[método]` de [IC-xx] — test pasa
3. **Refactor:** [qué se refactoriza — o "sin refactor necesario en esta iteración"]

---

[Repetir por cada SC-xx/SE-xx de la slice.]

## Cobertura esperada

**Criterio mínimo de cobertura:** [porcentaje o regla — ej. ≥80% de líneas en los módulos tocados]
**IC-xx con tests:** [N]/[N total en la slice]
**BDD scenarios con tests:** [N]/[N total en la slice]
```

---

## Artefacto 5 — execution_plan.md

**Path:** `/050_vertical/VS-xx/execution_plan.md`

```markdown
# Execution Plan — [VS-xx]: [nombre de la slice]
Fecha: [fecha]
Harness: 050 Vertical
Producido por: vertical-writer

---

## Resumen de descomposición

**Features:** [N]
**Tickets:** [N total]
**Tasks:** [N total]
**Todos los IC-xx de la slice asignados a ≥1 task:** SÍ / NO

---

## Feature FT-01 — [nombre de la Feature]

**Descripción:** [qué funcionalidad entrega esta Feature en términos de negocio]
**IC-xx cubiertos:** [lista de IC-xx]
**BDD Scenarios cubiertos:** [lista SC-xx/SE-xx]

### Ticket TK-01 — [nombre del Ticket]

**Descripción:** [qué implementa este Ticket]
**IC-xx:** [IC-xx que implementa]
**BDD Scenario:** [SC-xx/SE-xx que prueba]
**Criterio de Done:** [condición verificable — ej. "SC-xx pasa en integración con cobertura ≥80%"]

**Tasks en orden TDD:**

| TA-xx | Fase | Descripción | IC-xx / SC-xx | Estimación |
|-------|------|-------------|---------------|------------|
| TA-01 | Red    | Escribir test [nombre] que falla porque [IC-xx] no existe | IC-xx, SC-xx | [XS/S/M] |
| TA-02 | Green  | Implementar [método] de [IC-xx] hasta que test pase | IC-xx | [XS/S/M] |
| TA-03 | Refactor | [descripción del refactor — o "Sin refactor" si no aplica] | IC-xx | [XS/S] |

---

### Ticket TK-02 — [nombre del Ticket]

[Repetir estructura de Ticket con Tasks TDD.]

---

[Repetir Feature FT-xx y Tickets TK-xx por cada agrupación funcional de la slice.]

## Verificación de cobertura de IC-xx

| IC-xx | Feature/Ticket/Task donde aparece | Estado |
|-------|----------------------------------|--------|
| IC-xx | FT-01/TK-01/TA-02              | CUBIERTO |

(Cada IC-xx de la slice debe aparecer en ≥1 Task. Si alguno falta: INCOMPLETO.)

## Convención de IDs

Los IDs FT-xx, TK-xx y TA-xx son **locales a esta slice**. Para referenciarlos desde otros artefactos
o slices, usar el prefijo de slice: `[VS-xx]-FT-01`, `[VS-xx]-TK-02`, `[VS-xx]-TA-03`.
```

---

## Verificación cruzada entre los 5 artefactos (vertical-writer al terminar)

Antes de ejecutar el self-checklist del Demo Statement, verificar la consistencia entre los 5 artefactos:

- [ ] `proposal.md`: lista todos los IC-xx de la slice según I-1 (vertical_slice_plan.md)
- [ ] `proposal.md`: lista todos los BDD scenarios de la slice según I-1
- [ ] `software_design_specification.md`: tiene ≥1 sección por cada SC-xx/SE-xx de la slice
- [ ] `software_design_specification.md`: no referencia BDD scenarios de otras slices
- [ ] `software_design_document.md`: referencia solo IC-xx definidos en I-5 (contract_definitions.md)
- [ ] `software_design_document.md`: incluye firma técnica completa para cada IC-xx de la slice
- [ ] `software_design_document.md`: consistente con el stack del ADR-001 (I-7)
- [ ] `testing_plan.md`: tiene ≥1 estrategia de test por IC-xx de la slice, consistente con I-8
- [ ] `testing_plan.md`: define fase Red explícitamente (qué tests escribir primero)
- [ ] `execution_plan.md`: todos los IC-xx de la slice asignados a ≥1 Task
- [ ] `execution_plan.md`: orden TDD explícito (Red→Green→Refactor) en cada Ticket
- [ ] `execution_plan.md`: Criterio de Done verificable por Ticket con referencias a SC-xx o IC-xx
- [ ] Sin IC-xx referenciados que no existan en I-5 (contract_definitions.md)
- [ ] Sin BDD scenarios referenciados que no existan en I-9 (bdd_features.md)
- [ ] Lenguaje ubicuo del domain_glossary.md (I-14) usado consistentemente en los 5 artefactos
- [ ] Los 5 archivos existen en `/050_vertical/[VS-xx]/` con contenido (Write ejecutado para cada uno — LL-01)

## Reglas de escritura

- **`proposal.md` es el PRIMER tool call** después de completar la lectura del slice_analysis_report.
  Sin excepción. No producir ningún otro artefacto antes de haber escrito proposal.md en disco.
- El campo `Estado` no aplica a los artefactos del 050 — no hay campo `Estado: DRAFT` en ninguno de los 5.
  El governor actualiza `harness-state.json` para rastrear el estado de la slice.
- No inventar IC-xx, métodos, DTOs ni BDD scenarios. Todo debe ser trazable a I-1..I-17.
- Si un dato necesario no está disponible en los inputs: marcar con `[PENDIENTE: razón]` y continuar.
- Los IDs FT-xx, TK-xx y TA-xx son nuevos (asignados por el writer en el execution_plan). Empezar en FT-01, TK-01, TA-01.
- **La firma técnica del SDD debe coincidir exactamente con la que el vertical-evaluator verificará en D2.**
  No usar variantes (ej. `getById` vs `findById` — elegir uno y usarlo consistentemente en todos los artefactos).
