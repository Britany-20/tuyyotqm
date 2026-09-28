-- Danny ♥ Brithany — configuración pública para la página de pareja
-- Este proyecto usa la clave PUBLICABLE en el HTML. Nunca uses service_role aquí.

create extension if not exists pgcrypto;

create table if not exists public.plans (
  id uuid primary key default gen_random_uuid(),
  text text not null,
  done boolean not null default false,
  author text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.replies (
  id uuid primary key default gen_random_uuid(),
  text text not null,
  author text,
  created_at timestamptz not null default now()
);

create table if not exists public.songs (
  id uuid primary key default gen_random_uuid(),
  title text,
  lyrics text not null,
  author text,
  created_at timestamptz not null default now()
);

alter table public.plans enable row level security;
alter table public.replies enable row level security;
alter table public.songs enable row level security;

drop policy if exists "plans_public_select" on public.plans;
drop policy if exists "plans_public_insert" on public.plans;
drop policy if exists "plans_public_update" on public.plans;
drop policy if exists "plans_public_delete" on public.plans;
create policy "plans_public_select" on public.plans for select to anon, authenticated using (true);
create policy "plans_public_insert" on public.plans for insert to anon, authenticated with check (true);
create policy "plans_public_update" on public.plans for update to anon, authenticated using (true) with check (true);
create policy "plans_public_delete" on public.plans for delete to anon, authenticated using (true);

drop policy if exists "replies_public_select" on public.replies;
drop policy if exists "replies_public_insert" on public.replies;
create policy "replies_public_select" on public.replies for select to anon, authenticated using (true);
create policy "replies_public_insert" on public.replies for insert to anon, authenticated with check (true);

drop policy if exists "songs_public_select" on public.songs;
drop policy if exists "songs_public_insert" on public.songs;
create policy "songs_public_select" on public.songs for select to anon, authenticated using (true);
create policy "songs_public_insert" on public.songs for insert to anon, authenticated with check (true);

-- Bucket público para que las imágenes puedan mostrarse directamente en la página.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'couple-photos',
  'couple-photos',
  true,
  10485760,
  array['image/jpeg','image/png','image/webp','image/gif','image/heic','image/heif']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "couple_photos_public_read" on storage.objects;
drop policy if exists "couple_photos_public_upload" on storage.objects;
drop policy if exists "couple_photos_public_delete" on storage.objects;
create policy "couple_photos_public_read"
on storage.objects for select to anon, authenticated
using (bucket_id = 'couple-photos');

create policy "couple_photos_public_upload"
on storage.objects for insert to anon, authenticated
with check (bucket_id = 'couple-photos');

create policy "couple_photos_public_delete"
on storage.objects for delete to anon, authenticated
using (bucket_id = 'couple-photos');
