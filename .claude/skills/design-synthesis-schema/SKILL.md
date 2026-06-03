---
name: design-synthesis-schema
description: Schema y formato de los 5 artefactos finales del 030 Design Harness producidos por design-architect. Usar cuando design-architect escribe los artefactos o cuando design-evaluator los lee para auditar.
user-invocable: false
agent: design-architect
---

Los 5 artefactos deben escribirse en la carpeta `/030_design/`. La carpeta ya existe (creada por el governor en E10-A).

**Orden de producción obligatorio:**

1. `architecture_decision_records.md` — primero, siempre. ADR-001 (stack) debe existir antes de que cualquier otro artefacto referencie tecnologías concretas.
2. `technical_blueprint.md` — define la estructura de capas y módulos (MOD-xx).
3. `contract_definitions.md` — define interfaces (IC-xx) y DTOs (DTO-xx) usando el stack del ADR-001.
4. `dependency_graph.md` — describe cómo se conectan los MOD-xx y cómo se implementan los IC-xx.
5. `test_strategy_map.md` — cubre cada IC-xx con su estrategia de mock/stub; incluye Guía de Vertical Slices.

Las IDs que el architect recibe desde `design_analysis_report.md` y debe referenciar:
- `CO-xx` — componentes / bounded contexts
- `IC-xx` — interfaces requeridas (el analyst las identifica; el architect las formaliza con firmas y DTOs)
- `PT-xx` — patrones de diseño propuestos
- `RT-xx` — restricciones tecnológicas (acotan el ADR-001)

Las IDs que el architect asigna en los artefactos finales:
- `MOD-xx` — módulos en technical_blueprint
- `IC-xx` — interfaces en contract_definitions
- `DTO-xx` — data transfer objects en contract_definitions
- `DEP-xx` — dependencias en dependency_graph
- `ADR-xx` — architecture decision records
- `TS-xx` — ítems de test strategy en test_strategy_map

---

## Artefacto 1 — architecture_decision_records.md

**Path:** `/030_design/architecture_decision_records.md`
**Producir primero.** ADR-001 define el stack; sin él ningún otro artefacto puede mencionar tecnologías concretas.

```markdown
# Architecture Decision Records — 030 Design
Fecha: [fecha]
Estado: DRAFT | APROBADO POR CLIENTE
Producido por: design-architect

---

## ADR-001 — Selección de Stack Tecnológico

**ID:** ADR-001
**Fecha:** [fecha]
**Estado:** ACEPTADO

### Contexto

[Descripción del sistema a construir, su escala esperada, restricciones tecnológicas
identificadas (RT-xx) y criterios de selección derivados del design_analysis_report.]

Restricciones aplicables:
- RT-01: [descripción]
- RT-xx: [descripción]

### Opciones evaluadas

| Opción | Descripción | Pros | Contras |
|--------|-------------|------|---------|
| Opción A | [nombre stack] | [ventajas] | [desventajas] |
| Opción B | [nombre stack] | [ventajas] | [desventajas] |
| [Opción C si aplica] | ... | ... | ... |

### Criterios de decisión

| Criterio | Peso | Opción elegida justificación |
|----------|------|------------------------------|
| [criterio 1] | alto / medio / bajo | [por qué la opción elegida gana en este criterio] |
| [criterio 2] | ... | ... |

### Decisión

Stack seleccionado: **[nombre del stack completo]**

Componentes:
- Lenguaje: [nombre y versión]
- Framework principal: [nombre y versión]
- ORM / Acceso a datos: [nombre si aplica]
- Infraestructura de base: [contenedores, nube, servidor, etc.]
- [Otros componentes relevantes]

### Consecuencias aceptadas

[Qué limitaciones o trade-offs se aceptan al elegir este stack. Qué queda fuera de alcance
por esta decisión. Qué se facilita.]

---

## ADR-002 — [Patrón de Diseño Mayor: nombre]

**ID:** ADR-002
**Fecha:** [fecha]
**Estado:** ACEPTADO
**Patrón origen:** PT-xx

### Contexto

[Problema técnico que motiva este patrón, derivado del design_analysis_report.]

### Decisión

[Descripción del patrón seleccionado y cómo se aplica en este sistema.]

Componentes afectados: [CO-xx, CO-xx]

### Consecuencias aceptadas

[Trade-offs y limitaciones del patrón en este contexto.]

---

[Repetir sección ADR-xx por cada patrón de diseño mayor o decisión técnica significativa.
Mínimo ADR-001. Agregar un ADR por cada PT-xx del analysis_report que represente una
decisión arquitectónica relevante (no detalles de implementación).]
```

**Reglas:**
- ADR-001 es obligatorio y debe incluir: contexto con RT-xx, ≥2 opciones evaluadas con pros/contras, criterios de decisión con peso, y decisión con lista de componentes del stack.
- Un ADR adicional por cada PT-xx que represente un patrón de diseño mayor (Repository, Strategy, Factory, etc.).
- `Estado: DRAFT` hasta aprobación de A en CP-04.

---

## Artefacto 2 — technical_blueprint.md

**Path:** `/030_design/technical_blueprint.md`
**Producir segundo.** Requiere que ADR-001 esté completo para poder mencionar tecnologías concretas en los módulos.

```markdown
# Technical Blueprint — 030 Design
Fecha: [fecha]
Estado: DRAFT | APROBADO POR CLIENTE
Producido por: design-architect
Stack de referencia: ADR-001

---

## Estructura de Capas

[Descripción de las capas del sistema y sus responsabilidades, derivadas del análisis
de capas del design_analysis_report.]

| Capa | Responsabilidad | Puede importar de |
|------|-----------------|-------------------|
| Dominio | Lógica de negocio pura; entidades, interfaces (IC-xx) como contratos abstractos | Ninguna capa externa |
| Aplicación | Orquestación de casos de uso; invoca IC-xx | Dominio |
| Infraestructura | Implementaciones concretas de IC-xx (DB, APIs, Notifiers) | Dominio, librerías externas |

---

## Módulos del Sistema

[Un módulo por bounded context identificado en el design_analysis_report. Cada CO-xx
del analyst → al menos un MOD-xx aquí.]

### MOD-01 — [Nombre del Módulo] (CO-xx)

**Bounded context origen:** CO-xx
**Capa principal:** Dominio / Aplicación / Infraestructura
**Descripción:** [qué agrupa este módulo]

#### Estructura de carpetas

```
[nombre-modulo]/
├── domain/
│   ├── [EntidadPrincipal].py        — Entidad de dominio
│   ├── [IInterfaz].py               — Interface / Puerto (IC-xx)
│   └── [ServicioDominio].py         — Lógica de negocio
├── application/
│   ├── [CasoDeUso].py               — Orquestador del flujo
│   └── [DTOEntrada].py              — DTO-xx de entrada
└── infrastructure/
    ├── [ImplementacionRepo].py      — Implementación de IC-xx
    └── [DTORespuesta].py            — DTO-xx de salida
```

#### Skeleton de clases e interfaces principales

```[lenguaje del ADR-001]
# [IInterfaz] — IC-xx
class IProductoRepository(ABC):
    @abstractmethod
    def find_by_id(self, id: str) -> Optional[ProductoDTO]: ...

    @abstractmethod
    def save(self, producto: Producto) -> None: ...

# [EntidadDominio]
class Producto:
    def __init__(self, id: str, nombre: str, stock: int): ...
    def reducir_stock(self, cantidad: int) -> None: ...
```

[Repetir sección MOD-xx por cada bounded context CO-xx del analysis_report.]

---

## Resumen de Módulos

| MOD-xx | Nombre | Bounded Context (CO-xx) | Capa | Interfaces (IC-xx) |
|--------|--------|------------------------|------|-------------------|
| MOD-01 | ...    | CO-xx                  | ...  | IC-xx, IC-xx      |
```

**Reglas:**
- Un MOD-xx por cada CO-xx del analysis_report. Sin CO-xx huérfanos.
- La estructura de carpetas usa el lenguaje del ADR-001.
- El skeleton de clases e interfaces muestra firmas de métodos, no implementaciones.
- Los nombres de clases e interfaces usan el lenguaje ubicuo del `domain_glossary.md`.
- `Estado: DRAFT` hasta aprobación de A en CP-04.

---

## Artefacto 3 — contract_definitions.md

**Path:** `/030_design/contract_definitions.md`
**Producir tercero.** Formaliza cada IC-xx del analysis_report con firmas completas de métodos y DTOs.

```markdown
# Contract Definitions — 030 Design
Fecha: [fecha]
Estado: DRAFT | APROBADO POR CLIENTE
Producido por: design-architect
Stack de referencia: ADR-001

---

## Interfaces por Bounded Context

### MOD-01 — [Nombre del Módulo]

#### IC-01 — I[NombreInterface]

**Tipo:** Repository / Service / Notifier / API
**IC-xx origen (analysis_report):** IC-xx
**Entidad de negocio:** [entidad de data_contracts.md]
**Módulo propietario:** MOD-xx

```[lenguaje del ADR-001]
class I[Nombre](ABC):

    @abstractmethod
    def [metodo_1](self, [param]: [tipo]) -> [tipo_retorno]:
        """[descripción en una línea]"""
        ...

    @abstractmethod
    def [metodo_2](self, [param]: [tipo]) -> [tipo_retorno]: ...
```

**DTOs asociados:**

```[lenguaje del ADR-001]
@dataclass
class [EntidadDTO]:           # DTO-xx — transferencia de datos
    [campo_1]: [tipo]         # [descripción breve]
    [campo_2]: [tipo]

@dataclass
class [EntidadErrorDTO]:      # DTO-xx — respuesta de error
    codigo: str
    mensaje: str
    campo_afectado: Optional[str] = None
```

[Repetir IC-xx por cada IC-xx del analysis_report.]

---

## Resumen de Contratos

| IC-xx | Interface | Tipo | IC-xx origen | MOD-xx | DTOs (DTO-xx) |
|-------|-----------|------|-------------|--------|--------------|
| IC-01 | ...       | ...  | IC-xx       | MOD-xx | DTO-xx, DTO-xx |

---

## Resumen de DTOs

| DTO-xx | Nombre | Propósito | IC-xx propietaria | Campos principales |
|--------|--------|-----------|------------------|-------------------|
| DTO-01 | ...    | request / response / error | IC-xx | [lista] |
```

**Reglas:**
- Toda IC-xx del analysis_report debe tener su IC-xx correspondiente. Sin IC-xx huérfanas.
- Toda entidad de `data_contracts.md` que tenga IC-xx debe tener ≥1 DTO-xx de request o response.
- Los errores de cada IC-xx deben tener ≥1 DTO-xx de error.
- Usar los tipos del lenguaje definido en ADR-001. Nunca tipos genéricos de pseudocódigo.
- Los nombres de interfaces, métodos y DTOs usan el lenguaje ubicuo del `domain_glossary.md`.
- `Estado: DRAFT` hasta aprobación de A en CP-04.

---

## Artefacto 4 — dependency_graph.md

**Path:** `/030_design/dependency_graph.md`
**Producir cuarto.** Documenta cómo se conectan los módulos y cómo se gestiona la inyección de dependencias.

```markdown
# Dependency Graph — 030 Design
Fecha: [fecha]
Estado: DRAFT | APROBADO POR CLIENTE
Producido por: design-architect
Stack de referencia: ADR-001

---

## Topología de Dependencias

[Descripción textual de la topología completa. Puede complementarse con diagrama ASCII.]

```
[MOD-01 Dominio]
    ↑ implementa
[MOD-01 Infraestructura] → [IC-01 (puerto)]
    ↑ invoca
[MOD-01 Aplicación] → [IC-01 (interfaz abstracta)]
    ↑ instancia (DI)
[Contenedor de DI / Configuración]
```

---

## Dependencias por Módulo

| DEP-xx | Módulo origen (MOD-xx) | Módulo/Componente destino | Tipo de dependencia | Interface (IC-xx) |
|--------|------------------------|--------------------------|--------------------|--------------------|
| DEP-01 | MOD-01 Aplicación      | MOD-01 Infraestructura    | Inyección de dependencia | IC-01 |
| DEP-xx | ...                    | ...                       | ...                | ...                |

**Tipos de dependencia:**
- `Inyección de dependencia` — el módulo recibe la implementación por constructor o setter
- `Invocación directa` — dependencia estática (solo dentro de la misma capa)
- `Evento` — comunicación desacoplada vía sistema de eventos

---

## Estrategia de Inyección de Dependencias

**Mecanismo seleccionado:** [framework DI del ADR-001 / manual / contenedor propio]

### Puntos de inyección por módulo

#### MOD-01 — [Nombre]

| Clase / Servicio | Dependencia inyectada (IC-xx) | Punto de inyección | Scope |
|-----------------|------------------------------|-------------------|-------|
| [CasoDeUso]     | IC-01                         | Constructor        | request / singleton |
| ...             | ...                           | ...                | ...   |

[Repetir por cada módulo con dependencias inyectadas.]

---

## Reglas de Dependencia (guardianes de arquitectura)

1. **Dominio no importa Infraestructura.** Si un módulo de Dominio necesita algo de Infraestructura, debe definir una IC-xx y dejar que Infraestructura la implemente.
2. **Aplicación no instancia implementaciones concretas.** Solo recibe IC-xx inyectadas.
3. **Infraestructura puede importar librerías externas** (ORM, cliente HTTP, etc.) pero no puede contener lógica de negocio.
4. **Dependencias entre bounded contexts (MOD-xx) van siempre vía IC-xx**, nunca imports directos entre módulos de dominio.
```

**Reglas:**
- Toda IC-xx de `contract_definitions.md` debe aparecer al menos una vez en la tabla de Dependencias.
- Los puntos de inyección deben ser coherentes con el mecanismo DI del ADR-001.
- Cada DEP-xx debe referenciar el MOD-xx origen y el IC-xx que actúa como contrato.
- `Estado: DRAFT` hasta aprobación de A en CP-04.

---

## Artefacto 5 — test_strategy_map.md

**Path:** `/030_design/test_strategy_map.md`
**Producir quinto.** Cubre cada IC-xx con su estrategia de mock/stub e incluye la Guía de Vertical Slices (ADJ-04).

```markdown
# Test Strategy Map — 030 Design
Fecha: [fecha]
Estado: DRAFT | APROBADO POR CLIENTE
Producido por: design-architect
Stack de referencia: ADR-001

---

## Estrategia de Test por Interface

[Una entrada TS-xx por cada IC-xx de contract_definitions.md.]

| TS-xx | Interface (IC-xx) | Nivel de test | Herramienta de mock/stub | Punto de inyección (DEP-xx) | Escenario BDD cubierto |
|-------|-------------------|--------------|--------------------------|----------------------------|----------------------|
| TS-01 | IC-01 — I[Nombre] | Unitario | [framework mock del ADR-001] | DEP-xx | SC-xx, SE-xx |
| TS-xx | ...               | Integración / Contrato | ... | ... | ... |

**Niveles de test:**
- `Unitario` — mock completo de la dependencia; prueba la lógica de negocio aislada
- `Integración` — implementación real conectada a infraestructura de test (ej. DB en memoria)
- `Contrato` — verifica que la implementación cumple el contrato de la IC-xx

---

## Detalle de Estrategia por Interface

### TS-01 — IC-01: I[NombreInterface]

**Tipo de test primario:** Unitario
**Herramienta:** [pytest-mock / Mockito / jest.fn() — según ADR-001]

#### Mock/Stub de referencia

```[lenguaje del ADR-001]
# Mock para tests unitarios del caso de uso que usa IC-01
class Mock[Nombre]Repository:
    def __init__(self):
        self._store = {}

    def find_by_id(self, id: str):
        return self._store.get(id)

    def save(self, entidad):
        self._store[entidad.id] = entidad
```

#### Casos de test derivados de BDD

| Caso de test | Escenario BDD | Given (estado del mock) | When (acción) | Then (verificación) |
|-------------|--------------|------------------------|---------------|---------------------|
| test_[accion]_[resultado] | SC-xx | mock retorna [valor] | llamar [metodo] | verificar [resultado] |
| test_[accion]_[error] | SE-xx | mock lanza [excepción] | llamar [metodo] | verificar manejo de error |

[Repetir TS-xx por cada IC-xx de contract_definitions.md.]

---

## Guía de Vertical Slices

> Esta sección es input directo para el 040 Planning. Define las fronteras naturales de
> slicing para que el 040 pueda planificar iteraciones coherentes con la arquitectura.

### Slice 1 — Tracer Bullet

**Objetivo:** Demostrar que la arquitectura funciona de extremo a extremo con el flujo más simple.
**Scope:**
- Módulo(s): [MOD-xx]
- Interface(s): [IC-xx]
- Escenario BDD de referencia: [SC-xx — nombre]
- Endpoint / punto de entrada: [ruta o evento más simple del sistema]

**Artefactos técnicos necesarios:**
- [ ] IC-xx implementada (versión mínima)
- [ ] DTO-xx de request y response
- [ ] Caso de uso básico funcional
- [ ] Test unitario con mock de IC-xx

**Criterio de éxito:** El flujo del SC-xx de referencia se ejecuta de extremo a extremo sin errores.

---

### Slice 2 — MVP

**Objetivo:** Funcionalidad mínima que aporta valor real al usuario.
**Scope:**
- Módulo(s): [MOD-xx, MOD-xx]
- Interface(s): [IC-xx, IC-xx]
- Escenarios BDD cubiertos: [SC-xx, SC-xx, SE-xx]

**Artefactos técnicos necesarios:**
- [ ] Todos los IC-xx del scope implementados
- [ ] Tests unitarios + ≥1 test de integración
- [ ] Manejo de errores según error_exception_policy.md para los SE-xx cubiertos

**Criterio de éxito:** Los escenarios BDD del scope pasan en un entorno de test integrado.

---

### Slice 3 — Robustez

**Objetivo:** Cobertura completa de casos de borde, rendimiento y funcionalidades secundarias.
**Scope:**
- Módulo(s): todos los MOD-xx
- Interface(s): todas las IC-xx
- Escenarios BDD cubiertos: todos los SC-xx y SE-xx

**Artefactos técnicos necesarios:**
- [ ] Cobertura de test ≥ umbral definido en acceptance_criteria.md
- [ ] Tests de contrato para todas las IC-xx
- [ ] Todos los DTO-xx de error implementados y testeados

**Criterio de éxito:** Todos los escenarios BDD pasan; rúbrica del 040 aprobada.

---

## Resumen de cobertura

| IC-xx | TS-xx | Nivel | Slice |
|-------|-------|-------|-------|
| IC-01 | TS-01 | Unitario | Tracer Bullet |
| ...   | ...   | ...   | ...   |

(Verificar que toda IC-xx de contract_definitions.md tiene ≥1 TS-xx en esta tabla.)
```

**Reglas:**
- Toda IC-xx de `contract_definitions.md` debe tener ≥1 TS-xx. Sin IC-xx sin estrategia de test.
- La **Guía de Vertical Slices (ADJ-04 + ADJ-32)** usa la nomenclatura formal:
  `VS-Tracer Bullet → VS-Crecimiento-1..N (opcional) → VS-MVP → VS-Evolución-1..M (opcional) → VS-Robustez`
  Tracer Bullet, MVP y Robustez son obligatorios. Crecimiento (0..N) y Evolución (0..M) tienen piso mínimo por tamaño:

  | IC-xx totales | MOD-xx totales | N mínimo | M mínimo |
  |---------------|----------------|----------|----------|
  | ≤ 4           | ≤ 2            | 0        | 0        |
  | 5 – 7         | 3 – 4          | 1        | 1        |
  | ≥ 8           | ≥ 5            | 2        | 1        |

  Criterio de división por slice: máx. 3 IC-xx nuevas, 2 MOD-xx nuevos, 10 BDD scenarios nuevos.
  Si una slice supera cualquier límite → dividirla. El número final emerge de la evaluación.
- Por cada slice, incluir los **5 campos obligatorios**:
  1. **Nombre** — identificador único (ej. `VS-Tracer Bullet`, `VS-Crecimiento-1`, `VS-MVP`)
  2. **Tipo** — `hito-principal` (Tracer Bullet, MVP, Robustez) u `opcional` (Crecimiento-N, Evolución-M)
  3. **IC-xx asignados** — interfaces de `contract_definitions.md` que se implementan en esta slice
  4. **BDD scenarios** — SC-xx y SE-xx de `bdd_features.md` que cubre esta slice
  5. **Criterio de Done** — hitos principales: criterio riguroso y explícito; opcionales: liviano ("feature X integrada y pasando tests")
- Los mock/stub de referencia usan el lenguaje y herramientas del ADR-001.
- Los casos de test derivados de BDD referencian SC-xx y SE-xx de `bdd_features.md`.
- `Estado: DRAFT` hasta aprobación de A en CP-04. **El governor edita el campo Estado a `APROBADO POR CLIENTE` en los 5 artefactos tras CP-04 — el architect siempre escribe `DRAFT`.**

---

## Verificación cruzada entre artefactos (design-architect al terminar)

Antes de ejecutar el self-checklist del Demo Statement, verificar la consistencia entre los 5 artefactos:

- [ ] Cada CO-xx del analysis_report tiene ≥1 MOD-xx en `technical_blueprint.md`
- [ ] Cada IC-xx del analysis_report tiene ≥1 IC-xx en `contract_definitions.md`
- [ ] Cada IC-xx de `contract_definitions.md` tiene ≥1 DEP-xx en `dependency_graph.md`
- [ ] Cada IC-xx de `contract_definitions.md` tiene ≥1 TS-xx en `test_strategy_map.md`
- [ ] ADR-001 existe en `architecture_decision_records.md` con ≥2 opciones evaluadas
- [ ] Ningún artefacto menciona una tecnología no definida en ADR-001
- [ ] Todos los nombres de clases, interfaces y métodos usan términos del `domain_glossary.md`
- [ ] `test_strategy_map.md` tiene sección "Guía de Vertical Slices" con Tracer Bullet, MVP y Robustez; cada slice tiene los 5 campos: nombre, tipo, IC-xx asignados, BDD scenarios (SC-xx/SE-xx), criterio de Done
- [ ] Los 5 archivos existen en `/030_design/` con contenido (Write ejecutado para cada uno)
