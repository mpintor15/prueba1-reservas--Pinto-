-- Esquema de la app de reservas de sala.
-- Ejecutar en el SQL Editor de Supabase.

create table if not exists public.reservas (
  id          uuid primary key default gen_random_uuid(),
  sala_id     text not null,
  usuario_id  uuid not null references auth.users (id),
  inicio      timestamptz not null,
  fin         timestamptz not null,
  creada_en   timestamptz not null default now(),
  constraint fin_despues_de_inicio check (fin > inicio)
);

alter table public.reservas enable row level security;

revoke all on public.reservas from anon, authenticated;
grant select (id, sala_id, inicio, fin) on public.reservas to authenticated;
grant insert on public.reservas to authenticated;

drop policy if exists "ver reservas" on public.reservas;
create policy "ver reservas"
  on public.reservas for select
  to authenticated
  using (true);

drop policy if exists "crear reservas" on public.reservas;
create policy "crear reservas"
  on public.reservas for insert
  to authenticated
  with check ((select auth.uid()) = usuario_id);
