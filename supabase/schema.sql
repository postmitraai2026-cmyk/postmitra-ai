-- PostMitra fresh Supabase schema. Run only in the NEW PostMitra Supabase project.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 display_name text,
 role text not null default 'user' check (role in ('user','admin')),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.business_profiles (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 business_name text not null,
 business_category text,
 website_url text,
 logo_url text,
 brand_notes text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.social_posts (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 business_profile_id uuid references public.business_profiles(id) on delete set null,
 headline text not null,
 caption text,
 image_url text,
 platforms text[] not null default '{}',
 status text not null default 'draft' check(status in ('draft','scheduled','publishing','published','failed')),
 scheduled_at timestamptz,
 published_at timestamptz,
 provider_post_ids jsonb not null default '{}'::jsonb,
 last_error text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.social_accounts (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 business_profile_id uuid references public.business_profiles(id) on delete cascade,
 provider text not null check(provider in ('instagram','facebook','google_business')),
 provider_account_id text,
 display_name text,
 connection_status text not null default 'not_connected' check(connection_status in ('not_connected','connected','expired','needs_review')),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.subscriptions (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 plan_code text not null check(plan_code in ('starter_999','pro_1999')),
 amount_inr integer not null check(amount_inr in (999,1999)),
 status text not null default 'pending' check(status in ('pending','active','past_due','cancelled','expired')),
 provider text not null default 'razorpay',
 provider_customer_id text,
 provider_subscription_id text,
 current_period_end timestamptz,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.usage_events (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 event_type text not null check(event_type in ('poster_generation','caption_generation','scheduled_post','ai_reply')),
 units integer not null default 1 check(units > 0),
 metadata jsonb not null default '{}'::jsonb,
 created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.business_profiles enable row level security;
alter table public.social_posts enable row level security;
alter table public.social_accounts enable row level security;
alter table public.subscriptions enable row level security;
alter table public.usage_events enable row level security;

create policy "read own profile" on public.profiles for select to authenticated using(auth.uid()=id);
create policy "update own profile" on public.profiles for update to authenticated using(auth.uid()=id) with check(auth.uid()=id);
create policy "own business rows" on public.business_profiles for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "own post rows" on public.social_posts for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "read own social accounts" on public.social_accounts for select to authenticated using(auth.uid()=user_id);
create policy "read own subscriptions" on public.subscriptions for select to authenticated using(auth.uid()=user_id);
create policy "read own usage" on public.usage_events for select to authenticated using(auth.uid()=user_id);

create index if not exists social_posts_user_schedule_idx on public.social_posts(user_id,status,scheduled_at);
create index if not exists subscriptions_user_status_idx on public.subscriptions(user_id,status);
create index if not exists usage_events_user_date_idx on public.usage_events(user_id,created_at desc);

create or replace function public.handle_new_postmitra_user()
returns trigger language plpgsql security definer set search_path=''
as $$
begin
 insert into public.profiles(id,display_name,role)
 values(new.id,coalesce(new.raw_user_meta_data->>'display_name',''),'user')
 on conflict(id) do nothing;
 return new;
end; $$;
drop trigger if exists postmitra_auth_user_created on auth.users;
create trigger postmitra_auth_user_created after insert on auth.users
for each row execute procedure public.handle_new_postmitra_user();
