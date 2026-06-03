---
name: discovery-transcript-schema
description: Schema y formato del archivo dialogue_transcript.md del 010 Discovery Harness. Escritura incremental por ronda. Soporta múltiples stakeholders y múltiples sesiones. Usar cuando discovery-dialoguer escribe el transcript o cuando discovery-analyst lo lee y procesa.
user-invocable: false
agent: discovery-dialoguer
---

## Ruta del archivo

`/010_discovery/dialogue_transcript.md`

Crear la carpeta `/010_discovery/` si no existe antes de escribir.

## Principio de escritura

**El transcript se escribe de forma incremental — una entrada por ronda, inmediatamente después de que el interlocutor responde.** No esperar al final. El transcript es la fuente de verdad del estado en todo momento.

Si el archivo ya existe al iniciar, discovery-dialoguer lo lee para determinar dónde retomar.

---

## Estructura completa del transcript

```
# Dialogue Transcript — 010 Discovery
Última actualización: [fecha y hora]
Estado global: EN CURSO | COMPLETO | INCOMPLETO

## Estado de stakeholders
(Actualizar este bloque cada vez que cambia el estado de un stakeholder)

| ID   | Nombre/Identificador | Rol                              | Estado entrevista                            |
|------|---------------------|----------------------------------|----------------------------------------------|
| S-01 | ...                 | negocio / técnico / usuario / otro | PENDIENTE / EN CURSO / COMPLETA / NO DISPONIBLE |

Stakeholder activo: [S-xx | ninguno]
Última ronda completada: [S-xx · Ronda N | —]

---

## Contexto de arranque
(Solo si no existían archivos de input al iniciar — omitir si no aplica)
- Nombre del proyecto: [nombre o —]
- Problema central: [descripción o —]
- Primer stakeholder: [nombre/rol o —]

## Inputs leídos
- brief.md: [ENCONTRADO | NO ENCONTRADO]
- business_context.md: [ENCONTRADO | NO ENCONTRADO]
- constraints.md: [ENCONTRADO | NO ENCONTRADO]

---

## Entrevistas

### Entrevista S-01 — [Nombre/Identificador] ([Rol])
Banco aplicado: [A — Negocio | B — Técnico | C — Usuario]
Inicio: [fecha]
Cierre: [fecha | EN CURSO]

#### Ronda 1
**discovery-dialoguer:** [pregunta]
**S-01:** [respuesta]

#### Ronda 2
**discovery-dialoguer:** [pregunta]
**S-01:** [respuesta]

[continuar numerando dentro de cada entrevista...]

[ENTREVISTA CERRADA — Stakeholder: S-01 — Ronda N — fecha]

---

### Entrevista S-02 — [Nombre/Identificador] ([Rol])
Banco aplicado: [A — Negocio | B — Técnico | C — Usuario]
Inicio: [fecha]
Cierre: [fecha | EN CURSO]

#### Ronda 1
...

[ENTREVISTA CERRADA — Stakeholder: S-02 — Ronda N — fecha]

---

[repetir por cada stakeholder]

---

## Resumen de Hallazgos
(Completar al cerrar cada entrevista, actualizar si cambia)

### Actores Identificados
| Actor | Descripción | Objetivo de Valor | Stakeholder fuente |
|-------|-------------|-------------------|--------------------|
| ...   | ...         | ...               | S-01 / S-02 / ...  |

### Contradicciones Detectadas
| ID   | Stakeholders involucrados | Descripción | Resolución |
|------|--------------------------|-------------|------------|
| C-01 | S-01 vs S-02             | ...         | ...        |

### Comportamiento ante Fallos
| Escenario | Actor del sistema | Stakeholder fuente | Comportamiento Esperado |
|-----------|------------------|-------------------|------------------------|
| ...       | ...              | S-01 / S-02 / ... | ...                    |

### Items UNRESOLVED
| Área | Pregunta sin respuesta | Stakeholder consultado | Impacto estimado |
|------|----------------------|----------------------|-----------------|
| ...  | ...                  | S-xx                 | alto/medio/bajo  |

## Criterio de Done — Verificación
- [ ] Todos los stakeholders de la lista fueron entrevistados o marcados NO DISPONIBLE
- [ ] Sin contradicciones nuevas en 2 rondas consecutivas por stakeholder
- [ ] Todos los actores identificados con ≥1 objetivo de valor
- [ ] ≥1 respuesta sobre comportamiento ante fallos por banco aplicado
```

---

## Reglas de escritura incremental

**Cuándo escribir:**
1. Después de cada ronda completada (pregunta + respuesta): actualizar la sección de la entrevista activa y el campo `Última ronda completada` en el bloque de estado.
2. Al cambiar el estado de un stakeholder (PENDIENTE → EN CURSO → COMPLETA / NO DISPONIBLE): actualizar la tabla de estado de stakeholders.
3. Al cerrar una entrevista: agregar la línea `[ENTREVISTA CERRADA...]`, actualizar `Cierre:` en el encabezado de la entrevista, actualizar `Resumen de Hallazgos`.
4. Al cerrar el transcript completo: actualizar `Estado global` a COMPLETO o INCOMPLETO.

**Cómo escribir:**
- Usar `Read` para leer el estado actual del archivo antes de cada `Write`.
- Reescribir el archivo completo con el nuevo contenido (no append parcial que corrompa la estructura).
- Actualizar siempre `Última actualización` con la fecha/hora actual.

**Convenciones:**
- `Estado global: EN CURSO` mientras haya stakeholders PENDIENTE o EN CURSO.
- `Estado global: COMPLETO` solo cuando todas las condiciones del Criterio de Done están marcadas.
- `Estado global: INCOMPLETO` si se detuvo por escalamiento o stakeholder crítico NO DISPONIBLE.
- El número de ronda reinicia en 1 para cada nueva entrevista de stakeholder.
- ID de stakeholder: `S-01`, `S-02`…; ID de contradicción: `C-01`, `C-02`…
- Si no se ejecutó el arranque en frío, omitir la sección `## Contexto de arranque`.
