# Deployment Harness (Despliegue y Entrega Continua)

El objetivo de este arnés es automatizar y asegurar el paso del software verificado a los entornos de ejecución (Staging, Producción). Su misión es garantizar que el despliegue sea seguro, observable y que el sistema esté disponible y saludable para los usuarios finales.

## Precondición: Gate de Peer Review
Este arnés **no se activa automáticamente** al terminar el 080. Entre el 080 y el 090 existe un gate de aprobación humana gestionado por la **Instancia A (Gobernanza)**:
1.  La Instancia A recibe el `Ready-for-Review Artifact` del 080 y lo presenta al humano para peer review.
2.  El humano inspecciona el PR y emite su aprobación explícita.
3.  Solo tras esa aprobación, la Instancia A activa el 090 pasándole la referencia al artefacto aprobado.
4.  Si el humano solicita cambios, el flujo regresa al 050 siguiendo la ruta definida en el 080.

## Entradas (Inputs)
*   **Ready-for-Review Artifact (del Verification Harness):** El código inspeccionado por humanos y con peer review aprobado.
*   **Infrastructure as Code (IaC):** Definiciones del entorno (contenedores, servidores, bases de datos).
*   **Secretos y Configuración de Entorno:** Credenciales seguras y variables específicas de cada entorno.
*   **Políticas de Despliegue:** Reglas sobre cuándo y cómo desplegar (ej. Blue-Green, Canary, ventanas de mantenimiento).

## Proceso (Process)
*   **Orquestación de CI/CD:** Ejecución de los pipelines automatizados de despliegue.
*   **Smoke Testing / Health Checks:** Verificación automática de que la aplicación está "viva" y respondiendo correctamente justo después del despliegue.
*   **Gestión de Tráfico:** Switch gradual de usuarios de la versión vieja a la nueva (si se usa Canary o Blue-Green).
*   **Monitoreo Post-Despliegue:** Observación de métricas clave (latencia, errores, consumo) para detectar problemas tempranos.
*   **Automated Rollback:** Capacidad de revertir instantáneamente a la versión anterior si los health checks fallan.

## Salidas (Outputs - Artefactos)
*   **Live Application:** La nueva versión del software funcionando en el entorno objetivo.
*   **Deployment Report:** Registro detallado de qué se desplegó, quién lo aprobó y el resultado de los health checks.
*   **System Health Dashboard:** Enlace o reporte del estado actual del sistema tras el cambio.
*   **Final Value Delivery Notification:** Confirmación de que el incremento de valor ya está disponible para el cliente.
