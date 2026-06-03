---
name: discovery-analysis-schema
description: Schema y formato del archivo analysis_report.md del 010 Discovery Harness. Soporta transcripts multi-stakeholder con bancos de preguntas por rol. Usar cuando discovery-analyst escribe el reporte o cuando discovery-synthesizer lo lee y procesa.
user-invocable: false
agent: discovery-analyst
---

## Ruta del archivo

`/discovery/analysis_report.md`

## Cómo leer el transcript

El transcript puede contener entrevistas de múltiples stakeholders, cada uno con un banco
de preguntas diferente (A=negocio, B=técnico, C=usuario). Al analizar:

- Leer todas las entrevistas, no solo la primera.
- Consolidar actores y objetivos de valor a través de todos los stakeholders.
- Las contradicciones pueden surgir entre respuestas de distintos stakeholders — registrar
  los IDs de stakeholder involucrados (S-01, S-02...).
- Los escenarios de fallo de Banco A (negocio) y Banco B (técnico) y Banco C (usuario)
  tienen perspectivas distintas sobre el mismo sistema — consolidarlos sin borrar matices.

## Estructura del reporte

```
# Analysis Report — 010 Discovery
Fecha: [fecha]
Fuente: /discovery/dialogue_transcript.md
Estado del transcript: [COMPLETO | INCOMPLETO]
Stakeholders entrevistados: [N] (S-01: rol, S-02: rol, ...)

## Actores del Sistema

(Distinción: actores del sistema ≠ stakeholders entrevistados. Un stakeholder S-01 puede
haber identificado 3 actores del sistema. Listar los actores del sistema aquí.)

| ID    | Actor | Descripción | Stakeholder fuente | Objetivos de Valor |
|-------|-------|-------------|-------------------|-------------------|
| A-01  | ...   | ...         | S-01 / S-02 / ... | [lista separada por punto y coma] |

## Objetivos de Valor por Actor del Sistema

### A-01 — [Nombre del Actor]
| ID    | Objetivo | Perspectiva | Prioridad |
|-------|----------|-------------|-----------|
| OV-01 | ...      | negocio / técnica / usuario | alta/media/baja |

[repetir por cada actor del sistema]

## Contradicciones Detectadas

| ID   | Stakeholders involucrados | Actores del sistema afectados | Descripción | Estado | Resolución Propuesta |
|------|--------------------------|-------------------------------|-------------|--------|---------------------|
| C-01 | S-01 vs S-02             | A-01                          | ...         | RESUELTA | ... |

Estado posible: RESUELTA | ABIERTA | ESCALADA

## Escenarios de Fallo

| ID    | Actor del sistema | Perspectiva | Escenario | Comportamiento Esperado | Prioridad |
|-------|------------------|-------------|-----------|------------------------|-----------|
| SF-01 | A-01             | negocio / técnica / usuario | ... | ... | alta/media/baja |

## Ambigüedades Detectadas

| ID   | Descripción | Stakeholders involucrados | Impacto en síntesis |
|------|-------------|--------------------------|---------------------|
| AM-01 | ...        | S-01 / S-02 / ...        | alto/medio/bajo     |

Ambigüedad = mismo concepto descrito de forma inconsistente sin llegar a contradicción directa.

## Vacíos Detectados

| ID   | Tipo | Descripción | Actor / Área afectada |
|------|------|-------------|----------------------|
| V-01 | actor sin objetivos / actor sin fallos / área sin respuesta | ... | A-01 / ... |

## Items UNRESOLVED (heredados del transcript)

| Área | Pregunta sin respuesta | Stakeholder consultado | Impacto en síntesis |
|------|----------------------|----------------------|---------------------|
| ...  | ...                  | S-01 / S-02 / ...    | alto/medio/bajo     |

## Preguntas de Aclaración para discovery-dialoguer

(Completar si hay issues — contradicciones ABIERTA, ambigüedades, o vacíos. Vacío si el análisis está limpio.)

| ID    | Stakeholder a consultar | Pregunta específica | Issue que resuelve |
|-------|------------------------|--------------------|--------------------|
| PA-01 | S-01 / S-02 / nuevo    | ...                | C-01 / AM-01 / V-01 |

Estado: [PENDIENTE | RESUELTO — iteración N]

## Verificación del Criterio de Done

- [ ] Todos los actores del sistema tienen al menos un objetivo de valor
- [ ] Todas las contradicciones están catalogadas (RESUELTA, ABIERTA o ESCALADA)
- [ ] Al menos un escenario de fallo documentado por actor principal
- [ ] Ningún actor principal tiene escenarios de fallo vacíos
- [ ] Los aportes de todos los stakeholders entrevistados están reflejados
- [ ] Sin ambigüedades sin resolver
- [ ] Sin vacíos que dejarían un artefacto final incompleto

## Estado del análisis

LISTO PARA SÍNTESIS | PENDIENTE DE ACLARACIÓN | ALERTA — [N] iteraciones sin resolver

## Cobertura

Iteración de análisis: [N]
Stakeholders entrevistados: [N]
Actores del sistema identificados: [N]
Objetivos de valor totales: [N]
Contradicciones: [N resueltas] / [N abiertas] / [N escaladas]
Ambigüedades: [N]
Vacíos: [N]
Escenarios de fallo: [N]
Items UNRESOLVED: [N]
Preguntas de aclaración pendientes: [N]
```

## Reglas de escritura

- Asignar IDs secuenciales: actores `A-01`, `A-02`…; objetivos `OV-01`, `OV-02`…; contradicciones `C-01`, `C-02`…; escenarios `SF-01`, `SF-02`…
- Distinguir entre **stakeholders** (personas entrevistadas, IDs S-xx) y **actores del sistema** (entidades que interactúan con el sistema, IDs A-xx). Un stakeholder puede ser también un actor del sistema.
- Consolidar aportaciones de todos los stakeholders — no repetir el mismo actor del sistema por cada stakeholder que lo mencionó.
- Heredar todos los items UNRESOLVED del transcript sin modificarlos. Agregar columna `Impacto en síntesis`.
- Una contradicción marcada `RESUELTA` debe tener `Resolución Propuesta` no vacía.
- Una contradicción `ABIERTA` implica que discovery-analyst no pudo resolverla — impacto alto automático.
- No inferir actores ni objetivos que no aparezcan explícitamente en el transcript.
- El campo `Estado del transcript` refleja el estado declarado en `dialogue_transcript.md`.
