---
name: discovery-synthesis-schema
description: Schema y formato de los 4 artefactos finales del 010 Discovery Harness producidos por discovery-synthesizer. Usar cuando discovery-synthesizer escribe los artefactos o cuando discovery-evaluator los lee para auditar.
user-invocable: false
agent: discovery-synthesizer
---

Los 4 artefactos deben escribirse en la carpeta `/010_discovery/`. Crear la carpeta si no existe.

---

## Artefacto 1 — shared_understanding.md

**Path:** `/010_discovery/shared_understanding.md`

```
# Shared Understanding Document — 010 Discovery
Fecha: [fecha]
Estado: DRAFT | APROBADO POR CLIENTE

## Propósito del Sistema

[Descripción en lenguaje natural, 2–4 párrafos. Sin jerga técnica. Responde: ¿qué problema resuelve y para quién?]

## Actores y sus Necesidades

### [Nombre del Actor A-01]
- **Descripción:** [quién es]
- **Necesidades principales:**
  - [objetivo de valor OV-01]
  - [objetivo de valor OV-02]
  - ...

[repetir por cada actor del analysis_report]

## Lo que el Sistema Hace

[Lista numerada de capacidades acordadas. Cada ítem debe ser verificable: "el sistema permite X" o "el sistema notifica a Y cuando Z".]

1. ...
2. ...

## Contradicciones Resueltas

[Solo las marcadas RESUELTA en el analysis_report. Omitir las ABIERTAS y ESCALADAS.]

| Contradicción | Resolución acordada |
|---------------|---------------------|
| ...           | ...                 |

## Aprobación del Cliente

Estado: [PENDIENTE | APROBADO POR CLIENTE]
Fecha de aprobación: [fecha o —]
Registro: [cita textual de la aprobación o —]
```

**Reglas:**
- `Estado: APROBADO POR CLIENTE` solo cuando Instance A registra aprobación explícita en CP-04.
- discovery-synthesizer escribe siempre con `Estado: DRAFT`. Instance A actualiza a `APROBADO POR CLIENTE` tras CP-04. **Esta frase exacta es la que verifica D5 de la rúbrica — no usar variantes ("APROBADO", "Aprobado por el cliente", etc.).**
- No incluir contradicciones ABIERTAS o ESCALADAS — esas bloquean la fase.

---

## Artefacto 2 — scope_boundaries.md

**Path:** `/010_discovery/scope_boundaries.md`

```
# Scope Boundaries — 010 Discovery
Fecha: [fecha]

## Qué NO hará el sistema en esta etapa

| ID    | Exclusión | Razón | Fuente |
|-------|-----------|-------|--------|
| EX-01 | ...       | ...   | [transcript ronda N / restricción del cliente / decisión del equipo] |

## Qué queda diferido (posibles futuras fases)

| ID    | Capacidad diferida | Condición para incluir |
|-------|--------------------|----------------------|
| DF-01 | ...                | ...                  |

## Restricciones activas

| Tipo | Restricción | Impacto |
|------|-------------|---------|
| tecnológica / presupuesto / legal / tiempo | ... | ... |
```

**Reglas:**
- Mínimo 3 exclusiones explícitas (gate de la rúbrica D2).
- Derivar exclusiones de: items UNRESOLVED con impacto alto, restricciones del `constraints.md`, decisiones de descarte mencionadas en el transcript.
- Si el transcript no provee suficientes exclusiones, generar al menos 3 derivadas de los límites implícitos del scope acordado.

---

## Artefacto 3 — domain_glossary.md

**Path:** `/010_discovery/domain_glossary.md`

```
# Domain Glossary — 010 Discovery
Fecha: [fecha]

## Términos del Dominio

| Término | Definición acordada | Sinónimos a evitar | Actor que lo usa |
|---------|--------------------|--------------------|-----------------|
| ...     | ...                | ...                | ...             |

## Abreviaturas

| Abreviatura | Expansión | Contexto de uso |
|-------------|-----------|-----------------|
| ...         | ...       | ...             |
```

**Reglas:**
- Incluir todos los términos específicos del negocio que aparecen en el transcript (no términos técnicos genéricos).
- La columna `Sinónimos a evitar` previene ambigüedad: si el cliente usó varios términos para lo mismo, registrar el canónico y listar los descartados.
- Mínimo 5 términos de dominio para considerar el glosario útil.

---

## Artefacto 4 — failure_behavior.md

**Path:** `/010_discovery/failure_behavior.md`

```
# Failure Behavior — 010 Discovery
Fecha: [fecha]
Destino: input directo para Error & Exception Policy del 020 Specification Harness

## Escenarios de Fallo por Actor

### [Nombre del Actor A-01]

| ID    | Escenario | Causa probable | Comportamiento esperado | Prioridad |
|-------|-----------|---------------|------------------------|-----------|
| SF-01 | ...       | ...           | ...                    | alta/media/baja |

[repetir por cada actor con escenarios en el analysis_report]

## Escenarios Globales (no atribuibles a un actor específico)

| ID    | Escenario | Comportamiento esperado | Prioridad |
|-------|-----------|------------------------|-----------|
| SG-01 | ...       | ...                    | alta/media/baja |

## Items sin Respuesta del Cliente

| Escenario | Pregunta pendiente | Impacto en el 020 |
|-----------|-------------------|--------------------|
| ...       | ...               | ...                |
```

**Reglas:**
- Heredar todos los escenarios de fallo del `analysis_report.md` sin modificar comportamientos.
- Agregar `Causa probable` como inferencia de discovery-synthesizer (claramente marcada como inferencia si no está en el transcript).
- Los items sin respuesta son los UNRESOLVED de fallo del analysis_report — el 020 deberá resolverlos antes de especificar la política de excepciones.

---

## Verificación de cobertura (discovery-synthesizer al terminar)

Antes de reportar a B, verificar:
- [ ] `shared_understanding.md` cubre todos los actores del analysis_report
- [ ] `scope_boundaries.md` tiene ≥3 exclusiones
- [ ] `domain_glossary.md` tiene ≥5 términos
- [ ] `failure_behavior.md` tiene ≥1 escenario por actor principal
- [ ] Los 4 archivos existen en `/010_discovery/`
