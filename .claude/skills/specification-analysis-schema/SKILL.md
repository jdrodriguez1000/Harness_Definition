---
name: specification-analysis-schema
description: Schema y formato del archivo spec_analysis_report.md del 020 Specification Harness. Usar cuando specification-analyst escribe el reporte o cuando specification-writer lo lee para producir los 4 artefactos finales.
user-invocable: false
agent: specification-analyst
---

## Ruta del archivo

`/specification/spec_analysis_report.md`

## Propósito del reporte

El spec_analysis_report es el puente entre los artefactos del 010 Discovery y los 4 artefactos
finales del 020. No produce especificación — organiza y estructura lo que el specification-writer
necesita para producirla. Todo lo que aparezca en este reporte debe ser trazable a un artefacto
del 010; nada se infiere ni se inventa.

## Estructura del reporte

```
# Spec Analysis Report — 020 Specification
Fecha: [fecha]
Producido por: specification-analyst
Iteración: [N]

## Inputs analizados

| Input | Path | Estado |
|-------|------|--------|
| shared_understanding.md | /discovery/shared_understanding.md | leído |
| domain_glossary.md      | /discovery/domain_glossary.md      | leído |
| scope_boundaries.md     | /discovery/scope_boundaries.md     | leído |
| failure_behavior.md     | /discovery/failure_behavior.md     | leído |

Resoluciones de PENDIENTE recibidas del governor: [N ítems / ninguna]

## Actores y Objetivos de Valor

(Extraídos de shared_understanding.md. Cada actor debe tener ≥1 objetivo de valor.)

| ID    | Actor | Descripción | Objetivos de Valor |
|-------|-------|-------------|-------------------|
| AC-01 | ...   | ...         | [lista separada por punto y coma] |

### Objetivos de Valor por Actor

#### AC-01 — [Nombre del Actor]
| ID    | Objetivo de Valor | Prioridad |
|-------|------------------|-----------|
| OV-01 | ...              | alta / media / baja |

[repetir por cada actor]

## Comportamientos a Especificar

(Para cada actor, derivar los comportamientos que deben traducirse a escenarios BDD.
Usar el domain_glossary.md para todos los términos.)

### AC-01 — [Nombre del Actor]

#### Camino Feliz
| ID    | Situación inicial | Acción del actor | Resultado esperado | Restricciones de scope |
|-------|------------------|------------------|--------------------|----------------------|
| CF-01 | ...              | ...              | ...                | [referencia a scope_boundaries si aplica] |

#### Casos de Borde
| ID    | Condición límite / dato inválido / estado excepcional | Resultado esperado | Fuente |
|-------|------------------------------------------------------|-------------------|--------|
| CB-01 | ...                                                  | ...               | failure_behavior.md / derivado |

[repetir por cada actor]

## Entidades y Relaciones Conceptuales

(Modelado mental del dominio extraído de shared_understanding.md y domain_glossary.md.
No es un schema técnico — es el modelo de negocio.)

### Entidades

| ID    | Entidad | Descripción | Atributos clave | Fuente en glossary |
|-------|---------|-------------|-----------------|-------------------|
| EN-01 | ...     | ...         | [lista]         | sí / no |

### Relaciones entre Entidades

| ID    | Entidad A | Relación | Entidad B | Cardinalidad | Restricción de negocio |
|-------|-----------|----------|-----------|--------------|----------------------|
| RE-01 | ...       | tiene    | ...       | 1..N         | ... |

## Error & Exception Mapping

(Para cada ítem del failure_behavior.md, documentar la política a aplicar en la
Error & Exception Policy. Los ítems PENDIENTE deben tener resolución del governor.)

| ID    | Ítem de failure_behavior.md | Estado original | Política a aplicar | Resolución del governor | Acción concreta |
|-------|----------------------------|-----------------|-------------------|------------------------|-----------------|
| EE-01 | ...                        | DEFINIDO / PENDIENTE | ...           | [respuesta del governor / N/A] | mensaje al usuario / reintento / bloqueo / acción alternativa |

## Exclusiones de Scope a Respetar

(Extraídas de scope_boundaries.md. El writer no debe generar escenarios BDD para estos ítems.)

| ID    | Exclusión | Impacto en especificación |
|-------|-----------|--------------------------|
| EX-01 | ...       | no generar escenarios BDD / no definir contratos de datos |

## Ítems REQUIERE_ACLARACIÓN

(Solo si el analyst detectó un ítem PENDIENTE en failure_behavior.md sin resolución del governor.
Si no hay ítems, escribir "Ninguno".)

| ID    | Ítem bloqueante | Artefacto afectado | Acción requerida |
|-------|----------------|-------------------|-----------------|
| RA-01 | ...            | error_exception_policy.md | El governor debe obtener resolución del cliente antes de continuar |

## Verificación del Criterio de Done

- [ ] Todos los actores de shared_understanding.md están en la tabla de Actores
- [ ] Cada actor tiene ≥1 comportamiento de camino feliz identificado
- [ ] Todos los ítems del failure_behavior.md están en Error & Exception Mapping
- [ ] Todos los ítems PENDIENTE tienen resolución del governor (o están en REQUIERE_ACLARACIÓN)
- [ ] Al menos un caso de borde identificado por actor principal
- [ ] Todas las entidades del domain_glossary.md con relevancia de negocio están en la tabla de Entidades
- [ ] Las exclusiones de scope_boundaries.md están registradas

## Estado del análisis

LISTO PARA WRITER | REQUIERE_ACLARACIÓN — [N] ítems bloqueantes | ALERTA — [N] iteraciones sin resolver

## Cobertura

Iteración de análisis: [N]
Actores identificados: [N]
Comportamientos de camino feliz: [N]
Casos de borde: [N]
Entidades conceptuales: [N]
Relaciones entre entidades: [N]
Ítems de failure_behavior procesados: [N resueltos] / [N con REQUIERE_ACLARACIÓN]
Exclusiones de scope registradas: [N]
```

## Reglas de escritura

- Asignar IDs secuenciales: actores `AC-01`, objetivos `OV-01`, caminos felices `CF-01`,
  casos de borde `CB-01`, entidades `EN-01`, relaciones `RE-01`, errores `EE-01`, exclusiones `EX-01`,
  requiere aclaración `RA-01`.
- Usar exclusivamente los términos del `domain_glossary.md`. Si un concepto no aparece en el glosario
  pero es necesario, registrarlo en la tabla de Entidades con `Fuente en glossary: no`.
- No inventar comportamientos ni entidades. Solo lo derivable de los 4 artefactos del 010.
- Un ítem `PENDIENTE` en failure_behavior.md sin resolución del governor → registrar en
  REQUIERE_ACLARACIÓN y marcar Estado del análisis como `REQUIERE_ACLARACIÓN`.
- Un ítem `PENDIENTE` con resolución del governor → incluir la resolución en la columna
  "Resolución del governor" de Error & Exception Mapping.
- Las exclusiones de scope_boundaries.md son límites duros — el writer no puede especificar
  nada que esté en esa lista.
- El campo `Fuente` en Casos de Borde debe indicar si el caso viene directamente del
  `failure_behavior.md` o fue derivado por el analyst a partir del contexto del 010.
