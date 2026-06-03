---
name: discovery-interview-protocol
description: Protocolo socrático del 010 Discovery Harness. Define el arranque en frío, la identificación de stakeholders, los 3 bancos de preguntas por rol (negocio/técnico/usuario), las reglas de conducción del diálogo y el criterio de parada. Usar cuando discovery-dialoguer conduce la entrevista de descubrimiento.
user-invocable: false
agent: discovery-dialoguer
---

## Reglas de conducción del diálogo

1. **Una pregunta a la vez.** Nunca hagas más de una pregunta por turno.
2. **Valida antes de profundizar.** Cuando el interlocutor responde, confirma lo entendido antes de continuar.
3. **No asumas.** Si algo no está claro, pregunta en lugar de inferir.
4. **Escribe después de cada ronda.** Inmediatamente después de recibir una respuesta, actualizar el transcript antes de formular la siguiente pregunta. No acumular rondas en memoria.
5. **Un interlocutor a la vez.** Completa la entrevista de un stakeholder antes de pasar al siguiente.

---

## Fase -1 — Verificación de estado (siempre, al arrancar)

Antes de cualquier otra acción, verificar si `/010_discovery/dialogue_transcript.md` ya existe:

**Si existe:**
- Leer el bloque `## Estado de stakeholders` para identificar el estado de cada uno.
- Leer `Stakeholder activo` y `Última ronda completada`.
- Si hay un stakeholder EN CURSO: reanudar esa entrevista desde la siguiente ronda.
- Si no hay stakeholder EN CURSO pero hay PENDIENTES: comenzar con el primero de la lista.
- Si todos están COMPLETA o NO DISPONIBLE: el transcript ya está terminado — reportar a B y no hacer nada más.
- Notificar al interlocutor que se retoma la sesión: "Retomamos la entrevista. La última pregunta fue: [última ronda]. ¿Continuamos?"

**Si no existe:**
- Continuar a la Fase 0 (arranque) o Fase 1 (primer inicio con inputs disponibles).

---

## Fase 0 — Arranque en frío (solo si no hay inputs)

Si ninguno de los tres archivos de input existe (`brief.md`, `business_context.md`, `constraints.md`),
ejecutar este protocolo antes de iniciar cualquier entrevista:

Usar `AskUserQuestion` con estas preguntas (una sola llamada con múltiples preguntas):
1. "¿Cuál es el nombre del proyecto o sistema que quieren construir?"
2. "En 2–3 líneas: ¿qué problema central buscan resolver?"
3. "¿Quién es el primer stakeholder con el que debo hablar ahora?"

Registrar las respuestas en el transcript bajo `## Contexto de arranque` antes de las rondas de diálogo.
Continuar con la Fase 1 usando esta información como punto de partida.

---

## Fase 1 — Identificación de stakeholders

Al inicio de la primera entrevista, antes de entrar a las preguntas de contenido, identificar el
universo completo de interlocutores:

1. "Antes de empezar, ¿quién eres y cuál es tu rol en este proyecto?"
   → Registrar: nombre o identificador, rol (negocio / técnico / usuario final / otro)

2. "¿Hay otras personas que deberían participar en esta etapa de descubrimiento?"
   → Por cada persona mencionada: nombre/identificador + rol + disponibilidad estimada
   → Registrar en el transcript bajo `## Stakeholders pendientes`

3. Si el interlocutor no menciona a nadie más, preguntar explícitamente:
   - "¿Hay alguien del área técnica o de sistemas que deba conocer las restricciones existentes?"
   - "¿Hay usuarios que usarán el sistema directamente cuya opinión sería valiosa?"

Todos los stakeholders identificados forman la **lista de entrevistas pendientes**. discovery-dialoguer
no puede cerrar el transcript como COMPLETO hasta haber entrevistado a todos.

---

## Fase 2 — Entrevista por stakeholder

Para cada stakeholder de la lista, identificar su rol y aplicar el banco de preguntas correspondiente.
Si el rol no es claro, preguntar: "¿Cuál es tu relación principal con este proyecto?"

### Banco A — Stakeholder de Negocio (gerente, directivo, product owner, sponsor)

**Área A1 — Problema y objetivo estratégico**
- ¿Qué problema de negocio concreto resuelve este sistema?
- ¿Cómo se maneja ese problema hoy sin el sistema?
- ¿Qué tendría que pasar para que digas "el sistema funciona perfectamente"?
- ¿Cómo medirías el éxito del sistema en términos de negocio (tiempo, dinero, clientes, errores)?

**Área A2 — Prioridades y restricciones de negocio**
- Si tuvieras que elegir una sola cosa que el sistema debe hacer bien, ¿cuál sería?
- ¿Hay plazos, presupuestos o restricciones regulatorias que el sistema deba respetar?
- ¿Qué pasaría si el sistema no estuviera disponible durante 1 hora? ¿Y durante 1 día?

**Área A3 — Actores y conflictos de prioridad**
- ¿Quiénes son los beneficiarios principales? ¿Y los que se ven afectados indirectamente?
- Si dos áreas de la empresa quieren cosas distintas del sistema, ¿quién tiene la última palabra?

**Área A4 — Comportamiento ante fallos (perspectiva de negocio)**
- Si el sistema falla mientras un cliente está haciendo una operación crítica, ¿qué debe pasar?
- ¿Hay operaciones que jamás deben perderse aunque el sistema falle (ej. transacciones, pedidos)?
- ¿Qué nivel de visibilidad quiere el negocio sobre los errores del sistema?

---

### Banco B — Stakeholder Técnico (arquitecto, líder técnico, administrador de sistemas, IT)

**Área B1 — Entorno técnico existente**
- ¿Qué sistemas o plataformas ya existen con los que este sistema debe integrarse?
- ¿Hay tecnologías impuestas (lenguaje, framework, cloud, base de datos)?
- ¿Qué parte del stack técnico es negociable y cuál no?

**Área B2 — Restricciones y deuda técnica**
- ¿Hay limitaciones de infraestructura que debamos conocer desde el inicio?
- ¿Existe deuda técnica en los sistemas actuales que podría afectar la integración?
- ¿Hay requisitos de seguridad, compliance o auditoría que el sistema deba cumplir?

**Área B3 — Volumen y escala**
- ¿Cuántos usuarios concurrentes se esperan? ¿Cuál es el pico estimado?
- ¿Qué volumen de datos maneja el sistema hoy? ¿Cómo se proyecta que crezca?

**Área B4 — Comportamiento ante fallos (perspectiva técnica)**
- ¿Qué estrategia de recuperación existe ante caídas del sistema actual?
- ¿El nuevo sistema debe tener alta disponibilidad o puede tener ventanas de mantenimiento?
- ¿Cómo se espera que el sistema maneje errores de integración con sistemas externos?

---

### Banco C — Usuario Final (operario, empleado, cliente externo, persona que usa el sistema día a día)

**Área C1 — Flujo de trabajo actual**
- ¿Qué tareas haces hoy que este sistema debería facilitar o reemplazar?
- ¿Cuánto tiempo te toma hacer esa tarea hoy? ¿Con qué frecuencia la haces?
- ¿Qué es lo más frustrante de cómo se hace esa tarea ahora?

**Área C2 — Necesidades de usabilidad**
- ¿Desde qué dispositivo usarías el sistema principalmente (computadora, celular, tablet)?
- ¿Hay momentos del día o condiciones (poco tiempo, mucho ruido, conexión lenta) en que tendrías que usarlo?
- ¿Qué nivel de detalle necesitas ver para tomar una decisión con el sistema?

**Área C3 — Errores y recuperación desde la perspectiva del usuario**
- ¿Qué pasa si cometes un error usando el sistema? ¿Necesitas poder deshacerlo?
- Si el sistema te da un mensaje de error, ¿qué información necesitas para saber qué hacer?
- ¿Alguna vez perdiste trabajo porque un sistema falló sin guardar tu avance? ¿Qué esperarías que hubiera pasado?

---

## Fase 3 — Cierre de cada entrevista

Al terminar con un stakeholder:
1. Resumir en 3–4 puntos lo que entendiste de su perspectiva y confirmar con él.
2. Preguntar: "¿Hay algo importante que no te pregunté y que crees que debería saber?"
3. Registrar el cierre en el transcript: `[ENTREVISTA CERRADA — Stakeholder: X — Ronda N]`
4. Pasar al siguiente stakeholder de la lista pendiente.

---

## Fase 5 — Modo Aclaración (solo cuando discovery-analyst lo solicita)

Este modo se activa cuando discovery-analyst encontró issues y B re-spawna discovery-dialoguer con un `analysis_report.md` que tiene preguntas pendientes.

**Diferencia con Modo Discovery:** no se repite el protocolo completo. Solo se hacen las preguntas de la sección `## Preguntas de Aclaración` del reporte, en orden, al stakeholder indicado.

**Conducción:**
1. Presentar al stakeholder: "Revisando las respuestas anteriores, necesito clarificar algunos puntos."
2. Hacer cada pregunta pendiente (PA-xx con estado PENDIENTE) de forma conversacional — una por turno, con la misma regla de validar antes de continuar.
3. Si el stakeholder no puede o no quiere responder: registrar como UNRESOLVED en el transcript con la razón indicada.
4. No hacer preguntas fuera de la lista PA-xx. El scope está definido por discovery-analyst.

**Registro en el transcript:**
Agregar las rondas de aclaración bajo una sección nueva:
```
### Aclaración — Iteración [N] — [fecha]
Fuente: /010_discovery/analysis_report.md — Preguntas PA-xx a PA-xx

#### Ronda 1
**discovery-dialoguer:** [pregunta PA-01]
**S-01:** [respuesta]
...
```

---

## Criterio de parada global

El transcript solo puede marcarse como COMPLETO cuando se cumplen **todas** estas condiciones:

1. Todos los stakeholders de la lista (incluyendo los identificados en Fase 1) han sido entrevistados.
2. No emergen contradicciones nuevas en 2 rondas consecutivas por stakeholder.
3. Todos los actores identificados tienen al menos un objetivo de valor definido.
4. Existe al menos una respuesta sobre comportamiento ante fallos de cada banco aplicado.

Si un stakeholder identificado no está disponible, registrarlo como `NO DISPONIBLE` en la lista
con el impacto estimado, y continuar sin él. No bloquear el flujo indefinidamente.
