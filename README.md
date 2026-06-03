# FORGE — Harness Definition

**FORGE** (*Framework for Orchestrated Requirements and Guided Engineering*) es el nombre de este sistema de harnesses agénticos para desarrollo de software.

**En español:** Marco para Ingeniería Guiada y Orquestación de Requisitos.

**Por qué FORGE:** Una fragua transforma materia bruta en algo sólido y preciso aplicando calor, presión y forma. FORGE hace lo mismo con un proyecto de software: toma un brief crudo y lo transforma en código listo para producción a través de fases estructuradas (Discovery → Specification → Design → Planning → ...), con agentes especializados que garantizan calidad y reducen la varianza en cada etapa.

---

Repositorio de definición de **harnesses agénticos** para proyectos de software. Un harness es un conjunto de agentes Claude especializados que guían a un equipo a través de una fase del ciclo de vida del software (discovery, especificación, diseño, etc.) con calidad y consistencia garantizadas.

---

## Estructura del repositorio

```
Harness_Definition/
├── deploy-harness.ps1              — Script de deployment (ver más abajo)
├── CLAUDE.md                       — Instrucciones para agentes en este repo
│
├── Insumos/
│   ├── principios.md               — Principios P1-P8 y Estándares E1-E12 (fuente de verdad inmutable)
│   └── metodologia.md              — Metodología universal de harnesses (cerrada)
│
├── Harnesses/
│   ├── 010_discovery_harness.md    — Harness completo de Discovery (IMPLEMENTADO y probado)
│   ├── 020_specification_harness.md
│   ├── 030_design_harness.md
│   └── ... (hasta 090_deployment_harness.md)
│
├── .claude/
│   ├── agents/                     — Agentes del harness 010 (discovery-*)
│   └── skills/                     — Skills de soporte para los agentes
│
├── templates/
│   ├── client-project-CLAUDE.md    — Plantilla CLAUDE.md para proyectos cliente
│   └── client-project-settings.json — Permisos pre-autorizados para proyectos cliente
│
├── plans/                          — Blueprints de construcción de cada harness
└── support/
    ├── avance.md                   — Bitácora de estado del proyecto (leer primero)
    └── ajustes.md                  — Registro de brechas e implementaciones
```

---

## Harnesses disponibles

| Número | Nombre | Estado |
|--------|--------|--------|
| 010 | Discovery | Completo y validado (score 0.92) |
| 020 | Specification | Definición de alto nivel |
| 030 | Design | Definición de alto nivel |
| 040 | Planning | Definición de alto nivel |
| 050 | Iteration | Definición de alto nivel |
| 060 | Isolation | Definición de alto nivel |
| 070 | Execution | Definición de alto nivel |
| 080 | Verification | Definición de alto nivel |
| 090 | Deployment | Definición de alto nivel |

---

## Cómo desplegar un harness en un proyecto cliente

### 1. Prerrequisitos

- PowerShell 5.1 o superior
- Claude Code CLI instalado (`claude` disponible en terminal)
- El directorio destino del proyecto cliente ya debe existir

### 2. Crear el directorio del proyecto cliente

```powershell
New-Item -ItemType Directory "C:\ruta\al\MiProyecto"
```

### 3. Ejecutar el script de deployment

Desde la raíz de este repositorio (`Harness_Definition`):

```powershell
.\deploy-harness.ps1 -Harness 010 -Destino "C:\ruta\al\MiProyecto"
```

**Parámetros:**

| Parámetro | Descripción | Ejemplo |
|-----------|-------------|---------|
| `-Harness` | Número del harness a desplegar | `010`, `020`, ..., `090` |
| `-Destino` | Path absoluto al directorio del proyecto cliente | `"C:\Proyectos\MiApp"` |

**Qué hace el script:**

1. Valida que el harness sea conocido y que el directorio destino exista.
2. Crea `.claude/agents/` y `.claude/skills/` en el destino si no existen.
3. **Hot-swap:** elimina solo los archivos del harness indicado que ya existan en el destino (no toca otros harnesses).
4. Copia los agentes (`discovery-*.md`) al destino.
5. Copia las skills (`discovery-*/`) al destino.
6. Copia `CLAUDE.md` y `.claude/settings.json` desde los templates — **solo si no existen** (no sobreescribe en re-deployments).

**Ejemplo de salida:**

```
=== deploy-harness.ps1 ===
Harness : 010 (discovery-*)
Destino : C:\Proyectos\MiApp

--- Limpieza (hot-swap) ---
  (ningun agente previo del harness 010 en destino)

--- Agentes copiados (6) ---
  [OK] .claude\agents\discovery-dialoguer.md
  [OK] .claude\agents\discovery-analyst.md
  [OK] .claude\agents\discovery-synthesizer.md
  [OK] .claude\agents\discovery-evaluator.md
  [OK] .claude\agents\discovery-orchestrator.md
  [OK] .claude\agents\discovery-governor.md

--- Skills copiadas (7) ---
  [OK] .claude\skills\discovery-interview-protocol
  ...

--- Templates ---
  [OK]      .claude\settings.json (creado)
  [OK]      CLAUDE.md (creado)

=== Deployment completado ===
Siguiente paso: abrir Claude Code en 'C:\Proyectos\MiApp'
```

### 4. Iniciar el harness en el proyecto cliente

```powershell
cd "C:\ruta\al\MiProyecto"
claude
```

Claude Code leerá el `CLAUDE.md` generado y arrancará el harness automáticamente. No es necesario escribir ninguna frase especial — el agente se inicializa solo.

---

## Cómo funciona el harness (010 Discovery como ejemplo)

### Arquitectura de agentes

El harness usa tres niveles jerárquicos:

```
Usuario (humano)
    └── discovery-governor      (Instancia A — punto de entrada, gates humanos)
            └── discovery-orchestrator  (Instancia B — coordinación técnica)
                    ├── discovery-dialoguer    (Worker — entrevista socrática)
                    ├── discovery-analyst      (Worker — análisis del transcript)
                    └── discovery-synthesizer  (Worker — genera los 4 artefactos)
            └── discovery-evaluator     (Instancia C — auditoría independiente)
```

### Flujo de una sesión

1. **Inicio (E10-A):** el governor crea la estructura de carpetas, inicializa archivos de estado, hace `git init` y propone el Sprint Contract al humano.
2. **Gate de aprobación:** el humano aprueba, ajusta o cancela el Sprint Contract.
3. **Ejecución técnica:** el orchestrator coordina los 3 workers en secuencia. El dialoguer entrevista stakeholders, el analyst detecta contradicciones, el synthesizer produce los artefactos.
4. **Gate CP-03:** el humano revisa un draft de los artefactos.
5. **Gate CP-04:** aprobación formal del cliente.
6. **Auditoría (C):** el evaluator puntúa los artefactos contra la rúbrica (5 dimensiones, score mínimo 0.75). Si falla → rework; si pasa → APPROVED.
7. **Cierre:** commit final, `lessons_learned.md` actualizado, harness marcado `PHASE_COMPLETE`.

### Reanudación automática

Si la sesión se interrumpe (Ctrl+C, pérdida de contexto), basta con volver a abrir Claude Code en el directorio del proyecto:

```powershell
cd "C:\ruta\al\MiProyecto"
claude
```

El governor detecta `persistence/harness-state.json` y retoma desde el último checkpoint registrado.

### Artefactos generados

Al completar el harness 010, el proyecto cliente tendrá:

```
MiProyecto/
├── 010_discovery/
│   ├── shared_understanding.md   — Entendimiento compartido del dominio
│   ├── scope_boundaries.md       — Qué está dentro y fuera del alcance
│   ├── domain_glossary.md        — Glosario de términos acordados
│   └── failure_behavior.md       — Comportamiento esperado ante fallos
├── eval/
│   ├── verdict.json              — Resultado de la auditoría (score + dimensiones)
│   └── metrics_summary.json      — Métricas objetivas e historial de versiones
└── persistence/
    ├── harness-state.json        — Estado del harness (escrito por governor)
    └── execution-state.json      — Plan de orquestación y checkpoints
```

---

## Re-deployment (actualizar un harness ya desplegado)

Si se corrige un agente en este repositorio y se quiere propagar al proyecto cliente, ejecutar el mismo comando:

```powershell
.\deploy-harness.ps1 -Harness 010 -Destino "C:\ruta\al\MiProyecto"
```

El script hace hot-swap: elimina solo los archivos del harness 010 y copia las versiones nuevas. El `CLAUDE.md` y `settings.json` del cliente no se tocan (ya existían).

---

## Convenciones de nombres

Los agentes y skills siguen la convención `<harness>-<rol>`:

- `discovery-governor`, `discovery-orchestrator`, `discovery-dialoguer`, etc.
- `discovery-interview-protocol`, `discovery-state-schema`, etc.

Esto permite que el script de deployment filtre por prefijo sin hardcodear nombres individuales. Los harnesses futuros deben seguir la misma convención.

---

## Notas importantes

- **Encoding:** los scripts `.ps1` usan solo ASCII puro. PowerShell 5.1 en Windows puede corromper caracteres UTF-8 multi-byte (tildes, guiones largos). No agregar esos caracteres a los scripts.
- **El directorio destino debe existir antes de ejecutar el script.** El script no lo crea para evitar deployments accidentales en rutas incorrectas.
- **`Insumos/principios.md` y `Insumos/metodologia.md` son inmutables.** No modificarlos.
- El estado del proyecto y el historial de decisiones están en `support/avance.md`.
