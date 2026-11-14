-- BALZOUG initial Supabase schema
-- Apply in Supabase SQL Editor only after reviewing and configuring the project.
create extension if not exists pgcrypto;

create type public.app_role as enum ('student', 'college_supervisor', 'admin', 'super_admin');
create type public.account_status as enum ('pending', 'approved', 'rejected', 'suspended');
create type public.contribution_status as enum ('pending', 'approved', 'rejected');

create table public.colleges (
  id uuid primary key default gen_random_uuid(),
  name_ar text not null,
  name_en text,
  created_at timestamptz not null default now()
);

create table public.departments (
  id uuid primary key default gen_random_uuid(),
  college_id uuid not null references public.colleges(id) on delete cascade,
  name_ar text not null,
  name_en text,
  created_at timestamptz not null default now()
);

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  university_number text unique not null,
  full_name text not null,
  college_id uuid references public.colleges(id),
  department_id uuid references public.departments(id),
  study_level text,
  role public.app_role not null default 'student',
  status public.account_status not null default 'pending',
  created_at timestamptz not null default now()
);

create table public.courses (
  id uuid primary key default gen_random_uuid(),
  department_id uuid not null references public.departments(id) on delete cascade,
  study_level text not null,
  name_ar text not null,
  name_en text,
  semester text,
  created_at timestamptz not null default now()
);

create table public.study_files (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses(id) on delete cascade,
  title text not null,
  category text not null check (category in ('lectures','worksheets','summaries','past_exams','books','links')),
  storage_path text,
  external_url text,
  mime_type text,
  uploaded_by uuid references public.profiles(id),
  status public.contribution_status not null default 'pending',
  downloads integer not null default 0,
  created_at timestamptz not null default now(),
  constraint file_location_required check (storage_path is not null or external_url is not null)
);

create table public.file_ratings (
  id uuid primary key default gen_random_uuid(),
  file_id uuid not null references public.study_files(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  rating smallint not null check (rating between 1 and 5),
  updated_at timestamptz not null default now(),
  unique (file_id, user_id)
);

create table public.favorites (
  user_id uuid not null references public.profiles(id) on delete cascade,
  file_id uuid not null references public.study_files(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, file_id)
);

create table public.announcements (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text not null,
  college_id uuid references public.colleges(id),
  published_by uuid references public.profiles(id),
  published_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.lecture_sessions (
  id uuid primary key default gen_random_uuid(),
  college_id uuid not null references public.colleges(id) on delete cascade,
  department_id uuid not null references public.departments(id) on delete cascade,
  course_id uuid not null references public.courses(id) on delete cascade,
  study_level text not null,
  weekday smallint not null check (weekday between 0 and 6),
  starts_at time not null,
  ends_at time not null,
  room text,
  lecturer_name text,
  created_at timestamptz not null default now(),
  check (ends_at > starts_at)
);

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  title text not null,
  body text not null,
  kind text not null,
  read_at timestamptz,
  created_at timestamptz not null default now()
);

-- Enable RLS. Policies must be added after the institution's approval workflow
-- and role-management process are configured. Do not expose tables publicly.
alter table public.colleges enable row level security;
alter table public.departments enable row level security;
alter table public.profiles enable row level security;
alter table public.courses enable row level security;
alter table public.study_files enable row level security;
alter table public.file_ratings enable row level security;
alter table public.favorites enable row level security;
alter table public.announcements enable row level security;
alter table public.lecture_sessions enable row level security;
alter table public.notifications enable row level security;

-- Intentionally no permissive policies are created here. Add reviewed policies
-- before connecting the mobile app; otherwise client access is denied by RLS.
