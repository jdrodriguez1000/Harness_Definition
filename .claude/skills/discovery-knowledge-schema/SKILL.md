---
name: discovery-knowledge-schema
description: Schema y formato de los dos archivos de conocimiento del 010 Discovery Harness — lessons_learned.md y decisions_library.md. Escritor exclusivo: discovery-governor. Usar cuando discovery-governor escribe en estos archivos al cerrar un ciclo, registrar un rechazo, o documentar decisiones tomadas durante los gates.
user-invocable: false
agent: discovery-governor
---

Los dos archivos de conocimiento viven en `/knowledge/` del directorio de trabajo del proyecto.
El directorio `/knowledge/` es creado por discovery-governor en el Ritual E10-A Paso 2.

**Escritor único:** discovery-governor. Ningún Worker ni discovery-orchestrator escribe estos archivos.
**Lectores:** discovery-orchestrator (lee al inicio para contexto; no modifica).

---

## Archivo 1 — lessons_learned.md

**Path:** `/knowledge/lessons_learned.md`

**Estructura del archivo:**

```markdown
# Lessons Learned — 010 Discovery

<!-- Una entrada por ciclo o evento significativo. Las entradas nuevas se agregan al final. -->

## Ciclo 1 — <timestamp>

**Tipo:** técnico | estratégico | aprendizaje
**Descripción:** <qué pasó>
**Acción tomada:** <cómo se respondió>
**Resultado:** <outcome observado>

---
```

**Reglas:**
- Una sección `## Ciclo N` por evento significativo (rechazo, rework, aprendizaje notable del cierre).
- El campo `Tipo` clasifica el origen: `técnico` (artefacto incompleto, actor sin objetivo), `estratégico` (cambio de intención del cliente), `aprendizaje` (insight de proceso).
- Regla append-only: no modificar entradas anteriores. Solo agregar secciones nuevas al final.
- discovery-governor escribe en este archivo en dos momentos: al registrar un rechazo (Protocolo de Rechazo) y en el Cierre (paso 2).

---

## Archivo 2 — decisions_library.md

**Path:** `/knowledge/decisions_library.md`

**Estructura del archivo:**

```markdown
# Decisions Library — 010 Discovery

| ID | Decisión | Razón | Harness | Timestamp |
|----|----------|-------|---------|-----------|
| D-001 | <descripción de la decisión> | <por qué se tomó> | 010_discovery | <timestamp ISO 8601> |
```

**Reglas:**
- Una fila por decisión. El ID es secuencial: D-001, D-002, etc.
- El campo `Decisión` es conciso (una línea). La `Razón` explica el contexto que llevó a elegir esa opción.
- discovery-governor escribe en este archivo durante los gates (Sprint Contract, CP-03, CP-04) y en el Cierre.
- Las decisiones del cliente (aprobaciones, cambios de scope) y las decisiones del harness (rechazo técnico vs estratégico) son ambas candidatas a registrar.
- Regla append-only: no modificar filas anteriores. Solo agregar nuevas filas al final de la tabla.

---

## Cuándo escribe discovery-governor

| Evento | Archivo | Contenido a agregar |
|--------|---------|---------------------|
| Rechazo técnico | `lessons_learned.md` | Ciclo con Tipo=técnico, razones del verdict, acción de rework |
| Rechazo estratégico | `lessons_learned.md` | Ciclo con Tipo=estratégico, cambio de intención del cliente |
| Cierre (Paso 2) | `lessons_learned.md` | Ciclo con Tipo=aprendizaje, resumen del ciclo completo |
| Aprobación Sprint Contract | `decisions_library.md` | Decisión de scope/restricciones aprobada |
| CP-04 aprobación formal | `decisions_library.md` | Decisión de aprobación del Shared Understanding |
| Rechazo técnico | `decisions_library.md` | Decisión de re-ejecutar workers vs escalar |
