-- Actualización para mensajes editables/borrables
-- Ejecuta este archivo en Supabase > SQL Editor > Run.

alter table public.replies
  add column if not exists owner_token text;

create index if not exists replies_created_at_idx
  on public.replies (created_at);

create index if not exists replies_owner_token_idx
  on public.replies (owner_token);

alter table public.replies enable row level security;

drop policy if exists "replies_public_select" on public.replies;
drop policy if exists "replies_public_insert" on public.replies;
drop policy if exists "replies_public_update" on public.replies;
drop policy if exists "replies_public_delete" on public.replies;

create policy "replies_public_select"
on public.replies
for select to anon, authenticated
using (true);

create policy "replies_public_insert"
on public.replies
for insert to anon, authenticated
with check (true);

create policy "replies_public_update"
on public.replies
for update to anon, authenticated
using (true)
with check (true);

create policy "replies_public_delete"
on public.replies
for delete to anon, authenticated
using (true);


-- Enlaces de YouTube compartidos
create table if not exists public.youtube_links (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  url text not null,
  author text,
  created_at timestamptz not null default now()
);

alter table public.youtube_links enable row level security;
drop policy if exists "youtube_public_select" on public.youtube_links;
drop policy if exists "youtube_public_insert" on public.youtube_links;
drop policy if exists "youtube_public_delete" on public.youtube_links;
create policy "youtube_public_select" on public.youtube_links for select to anon, authenticated using (true);
create policy "youtube_public_insert" on public.youtube_links for insert to anon, authenticated with check (true);
create policy "youtube_public_delete" on public.youtube_links for delete to anon, authenticated using (true);
