# Stacks de Referencia del Equipo

Este archivo define los stacks tecnológicos preferidos por el equipo según el tipo
de proyecto. El design-architect lo lee cuando las RT-xx del cliente son ausentes o
insuficientes para determinar el stack completo.

**Mantenimiento:** actualizar este archivo cuando el equipo adopte nuevas tecnologías
o cambie de preferencias. El deploy-harness.ps1 copia este archivo al proyecto cliente
en cada deployment, por lo que siempre refleja la versión actual.

---

## Criterio de clasificación de tier

Evaluar las siguientes señales del `design_analysis_report.md` (bounded contexts, RT-xx, CO-xx):

| Señal | Tier PEQUEÑO | Tier GRANDE |
|---|---|---|
| Tipos de cliente | Solo web | Web + móvil y/o escritorio |
| Equipos de desarrollo | Un solo equipo | Múltiples equipos por área |
| Volumen de usuarios | Pocos usuarios diarios | Alto volumen / concurrencia |
| Necesidad de rendimiento | Estándar | Alto rendimiento en backend crítico |
| Tiempo de entrega | Días / semanas | Meses |
| Separación backend/frontend | No requerida | Requerida (backends independientes) |

Si hay ambigüedad, documentar las señales evaluadas en el ADR-001 y justificar
la elección del tier. El humano puede corregir en CP-03.

---

## Criterio de aplicación (ambos tiers)

- RT-xx del cliente cubren el stack completo → ignorar este archivo, respetar RT-xx.
- RT-xx son parciales → completar las capas faltantes con el stack del tier correspondiente.
- Sin RT-xx → proponer el stack completo del tier y documentarlo en ADR-001 como
  "stack de referencia del equipo — sin restricciones explícitas del cliente".

El ADR-001 debe documentar explícitamente:
- El tier elegido (PEQUEÑO / GRANDE) y las señales que justifican la clasificación.
- Qué capas vienen de RT-xx del cliente y cuáles del stack de referencia del equipo.
- Cualquier desviación del stack de referencia y la razón técnica que la justifica.

---

## Stack Tier PEQUEÑO

*Uso: app web para cliente, pocos usuarios, entrega rápida, un solo equipo.*

### Opción A — Full-stack JavaScript (sin backend separado)

| Capa | Tecnología | Alternativas válidas |
|---|---|---|
| Full-stack framework | Next.js | TanStack Start, SvelteKit, Nuxt.js |
| UI components | shadcn/ui | — |
| Formularios + validación | React Hook Form + Zod | — |
| ORM | Prisma | Drizzle |
| Base de datos | PostgreSQL | — |
| Almacenamiento de archivos | DigitalOcean Spaces (S3-compat.) | AWS S3 |
| Emails transaccionales | Brevo | AWS SES |
| Autenticación | Better Auth | NextAuth (legacy) |
| Deploy | Railway | VPS (Hostinger, DigitalOcean) |

*Elegir cuando el equipo es JavaScript/TypeScript first o cuando no se requiere API pública separada.*

### Opción B — Backend Python + Frontend React

| Capa | Tecnología | Alternativas válidas |
|---|---|---|
| Backend API | FastAPI | — |
| ORM | SQLAlchemy | — |
| Migraciones | Alembic | — |
| Admin panel | sqladmin | Panel custom con React |
| Base de datos | PostgreSQL | — |
| Frontend | React + Vite | Next.js si hay SEO |
| UI components | shadcn/ui | — |
| Almacenamiento de archivos | DigitalOcean Spaces (S3-compat.) | AWS S3 |
| Emails transaccionales | Brevo | AWS SES |
| Deploy | Railway | VPS (Hostinger, DigitalOcean) |

*Elegir cuando el equipo domina Python, o cuando el proyecto requiere lógica de backend con tipado fuerte (Pydantic) y/o panel de administración básico (CRUD de usuarios, catálogos, configuración). `sqladmin` genera el admin directamente desde los modelos SQLAlchemy — sin código adicional para casos básicos.*

---

## Stack Tier GRANDE

*Uso: múltiples clientes (web + móvil + escritorio), múltiples equipos, alto rendimiento.*

### Evaluación de backend (obligatoria antes de elegir tecnología)

Para proyectos Tier GRANDE, evaluar primero si FastAPI es suficiente como backend:

| Criterio | FastAPI es suficiente | Escalar a Go |
|---|---|---|
| Concurrencia | async/await cubre la carga esperada | Miles de conexiones simultáneas, latencia sub-ms crítica |
| Equipo | Domina Python | El equipo ya trabaja en Go o la performance lo exige |
| Procesamiento | I/O bound (APIs, DB, servicios externos) | CPU bound (video, criptografía, procesamiento masivo) |
| Despliegue | Un backend monolítico o pocos servicios | Microservicios independientes con SLAs estrictos |

**Si FastAPI es suficiente:** usarlo como backend en lugar de Go. Documentar en ADR-001 la evaluación realizada y la razón por la que Go no fue necesario.

**Si Go es necesario:** justificarlo en ADR-001 con el criterio específico que lo requiere (no elegir Go por defecto sin evaluación). Informar al humano en CP-03 que se escaló más allá de FastAPI y por qué.

| Capa | Tecnología por defecto | Alternativa si FastAPI es suficiente |
|---|---|---|
| Base de datos principal | PostgreSQL | — |
| Base de datos NoSQL | MongoDB | — |
| Base de datos ligera / interna | SQLite | — |
| Caché | Redis | — |
| Backend (REST API) | Go + Gin | FastAPI + SQLAlchemy |
| ORM | GORM (Go) / SQLAlchemy (Python) | — |
| Frontend sin SEO (dashboard) | React + Vite | Svelte, Angular, Vue |
| Frontend con SEO (público) | Next.js | — |
| Mobile | React Native | Swift (iOS), Kotlin (Android) |
| Desktop | Tauri | Nativo |
| Integración IA — terminal | CLI en Go | CLI en TypeScript |
| Integración IA — chat | MCP en TypeScript / Python | MCP en Go |
| CI/CD | GitHub Actions + GHCR | — |
| Deploy | Railway / AWS / DigitalOcean | VPS propio |
| Editor recomendado | VS Code + GitHub Copilot | Zed |

**Decisión de repositorio (Tier GRANDE):** repos separados o carpetas separadas en el mismo
repo desplegadas de forma independiente. Sin monorepo — Go y TypeScript no comparten lógica.
