-- Weekschema: database-opzet
-- Plakken in Supabase: SQL Editor -> New query -> Run
-- Elke gebruiker ziet en wijzigt alleen zijn eigen gegevens (Row Level Security).

create table if not exists public.weekschema_weeks (
  user_id    uuid        not null default auth.uid() references auth.users (id) on delete cascade,
  week       date        not null,              -- maandag van de week
  payload    jsonb       not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, week)
);

alter table public.weekschema_weeks enable row level security;

-- Alleen ingelogde gebruikers, en alleen hun eigen rijen
drop policy if exists "eigen weken lezen"     on public.weekschema_weeks;
drop policy if exists "eigen weken toevoegen" on public.weekschema_weeks;
drop policy if exists "eigen weken wijzigen"  on public.weekschema_weeks;
drop policy if exists "eigen weken wissen"    on public.weekschema_weeks;

create policy "eigen weken lezen" on public.weekschema_weeks
  for select to authenticated using ((select auth.uid()) = user_id);

create policy "eigen weken toevoegen" on public.weekschema_weeks
  for insert to authenticated with check ((select auth.uid()) = user_id);

create policy "eigen weken wijzigen" on public.weekschema_weeks
  for update to authenticated using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "eigen weken wissen" on public.weekschema_weeks
  for delete to authenticated using ((select auth.uid()) = user_id);

-- Niet-ingelogde bezoekers krijgen geen toegang
revoke all on public.weekschema_weeks from anon;
grant select, insert, update, delete on public.weekschema_weeks to authenticated;

-- updated_at automatisch bijwerken
create or replace function public.weekschema_touch()
returns trigger language plpgsql set search_path = '' as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists weekschema_touch on public.weekschema_weeks;
create trigger weekschema_touch before update on public.weekschema_weeks
  for each row execute function public.weekschema_touch();
