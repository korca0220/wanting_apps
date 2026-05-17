create table if not exists profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function set_profiles_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on profiles;
create trigger profiles_set_updated_at
before update on profiles
for each row execute function set_profiles_updated_at();

alter table profiles enable row level security;

drop policy if exists "owner can read own profile" on profiles;
create policy "owner can read own profile"
  on profiles for select
  using (auth.uid() = user_id);

drop policy if exists "owner can insert own profile" on profiles;
create policy "owner can insert own profile"
  on profiles for insert
  with check (auth.uid() = user_id);

drop policy if exists "owner can update own profile" on profiles;
create policy "owner can update own profile"
  on profiles for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
