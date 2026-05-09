# Supabase migrations

Source of truth for the DailyPiece backend schema.

`migrations/0001_*` and `0002_*` were applied to the dev project
(`ezkxljofqluwljhofwey`) via Supabase MCP. They are kept here as the
audit trail and for replaying onto a fresh project (e.g. prod).

## Replay onto a new project

Either via Supabase CLI:

```bash
supabase link --project-ref <ref>
supabase db push
```

Or paste each `*.sql` into the dashboard SQL Editor in order.

## Adding a new migration

1. Write `NNNN_<snake_case>.sql` here (next number).
2. Apply via MCP `apply_migration` tool, or `supabase db push` once CLI is set up.
3. Commit the file in the same change as any client code that depends on it.
