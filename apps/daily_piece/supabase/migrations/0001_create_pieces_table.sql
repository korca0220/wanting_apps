-- Pieces table — see ADR 0003.
-- Domain invariant "one Piece per local day" is enforced by UNIQUE(user_id, date).

create table public.pieces (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  photo_path  text not null,
  comment     varchar(50) not null,
  date        date not null,
  created_at  timestamptz not null default now(),
  unique (user_id, date)
);

-- Timeline query: latest pieces per user, descending.
create index pieces_user_id_date_desc_idx
  on public.pieces (user_id, date desc);

alter table public.pieces enable row level security;

create policy "owner can read own pieces"
  on public.pieces for select
  using (auth.uid() = user_id);

create policy "owner can insert own pieces"
  on public.pieces for insert
  with check (auth.uid() = user_id);

create policy "owner can update own pieces"
  on public.pieces for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "owner can delete own pieces"
  on public.pieces for delete
  using (auth.uid() = user_id);
