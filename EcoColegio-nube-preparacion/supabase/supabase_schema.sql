-- EcoColegio: esquema inicial para Supabase
-- Ejecutar en SQL Editor después de crear un proyecto Supabase.
-- Las contraseñas NO se guardan en tablas propias; Supabase Auth las gestiona.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  display_name text not null,
  grade text not null default '',
  role text not null check (role in ('admin', 'student')),
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.recycling_records (
  id uuid primary key default gen_random_uuid(),
  student_user_id uuid references public.profiles(user_id) on delete set null,
  student_name text not null default 'Registro general',
  grade text not null default '',
  material text not null,
  quantity_kg numeric(10,2) not null default 0 check (quantity_kg >= 0),
  points integer not null default 0 check (points >= 0),
  record_date date not null default current_date,
  notes text not null default '',
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);

create table if not exists public.environmental_activities (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text not null default '',
  activity_date date,
  grade text not null default '',
  image_url text not null default '',
  published boolean not null default true,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);

create table if not exists public.eco_settings (
  setting_key text primary key,
  setting_value jsonb not null default '{}'::jsonb,
  updated_by uuid references auth.users(id) on delete set null,
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.recycling_records enable row level security;
alter table public.environmental_activities enable row level security;
alter table public.eco_settings enable row level security;

-- Helper: true only for authenticated users with active administrator profile.
create or replace function public.is_eco_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles p
    where p.user_id = auth.uid()
      and p.role = 'admin'
      and p.active = true
  );
$$;

-- Profiles: signed-in users can read basic profile rows for dashboards/rankings.
-- Email/password are not stored here. Account management is server-side only.
drop policy if exists "profiles_select_authenticated" on public.profiles;
create policy "profiles_select_authenticated"
on public.profiles for select to authenticated
using (active = true or public.is_eco_admin());

drop policy if exists "profiles_admin_insert" on public.profiles;
create policy "profiles_admin_insert"
on public.profiles for insert to authenticated
with check (public.is_eco_admin());

drop policy if exists "profiles_admin_update" on public.profiles;
create policy "profiles_admin_update"
on public.profiles for update to authenticated
using (public.is_eco_admin()) with check (public.is_eco_admin());

drop policy if exists "profiles_admin_delete" on public.profiles;
create policy "profiles_admin_delete"
on public.profiles for delete to authenticated
using (public.is_eco_admin());

-- Students can read shared recycling information; only administrators can mutate it.
drop policy if exists "recycling_select_authenticated" on public.recycling_records;
create policy "recycling_select_authenticated"
on public.recycling_records for select to authenticated using (true);

drop policy if exists "recycling_admin_insert" on public.recycling_records;
create policy "recycling_admin_insert"
on public.recycling_records for insert to authenticated
with check (public.is_eco_admin());

drop policy if exists "recycling_admin_update" on public.recycling_records;
create policy "recycling_admin_update"
on public.recycling_records for update to authenticated
using (public.is_eco_admin()) with check (public.is_eco_admin());

drop policy if exists "recycling_admin_delete" on public.recycling_records;
create policy "recycling_admin_delete"
on public.recycling_records for delete to authenticated
using (public.is_eco_admin());

drop policy if exists "activities_select_published" on public.environmental_activities;
create policy "activities_select_published"
on public.environmental_activities for select to authenticated
using (published = true or public.is_eco_admin());

drop policy if exists "activities_admin_insert" on public.environmental_activities;
create policy "activities_admin_insert"
on public.environmental_activities for insert to authenticated
with check (public.is_eco_admin());

drop policy if exists "activities_admin_update" on public.environmental_activities;
create policy "activities_admin_update"
on public.environmental_activities for update to authenticated
using (public.is_eco_admin()) with check (public.is_eco_admin());

drop policy if exists "activities_admin_delete" on public.environmental_activities;
create policy "activities_admin_delete"
on public.environmental_activities for delete to authenticated
using (public.is_eco_admin());

drop policy if exists "settings_select_authenticated" on public.eco_settings;
create policy "settings_select_authenticated"
on public.eco_settings for select to authenticated using (true);

drop policy if exists "settings_admin_insert" on public.eco_settings;
create policy "settings_admin_insert"
on public.eco_settings for insert to authenticated
with check (public.is_eco_admin());

drop policy if exists "settings_admin_update" on public.eco_settings;
create policy "settings_admin_update"
on public.eco_settings for update to authenticated
using (public.is_eco_admin()) with check (public.is_eco_admin());

drop policy if exists "settings_admin_delete" on public.eco_settings;
create policy "settings_admin_delete"
on public.eco_settings for delete to authenticated
using (public.is_eco_admin());

-- Ranking read model: intentionally exposes only display name, grade and total points.
create or replace view public.student_ranking as
select
  p.user_id,
  p.display_name,
  p.grade,
  coalesce(sum(r.points), 0)::bigint as total_points,
  coalesce(sum(r.quantity_kg), 0)::numeric(12,2) as total_kg
from public.profiles p
left join public.recycling_records r on r.student_user_id = p.user_id
where p.role = 'student' and p.active = true
group by p.user_id, p.display_name, p.grade;

grant select on public.student_ranking to authenticated;

-- IMPORTANT:
-- Create the first admin from the Supabase Dashboard / Auth, then insert its
-- profile row as role='admin' using SQL Editor. Never expose the service_role key
-- in HTML, Android assets, GitHub, or client-side code.
