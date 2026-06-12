-- Jalankan file ini di Supabase Dashboard -> SQL Editor.
-- Schema ini mempertahankan fitur app saat ini: submit publik, live transparansi,
-- dan download CSV dari client.

create extension if not exists pgcrypto;

create table if not exists public.submissions (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  censored_name text not null default 'Anonim',
  nama text not null default 'Anonim',
  umur text not null,
  jenis_kelamin text not null,
  domisili text not null,
  pendidikan text not null,
  q1 text not null,
  q2 text not null,
  q3 text not null,
  q4 text not null,
  q5 text not null,
  q6 text not null,
  q7 text not null,
  q8 text not null,
  q9 text not null,
  q10 text not null,
  q11 text not null,
  q12 text not null,
  q13 text not null,
  q14 text not null,
  q15 text not null,
  pesan text not null default ''
);

create index if not exists submissions_created_at_idx
  on public.submissions (created_at desc);

alter table public.submissions enable row level security;

drop policy if exists "Public can submit questionnaire" on public.submissions;
create policy "Public can submit questionnaire"
  on public.submissions
  for insert
  to anon
  with check (true);

drop policy if exists "Public can read transparency data" on public.submissions;
create policy "Public can read transparency data"
  on public.submissions
  for select
  to anon
  using (true);

do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'submissions'
  ) then
    alter publication supabase_realtime add table public.submissions;
  end if;
end $$;
