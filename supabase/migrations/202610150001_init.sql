-- Ramaca in Chiaro: dati di liquidità riservati all'utente autenticato.
create table if not exists public.transactions (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  source_key text not null,
  occurred_on date,
  value_on date,
  book_month text not null,
  account_name text not null check (account_name in ('UniCredit', 'Banca d''Asti', 'Cassa contanti')),
  description text not null,
  amount numeric(14,2) not null,
  category text not null default 'Da classificare',
  interest numeric(14,2),
  competence text,
  created_at timestamptz not null default now(),
  constraint transactions_owner_source_key unique (owner_id, source_key)
);

create table if not exists public.account_balances (
  owner_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  account_name text not null check (account_name in ('UniCredit', 'Banca d''Asti', 'Cassa contanti')),
  opening_balance numeric(14,2) not null,
  updated_at timestamptz not null default now(),
  primary key (owner_id, account_name)
);

create table if not exists public.forecast_settings (
  owner_id uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  forecast_values jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.transactions enable row level security;
alter table public.account_balances enable row level security;
alter table public.forecast_settings enable row level security;

revoke all on public.transactions, public.account_balances, public.forecast_settings from anon;
grant select, insert, update, delete on public.transactions, public.account_balances, public.forecast_settings to authenticated;

create policy "user owns transactions" on public.transactions
  for all to authenticated
  using (owner_id = (select auth.uid()))
  with check (owner_id = (select auth.uid()));

create policy "user owns account balances" on public.account_balances
  for all to authenticated
  using (owner_id = (select auth.uid()))
  with check (owner_id = (select auth.uid()));

create policy "user owns forecast settings" on public.forecast_settings
  for all to authenticated
  using (owner_id = (select auth.uid()))
  with check (owner_id = (select auth.uid()));
