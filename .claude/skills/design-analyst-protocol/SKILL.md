---
name: design-analyst-protocol
description: Protocolo analítico del design-analyst en el 030 Design Harness. Define las 7 categorías de extracción, la regla de no-inferencia, el criterio de done y el límite de iteraciones. Usar cuando design-analyst ejecuta su análisis sobre los 8 inputs del 030.
user-invocable: false
agent: design-analyst
---

## Regla de no-inferencia (absoluta)

No extraer componentes, interfaces ni restricciones que no estén derivados de los 8 inputs.
Si algo es ambiguo o está ausente en los inputs, registrarlo como gap en la tabla de
Gaps e Ítems de Escalamiento. Nunca asumir tecnologías ni completar con conocimiento externo
sobre stacks o patrones sin base en los inputs.

## Orden de lectura de inputs

Leer en este orden para construir el contexto progresivamente antes de extraer:

1. `discovery/domain_glossary.md` — fijar el vocabulario obligatorio antes de leer nada más
2. `discovery/scope_boundaries.md` — identificar RT-xx y límites duros antes de analizar funcionalidades
3. `discovery/shared_understanding.md` — contexto de dominio y restricciones de calidad
4. `discovery/failure_behavior.md` — patrones de error que el diseño debe manejar
5. `specification/bdd_features.md` — bounded contexts y flujos a soportar arquitectónicamente
6. `specification/data_contracts.md` — entidades que necesitan interfaces técnicas (IC-xx)
7. `specification/acceptance_criteria.md` — restricciones de comportamiento que el diseño debe garantizar
8. `specification/error_exception_policy.md` — políticas de error que impactan el diseño de interfaces

## Categorías de extracción

### 1. Bounded Contexts y Componentes (CO-xx)

Fuente principal: `bdd_features.md`.

Identificar los bounded contexts del sistema: agrupaciones coherentes de funcionalidad que
pueden desplegarse o evolucionar de forma independiente. Cada Feature o grupo de Scenarios
relacionados en `bdd_features.md` suele corresponder a un bounded context.

Reglas:
- Cada bounded context identificado → al menos un CO-xx.
- Un CO-xx agrupa responsabilidades cohesivas (alta cohesión interna, bajo acoplamiento externo).
- No crear un CO-xx por cada Scenario individual — buscar la agrupación natural por dominio.
- Si dos Scenarios comparten las mismas entidades y actores, pertenecen al mismo CO-xx.
- Registrar los actores que interactúan con cada CO-xx (tomados de los Scenarios BDD).

### 2. Interfaces Requeridas (IC-xx)

Fuente principal: `data_contracts.md`. Fuente secundaria: `error_exception_policy.md`.

Por cada entidad de `data_contracts.md`, determinar si necesita un "puerto" hacia el exterior
(persistencia, servicio externo, notificación, API). Si lo necesita → IC-xx.

Reglas:
- Una entidad que solo es DTO interno (transferencia entre capas) no necesita IC-xx obligatorio.
- Una entidad que se persiste, se consulta desde exterior, o dispara notificaciones → IC-xx obligatorio.
- Para cada IC-xx, listar las operaciones esperadas derivadas de los Scenarios BDD (verbos: findById,
  save, list, send, notify, etc.).
- Asignar la IC-xx al CO-xx propietario lógico (el componente responsable de esa entidad).
- Revisar `error_exception_policy.md`: si existen políticas de manejo de errores que requieren
  interfaces especializadas (ej. IErrorLogger, INotificador de fallo), crear IC-xx adicionales.

### 3. Restricciones Tecnológicas (RT-xx)

Fuente principal: `scope_boundaries.md`. Fuente secundaria: `shared_understanding.md`.

Extraer toda restricción que acote la selección de stack tecnológico. Una RT-xx no es una
preferencia — es un límite duro que el ADR-001 no puede ignorar.

Tipos de restricción a buscar:
- **Lenguaje:** "debe ser en Python", "el equipo solo conoce Java"
- **Framework:** "ya tenemos licencia de X", "debe integrarse con el sistema legacy Y"
- **Infraestructura:** "se despliega en contenedores Docker", "no se permite cloud pública"
- **Plataforma:** "debe correr en Windows Server", "integración con Active Directory"
- **Presupuesto:** "sin licencias de pago", "costo mensual máximo de X"

Para cada RT-xx, registrar el impacto concreto en la selección de stack y su peso como
criterio de evaluación para el ADR-001 (alto / medio / bajo).

### 4. Patrones de Diseño Propuestos (PT-xx)

Fuente: todos los inputs, con énfasis en `bdd_features.md` y `data_contracts.md`.

Identificar problemas técnicos que los patrones de diseño resuelven. No proponer patrones
por convención — proponer solo los que resuelven un problema concreto identificado.

Problemas a buscar activamente:
- **Variabilidad de reglas de negocio** (distintos Scenarios con la misma acción pero diferente
  resultado según condición) → Strategy o Policy
- **Acceso a persistencia** (cualquier IC-xx de tipo Repository) → Repository
- **Creación de entidades complejas** (entidades con muchas dependencias internas) → Factory
- **Desacoplamiento de notificaciones** (IC-xx de tipo Notifier) → Observer o Mediator
- **Orquestación de casos de uso** (flujos multi-paso en un Scenario) → Command o Service
- **Manejo centralizado de errores** (políticas de `error_exception_policy.md`) → Chain of
  Responsibility o Decorator

Para cada PT-xx, documentar el punto exacto de inyección de dependencia y la estrategia de
mock/stub que habilita el TDD (orientación para `test_strategy_map.md`).

### 5. Análisis de Capas Arquitectónicas

Fuente: `bdd_features.md` + `shared_understanding.md`.

Identificar las capas del sistema a partir del modelado del dominio. La separación mínima
esperada es:

- **Capa Dominio:** lógica de negocio pura. Sin imports de infraestructura.
  Contiene: entidades de dominio, reglas de negocio, interfaces (IC-xx como contratos abstractos).
- **Capa Aplicación:** orquestación de casos de uso. Invoca interfaces de Dominio.
  Contiene: servicios de aplicación, handlers, casos de uso por Scenario BDD.
- **Capa Infraestructura:** implementaciones concretas. Depende de frameworks externos.
  Contiene: implementaciones de IC-xx (DB, APIs externas, sistemas de notificación).

Asignar cada CO-xx a la capa correspondiente. Documentar las restricciones de dependencia
entre capas (qué puede importar de qué).

### 6. Flujos de Datos Técnicos

Fuente: `bdd_features.md` (Scenarios) + `data_contracts.md` (entidades).

Por cada CO-xx principal, trazar el flujo desde la entrada del sistema hasta la persistencia
o respuesta. El flujo debe ser trazable a un Scenario BDD específico.

Formato mínimo por flujo:
```
[Entrada] → [Handler/Controller] → [Caso de uso] → [IC-xx] → [Persistencia/Notificación/Respuesta]
```
Cada nodo del flujo debe corresponder a un CO-xx o IC-xx ya identificado. Sin nodos genéricos.

### 7. Gaps e Ítems de Escalamiento

Fuente: contradicciones o ausencias detectadas durante las categorías 1-6.

Registrar como gap solo cuando el problema impide diseñar sin asumir algo no documentado.

Casos típicos de gap:
- Un bounded context en `bdd_features.md` no tiene entidades correspondientes en `data_contracts.md`.
- Una entidad en `data_contracts.md` tiene relaciones no definidas que afectan el diseño de IC-xx.
- Las RT-xx de `scope_boundaries.md` son contradictorias entre sí.
- La `error_exception_policy.md` exige comportamientos de error que no tienen entidad correspondiente.

Un gap con impacto alto en el diseño → marcarlo para escalamiento (el governor debe resolver
antes de que el design-architect produzca artefactos).

## Criterio de done del análisis

Verificar después de escribir el reporte. Si alguna condición falla, actualizar el reporte
antes de reportar COMPLETED.

- [ ] ≥1 CO-xx por cada bounded context identificado en `bdd_features.md`
- [ ] ≥1 IC-xx por cada entidad de `data_contracts.md` que requiere interface
- [ ] ≥1 RT-xx derivada de `scope_boundaries.md`
- [ ] ≥1 PT-xx con justificación trazable a un problema concreto de los inputs
- [ ] Tabla de capas arquitectónicas completa con todos los CO-xx asignados
- [ ] ≥1 flujo de datos por CO-xx principal
- [ ] Tabla de Gaps completa (o "Ninguno" explícito)
- [ ] `design/design_analysis_report.md` escrito en disco antes de reportar

## Límite de iteraciones

Si design-analyst ha sido ejecutado 2 veces o más sobre los mismos inputs y persisten gaps
bloqueantes sin resolución del governor, agregar en el reporte:

`ALERTA: 2 iteraciones completadas sin resolver gaps bloqueantes. Escalar al humano.`

Reportar `ESCALAMIENTO REQUERIDO` al governor. No ejecutar una tercera iteración sin
instrucción explícita del governor.
