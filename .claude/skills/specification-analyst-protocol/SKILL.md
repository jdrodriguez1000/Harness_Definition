---
name: specification-analyst-protocol
description: Protocolo analítico del specification-analyst en el 020 Specification Harness. Define las 7 categorías de extracción, la regla de no-inferencia, el criterio de done y el límite de iteraciones. Usar cuando specification-analyst ejecuta su análisis sobre los artefactos del 010.
user-invocable: false
agent: specification-analyst
---

## Regla de no-inferencia (absoluta)

No extraer actores, comportamientos ni entidades que no estén explícitamente presentes en los
artefactos del 010. Si algo es ambiguo o está ausente, registrarlo como `REQUIERE_ACLARACIÓN`
en el reporte. Nunca asumir ni completar con conocimiento externo.

## Categorías de extracción

### 1. Actores del sistema

Fuente: `shared_understanding.md`.

Extraer todas las entidades que interactúan con el sistema: personas, roles, sistemas externos.
Registrar todos los actores, no solo los principales. Un actor es quien usa, opera o recibe
respuesta del sistema — no es necesariamente un stakeholder entrevistado en el 010.

### 2. Objetivos de valor por actor

Fuente: `shared_understanding.md`.

Para cada actor, extraer lo que necesita lograr (resultado de negocio), no funcionalidades
técnicas. Un objetivo de valor responde a "¿para qué usa este actor el sistema?".
Cada actor debe tener al menos un objetivo de valor; si no tiene ninguno, registrar como vacío
con impacto alto en la especificación.

### 3. Comportamientos a especificar — Camino feliz

Fuente: `shared_understanding.md` + objetivos de valor extraídos.

Por cada actor, identificar las situaciones en que interactúa exitosamente con el sistema.
Cada objetivo de valor debe traducirse en al menos un comportamiento de camino feliz.
Estructurar cada comportamiento como: situación inicial → acción del actor → resultado esperado.
Registrar si alguna exclusión de `scope_boundaries.md` aplica a ese comportamiento.

### 4. Casos de borde

Fuente primaria: `failure_behavior.md`. Fuente secundaria: derivaciones lógicas del contexto del 010.

Identificar sistemáticamente: condiciones límite, datos inválidos y estados excepcionales.
Para cada caso, registrar explícitamente su fuente (failure_behavior.md o derivado).
Un caso derivado es aquel que el analyst infiere como consecuencia lógica del comportamiento
de camino feliz, sin que esté explícito en el failure_behavior.md — marcar siempre como "derivado"
para que el writer pueda distinguirlo de los casos confirmados por el cliente en el 010.

### 5. Entidades y relaciones conceptuales

Fuente: `shared_understanding.md` + `domain_glossary.md`.

Extraer las entidades del dominio de negocio (no tablas técnicas) y sus relaciones lógicas.
Una relación lógica expresa una regla de negocio: "Un Pedido siempre debe tener al menos
un Producto", "Un Médico puede tener muchas Citas pero una Cita solo pertenece a un Médico".
Si una entidad aparece en el `domain_glossary.md`, registrarla como confirmada en el glosario.
Si es necesaria pero no está en el glosario, registrarla igualmente y marcar como ausente.

### 6. Error & Exception Mapping

Fuente: `failure_behavior.md` + resoluciones de PENDIENTE recibidas del governor.

Para cada ítem del `failure_behavior.md`, documentar la política de excepción a aplicar en
el artefacto `error_exception_policy.md`. Los ítems marcados como DEFINIDO en el failure_behavior
son directos. Los ítems marcados como PENDIENTE requieren la resolución del governor:
- Si el governor proporcionó resolución: incluirla como política a aplicar.
- Si el governor NO proporcionó resolución: registrar en REQUIERE_ACLARACIÓN y no inventar política.

### 7. Exclusiones de scope

Fuente: `scope_boundaries.md`.

Registrar explícitamente cada exclusión con su impacto en la especificación. Ejemplos de impacto:
"no generar escenarios BDD para este actor", "no definir contratos de datos para esta entidad",
"no incluir este caso de borde en la Error & Exception Policy".
El specification-writer no puede cruzar ninguna exclusión de esta lista.

## Criterio de done del análisis

Verificar después de escribir el reporte. Si alguna condición falla, actualizar el reporte
antes de reportar a B.

- [ ] Todos los actores de `shared_understanding.md` están en la tabla de Actores
- [ ] Cada actor tiene ≥1 comportamiento de camino feliz identificado
- [ ] Todos los ítems del `failure_behavior.md` están en Error & Exception Mapping
- [ ] Todos los ítems PENDIENTE tienen resolución del governor o están en REQUIERE_ACLARACIÓN
- [ ] Al menos un caso de borde por actor principal
- [ ] Todas las entidades relevantes del `domain_glossary.md` están en la tabla de Entidades
- [ ] Las exclusiones de `scope_boundaries.md` están registradas con su impacto

## Límite de iteraciones

Si specification-analyst ha sido ejecutado 3 veces o más sobre los mismos inputs y aún quedan
ítems REQUIERE_ACLARACIÓN no resueltos, agregar en el reporte:

`ALERTA: 3 iteraciones completadas sin resolver todos los ítems bloqueantes. Escalar al humano.`

Reportar a B con esta alerta. No ejecutar una cuarta iteración sin instrucción explícita de B.
