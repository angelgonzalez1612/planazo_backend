# Planazo — Backend

API de Planazo (NestJS + Drizzle ORM sobre PostgreSQL). Modela el contenido
como un **motor de conocimiento**: un `Place` (lugar) es una entidad
reutilizable que se relaciona con artículos, eventos, promociones y
rankings, en vez de vivir dentro de un único post de blog.

Este repo es hermano de [`planazo_fronted`](https://github.com/angelgonzalez1612/planazo_fronted)
(sitio público) y [`planazo_cms`](https://github.com/angelgonzalez1612/planazo_cms)
(panel de generación de contenido con IA, en construcción). Los tres
consumen el mismo contrato en `packages/types` y, cuando el CMS exista,
ambos frontends van a hablarle a esta API por HTTP — nunca entre ellos.

## Estructura

```
apps/
  api/      NestJS + Drizzle ORM — API REST sobre PostgreSQL
packages/
  types/    Contrato de datos compartido (Place, Article, Ranking, ...)
  shared/   Utilidades puras (slugify, formatPriceLevel, ...)
```

## Requisitos

- Node.js 20+
- pnpm 9 (`corepack enable` si no lo tienes)
- PostgreSQL (Supabase recomendado)

## Puesta en marcha

```bash
pnpm install
cp apps/api/.env.example apps/api/.env   # completar DATABASE_URL, etc.
pnpm --filter @planazo/api db:migrate
pnpm dev
```

## Variables de entorno (`apps/api/.env`)

| Variable | Descripción |
|---|---|
| `DATABASE_URL` | Connection string de Postgres (Supabase → Database → Connection string) |
| `PORT` | Puerto de la API (default 3001) |
| `CORS_ORIGIN` | Origen permitido para CORS (URL del frontend) |
| `REDIS_URL` | Opcional, para cuando se agregue cache de home/búsquedas |

## Modelo de datos (resumen)

`places` es la entidad central. Se relaciona (muchos-a-muchos donde
aplica) con `categories`, `tags`, `services`, `photos`, `social_links`,
`opening_hours`, `articles` (vía `article_places`), `events`,
`promotions` y `rankings` (vía `ranking_places`, con posición). Ver
`apps/api/src/db/schema/*.ts` — es la fuente de verdad; `packages/types`
espeja el contrato HTTP que expone la API.

## Scripts

- `pnpm dev` — levanta la API en modo watch
- `pnpm build` / `pnpm lint` / `pnpm typecheck` — en todos los paquetes
- `pnpm db:generate` — genera una migración SQL a partir del schema de Drizzle
- `pnpm db:migrate` — aplica migraciones pendientes
