---
name: design-rubric
description: Rúbrica de evaluación del 030 Design Harness. Define las 5 dimensiones de evaluación, las anclas de calibración (0.2/0.5/0.8/1.0), la regla de gate (≥0.75) y la regla de veto (D5=0.0). Usar cuando design-evaluator evalúa los 5 artefactos finales del Design.
user-invocable: false
agent: design-evaluator
---

## Dimensiones de evaluación

| ID | Dimensión | Pregunta central |
|----|-----------|-----------------|
| D1 | Blueprint Coverage | ¿Todos los bounded contexts de `bdd_features.md` tienen ≥1 módulo (MOD-xx) en `technical_blueprint.md` con estructura de capas coherente? |
| D2 | Contract Completeness | ¿Todas las entidades de `data_contracts.md` tienen interface técnica (IC-xx) y DTOs en `contract_definitions.md`? ¿Sin entidades huérfanas ni interfaces sin entidad? |
| D3 | Testability | ¿Cada interface (IC-xx) tiene ≥1 TS-xx en `test_strategy_map.md`? ¿La estrategia de DI en `dependency_graph.md` es coherente con la testabilidad requerida? ¿La Guía de Vertical Slices tiene las 3 secciones obligatorias? |
| D4 | ADR Completeness | ¿ADR-001 incluye contexto, ≥2 opciones evaluadas con pros/contras, criterios de decisión con peso y decisión final justificada? ¿Cada patrón mayor tiene su ADR? |
| D5 | Consistency | ¿Sin contradicciones entre los 5 artefactos? ¿Sin contradicciones con los inputs del 020/010? ¿Lenguaje ubicuo del glosario usado consistentemente? |

**Gate de paso:** promedio ≥ 0.75 en todas las dimensiones.
**Regla de veto:** si D5 = 0.0, veredicto REJECTED inmediato sin calcular promedio.

---

## Anclas de calibración

> Dominio de referencia: Sistema de Inventario y Alertas de Stock — Distribuidora Andina Ltda.
> Actores: Almacenista, Jefa de Compras, Gerente.

### Score 0.2 — Cobertura mínima, gaps críticos

**D1:** Technical Blueprint solo lista carpetas genéricas sin módulos por bounded context.
Sin separación de capas (Dominio / Aplicación / Infraestructura) o sin skeletons de clases.
**D2:** Contract Definitions tiene interfaces sin métodos definidos o sin DTOs. Entidades del
020 sin interface correspondiente.
**D3:** Test Strategy Map ausente, vacío o menciona "escribir tests" sin estrategia de mock
concreta por interface. Sin Guía de Vertical Slices.
**D4:** ADR-001 lista el stack sin evaluar alternativas. Sin criterios de decisión. Sin
consecuencias aceptadas.
**D5:** Contradicciones directas y no documentadas entre artefactos.

> Ejemplo: Blueprint con carpetas `src/`, `tests/`, `lib/` sin módulos de dominio (Inventario,
> Alertas, Compras). Contract Definitions tiene `IRepositorio` sin métodos. ADR-001 dice
> "usaremos Python + FastAPI porque es popular" sin comparar con ninguna alternativa. Test
> Strategy Map menciona "mockear la base de datos" sin especificar cómo ni con qué herramienta.
> dependency_graph menciona un componente `NotificadorEmail` que no existe en contract_definitions.

### Score 0.5 — Cobertura parcial, gaps importantes

**D1:** Technical Blueprint con capas definidas pero módulos incompletos: faltan bounded contexts
secundarios (ej. solo Inventario y Compras, sin módulo de Alertas). Skeletons presentes solo para
el módulo principal.
**D2:** Contract Definitions define interfaces para entidades principales con métodos pero sin DTOs
de request/response. Sin DTOs de error. ≥1 entidad del 020 sin interface correspondiente.
**D3:** Test Strategy Map menciona mocks para ≥50% de interfaces pero sin detalle de implementación
del mock. Sin Guía de Vertical Slices o con solo 1 de las 3 secciones obligatorias.
**D4:** ADR-001 evalúa 2 opciones superficialmente (1 argumento por opción). Sin criterios de
decisión con peso. Patrones identificados en el analysis_report sin ADR correspondiente.
**D5:** 1–2 inconsistencias detectadas; pueden ser silenciosas o documentadas parcialmente.

> Ejemplo: Blueprint define Inventario y Compras como módulos pero omite el módulo de Alertas.
> Contract Definitions tiene IInventarioRepository con sus métodos pero sin DTOs para
> request/response. ADR-001 compara Python vs Node.js con 1 argumento por opción. Test Strategy
> Map documenta mock de DB pero no del servicio de alertas. Guía de Vertical Slices con solo
> el Tracer Bullet definido (MVP y Robustez ausentes).

### Score 0.8 — Cobertura completa, gaps menores

**D1:** Todos los bounded contexts del 020 con módulos y estructura de capas. 1-2 submódulos
menores faltantes o sin skeleton de clase.
**D2:** Contract Definitions completo para entidades principales pero con 1-2 DTOs faltantes
(ej. falta DTO de error de una interface secundaria). Sin entidades huérfanas.
**D3:** Test Strategy Map cubre ≥80% de interfaces con estrategia de mock detallada. Guía de
Vertical Slices con las 3 secciones pero con 1 sección incompleta (ej. MVP sin criterio de
éxito definido).
**D4:** ADR-001 con ≥2 opciones bien evaluadas y criterios de decisión. Falta explicitar las
consecuencias aceptadas o falta 1 criterio de peso relevante. ≥1 patrón mayor con ADR completo.
**D5:** 1 inconsistencia menor detectada y documentada o sin impacto real en la arquitectura.

> Ejemplo: Blueprint define Inventario (Producto, Movimiento, Stock), Alertas (Umbral), Compras
> (Orden, Proveedor) con estructura correcta de capas. Contract Definitions completo excepto
> falta el DTO de respuesta del endpoint de alertas. ADR-001 evalúa Python/FastAPI vs
> Node.js/Express con pros/contras pero no menciona el criterio de rendimiento bajo carga.
> Test Strategy Map completo para repositorios pero sin estrategia de mock para el servicio de
> notificaciones. 1 inconsistencia menor: dependency_graph menciona un `AlertaService` con scope
> `request` pero contract_definitions no define su scope esperado.

### Score 1.0 — Cobertura completa, sin gaps

**D1:** Todos los bounded contexts con módulos y submódulos. Estructura de capas correcta y
coherente con los escenarios BDD del 020. Skeletons de clases e interfaces principales presentes
en todos los módulos.
**D2:** Contract Definitions 100% completo: interfaces con todos sus métodos tipados + DTOs de
request, response y error para todas las entidades. Sin entidades huérfanas ni interfaces vacías.
**D3:** Test Strategy Map cubre 100% de interfaces con mock/stub y niveles de test (unitario,
integración, contrato). Guía de Vertical Slices con las 3 secciones completas: Tracer Bullet,
MVP y Robustez con scope, artefactos técnicos y criterio de éxito definidos.
**D4:** ADR-001 con contexto completo (RT-xx incluidas), ≥2 opciones evaluadas con ≥2 pros/contras
cada una, criterios de decisión con peso y justificación, consecuencias aceptadas. ADR adicional
por cada PT-xx del analysis_report.
**D5:** Sin contradicciones. Lenguaje ubicuo del `domain_glossary.md` usado consistentemente.
Ningún artefacto menciona una tecnología no definida en ADR-001.

> Ejemplo: Blueprint define Inventario (Producto, Movimiento, Stock), Alertas (Umbral, Notificación),
> Compras (Orden, Proveedor) con capas Dominio/Aplicación/Infraestructura completas y skeletons de
> clases por módulo. Contract Definitions tiene IProductoRepository con 5 métodos tipados + ProductoDTO
> + ProductoErrorDTO; IAlertaService con 3 métodos + AlertaDTO + AlertaErrorDTO; y así para cada entidad.
> ADR-001: contexto = inventario con concurrencia baja (25 usuarios) + RT-01 (Python obligatorio por
> equipo), opciones = Python/FastAPI+SQLAlchemy vs Python/Django+ORM vs Node.js/Express (eliminada por
> RT-01), criterios = simplicidad + soporte ORM + curva del equipo, decisión = Python/FastAPI+SQLAlchemy.
> Test Strategy Map: IProductoRepository → pytest-mock; IAlertaService → stub configurable; tests
> unitarios por caso de uso, integración por endpoint. Guía de Vertical Slices: Tracer Bullet =
> GET /stock/{id} (SC-01, MOD-01 Dominio), MVP = CRUD inventario + alertas básicas (SC-01..SC-08,
> SE-01..SE-04), Robustez = historial + informes + todos los SE-xx. Sin ninguna contradicción.

---

## Aplicación de la regla de veto (D5 = 0.0)

D5 = 0.0 se asigna cuando existe una contradicción directa y no documentada entre artefactos.
Ejemplos:

- `technical_blueprint.md` define el módulo Alertas en la capa Dominio, pero `dependency_graph.md`
  lo conecta directamente con el cliente de email externo (infraestructura), violando la regla de
  capas sin documentar la excepción.
- `contract_definitions.md` define `findById` retornando `Optional[ProductoDTO]`, pero
  `test_strategy_map.md` muestra un mock que retorna un dict sin tipo para el mismo método.
- `architecture_decision_records.md` selecciona Python/FastAPI, pero `technical_blueprint.md`
  muestra skeletons en TypeScript sin documentar la discrepancia.
- Una tecnología mencionada en `contract_definitions.md` no está definida en ADR-001 y no hay
  nota explicando la adición.

Una inconsistencia documentada (marcada con `[PENDIENTE]` o en nota explícita) no activa el veto —
es una inconsistencia conocida que puede resolverse. Solo la contradicción silenciosa activa el veto.
