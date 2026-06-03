---
name: specification-synthesis-schema
description: Schema y formato de los 4 artefactos finales del 020 Specification Harness producidos por specification-writer. Usar cuando specification-writer escribe los artefactos o cuando specification-evaluator los lee para auditar.
user-invocable: false
agent: specification-writer
---

Los 4 artefactos deben escribirse en la carpeta `/020_specification/`. La carpeta ya existe (creada por el governor en E10-A).

Las IDs que el writer recibe desde `spec_analysis_report.md` y debe referenciar:
- `AC-xx` — actores
- `CF-xx` — comportamientos de camino feliz
- `CB-xx` — casos de borde
- `EN-xx` — entidades conceptuales
- `RE-xx` — relaciones entre entidades
- `EE-xx` — ítems de Error & Exception Mapping
- `EX-xx` — exclusiones de scope

---

## Artefacto 1 — bdd_features.md

**Path:** `/020_specification/bdd_features.md`

Producir primero. Los IDs de escenario (SC-xx, SE-xx) son la fuente de referencia para `acceptance_criteria.md`.

```
# BDD Feature Files — 020 Specification
Fecha: [fecha]
Estado: DRAFT | APROBADO POR CLIENTE
Basado en: 020_specification/spec_analysis_report.md

## Resumen de cobertura

| Actor (ID) | Escenarios camino feliz | Escenarios caso de borde |
|------------|------------------------|--------------------------|
| [AC-01] [nombre] | [N] | [N] |

---

## Feature: [Nombre del Actor AC-01]

### Escenarios de Camino Feliz

#### SC-01 — [Nombre del escenario]
**Fuente:** CF-xx
**Actor:** [AC-xx — nombre]

```gherkin
Dado que [condición inicial en lenguaje del dominio]
Cuando [acción del actor]
Entonces [resultado esperado verificable]
  Y [resultado adicional si aplica]
```

[repetir SC-xx por cada CF-xx del actor]

### Escenarios de Caso de Borde

#### SE-01 — [Nombre del escenario]
**Fuente:** CB-xx
**Actor:** [AC-xx — nombre]

```gherkin
Dado que [condición límite o estado excepcional]
Cuando [acción del actor o del sistema]
Entonces [resultado esperado ante el caso de borde]
```

[repetir SE-xx por cada CB-xx del actor]

---

[repetir sección Feature por cada actor AC-xx]
```

**Reglas:**
- IDs de escenarios de camino feliz: `SC-xx` (SC-01, SC-02 …). Secuencial global, no por actor.
- IDs de escenarios de caso de borde: `SE-xx` (SE-01, SE-02 …). Secuencial global.
- Cada SC-xx debe referenciar el CF-xx que lo origina. Cada SE-xx debe referenciar el CB-xx.
- Todos los términos de los bloques Dado/Cuando/Entonces deben aparecer en `domain_glossary.md`.
  Si un término necesario no está en el glosario, marcarlo con `[GLOSARIO: pendiente — nombre del término]`.
- No generar escenarios para ítems de `EX-xx` (exclusiones de scope).
- No omitir ningún actor del analysis_report. Todo AC-xx debe tener ≥1 SC-xx y ≥1 SE-xx.
- `Estado: APROBADO POR CLIENTE` solo cuando Instance A registra aprobación en CP-04.
  specification-writer escribe siempre con `Estado: DRAFT`.

---

## Artefacto 2 — data_contracts.md

**Path:** `/020_specification/data_contracts.md`

Producir segundo. Define el modelo de datos de negocio (no un schema técnico).

```
# Data Contracts — 020 Specification
Fecha: [fecha]
Estado: DRAFT | APROBADO POR CLIENTE
Basado en: 020_specification/spec_analysis_report.md

## Entidades y sus Contratos

### [Entidad EN-01 — Nombre]

**Descripción:** [descripción de negocio, sin terminología técnica]

#### Campos

| Campo | Tipo de dato (negocio) | Formato | Obligatorio | Validaciones de negocio | Escenario BDD relacionado |
|-------|------------------------|---------|-------------|------------------------|--------------------------|
| [nombre] | texto / número / fecha / booleano / lista | [ej: DD/MM/AAAA] | sí / no | [regla de negocio] | SC-xx / SE-xx |

#### Reglas de negocio de la entidad

| ID    | Regla | Prioridad |
|-------|-------|-----------|
| RN-01 | ...   | alta / media / baja |

[repetir sección por cada entidad EN-xx]

---

## Relaciones entre Entidades

| ID    | Entidad A | Relación | Entidad B | Cardinalidad | Restricción de negocio |
|-------|-----------|----------|-----------|--------------|------------------------|
| RE-01 | ...       | [verbo]  | ...       | 1..1 / 1..N / N..N | ... |

(Trasladar directamente las RE-xx del analysis_report. No inferir relaciones nuevas.)
```

**Reglas:**
- IDs de reglas de negocio: `RN-xx` (RN-01, RN-02 …). Secuencial global.
- Cubrir todas las entidades `EN-xx` del analysis_report.
- La columna "Tipo de dato (negocio)" usa lenguaje de negocio, nunca tipos técnicos (no `VARCHAR`, `INT`, `UUID`).
- La columna "Escenario BDD relacionado" traza cada campo a al menos un SC-xx o SE-xx.
- Si un campo no puede trazarse a ningún escenario BDD, registrar como `[sin escenario — revisar]`.
- Trasladar las relaciones RE-xx del analysis_report sin inferir relaciones adicionales.
- `Estado: DRAFT` hasta aprobación de A en CP-04.

---

## Artefacto 3 — acceptance_criteria.md

**Path:** `/020_specification/acceptance_criteria.md`

Producir tercero. Requiere que `bdd_features.md` esté completo para tener los IDs SC-xx y SE-xx.

```
# Product Acceptance Criteria — 020 Specification
Fecha: [fecha]
Estado: DRAFT | APROBADO POR CLIENTE
Basado en: 020_specification/spec_analysis_report.md + 020_specification/bdd_features.md

## Criterios de Aceptación por Actor

### [Actor AC-01 — Nombre]

| ID     | Criterio | Escenario BDD | Condición de cumplimiento | Condición de fallo |
|--------|----------|---------------|--------------------------|-------------------|
| ACP-01 | ...      | SC-xx / SE-xx | [qué debe ser verdad para considerarlo cumplido] | [qué indica que no cumple] |

[repetir por cada actor AC-xx]

---

## Criterios de Aceptación Globales

(Criterios que aplican a todos los actores o al sistema en general.)

| ID     | Criterio | Escenario BDD | Condición de cumplimiento | Condición de fallo |
|--------|----------|---------------|--------------------------|-------------------|
| ACP-xx | ...      | SC-xx / SE-xx | ...                       | ...               |

---

## Trazabilidad inversa

| Escenario BDD | Criterio de aceptación |
|---------------|------------------------|
| SC-01         | ACP-xx                 |
| SE-01         | ACP-xx                 |

(Verificar que ningún SC-xx ni SE-xx quede sin criterio de aceptación asociado.)
```

**Reglas:**
- IDs: `ACP-xx` (ACP-01, ACP-02 …). Secuencial global.
- Todo criterio debe referenciar un SC-xx o SE-xx de `bdd_features.md`. Sin criterios huérfanos.
- Todo SC-xx y SE-xx de `bdd_features.md` debe tener ≥1 ACP-xx en la tabla de trazabilidad inversa.
- La "Condición de cumplimiento" es verificable por el cliente: describe un comportamiento observable, no una implementación técnica.
- `Estado: DRAFT` hasta aprobación de A en CP-04.

---

## Artefacto 4 — error_exception_policy.md

**Path:** `/020_specification/error_exception_policy.md`

Producir último. Resuelve todos los EE-xx del analysis_report (incluyendo los que estaban PENDIENTE en el 010 y el governor ya resolvió).

```
# Error & Exception Policy — 020 Specification
Fecha: [fecha]
Estado: DRAFT | APROBADO POR CLIENTE
Basado en: 020_specification/spec_analysis_report.md

## Políticas por Actor

### [Actor AC-01 — Nombre]

| ID     | Escenario de error (EE-xx) | Causa | Mensaje al usuario | Reintento | Bloqueo | Acción alternativa | Escenario BDD relacionado |
|--------|---------------------------|-------|-------------------|-----------|---------|-------------------|--------------------------|
| EP-01  | EE-xx — [descripción]     | ...   | "[texto exacto]"  | sí (N veces) / no | sí / no | [qué hace el sistema] | SE-xx |

[repetir por cada actor con ítems EE-xx]

---

## Políticas Globales

(Errores no atribuibles a un actor específico — errores de sistema, conectividad, etc.)

| ID     | Escenario de error (EE-xx) | Causa | Mensaje al usuario | Reintento | Bloqueo | Acción alternativa |
|--------|---------------------------|-------|-------------------|-----------|---------|-------------------|
| EP-xx  | EE-xx — [descripción]     | ...   | "[texto exacto]"  | sí / no   | sí / no | ...               |

---

## Resoluciones de ítems PENDIENTE del 010

(Solo si el analysis_report incluía ítems que estaban PENDIENTE en failure_behavior.md.
Si no aplica, escribir "Ninguno".)

| Ítem original (EE-xx) | Pregunta que estaba pendiente | Resolución del governor | Política aplicada (EP-xx) |
|-----------------------|------------------------------|------------------------|--------------------------|
| ...                   | ...                          | ...                    | EP-xx                    |
```

**Reglas:**
- IDs: `EP-xx` (EP-01, EP-02 …). Secuencial global.
- Cubrir todos los EE-xx del analysis_report. Sin excepciones.
- El "Mensaje al usuario" debe ser texto concreto y en lenguaje de dominio — no "[mensaje de error genérico]".
- La columna "Acción alternativa" especifica qué hace el sistema, no solo qué muestra. Puede ser "ninguna" si la única acción es mostrar el mensaje.
- Todo EE-xx que estaba marcado como PENDIENTE en failure_behavior.md y fue resuelto por el governor debe aparecer en la sección "Resoluciones de ítems PENDIENTE del 010".
- `Estado: DRAFT` hasta aprobación de A en CP-04.

---

## Verificación de cobertura (specification-writer al terminar)

Antes de reportar a B, verificar:

- [ ] `bdd_features.md`: todos los actores AC-xx tienen ≥1 escenario SC-xx (camino feliz)
- [ ] `bdd_features.md`: todos los actores AC-xx tienen ≥1 escenario SE-xx (caso de borde)
- [ ] `data_contracts.md`: todas las entidades EN-xx del analysis_report tienen contrato
- [ ] `data_contracts.md`: todas las relaciones RE-xx del analysis_report están en la sección de relaciones
- [ ] `acceptance_criteria.md`: todos los SC-xx y SE-xx tienen ≥1 ACP-xx en trazabilidad inversa
- [ ] `acceptance_criteria.md`: ningún ACP-xx tiene campo "Escenario BDD" vacío
- [ ] `error_exception_policy.md`: todos los EE-xx del analysis_report tienen política EP-xx
- [ ] `error_exception_policy.md`: los ítems PENDIENTE resueltos están en la sección correspondiente
- [ ] Los 4 archivos existen en `/020_specification/`
- [ ] Ningún término clave queda sin referencia en `domain_glossary.md` (o está marcado con `[GLOSARIO: pendiente]`)
